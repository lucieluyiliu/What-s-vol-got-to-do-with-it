
function out=objective(params, arg,normal)
%This is the objective function used to calculate kappa_1m 
%by minimizing the distance between the
%equation system and zero.
%Input: params: structure carrying all parameters
%       arg: a vector of unknown parameters kappa_1m, A_x, A_sigmabar,A_sigma
%       normal: logic indicating whether jump size in x is normal 
if nargin<3
    normal=false;
end

theta=params.theta;
delta=params.delta;
Lambda=params.Lambda;
A0=params.A0;
A=params.Ac;
kappa_c = params.kappa_c;

e_d=[0;0;0;0;1];
EY=params.EY;


%read unknwon parameters as arguments in the minimization program
Am =  [0;arg(2:end);0]; 
kappa1m = arg(1);

eqn1=theta*log(delta)-(1-theta)*(kappa_c(2)-1)*A0-(1-theta)*kappa_c(1)-log(kappa1m)+(1-kappa1m)*Am'*EY+fapdx(params,e_d+kappa1m*Am-Lambda,normal);
eqn2=gapdx(params,e_d+kappa1m*Am-Lambda,normal)+(1-theta)*A-Am;
%sum of squared distance for the system of equations from 0clc
out=1e6*(eqn1^2+sumsqr(eqn2));

end
