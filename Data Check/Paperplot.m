clear
close all
clc

load('Distribution.mat')
temps=medfilt1(temp,10);

%%
[y,x]=hist(temp,100);
figure (1)
h=gca;
set(h,'FontSize',14); 
bar(x,y,'FaceColor','g','EdgeColor','w');box off
hold on
axis([500,2300,0,1500]);
temp1=temp(find(temp<1500));
[mu1,sigma1]=normfit(temp1);
temp2=temp(find(temp>=1500));
[mu2,sigma2]=normfit(temp2);

%plot the fitted figure
t=1:max(x);
Y1=normpdf(t,mu1,sigma1);
para1=max(temp1)/max(Y1);
Y1=Y1.*700000;
plot(t,Y1,'b');
hold on
Y2=normpdf(t,mu2,sigma2);
para2=max(y)/max(Y2);
Y2=Y2*160000;
plot(t,Y2,'r');
hold off

xlabel('RSSI Values')
ylabel('Distribution Count')
legend('RSSI Distribution Histgram','Caused by white noise','Caused by environmental factors')


%%
[y,x]=hist(temps,100);
figure (2)
h=gca;
set(h,'FontSize',14); 
bar(x,y,'FaceColor','g','EdgeColor','w');box off
hold on
axis([500,2300,0,2000]);
temp1=temps(find(temps<1500));
[mu1,sigma1]=normfit(temp1);
temp2=temps(find(temps>=1500));
[mu2,sigma2]=normfit(temp2);

%plot the fitted figure
t=1:max(x);
Y1=normpdf(t,mu1,sigma1);
para1=max(temp1)/max(Y1);
Y1=Y1.*550000;
plot(t,Y1,'b');
hold on
Y2=normpdf(t,mu2,sigma2);
para2=max(y)/max(Y2);
Y2=Y2*15000;
plot(t,Y2,'r');
hold off

xlabel('RSSI Values')
ylabel('Distribution Count')
legend('RSSI Distribution Histgram','Caused by white noise','Caused by environmental factors')

