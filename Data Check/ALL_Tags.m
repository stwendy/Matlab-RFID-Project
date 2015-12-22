function TAG=ALL_Tags(filename)

%This is the main file to test the data collected in the hospital 
% close all
% clear all
% clc
format long g; 
fid = fopen(filename);
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
   %Ave_RSSI(num)=mean(RSSI(row));
%    temp=RSSI(row);
%    hist(temp,300);

    % calculate the reading rate
    if (Tag_no=='0')
        % do nothing
    else
        [row,col] = find(strcmp(Tag_ID,Tag_no));
        Reading_Rate_tmp=Time_Stamp(row);
        
        for i=1:count
             [row_t,col_t] = find(Reading_Rate_tmp>=5000*(i-1) & ...
                                   Reading_Rate_tmp<5000*i);
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

% Hours
% Minutes
% Seconds

%  bar(Reading_Rate_ave)
%  xlabel('tags')
%  ylabel('reading rate')

% imagesc(Reading_Rate);
% xlabel('time windows (5 seconds/unit)');
% ylabel('tags')
% colorbar

Sta=sum(Reading_Rate,2);
index=find(Sta>=0);
if (length(Segement{index(1)})<2)
    TAG=cell(length(index)-1,1);
else
    TAG=cell(length(index),1);
end

count=1;
for i=1:length(index)
    if (length(Segement{index(i)})>2)
        TAG{count}=Segement{index(i)}(21:24);
        count=count+1;
    end
end