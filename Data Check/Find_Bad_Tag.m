%% this is the main function to find the bad tags

%% 
close all
clear all
clc

Working_Path = pwd;
folderpath=strcat(pwd,'\Ori_Data\');
files=dir(folderpath);

ALL=[];
% check all the files and find bad tags
for i=length(files):length(files)
     filename=strcat(folderpath,files(i).name);
    TAG=Ori_Check(filename);
    
    ALL=[ALL;TAG];
end

[Badtags, ia, ic] = unique(ALL);
TAG_List=zeros(length(Badtags),2);

for i=1:length(Badtags)
    TAG_List(i,1)=length(find(ic==ic(ia(i))));
end

% check all the files and find all tags
ALLSET=[];
for i=3:length(files)
     filename=strcat(folderpath,files(i).name);
    TAG=ALL_Tags(filename);
    
    ALLSET=[ALLSET;TAG];
end

[Alltags, ia, ic] = unique(ALLSET);
[lia1,locb1] = ismember(ALLSET,Badtags);
for i=1:length(Badtags)
    ind=length(find(locb1==i));
    TAG_List(i,2)=ind;
end