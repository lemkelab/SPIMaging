function [CovarainceMat,EigenVectors,EigenValues]=CovMat3D(PointCloud)
%[CovMat,EigenVectors,EigenValues]=CovarianceMat(PointCloud)
%Calculate the covariance matrix CovMat of a point cloud PointCloud, and the orientation  
%(EigenVectors) and magnitude (EigenValues) of the main axes .

    tic
    display('Calculating Point Cloud Orientation')

    % Calculate the covariance matrix
    
     CovarainceMat=cov(PointCloud(:,1:3));
    
    % Calculate EiVal
    
	[EigenVectors,EigenValues]=eigs(CovarainceMat,3,'SM');
    
    toc
    
end