function filtered_image = manual_gaussian_filter(image, filter_size, sigma)
    %% Manually implemented Gaussian filtering
    % is converted to double precision for easy processing
    image = im2double(image);
    
    % Create Gaussian filter
    [h, w] = deal(filter_size(1), filter_size(2));
    center_h = ceil((h+1)/2);
    center_w = ceil((w+1)/2);
    GaussianFilter = arrayfun(@(i, j) (1/(2*pi*sigma^2))*exp(-(((i-center_h)^2+(j-center_w)^2)/(2*sigma^2))), (1:h)'*ones(1,w), ones(h,1)*(1:w));
    GaussianFilter = GaussianFilter / sum(GaussianFilter(:)); % 归一化
    
    % filtering
    pad_h = floor(h/2);
    pad_w = floor(w/2);
    padded_image = padarray(image, [pad_h, pad_w]);
    filtered_image = zeros(size(image));
    
    for i = 1:size(image, 1)
        for j = 1:size(image, 2)
            for c = 1:size(image, 3) % RGB pics
                patch = padded_image(i:i+h-1, j:j+w-1, c);
                filtered_image(i, j, c) = sum(sum(GaussianFilter.*patch));
            end
        end
    end
    
    filtered_image = im2uint8(filtered_image);

end
