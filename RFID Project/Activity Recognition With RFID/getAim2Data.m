%% Extract ground truth from AIM2 coding
function getAim2Data(casename)
% close all
% clear all
% clc

%% Read the excel files
xlsName=strcat('AIM2\AIM2Output_10Objects_',casename,'.xlsx');
[~,xlsdata] = xlsread(xlsName);
length=size(xlsdata,1);
tmpStartTime=xlsdata(2:length,1);
tmpEndTime=xlsdata(2:length,2);
tmpAIM2=xlsdata(2:length,3);

startTime=timeConverter(tmpStartTime);
endTime=timeConverter(tmpEndTime);
AIM2=ActivityConverter(tmpAIM2);

timeMax=max(endTime);

% Generate AIM 2 Log
[~,activityList] = xlsread('AIM2 Activity List.xlsx');
AIM2Coding=zeros((size(activityList,1)),timeMax);

for i=1:size(AIM2,2)
    Hash_Map_Temp=ismember(activityList,AIM2{i});
    [row,col,~]=find(Hash_Map_Temp);
    
    AIM2Coding(row,startTime(i):endTime(i))=1;
end

filename=strcat('AIM2_mat\',casename,'_AIM2.mat');
save(filename,'AIM2Coding')

%% Convert the time from HH:MM:SS to seconds
function time=timeConverter(tmpTime)
    length=size(tmpTime,1);
    time=zeros(length,1);
    for i=1:length
        [hour,remain] = strtok(tmpTime{i}, ':');hour=str2double(hour);
        [minute,remain] = strtok(remain, ':'); minute=str2double(minute);
        [second,remain] = strtok(remain, ':'); second=str2double(second);
        [microsecond,remain] = strtok(remain, ':'); microsecond=str2double(microsecond);
        
        time(i)=round(3600*hour+60*minute+second+microsecond/1000);
    end
return

%% Convert the Status into Keyword
function AIM2=ActivityConverter(tmpAIM2)
    % Convert the time from HH:MM:SS to seconds
    length=size(tmpAIM2,1);
    for i=1:length
        [token,remain] = strtok(tmpAIM2{i}, '-');
        [AIM2{i},remian] = strtok(remain, '-');
    end
return