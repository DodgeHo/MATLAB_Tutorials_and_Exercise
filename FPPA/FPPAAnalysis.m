function [Im_ori,Im_noisy,Im_final] = FPPAAnalysis(PicFileName,NoiseLevel,lambda, mu, K)
    % *Read Image*
    
    [Im_ori,map] = imread(PicFileName);
    Im_ori= ind2gray(Im_ori,map);

    %% 
    % *4.2 Implementation of adding Gaussian noise*
    
    
    sigma = (NoiseLevel*NoiseLevel)/(255 * 255);
    Im_noisy = imnoise(Im_ori, 'gaussian', 0, sigma);
    Im_noisy = im2double(Im_noisy);

    %% 
    % *For a given vectorized image x∈Rd (d = m * n), let X = mat(x) :*
    % 
    % In this case,literally nothing we can do, X is just Im_noisy or v.
    
    [m, n] = size(Im_noisy);
    d = m*n;
    v = reshape(Im_noisy, [], 1);
    X = im2double(reshape(v, [m, n]) );
    
    
    I2d_lambda_BBT = cal_I2d_lambda_BBT(m,n,lambda);
    
    prox_phi = @(x, mu) max(abs(x) - mu, 0).*sign(x); % proximity operator
    Bx0 = cal_Bx_by_x(X,m,n);
    Bx = Bx0;
    Y = Bx0;
    
    % Fixed-point proximity algorithm
    for k = 1:K
        factor = Bx + I2d_lambda_BBT * Y; 
        Y = factor - prox_phi(factor, mu/lambda); % Apply the proximity operator here
    
    end
    %%
    [BTY] = cal_Bty_by_y(Y,m,n);
    u = double(v) - lambda*BTY;
    Im_final = reshape(u, [m, n]);  
end