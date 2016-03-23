clear all
close all
clc


%%
counter=0;
for i=0:4
    for j=0:4
        counter=counter+1;
        filename=strcat(num2str(i),'_enc_',num2str(j),'.jpg');
        image=double([imread(filename)]');
        
        copy1=image(7:18,:);
        copy2=image([24:-1:19,6:-1:1],:);  
        II=(copy1+copy2)/2;
        Activation=zeros(size(II));
        
        [~,Pos]=sort(reshape(II,[1,12*8]),'descend');
        for kk=1:5
            Activation (mod(Pos(kk),12)+1,ceil(Pos(kk)/12))=1;
        end
        clear Pos;
        clear index;
        
        figure(1)
        subplot(5,5,j*5+i+1)
        imagesc(II);
        clear II;
        clear copy1;
        clear copy2;
        
        figure(2)
        subplot(5,5,j*5+i+1)
        imagesc(Activation);
        clear Activation;
    end
end