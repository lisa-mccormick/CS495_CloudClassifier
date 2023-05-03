function [output, info] = saltpepperImage(img, information)

        output = imnoise(img, 'salt & pepper');

        info = information;
end