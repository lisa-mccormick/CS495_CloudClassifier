function augmented = noise(datastore)

    augmented = transform(datastore, @addNoise);

end