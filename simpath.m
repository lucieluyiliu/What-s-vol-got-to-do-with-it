%This function simulates a state variables path
%and all the asset pricing implications

%Input : params: a structure that stores all the parameters
%        T: the length of the sample path
%        seed: a random number generator seed
%        normal: a logic variable indicating whether jump size in x is normal

function out=simpath(params, T,seed,normal)
rng(seed)
if nargin<4
    normal=false;
end

%initialize output vectors
n=5; %# of state variables
Y=zeros(n,T);
rf=zeros(T,1);
rm=zeros(T,1);
rp=zeros(T,1);
var_P=zeros(T,1);
var_Q=zeros(T,1);
pd=zeros(T,1);
vp=zeros(T,1);
level=zeros(T,1);
drift=zeros(T,1);
d=zeros(T,1);
logd=zeros(T,1);
p=zeros(T,1);
Jdrift=zeros(T,1);

%calculate some moments of the jump distribution out side of the loop
tempMGF1p=MGFpsi1(params.gammadist,zeros(5,1),normal);
tempMGF1q=MGFpsi1(params.gammadist,-params.Lambda,normal);
tempMGF2p=MGFpsi2(params.gammadist,zeros(5,1),normal);
tempMGF2q=MGFpsi2(params.gammadist,-params.Lambda,normal);

l1=zeros(5,5);
l1(:,4)=params.l1;

%****************************
%Generate iid normal vectors
 Z=mvnrnd(zeros(n,1),eye(n),T);
%Generate gaussian covariance matrix and compound poisson processes.
 Y(:,1)=params.EY;  %starting value is the unconditonal mean

for i=2:T
 GG=(params.h+params.H_sigma*Y(4,i-1));
 G=chol(GG); %Y(4) is sigma^2_t, cholesky decomposition
 GZ=G'*Z(i,:)'; %cholesky decomposition
 
%simulating compound poisson jumps
lambdat=[0;params.l1_x*Y(4,i-1);0;params.l1_sigma*Y(4,i-1);0];
N=poissrnd([lambdat(2),lambdat(4)]); %generate number of jumps
%jump size
if normal==false
jump_x=-gamrnd(params.gammadist.nu_x,params.gammadist.mu_x/params.gammadist.nu_x,N(1),1)+params.gammadist.mu_x; %jump size
else
jump_x=normrnd(0,params.gammadist.mu_x,[N(1),1]);
end
jump_sigma=gamrnd(params.gammadist.nu_sigma,params.gammadist.mu_sigma/params.gammadist.nu_sigma,N(2),1);
J=[0;sum(jump_x);0;sum(jump_sigma);0];
EJ=[0;0;0;params.gammadist.mu_sigma*lambdat(4);0];
J_tilde=J-EJ;
Y(:,i)=params.mu_tilde+params.F_tilde*Y(:,i-1)+GZ+J_tilde;

%floor volatility at 0

