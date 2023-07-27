function [fivemin_grid, last_price]=create_grid(A, first_price)
%This function clculates 5-min log return during a day
%Input: first_price: last 5-minute price in the previous trading day
%       A: output of fscanf file id
%OUTPUT: five_mingrid gives a vector of 5-min return
%        last_price records the price in the last 5-minute of the current
%        day.

time=datetime(A(:,3),A(:,1),A(:,2),A(:,4),A(:,5),A(:,6));
temp=A(:,7); %stores price
%RV is sensitive to how I divide the bin and define 5-minute return
[Y,~]=discretize(time,minutes(5)); %put prices into 5-minutes bin

indx=diff(Y)==1;  
indx=[true;indx(1:end-1)];%indx is the begining index of each bin
indx_end=diff(Y)==1; %index_end is the end index of each bin
indx_end(end)=1;
indx(end)=1; % If this statement , then the last price of a trading day will be used to calculate last return,
% and the overnight return will be calculated using the last price.

%If I take 5-min return to be the return between beginning of the bin and
%end of the bin, undershoot, if I define 5-min return to be 
%the return between the beginning of each bn, overshot.

%indx_end(1)=1;
fivemin_price=temp(indx); %this version uses beginnning of the bin
fivemin_grid.returns=diff(log(fivemin_price));

%fivemin_grid.returns=log(temp(indx_end))-log(temp(indx));
if first_price~=0 % if this is not the begining of the sample
    fivemin_grid.returns=[log(temp(1))-log(first_price);fivemin_grid.returns];
end

%fivemin_price(end);
last_price=fivemin_price(end);
%last_price=temp(end);
end
