
function  out=MGFpsi2(gammadist,u,normal)
%This function calculates the vector of second-order derivatives of the moment generating 
%functions of the jump size distributions.

%Input: u: a 5*1 vector
%       normal: logical indicating whether jump size in x is normal
%       gammadist: structure of gamma distribution parameters
%Output: A vector of second-order derivatives of the moment 
%generating functions of each jump size distribution 
%in the state vector evaluated at each element in u.

%Since c, sigmabar, d do not have jump innovations, their jump size is 0, 
%and the corresponding derivatives are 0
%The derivatives of the moment generating function for xi_x and xi_sigma
%are provided in a separate note.
if nargin<3
normal=false;
end
out=zeros(5,1);
if normal==false
    [mu_x,nu_x,mu_sigma,nu_sigma]=deal(gammadist.mu_x,gammadist.nu_x,gammadist.mu_sigma,gammadist.nu_sigma);

out(2)=mu_x^2*(1+nu_x)*(1+mu_x/nu_x*u(2))^(-2-nu_x)*exp(mu_x*u(2))/nu_x...
    -2*mu_x^2*(1+mu_x/nu_x*u(2))^(-1-nu_x)*exp(mu_x*u(2))+mu_x^2*(1+mu_x/nu_x*u(2))^(-nu_x)*exp(mu_x*u(2));
else
    [sigma_x,mu_sigma,nu_sigma]=deal(gammadist.mu_x,gammadist.mu_sigma,gammadist.nu_sigma);
    out(2)=sigma_x^2*exp(sigma_x^2*u(2)^2/2)+sigma_x^4*u(2)^2 *exp(sigma_x^2*u(2)^2/2);

end
out(4)=mu_sigma^2*(1+nu_sigma)*(1-mu_sigma/nu_sigma*u(4))^(-2-nu_sigma)/nu_sigma;

end