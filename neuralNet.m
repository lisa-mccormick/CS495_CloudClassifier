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

% Mirror all images along the y-axis
if not(isfolder('reflectedImages/'))
    reflectedImages = transform(trainingImages, @flipImage, 'IncludeInfo', true);
    location = '/MATLAB Drive/CS495_CloudClassifier/reflectedImages/';
    writeall(reflectedImages, location, 'OutputFormat','jpg', 'FilenamePrefix','reflect_');
end

% Add a salt & pepper filter to all images
if not(isfolder('saltPepperImages/'))
    saltPepperImages = transform(trainingImages, @saltpepperImage, 'IncludeInfo', true);
    location = '/MATLAB Drive/CS495_CloudClassifier/saltPepperImages/';
    writeall(saltPepperImages, location, 'OutputFormat','jpg', 'FilenamePrefix','saltPepper_');
end

% Add a gaussian blur to all images
if not(isfolder('gaussBlurImages/'))
    gaussBlurImages = transform(trainingImages, @gaussBlurImage, 'IncludeInfo', true);
    location = '/MATLAB Drive/CS495_CloudClassifier/gaussBlurImages/';
    writeall(gaussBlurImages, location, 'OutputFormat','jpg', 'FilenamePrefix','gaussBlur_');
end

% Add a random block to all images
if not(isfolder('blockedImages/'))
    blockedImages = transform(trainingImages, @blockImage, 'IncludeInfo', true);
    location = '/MATLAB Drive/CS495_CloudClassifier/blockedImages/';
    writeall(blockedImages, location, 'OutputFormat','jpg', 'FilenamePrefix','block_');
end

% Paths for each set of image files for final training datastore
origTrainingImages = '/MATLAB Drive/CS495_CloudClassifier/train/';
reflectedImages = '/MATLAB Drive/CS495_CloudClassifier/reflectedImages/train/';
saltPepperImages = '/MATLAB Drive/CS495_CloudClassifier/saltPepperImages/train/';
gaussBlurImages = '/MATLAB Drive/CS495_CloudClassifier/gaussBlurImages/train/';
blockedImages = '/MATLAB Drive/CS495_CloudClassifier/blockedImages/train/';

% Storing all the images into a single array, remove or add groups as
% neccessary for training purposes
imageSet = {
    origTrainingImages, ...
    saltPepperImages
   };

% imageSet = {
%     origTrainingImages, ...
%     reflectedImages, ...
%     saltPepperImages, ...
%     gaussianImages, ...
%     blockedImages
%    };

% Creating total image datastore
trainImages =  imageDatastore(...
   imageSet, ...
   'IncludeSubfolders',true, ...
   'LabelSource', 'foldernames');

% Use this to previw the augmentations before proceeding to the CNN
% imshow(imtile(preview(trainImages)))

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
   'MiniBatchSize',32, ...
   'MaxEpochs',4, ...
   'InitialLearnRate',1e-4, ...
   'Shuffle','every-epoch', ...
   'ValidationData',augVal, ...
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
