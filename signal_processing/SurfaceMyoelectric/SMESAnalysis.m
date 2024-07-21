function [ResultStructure] = SMESAnalysis(channeldata, dataName, PictureName, drawOption, r, Nbins)
    %% Input: channeldata Must be a one-dimensional signal
    % dataName is the title of the image
    % If you pass "" to PictureName, the image will not be saved
    % drawOption is used to set the drawing method, 0-Inoise is represented by a histogram of 5 different colors; 1- Inoise is represented by a vertical bar

    ResultStructure = struct();
    %% 1) Consider the time series {xi}, i = 1,..., N, where N being the number of samples.
    [N,~] = size(channeldata);
    
    %% 2) Divide {xi} into M = N/r epochs.
    % Notice that there is rounding here, the data in the interval [M*r+1,end] will not participate in the next experiment.
    M = floor(N/r);  % M is the quantity of epochs
    N = M*r;
    
    %% 3) Obtain the auxiliary time series of the normalized sum of squares
    C = channeldata(1:r:N, :).^2;
    for i = 2:(r-1)
      C = C + channeldata(i:r:N, :).^2;
    end
    C = C./r;
    
    
    %% 4) Obtain the histogram of the series Log10 C. The bins of the histogram are defined as
    Log10C_data = log10(C);
    min_Log10C_data = min(Log10C_data);
    max_Log10C_data = max(Log10C_data);
    hist_range = (max_Log10C_data - min_Log10C_data)/2.0/Nbins;

    binEdges = min_Log10C_data:hist_range:max_Log10C_data;  % Boundary of interval
    binCenters = binEdges(1:end-1) + diff(binEdges)/2;  % Centeral point of interval


    %% 5) Search for local maxima of the curve that interpolates the frequencies of the histogram.
    % Calculate frequency and interval information
    [counts, ~] = histcounts(Log10C_data, binEdges);
    xData = 1:numel(counts);
    % Initialize a1, a2, b1, and b2 so that the two Gaussian functions are not too close together
    a1_start = max(counts);
    a2_start = a1_start/2;
    b1_start = xData(end)*0.5;
    b2_start = xData(end)*0.75;
    fitResult = fit(xData', counts', 'gauss2', 'StartPoint', [a1_start,b1_start,1,a2_start,b2_start,1]);

    % Now the b value in the binomial Gaussian function is the horizontal coordinate of the two peaks
    Inoise = min (round(fitResult.b1),  round(fitResult.b2));
    Isignal = max (round(fitResult.b1),  round(fitResult.b2));
    % These four sentences to prevent the next step of the calculation from touching the boundary, later found very safe
    % Generally, there should be: 3 ≤ Inoise < Isignal ≤ N-2    
    %     Inoise = min(xData(end)-2, Inoise);
    %     Inoise = max(Inoise, 3);
    %     Isignal = min(xData(end)-2, Isignal);
    %     Isignal = max(Isignal, 3);
    ResultStructure.Inoise = Inoise;
    ResultStructure.Isignal = Isignal;
    
    %% 6) Estimate the mean power of the noise, averaging five bins around Inoise
    % numerator and denominator
    numeratornoise = counts(Inoise-2:Inoise+2) .* binCenters(Inoise-2:Inoise+2);
    denominatornoise = counts(Inoise-2:Inoise+2);
    Pnoise = sum(numeratornoise)/sum(denominatornoise);
    ResultStructure.Pnoise = Pnoise;

    %% 7) Estimate the mean power of the noise, averaging five bins around Isignal
    % numerator and denominator
    numeratorsignal = counts(Isignal-2:Isignal+2) .* binCenters(Isignal-2:Isignal+2);
    denominatorsignal = counts(Isignal-2:Isignal+2);
    Psignal = sum(numeratorsignal)/sum(denominatorsignal);
    ResultStructure.Psignal = Psignal;

    %% 8) Estimate the root-mean-square value of the background noise enoise
    e_noise = sqrt(abs(Pnoise));
    ResultStructure.e_noise = e_noise;

    %% 9) Estimate the SNR (in decibel)
    SNR = 10 * log10((Psignal-Pnoise)/Pnoise);
    ResultStructure.SNR = SNR;

    %% 10) Estimate the DC (%)
    DC = 100 * (denominatorsignal/(denominatorsignal+denominatornoise));
    ResultStructure.DC = DC;

    % plot
    histogram(Log10C_data, 'BinLimits', [min_Log10C_data, max_Log10C_data], 'BinWidth', hist_range);
    ResultStructure.binEdges = binEdges;
    ResultStructure.binCounts = counts;
    title(dataName);

    if (drawOption == 0)
        hold on;
        minNoiseEdge = binEdges(Inoise-2);
        maxNoiseEdge = binEdges(Inoise+3);
        histogram(Log10C_data,'BinLimits', [minNoiseEdge, maxNoiseEdge], 'BinWidth', hist_range, 'FaceColor', 'g');
        hold off;
    
        hold on;
        minSignalEdge = binEdges(Isignal-2);
        maxSignalEdge = binEdges(Isignal+3);
        histogram(Log10C_data,'BinLimits', [minSignalEdge, maxSignalEdge], 'BinWidth', hist_range, 'FaceColor', 'y');
        hold off;
    else
        hold on;
        ylim = get(gca, 'YLim'); % Gets the Y-axis range of the current axis
        XInoise = binCenters(Inoise);
        XIsignal = binCenters(Isignal);
        line([XInoise XInoise], ylim, 'Color', 'g', 'LineWidth', 1); % Draw the first vertical line and color it green
        line([XIsignal XIsignal], ylim, 'Color', 'b', 'LineWidth', 1); % Draw the second vertical line and color it blue
        hold off;
    end

    hold on;
    plot(binCenters,fitResult(xData), 'LineWidth', 2);
    hold off;
    hold on;
    legend('Log10C', 'Inoise', 'Isignal', 'Fitted Curve'); % Add a legend description
    hold off;
    % Save the picture and histogram data
    if (PictureName ~= "")
        % Save the picture
        FileName = strcat('pics/', PictureName,'.png');
        saveas(gcf, FileName); 
        % save bin data as xls
        FileName2 = strcat('bins/', PictureName,'.xls');
        counts(end+1) = nan;
        T = table(binEdges', counts', 'VariableNames', {'binEdges', 'binCounts'});
        writetable(T, FileName2);
    end

end
