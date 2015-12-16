%% Pre Load AIM1 data
% clear all
% close all
% clc

%%
directory_name = strcat(pwd,'\AIM1\');
files = dir(directory_name);

for i=3:length(files)
    casenum=files(i).name(12:17);
    fprintf('processing AIM 1: %s \n',casenum);
    getAim1Data(casenum);
end