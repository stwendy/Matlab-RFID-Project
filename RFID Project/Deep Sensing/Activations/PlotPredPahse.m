PP=zeros(5,length(DD));
for i=0:4
    index=find(DD==i);
    PP(i+1,index)=1;
    clear index
end

imagesc(PP);