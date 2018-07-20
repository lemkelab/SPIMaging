function [Image,IndexMap]=CylProjector(CylCoors, PointValues, MapValue)
%[Image,IndexMap]=CylProjector(CylCoors, PointValues,Plotting)
% Projects the surface texture of a 3D model [CylCoors, PointValues] into
% the plane Image. The projection takes cylindrical coordinates and assumes
% the main axis of the model is centered in the Z axis.
% The optional output IndexMap maps the components of CylCoors projected 
% into each pixel of Image (or something else ;D).

    if nargin<3
        MapValue='Index';
    end
    
    display('Projecting Point Values')

    tic
    % Retrive unique values in two dimentions.
    [UniqueTheta, ~, SubsTheta]=unique(CylCoors(:,1));
    [UniqueH,~,SubsH]=unique(CylCoors(:,3));
    ImageSize = [numel(UniqueH), numel(UniqueTheta)];
    
    % Project values of third dimention into 2D manifold
    Image=accumarray([SubsH, SubsTheta], PointValues, ImageSize, @max, uint16(0));
    
    % For optional mapping 
    if nargout>1 && strcmp(MapValue,'Index')
        
        IndexMap=accumarray([SubsH, SubsTheta], 1:size(CylCoors,1), ImageSize, @(x) {x});
    
    elseif nargout>1 && strcmp(MapValue,'Radius') 
     
        Radi=CylCoors(:,2);
        IndexMap=accumarray([SubsH, SubsTheta], Radi, ImageSize, @max, NaN);
        
    end

    
    
    toc


    end