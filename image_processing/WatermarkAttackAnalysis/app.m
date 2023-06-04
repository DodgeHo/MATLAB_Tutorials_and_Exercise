
PictureName = 'ccc.jpg';
watermarkName = 'cust.jpg';
% drawOption: 0-low-pass filtering attack, 1-Rotation attack, 2-clipping attack
% parameters drawOption=0 indicates the variance of the Gaussian function drawOption=1 indicates the number of degrees of rotation
% drawOption=2 indicates the size of the cut
figure;
MSE1 = WatermarkAttackAnalysis(PictureName, watermarkName, 0, 0.4)
figure;
MSE2 = WatermarkAttackAnalysis(PictureName, watermarkName, 1, 45)
figure;
MSE3 = WatermarkAttackAnalysis(PictureName, watermarkName, 2, 128)
