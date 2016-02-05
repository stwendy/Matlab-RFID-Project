%%
% This file is used for sync the RFID files and video data

%%
clear all
close all
clc

%%
caseNum='151213';

% load video time zero table
    fileID = fopen('timeZero.txt'); 
    timezeroTmp=textscan(fileID,'%s','Delimiter','\n');
    fclose(fileID);
    timeZero=timezeroTmp{1};
    
% format the timezero
for i=1:length(timeZero)
    if (strcmp(timeZero{i}(1:6),caseNum))
        syncTimeTmp=timeZero{i}(7:length(timeZero{i}));
        timeZero=timezeroTmp{1};
    end
end