function prediction = predictCloud(img)
    
    load final_trainedNet.mat
    
    img = imageDatastore(...
        img, ...
       'IncludeSubfolders',true, ...
       'LabelSource', 'foldernames');

    augTest = augmentedImageDatastore(imageSize, img);

    [yPred, scores] = classify(trainedNet, augTest);

    prediction = yPred;
end