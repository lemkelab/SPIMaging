function [RotatedPointCloud,RotMat] = PCRotator(PCCoors,Angle,Axis)
%[RotatedPointCloud,RotMat] = PCRotator(PCCoors,Angle,Axis)
% Rotates a pointcloud PointCloud Angle radians in Axis direction.
% Axis= 1 equals X-axis, =2 Y-axis, =3 Z-axis.

switch Axis
    
    case 1
        
        RotMat=[1,0,0;
                0,cos(Angle),-sin(Angle);
                0,sin(Angle),cos(Angle)];
        
    case 2
        
        RotMat=[cos(Angle),0,sin(Angle);
                0,1,0;
                -sin(Angle),0,cos(Angle)];
        
    case 3
        
        RotMat=[cos(Angle),-sin(Angle),0;
                sin(Angle),cos(Angle),0;
                0,0,1];
        
end
        
    RotatedPointCloud=PCCoors*RotMat;

end

