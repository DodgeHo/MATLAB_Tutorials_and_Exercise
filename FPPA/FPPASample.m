PicFileName = 'Cameraman.png';
NoiseLevel = 20;% gauss std
lambda = 0.2;%  λ 
mu = 0.1; % µ 
K = 10;% iteration time
[Im_ori,Im_noisy,Im_final] = FPPAAnalysis(PicFileName,NoiseLevel,lambda, mu, K);

figure;
subplot(1,3,1);
imshow(Im_ori);
title('Origin Image');
subplot(1,3,2);
imshow(Im_noisy);
title('Noisy Image');
subplot(1,3,3);
imshow(Im_final);
title('Reconstructed Image');