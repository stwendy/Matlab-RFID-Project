%This is the main file to test the data collected in the hospital 
close all
clear all
clc
format long g; 
fid = fopen('Ori_Data\CR1_RFID_2015_12_15_10_25_37.txt');
Info = textscan(fid, '%f %s %s %d %f %f');
fclose(fid);

% Extract the data
Time_Stamp=Info{1}-Info{1}(1);
IP_Address=Info{2};
Tag_ID=Info{3};
Antenna_Num=Info{4};
RSSI=Info{5};
Find_Time=Info{6};

[Segement,ia,ic] = unique(Tag_ID) ;
Duration=max(Time_Stamp)-min(Time_Stamp);
Freq=zeros(1,size(Segement,1));
Ave_RSSI=zeros(1,size(Segement,1));
count=floor(max(Time_Stamp)/5000)+1;
Reading_Rate=zeros(size(Segement,1),count);

for num=1:size(Segement,1)
   Tag_no=Segement{num}; 
   [row,col] = find(strcmp(Tag_ID,Tag_no));
   Freq(1,num)=length(row);
   Ave_RSSI(num)=mean(RSSI(row(1)));
   temp=RSSI(row);
%    hist(temp,300);

    % calculate the reading rate
    if (Tag_no=='0')
        % do nothing
    else
        [row,col] = find(strcmp(Tag_ID,Tag_no));
        Reading_Rate_tmp=Time_Stamp(row);
        
        for i=1:count
             [row_t,col_t] = find(Reading_Rate_tmp>=4000*(i-1) & ...
                                   Reading_Rate_tmp<4000*i);
             Reading_Rate(num,i)=length(row_t);
        end
    end
end

Reading_Rate_ave=mean(Reading_Rate,2);

%% Calculate the lasting time
% Duration=max(Time_Stamp)-min(Time_Stamp);
Hours=floor(Duration/3600000);
Minutes=floor((Duration-Hours*3600000)/60000);
Seconds=floor((Duration-Hours*3600000-Minutes*60000)/1000);

Hours
Minutes
Seconds

%  bar(Reading_Rate_ave)
%  xlabel('tags')
%  ylabel('reading rate')



Sta=sum(Reading_Rate,2);
index=find(Sta<20);

TAG=cell(length(index),1);
count=1;
for i=1:length(index)
    if (length(Segement{index(i)})>2)
        TAG{count}=Segement{index(i)}(21:24);
        count=count+1;
    end
end

xls_Path=strcat(pwd,'\Hash Table.xlsx');
[~,Hash_Table] = xlsread(xls_Path, 'Sheet1', 'B1:Gk48');
[~,Obj_Name] = xlsread(xls_Path, 'Sheet1', 'A1:A48');

Obj_Int=[];
for ii=1:length(Segement)
    if (length(Segement{ii,1})>1)
        Last4Digits=Segement{ii,1}(21:24);

        % find realted obj
        Hash_Map_Temp=ismember(Hash_Table,Last4Digits);
        [row,col,~]=find(Hash_Map_Temp);

        if (isempty(row))
            Segement{ii,1}=strcat('Null_',Last4Digits);
        else
           ObjName=Obj_Name{row(1)};
           Segement{ii,1}=strcat(ObjName,'_',Last4Digits);
           
           if(strcmp(ObjName,'BP Bulb'))
               Obj_Int=[Obj_Int;Reading_Rate(row(1),:)];
           end
        end
    end
end

figure
imagesc(Reading_Rate);
xlabel('time windows (5 seconds/unit)');
ylabel('tags')
set(gca, 'Ytick', 1:length(Segement), 'YtickLabel', Segement);

colorbar
% figure
% imagesc(Obj_Int);
% colorbar


Hours*3600+Minutes*60+Seconds
% figure
% subplot(211)
% imagesc(Reading_Rate(:,1:500));
% subplot(212)
% imagesc(Reading_Rate(:,1500:2000));