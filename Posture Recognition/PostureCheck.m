%This is the main file to test the data collected in the hospital 
close all
clear all
clc

%% 
directory='C:\Users\Xinyu Li\Google Drive\R01 RFID project\AIM1\Kinect Data\Activity\';
file='151231.txt';
filename=strcat(directory,file);

fid = fopen(filename);
info = textscan(fid, '%s %s %s','delimiter',',');
fclose(fid);

%%
activity=info{1};
time=info{2};
status=info{3};
[activityStartTime,timeInSecond]=time2Second(time);
timeInSecond=timeInSecond+1;
timeMax=max(timeInSecond);
numStatus=status2double(status);
numActivity=activity2double(activity);

%%
activityRecognition=zeros(3,timeMax);
for i=1:length(numActivity)
    if (numStatus(i)>activityRecognition(numActivity(i),timeInSecond(i)))
        activityRecognition(numActivity(i),timeInSecond(i))=numStatus(i);
    end
end