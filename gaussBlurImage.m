function [output, info] = gaussBlurImage(img, information)

    output = imgaussfilt(img, 2);

    info = information;
end