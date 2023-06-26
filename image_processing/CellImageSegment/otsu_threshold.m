function threshold = otsu_threshold(img)
    %% Manually implemented OTSU Otsu method
    % Converts the image to double precision
    img = im2double(img);
    
    % Calculate the histogram
    counts = imhist(img);
    counts = counts / sum(counts); % Normalize
    
    % Calculating the total mean
    total_mean = sum((0:255)'.*counts);
    
    % Calculate the variance between classes
    best_variance = 0;
    threshold = 0;
    for t = 1:255
        % Calculate class probabilities and class means
        w0 = sum(counts(1:t));
        w1 = sum(counts(t+1:end));
        m0 = sum((0:t-1)'.*counts(1:t)) / w0;
        m1 = sum((t:255)'.*counts(t+1:end)) / w1;
    
        % Calculate the variance between classes
        variance = w0*(m0 - total_mean)^2 + w1*(m1 - total_mean)^2;
        if variance > best_variance
            best_variance = variance;
            threshold = t;
        end
    end

end
