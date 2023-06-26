function out = morphological_opening(binary_image, se)
    %% Implements morphological open operation manually

    % The corrosion calculation is performed first
    im = binary_image;
    se_size = size(se, 1);
    padding_size = floor(se_size / 2);
    im = padarray(im, [padding_size padding_size], 1);
    [m, n] = size(im);
    out = zeros(m - 2 * padding_size, n - 2 * padding_size);
    for i = 1 + padding_size:m - padding_size
        for j = 1 + padding_size:n - padding_size
            sub_im = im(i - padding_size:i + padding_size, j - padding_size:j + padding_size);
            if all(sub_im(:) >= se(:))
                out(i - padding_size, j - padding_size) = 1;
            else
                out(i - padding_size, j - padding_size) = 0;
            end
        end
    end

    % And then we do the expansion
    im = padarray(out, [padding_size padding_size], 0);
    out = zeros(m - 2 * padding_size, n - 2 * padding_size);
    for i = 1 + padding_size:m - padding_size
        for j = 1 + padding_size:n - padding_size
            sub_im = im(i - padding_size:i + padding_size, j - padding_size:j + padding_size);
            if any(sub_im(:) & se(:))
                out(i - padding_size, j - padding_size) = 1;
            else
                out(i - padding_size, j - padding_size) = 0;
            end
        end
    end

end
