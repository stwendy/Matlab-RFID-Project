%% 
clear all
close all
clc

%%
Obj=8;

load('AIM2Probability(withAIM1data).mat')

%for object use detection
% Threshold=[0.37,0.37,0.50,0.37,0.51,0.33,0.51,0.50,0.50,0.50,0.37]; 

%for object activity recognition with prediction 
Threshold=[0.50,0.25,0.22,0.40,0.20,0.16,0.49,0.37,0.50,0.07,0.18];

%for object activity recognition with AIM1 Ground truth 
% Threshold=[0.50,0.32,0.50,0.14,0.20,0.16,0.50,0.39,0.49,0.10,0.18];


Pred=zeros(size(Data,1),1);
index=find(Data(:,Obj)>=Threshold(Obj));
Pred(index)=1;

%% Matrix 1 Accuracy
GT=Data(:,Obj+11);

TP=length(find(GT==1 & Pred==1));
TN=length(find(GT==0 & Pred==0));
FP=length(find(GT==1 & Pred==0));
FN=length(find(GT==0 & Pred==1));

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

[Accuracy, Precision, Recall, FScore]
[S,P,MCC]
[Informedness,Markedness]