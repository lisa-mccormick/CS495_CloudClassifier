% Load images
rootDir = '/MATLAB Drive/CS495_CloudClassifier/';
trainDir = [rootDir 'train'];
validateDir = [rootDir 'val'];
testDir = [rootDir 'test'];
trainingImages = imageDatastore(...
   trainDir, ...
   'IncludeSubfolders',true, ...
   'LabelSource', 'foldernames');
validateImages = imageDatastore(...
   validateDir, ...
   'IncludeSubfolders',true, ...
   'LabelSource', 'foldernames');
testImages = imageDatastore(...
   testDir, ...
   'IncludeSubfolders',true, ...
   'LabelSource', 'foldernames');

%% Image augmentation datastores
% The following will perform a series of augmentations on the training set
% of images, overall providing triple the amount of training data.

% Mirror all images along the y-axis
reflectedImages = transform(trainingImages, @(x) flip(x,2));

% Add a salt & pepper filter to all images
noisyImages = transform(trainingImages, @(x) imnoise(x, 'salt & pepper'));

trainImages = combine(trainingImages, reflectedImages, noisyImages);

%% Initializing network
net = alexnet;
layersTransfer = net.Layers(1:end-3);
numClasses = numel(categories(trainImages.Labels));
layers = [
   layersTransfer
   fullyConnectedLayer(numClasses,'WeightLearnRateFactor',20,'BiasLearnRateFactor',20)
   softmaxLayer
   classificationLayer];

imageSize = [227 227 3];
augTrain = augmentedImageDatastore(imageSize,trainImages);
augVal = augmentedImageDatastore(imageSize,validateImages);
options = trainingOptions('sgdm', ...
   'MiniBatchSize',10, ...
   'MaxEpochs',6, ...
   'InitialLearnRate',1e-4, ...
   'Shuffle','every-epoch', ...
   'ValidationData',augVal, ...
   'ValidationFrequency',3, ...
   'Verbose',false, ...
   'Plots','training-progress');
netTransfer = trainNetwork(augTrain,layers,options);
trainedNet = netTransfer;
save trainedNet

augTest = augmentedImageDatastore(imageSize, testImages);
[yPred, scores] = classify(netTransfer, augTest);
yTest = testImages.Labels;
accuracy = mean(yPred==yTest)
