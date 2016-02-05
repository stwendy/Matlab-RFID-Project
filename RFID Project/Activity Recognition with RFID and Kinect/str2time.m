function time=str2time(input)
    time=zeros(length(input),1);
    for i=1:size(input,1)
        tmp= str2double(strsplit(input{i},':'));
        time(i)=ceil((1000*(tmp(1)*3600+tmp(2)*60+tmp(3))+tmp(4))/1000);
    end
return