%% visulize kernel New Version

clc

numKernel=length(kernel)/49;
kernelMap=zeros(7,7,numKernel);

count=1;
for r=1:7
    for c=1:7
        for l=1:numKernel
            kernelMap(c,r,l)=kernel(count);
            count=count+1;
        end
    end
end

for i=26:50
    figure(2)
    subplot(5,5,i-25)
    imagesc(kernelMap(:,:,i));
end