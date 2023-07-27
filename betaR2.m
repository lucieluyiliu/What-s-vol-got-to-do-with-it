
function [beta,R2]=betaR2(lhv,rhv)
%This function runs OLS regression (including constant)
%Input: lhv: dependent variables
%       rhv: independent variables
%Output: beta: regression coefficients
%         R2: regression R2
if size(rhv,1) ~= size(lhv,1);
   disp('betaR2: left and right sides must have same number of rows. Current rows are');
   size(lhv)
   size(rhv)
end

T = size(lhv,1);
rhv=[ones(T,1),rhv];
beta=rhv\lhv;
err=lhv-rhv*beta;
rss=mean(err.^2);
vary = lhv - ones(T,1)*mean(lhv);
vary = mean(vary.^2);
R2=1-rss/vary;
beta=beta(2:end); % no need to give intercept as output
end