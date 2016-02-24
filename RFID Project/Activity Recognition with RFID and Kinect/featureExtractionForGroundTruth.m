%% 
% this file is used for feature extraction using ground truth coding
% the 3 features extracted are
% activity position, medical phase and object use combination
% The features are written into csv files

%%
close all
clear all
clc

%% Extract features

dirName='C:\Users\Xinyu Li\Google Drive\R01 RFID project\AIM1\AIM 1 Output\New System\';
files=dir(fullfile(dirName,'*.xlsx'));
  
% define feature matrix for each second
feature=[];

for f=1:length(files)
    fileName=strcat(dirName,files(f).name);
    caseNum=files(f).name(12:length(files(f).name)-5);
    
    loadName=strcat('C:\Users\Xinyu Li\Google Drive\R01 RFID project\AIM1\AIM 1 Output\New System\Converted Data\',caseNum,'_AIM1.mat');
    load(loadName);
    loadName=strcat('C:\Users\Xinyu Li\Google Drive\R01 RFID project\AIM1\AIM 1 Output\New System\Converted Data\',caseNum,'_AIM2.mat');
    load(loadName);
    loadName=strcat('C:\Users\Xinyu Li\Google Drive\R01 RFID project\AIM1\AIM 1 Output\New System\Converted Data\',caseNum,'_AIM3.mat');
    load(loadName);
    loadName=strcat('C:\Users\Xinyu Li\Google Drive\R01 RFID project\AIM1\AIM 1 Output\New System\Converted Data\',caseNum,'_ZoneAIM1.mat');
    load(loadName);
    
    AIM3=processedAIM3;
    AIM2=processedAIM2;
    AIM1=processedAIM1;
%     zoneAIM1=ZoneAIM1;
    
    %remove the unnecessary medical phase
    AIM3(2,:)=[];
    AIM3(6,:)=[];
    AIM2(8,:)=[];
    
    for i=1:size(AIM1,2)
        % extract object use combination
        objectuseComb=zeros(1,11);
        index=find(AIM1(:,i)>0);
        objectuseComb(index)=1;
        clear index;
        
        % extract medical phase
        medicalPhase=0;
        index=find(AIM3(:,i)==1);
        if(~isempty(index))
            medicalPhase=index(1);
        end
        clear index;
        
        % extract position of eight zone
        zoneTmp=zeros(1,8);
        for ii=1:8
            if (~isempty(find(zoneAIM1(:,i)==ii)))
                zoneTmp(ii)=1;
            end
        end
        
        % extract activity ground truth
        activities=zeros(1,10);
        index=find(AIM2(:,i)>0);
        activities(index)=1;
        clear index;
        
        % put zone (1-8), phase (9), object use(10-20), and ground truth(21-30)
        featureTmp=[zoneTmp,medicalPhase,objectuseComb,activities];
        feature=[feature;featureTmp];
    end
    clear AIM3;     clear AIM2;     clear AIM1; clear zoneAIM1;
    clear featureTmp;
end

FILENAME=strcat(pwd,'\featureFromGroundTruth_ALL.csv');
csvwrite(FILENAME,feature);