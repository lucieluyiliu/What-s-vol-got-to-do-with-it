%This is the main program for the empirical part of
%What's Vol got to do with it Drechsler and Yaron(2011)
clc
clear all

start_date='1990-01-01';
end_date='2007-03-31';
Fut2=getdata(start_date,end_date);
Fut2RV=Fut2.RV*1e4;
SP_Ret=readtable('monthly_SP_return.csv');
r_SP=log(1+SP_Ret.vwretd);
VW_Ret=readtable('monthly_VW_return.csv');
r_VW=log(1+VW_Ret.vwretd);
SP_daily=readtable('daily_SP_return.csv');
SP_daily.returns=log(1+SP_daily.sprtrn);
SP_daily.return_squared=SP_daily.returns.^2;
SP_daily.yearmon=floor(SP_daily.DATE/100);
[yearmon,ia,ic]=unique(SP_daily.yearmon); %ic is the corresponding index of the value of yearmon for each day
dailyvol=accumarray(ic,SP_daily.return_squared)*1e4;
Tbill=readtable('30day_Tbill_return.csv');
Rf=log(1+Tbill.t30ret);
rx_SP=(r_SP-Rf)*100;
rx_VW=(r_VW-Rf)*100;
monthly_vix=readtable('monthly_vix.csv');
VIX2=monthly_vix.VIX.^2/12;


%table 1 summary statistics

table1=zeros(6,5);
%SP
table1(1,1)=mean(rx_SP);
table1(2,1)=median(rx_SP);
table1(3,1)=std(rx_SP);
table1(4,1)=skewness(rx_SP);
table1(5,1)=kurtosis(rx_SP);
temp=autocorr(rx_SP,1);
table1(6,1)=temp(2);

%VW
table1(1,2)=mean(rx_VW);
table1(2,2)=median(rx_VW);
table1(3,2)=std(rx_VW);
table1(4,2)=skewness(rx_VW);
table1(5,2)=kurtosis(rx_VW);
temp=autocorr(rx_VW,1);
table1(6,2)=temp(2);

%VIX^2
table1(1,3)=mean(VIX2);
table1(2,3)=median(VIX2);
table1(3,3)=std(VIX2);
table1(4,3)=skewness(VIX2);
table1(5,3)=kurtosis(VIX2);
temp=autocorr(VIX2,1);
table1(6,3)=temp(2);
%Fut2
table1(1,4)=mean(Fut2RV);
table1(2,4)=median(Fut2RV);
table1(3,4)=std(Fut2RV);
table1(4,4)=skewness(Fut2RV);
table1(5,4)=kurtosis(Fut2RV);
temp=autocorr(Fut2RV,1);
table1(6,4)=temp(2);

%daily
table1(1,5)=mean(dailyvol);
table1(2,5)=median(dailyvol);
table1(3,5)=std(dailyvol);
table1(4,5)=skewness(dailyvol);
table1(5,5)=kurtosis(dailyvol);
temp=autocorr(dailyvol,1);
table1(6,5)=temp(2);
table01(table1);

%table 02
%predicting variance under p
Mdl=arima(1,0, 1);
[EstMdl,EstParamCov]=estimate(Mdl,dailyvol);
beta_daily=[EstMdl.Constant;cell2mat(EstMdl.AR);cell2mat(EstMdl.MA)];
temp=sqrt(diag(EstParamCov(1:3,1:3)));
t_daily=beta_daily./temp;
[resid,~] = infer(EstMdl,dailyvol);
dailyvolhat=dailyvol-resid;
ybar=mean(dailyvol);
erry=dailyvol-ybar;
TSS=sum(erry.^2);
RSS=sum(resid.^2);
R2_daily=1-RSS/TSS;
%Fut2 prediction
lhv=Fut2RV(2:end);
rhv=[ones(size(Fut2RV,1)-1,1),Fut2RV(1:end-1),VIX2(1:end-1)];
[beta_Fut,~,R2_Fut,t_Fut,~,~,~,~,~] = olsgmm(lhv,rhv,18,1);
table02(beta_daily,R2_daily,t_daily,beta_Fut,R2_Fut,t_Fut);
Fut2hat=rhv*beta_Fut;
%table 3 properties of the variance risk premium

