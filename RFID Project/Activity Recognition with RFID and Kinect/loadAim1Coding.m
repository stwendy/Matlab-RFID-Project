% Extract ground truth from new coding

%%
clear all
close all
clc

%%

% load files in the folder
    dirName='C:\Users\Xinyu Li\Google Drive\R01 RFID project\AIM1\AIM 1 Output\New System\';
    files=dir(fullfile(dirName,'*.xlsx'));

% load activity list
    fileID = fopen('ActivityList.txt'); 
    ActivityTmp=textscan(fileID,'%s','Delimiter','\n');
    fclose(fileID);
    ActivityList=ActivityTmp{1};
  
% load activity list
    fileID = fopen('ObjectList.txt'); 
    ObjectTmp=textscan(fileID,'%s','Delimiter','\n');
    fclose(fileID);
    ObjectList=ObjectTmp{1};

for f=1:length(files)
    fileName=strcat(dirName,files(f).name);
    caseNum=files(f).name(length(files(f).name)-10:length(files(f).name)-5);
    fprintf('Processing case %s ...\n',caseNum);
    
    [~,~,Temp] =xlsread(fileName);
%     Temp(1,:)=[];
    
    startTime=str2time(Temp(:,1));
    endTime=str2time(Temp(:,2));
    Temp(:,1:2)=[];
    Temp=[num2cell(endTime),Temp];
    Temp=[num2cell(startTime),Temp];
    timeMax=max(endTime);

    AIM1=[];
    AIM2=[];
    AIM3=[];
    
    % process AIM1 AIM2 and Phase Data
    for i=1:size(Temp,1)
        if (~isnan(Temp{i,4})) % It is an AIM1 Item
            AIM1=[AIM1;Temp(i,:)];
        elseif (strcmp(Temp{i,3},'Pre-Arrival') || strcmp(Temp{i,3},'Pt arrival') || ...
                    strcmp(Temp{i,3},'Pre-Primary') || strcmp(Temp{i,3},'Primary') || ...
                    strcmp(Temp{i,3},'Secondary') || strcmp(Temp{i,3},'Post-Secondary') || ...
                    strcmp(Temp{i,3},'Pt departure'))
             AIM3=[AIM3;Temp(i,:)]; 
        else
            AIM2=[AIM2;Temp(i,:)]; 
            
        end
    end
    
    % processing AIM3 Data
    processedAIM3=zeros(7,timeMax);
    for i=1:7
        starttmp=AIM3{i,1};
        endtmp=AIM3{i,2};
        processedAIM3(i,starttmp:endtmp)=1;
    end
    saveName=strcat('C:\Users\Xinyu Li\Google Drive\R01 RFID project\AIM1\AIM 1 Output\New System\Converted Data\',caseNum,'_AIM3.mat');
    save(saveName,'processedAIM3');

%     processing AIM2 Data
    processedAIM2=zeros(length(ActivityList),timeMax);
    for i=1:size(AIM2,1)
        % get the key code
        [token,remain] = strtok(AIM2{i,3}, '-');
        [key,remian] = strtok(remain, '-');
        idx = find(strcmp([ActivityList{:}], key));
        [index,~] = find(strcmp(ActivityList,key));
        
        % get time
        starttmp=AIM2{i,1};
        endtmp=AIM2{i,2};
        processedAIM2(index,starttmp:endtmp)=1; 
    end
    saveName=strcat('C:\Users\Xinyu Li\Google Drive\R01 RFID project\AIM1\AIM 1 Output\New System\Converted Data\',caseNum,'_AIM2.mat');
    save(saveName,'processedAIM2');
    
    % processing AIM1 Data
    processedAIM1=zeros(length(ObjectList),timeMax);
    zoneAIM1=zeros(length(ObjectList),timeMax);
    for i=1:size(AIM1,1)
        % get the key code
        key=AIM1{i,3};
        index=find(strncmp(ObjectList, key, 3));
        
        % get time
        starttmp=AIM1{i,1};
        endtmp=AIM1{i,2};
        
        % get the object use type
        if (strcmp(AIM1{i,4},' In Use'))
            processedAIM1(index,starttmp:endtmp)=2; 
            strZone=AIM1{i,7};
            zonetmp=str2double(strZone(length(strZone)));
            zoneAIM1(index,starttmp:endtmp)=zonetmp;
        elseif (strcmp(AIM1{i,4},' In Motion') && strcmp(AIM1{i,8},'Task Related'))
            processedAIM1(index,starttmp:endtmp)=1; 
            strZone=AIM1{i,7};
            zonetmp=str2double(strZone(length(strZone)));
            zoneAIM1(index,starttmp:endtmp)=zonetmp;
        else
            processedAIM1(index,starttmp:endtmp)=-1; 
            strZone=AIM1{i,7};
            zonetmp=str2double(strZone(length(strZone)));
            zoneAIM1(index,starttmp:endtmp)=zonetmp;
        end
    end
    saveName=strcat('C:\Users\Xinyu Li\Google Drive\R01 RFID project\AIM1\AIM 1 Output\New System\Converted Data\',caseNum,'_AIM1.mat');
    save(saveName,'processedAIM1');
    saveName=strcat('C:\Users\Xinyu Li\Google Drive\R01 RFID project\AIM1\AIM 1 Output\New System\Converted Data\',caseNum,'_ZoneAIM1.mat');
    save(saveName,'zoneAIM1');
    
    % processing AIM1 location data
    
    clear AIM1;
    clear AIM2;
    clear AIM3;
    clear zoneAIM1;
end

%%


