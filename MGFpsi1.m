function out=MGFpsi1(gammadist,u,normal)
%This function calculates the vector of first-order derivatives of the moment generating 
%functions of the jump size distributions.

%Input:  u a 5*1 vector
%        gammadist: a structure containing gammadistribution parameters
%        normal: logic indicating whether jump in x is normal

%Output: A vector of first order derivatives of the moment 
%generating functions of each jump size distribution 
%in the state vector evaluated at each element in u.


%Since c, sigmabar, d do not have jump innovations, their jump size is 0, 
%and the corresponding derivatives are 0
%The second-order derivatives of the moment generating function for xi_x and xi_sigma
%are provided in a separate note.
if nargin<3
normal=false;
end
if normal==false
  [mu_x, nu_x, mu_sigma, nu_sigma] = deal(gammadist.mu_x, gammadist.nu_x, gammadist.mu_sigma, gammadist.nu_sigma);

out=zeros(5,1);
out(2)=-mu_x*(1+mu_x/nu_x*u(2))^(1-nu_x)*exp(mu_x*u(2))+mu_x*(1+mu_x/nu_x*u(2))^(-nu_x)*exp(mu_x*u(2));
else
    [sigma_x,mu_sigma,nu_sigma]=deal(gammadist.mu_x,gammadist.mu_sigma,gammadist.nu_sigma);
    
    out=zeros(5,1);
  out(2)=sigma_x^2*exp(sigma_x^2*u(2)^2/2)*u(2);
end
out(4)=mu_sigma*(1-mu_sigma/nu_sigma*u(4))^(-1-nu_sigma);
end
