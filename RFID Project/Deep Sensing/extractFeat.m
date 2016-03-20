%%

clear all
clc
close all


%%
filename='C:\Users\Xinyu Li\Desktop\full_1_out_10000.txt';
fid = fopen(filename);
Info = textscan(fid, '%f ');
fclose(fid);

data=Info{1};

%%
feat=reshape(data,[1024,floor(length(data)/1024)]);
feat=feat';
csvname='C:\Users\Xinyu Li\Desktop\featureFromConvAll.csv';
csvwrite(csvname,feat);


