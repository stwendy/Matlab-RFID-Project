% ConfusionMatrix: compute the confusion matrix given ground truth data and classification results
%
% usage conf=ConfusionMatrix(GTclasses,result_classes,Nclasses)
%
% input:  - GTclasses: a vector containing the correct class label (ground truth) for each data point. 
%         - result_classes: a vector containing the recognized class label for each data point. 
%           Both GTclasses and result_classes are Nx1 vectors where N is the number of data points.
%         - Nclasses: Number of classes. 
%
% Note: Class labels are assumed to be integers.   

function conf=ConfusionMatrix(GTclasses,result_classes,Nclasses)

% creat a confusion matrix

Confmatrix=zeros(Nclasses,Nclasses);

for i=1:length(GTclasses),
    Confmatrix(GTclasses(i),result_classes(i))=Confmatrix(GTclasses(i),result_classes(i))+1;
end

conf=(Confmatrix ./ repmat(sum(Confmatrix,2),1,Nclasses))*100;

