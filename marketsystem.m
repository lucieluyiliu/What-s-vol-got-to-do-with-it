
function out=marketsystem(params,arg,normal)
%This function gives the value of the system of
%equations that must be satisfied by parameters
%of the market portfolio.
%Input: params: a structure containing all parameters
%       arg: a vector containing values
%       of the unknown parameters kappa_1m, A_m(5*1)
%       normal: a logic variable indicating whether jump size in x is
%       normal
if nargin<3
    normal=false;
end

kappa1m=arg(1);
Am=arg(2:end);

e_d=[0;0;0;0;1];


out=[params.theta*log(params.delta)-(1-params.theta)*(params.kappa_c(2)-1)*params.A0-(1-params.theta)*params.kappa_c(1)-log(kappa1m)+(1-kappa1m)*Am'*params.EY+fapdx(params,e_d+kappa1m*Am-params.Lambda,normal);
gapdx(params,e_d+kappa1m*Am-params.Lambda,normal)+(1-params.theta)*params.Ac-Am];

end