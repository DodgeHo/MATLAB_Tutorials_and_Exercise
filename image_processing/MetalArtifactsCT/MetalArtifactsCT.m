function [irdnImg] = MetalArtifactsCT(PictureName, thrshldVal, metal_xrange, metal_yrange)

[~, ~, extension] = fileparts(PictureName);
if (extension == ".dcm")
    info = dicominfo(fullfile(PictureName), 'UseDictionaryVR', true);
    image = dicomread(info);
else
    image = imread(PictureName);
    if ndims(image) == 3
        % convert rgb image to be gray level
        image = rgb2gray(image);
    end
end

%Displays the grayscale of the original image
srcImg = double(image) *256.0 ./double(max(image(:)) + 1);
figure;
subplot(2,2,1);
imshow(srcImg,[]),title('original image');
 
%% 
% The original image (Figure A) is segmented by threshold, 
% the metal image is segmented, the metal image is segmented (Figure B), 
% and the metal image is removed (Figure C). 
[srcImg_width,srcImg_height]=size(srcImg);
metalImg = zeros(srcImg_width,srcImg_height);
notMetalImg = srcImg;

for w=1:srcImg_width
    for h=1:srcImg_height
        if (srcImg(w,h)>=thrshldVal &&...
                w>metal_xrange(1) && w <metal_xrange(2) && h > metal_yrange(1) && h <metal_yrange(2))
          metalImg(w,h) = 255;
          notMetalImg(w,h) = 0;
        end
    end
end
 
subplot(2,2,2);
imshow(metalImg,[]),title('Metal threshold segmentation image');

subplot(2,2,3);
imshow(notMetalImg,[]),title('Original image with metal parts removed');

%% 2. Radon transformation of image A, image B and image C is obtained to obtain three sinusoidal graphs,
% namely graph RA, graph RB and graph RC.

% The angular range of the Radon transform
radon_theta=0:179;

% Radon transformation of metals
[R_metal,X_metal]=radon(metalImg,radon_theta);
% Radon transformation of non-metallic parts
[R_notMetal,X_notMetal]=radon(notMetalImg,radon_theta);
R_notMetal_before = R_notMetal;

%% Since figure RB is the cause of Figure A artifacts. 
% Remove the part of graph RC that intersects with graph RB, leaving a gap, 
% which is corrected using an interpolation algorithm. 
% At this point we get the graph R_RES.

MetalConstant = 999;
% When we have upIndex to actively find the next metalPQBeta(w,h) is also equal to MetalConstant, 
% in general, we have found the interpolation interval, 
% we just interpolate from metalPQBeta(upIndex,h) to metalPQBeta(w,h),
% But unless R_metal(round((upIndex + w)*0.5),h) is equal to 0, 
% If this value is 0 it means that we found the non-metal interval (in other words metalPQBeta(upIndex,h) 
% to metalPQBeta(w,h) to this segment is actually black).


% The Radon transform results of metal images are interpolated and corrected
[radon_width,radon_height]=size(R_metal);
% The result of the radon transformation is that the lateral coordinates are distances and the vertical coordinates are angles
% metalPQBeta matrix, which stores the boundaries of the metal's radon transformation
metalPQBeta = zeros(radon_width,radon_height);
% Gets the boundary of the metal's Radon transformation
for h = 1:radon_height
    for w = 2:radon_width-1
        preIndex = w -1;
        nextIndex = w + 1;
        currPix = R_metal(w,h);
        if(currPix > 0)
            if((R_metal(nextIndex,h) > 0 && R_metal(preIndex,h) == 0) || (R_metal(nextIndex,h) == 0 && R_metal(preIndex,h) > 0))
                metalPQBeta(w,h) = MetalConstant;
            end
        end
    end
end
 
% The linear interpolation replaces the radon transform of the metal with the radon transform of the non-metal
for h = 1:radon_height
    upIndex = 0;
    for w = 1:radon_width
        if( metalPQBeta(w,h) == MetalConstant && upIndex == 0)
            upIndex = w;
        elseif(metalPQBeta(w,h) == MetalConstant && upIndex ~= 0)
            g_pBeta = R_notMetal(upIndex,h);
            g_qBeta = R_notMetal(w,h);
            midPixValue = R_metal(round((upIndex + w)*0.5),h); 
            if(midPixValue > 0)
                for k = upIndex:w
                    left_val = g_pBeta*(w - k)/(w - upIndex);
                    right_val = g_qBeta*(k - upIndex)/(w - upIndex);
                    R_notMetal(k,h) = left_val + right_val;
                end
                upIndex = 0; 
            else
                upIndex = w;
            end        
        end
    end
end
 
%% 4. Radon inverse transformation is performed on Figure R_RES to obtain Figure D. 
% Since there is no metal information in Figure D at this time, 
% the metal part in Figure B is added to image D to obtain the final metal artifact correction figure F.

% The interpolation correction result of radon transformation of non-metal is inversely transformed
irdnImg=iradon(R_notMetal,radon_theta,'linear','Hann',1,1);
 
% Metal information compensation
irdnImg=imresize(irdnImg,[512,512]);

% Normalization of image processing
subplot(2,2,4);
imshow(irdnImg,[]),title('Metal artifact correction of final image');


figure;
subplot(3,1,1);
imagesc(radon_theta,X_metal,R_metal),title('Radon transformation of metals');
xlabel('\theta');
ylabel('x\prime');
colormap(gray);
colorbar;
subplot(3,1,2);
imagesc(radon_theta,X_notMetal,R_notMetal_before),title('Radon transformation of non-metallic parts');
xlabel('\theta');
ylabel('x\prime');
colormap(gray);
colorbar;
subplot(3,1,3);
imagesc(radon_theta,X_notMetal, R_notMetal),title('The radon transform results of non-metal parts were interpolated and corrected');
xlabel('\theta');
ylabel('x\prime');
colormap(gray);
colorbar;
end