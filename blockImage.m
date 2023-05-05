function [output, info] = blockImage(img, information)
    maskHeightMax = round(size(img, 1) / 2);
    maskWidthMax = round(size(img, 2) / 2);
    
    % randomly define the location, width and height of the mask
    x = randi(size(img, 1), 1);
    y = randi(size(img, 2), 1);
    h = randi(min(size(img, 1) - x + 1, maskHeightMax), 1);
    w = randi(min(size(img, 2) - y + 1, maskWidthMax), 1);
    
    % fill in the rectangle with gray
    img(x:x + h, y:y + w, :) = 128;
    
    % resize the image
    img = img(1:32,1:32,:);

    output = img;
    info = information;
end