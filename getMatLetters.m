function out=getMatLetters(daily_file_list,data_folder)
%thid function picks out unique maturity letters given the index type and
%the daily file list in a month.

%Input: daily_file_list: a list of daily zip files
%data_folder: directory of data folder

%ooutput:a list of unique maturity letters in the file list
temp=[];
for i=1:length(daily_file_list)
    if length(daily_file_list(i).name)<3  %get rid of the dots
        continue
    end
    if daily_file_list(i).name(1:2)==data_folder
        %strfind(daily_file_list(i).name,data_folder)>0
    temp=[temp;daily_file_list(i).name(3)];
    end
end
out=unique(temp);
end
