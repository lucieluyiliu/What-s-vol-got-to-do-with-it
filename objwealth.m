function out=objwealth(params,arg,normal)
%%This is the objective function used to solve 
%the wealth portfolio by minimizing the distance between the
%equation system to zero.

%Input: pram:structure containing all parameters
%       arg: vector of unknowns kappa_1c,A_x,A_sigmabar,A_sigma
%        normal: logic indicating whether jump in x is normal
%output: sum of squared distances of system of equations from 0

if nargin<3
    normal=false;
end

e_c=[1;0;0;0;0];
kappa1=arg(1);
A=[0;arg(2:end);0];
  theta=params.theta;
  delta=params.delta;
  psi=params.psi;
  EY=params.EY;

 eqn1=theta*log(delta)+theta*(-log(kappa1)+(1-kappa1)*A'*EY)+fapdx(params,theta*(1-1/psi)*e_c+theta*kappa1*A,normal);
 eqn2=gapdx(params,theta*(1-1/psi)*e_c+theta*kappa1*A,normal)-A*theta; 
 %calculate sum of squared distances
 out=1e6*(eqn1^2+sumsqr(eqn2));
end


