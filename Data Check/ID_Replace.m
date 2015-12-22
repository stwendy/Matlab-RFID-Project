%%  This file is used to replace the TAG ID with obj name

clear all
close all
clc

%%
xls_Path=strcat(pwd,'\Hash Table.xlsx');
[~,Hash_Table] = xlsread(xls_Path, 'Sheet1', 'B1:GB48');
[~,Obj_Name] = xlsread(xls_Path, 'Sheet1', 'A1:A48');

% load the RFID TAG ID
xls_Path=strcat(pwd,'\Taglist.xlsx');
[~,TAGID] = xlsread(xls_Path, 'A2:F92');

% Loop through each case

for casenum=1:size(TAGID,2)
    temp=TAGID(:,casenum);
    for tagcount=1:length(temp)
        if size(temp{tagcount}>1)
            Last4Digits=temp{tagcount}(22:25);

            % find realted obj
            Hash_Map_Temp=ismember(Hash_Table,Last4Digits);
            [row,col,~]=find(Hash_Map_Temp);
            
            if (isempty(row))
                temp{tagcount}=strcat('NULL_',Last4Digits);
            else
               ObjName=Obj_Name{row(1)};
               temp{tagcount}=strcat(ObjName,'_',Last4Digits);
            end
        end
    end
    TAGID(:,casenum)=temp;
end