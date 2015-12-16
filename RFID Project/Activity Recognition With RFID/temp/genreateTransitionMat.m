%% generate transition matrix

clear all
close all
clc

%%
load('AIM2.mat');

Sequence=zeros(size(AIM2));

for act=1:size(AIM2,2)
    for i=2:size(AIM2,1)
        if(AIM2(1,act)==1)
            Sequence(1,act)=act;
        elseif(AIM2(i-1,act)==0 && AIM2(i,act)==1)
            Sequence(i,act)=act;
        end
    end
end

for i=1:size(AIM2,1)
    Seq(i)=max(Sequence(i,:));
end
clear index;
index=find(Seq);
SS=Seq(index);

%%
TransMat=zeros(11,11);

for i=1:length(SS)-1
    TransMat(SS(i),SS(i+1))=TransMat(SS(i),SS(i+1))+1;
end

TransMat=TransMat./(length(SS));

