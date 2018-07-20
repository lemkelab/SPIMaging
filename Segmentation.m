function Mask=Segmentation(Stack,Threshold,BiLayer,Method)
%(Stack,Threshold,BiLayer,Method)
% Segment an image stack Stack in exactly two components: subject and background.
% If segmentation returns more than one subject, or holes in subject, all but
% the largest subjects are eliminated, holes are filled.
% Set optional input 'Method' to '3D' to perform 3D morph. ops., which are
% dramatically (!!!) slower but 3D consistent and vectorized (i.e. perfom well in
% multiple threads). 'Pseudo3D' performs 2D morph. ops. along two
% differnt axes.

display('Segmenting Image Components')
tic

if nargin<3
    Method='2D';
    BiLayer=0;
end

if nargin<4
    Method='2D';
end


Mask=false(size(Stack,1),size(Stack,2),size(Stack,3));

if strcmp(Method,'3D') % 3D Segmentation
    
    %create 3D kernel
    LayerRadius=3;
    [xx,yy,zz] = ndgrid(-LayerRadius:LayerRadius);
    Kernel = sqrt(xx.^2 + yy.^2 + zz.^2) <= LayerRadius;
    
    %segmentation
    Stack=imclose(Stack,Kernel);
    Mask=Stack>Threshold;
    
    % filter objects other than largest
    Comps=regionprops(Mask,'Area');
    CompArea=sort([Comps.Area]);
    
    if length(CompArea)>1 
        Mask=bwareaopen(Mask,CompArea(end));
    end
    
    % fill holes
    Mask=~Mask;
    
    Comps=regionprops(Mask,'Area');
    CompArea=sort([Comps.Area]);
    
    if length(CompArea)>1
        Mask=bwareaopen(Mask,CompArea(end));
    end
    
    Mask=~Mask;
    
    % second layer
    if BiLayer
        [xx,yy,zz] = ndgrid(-8:8);
        Kernel2 = sqrt(xx.^2 + yy.^2 + zz.^2) <= 8;
        Mask=imdilate(Mask,Kernel2);
    end
    
    
elseif strcmp(Method,'Pseudo3D') %2D segmentation in 2 different axes
    
    Kernel=strel('disk',5);
    
    %Segmentation for first axis
    for ii=1:size(Stack,3)
        
        Image=imclose(Stack(:,:,ii),Kernel);
        
        Image=Image>Threshold;
        
        Comps=regionprops(Image,'Area');
        CompArea=sort([Comps.Area]);
        
        if length(CompArea)>1
            Image=bwareaopen(Image,CompArea(end));
        end
        
        Image=~Image;
        
        Comps=regionprops(Image,'Area');
        CompArea=sort([Comps.Area]);
        
        if length(CompArea)>1
            Image=bwareaopen(Image,CompArea(end));
        end
        
        Mask(:,:,ii)=~Image;
        
    end
    
    Mask=StackReshaper(Mask,2);
    MaskAlt=Mask;
    
    %Segmentation for second axis
    for ii=1:size(Mask,3)
        
        Image=MaskAlt(:,:,ii);
        
        Comps=regionprops(Image,'Area');
        CompArea=sort([Comps.Area]);
        
        if length(CompArea)>1
            Image=bwareaopen(Image,CompArea(end));
        end
        
        Image=~Image;
        
        Comps=regionprops(Image,'Area');
        CompArea=sort([Comps.Area]);
        
        if length(CompArea)>1
            Image=bwareaopen(Image,CompArea(end));
        end
        
        if BiLayer
            Kernel2=strel('disk',8); % Kernel for layer erosion
            Image=imdilate(Image,Kernel2);
        end
        
        Mask(:,:,ii)=~Image;
        
    end
    
    Mask=StackReshaper(Mask,1);

else % 2D segmentation
    Kernel=strel('disk',40);
    
    parfor ii=1:size(Stack,3) 
        
        Image=imclose(Stack(:,:,ii),Kernel);
        Image=Image>Threshold;
        
        % filter objects other than largest
        Comps=regionprops(Image,'Area');
        CompArea=sort([Comps.Area]);
        
        if length(CompArea)>1
            Image=bwareaopen(Image,CompArea(end-1)+1);
        end
        
        % fill holes
        Image=~Image;
        Comps=regionprops(Image,'Area');
        CompArea=sort([Comps.Area]);
        
        if length(CompArea)>1
            Image=bwareaopen(Image,CompArea(end-1)+1);
        end
        
        
        if BiLayer
            Kernel2=strel('disk',8); % Kernel for layer erosion
            Image=imdilate(Image,Kernel2);
        end
        
        Mask(:,:,ii)=~Image;
        % Unused alternatives:
        %         if sum(~Image(:))>numel(Image)/20
        %             Mask(:,:,ii)=activecontour(Stack(:,:,ii),~Image);
        %         else
        %             Mask(:,:,ii)=~Image;
        %         end
        %
        %         if sum(~Image(:))>numel(Image)/20
        %             Mask(:,:,ii)=imsegfmm(Stack(:,:,ii),~Image,0.05);
        %         else
        %             Mask(:,:,ii)=~Image;
        %         end
    end
end
toc

end