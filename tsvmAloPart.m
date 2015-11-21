clear all
clc
close all
% load data
load data
% specify the groudTruth
dataRow = 540;
dataColumn = 540;
groudTruth = reshape(label,dataRow,dataColumn);
% specify trainNum, trainIndex, classNum 
trainNum = round(length(label) / 6);
trainIndex = randperm(length(label), trainNum );
classNum = length(unique(label));
% get trainData, trainLabels, testData, testLabels
dataTrain = feature(trainIndex,:);
% specify the trainNumLabel, trainNumUnlabel
trainNumLabel = round(trainNum / 50);
trainNumUnlabel =trainNum - trainNumLabel;
temp = label(trainIndex);
a = randperm(trainNum,trainNumLabel);
trainIndexLabel = trainIndex(a);
trainLabels =  temp(a);
% generate the labels of the training samples for TSVM
trainLabelsTSVM = zeros(trainNum,classNum);
for iter = 1 : classNum
    temp =  trainLabels == iter ;
    trainLabelsTSVM(a(temp),iter) = 1;
    temp =  trainLabels ~= iter ;
    trainLabelsTSVM(a(temp),iter) = -1;
end
clear temp iter
% train by TSVM

% specify the enviroment
SVMLightPath='';
Kernel = 'linear';
KernelParam = 0.08;
kerparam=1/(2*KernelParam*KernelParam);
lambda = 0.5;
C=1/(2*lambda);
% specify the nets
optsvml = svmlopt('C',C,'Kernel',KERNELS(Kernel),'KernelParam',kerparam);
optsvml.Verbosity=0;
optsvml.ExecPath=SVMLightPath;
tic 
for iter = 1 : classNum
    eval( strcat('net',num2str(iter),'=svml(''model',num2str(iter),''',optsvml);') );
    eval( strcat('net',num2str(iter),'=svmltrain(net',num2str(iter), ',dataTrain,', 'trainLabelsTSVM(:,iter));') )
end
% test
% specify testIndex
temp = (1 : length(label)).';
temp(trainIndex) = [];
testIndex = repmat(temp,1,classNum);
% test
Ypred = zeros(length(label) - trainNum,classNum);
for iter = 1 : classNum
    expression = strcat( 'Ypred(:,iter) = svmlfwd(net', num2str(iter), ',feature(testIndex(:,iter),:));');
    eval(expression);
end
timeUsed = toc;

% labels for all data
% YpredAll = zeros(length(label),classNum);
% for iter =  1 : classNum 
%     YpredAll(testIndex(:,iter),iter) = Ypred(:,iter);
%     temp = trainIndex(trainLabelsTSVM(:,iter)==1);
%     YpredAll( temp,iter) = ones(length(temp),1)*realmax;
%     temp = trainIndex(trainLabelsTSVM(:,iter)==-1);
%     YpredAll(temp,iter) = ones(length(temp),1)*realmin;
% end
[values,labelTestPredict] = max(Ypred,[],2);
% unify the test labels 
temp = label(testIndex(:,1));
labels = sort( unique(temp) );
tempDataImage = labelTestPredict;
for iter = 1 : length( labels )
    if labels(iter) ~= 0
        tempIndex = find( temp == labels(iter) );
        indexRandom = tempIndex( randperm( length(tempIndex), 1 ) );
        tempDataImage( tempDataImage == tempDataImage(indexRandom) ) = 10 + temp( indexRandom );
    end
end
tempDataImage = mod( tempDataImage, 10 );
% dataImage = reshape( tempDataImage, dataRow, dataColumn );
dataImage = tempDataImage;
% show the image
% dataRow = 540;
% dataColumn = 540;
% dataImage = reshape( dataImage, dataRow, dataColumn );
% imageResult = getColorImage(dataImage);
% imwrite(imageResult,'result.bmp');
% imshow(imageResult);
% fileName = strcat('result.fig');
% saveas(gcf,fileName,'fig')
% 各种精度计算及存储
[ Matrix, kappa, coePro, coeUser, coeTotal ] = ConfuseMatrixComputation( label(testIndex(:,1)), dataImage );
fileName = strcat('ConfuseMatrix.fig');
saveas(gcf, fileName, 'fig');
fileName = strcat('result','.mat');
save(fileName,...
    'kappa', ...
    'coeTotal', ...
    'coePro', ...
    'coeUser', ...
    'Matrix', ...
    'dataImage', ...
    'timeUsed');

dataSeparateSave;
    
    


