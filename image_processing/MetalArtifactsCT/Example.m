 close all;

filepath = 'sam1.dcm';
thrshldVal = 100;
metal_xrange = [185, 212]; % Metal interference range, uncertain input [0, Inf], the same below
metal_yrange = [149, 177];
resImg = MetalArtifactsCT(filepath, thrshldVal, metal_xrange, metal_yrange);

% Zoom to [0, 255] and save as PNG
image_scaled = uint8((resImg / max(resImg(:))) * 255);
imwrite(image_scaled, 'resImg1.png');


filepath = 'sam2.png';
thrshldVal = 180;
metal_xrange = [0, Inf]; 
metal_yrange = [0, Inf];
resImg = MetalArtifactsCT(filepath, thrshldVal, metal_xrange, metal_yrange);

image_scaled = uint8((resImg / max(resImg(:))) * 255);
imwrite(image_scaled, 'resImg2.png');




