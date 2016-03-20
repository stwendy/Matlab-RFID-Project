%% the function is used to visulize weight in first connvolutional layers
clc

kernelNum=length(weight)/56;
for i=1:kernelNum
    Temp=weight((i-1)*56+1:i*56);
    kernel(:,:,i)=[reshape(Temp,[7,8])]';
    
figure (1)
    subplot(6,6,i)
    imagesc(kernel(:,:,i));
end

input=[reshape(in,[24,40])]';

for i=1:kernelNum
figure (2)
    output=conv2(input,kernel(:,:,i));
    subplot(6,6,i)
    imagesc(output);
    clear output;
end
