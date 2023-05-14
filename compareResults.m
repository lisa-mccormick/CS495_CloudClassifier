function results = compareResults(img)

    load final_trainedNet.mat

    augTest = augmentedImageDatastore(imageSize, img);

    [detectedClasses, scores] = classify(trainedNet, augTest);

    sz = [size(augTest.Files,1), 5];
    varTypes = ["categorical", "categorical", "categorical", "single", "single"];
    varNames = ["Detected Class", "Actual Class", "Match?", "Distance", "Datastore Index"]; 
    
    results = table('Size',sz,'VariableTypes',varTypes,'VariableNames',varNames);
    results(:,"Detected Class") = array2table(detectedClasses);
    results(:,"Actual Class") = array2table(img.Labels);
    results(:,"Match?") = array2table(categorical(detectedClasses == img.Labels));
    results(:,"Distance") = array2table(scores(:,2));
    results(:,"Datastore Index") = array2table((1:sz(1))');
end