%% Pre Load AIM2 data
% clear all
% close all
% clc

%%
directory_name = strcat(pwd,'\AIM2\');
files = dir(directory_name);

for i=3:length(files)
    casenum=files(i).name(22:27);
    fprintf('processing AIM 2: %s \n',casenum);
    getAim2Data(casenum);
end