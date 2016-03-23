%% generate data for deep learning

close all
clear all
clc

%%
% dirName='C:\Users\Xinyu Li\Google Drive\R01 RFID project\AIM1\AIM 1 Output\New System\Converted Data\RSS\';
% files=dir(fullfile(dirName,'*.mat'));
%     
data=[];
label=[];
% 
% 
% % f=6;
% fileName=strcat(dirName,files(f).name);
% caseNum=files(f).name(1:length(files(f).name)-4);
% fprintf('Processing %s \n',files(f).name);

% load RSS data
load('151227.mat');
RSS=Binary_Antenna;

duration=size(RSS,2);
for i=1:duration
%     dataTmp(i,:)=reshape(imresize(reshape(RSS(:,i,:),[size(RSS,1),size(RSS,3)]),[28,28]),[1,28*28]);
    tt=reshape(RSS(:,i,:),[size(RSS,1),size(RSS,3)]);
    ttRep=[tt(:,12:-1:7),tt,tt(:,6:-1:1)]';
    temp=reshape(ttRep,[1,size(ttRep,1)*size(ttRep,2)]);
    index=find (temp==-100);
        temp(index)=0;
    clear index
    dataTmp(i,:)=temp;
end
data=dataTmp;
% data=ceil(abs([label(:,4),data]));
data=ceil(abs(data));

%% randomly sample 
DD=[];


for ii=5:size(data,1)
    DD=[DD;[reshape([data(ii-4:ii,:)]',[1,5*size(data,2)])]];
end
filename='151227Test.csv';
csvwrite(filename,DD);