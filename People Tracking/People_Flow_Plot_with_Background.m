%% Author Xinyu Li
% The script is used to plot location of people recorded by RFID system in
% code room 1 dynamically. with height view background

%% 
clear all
close all
clc

%% Load file and establish timeline
dirctory='C:\Users\Xinyu Li\Google Drive\R01 RFID project\AIM1\Kinect Data\Position\';
file='151213.txt';
filename=strcat(dirctory,file);
fprintf('Now working on file: %s \n',filename);

fid = fopen(filename);
info = textscan(fid, '%s %s %f %f ','delimiter',',');
fclose(fid);

id=info{1};
time=info{2};
xCoordinate=info{3};
yCoordinate=info{4};

peopleID=str2Double(id);
[positionStartTime,timeInSecond]=time2Second(time);
timeInSecond=timeInSecond+1;
uniqueID=unique(peopleID);

% load background directory
bgImages=dir('C:\Users\Xinyu Li\Google Drive\R01 RFID project\AIM1\Kinect Data\1-3-2016_21-16-55\*.png');
% calculate the first time for background
bgStartTime=getBGStartTime(bgImages);
timeDiff=bgStartTime-positionStartTime;
% Update the background with following interval
updateCoefficient=10+timeDiff;
%% Generate Motion Video
timeMax=max(timeInSecond);
% minX=min(xCoordinate);
% maxX=max(xCoordinate);
% minY=min(yCoordinate);
% maxY=max(yCoordinate);
minX=-50;
maxX=650;
minY=0;
maxY=500;


peopleLocation=cat(3,zeros(timeMax,length(uniqueID)),zeros(timeMax,length(uniqueID)));

% setup video writer
motionVideo = VideoWriter('C:\Users\Xinyu Li\Desktop\Test.avi');
open(motionVideo);

% setupp color for people
colorMap=['c','m','w','y','r','g','b'];
colorForPeople=zeros(1,7);

% Generate people's location in single second
for t=1:timeMax
    for p=1:length(uniqueID)
        index=find(peopleID==uniqueID(p) & timeInSecond==t);
        if (~isempty(index))
            peopleLocation(t,p,1)=mean(xCoordinate(index));
            peopleLocation(t,p,2)=mean(yCoordinate(index));
        end
    end  
end

% Generate Frames and use differnt color for different ID

count=1;
load('Background.mat');
% tmpBG=imread(strcat('C:\Users\Xinyu Li\Google Drive\R01 RFID project\AIM1\Kinect Data\1-3-2016_21-16-55\',bgImages(count).name));
for t=1:timeMax
   figureToPlot=figure(1);
   if (mod(t,updateCoefficient)==0)
%        BG=flipud(fliplr(tmpBG));
%        imshow(BG(1:450,251:800));
        imshow(BG);
       hold on
       count=count+1;
   else
 
%        tmpBG=imread(strcat('C:\Users\Xinyu Li\Google Drive\R01 RFID project\AIM1\Kinect Data\1-3-2016_21-16-55\',bgImages(count).name));
%        BG=flipud(fliplr(tmpBG));
%        imshow(BG(1:450,251:800));
        imshow(BG);
       hold on
   end
   
   % Reset the unused colors
   if (t>1)
       resetIndex=find(peopleLocation(t-1,:,1)~=0 & peopleLocation(t,:,1)==0);
       if (~isempty(resetIndex))
           for tmp=1:length(resetIndex)
                colorForPeople(find(colorForPeople==resetIndex(tmp)))=0;
           end
       end
   end
   
%    rectangle('Position',[-100 205 130 70],'FaceColor','y');
%    axis([minX,maxX,minY,maxY]);
   indexP=find(peopleLocation(t,:,1));
   axis([minX,maxX,minY,maxY]);
   for p=1:length(indexP)
       % find a usable color if there is no color assigned to the people
       if(isempty(find(colorForPeople==indexP(p))))
            indexColorNotUsed=find(colorForPeople==0);
            colorForPeople(indexColorNotUsed(1))=indexP(p);
       end
       
       % Plot figure with given color
       colorIndex=find(colorForPeople==indexP(p));
       cmd=strcat('o',colorMap(colorIndex));
       xtmp=150-peopleLocation(t,indexP(p),1);
       ytmp=abs(450-peopleLocation(t,indexP(p),2));
       plot(xtmp,ytmp,cmd,'MarkerFaceColor',colorMap(colorIndex),'MarkerSize',10);
       axis([minX,maxX,minY,maxY]);
   end
   
   imagePath=strcat(pwd,'\tmp.jpg');
   saveas(figureToPlot,imagePath)
   fprintf('Frame %d is written into file \n',t);
   clf(figureToPlot,'reset');
   
   % write current frame to video
   frameCurrent=imread(imagePath);
   for re=1:10
    writeVideo(motionVideo,frameCurrent);
   end
end
close all
close(motionVideo)
disp('ALL DONE! ')