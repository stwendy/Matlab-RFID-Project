function numStatus=status2double(status)
    numStatus=zeros(length(status),1);
    
    for i=1:length(status)
        if (strcmp(status{i},'False'))
            numStatus(i)=0;
        else
            numStatus(i)=1;
        end
    end
return