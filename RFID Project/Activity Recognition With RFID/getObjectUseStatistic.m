function getObjectUseStatistic()
close all
clear all
clc


    directory_name = strcat(pwd,'\AIM1\');
    files = dir(directory_name);
    
    GT=[];
    for i=3:length(files)
        casenum=files(i).name(12:17);
        tmp=Get_GroundTruth_Statistics(casenum);
        
        % Align with AIM 2 data
        load(strcat('AIM1_mat\',casenum,'_AIM1.mat'));
        load(strcat('AIM2_mat\',casenum,'_AIM2.mat'));

        Duration=max(size(AIM1Coding,2),size(AIM2Coding,2))
        
        AIM1=zeros(Duration,size(tmp,2));
        AIM1(1:Duration,:)=tmp(1:Duration,:);
        GT=[GT;AIM1];
    end
    
    
    for obj=1:size(GT,2)
        statisicsGT(obj,1)=length(find(GT(:,obj)==1))/length(find(GT(:,obj)>0));
        statisicsGT(obj,2)=length(find(GT(:,obj)==2))/length(find(GT(:,obj)>0));
        statisicsGT(obj,3)=length(find(GT(:,obj)==3))/length(find(GT(:,obj)>0));
    end
    

end


%% -------------------------------------------------------------------------------
% Extract Ground truth
% -------------------------------------------------------------------------------
function GT=Get_GroundTruth_Statistics(case_name)

%% Load Ground Truth data
GT_name=strcat('\AIM1\AIM1Output_',case_name,'.xlsx');
[~,Ground_Truth_xls] = xlsread(GT_name);

% Load Harsh table from excel file into workspace
Hash_Table_Path=strcat(pwd,'\Hash Table 2.xlsx');
[~,Hash_Table] = xlsread(Hash_Table_Path);
[~,Obj_Name] = xlsread(Hash_Table_Path);

Start_Time_ms=zeros(size(Ground_Truth_xls,1),1);
End_Time_ms=zeros(size(Ground_Truth_xls,1),1);
k=1;

% Fetching data from excel into matlab
for  i=2:size(Ground_Truth_xls,1)
    Start_Time_ms(k)=(((str2double(Ground_Truth_xls{i,1}(1:2)))*60+ ... %Hours
                        str2double(Ground_Truth_xls{i,1}(4:5)))*60+ ... %Minutes
                        str2double(Ground_Truth_xls{i,1}(7:8)))*1000+ ... % Seconds
                        str2double(Ground_Truth_xls{i,1}(10:11)); %MS
                    
    End_Time_ms(k)=(((str2double(Ground_Truth_xls{i,2}(1:2)))*60+ ...
                        str2double(Ground_Truth_xls{i,2}(4:5)))*60+ ...
                        str2double(Ground_Truth_xls{i,2}(7:8)))*1000+ ...
                        str2double(Ground_Truth_xls{i,2}(10:11));
    k=k+1;
end

%Generate the Data Matrix
Ground_Truth=zeros(size(Obj_Name,1),max(End_Time_ms));
for  i=2:size(Ground_Truth_xls,1)
    Obj_Name_Tmp=Ground_Truth_xls{i,3};
    for m=1:size(Obj_Name,1)
       if (~isempty(strfind(Obj_Name{m},Obj_Name_Tmp))) 
           if (strcmp(Ground_Truth_xls{i,4},' In Use'))
                Ground_Truth(m,Start_Time_ms(i-1):End_Time_ms(i-1))=1;
           elseif (strcmp(Ground_Truth_xls{i,4},' In Motion') && strcmp(Ground_Truth_xls{i,8},' Task Related'))
                Ground_Truth(m,Start_Time_ms(i-1):End_Time_ms(i-1))=2;
           elseif (strcmp(Ground_Truth_xls{i,4},' In Motion') && strcmp(Ground_Truth_xls{i,8},' Item Removed from Package'))
                Ground_Truth(m,Start_Time_ms(i-1):End_Time_ms(i-1))=2;
           elseif strcmp(Ground_Truth_xls{i,4},' In Motion')
               Ground_Truth(m,Start_Time_ms(i-1):End_Time_ms(i-1))=3;
           end
       end
    end
end

for i=1:size(Ground_Truth,2)/1000+1
    if (i<=size(Ground_Truth,2)/1000)
        Compressed_Ground_Truth(:,i)=floor(sum(Ground_Truth(:,(i-1)*1000+1:i*1000),2)./1000);
    else
        Compressed_Ground_Truth(:,i)=0;
    end
end

GT=Compressed_Ground_Truth';

end