% This script is the main program that runs the calibration of 
%'What's Vol got to do with it?' Drechsler and Yaron 2011
clc;
clear all;
%****************************************************
%  0.parameter innitialization (p.27 Table and text)*
%****************************************************

%0.l Preference parameters
params.delta=0.999; %time preference
params.gamma=9.5 ; %risk aversion
params.psi=2;      %EIS
params.theta=(1-params.gamma)/(1-1/params.psi);
 
%0.2 State dynamics
%The state vector includes Delta_c, x,sigma^2bar, sigma^2, Delta_d
%calibration of the VAR system specifies the unconditional mean
%model is calibrated for the compensated (tilde) dynamics

%VAR coefficients
params.rho_x=0.976;
params.rho_sigmabar=0.985;
params.rho_sigmatilde=0.87;
params.phi=2.5; %dividend leverage

%initialize the VAR dynamics
n=5;%number of state variables

%calibrate the unconditional mean
params.EDc=0.0016;
params.Esigma2=1;
params.EDd=0.0016; 
params.EY=[params.EDc;params.EDc;params.Esigma2;params.Esigma2;params.EDd];
%why they set the unconditional mean of 
%dividend growth to the same as consumption growth although dividend
%is a leveraged claim to the consumption flow. 
%This results in dividend having a negative drift



params.F_tilde=[0, 1,    0,                0,             0;
   0, params.rho_x,0,                0,             0;
   0, 0,    params.rho_sigmabar,     0,             0;
   0, 0,    (1-params.rho_sigmatilde),params.rho_sigmatilde,0;
   0, params.phi,  0,                0,             0];



%Gaussian covariance matrix(p.26)
%weight of conditional volatility
omega_c=0.5;
omega_x=1;
omega_sigmabar=0;
omega_sigma=1;
omega_d=0.125;
params.omega=[omega_c;omega_x;omega_sigmabar;omega_sigma;omega_d];

%scaling factors
fi_c=0.0066;
fi_x=0.032*fi_c;
fi_sigmabar=0.1;
fi_sigma=0.35;
fi_d=5.7*fi_c;
params.fi=[fi_c;fi_x;fi_sigmabar;fi_sigma;fi_d];

%correlation matrix only allow correlation between delta_c and delta_d
Omega_cd=0.2;
params.Omega=[1,   0, 0, 0, Omega_cd;
       0,   1, 0, 0, 0;   
       0,   0, 1, 0, 0;
       0,   0, 0, 1, 0;
       Omega_cd, 0, 0, 0, 1];


%Jump intensity parameters
%The paper simply sets l_0=0 without explicitly specifying 
%But since they shut down jumps by setting l1=0, then  it must be the case that l0=0 

params.l1_x=0.8/12;
params.l1_sigma=0.8/12;
params.l1_x=0.8/12;
params.l1_sigma=0.8/12;

%for comparative statics
%uncomment to get alternative model A-C in Table 14
%  params.l1_x=0;
%  params.l1_sigma=0;

params.l1=[0;params.l1_x;0;params.l1_sigma;0]; %stack into a vector for convenience of later operations

%Parameterize jump size gamma distributions

params.gammadist.nu_x=1;

params.gammadist.mu_x=3.645*fi_x;

params.gammadist.nu_sigma=1;

params.gammadist.mu_sigma=2.55;

params.l0=zeros(5,1);

%back out drift from unconditonal mean

params.mu_tilde=(eye(n)-params.F_tilde)*params.EY;
%to implement the numerical solution method (appendix A.1)
%infer original dynamics from the compensated (tilde) dynamics (p.25).  
%page 25 right below eqn(24)
%since l_0=0, mu and mu_tilde are the same
%expectation of jump size
Exi=[0;0;0;params.gammadist.mu_sigma;0]; % by properties of Gamma distribution 

params.F=params.F_tilde-diag(MGFpsi1(params.gammadist, zeros(5,1)))*params.l1;

%%
%**************************************************
% 1. Model solution and Asset pricing implications*
%**************************************************
%Solving the model numerically before simulation since I need to 
%calculate asset returns within the simulation loop.

%------------------------
%1.1 Wealth portfolio
%------------------------
%need f and g functions as defined in p.39
%involve moment generating functions of the jump size distribution and H matrices
%p.26
params.H_sigma=diag(params.fi.*sqrt(params.omega))*params.Omega*diag(params.fi.*sqrt(params.omega))';
%since covariance matrix only depends on sigma^2, all other H matrics are
%zero (p.11).

