% This is for the obj use analysis for data file 150734

close all
clear all
clc
format long g; 
fid = fopen('150734.txt');
Info = textscan(fid, '%f %s %s %d %f %f','delimiter', ' ');
fclose(fid);

% Extract the data
Time_Stamp=Info{1}-Info{1}(1)+1;
IP=Info{2};
Tag_ID=Info{3};
Antenna_Num=Info{4};
RSSI=Info{5};
% Find_Time=Info{6};

[Segement,ia,ic] = unique(Tag_ID) ;

Duration=max(Time_Stamp)-min(Time_Stamp);
Hours=floor(Duration/3600000);
Minutes=floor((Duration-Hours*3600000)/60000);
Seconds=floor((Duration-Hours*3600000-Minutes*60000)/1000);
fprintf('The recording lasts for %d hours, %d minutes, %d seconds.\n',Hours,Minutes,Seconds);

xls_Path=strcat(pwd,'\Hash Table.xlsx');
[~,Hash_Table] = xlsread(xls_Path, 'Sheet1', 'B1:Gk48');
[~,Obj_Name] = xlsread(xls_Path, 'Sheet1', 'A1:A48');

% sync data time diff is 12min37sec=757sec=757000ms 
% end time is 19:30:55=1170055

ID=cell(1,1);
RAW=[];
count=0;
for i=1:length(Time_Stamp)
    if (Time_Stamp(i)<=757000 || Time_Stamp(i)>757000+1170055)
        % Ignore this data
    else
        ID_tmp=Tag_ID{i};
        LL=length(ID_tmp);
        if (LL>4)
            Last4Digits=ID_tmp(LL-3:LL);
            
            % find realted obj
            Hash_Map_Temp=ismember(Hash_Table,Last4Digits);
            [row,col,~]=find(Hash_Map_Temp);
            if (isempty(row))
%                 disp(Last4Digits);
            elseif (strcmp(Obj_Name{row(1)},'Otoscope') || strcmp(Obj_Name{row(1)},'BP Bulb') || strcmp(Obj_Name{row(1)},'Opthalmoscope') || ...
                     strcmp(Obj_Name{row(1)},'BP Cuff - Child') || strcmp(Obj_Name{row(1)},'BP Cuff - Adult') || strcmp(Obj_Name{row(1)},'BP Cuff - Infant'))
                 count=count+1;
                ID{count}=Last4Digits;
                RAW=[RAW;Time_Stamp(i),RSSI(i)];
            end            
        end
    end
end

% Time reset
RAW(:,1)=RAW(:,1)-757000;
[Segement,ia,ic] = unique(ID) ;
Max_Time=max(RAW(:,1));

% define each obj
Num_Obj=length(Segement);

Data=zeros(floor(Max_Time./1000)+1,Num_Obj);
for i=1:length(RAW(:,1))
    if (RAW(i,2)>Data(round(RAW(i,1)./1000),ic(i)))
        Data(round(RAW(i,1)./1000),ic(i))=RAW(i,2);
    end
end



Data=Data';
% 1,2,3,4-8,5,6,7,9-10
Target={'Ototscope','Opthalmoscope','BP Cuff - Adult 10 Inside','BP Cuff - Adult 11-1 Inside', ...
                'BP Cuff - Adult 12-1 Inside','BP Cuff - Adult 11-2 Outside','BP Cuff - Adult 11-3 Inside','BP Cuff - Adult 11-1 Outside','BP Cuff - Child 9 Inside','BP Cuff - Child 9 Outside'};

%%  Pre-processing data
for i=1:size(Data,2)-8
    for row=1:size(Data,1)
        Data(row,i)=mean(Data(row,i:i+7));
    end
    if (sum(Data(:,i))==0)
        Data(:,i)=-100;
    end
end

figure(1)
subplot(211)
plot(Data(4,:));
subplot(212)
plot(Data(8,:));

Diff=(Data(4,:)-Data(8,:));
% smooth(Diff,10)
index=find(Diff>500);

Pred=zeros(1,length(Diff));
Pred(index)=1;
GT([273:363,410:416,878:885,974:990,1016:1019,1023:1030,990:1024,1145:1148])=1.1;

figure
plot(Pred);
hold on
plot(GT);


% 
for i=2:length(Pred)
    if (Pred(i)==1 && Pred(i-1)==0 )
        Pred(i:i+7)=1;
    end
end

figure
plot(Pred);
hold on
plot(GT);
