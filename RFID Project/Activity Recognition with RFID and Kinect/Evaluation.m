%% 
% clear all
close all
clc

%%
RR=[];
GT=KK;
%% Matrix 1 Accuracy
% GT=phaseResult(:,1);
for i=1:size(Prob,1)
    [~,Pred(i,1)]=max(Prob(i,:));
end
Pred=Pred-1;
for phase=0:(size(Prob,2)-1)

TP=length(find(GT==phase & Pred==phase));
TN=length(find(GT~=phase & Pred~=phase));
FP=length(find(GT~=phase & Pred==phase));
FN=length(find(GT==phase & Pred~=phase));

NTotal=TP+TN+FP+FN;
Accuracy=(TP+TN)/NTotal;

%% Matrix 2 F-Score
Precision=TP/(TP+FP);
Recall=TP/(TP+FN);
FScore=2*Precision*Recall/(Precision+Recall);



%% Matrix 3 MCC
S=(TP+FN)/NTotal;
P=(TP+FP)/NTotal;

MCC=(TP/NTotal-S*P)/sqrt(P*S*(1-P)*(1-S));

%% Matrix 4 Informedness and Markedness
TPR=TP/(TP+FN);
SPC=TN/(FP+TN);
PPV=TP/(TP+FP);
NPV=TN/(TN+FN);

Informedness=TPR+SPC-1;
Markedness=PPV+NPV-1;

%% Print the matrixes

[TP,TN,FP,FN]/NTotal;

[Accuracy, Precision, Recall, FScore];
[S,P,MCC];
[Informedness,Markedness];

RR=[RR;Accuracy, Precision, Recall, FScore,Informedness,Markedness,MCC];
end