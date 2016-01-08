%This is the main file to test the data collected in the hospital 
close all
clear all
clc

%% 
dir='C:\Users\Xinyu Li\Google Drive\R01 RFID project\AIM1\Kinect Data\RFID\';
file='160104.txt';
filename=strcat(dir,file);

fid = fopen(filename);
Info = textscan(fid, '%s %d %s %f %f %f %f','delimiter',',');
fclose(fid);

% Extract the data
timeStamp=Info{7}-Info{7}(1);
readerNumber=Info{1};
tagID=Info{3};
portNumber=Info{2};
RSS=Info{4};
Phase=Info{5};
Doppler=Info{6};
% Find_Time=Info{6};

Duration=ceil(max(timeStamp)/1000);
Hour=floor(Duration/(3600*1000));
Minute= floor((Duration-Hour*3600*1000)/(1000*60));
Second=floor((Duration-Hour*3600*1000-Minute*60*1000)/1000);
fprintf('The recorded data file lasts for %d: %d: %d \n',Hour,Minute,Second);

%%

% Find the unique tag id
uniqueID=unique(tagID);
% Cut tag ID with 4 digits
for i=1:length(uniqueID)
    LL=length(uniqueID{i});
    uniqueID{i}=uniqueID{i}(LL-3:LL);
end

% Fetch all the RFID data into matrix in ms
windowSize=1000;
Step=1000;

rfidData=zeros(length(uniqueID),Duration);
dopplerFrequencyShiftData=zeros(length(uniqueID),Duration);
readingRate=zeros(size(rfidData,1),ceil(Duration/1000));

for i=1:length(timeStamp)
    LL=length(tagID{i});
    last4Digits=tagID{i}(LL-3:LL); 
    
    % find the row of data
    searchResult=ismember(uniqueID,last4Digits);
    [row,~,~]=find(searchResult);
    
    % find the column of the data
    col=floor(timeStamp(i)/1000000)+1;
    readingRate(row,col)=readingRate(row,col)+1;
    
    if (rfidData(row,floor(timeStamp(i)/1000)+1)==0)
        dopplerFrequencyShiftData(row,floor(timeStamp(i)/1000)+1)=Doppler(i);
        rfidData(row,floor(timeStamp(i)/1000)+1)=RSS(i);
    else
        dopplerFrequencyShiftData(row,floor(timeStamp(i)/1000)+1)=max(dopplerFrequencyShiftData(row,floor(timeStamp(i)/1000)+1),Doppler(i));
        rfidData(row,floor(timeStamp(i)/1000)+1)=(rfidData(row,floor(timeStamp(i)/1000)+1)+RSS(i))/2;
    end
end

% Calculate RSS for every second
rfidDataS=zeros(size(rfidData,1),ceil(Duration/1000));
dopplerFrequencyShiftDataS=zeros(size(rfidData,1),ceil(Duration/1000));
for obj=1:size(rfidData,1)
    for t=1:ceil((size(rfidData,2)-windowSize)/1000)
        tmpRFID=rfidData(obj,1+(t-1)*1000:(t-1)*1000+windowSize);
        [~,~,v]=find(tmpRFID);
        if (length(v)>0)
            rfidDataS(obj,t)=mean(v);
        else
            rfidDataS(obj,t)=-100;
        end
        
        tmpDoppler=dopplerFrequencyShiftData(obj,1+(t-1)*1000:(t-1)*1000+windowSize);
        [~,~,v]=find(tmpDoppler);
        if (length(v)>0)
            dopplerFrequencyShiftDataS(obj,t)=mean(v);
        else
            dopplerFrequencyShiftDataS(obj,t)=0;
        end
    end
end

kk=0;

% stop here
