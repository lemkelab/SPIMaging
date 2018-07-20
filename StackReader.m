function [Stack,Info]=StackReader(StackFile,Subsampling,HDF5Group)
%[Stack,Info]=StackReader(StackFile,Subsampling,HDF5Group)
%Read the .tif or .h5 stack in StackFile and generate Stack. 
%Optional input Subsampling (default = 1)
%Optional input HDF5Group only relevant for HDF5 data (default = '/Data')

display('Reading Image Stack')

if ~isempty(strfind(StackFile,'.h5')) % read hdf5 
    tic
    Info=h5info(StackFile);
    if nargin<3
        HDF5Group='/Data';
    end
    
    Stack=h5read(StackFile,HDF5Group);
    if nargin>1
        Stack=Stack(1:Subsampling:end,1:Subsampling:end,1:Subsampling:end);
    end
    toc
else % else read .tiff

    tic

    if nargin<2
        Subsampling=1;
    end

    Info=imfinfo(StackFile);
    mImage=Info(1).Width;
    nImage=Info(1).Height;
    NumberImages=length(Info);
    BDepth=Info(1).BitDepth;

    switch BDepth
        case 8
            TStack=zeros(nImage,mImage,NumberImages,'uint8');
        case 16
            TStack=zeros(nImage,mImage,NumberImages,'uint16');
        otherwise
            TStack=zeros(nImage,mImage,NumberImages);

    end

    TifLink = Tiff(StackFile, 'r');

    for j=1:NumberImages
        TifLink.setDirectory(j);
        TStack(:,:,j)=uint16(TifLink.read());
    end
    TifLink.close();

    if Subsampling>1

       TStack=TStack(1:Subsampling:end, 1:Subsampling:end,1:Subsampling:end); 

    end

    %Swap coordinates axes=>Z (not X) now main axis
    switch BDepth
        case 8  % Coors are not swaped in 8bit... based on usecase
            Stack=TStack;%zeros(size(TStack,3),... 
                  %      size(TStack,1),...
                  %      size(TStack,2),'uint8');
        case 16
            Stack=zeros(size(TStack,3),...
                        size(TStack,1),...
                        size(TStack,2),'uint16');

            for ii=1:size(TStack,3) %Transform to double stack
                Stack(ii,:,:)=TStack(:,:,ii); %Swap coordinates axes=>Z (not X) now main axis
            end           
    end
    toc

end

end