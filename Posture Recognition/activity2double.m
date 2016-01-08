function numActivity=activity2double(activity)
    numActivity=zeros(length(activity),1);
    
    for i=1:length(activity)
        if (strcmp(activity{i},'Abd'))
            numActivity(i)=1;
        elseif (strcmp(activity{i},'Iv'))
            numActivity(i)=2;
        else
            numActivity(i)=3;
        end
    end
return