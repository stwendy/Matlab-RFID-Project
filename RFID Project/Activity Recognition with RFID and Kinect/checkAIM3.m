%% Check if the medical phase linked to time

%%
close all
clear all
clc

%%
    dirName='C:\Users\Xinyu Li\Google Drive\R01 RFID project\AIM1\AIM 1 Output\New System\';
    files=dir(fullfile(dirName,'*.xlsx'));
    
AIM3=[];
    
for f=1:length(files)
    fileName=strcat(dirName,files(f).name);
    caseNum=files(f).name(12:length(files(f).name)-5);
    
    loadName=strcat('C:\Users\Xinyu Li\Google Drive\R01 RFID project\AIM1\AIM 1 Output\New System\Converted Data\',caseNum,'_AIM3.mat');
    load(loadName);
    
    starttmp=find(processedAIM3(2,:));
    endtmp=find(processedAIM3(7,:));
    AIM3(:,:,f)=imresize(processedAIM3(2:7,starttmp(1):endtmp(1)),[6,1000]);
end

% Calculate the time distribution of medical phases
cmpAIM3=sum(AIM3,3);
