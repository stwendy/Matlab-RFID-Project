%% Check Position heatmap for different phase
clear all
close all
clc


% function positionStatisticsHeatmap=phaseTrain(caseNumber)
caseNumber=0;

dirName='C:\Users\Xinyu Li\Google Drive\R01 RFID project\AIM1\AIM 1 Output\New System\';
files=dir(fullfile(dirName,'*.xlsx'));
    
AIM3=[];
positionStatisticsHeatmap=zeros(600,600,7);
positionStatisticsHeatmapTmp=zeros(600,600,7);
phaseLength=zeros(1,7);
numberOfID=zeros(length(files),7);
    
for f=1:length(files)
    if (f~=caseNumber)
        fileName=strcat(dirName,files(f).name);
        caseNum=files(f).name(length(files(f).name)-10:length(files(f).name)-5);
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
            phaseLengthTmp(phase)=max(phaseTime)-min(phaseTime)+1;

            for ii=1:length(index)
                if (xCoordinate(index(ii)) >0 && xCoordinate(index(ii)) <=600 && yCoordinate(index(ii)) >0 && yCoordinate(index(ii)) <=600)
                    positionStatisticsHeatmapTmp(yCoordinate(index(ii)),xCoordinate(index(ii)),phase)=positionStatisticsHeatmapTmp(yCoordinate(index(ii)),xCoordinate(index(ii)),phase)+1;
                end
            end
    
            phaseLength(phase)=phaseLength(phase)+phaseLengthTmp(phase);
            positionStatisticsHeatmap(:,:,phase)=positionStatisticsHeatmap(:,:,phase)+positionStatisticsHeatmapTmp(:,:,phase);
            phaseLengthTmp=phaseLengthTmp.*0;
            positionStatisticsHeatmapTmp=positionStatisticsHeatmapTmp.*0;
        end
        
    end
end

% Normalize for scale
for i=1:size(positionStatisticsHeatmap,3)
    temp=imgaussfilt(positionStatisticsHeatmap(:,:,i),5);
    temp=temp./phaseLength(i);
    temp=imresize(temp,[60 60]);
    normTmp = temp - min(temp(:));
%     positionStatisticsHeatmap(:,:,i) =flipud( normTmp ./ max(normTmp(:)));
    Tmp(:,:,i) =flipud( normTmp ./ max(normTmp(:)));
    figure(1)
    subplot(3,3,i)
    imagesc(Tmp(:,:,i));hold on
    rectangle('Position',[3 6 4 2],'EdgeColor','r','LineWidth',1);
end

% return