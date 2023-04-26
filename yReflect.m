function augmented = yReflect(datastore)

    aug = imageDataAugmenter("RandXReflection", true);

    imageSize = [227 227 3];

    augmented = augmentedImageDatastore( ...
        imageSize, datastore, ...
        "DataAugmentation",aug);

end