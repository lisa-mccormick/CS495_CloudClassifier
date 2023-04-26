function noisyImg = addNoise(img)
  
    noisyImg = img;

    for i = 1:size(img, 1)

      noisyImg{idx} = imnoise(img{1}, 'salt & pepper');

    end

end