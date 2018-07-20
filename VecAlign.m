function RotMat=VecAlign(Vec1,DirVec)
%RotMat=VecAlign(Vec1,DirVec)
%Calculates a 3x3 rotation matrix RotMat that aligns Vec1 to DirVec. 

% Calculate RotMat
    Vec1=Vec1./norm(Vec1);
    V=cross(Vec1,DirVec); 
    S=norm(V);
    C=dot(Vec1,DirVec);
    VMat=[0,-V(3),V(2)
          V(3),0,-V(1)
         -V(2),V(1),0];    
    
    RotMat=eye(3)+VMat+VMat^2*((1-C)/S^2);
    
 