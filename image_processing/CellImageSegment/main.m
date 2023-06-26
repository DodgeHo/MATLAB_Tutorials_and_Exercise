%% Read in the picture and display the picture
fileName = 'CellsPics.bmp';
testImage = imread(fileName);
testImage = im2double(testImage); % Convert to double precision for easy processing
figure();
subplot(2,2,1);
imshow(testImage);
title('original image');

%% Create a Gaussian filter to filter the image
filter_size = [3 3];
sigma = 1;
filtered_image = manual_gaussian_filter(testImage, filter_size, sigma);
subplot(2,2,2);
imshow(filtered_image); % Displays the filtered image
title('The filtered image');

% Perform Otsu segmentation (no filtering)
blue_channel_unfilt = im2uint8(testImage(:,:,3));% Read the image and get the blue channel
threshold = otsu_threshold(blue_channel_unfilt);
binary_image_unfilt = blue_channel_unfilt > threshold;
subplot(2,2,3);
imshow(binary_image_unfilt);
title('The Otsu method is implemented directly without filtering');

% Perform Otsu segmentation (filtering)
blue_channel = filtered_image(:,:,3);
threshold = otsu_threshold(blue_channel);
binary_image = blue_channel > threshold;
subplot(2,2,4);
imshow(binary_image);
title('滤波后大津法分割');

%%
% Hole filling: Perform the open operation
se = strel('disk', 2).Neighborhood; % Gets the neighborhood matrix of structure elements
opened_image = morphological_opening(binary_image, se);
figure(2);
subplot(3,2,1);
imshow(opened_image);

% Call watershed algorithm
[bw3, D, wb, bw2, bw, mask] = Watershed(opened_image);
subplot(3,2,2);
imshow(D,[]);
subplot(3,2,3);
imshow(wb);
subplot(3,2,4);
imshow(bw2);
subplot(3,2,5);
imshowpair(bw,mask,'blend')
subplot(3,2,6);
imshow(bw3);
 
%%

%% Segmented cell
[stats, boundary_image, overlay_image, region_images] = CellSegment(bw3, filtered_image);

figure(3);
subplot(2,1,1);
imshowpair(bw3, boundary_image, 'blend');
subplot(2,1,2);
imshow(overlay_image);
hold on;
% Cell numbers are displayed on the original image
for k=1:length(stats)
    % Gets the size and boundaries of the connected region
    area = stats(k).Area;
    bbox = stats(k).BoundingBox;
    perimeter = stats(k).Perimeter;
    center_posi = [ bbox(2)+ 0.5 * bbox(4), bbox(1)+ 0.5 * bbox(3)];
    text(center_posi(2), center_posi(1), sprintf('%d', k), 'Color', 'w');
end
hold off;

%%
% Count the chromosomes in each cell
for k = 1:length(region_images)
    region_image = region_images{k};
    
    % The red and green chromosomes were segmented respectively
    red_chromosomes = imbinarize(region_image(:,:,1));
    green_chromosomes = imbinarize(region_image(:,:,2));

    % The red and green chromosomes were labeled with connected regions
    red_CC = bwconncomp(red_chromosomes);
    green_CC = bwconncomp(green_chromosomes);

    % Count the number of red and green chromosomes
    num_red = red_CC.NumObjects;
    num_green = green_CC.NumObjects;
    stats(k).num_red = num_red;
    stats(k).num_green = num_green;

    % Shows the number of red and green chromosomes in each cell
    fprintf('Cell %d: %d red chromosomes, %d green chromosomes\n', k, num_red, num_green);
    figure;
    imshow(region_images{k});

end