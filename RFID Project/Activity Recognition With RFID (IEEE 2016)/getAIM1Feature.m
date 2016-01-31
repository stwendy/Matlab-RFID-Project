%% -------------------------------------------------------------------------------
% Generate AIM1 feature
% -------------------------------------------------------------------------------
function AIM1=getAIM1Feature(casenum)
    RAW_dir=strcat(pwd,'\RAW\');
    load(strcat(RAW_dir,casenum,'.mat'));
    fprintf('Processing file %s ... \n',casenum);
    
    Hash_Table_Path=strcat(pwd,'\Hash Table 1.xlsx');
    [~,Hash_Table] = xlsread(Hash_Table_Path,'B1:FR12');
    [~,Obj_Name] = xlsread(Hash_Table_Path,'A1:A12');
    
    startTime=RAW_Data{1}(1);
    timeMax=floor((max([RAW_Data{:,1}])-startTime)./1000);
    TimeStamp=[RAW_Data{:,1}]-startTime;
    
    % Features Needed
    Feat_Time=(1:timeMax)';
    Feat_Position=zeros(timeMax,(size(Obj_Name,1))-1);
    Feat_RSS=zeros(timeMax,(size(Obj_Name,1)));
    Feat_SRCC=zeros(timeMax,(size(Obj_Name,1))-1);
    Feat_Entropy=zeros(timeMax,(size(Obj_Name,1))-1);
    Feat_DomFreq=zeros(timeMax,(size(Obj_Name,1))-1);
    feature=[];
    
    % Go through the RAW data
    for i=1:timeMax-3
        % find the object in each time range
        index_tmp=find(TimeStamp>(i-1)*1000 & TimeStamp<(i-1)*1000+2000);
        Binary_Antenna=zeros(length(Obj_Name)-1,8);
        
        for obj=1:length(index_tmp)
            % find the correlated obj name
            Last4Digits=RAW_Data{index_tmp(obj),4};
            Hash_Map_Temp=ismember(Hash_Table,Last4Digits);
            [row,col,~]=find(Hash_Map_Temp);
                     
            %---------------------------------------------------------------------------------------- get peak RSSI (Use Peak RSS), unfiltered.
            if (RAW_Data{index_tmp(obj),2}>Feat_RSS(i,row(1)))
                    Feat_RSS(i,row(1))=RAW_Data{index_tmp(obj),2};
            end
            
            %---------------------------------------------------------------------------------------- get antenna combination (use binary to int)
            if (row(1)<=11)
                Binary_Antenna(row(1),RAW_Data{index_tmp(obj),3})=1;
            else
                Binary_Antenna(11,RAW_Data{index_tmp(obj),3})=1;
            end 
        end
        Feat_Position(i,:) = bi2de(Binary_Antenna)';
        clear index_tmp;
        
        %---------------------------------------------------------------------------------------- get  SRCC
        if (i==timeMax)
            Feat_SRCC(i,:)=0;
        else
            index_tmp=find(TimeStamp>(i-1)*1000 & TimeStamp<(i+1)*1000);
            RSS_in_ms=zeros(12,2000);
            tmp_time=[RAW_Data{:,1}]-startTime-(i-1)*1000+1;
            for obj=1:length(index_tmp)
                % find the correlated obj name
                Last4Digits=RAW_Data{index_tmp(obj),4};
                Hash_Map_Temp=ismember(Hash_Table,Last4Digits);
                [row,col,~]=find(Hash_Map_Temp);

                RSS_in_ms(row(1),tmp_time(index_tmp(obj)))=RAW_Data{index_tmp(obj),2};
            end   
            RSS_in_ms(11,:)=abs(RSS_in_ms(11,:)-RSS_in_ms(12,:));

            for tmp=1:11
                SRCC_tmp=corr(RSS_in_ms(tmp,1:1000)'+eps,RSS_in_ms(tmp,1001:2000)'+eps , 'type', 'Spearman');
                if (isnan(SRCC_tmp))
                    Feat_SRCC(i,tmp)=2;
                else
                    Feat_SRCC(i,tmp)=SRCC_tmp;
                end
            end

            %---------------------------------------------------------------------------------------- Put Entropy and dominant frequency 
            for tmp=1:11
                Feat_DomFreq(i,tmp)=Get_Dominant_Freq(smooth(RSS_in_ms(tmp,:),5)); 
                Feat_Entropy(i,tmp)=Get_Entropy(smooth(RSS_in_ms(tmp,:),5)); 
            end

        clear index_tmp;
        end
        
        if (mod(i,floor(timeMax/10))==0)
            fprintf('->%d  ',10*floor(i/(timeMax/10)));
        end
        
        if (i==timeMax)
                fprintf('\n');
        end
    end
    
     %  Post process the RSS
    Feat_RSS(:,11)=smooth(abs(Feat_RSS(:,11)-Feat_RSS(:,12)),10);
    for tmp=1:11
        Feat_RSS(:,tmp)=smooth(Feat_RSS(:,tmp),5);
    end

    % Cat the features
    feat=[Feat_Time,Feat_Position,Feat_RSS(:,1:11),Feat_SRCC,Feat_Entropy,Feat_DomFreq];

    % Extract the Ground Truth
    GT=Get_GroundTruth(casenum);

    Duration=min(timeMax,size(GT,1));
    feature=[feat(1:Duration,:),GT(1:Duration,:)];


    % Align with AIM 2 data
    load(strcat('AIM1_mat\',casenum,'_AIM1.mat'));
    load(strcat('AIM2_mat\',casenum,'_AIM2.mat'));

    Duration=max(size(AIM1Coding,2),size(AIM2Coding,2))
    minLength=min([size(AIM1Coding,2),size(AIM2Coding,2),size(feature,1)]);
    AIM1=zeros(Duration,size(feature,2));
    AIM1(1:minLength,:)=feature(1:minLength,:);
return


%% -------------------------------------------------------------------------------
% Calculate Doninant Frequency Componient
% -------------------------------------------------------------------------------
function Dom_Freq=Get_Dominant_Freq(x) 
    Fs = 10; % sampling frequency 1 kHz
    t =  0:1:2000; % time scale
    x = x - mean(x);                                      
    nfft = 512; % next larger power of 2
    y = fft(x,nfft); % Fast Fourier Transform
    y = abs(y.^2); % raw power spectrum density
    y = y(1:1+nfft/2); % half-spectrum
    [v,k] = max(y); % find maximum
    f_scale = (0:nfft/2)* Fs/nfft; % frequency scale
    fest = f_scale(k); % dominant frequency estimate
    Dom_Freq=fest;
return

%% -------------------------------------------------------------------------------
% Calculate Entropy
% -------------------------------------------------------------------------------
function Entropy=Get_Entropy(signal)
%     p = hist(signal, [min(signal):100:max(signal)]);
%     Entropy = -sum(p.*log2(p))/log2(length(p));

Entropy=entropy(signal);
return

%% -------------------------------------------------------------------------------
% Extract Ground truth
% -------------------------------------------------------------------------------
function GT=Get_GroundTruth(case_name)

%% Load Ground Truth data
GT_name=strcat('\AIM1\AIM1Output_',case_name,'.xlsx');
[~,Ground_Truth_xls] = xlsread(GT_name);

% Load Harsh table from excel file into workspace
Hash_Table_Path=strcat(pwd,'\Hash Table 2.xlsx');
[~,Hash_Table] = xlsread(Hash_Table_Path);
[~,Obj_Name] = xlsread(Hash_Table_Path);

Start_Time_ms=zeros(size(Ground_Truth_xls,1),1);
End_Time_ms=zeros(size(Ground_Truth_xls,1),1);
k=1;

% Fetching data from excel into matlab
for  i=2:size(Ground_Truth_xls,1)
    Start_Time_ms(k)=(((str2double(Ground_Truth_xls{i,1}(1:2)))*60+ ... %Hours
                        str2double(Ground_Truth_xls{i,1}(4:5)))*60+ ... %Minutes
                        str2double(Ground_Truth_xls{i,1}(7:8)))*1000+ ... % Seconds
                        str2double(Ground_Truth_xls{i,1}(10:11)); %MS
                    
    End_Time_ms(k)=(((str2double(Ground_Truth_xls{i,2}(1:2)))*60+ ...
                        str2double(Ground_Truth_xls{i,2}(4:5)))*60+ ...
                        str2double(Ground_Truth_xls{i,2}(7:8)))*1000+ ...
                        str2double(Ground_Truth_xls{i,2}(10:11));
    k=k+1;
end

%Generate the Data Matrix
Ground_Truth=zeros(size(Obj_Name,1),max(End_Time_ms));
for  i=2:size(Ground_Truth_xls,1)
    Obj_Name_Tmp=Ground_Truth_xls{i,3};
    for m=1:size(Obj_Name,1)
       if (~isempty(strfind(Obj_Name{m},Obj_Name_Tmp))) 
           if (strcmp(Ground_Truth_xls{i,4},' In Use'))
                Ground_Truth(m,Start_Time_ms(i-1):End_Time_ms(i-1))=1;
           elseif strcmp(Ground_Truth_xls{i,4},' In Motion')
                Ground_Truth(m,Start_Time_ms(i-1):End_Time_ms(i-1))=1;
           end
       end
    end
end

for i=1:size(Ground_Truth,2)/1000+1
    if (i<=size(Ground_Truth,2)/1000)
        Compressed_Ground_Truth(:,i)=floor(sum(Ground_Truth(:,(i-1)*1000+1:i*1000),2)./1000);
    else
        Compressed_Ground_Truth(:,i)=0;
    end
end

GT=Compressed_Ground_Truth';
