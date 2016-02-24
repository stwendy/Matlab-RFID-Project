%%
% This code is used to analyze relationship between phase and activity

%%
close all
clear all
clc

%%
dirName='C:\Users\Xinyu Li\Google Drive\R01 RFID project\AIM1\AIM 1 Output\New System\';
files=dir(fullfile(dirName,'*.xlsx'));
    
AIM1=[];
AIM2=[];
    
confusionMatrix=zeros(11,11);
SS=zeros(11,1);

for f=1:length(files)
    fileName=strcat(dirName,files(f).name);
    caseNum=files(f).name(12:length(files(f).name)-5);
    
    loadName=strcat('C:\Users\Xinyu Li\Google Drive\R01 RFID project\AIM1\AIM 1 Output\New System\Converted Data\',caseNum,'_AIM1.mat');
    load(loadName);
    
    loadName=strcat('C:\Users\Xinyu Li\Google Drive\R01 RFID project\AIM1\AIM 1 Output\New System\Converted Data\',caseNum,'_AIM2.mat');
    load(loadName);
    
    AIM2=processedAIM2;
    AIM1=processedAIM1;
    
    for i=1:size(AIM2,2)
        for a=1:size(AIM2,1)
            if (AIM2(a,i)==1)
                row=find(AIM1(:,i)~=0);
                for j=1:length(row)
                    confusionMatrix(a,row(j))=confusionMatrix(a,row(j))+1;
                end
                SS(a)=SS(a)+1;
                
                clear row;
            end
        end
    end
    
    clear AIM2
    clear AIM1
        
end

% SS=sum(confusionMatrix,2);
for i=1:size(confusionMatrix,1)
    confusionMatrix(i,:)=100.*confusionMatrix(i,:)./SS(i);
end