%% This script is used to calculate the time between two time points
clear
clc

% the output is in ms
Time1=[12,39,52];
Time2=[13,14,18];

Diff=1000*(60*(60*abs(Time1(1)-Time2(1))+abs(Time1(2)-Time2(2)))+abs(Time1(3)-Time2(3)));
Diff

%% Here calculate the video duration
Time3=[00,41,24,12];
Duration=1000*(60*(60*(Time3(1))+Time3(2))+Time3(3))+Time3(4);
Duration