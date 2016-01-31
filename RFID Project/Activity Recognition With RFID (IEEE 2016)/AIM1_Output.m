%% The code is used to etract frames from video
clear all
close all
clc

%%
directory_name = strcat(pwd,'\AIM1\');
files = dir(directory_name);

[~,Obj_Name] = xlsread('Object_List.xlsx','A1:A11');

timestatic=[];
for i=3:length(files)
    filename=strcat(directory_name,files(i).name);
    fprintf('Processing file: %s \n', files(i).name);
    timestatic_tmp=fetchGroundTruth(filename,Obj_Name);
    if (i==3)
        timestatic=timestatic_tmp;
    else
        if (size(timestatic_tmp,2)>=size(timestatic,2))
            timestatic=[(timestatic+timestatic_tmp(:,1:size(timestatic,2))),timestatic_tmp(:,size(timestatic,2):size(timestatic_tmp,2))];
        else
            timestatic=[(timestatic_tmp+timestatic(:,1:size(timestatic_tmp,2))),timestatic(:,size(timestatic_tmp,2):size(timestatic,2))];
        end
    end
    
    clear timestatic_tmp;
end

maxcount=max(max(timestatic));

for i=1:11
    max_tmp=max(timestatic(i,:));
    offset=maxcount/max_tmp;
    
    timestatic_Normalized(i,:)=timestatic(i,:).*offset;
end