params.h=diag(params.fi.*sqrt(1-params.omega))*params.Omega*diag(params.fi.*sqrt(1-params.omega))';
%selection vector for consumption growth and dividend growth
e_c=[1;0;0;0;0];
e_d=[0;0;0;0;1];


%Solve for kappa and As (A.2)

%two methods
%1.solving without imposing model implied restrictions (fsolve or vpasolve)
%default method
%-----------uncomment to try this method-------- 
 svalues=[0.9;0;0;0;0;0];
 temp=fsolve(@(arg)wealthsystem(params,arg),svalues);
 options=optimoptions(@fsolve,'Display','off','FunctionTolerance',1e-4,'Algorithm','levenberg-marquardt');
 params.Ac=temp(2:end);
 params.kappa_c(2)=temp(1);
 params.kappa_c(1)=-params.kappa_c(2)*log(params.kappa_c(2))-(1-params.kappa_c(2))*log(1-params.kappa_c(2));
params.A0=log(params.kappa_c(2))-log(1-params.kappa_c(2))-params.Ac'*params.EY;
%-----------------------------------------------
%2.impose A_c=A_d=0 and A_sigma<0, A_sigmabar<0

%   -does not satisfy the equations perfectly

%--------uncomment to try this method-------------
%   svalues=zeros(4,1);
%   lb = -20*ones(n-1,1);
%   ub = 20*ones(n-1,1);
%   svalues(1) = 0.90; % Better starting value
%   lb(1) = 0.0;
%   ub(1) = 1.0;
%   %ub(4:5)=0;
%   [unknowns,fval,exit,output] = fmincon(@(arg)objwealth(params,arg), svalues, [], [], [], [], lb, ub);
%   params.kappa_c(2)=unknowns(1);
%   params.Ac=[0;unknowns(2:end);0];
% 
% %Calculate kappa_0 and A_0 using eqn A2.2 and A2.1
% params.kappa_c(1)=-params.kappa_c(2)*log(params.kappa_c(2))-(1-params.kappa_c(2))*log(1-params.kappa_c(2));
% params.A0=log(params.kappa_c(2))-log(1-params.kappa_c(2))-params.Ac'*params.EY;
%--------------------------------------------------

%Market price of risk (p.13)
params.Lambda=params.gamma*e_c+(1-params.theta)*params.kappa_c(2)*params.Ac;
%Risk free rate parameters
params.r_f0=-params.theta*log(params.delta)+(1-params.theta)*(params.kappa_c(1)+(params.kappa_c(2)-1)*params.A0)-fapdx(params,-params.Lambda);
params.rf_coef=-(gapdx(params, -params.Lambda)-(params.theta-1)*params.Ac);

%-----------------------------
%1.2 market portfolio
%-----------------------------
%two methods
%1.without any model implied restrictions, symbolic solver vpasolve
%(default method)
%--------uncomment to try this method--------------
 syms kappa1m;
 syms A_mc A_mx A_msigmabar A_msigma A_md;

 syms m_solver1(kappa1m,A_mc,A_mx,A_msigmabar,A_msigma, A_md);
 syms m_solver2(kappa1m,A_mc,A_mx,A_msigmabar,A_msigma, A_md);
 syms m_solver1(Ezm,A_mc,A_mx,A_msigmabar,A_msigma, A_md); 
 
 m_solver1(kappa1m,A_mc,A_mx,A_msigmabar,A_msigma, A_md)=params.theta*log(params.delta)-(1-params.theta)*(params.kappa_c(2)-1)*params.A0-(1-params.theta)*params.kappa_c(1)-log(kappa1m)+(1-kappa1m)*[A_mc;A_mx;A_msigmabar;A_msigma;A_md]'*params.EY+fapdx(params,e_d+kappa1m*[A_mc;A_mx;A_msigmabar;A_msigma;A_md]-params.Lambda);
 m_solver2(kappa1m,A_mc,A_mx,A_msigmabar,A_msigma, A_md)=gapdx(params,e_d+kappa1m*[A_mc;A_mx;A_msigmabar;A_msigma;A_md]-params.Lambda)+(1-params.theta)*params.Ac-[A_mc;A_mx;A_msigmabar;A_msigma;A_md];

 temp=vpasolve([m_solver1==0,m_solver2==0],[kappa1m,A_mc,A_mx,A_msigmabar,A_msigma, A_md],[[0,1];[-inf,inf];[-inf,inf];[-inf,inf];[-inf,inf];[-inf,inf]]);
 params.kappa_m(2)=double(temp.kappa1m);
 params.Am=double([temp.A_mc;temp.A_mx;temp.A_msigmabar;temp.A_msigma;temp.A_md]);
