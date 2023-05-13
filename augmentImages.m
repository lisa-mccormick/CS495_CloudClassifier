function augmentImages(img, datasetName)

    % Used for setting locations to save off all the image files
    currentDir = pwd;

    % Mirror all images along the y-axis
    if not(isfolder(append(datasetName, '/reflectedImages/')))
        reflectedImages = transform(img, @flipImage, 'IncludeInfo', true);
        location = append(currentDir, '/', datasetName, '/reflectedImages/');
        writeall(reflectedImages, location, 'OutputFormat','jpg', 'FilenamePrefix','reflect_');
    end
    
    % Add a salt & pepper filter to all images
    if not(isfolder(append(datasetName, '/saltPepperImages/')))
        saltPepperImages = transform(img, @saltpepperImage, 'IncludeInfo', true);
        location = append(currentDir, '/', datasetName, '/saltPepperImages/');
        writeall(saltPepperImages, location, 'OutputFormat','jpg', 'FilenamePrefix','saltPepper_');
    end
    
    % Add a gaussian blur to all images
    if not(isfolder(append(datasetName, '/gaussBlurImages/')))
        gaussBlurImages = transform(img, @gaussBlurImage, 'IncludeInfo', true);
        location = append(currentDir, '/', datasetName, '/gaussBlurImages/');
        writeall(gaussBlurImages, location, 'OutputFormat','jpg', 'FilenamePrefix','gaussBlur_');
    end
    
    % Add a random block to all images
    if not(isfolder(append(datasetName, '/blockedImages/')))
        blockedImages = transform(img, @blockImage, 'IncludeInfo', true);
        location = append(currentDir, '/', datasetName, '/blockedImages/');
        writeall(blockedImages, location, 'OutputFormat','jpg', 'FilenamePrefix','block_');
    end

end