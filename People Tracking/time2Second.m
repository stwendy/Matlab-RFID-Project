%% fuction to convert time into seconds
function [startTime,timeInSecond]=time2Second(time)
    timeInSecond=zeros(length(time),1);

    strStartTime=time{1};
    Seg = strsplit(strStartTime,':');
    startTime=str2double(Seg{1})*3600+str2double(Seg{2})*60+str2double(Seg{3});
    
    parfor t=1:length(time)
        Seg = strsplit(time{t},':');
        timeInSecond(t)=str2double(Seg{1})*3600+str2double(Seg{2})*60+str2double(Seg{3})-startTime;  
    end
return 