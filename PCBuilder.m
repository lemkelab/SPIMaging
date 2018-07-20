function [PointCoors,PointValues,AltValues]=PCBuilder(Stack,Mask,Subsampling,Type,Stack2)
%[PointCoors,PointValues]=PCBuilder(Stack,Mask,Subsampling,Type,Stack2)
% Uses the images in a stack Stack to build a pointcloud as an xyz-array of
% point coodinates PointCoors, and an array with intensity values 
% corresponding to each point PointValues.
% Optional input Mask is a stack of binary images the same size as Stack 
% with masked points. 
% Optional input Subsampling takes 1/Subsampling of the
% points in Stack (default 1: no subsampling).
% Set optional input Type to "Single" if RAM is a consideration (default: double)
% Optional input Stack2 is the same size as Stack. It's values are mapped
% into AltValues.

tic

if nargin<2
    Mask=true(size(Stack));
    Subsampling=1;
    Type='Double';
elseif nargin<3
    Subsampling=1;
    Type='Double';
elseif nargin<4
    Type='Double';
end


display('Generating PointCloud')
tic

% Create point coordiantes of unmasked image segments.

% PointCloud=zeros(numel(find(Mask==1),4));
% CurrentPoint=0;
% 
%     for x=1:size(Stack,1)
%         for y=1:size(Stack,2)
%             for z=1:size(Stack,3)
%                 
%                 if Mask(x,y,z)==1;
%                     
%                     CurrentPoint=CurrentPoint+1;
%                     
%                     PointCloud(CurrentPoint,:)=[x,y,z,Stack(x,y,z)];
%                 
%                 end   
%             end 
%         end
%     end
% toc

switch Type %same as above but vectorized
    case 'Single' 
        [x,y,z]=ind2sub(size(Mask),find(Mask~=false));
        x=single(x);y=single(y);z=single(z);
  
    otherwise % double
        [x,y,z]=ind2sub(size(Mask),find(Mask~=false));
end

% Assign intensity values.
PointValues=Stack(sub2ind(size(Stack),x,y,z));
if nargin>4
   AltValues=Stack2(sub2ind(size(Stack),x,y,z)); 
else
   AltValues=false;
end

% Subsample Output.
PointCoors=[x(1:Subsampling:end),y(1:Subsampling:end),z(1:Subsampling:end)];
PointValues=PointValues(1:Subsampling:end);
AltValues=AltValues(1:Subsampling:end);

toc

end