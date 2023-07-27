
function out=fapdx(params,u,normal)
%this is the f function in the appendix(p.39).
%Input: params, a structure containing all parameters
%normal: an indicator function indicating whether 
%jump size in x is normal
%u: a five by one vector
%Output: value of f.
if nargin<3
    normal=false;
end
h=params.h;
mu_tilde=params.mu_tilde;
out=mu_tilde'*u+0.5*u'*h*u+params.l0'*(MGFpsi(params.gammadist,u,normal)-1); % the paper implicitly assumes l0=0 hence the third term vanishes.
end
