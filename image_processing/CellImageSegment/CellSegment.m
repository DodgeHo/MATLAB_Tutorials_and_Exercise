function [stats, boundary_image, overlay_image, region_images] = CellSegment(binary_image, original_image, SplitLines)
    %% Segment Cell

    if (nargin < 3)
        SplitLines = [];
    end

    if (numel(SplitLines) ~=0)
        % traverse all the line segments
        for k = 1:2:size(SplitLines, 1)
            
            % Use the bresenham function to generate all points on a line segment
            [x, y] = bresenham(SplitLines(k,1), SplitLines(k,2), ...
                SplitLines(k+1,1), SplitLines(k+1,2));
            
            for j = 1:numel(x)
                binary_image(y(j), x(j)) = 0;
            end
        end
    end


    % Use the bwconncomp function to find all connected regions
    CC = bwconncomp(binary_image, 4);
    
    % Use the regionprops function to calculate the area and boundaries of each region
    stats = regionprops(CC, 'Area', 'BoundingBox', 'PixelList','Perimeter');
    
    % Create a new image to show the boundary
    boundary_image = false(size(binary_image));
    % imshowpair(bw3, boundary_image, 'blend');
    % Gets the size of the image
    [H, W] = size(binary_image);
    
    for k = numel(stats):-1:1
        bbox = stats(k).BoundingBox;
        bbox_y_range = [bbox(2), bbox(2)+bbox(4)];
        bbox_x_range = [bbox(1), bbox(1)+bbox(3)];
    
        if any(bbox_x_range(1) <= 2) || ...     % top edge
           any(bbox_x_range(2) >= W-1) || ...     % bottom edge
           any(bbox_y_range(1) <= 2) || ...     % left edge
           any(bbox_y_range(2) >= H-1)            % right edge
           stats(k) = [];
           CC.PixelIdxList{k} = [];
        else
           stats(k).PixelIdxList = CC.PixelIdxList{k};
        end
    end
    
    region_images = cell(length(stats), 1); 
    
    % Traverse each connected region
    for k=1:length(stats)      
    
        pixelList = stats(k).PixelList;     % Gets a list of pixels for the connected region
        binary_mask = uint8(ones(size(original_image)));     % Create a binary image the same size as the original image
        for i = 1:size(pixelList, 1)
            binary_mask(pixelList(i,2), pixelList(i,1), :) = 0;     % Set the connected area to black
        end
        % Extract the image portion of the area from the original image
        region_image = original_image + 255 * binary_mask;     % Set the part outside the connected area to white
        region_image(region_image>255) = 255;
        bbox = stats(k).BoundingBox;
        bbox_x = floor(bbox(2)) : ceil(bbox(2)+ bbox(4));
        bbox_y = floor(bbox(1)) : ceil(bbox(1)+bbox(3));
        region_images{k} = region_image(bbox_x, bbox_y, :);
       
    
        % The boundary of the connected region is obtained and displayed on the boundary image
        region_mask = false(size(binary_image));
        region_mask(stats(k).PixelIdxList ) = true;
        boundaries = bwboundaries(region_mask, 4, 'noholes');
        for b = 1:numel(boundaries)
            boundary = boundaries{b};
            linearInd = sub2ind(size(boundary_image), boundary(:,1), boundary(:,2));
            boundary_image(linearInd) = true;
        end
    
    end

    overlay_image = original_image; % Now let's draw the border onto the original
    boundary_color = [255,255,255]; % Set the color of the border, here we'll use white
    % Draw a border on the new image
    for row = 1:H
        for col = 1:W
            if boundary_image(row, col)
                overlay_image(row, col, :) = boundary_color;
            end
        end
    end

end

