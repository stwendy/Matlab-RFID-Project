function AIM1AIM2=combineAIM1AIM2(casename)

load(strcat('AIM1_mat\',casename,'_AIM1.mat'));
load(strcat('AIM2_mat\',casename,'_AIM2.mat'));

Duration=max(size(AIM1Coding,2),size(AIM2Coding,2));
AIM1AIM2=zeros(Duration,size(AIM1Coding,1)+size(AIM2Coding,1));
AIM1Coding=AIM1Coding';
AIM2Coding=AIM2Coding';

AIM1AIM2(1:size(AIM1Coding,1),1:size(AIM1Coding,2))=AIM1Coding;
AIM1AIM2(1:size(AIM2Coding,1),size(AIM2Coding,2)+1:size(AIM2Coding,2)+size(AIM2Coding,2))=AIM2Coding;

return 