% Calaulate A_m0 and kappa_m0
 params.kappa_m(1)=-params.kappa_m(2)*log(params.kappa_m(2))-(1-params.kappa_m(2))*log(1-params.kappa_m(2));
 params.Am0=log(params.kappa_m(2))-log(1-params.kappa_m(2))-params.Am'*params.EY;

%-----------------------------------------------------
%Or fsolve, but fsolve works very badly in this case
%-----------uncomment to see----------------------------------
% options=optimset('MaxFunEvals',1e6,'MaxIter',1e7,'tolFun',1e-6);
% svalues=[0.9;0;0;0;0;0];
% temp=fsolve(@(arg)marketsystem(params,arg),svalues,options);
% params.kappa_m(2)=temp(1);
% params.Am=temp(2:end);
%---------------------------------------
%2.impose model-implied restrictions Am_c=Am_d=0,kappa_1m<1
%solve numerically using fmincon
%resulting market return is nonsensibly high
%-----------uncomment to see--------------------------
%   svalues=zeros(4,1);
%   lb = -50*ones(n-1,1);
%   ub = 50*ones(n-1,1);
%   svalues(1) = 0.90; % Better starting value
%   lb(1) = 0.0;
%   ub(1) = 1.0;
%   %ub(end-1:end)=0;
%   [unknowns,fval,exit,output] = fmincon(@(arg)objective(params,arg), svalues, [], [], [], [], lb, ub);
%   params.kappa_m(2)=unknowns(1);
%   params.Am=[0;unknowns(2:end);0];
%   params.kappa_m(1)=-params.kappa_m(2)*log(params.kappa_m(2))-(1-params.kappa_m(2))*log(1-params.kappa_m(2));
%   params.Am0=log(params.kappa_m(2))-log(1-params.kappa_m(2))-params.Am'*params.EY;
%---------------------------------

%market return coefficients
params.Br=(params.kappa_m(2)*params.Am+e_d);
params.r0=-log(params.kappa_m(2))+(1-params.kappa_m(2))*params.Am'*params.EY+params.Br'*params.mu_tilde;
params.EJ=[0;0;0;params.gammadist.mu_sigma*params.l1_sigma;0];

%%
%***********************************
%Simulation of state vaiable series
%************************************
%924 monthly observations,1000 simulations
T=924;
rng(20180403);

nsim=1000;
CF=zeros(nsim,8);
Returns=zeros(nsim,10);
VP=zeros(nsim,8);
vpbeta=zeros(nsim,6);
vpR2=zeros(nsim,4);
lhcR2=zeros(nsim,3);
lhrR2=zeros(nsim,3);
volbeta=zeros(nsim,4);
volR2=zeros(nsim,4);

for i=1:nsim
seed=floor(rand*100000);
out=simpath(params,T,seed+i);
CF(i,:)=[out.EDc,out.sigmaDc,out.ACDc,out.EDd,out.sigmaDd,out.ACDd,out.corrDcDd,out.kurt_cQ];
Returns(i,:)=[out.Erm,out.Erf,out.sigma_rm,out.sigma_rf,out.Epd,out.sigma_pd,out.skew_rm_rf,out.kurt_rm_rf,out.AC_rm_rf,out.kurt_rmrf_annual];
VP(i,:)=[out.sigma_VarP,out.AC1_varP,out.AC2_varP,out.Evp,out.sigma_vp,out.skewVP,out.kurtVP,out.kurDVIX];
vpbeta(i,:)=out.vpbeta';
vpR2(i,:)=out.vpR2';
lhcR2(i,:)=out.lhcR2';
lhrR2(i,:)=out.lhrR2';
volbeta(i,:)=out.volbeta';
volR2(i,:)=out.volR2';
end

%print calibration floaters

%Table 6  Cash Flow       
table06(CF);


%Table 7 Asset returns         
table07(Returns);


%Table 8 Variance Premium        
table08(VP,vpbeta,vpR2);


%Table 9 Long run predictability 
table09(lhcR2,lhrR2);



