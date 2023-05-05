function [output, info] = gaussianImage(img, information)

    output = imnoise(img, 'gaussian');

    info = information;
end