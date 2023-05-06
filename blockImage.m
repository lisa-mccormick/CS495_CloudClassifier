function [output, info] = blockImage(img, information)
    output = img;

    maskHeightMax = round(size(output, 1) / 2);
    maskWidthMax = round(size(output, 2) / 2);
    
    % randomly define the location, width and height of the mask
    x = randi(size(output, 1), 1);
    y = randi(size(output, 2), 1);
    h = randi(min(size(output, 1) - x + 1, maskHeightMax), 1);
    w = randi(min(size(output, 2) - y + 1, maskWidthMax), 1);
    
    % fill in the rectangle with gray
    output(x:x + h, y:y + w, :) = 128;
    
    info = information;
end