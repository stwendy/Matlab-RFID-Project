%% function to convert string id into double
function peopleID=str2Double(id)
    peopleID=zeros(length(id),1);
    uniqueID=unique(id);

    for i=1:length(id)
        IndexC =strfind(uniqueID,id{i});
         peopleID(i)=find(not(cellfun('isempty', IndexC)));
    end
return