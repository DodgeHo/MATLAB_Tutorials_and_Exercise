function [share_images] = cryptographic3x3(binary_image)
%CRYPTOGRAPHIC3X3 a(3,3) visual cryptographyic scheme without pixel expansion

    % basic function matrix
    S0 = [1 0 1 0; 1 1 0 0; 0 1 1 0];
    S1 = [1 0 1 0; 1 0 0 1; 1 1 0 0];
    
    % prepare 3 share images
    blank_image = zeros(size(binary_image));
    share_images = {blank_image, blank_image, blank_image};
    
    for i = 1:2:size(binary_image, 1)
        for j = 1:2:size(binary_image, 2)
    
            % extract 2x2 pixels block
            block = binary_image(i:i+1, j:j+1);
            % Now upperLeft, upperRight, lowerLeft, lowerRight 
            % are the 1st, 2nd, 3rd, 4th pixel in order.
            pixel_list = reshape(block, [], 1);
    
            % Calculate the position and the amount of white pixels
            index_white = find(pixel_list == 0);
            num_white = numel(index_white);
    
            % Follow the amount of white pixel to decide which base matrix 
            % for transformation on the rows and columns
            S = S0; % transformation matrice
            cols = [1, 2, 3, 4];
            switch num_white
                case 4
                    % Method 1: Random swap of all columns
                    rand_cols = cols(randperm(length(cols)));
                    S(:, cols) = S(:, rand_cols);
                case {3,2}
                    % Method 2&3: (identical codes)
                    % One white pixel is randomly selected as the all-0s' column
                    % and other columns are randomly swapped
                    chosen_index_white = datasample(index_white,1); 
                    S(:, [4,chosen_index_white]) = S(:, [chosen_index_white,4]);
                    cols(chosen_index_white) = [];
                    rand_cols = cols(randperm(length(cols)));
                    S(:, cols) = S(:, rand_cols);
                case 1
                    % Method 4: The white pixel works as the 0s' column
                    % and other columns are randomly swapped
                    S(:, [4,index_white(1)]) = S(:, [index_white(1),4]);
                    cols(index_white(1)) = [];
                    rand_cols = cols(randperm(length(cols)));
                    S(:, cols) = S(:, rand_cols);
                otherwise
                    S = S1; % All black, we use the matrice S1
                    % Method 5: Random swap of all columns
                    cols = [1, 2, 3, 4];
                    rand_cols = cols(randperm(length(cols)));
                    S(:, cols) = S(:, rand_cols);
            end
    
            % Share each row of the transformed matrix to the corresponding shared images 1, 2, 3
            for k=1:3
                secret_block = reshape(S(k,:), 2, 2)';
                share_images{k}(i:i+1, j:j+1) = secret_block;
            end
    
            
        end
    end
end

