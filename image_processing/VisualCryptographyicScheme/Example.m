close all;

%% 3x3 visual cryptographyic scheme without pixel expansio 
% Read the picture. Firstly convert to grayscale, then to binary.
filepath = 'Lena.bmp';
[original_image,map] = imread(filepath);
if ndims(original_image) == 3
    gray_image = rgb2gray(original_image);
else
    gray_image = ind2gray(original_image,map);
end
binary_image = imresize(imbinarize(gray_image), [512 512]);

%% Encrypt
share_images = cryptographic3x3(binary_image);

%% Show the share images
result_image = share_images{1}+share_images{2}+share_images{3};
title_names = ["Share Image 1", "Share Image 2", "Share Image 3", "Share Image 1 + 2"...
    "Share Image 1 + 3", "Share Image 2 + 3"];
figure(1);
for k=1:3
    subplot(3, 3, k);
    imshow(double(share_images{k}), [0,1]);
    title(title_names(k));
end
share_images{4} = share_images{1} + share_images{2};
share_images{5} = share_images{1} + share_images{3};
share_images{6} = share_images{2} + share_images{3};
for k=4:6
    subplot(3, 3, k);
    imshow(double(share_images{k}), [1,2]);
    title(title_names(k));
end

% Show Original Image and Share Images
subplot(3, 3, 8);
imshow(double(result_image), [0,3]);
title('Share Image 1 + Share Image 2 + Share Image 3');
subplot(3, 3, 7);
imshow(binary_image);
title('Cryptographyic Image');

%% Extra process
extra_image = result_image - 2;
extra_image(extra_image<0) = 0;
subplot(3, 3, 9);
imshow(extra_image);
title('Extra Image');
