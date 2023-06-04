% Watermark under Attacktion Simulation Experiment
% By Dodge: asdsay@gmail.com

function [MSE] = WatermarkAttackAnalysis(PictureName, watermarkName, drawOption, parameters)
    %% Input: channeldata must be a one-dimensional signal
    % PictureName: Image file name; watermarkName: Watermark image file name
    % drawOption: 0-low-pass filtering attack, 1-Rotation attack, 2-clipping attack
    % parameters drawOption=0 indicates the variance of the Gaussian function drawOption=1 indicates the number of degrees of rotation
    % drawOption=2 indicates the size of the cut

    % Preparatory parameter
    maxsize=512;
    N=32;
    K=8; 
    D=zeros(maxsize);
    E=0.01;
    
    %% Read image
    I=imread(PictureName);
    subplot(3,2,1);
    imshow(I);
    title('Origin Image');
    I = double(I)/maxsize;


    %% Read watermark
    J=imread(watermarkName);
    J=double(imresize(J,[64,64])); % Scaling watermark
    subplot(3,2,2);
    imshow(J,[ ]);
    title('shrink Watermark image');
    % Embed Watermark
    for p=1:maxsize/K
        for q=1:maxsize/K
            x=(p-1)*K+1; y=(q-1)*K+1;
            I_dct=I(x:x+K-1,y:y+K-1);
            I_dct1=dct2(I_dct);
            if J(p,q)==0
                alfa=-1;
            else
                alfa=1;
            end
            I_dct2=I_dct1+alfa*E;
            I_dct=idct2(I_dct2);
            D(x:x+K-1,y:y+K-1)=I_dct;
        end
    end
    subplot(3,2,3);
    imshow(D,[]);
    title('Image with watermark');

    % Since the extracted watermark has been binarized, the previous watermark also needs to be binarized
    binaryJ = imbinarize(rgb2gray(J),0.5);
    subplot(3,2,5);imshow(binaryJ,[ ]);title(' original binary watermark');


    %% The watermark is added to the image of a variety of attacks

    ResultPic = D;
    switch drawOption
        case 0 
            % low-pass filtering attack
            hh=fspecial('gaussian',3,parameters);
            ResultPic=filter2(hh,D);
        case 1
            % Rotation attack
            ResultPic=imrotate(D,parameters,'bilinear','crop');
        case 2
            % clipping attack
            ResultPic(1:128,1:128)=0;
    end


    %% extract watermark
    rebuildWaterMark = zeros(maxsize/K,maxsize/K);
    for p=1:maxsize/K
        for q=1:maxsize/K
            x=(p-1)*K+1;
            y=(q-1)*K+1;
            I1=I(x:x+K-1,y:y+K-1);
             I_dct1=dct2(I1);
    
            I2=ResultPic(x:x+K-1,y:y+K-1);
            I_dct2=dct2(I2);
            if I_dct2>I_dct1
                rebuildWaterMark(p,q)=1;
            else
                rebuildWaterMark(p,q)=0;
            end
    
        end
    end
    subplot(3,2,6);imshow(rebuildWaterMark,[ ]);title('Restored binary watermark');
    MSE = sum((rebuildWaterMark(:) - binaryJ(:)).^2) / numel(binaryJ);


end