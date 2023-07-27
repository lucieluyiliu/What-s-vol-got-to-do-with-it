
function out=findNextMat(current_month, unique_letters)
%this function gives the next contract maturity month letter given 
%for the S&P 500 futures given the current month.
%H:March, M: June, U:September, Z: December.
%Input: current month: current month
%       unique_letters: unique maturity month letters
%in files under the current directory
if current_month<3
    out='H';
elseif current_month==12
        out='H';
elseif current_month>=3&&current_month<6
            out='M';
elseif current_month>=6 &&current_month<9
            out='U';
elseif current_month>=9 && current_month<12
    out='Z';
end
end