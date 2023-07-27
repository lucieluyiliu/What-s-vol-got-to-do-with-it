
function out=wealthsystem(params,arg,normal)
%this function gives a system of equation 
%that the parameters of the wealth portfolio
%need to satisfy
%input: params: structure carrying all parameters
%       normal: logic indicating whether jump size in x is normal
%       arg: a vector of unknown parameters kappa_1c and Ac
%output: the system of nonlinear equations
if nargin<3
    normal=false;
end
kappa1=arg(1);
A=arg(2:end);
%A=[0;arg(2:end);0];
e_c=[1;0;0;0;0];
out=[params.theta*log(params.delta)+params.theta*(-log(kappa1)+(1-kappa1)*A'*params.EY)+fapdx(params,params.theta*(1-1/params.psi)*e_c+params.theta*kappa1*A,normal);
gapdx(params,params.theta*(1-1/params.psi)*e_c+params.theta*kappa1*A,normal)-A*params.theta];
end