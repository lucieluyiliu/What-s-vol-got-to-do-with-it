function out=gapdx(params,u,normal)
%this is the g function in the appendix(p.39).
%Input: params: a structure containing all parameters
%u: a five by one vector
%normal: an logical variable indicating whether 
%jump size in x is normal
if nargin<3
    normal=false;
end

F=params.F;
H_sigma=params.H_sigma;
l1=params.l1;
%mu_x=params.mu_x;
%nu_x=params.nu_x;
%mu_sigma=params.mu_sigma;
%nu_sigma=params.mu_sigma;
%since the covariance matrix of the Brownian innovation only depends on
%sigma^2, there is only one H matrix in the uHu vector in A.1.4
uHu=[0;0;0;u'*params.H_sigma*u;0];
%Although model is calibrated using the compensated tilde dynamics (transformed dynamics in which the jump innovations are demeaned),  
%The solution method in Appendix A.1 uses the orginal process parameters.

%The vector of moment generating functions of the jump sizes, used in the definition of g(u)

out=params.F'*u+0.5*uHu+params.l1'*(MGFpsi(params.gammadist,u,normal)-1);

end
