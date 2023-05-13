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

%% Image augmentation
% The following will perform a series of augmentations on the training set

% augmentImages(trainingImages, 'trainAugmented');
% augmentImages(validateImages, 'valAugmented');


% Creating total image datastore
trainImages =  imageDatastore(...
   {'train', 'trainAugmented'}, ...
   'IncludeSubfolders',true, ...
   'LabelSource', 'foldernames');

% Oversampling to ensure classes are balanced when training
labels = trainImages.Labels;
[G,classes] = findgroups(labels);
numObservations = splitapply(@numel,labels,G)

desiredNumObservationsPerClass = max(numObservations);

files = splitapply(@(x){randReplicateFiles(x,desiredNumObservationsPerClass)},trainImages.Files,G);
files = vertcat(files{:});
labels=[];
info=strfind(files,'/');

for i=1:numel(files)
    idx=info{i};
    dirName=files{i};
    targetStr=dirName(idx(end-1)+1:idx(end)-1);
    targetStr2=cellstr(targetStr);
    labels=[labels;categorical(targetStr2)];
end
trainImages.Files = files;
trainImages.Labels=labels;
labelCount_oversampled = countEachLabel(trainImages)

% Use this to previw the augmentations before proceeding to the CNN
% imshow(imtile(preview(trainImages)))

%% Initializing network
net = alexnet;
layersTransfer = net.Layers(1:end-6);
numClasses = numel(categories(trainImages.Labels));
layers = [
   layersTransfer
   fullyConnectedLayer(900,'WeightLearnRateFactor',20,'BiasLearnRateFactor',20)
   reluLayer
   dropoutLayer
   fullyConnectedLayer(numClasses,'WeightLearnRateFactor',20,'BiasLearnRateFactor',20)
   softmaxLayer
   classificationLayer];

imageSize = [227 227 3];
augTrain = augmentedImageDatastore(imageSize,trainImages);
augTest = augmentedImageDatastore(imageSize,testImages);
options = trainingOptions('sgdm', ...
   'MiniBatchSize',32, ...
   'MaxEpochs',8, ...
   'InitialLearnRate',1e-4, ...
   'Shuffle','every-epoch', ...
   'ValidationData',augTest, ...
   'ValidationFrequency',3, ...
   'Verbose',false, ...
   'Plots','training-progress');
netTransfer = trainNetwork(augTrain, layers, options);
trainedNet = netTransfer;
save trainedNet

augTest = augmentedImageDatastore(imageSize, testImages);
[yPred, scores] = classify(netTransfer, augTest);
yTest = testImages.Labels;
accuracy = mean(yPred==yTest)
