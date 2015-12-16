%% Extract ground truth from AIM2 coding
function getAim1Data(casename)
% close all
% clear all
% clc

%% Read the excel files
xlsName=strcat('AIM1\AIM1Output_',casename,'.xlsx');
[~,xlsdata] = xlsread(xlsName);
length=size(xlsdata,1);
tmpStartTime=xlsdata(2:length,1);
tmpEndTime=xlsdata(2:length,2);
AIM1=xlsdata(2:length,3);

startTime=timeConverter(tmpStartTime);
endTime=timeConverter(tmpEndTime);
% AIM1=ActivityConverter(tmpAIM2);

timeMax=max(endTime);

% Generate AIM 2 Log
[~,objectList] = xlsread('AIM1 Object List.xlsx');
AIM1Coding=zeros((size(objectList,1)),timeMax);

for i=1:size(AIM1,1)
    Hash_Map_Temp=ismember(objectList,AIM1{i});
    [row,col,~]=find(Hash_Map_Temp);
    if (~isempty(row))
        AIM1Coding(row,startTime(i):endTime(i))=1;
    end
end
 
filename=strcat('AIM1_mat\',casename,'_AIM1.mat');
save(filename,'AIM1Coding')

%% Convert the time from HH:MM:SS to seconds
function time=timeConverter(tmpTime)
    length=size(tmpTime,1);
    time=zeros(length,1);
    for i=1:length
        [hour,remain] = strtok(tmpTime{i}, ':');hour=str2double(hour);
        [minute,remain] = strtok(remain, ':'); minute=str2double(minute);
        [second,remain] = strtok(remain, ':');  second=str2double(second);
        [microsecond,remain] = strtok(remain, ':'); microsecond=str2double(microsecond);
        
        time(i)=round(3600*hour+60*minute+second+microsecond/1000);
    end
return
