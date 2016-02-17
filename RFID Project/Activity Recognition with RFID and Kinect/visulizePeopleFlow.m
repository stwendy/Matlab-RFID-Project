%% 
% this function is used to visulize flow  distribution wtih recorde psition
% files every step seconds
clear all
close all
clc

%%
dirName='C:\Users\Xinyu Li\Google Drive\R01 RFID project\AIM1\AIM 1 Output\New System\';
files=dir(fullfile(dirName,'*.xlsx'));
nn=2;
caseNum=files(nn).name(12:length(files(nn).name)-5);

positionFilename=strcat('C:\Users\Xinyu Li\Google Drive\R01 RFID project\AIM1\Kinect Data\Position\',caseNum,'.txt');
loadName=strcat('C:\Users\Xinyu Li\Google Drive\R01 RFID project\AIM1\AIM 1 Output\New System\Converted Data\positionStatisticsHeatmap.mat');
load(strcat('C:\Users\Xinyu Li\Google Drive\R01 RFID project\AIM1\AIM 1 Output\New System\Converted Data\',caseNum,'_AIM3.mat'));
load(strcat('C:\Users\Xinyu Li\Google Drive\R01 RFID project\AIM1\AIM 1 Output\New System\Converted Data\offset.mat'));

load(loadName);
fid = fopen(positionFilename);
info = textscan(fid, '%s %s %f %f ','delimiter',',');
fclose(fid);

id=info{1};
time=info{2};
xCoordinate=ceil(info{3}+300);
yCoordinate=ceil(info{4});
peopleID=str2Double(id);

positionTime=time2Second(time,syncOffset(nn));

%% visulize every 1 minutes
step=60;
time=0;
count=1;
positionHeatmap=zeros(600,600,ceil(max(positionTime)/step)+1);
coorelationTime=zeros(size(positionStatisticsHeatmap,3),ceil(max(positionTime)/step)+1);
while (time<max(positionTime))
    index=find(positionTime>time & positionTime<=time+step);
    time=time+step;
    
    % Calculate heatmap every 1 minute
    for ii=1:length(index)
            if (xCoordinate(index(ii)) >0 && xCoordinate(index(ii)) <=600 && yCoordinate(index(ii)) >0 && yCoordinate(index(ii)) <=600)
                positionHeatmap(xCoordinate(index(ii)),yCoordinate(index(ii)),count)=positionHeatmap(xCoordinate(index(ii)),yCoordinate(index(ii)),count)+1;
            end
    end
    
    % pre-process
    temp=imresize(positionHeatmap(:,:,count),[60,60]);
    temp=imgaussfilt(temp./step,4);
    normTmp = temp - min(temp(:));
    temp = normTmp ./ max(normTmp(:));
    temp=flipud(temp);
    
    % Calculate the similiarty of people flow
    for l=1:size(positionStatisticsHeatmap,3)
        temp_positionStatisticsHeatmap=flipud(imresize(positionStatisticsHeatmap(:,:,l),[60,60]));
        temp_positionStatisticsHeatmap=imgaussfilt(temp_positionStatisticsHeatmap,4);
        normTmp = temp_positionStatisticsHeatmap - min(temp_positionStatisticsHeatmap(:));
        temp_positionStatisticsHeatmap = normTmp ./ max(normTmp(:));
        coorelationTime(l,count)=corr2(temp,temp_positionStatisticsHeatmap);
    end
    
    clear index
    figure(1)
    
    imagesc(temp);
    ax = gca;
    ax.XTickLabel = {'1','2','3','4','5','6'};
    ax.YTickLabel = {'6','5','4','3','2','1'};
    
    count=count+1;
end


%% make prediciton
for i=1:7
    coorelationTime(i,:)=smooth(coorelationTime(i,:),5);
end

duration=min(size(processedAIM3,2),max(positionTime));
prediction=zeros(size(coorelationTime,1),(size(coorelationTime,2)-1)*step);
for i=1:size(coorelationTime,2)-1
    [~,maxTmp]=max(coorelationTime(:,i));
    prediction(maxTmp,(i-1)*step+1:i*step)=1;  
end

figure
subplot(311)
imagesc(processedAIM3(:,1:duration));
subplot(312)
imagesc(coorelationTime);
subplot(313)
imagesc(prediction(:,1:duration));

%% Evaluation