VP_BTZ=VIX2(1:end-1)-Fut2RV(1:end-1);
VP_daily=VIX2(1:end-1)-dailyvolhat(2:end);
VP_Fut=VIX2(1:end-1)-Fut2hat;

%BTZ
table3=zeros(7,3);
table3(1,1)=mean(VP_BTZ);
table3(2,1)=median(VP_BTZ);
table3(3,1)=std(VP_BTZ);
table3(4,1)=min(VP_BTZ);
table3(5,1)=skewness(VP_BTZ);
table3(6,1)=kurtosis(VP_BTZ);
temp=autocorr(VP_BTZ,1);
table3(7,1)=temp(2);

%Daily
table3(1,2)=mean(VP_daily);
table3(2,2)=median(VP_daily);
table3(3,2)=std(VP_daily);
table3(4,2)=min(VP_daily);
table3(5,2)=skewness(VP_daily);
table3(6,2)=kurtosis(VP_daily);
temp=autocorr(VP_daily,1);
table3(7,2)=temp(2);
%VP-Fut
table3(1,3)=mean(VP_Fut);
table3(2,3)=median(VP_Fut);
table3(3,3)=std(VP_Fut);
table3(4,3)=min(VP_Fut);
table3(5,3)=skewness(VP_Fut);
table3(6,3)=kurtosis(VP_Fut);
temp=autocorr(VP_Fut,1);
table3(7,3)=temp(2);
table03(table3);

%table 4 predictive regressions
T=size(r_SP,1);
temp=readtable('SP_PE.csv');
PE=log(temp.PE);
rSP_annual=r_SP*1200; %annualized
%regression 1: 1-month return on VP

lhv=rSP_annual(2:end);
rhv=[ones(size(rSP_annual,1)-1,1),VP_Fut(1:end)];
[betapred1,~,R2pred1,tpred1,~,~,~,~,~]=olsgmm(lhv,rhv,18,1);
robust.RobustMdl1=fitlm(VP_Fut(1:end),rSP_annual(2:end),'RobustOpts','on');

%regression 2: 1 month return on lagged VP
lhv=rSP_annual(3:end);
rhv=[ones(size(rSP_annual,1)-2,1),VP_Fut(1:end-1)];
[betapred2,~,R2pred2,tpred2,~,~,~,~,~]=olsgmm(lhv,rhv,18,1);
robust.RobustMdl2=fitlm(VP_Fut(1:end),rSP_annual(2:end),'RobustOpts','on');

%regression 3 regress 3-month returns
rSP_3m=zeros(T-4,1);
for i=1:T-4
    rSP_3m(i)=sum(r_SP(i+1:i+4));
end
rSP_3m=rSP_3m*400;%annualize
lhv=rSP_3m;
rhv=[ones(size(rSP_3m,1),1),VP_Fut(1:end-3)];

[betapred3,~,R2pred3,tpred3,~,~,~,~,~]=olsgmm(lhv,rhv,18,1);
robust.RobustMdl3=fitlm(VP_Fut(1:end-3),rSP_3m,'RobustOpts','on');

%rergression 4: onr month return on both VP and pd
lhv=rSP_annual(2:end);
rhv=[ones(size(rSP_annual,1)-1,1),VP_Fut(1:end),PE(1:end-1)];
[betapred4,~,R2pred4,tpred4,~,~,~,~,~]=olsgmm(lhv,rhv,18,1);
robust.RobustMdl4=fitlm([VP_Fut(1:end),PE(1:end-1)],rSP_annual(2:end),'RobustOpts','on');

%regression 5 one month return on lagged VP and pd
lhv=rSP_annual(3:end);
rhv=[ones(size(rSP_annual,1)-2,1),VP_Fut(1:end-1),PE(2:end-1)];
[betapred5,~,R2pred5,tpred5,~,~,~,~,~]=olsgmm(lhv,rhv,18,1);
robust.RobustMdl5=fitlm([VP_Fut(1:end-1),PE(2:end-1)],rSP_annual(3:end),'RobustOpts','on');
%print Table04
table04(betapred1,betapred2,betapred3,betapred4,betapred5,R2pred1,R2pred2,R2pred3,R2pred4,R2pred5,tpred1,tpred2,tpred3,tpred4,tpred5,robust)