Y(4,i)=max(Y(4,i),0.001);
rf(i)=params.r_f0+params.rf_coef'*Y(:,i);
%rf(i)=max(params.r_f0+params.rf_coef'*Y(:,i),0); %risk free rate
rm(i)=params.r0+(params.Br'*params.F-params.Am')*Y(:,i-1)+params.Br'*GZ+params.Br'*J; %market return
%log price to dividend ratio (monthly)
pd(i)=params.Am0+params.Am'*Y(:,i); 
%need annual log price to dividend ratio 
%hence need to calculate annual dividend payment
%here I make the assumption that the starting value
%of log dividend is 0. And calculate the level of dividend using dividend
%growth.
logd(i)=logd(i-1)+Y(5,i); %monthly log dividend
d(i)=exp(logd(i)); %monthly dividend
p(i)=exp(pd(i)+logd(i)); %monthly price
%risk premia
rp(i)=params.Br'*GG*params.Lambda+lambdat'*(MGFpsi(params.gammadist,params.Br,normal)-1)-lambdat'*(MGFpsi(params.gammadist,params.Br-params.Lambda,normal)-MGFpsi(params.gammadist,-params.Lambda,normal));
%conditional variance under P
var_P(i)=params.Br'*GG*params.Br+params.Br.^2'*diag(tempMGF2p)*lambdat;
var_Q(i)=params.Br'*GG*params.Br+params.Br.^2'*diag(tempMGF2q)*lambdat;
%variance risk premia
%will be used in calculating drift difference due to jumps
Eplambda=l1*(params.mu_tilde+params.F_tilde*Y(:,i-1))+l1*diag(tempMGF1p)*lambdat;
Eqlambda=l1*(params.mu_tilde+params.F_tilde*Y(:,i-1))+l1*diag(tempMGF1q)*lambdat;
%level difference(p.20)
level(i)=params.Br.^2'*diag(tempMGF2q-tempMGF2p)*lambdat;
%drift difference (p.23) normal part
drift(i)=-params.Br'*params.H_sigma*params.Br*(params.h(4,4)+params.H_sigma(4,4)*Y(4,i))*params.Lambda(4);
%drift difference jump part(appendix C)
Jdrift(i)=params.Br.^2'*diag(tempMGF2q)*(Eqlambda-lambdat)-params.Br.^2'*diag(tempMGF2p)*(Eplambda-lambdat);
vp(i)=level(i)+drift(i)+Jdrift(i);
end
%%
%----uncomment the following part only if
%%the user wants to draw the path of one simulated sample.
%% this generates two figures in the report. 
%figure
% plot(rf);
% 
% figure
% plot(level*1e4,'LineWidth',0.75);
% hold on
% plot(drift*1e4,'LineWidth',0.75);
% hold on 
% plot(Jdrift*1e4,'LineWidth',0.75);
% 
% legend('level', 'normal drift','Jump drift');
% title('Components of the total variance risk premium');
% -----------------------
%%
vp=vp(end-206:end)*1e4; %variance premium related statistics are based on the last 207 monthly observations.
%1990.01-2007.03 has 207 months

%generate annual series
nyears=T/12;
Dc_annual=zeros(nyears,1);
Dd_annual=zeros(nyears,1);
rmrf_annual=zeros(nyears,1);
rm_annual=zeros(nyears,1);
rf_annual=zeros(nyears,1);
d_annual=zeros(nyears,1);
for i=1:nyears
Dc_annual(i) =sum(Y(1,12*(i-1)+1:12*i),2);
Dd_annual(i)=sum(Y(5,12*(i-1)+1:12*i),2);
rmrf_annual(i)=sum(rm(12*(i-1)+1:12*i))-sum(rf(12*(i-1)+1:12*i));
rm_annual(i)=sum(rm(12*(i-1)+1:12*i));
rf_annual(i)=sum(rf(12*(i-1)+1:12*i));
d_annual(i)=sum(d(12*(i-1)+1:12*i));
end
%annual frequency pd ratio
p_annual=p(12:12:T); %end of year price
pd_annual=log(p_annual./d_annual); %end of year pd ratio(12mo trailing)

%generate quarterly series
nquarters=T/3;
Dc_quarters=zeros(nquarters,1);
Dd_quarters=zeros(nquarters,1);
for i=1:nquarters
    Dc_quarters(i)=sum(Y(1,3*(i-1)+1:3*i),2);
    Dd_quarters(i)=sum(Y(5,3*(i-1)+1:3*i),2);
end
Dc_quarters=Dc_quarters(end-236:end); %1947:2-2006:4 has (2006-1947)*4+1=237 quarters
%consumption mean annualized
out.EDc=mean(Dc_annual)*100;
out.sigmaDc=std(Dc_annual)*100;
%autocorrelations of delta_c 
temp=autocorr(Dc_annual,1);
out.ACDc=temp(2);
out.EDd=mean(Dd_annual)*100;
out.sigmaDd=std(Dd_annual)*100;
%autocorrelation of delta_d
temp=autocorr(Dd_annual,1);
out.ACDd=temp(2);
%correltaion between delta c and delta d
out.corrDcDd=corr(Dc_annual,Dd_annual);
%kurtosis of delta c quarterly
out.kurt_cQ=kurtosis(Dc_quarters); 
%%
%***********************************************************
%    Calculate sample asset pricing moments as in Table 7  *
%***********************************************************
%simulation is monthly need to convert result to annual
out.Erm=mean(rm_annual)*100; %annualize in percentage
out.Erf=mean(rf_annual)*100;
out.sigma_rm=std(rm_annual)*100;
out.sigma_rf=std(rf_annual)*100;
out.Epd=mean(pd_annual); %annual log price to dividend ratio 

out.sigma_pd=std(pd_annual);
out.skew_rm_rf=skewness(rm-rf);
out.kurt_rm_rf=kurtosis(rm-rf);
temp=autocorr(rm-rf,1);
out.AC_rm_rf=temp(2);
out.kurt_rmrf_annual=kurtosis(rmrf_annual);

%**************************************************
% calculate variance premium statistic in Table 8 *
%***************************************************
out.sigma_VarP=std(var_P)*1e4;
temp=autocorr(var_P,2);
out.AC1_varP=temp(2);
out.AC2_varP=temp(3);
out.Evp=mean(vp);
out.sigma_vp=std(vp);
out.skewVP=skewness(vp);
out.kurtVP=kurtosis(vp);
out.kurDVIX=kurtosis(diff(var_Q));

%predictive regression
%first shorten sample to 1990.1-2007.3 207 periods
rm_new=rm(end-206:end)*1200;%annualized percentage
pd_new=pd(end-206:end);
rm_3m=zeros(size(rm_new,1)-2,1);
for i=1:size(rm_new,1)-2
    rm_3m(i)=sum(rm_new(i:i+2)); %overlapping quarterly return
end

out.vpbeta=zeros(6,1);
out.vpR2=zeros(4,1);
%univariate VP 1mo
[out.vpbeta(1),out.vpR2(1)]=betaR2(rm_new(2:end),vp(1:end-1));
%univariate VP 3mo
[out.vpbeta(2),out.vpR2(2)]=betaR2(rm_3m(2:end),vp(1:end-3));
%multivariate 1mo
[out.vpbeta(3:4),out.vpR2(3)]=betaR2(rm_new(2:end),[vp(1:end-1),pd_new(1:end-1)]);
%multivariate 3mo
[out.vpbeta(5:6),out.vpR2(4)]=betaR2(rm_3m(2:end),[vp(1:end-3),pd_new(1:end-3)]);

out.vpR2=out.vpR2*100;

%For the following long term predictive regressions, we need annual p/d
%ratios.
%********************************************
%   Table 9 long-horizon predictability     *
%********************************************

%consumption growth predictabilty
%generate non-overlapping 3-year and 5-year consumption growth and return
%series
Dc_3y=zeros(nyears-2,1);
Dc_5y=zeros(nyears-4,1);
rmrf_1y=zeros(T-11,1);
rmrf_3y=zeros(T-35,1);
rmrf_5y=zeros(T-59,1);

lhcR2=zeros(3,1); %long horizon consumption R2
lhrR2=zeros(3,1); %long horizon eturn R2
for i=1:nyears-2
    Dc_3y(i)=sum(Dc_annual(i:i+2));
end

for i=1:nyears-4
    Dc_5y(i)=sum(Dc_annual(i:i+4));
end
%monthly 1y return series
 for i=1:T-11
 rmrf_1y(i)=sum(rm(i:i+11))-sum(rf(i:i+11));
 end
%monthly 3y return series
for i=1:T-35
rmrf_3y(i)=sum(rm(i:i+35))-sum(rf(i:i+35));
end
%monthly 5y return series
for i=1:T-59
rmrf_5y(i)=sum(rm(i:i+59))-sum(rf(i:i+59));
end


%consumption predictability regression
[~,lhcR2(1)]=betaR2(Dc_annual(2:end),pd_annual(1:end-1));
[~,lhcR2(2)]=betaR2(Dc_3y(2:end),pd_annual(1:nyears-3));
[~,lhcR2(3)]=betaR2(Dc_5y(2:end),pd_annual(1:nyears-5));

%return predictability regression
[~,lhrR2(1)]=betaR2(rmrf_1y(2:end),pd(1:T-12));
[~,lhrR2(2)]=betaR2(rmrf_3y(2:end),pd(1:T-36));
[~,lhrR2(3)]=betaR2(rmrf_5y(2:end),pd(1:T-60));
out.lhcR2=lhcR2*100;
out.lhrR2=lhrR2*100;

% %************************************************
% %   Table 10 predictability of volatility       * 
% %************************************************
 out.volbeta=zeros(4,1);
 out.volR2=zeros(4,1);
%consumption volatility series
%fit AR(1) model for consumption growth
Mdl=fitlm(Dc_annual(1:end-1),Dc_annual(2:end));
%consumption volatility is calculated as the log of the sum of absolute
%residuals from an AR(1) model of consumption growth
Dc_resid=Dc_annual(2:end)-predict(Mdl,Dc_annual(1:end-1));
Dcvol_1y=zeros(nyears-1,1); %nyears-1 1y consumption volatility series
Dcvol_5y=zeros(nyears-5,1); %nyears-5 5y consumption volatility series
for i=1:nyears-1 
    Dcvol_1y(i)=log(abs(Dc_resid(i)));
end
for i=1:nyears-5
Dcvol_5y(i)=log(sum(abs(i:i+4)));
end
% return volatility series
rxvol_1y=zeros(T-11,1);
rxvol_5y=zeros(T-59,1);
for i=1:T-11
rxvol_1y(i)=sqrt(12)*std(rm(i:i+11)-rf(i:i+11));
end
for i=1:T-59
rxvol_5y(i)=sqrt(12)*std(rm(i:i+59)-rf(i:i+59));
end
%consumption volatility prediction (annual)
[out.volbeta(1),out.volR2(1)]=betaR2(Dcvol_1y,pd_annual(1:end-1)); %Dcvol starts from the second year
[out.volbeta(2),out.volR2(2)]=betaR2(Dcvol_5y,pd_annual(1:end-5));
%return volatility regression(monthly)
[out.volbeta(3),out.volR2(3)]=betaR2(rxvol_1y,pd(1:end-11));
[out.volbeta(4),out.volR2(4)]=betaR2(rxvol_5y,pd(1:end-59));
out.volR2=out.volR2*100;
end