function CylCoors=cart2cyl(x,y,z,RoundingVector,Shift)
%CylCoors=cart2cyl(x,y,z,RoundingVector)
% Transform carthesian coordinates into cylindrical coordinates. x,y, and z must be row vectors 
% of the same length. The optional input RoundingVector is a vector with the number decimals to
% round in each coordinate [theta,r,z] (usefull for adjusting the quality
% and number of points). The Optional input Shift is set to false for a raw
% (no Shift) coordinate convertion.

display('Transforming into Cylinder Coordinates')

 tic

if nargin<5
   Shift=true;
end

if Shift 
    x=x-min(x)-(max(x)-min(x))/2;
    y=y-min(y)-(max(y)-min(y))/2;
end

%Transform coordinates
theta=mod(atan2(y(:), x(:))+2*pi,2*pi);
r=sqrt(x.*x+y.*y);

%Round Outputs
if nargin>3
    
    RoundFactorTheta=10^RoundingVector(1);
    RoundFactorR=10^RoundingVector(2);
    RoundFactorZ=10^RoundingVector(3);
    
    theta=round(RoundFactorTheta*rad2deg(theta(:,1)))/RoundFactorTheta;
    r=round(RoundFactorR*r(:,1))/RoundFactorR;
    z=round(RoundFactorR*z(:,1))/RoundFactorZ;
    
end

%Output
CylCoors=[theta,r,z];

toc

end

