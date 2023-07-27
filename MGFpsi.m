
function out=MGFpsi(gammadist,u,normal)
%This function calculates the vector of moment generating functions
% of the jump size distributions evaluated at each element of u

%Input: u: a five by one vector
%       gammadist: a structure containing gamma distribution parameters
        %normal: logic variable indicating whether jump size in x is normal

%Output: the moment 
%generating functions of each jump size distribution evaluated at 
%the corresponding element of u.

%Since c, sigmabar, d do not have jump innovations, their jump size is 0, 
%and the corresponding element in the moment generating vector is 1 (or any constant)
%The derivation of the moment generating function for xi_x and xi_sigma
%is provided in a separate note.
if nargin<3
    normal=false;
end
if normal==false
    [mu_x,nu_x,mu_sigma,nu_sigma]=deal(gammadist.mu_x,gammadist.nu_x,gammadist.mu_sigma,gammadist.nu_sigma);
 out=[1;(1+mu_x*u(2)/nu_x)^(-nu_x)*exp(mu_x*u(2));1;(1-mu_sigma/nu_sigma*u(4))^(-nu_sigma);1];
else
    %if the jump size in x is normal
    [sigma_x,mu_sigma,nu_sigma]=deal(gammadist.mu_x,gammadist.mu_sigma,gammadist.nu_sigma);

  out=[1;exp(sigma_x^2*u(2)^2/2);1;(1-mu_sigma/nu_sigma*u(4))^(-nu_sigma);1];
end
end
