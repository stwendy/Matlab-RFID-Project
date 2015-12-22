%% This is the main file using weka as classifier
% Author: Xinyu Li

%% 
close all
clear all
clc

Working_Path = pwd;
%% Extract features for each data file
Data_Set_Num={'141126','141211','141216','141217','141219','141223','150211' ...
                '150202'};
Data_Set=Data_Set_Num{8};
            
            
load(strcat('Data\',Data_Set,'.mat'));
Time_Stamp=RF{1}-RF{1}(1);
IP_Address=RF{2};
Tag_ID=RF{3};
Antenna_Num=RF{4};
RSSI=RF{5};
[Segement,ia,ic] = unique(Tag_ID);

% Load Harsh table from excel file into workspace
xls_Path=strcat(pwd,'\Hash Table.xlsx');
[~,Hash_Table] = xlsread(xls_Path, 'Sheet1', 'B2:BD50');
[~,Obj_Name] = xlsread(xls_Path, 'Sheet1', 'A2:A50');

Obj_Used=zeros(1,size(Obj_Name,1));
Obj_Not_Used=zeros(1,size(Obj_Name,1));
Obj_Identified=zeros(1,size(Obj_Name,1));
Tag_Not_Identified=zeros(1,size(Obj_Name,1));

for i=1:length(Segement)
    if (~strcmp(Segement{i},'0'))
        Tag_Last_4_Digits=Segement{i}(21:24);
        Hash_Map_Temp=ismember(Hash_Table,Tag_Last_4_Digits);
        [row,col,~]=find(Hash_Map_Temp);

         if (isempty(row))
            Tag_Not_Identified(row)=1;
            Tag_Last_4_Digits
        else
            Obj_Identified(row)=1;
         end
    end
end

xls_Path=strcat(pwd,'\Output\AIM1Output_',Data_Set,'.xls');
[~,Ground_Truth_xls] = xlsread(xls_Path);

for  i=2:size(Ground_Truth_xls,1)
    Obj_Name_Tmp=Ground_Truth_xls{i,3};
    for m=1:size(Obj_Name,1)
       if (~isempty(strfind(Obj_Name{m},Obj_Name_Tmp))) 
           Obj_Used(m)=1;
       else
           Obj_Not_Used(m)=1;
       end
    end
end


%% Print out results
for i=1:size(Obj_Identified,2)
    if (Obj_Used(i)==1 && Obj_Identified(i)==0)
        disp(Obj_Name{i});
    end
end
disp('----------------------------------------------------------------------');
for i=1:size(Obj_Identified,2)
    if (Obj_Used(i)==0 && Obj_Identified(i)==1)
        disp(Obj_Name{i});
    end
end

Static=zeros(1,size(Obj_Name,1));
for i=1:size(Obj_Identified,2)
    if (Obj_Used(i)==1 && Obj_Identified(i)==1)
        Static(i)=1;    %object used and identified
    elseif (Obj_Used(i)==1 && Obj_Identified(i)==0)
        Static(i)=2;    %Object used but not identified
    end
end

Static=Static';


%% Visualize the performance
T_Max=max(Time_Stamp);
RSSI_Vis=zeros(length(Obj_Name),T_Max,8);

for i=1:length(Time_Stamp)
     if (~strcmp(Tag_ID{i},'0'))
        Tag_Last_4_Digits=Tag_ID{i}(21:24);
         Hash_Map_Temp=ismember(Hash_Table,Tag_Last_4_Digits);
        [row,col,~]=find(Hash_Map_Temp);
        if (strcmp(IP_Address{i},'192.168.1.150'))
            RSSI_Vis(row,Time_Stamp(i)+1,Antenna_Num(i)+1)=RSSI(i);
        else
            RSSI_Vis(row,Time_Stamp(i)+1,(Antenna_Num(i)+5))=RSSI(i);
        end
     end
end

RSSI_Vis=sum(RSSI_Vis,3);
RSSI_Visulization=zeros(length(Obj_Name),(floor(size(RSSI_Vis,2)/4000)));

for i=1:floor(size(RSSI_Vis,2)/4000)
    for row=1:length(Obj_Name)
        RSSI_Visulization(row,i)=sum(RSSI_Vis(row,4000*(i-1)+1:4000*i),2);
    end
end


Index=1:size(Obj_Name,1);
figure
imagesc(RSSI_Visulization)
set(gca,'ytick',1:size(Obj_Name,1),'yticklabel',{Obj_Name{Index}})
colorbar
