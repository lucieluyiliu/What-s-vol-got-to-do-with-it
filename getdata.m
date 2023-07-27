function [data]=getdata (start_date,end_date,ES)

%this function calculates the monthly realized variance using 5-minute
%log return of S& P 500 futures
%overnight and over-weekend return are treated as 5-min interval as in
%Drechler and Yaron

%INPUT: start_date: string of starting date 'yyyy-mm-dd'
       %end_date: string of end date 'yyyy-mm-dd'

%OUTput: table of yyyymm and RV of the month.

%In the working directory there should be 
%a folder SP that contains orginal TICKDATA data

%************************************************
%  initialize and house keeping                 *
%************************************************
if nargin < 3
    ES = 0;
    folder_end = '_SP';
else
    folder_end = '_ES';
end

date = [];
RV = [];
data_folder=folder_end(2:length(folder_end));
dir_name=data_folder;
file_list = dir(data_folder);
start_t = strsplit(start_date, '-');
end_t = strsplit(end_date, '-');
entry = 1;
f_newformat = 0;
first_price=0;

for i = 1:length(file_list)
    if strfind(file_list(i).name, strcat(start_t(1), '_', start_t(2), folder_end)) > 0
        start_file_index = i;
    end
    if strfind(file_list(i).name, strcat(end_t(1), '_', end_t(2), folder_end)) > 0
        end_file_index = i;
    end
end
%remove file names before start date and after end date.
file_list(1:start_file_index-1) = [];
file_list(end_file_index-start_file_index+2:length(file_list)) = [];

%*************************************************
%unzip monthly zip files                         *
%*************************************************

for i = 1:length(file_list)
  full_unzip_dir = nameUnzip(file_list(i).name, dir_name);
  current_date = strsplit(file_list(i).name, '_');
    current_month = str2double(current_date(2));
    current_year = str2double(current_date(1));
    if current_year == 2011 && current_month == 7
        f_newformat = 1; %format changed after 2011.07
    end  
    %directory of the file
    unzip(fullfile(file_list(i).folder, file_list(i).name), full_unzip_dir);
     %fullfile is builds full file name from parts
    daily_file_list = dir(full_unzip_dir);
    for k = 1:length(daily_file_list)  
        
       if strfind(daily_file_list(k).name,strcat(start_t{1},'_',start_t{2},'_',start_t{3}))>0
    daily_file_list(1:k-1)=[];% remove daily files before start date;
       end
       if strfind(daily_file_list(k).name,strcat(end_t{1},'_',end_t{2},'_',end_t{3}))>0
    daily_file_list(k+1:end)=[];% remove daily files after end date;
       end
     end
    % gather all the different maturities in the unzipped file
    unique_letters = getMatLetters(daily_file_list, data_folder);
    %gH:March, M: June, U:September, Z: December.
    % use findNextMat function to pick next maturity
    next_mat = findNextMat(current_month, unique_letters);
  
    %**********************************************
    %      Read the data                          *
    %**********************************************
    RV_m=0;
    for j = 1:length(daily_file_list)
        if strfind(daily_file_list(j).name, strcat(data_folder, next_mat)) > 0
            %if the file is next maturity contract, then unzip it.
            daily_data_dir = nameUnzip(daily_file_list(j).name, daily_file_list(j).folder);
            gunzip(fullfile(daily_file_list(j).folder, daily_file_list(j).name), daily_data_dir);
            %gz file
            current_filetoread = strcat(daily_data_dir,'\',daily_file_list(j).name(1:length(daily_file_list(j).name)));
            current_filetoread = current_filetoread(1:length(current_filetoread)-3);
             
            % This is where the file is read (sadly the different formats
            fid = fopen(current_filetoread, 'r');
            if fid == -1
                error('Cannot open file');
            end
             
            if f_newformat
                formatspect = '%d/%d/%d,%d:%d:%f,%f,%d,%c,%d, ,%f';
                sizeA = [11, Inf];
            else
                formatspect = '%d/%d/%d,%d:%d:%d,%f,%d,%c';
                sizeA = [9, Inf];
            end
             
            [A, ~] = fscanf(fid, formatspect, sizeA);
            A = A.';
            fclose(fid);
             
            % get a grid of 5 minute returns
            [fivemin_grid, last_price] = create_grid(A, first_price);
         
            first_price = last_price;
            % calculate RV in a trading day
            RV_d = sum(fivemin_grid.returns.^2);
             
            %date = [date; current_date_d];
            RV_m = RV_m+RV_d; %monthly realized variance is the sum of daily
            entry = entry+1;
        end      
    end
RV=[RV;RV_m];%monthly RV
rmdir(full_unzip_dir, 's');
date=[date;current_year*100+current_month];
data=table(date,RV);
end
