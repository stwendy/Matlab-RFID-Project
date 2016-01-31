

%% -------------------------------------------------------------------------------
clear all
close all
clc

%% -------------------------------------------------------------------------------
%  Pre-processing data and save them
% -------------------------------------------------------------------------------
% comment this if the AIM1 data is already extracted
% ConvertAIM1Data();


% comment this if the AIM2 data is already extracted
% ConvertAIM2Data();

%% -------------------------------------------------------------------------------
% Load data from mat file and generate training and testing data
% -------------------------------------------------------------------------------

% Uncomment if you want to reextract AIM1 AIM2 data file
% clear all
% close all
% clc
% 
% directory_name = strcat(pwd,'\AIM1\');
% files = dir(directory_name);
% 
% % put data and groundtruth together
% AIM1AIM2=[];
% for i=3:length(files)
%     casenum=files(i).name(12:17);
%     tmp=combineAIM1AIM2(casenum);
%     AIM1AIM2=[AIM1AIM2;tmp];
% end
% 
% %Save the extracted data file
% filename=strcat('AIM1AIM2.mat');
% save(filename,'AIM1AIM2')

%% -------------------------------------------------------------------------------
% Random data and generate trainning and testing data files
% -------------------------------------------------------------------------------
% clear all
% close all
% clc
% 
% 
% filename=strcat('AIM1AIM2.mat');
% load(filename);
% 
% index=randperm(size(AIM1AIM2,1));
% trainIndex=index(1:ceil(0.7*length(index)));
% testIndex=index(ceil(0.7*length(index))+1:length(index));
% 
% Train=AIM1AIM2(trainIndex,:);
% Test=AIM1AIM2(testIndex,:);
% 
% 
% FILENAME=strcat(pwd,'\AIM1AIM2_Train.csv');
% csvwrite(FILENAME,Train);
% 
% FILENAME=strcat(pwd,'\AIM1AIM2_Test.csv');
% csvwrite(FILENAME,Test);
% 
% filename=strcat('trainIndex.mat');
% save(filename,'trainIndex')
% filename=strcat('testIndex.mat');
% save(filename,'testIndex')

%% -------------------------------------------------------------------------------
% Generate related AIM1 feature for trainning and testing
% -------------------------------------------------------------------------------

% clear all
% close all
% clc
% 
% 
% directory_name = strcat(pwd,'\raw\');
% files = dir(directory_name);
% 
% % put AIM1 feature data and groundtruth together
% AIM1=[];
% for i=3:length(files)
%     casenum=files(i).name(1:6);
%     tmp=getAIM1Feature(casenum);
%     AIM1=[AIM1;tmp];
% end
% 
% filename=strcat('AIM1.mat');
% save(filename,'AIM1')
% 
% % Load test and train index
% filename=strcat('AIM1.mat');
% load(filename);
% filename=strcat('trainIndex.mat');
% load(filename);
% filename=strcat('testIndex.mat');
% load(filename);
% 
% trainAIM1=AIM1(trainIndex,:);
% testAIM1=AIM1(testIndex,:);
% 
% FILENAME=strcat(pwd,'\AIM1_Train.csv');
% csvwrite(FILENAME,trainAIM1);
% 
% FILENAME=strcat(pwd,'\AIM1_Test.csv');
% csvwrite(FILENAME,testAIM1);


%% -------------------------------------------------------------------------------
% Generate AIM2 Testing data based on AIM1 predicitons
% -------------------------------------------------------------------------------
close all
clear all
clc

load('probAIM1.mat');
load('thresholdAIM1.mat');
predAIM1=probAIM1;
for i=1:length(thresholdAIM1)
    index=find(predAIM1(:,i)>=thresholdAIM1(i));
    predAIM1(index,i)=1;
    predAIM1(:,i)=floor(predAIM1(:,i));
end

% generate AIM1AIM2 testing data
load('AIM1AIM2.mat');
filename=strcat('testIndex.mat');
load(filename);
Synced=AIM1AIM2(testIndex,12:22);

predAIM1=[predAIM1,Synced];
FILENAME=strcat(pwd,'\predAIM1.csv');
csvwrite(FILENAME,predAIM1);