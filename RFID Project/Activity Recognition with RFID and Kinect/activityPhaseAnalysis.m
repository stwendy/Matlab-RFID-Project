%%
% This code is used to analyze relationship between phase and activity

%%
close all
clear all
clc

%%
dirName='C:\Users\Xinyu Li\Google Drive\R01 RFID project\AIM1\AIM 1 Output\New System\';
files=dir(fullfile(dirName,'*.xlsx'));
    
AIM3=[];
AIM2=[];
    
confusionMatrix=zeros(11,5);

for f=1:length(files)
    fileName=strcat(dirName,files(f).name);
    caseNum=files(f).name(12:length(files(f).name)-5);
    
    loadName=strcat('C:\Users\Xinyu Li\Google Drive\R01 RFID project\AIM1\AIM 1 Output\New System\Converted Data\',caseNum,'_AIM3.mat');
    load(loadName);
    
    loadName=strcat('C:\Users\Xinyu Li\Google Drive\R01 RFID project\AIM1\AIM 1 Output\New System\Converted Data\',caseNum,'_AIM2.mat');
    load(loadName);
    
    AIM2=processedAIM2;
    AIM3=processedAIM3([1,3,4,5,6],:);
    
    for i=1:size(AIM2,2)
        for o=1:size(AIM2,1)
            if (AIM2(o,i)==1)
                row=find(AIM3(:,i)==1);
                confusionMatrix(o,row)=confusionMatrix(o,row)+1;
            end
        end
    end
    
    clear AIM2;
    clear AIM3;
        
end

SS=sum(confusionMatrix,2);
for i=1:size(confusionMatrix,1)
    confusionMatrix(i,:)=100.*confusionMatrix(i,:)./SS(i);
end