%Table 10 volatility predictability
table10(volbeta,volR2);

%%
%*************************************
%      Normally distributed jumps    *
%*************************************
%Redo everyting except for that jump size in x is normal
%risk aversion is increased to 10
normal=true;
params.gamma=10;
params.theta=(1-params.gamma)/(1-1/params.psi);

%------------------------
%1.1 Wealth portfolio
%------------------------

%two methods
%1.solving without imposing model implied restrictions (fsolve or vpasolve)
% default method

%-----------uncomment to try this method-------- 
 svalues=[0.9;0;0;0;0;0];
 temp=fsolve(@(arg)wealthsystem(params,arg,normal),svalues);
 options=optimoptions(@fsolve,'Display','off','FunctionTolerance',1e-4,'Algorithm','levenberg-marquardt');
 params.Ac=temp(2:end);
 params.kappa_c(2)=temp(1);
 params.kappa_c(1)=-params.kappa_c(2)*log(params.kappa_c(2))-(1-params.kappa_c(2))*log(1-params.kappa_c(2));
params.A0=log(params.kappa_c(2))-log(1-params.kappa_c(2))-params.Ac'*params.EY;
%-----------------------------------------------
%2.impose S_c=A_d=0 and A_sigma<0, A_sigmabar<0
%   -yields desired risk-free rate
%   -does not satisfy the equations perfectly
%---------uncomment to try----------------
%   svalues=zeros(4,1);
%   lb = -20*ones(n-1,1);
%   ub = 20*ones(n-1,1);
%   svalues(1) = 0.90; % Better starting value
%   lb(1) = 0.0;
%   ub(1) = 1.0;
%   %ub(4:5)=0;
%   [unknowns,fval,exit,output] = fmincon(@(arg)objwealth(params,arg), svalues, [], [], [], [], lb, ub);
%   params.kappa_c(2)=unknowns(1);
%   params.Ac=[0;unknowns(2:end);0];
% 
% %Calculate kappa_0 and A_0 using eqn A2.2 and A2.1
% params.kappa_c(1)=-params.kappa_c(2)*log(params.kappa_c(2))-(1-params.kappa_c(2))*log(1-params.kappa_c(2));
% params.A0=log(params.kappa_c(2))-log(1-params.kappa_c(2))-params.Ac'*params.EY;
%------------------------------
%Market price of risk (p.13)
params.Lambda=params.gamma*e_c+(1-params.theta)*params.kappa_c(2)*params.Ac;

%Risk free rate coefficients
params.r_f0=-params.theta*log(params.delta)+(1-params.theta)*(params.kappa_c(1)+(params.kappa_c(2)-1)*params.A0)-fapdx(params,-params.Lambda);
params.rf_coef=-(gapdx(params, -params.Lambda)-(params.theta-1)*params.Ac);

%-----------------------------
%1.2 Market portfolio
%-----------------------------
%Two methods
%1.without any model implied restrictions, symbolic solver vpasolve
%or fsolve (default method)
 syms kappa1m;
 syms A_mc A_mx A_msigmabar A_msigma A_md;

 syms m_solver1(kappa1m,A_mc,A_mx,A_msigmabar,A_msigma, A_md);
 syms m_solver2(kappa1m,A_mc,A_mx,A_msigmabar,A_msigma, A_md);
 syms m_solver1(Ezm,A_mc,A_mx,A_msigmabar,A_msigma, A_md); 
 
 m_solver1(kappa1m,A_mc,A_mx,A_msigmabar,A_msigma, A_md)=params.theta*log(params.delta)-(1-params.theta)*(params.kappa_c(2)-1)*params.A0-(1-params.theta)*params.kappa_c(1)-log(kappa1m)+(1-kappa1m)*[A_mc;A_mx;A_msigmabar;A_msigma;A_md]'*params.EY+fapdx(params,e_d+kappa1m*[A_mc;A_mx;A_msigmabar;A_msigma;A_md]-params.Lambda,normal);
 m_solver2(kappa1m,A_mc,A_mx,A_msigmabar,A_msigma, A_md)=gapdx(params,e_d+kappa1m*[A_mc;A_mx;A_msigmabar;A_msigma;A_md]-params.Lambda,normal)+(1-params.theta)*params.Ac-[A_mc;A_mx;A_msigmabar;A_msigma;A_md];

 temp=vpasolve([m_solver1==0,m_solver2==0],[kappa1m,A_mc,A_mx,A_msigmabar,A_msigma, A_md],[[0,1];[-inf,inf];[-inf,inf];[-inf,inf];[-inf,inf];[-inf,inf]]);
 params.kappa_m(2)=double(temp.kappa1m);
 params.Am=double([temp.A_mc;temp.A_mx;temp.A_msigmabar;temp.A_msigma;temp.A_md]);
