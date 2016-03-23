PP=zeros(11,length(Pred));
for i=0:10
    index=find(Pred==i);
    PP(i+1,index)=1;
    clear index
end

imagesc(PP);