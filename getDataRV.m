function [ data ] = getDataRV(start_date, end_date, ES)
%GETDATARV Function returns dataset of daily realized variance on the
%S&P500 futures contract
%   This function computes a daily realized variance measure (RV), a daily
%   jump-robust measure (MinRV) and a daily realised jump-variation measure
%   (RJV) based on the methodology used in Christoffersen & al. 2017
%   "Time-Varying Crash Risk: The Role of Stock Market Liquidity". This
%   function assumes that the daily files containing the information of
%   S&P500 is in compressed folders and decompresses/recompresses after
%   each file is opened.
%
% INPUTS:
%   start_date: a date in the format 'yyyy-mm-dd' for the starting date at
%   which we compute daily variance measures.
%
%   end_date: a date in the format 'yyyy-mm-dd' for the ending date at
%   which we compute daily variance measures.
%
%   ES (optional): default is ES=0 for the S&P500 futures contracts, if
%   ES=1 then we take the E-Mini future contracts instead of the S&P500
%   contracts
%
% OUTPUTS:
%   data: a dataset containing 4 columns: date, RV, MinRV, RJV
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
addpath('../utils') % add folder to the search path

 
if nargin < 3
    ES = 0;
    folder_end = '_SP';
else
    folder_end = '_ES';
end
 
date = [];
RV = [];
MinRV = [];
RJV = [];
data_folder = folder_end(2:length(folder_end)); %'SP' or 'EP'
first_price=0;
dir_name = datafileDB(data_folder); %read directory? This datafile DB function
file_list = dir(dir_name);
 
start_t = strsplit(start_date, '-');
end_t = strsplit(end_date, '-'); %date into year month day string
 
entry = 1;
f_newformat = 0;
 
for i = 1:length(file_list)
    if strfind(file_list(i).name, strcat(start_t(1), '_', start_t(2), folder_end)) > 0
        start_file_index = i;
    end
    if strfind(file_list(i).name, strcat(end_t(1), '_', end_t(2), folder_end)) > 0
        end_file_index = i;
    end
end
 
file_list(1:start_file_index-1) = [];
file_list(end_file_index-start_file_index+2:length(file_list)) = [];
 
for i = 1:length(file_list)
     
    full_unzip_dir = nameUnzip(file_list(i).name, dir_name);
     %this is another unknown function, maybe it gives the directory of the
     %unzipped file
    current_date = strsplit(file_list(i).name, '_');
    current_month = str2double(current_date(2));
    current_year = str2double(current_date(1));
    if current_year == 2011 && current_month == 7
        f_newformat = 1; %what happend in 2011.07?
    end
    %directory of the file
    unzip(fullfile(file_list(i).folder, file_list(i).name), full_unzip_dir);
     %fullfile is builds full file name from parts
    daily_file_list = dir(full_unzip_dir);
     
    % This loop is to pick only the specific days in a month 
    for k = 1:length(daily_file_list)
        %this if statement is very confusing
        if strfind(daily_file_list(k).name, strcat(end_t{1}, '_', end_t{2}, '_', end_t{3})) == 0
           daily_file_list(k) = []; %unless the month includes end date, 
        end
    end
    % gather all the different maturities in the unzipped file
    unique_letters = getMatLetters(daily_file_list, data_folder);
    %get maturity letters? H:March, M: June, U:September, Z: December.
    % use findNextMat function to pick next maturity
    next_mat = findNextMat(current_month, unique_letters);
     
    first_price = 0;
    for j = 1:length(daily_file_list)
        if strfind(daily_file_list(j).name, strcat(data_folder, next_mat)) > 0
            %if the file is next maturity contract, then unzip it.
            daily_data_dir = nameUnzip(daily_file_list(j).name, daily_file_list(j).folder);
            gunzip(fullfile(daily_file_list(j).folder, daily_file_list(j).name), daily_data_dir);
            %gz file
            current_filetoread = strcat(daily_data_dir,'\',daily_file_list(j).name(1:length(daily_file_list(j).name)));
            current_filetoread = current_filetoread(1:length(current_filetoread)-3);
             %remove gz.
            % This is where the file is read (sadly the different formats
            % aren't matlab native so I have to extract number by number
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
             
            [A, count] = fscanf(fid, formatspect, sizeA);
            A = A';
            fclose(fid);
             
            % get a grid of 1 minute returns
            [onemin_grid, current_date_d, last_price] = create_grid(A, first_price);
            %+99 creategrid is also a unknown function
            first_price = last_price;
            % calculate the different measures (*_d stands for daily)
            RV_d = sum(onemin_grid.returns.^2);
             
            date = [date; current_date_d];
            RV = [RV; RV_d];
             
            entry = entry+1;
            current_date_d
        end
    end
     
    % Remove the unzipped folder once data is collected to save space
    rmdir(full_unzip_dir, 's');
     
end
MinRV = zeros(size(RV,1),1);
RJV = zeros(size(RV,1),1);
 
data = table(date, RV, MinRV, RJV);