%% generate data for deep learning

close all
clear all
clc

%%
dirName='C:\Users\Xinyu Li\Google Drive\R01 RFID project\AIM1\AIM 1 Output\New System\Converted Data\RSS\';
files=dir(fullfile(dirName,'*.mat'));
    
data=[];
label=[];

for f=1:length(files)
% f=6;
fileName=strcat(dirName,files(f).name);
caseNum=files(f).name(1:length(files(f).name)-4);
fprintf('Processing %s \n',files(f).name);

% load RSS data
load(strcat(dirName,files(f).name));
RSS=Binary_Antenna;

% load GT
load(strcat('C:\Users\Xinyu Li\Google Drive\R01 RFID project\AIM1\AIM 1 Output\New System\Converted Data\',caseNum,'_AIM3.mat'));
GT=processedAIM3;

duration=min(size(GT,2),size(RSS,2));
for i=1:duration
%     dataTmp(i,:)=reshape(imresize(reshape(RSS(:,i,:),[size(RSS,1),size(RSS,3)]),[28,28]),[1,28*28]);
    tt=reshape(RSS(:,i,:),[1,size(RSS,1)*size(RSS,3)]);
    temp=tt;
    index=find (temp==-100);
        temp(index)=0;
    clear index
    dataTmp(i,:)=temp;
    labelTmp(i,:)=GT(:,i)';
end

data=[data; dataTmp];
label=[label;labelTmp];
end

LL=zeros(size(data,1),1);
for i=1:size(label,2)
    index=find(LL==0 & label(:,i)==1);
    LL(index)=i-1;
    clear index;
end


% data=ceil(abs([label(:,4),data]));
data=[LL,ceil(abs(data))];
data=sortrows(data,1);

%% randomly sample 
DD=[];

%%
for i=0:6
    index=find(data(:,1)==i);
        for ii=5:length(index)
            Tmp=data(index(ii)-4:index(ii),2:size(data,2));
            for obj=1:12
                MM(obj,:,:)=reshape(Tmp(1:5,8*(obj-1)+1:8*obj),[1,5,8]);
            end
            DD=[DD;[i,reshape(MM,[1,12*8*5])]];
            fprintf('processing Label: %d, %d out of %d ...\n',i,ii,length(index));
        end
    clear index
end
index=find(DD(:,1)>0);
DD(index,1)=DD(index,1)-1;
clear index;

DDD=[];
for i=0:4
    index=find(DD(:,1)==i);
        ii=randperm(length(index));
        if (length(index)>=500)
            DDD=[DDD;DD(index(ii(1:500)),:)];
        else
            DDD=[DDD;DD(index,:)];
        end
    clear index;
    clear ii;
end



index=find(DDD(:,1)>0);
DDD(index,1)=DDD(index,1)-1;
clear index;


count=0;
for  i=0:4
    figure(1)

    index=find(DDD(:,1)==i);
        Temp=mean(DDD(index,2:size(DDD,2)));
        TT=reshape(Temp,[12,5,8]);
        for channel=1:8
            count=count+1;   
            subplot(5,8,count)
            imagesc(uint8(TT(:,:,channel)),[0,75]);
        end
    clear index;
end

filename='data5sec_12_5_8_AIM3_train.csv';
csvwrite(filename,DDD);


% filename='labelTest.csv';
% csvwrite(filename,label);
