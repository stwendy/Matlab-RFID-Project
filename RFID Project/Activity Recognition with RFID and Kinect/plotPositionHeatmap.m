%% Check Position heatmap for different phase

%%
close all
clear all
clc

%%
    dirName='C:\Users\Xinyu Li\Google Drive\R01 RFID project\AIM1\AIM 1 Output\New System\';
    files=dir(fullfile(dirName,'*.xlsx'));
    
AIM3=[];
positionStatisticsHeatmap=zeros(600,600,7);
numberOfID=zeros(length(files),7);
    
for f=1:length(files)
    fileName=strcat(dirName,files(f).name);
    caseNum=files(f).name(12:length(files(f).name)-5);
    fprintf('Processing file %s ...\n',caseNum);
    loadName=strcat('C:\Users\Xinyu Li\Google Drive\R01 RFID project\AIM1\AIM 1 Output\New System\Converted Data\',caseNum,'_AIM3.mat');
    load(loadName);
    
    % load position file
    positionFilename=strcat('C:\Users\Xinyu Li\Google Drive\R01 RFID project\AIM1\Kinect Data\Position\',caseNum,'.txt');
    fileID = fopen(positionFilename); 
    positionTmp=textscan(fileID,'%s','Delimiter','\n');
    fclose(fileID);
    position=positionTmp{1};
    
    [~,remain] = strtok(position{1}, ',');
    [strPositionStartTime,~] = strtok(remain, ',');
    strPositionStartTime=strcat(strPositionStartTime,':00');
    positionStartTime=str2time(cellstr(strPositionStartTime));
    
    %find time zero and calculate time offset
    timeZeroFilename=strcat('timeZero.txt');
    fileID = fopen(timeZeroFilename); 
    timeZeroTmp=textscan(fileID,'%s','Delimiter','\n');
    fclose(fileID);
    timeZero=timeZeroTmp{1};
    
    for tt=1:length(timeZero)
        [key,remain] = strtok(timeZero{tt});
        if (strcmp(key,caseNum))
            strCodingStartTime=strcat(remain,':00');
            codingStartTime=str2time(cellstr(strCodingStartTime));
            syncOffset(f)=(codingStartTime-positionStartTime);
            break;
        end
    end
    
    % load position file and process position information
    fid = fopen(positionFilename);
    info = textscan(fid, '%s %s %f %f ','delimiter',',');
    fclose(fid);

    id=info{1};
    time=info{2};
    xCoordinate=ceil(info{3}+300);
    yCoordinate=ceil(info{4});
    peopleID=str2Double(id);
    positionTime=time2Second(time,syncOffset(f));
    
    % plot phase images
    for phase=1:size(processedAIM3,1)
        phaseTime=find(processedAIM3(phase,:));
        index=find(positionTime>min(phaseTime) & positionTime<max(phaseTime));
        phaseLength=max(phaseTime)-min(phaseTime)+1;

        for ii=1:length(index)
            if (xCoordinate(index(ii)) >0 && xCoordinate(index(ii)) <=600 && yCoordinate(index(ii)) >0 && yCoordinate(index(ii)) <=600)
                positionStatisticsHeatmap(xCoordinate(index(ii)),yCoordinate(index(ii)),phase)=positionStatisticsHeatmap(xCoordinate(index(ii)),yCoordinate(index(ii)),phase)+1;
            end
        end
        
        positionStatisticsHeatmap(:,:,phase)=positionStatisticsHeatmap(:,:,phase)./phaseLength;
        
        % Calculate the average ID number in each phase
        tmp=length(unique(peopleID(index)));
        numberOfID(f,phase)=tmp./phaseLength;
    end
    
    % Calculate the velocity changes 
    
    
end


%% plot distribution
medicalPhase={'Pre-Arrival','Pt arrival','Pre-Primary','Primary','Secondary','Post-Secondary','Pt departure'};
for i=1:size(positionStatisticsHeatmap,3)
    figure(1)
    subplot(3,3,i);
    temp=imresize(positionStatisticsHeatmap(:,:,i),[60,60]);
    temp=imgaussfilt(temp,4);
    normTmp = temp - min(temp(:));
    temp = normTmp ./ max(normTmp(:));
    imagesc(flipud(temp));
    ax = gca;
    ax.XTickLabel = {'1','2','3','4','5','6'};
    ax.YTickLabel = {'6','5','4','3','2','1'};
end