% Calaulate A_m0 and kappa_m0
 params.kappa_m(1)=-params.kappa_m(2)*log(params.kappa_m(2))-(1-params.kappa_m(2))*log(1-params.kappa_m(2));
 params.Am0=log(params.kappa_m(2))-log(1-params.kappa_m(2))-params.Am'*params.EY;

%fsolve works very badly
%-------------uncomment to see--------
% options=optimset('MaxFunEvals',1e8,'MaxIter',1e7,'tolFun',1e-10);
% svalues=[0.9;0;0;0;0;0];
% temp=fsolve(@(arg)marketsystem(params,arg),svalues,options);
% params.kappa_m(2)=temp(1);
% params.Am=temp(2:end);

%2.impose model-implied restrictions Am_c=Am_d=0,kappa_1m<1
%solve numerically using fmincon imposing model implied constraints
%
%------uncomment to see---------------
%   svalues=zeros(4,1);
%   lb = -40*ones(n-1,1);
%   ub = 40*ones(n-1,1);
%   svalues(1) = 0.90; % Better starting value
%   lb(1) = 0.0;
%   ub(1) = 1.0;
%   %ub(end-1:end)=0;
%   [unknowns,fval,exit,output] = fmincon(@(arg)objective(params,arg), svalues, [], [], [], [], lb, ub);
%   params.kappa_m(2)=unknowns(1);
%   params.Am=[0;unknowns(2:end);0];
%   params.kappa_m(1)=-params.kappa_m(2)*log(params.kappa_m(2))-(1-params.kappa_m(2))*log(1-params.kappa_m(2));
%   params.Am0=log(params.kappa_m(2))-log(1-params.kappa_m(2))-params.Am'*params.EY;
%-------------------------
%market return coefficients
params.Br=(params.kappa_m(2)*params.Am+e_d);
params.r0=-log(params.kappa_m(2))+(1-params.kappa_m(2))*params.Am'*params.EY+params.Br'*params.mu_tilde;
params.EJ=[0;0;0;params.gammadist.mu_sigma*params.l1_sigma;0];

%%
%***********************************
%Simulation of state vaiable series
%************************************
%924 monthly observations,1000 simulations
T=924;
rng(20180403);


%trial simulate one path
nsim=1000;
CF=zeros(nsim,8);
Returns=zeros(nsim,10);
VP=zeros(nsim,8);
vpbeta=zeros(nsim,6);
vpR2=zeros(nsim,4);
lhcR2=zeros(nsim,3);
lhrR2=zeros(nsim,3);
volbeta=zeros(nsim,4);
volR2=zeros(nsim,4);

for i=1:nsim
seed=floor(rand*100000);
out=simpath(params,T,seed+i,normal);
CF(i,:)=[out.EDc,out.sigmaDc,out.ACDc,out.EDd,out.sigmaDd,out.ACDd,out.corrDcDd,out.kurt_cQ];
Returns(i,:)=[out.Erm,out.Erf,out.sigma_rm,out.sigma_rf,out.Epd,out.sigma_pd,out.skew_rm_rf,out.kurt_rm_rf,out.AC_rm_rf,out.kurt_rmrf_annual];
VP(i,:)=[out.sigma_VarP,out.AC1_varP,out.AC2_varP,out.Evp,out.sigma_vp,out.skewVP,out.kurtVP,out.kurDVIX];
vpbeta(i,:)=out.vpbeta';
vpR2(i,:)=out.vpR2';
lhcR2(i,:)=out.lhcR2';
lhrR2(i,:)=out.lhrR2';
volbeta(i,:)=out.volbeta';
volR2(i,:)=out.volR2';
end

%print calibration floaters

%Table 6  Cash Flow       

table06(CF);

%Table 7 Asset returns                  

table07(Returns);


%Table 8 Variance Premium        

table08(VP,vpbeta,vpR2);



%Table 9 Long run predictability *

table09(lhcR2,lhrR2);



%Table 10                        

table10(volbeta,volR2);



