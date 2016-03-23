% function AIM1=getAIM1Feature()

clear all
close all
clc

    Hash_Table_Path=strcat(pwd,'\Hash Table 1.xlsx');
    [~,Hash_Table] = xlsread(Hash_Table_Path,'B1:FR12');
    [~,Obj_Name] = xlsread(Hash_Table_Path,'A1:A12');
    
%     Case_Time_Path=strcat(pwd,'\AIM1Output_TimeZero.xlsx');
%     caseName=xlsread(Case_Time_Path,'A2:A138');
%     caseTime=xlsread(Case_Time_Path,'B2:B138');

%     rfidfiles='C:\Users\Xinyu Li\Google Drive\R01 RFID project\AIM1\AIM 1 Output\New System\Test\160202';
%     listing = dir(rfidfiles);
%     N = length(listing);

    for i=1:1
%         caseWholeName=listing(i).name;
%         findFile=findstr(caseWholeName,'.txt')
%         if(~(findFile==1) & ~isempty(findFile))
            
%             fprintf(listing(i).name);
%             caseNum=caseWholeName(1:length(caseWholeName)-4);
            caseNum='151227';
            
            RFIDFilename='C:\Users\Xinyu Li\Google Drive\R01 RFID project\AIM1\AIM 1 Output\New System\Test\151227.txt';
    
%             CaseTemp=ismember(caseName,str2num(caseNum));
%             caseIndex=find(CaseTemp);
% 
%             caseStartTime=caseTime(caseIndex)

%             v=datestr(caseStartTime,'HH:MM:SS');


            fid = fopen(RFIDFilename);
            info = textscan(fid, '%s %s %s %f %f %f %f ','delimiter',',');
            fclose(fid);

        %     info=sortrows(info,7)

            times=info(7);
            aa=times{1,1};
            startTime=aa(1)./1000;
% 
%             time_reference=datenum('1970','yyyy');
%             time_matlab=time_reference+(startTime-5*3600*1000-648.480)/8.64e7;
% 
%             time_matlab_str=datestr(time_matlab,'HH:MM:SS');
% 
% %             s=(datenum(time_matlab_str)-datenum(v))*24*60*60
%             s=(datenum(time_matlab_str);
% 
% 
%             if(s>0)
%                 startDelay=s
%             else          
%                 startDelay=0
%             end
% 
%             startDelay=int32(startDelay)

            endTime=aa(length(aa))./1000;
            timeMax=floor((endTime-startTime)./1000);
            TimeStamp=[aa(:,1)]./1000-startTime;

            tags_cell=info(3);
            tags=tags_cell{1,1};

            rates_cell=info(6);
            rates=rates_cell{1,1};

            readers_cells=info(1);
            readers=readers_cells{1,1};


            ports_cells=info(2);
            ports=ports_cells{1,1};



            Binary_Antenna=ones(8,timeMax-3,length(Obj_Name)).*(-100);



            for i=0:timeMax-3

                fprintf(num2str(i))
                fprintf('\n')
                 index_tmp=find(TimeStamp>(i-1)*1000 & TimeStamp<(i-1)*1000+2000);



                 for obj=1:length(index_tmp)
                     temp=tags{index_tmp(obj),1};
                     Last4Digits=temp(length(temp)-3:length(temp));
                     Hash_Map_Temp=ismember(Hash_Table,Last4Digits);
                     [row,col,~]=find(Hash_Map_Temp);

                     if ~isempty(row)
                         port=ports{index_tmp(obj),1};
                         reader_temp=readers{index_tmp(obj),1};
                         readerLastDig=reader_temp(length(reader_temp));
        %                  object=Obj_Name(row);
                         portnum=str2num(port)*str2num(readerLastDig);

                         rate=rates(index_tmp(obj),1);
                         Binary_Antenna(portnum,i+1,row)=rate;


                     end

                 end


            end

            saveFile=strcat(caseNum,'.mat');

            save(saveFile,'Binary_Antenna')
        end
%     end

%     caseNum='151213';
    %fprintf(Obj_Name{1,1})
%     RFIDFilename=strcat(pwd,'\rfidData\',caseNum,'.txt');
%     
%     CaseTemp=ismember(caseName,str2num(caseNum));
%     caseIndex=find(CaseTemp);
%     
%     caseStartTime=caseTime(caseIndex)
%     
%     v=datestr(caseStartTime,'HH:MM:SS')
%     
%     
%     fid = fopen(RFIDFilename);
%     info = textscan(fid, '%s %s %s %f %f %f %f ','delimiter',',');
%     fclose(fid);
%     
% %     info=sortrows(info,7)
%     
%     times=info(7);
%     aa=times{1,1};
%     startTime=aa(1)./1000;
%     
%     time_reference=datenum('1970','yyyy');
%     time_matlab=time_reference+(startTime-5*3600*1000-648.480)/8.64e7;
%     
%     time_matlab_str=datestr(time_matlab,'HH:MM:SS');
%     
%     s=(datenum(time_matlab_str)-datenum(v))*24*60*60
%     
%     if(s>0)
%         startDelay=s
%     else
%         startDelay=0
%     end
%     
%     startDelay=int32(startDelay)
%     
%     endTime=aa(length(aa))./1000;
%     timeMax=floor((endTime-startTime)./1000);
%     TimeStamp=[aa(:,1)]./1000-startTime;
%     
%     tags_cell=info(3);
%     tags=tags_cell{1,1};
%     
%     rates_cell=info(4);
%     rates=rates_cell{1,1};
%     
%     readers_cells=info(1);
%     readers=readers_cells{1,1};
%     
%     
%     ports_cells=info(2);
%     ports=ports_cells{1,1};
%     
% 
%     
%     Binary_Antenna=ones(8,timeMax-3+startDelay,length(Obj_Name)).*(-100);
%     
%     
% 
%     for i=0:timeMax-3
%         
%         fprintf(num2str(i))
%         fprintf('\n')
%          index_tmp=find(TimeStamp>(i-1)*1000 & TimeStamp<(i-1)*1000+2000);
%          
%          
%          
%          for obj=1:length(index_tmp)
%              temp=tags{index_tmp(obj),1};
%              Last4Digits=temp(length(temp)-3:length(temp));
%              Hash_Map_Temp=ismember(Hash_Table,Last4Digits);
%              [row,col,~]=find(Hash_Map_Temp);
%              
%              if ~isempty(row)
%                  port=ports{index_tmp(obj),1};
%                  reader_temp=readers{index_tmp(obj),1};
%                  readerLastDig=reader_temp(length(reader_temp));
% %                  object=Obj_Name(row);
%                  portnum=str2num(port)*str2num(readerLastDig);
%                  
%                  rate=rates(index_tmp(obj),1);
%                  Binary_Antenna(portnum,i+startDelay,row)=rate;
%                  
%                  
%              end
%              
%          end
%          
%          
%     end
%     
%     saveFile=strcat(caseNum,'.mat')
%     
%     save(saveFile,'Binary_Antenna')
    
%     
%     for i=1:length(tags)
%         tag=tags{i,1}
%         fprintf(tag)
%     end
        
%     fprintf('1');
%     timeMax=floor((max([RAW_Data{:,1}])-startTime)./1000);
%     TimeStamp=[RAW_Data{:,1}]-startTime;
  fprintf('1')

% function Po=generatePort(readerNum,port)
%     Po=readerNum*port

