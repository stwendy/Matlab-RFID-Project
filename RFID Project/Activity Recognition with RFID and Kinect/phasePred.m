%% 
% this function is used to visulize flow  distribution wtih recorde psition
% files every step seconds
clear all
close all
clc

%% Choose phase for predicition and use rest for training
nn=7;
dirName='C:\Users\Xinyu Li\Google Drive\R01 RFID project\AIM1\AIM 1 Output\New System\';
files=dir(fullfile(dirName,'*.xlsx'));
side=60;
caseNum=files(nn).name(12:length(files(nn).name)-5);
% positionStatisticsHeatmap=phaseTrain(nn);

% Load saved data files 
positionFilename=strcat('C:\Users\Xinyu Li\Google Drive\R01 RFID project\AIM1\Kinect Data\Position\',caseNum,'.txt');
load(strcat('C:\Users\Xinyu Li\Google Drive\R01 RFID project\AIM1\AIM 1 Output\New System\Converted Data\',caseNum,'_AIM3.mat'));
load(strcat('C:\Users\Xinyu Li\Google Drive\R01 RFID project\AIM1\AIM 1 Output\New System\Converted Data\offset.mat'));
load('Tmp.mat')

fid = fopen(positionFilename);
info = textscan(fid, '%s %s %f %f ','delimiter',',');
fclose(fid);

id=info{1};
time=info{2};
xCoordinate=ceil(info{3}+300);
yCoordinate=ceil(info{4});
peopleID=str2Double(id);
positionTime=time2Second(time,syncOffset(nn));

%% estimate pt arrival and pt leave phase
% Flag=zeros(max(positionTime),1);
% for i=max(min(positionTime,1)):max(positionTime)
%     index=find(positionTime==i );
%    if (isempty(index))
%        Flag(i)=1;
%    elseif(isempty(find(xCoordinate(index) >0 & xCoordinate(index) <=600 & yCoordinate(index) >0 & yCoordinate(index) <=600)))
%        Flag(i)=1;
%    end
%    clear index;
% end

%% visulize every 1 minutes
step=25;
time=step;
count=1;
positionHeatmap=zeros(600,600,max(positionTime)-step+1);
coorelationTime=zeros(size(Tmp,3),max(positionTime));

while (time<max(positionTime))
    if (isempty(find(positionTime==time)))
        Flag(time)=1;
    else
    end
    
    index=find(positionTime>time-step & positionTime<=time);
    time=time+1;
    
    % Calculate heatmap 
    for ii=1:length(index)
            if (xCoordinate(index(ii)) >0 && xCoordinate(index(ii)) <=600 && yCoordinate(index(ii)) >0 && yCoordinate(index(ii)) <=600)
                positionHeatmap(xCoordinate(index(ii)),yCoordinate(index(ii)),count)=positionHeatmap(xCoordinate(index(ii)),yCoordinate(index(ii)),count)+1;
            end
    end
    
    % pre-process    
    temp=imgaussfilt(positionHeatmap(:,:,count),5);
    temp=temp./step;
    temp=imresize(temp,[side side]);
    normTmp = temp - min(temp(:));
    temp =flipud( normTmp ./ max(normTmp(:)));

    % Calculate the similiarty of people flow
    for l=1:size(Tmp,3)

        coorelationTime(l,count)=abs(corr2(temp,Tmp(:,:,l)));
    end
    fprintf('processing frame: %d\n',count);
    clear index   
    count=count+1;
end


%% make prediciton
for i=1:7
    coorelationTime(i,:)=smooth(coorelationTime(i,:),step);
end
coorelationTime(:,size(coorelationTime,2)-step+1:size(coorelationTime,2))=[];
coorelationTime=[zeros(7,step),coorelationTime];
duration=min(size(processedAIM3,2),max(positionTime));
prediction=zeros(size(coorelationTime,1),(size(coorelationTime,2)));
for i=1:size(coorelationTime,2)-1
    [value,maxTmp]=max(coorelationTime(:,i));
    prediction(maxTmp,i)=1;  
end

figure
subplot(311)
imagesc(processedAIM3([1,3,4,5,6],1:duration));
subplot(312)
imagesc(coorelationTime([1,3,4,5,6],1:duration));
subplot(313)
imagesc(prediction([1,3,4,5,6],1:duration));

%% Evaluation
TTT=zeros(1,duration);
GT=zeros(1,duration);
for i=1:7
    TTT=prediction(i,1:duration).*i+TTT;
    GT=processedAIM3(i,1:duration).*i+GT;
end
TT=ceil(smooth(TTT,step));
