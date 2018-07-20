function SurfaceMask=OnionCheat(Mask1,LayerWidth,Method) 
% SurfaceMask=OnionCheat(Mask1,LayerRadius,Method) 
%Erodes LayerRadius pixels/voxels from Mask1 and returns the difference,
%which resembles an onion layer.
%Default method performs a 2D erosion plane by plane.
%Optional input 'Method' is set to '3D' to perform a 3D erosion, which is
%dramatically (!!!) slower but 3D consistent and vectorized (i.e. perfoms well in
% multiple threads).

if nargin<3
    Method='2D';
end

display('Eroding Mask Surface')
tic


if strcmp(Method,'3D')
    % 3D erosion
    [xx,yy,zz] = ndgrid(-LayerWidth:LayerWidth); % Create 3D Kernel
    Kernel = sqrt(xx.^2 + yy.^2 + zz.^2) <= LayerWidth;
   
    Mask2=imerode(Mask1,Kernel);
    SurfaceMask=Mask1&~Mask2;

else
    % 2D erosion    
    Kernel = strel('disk',LayerWidth);
    SurfaceMask=false(size(Mask1));
 
    parfor ii=1:size(Mask1,3)
        Image=Mask1(:,:,ii);
        Image2=imerode(Image,Kernel);       
        SurfaceMask(:,:,ii)=Image&(~Image2);
    end

end
toc


end