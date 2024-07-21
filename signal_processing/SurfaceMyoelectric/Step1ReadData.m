%% Specify the folder path to read
folder = 'RealTimeRecord';
getChannelMethod = 1; %% Method to get the channel: 1-Identify intervals exceeding 3σ continuously, 0-Select the channel with the maximum amplitude, -1-All channels
rectangle_score_lim = 0.0; % Only valid when getChannelMethod = 1

% Get all .xls files in the folder
filePattern = fullfile(pwd, folder, '*.csv');
xlsFiles = dir(filePattern);
datasets = cell(length(xlsFiles),1);

%% Loop to read each .xls file
for i = 1:length(xlsFiles)
    % Construct the full path of the current file
    currentFile = fullfile(folder, xlsFiles(i).name);

    % Read the CSV file
    data = readmatrix(currentFile);  % If using an older version of MATLAB, use the csvread function
    
    % Find and delete columns that are entirely NaN
    nanColumns = all(isnan(data), 1);
    data(:, nanColumns) = [];

    % Note that sometimes there are reading errors, such as 585 being read as 585585, so take the remainder of 1000
    data = mod(data, 1000);

    % Restore signal to around 0 phase
    data = data - mean(data(:));

    datasets{i,1} = data;
    datasets{i,2} = xlsFiles(i).name;
    % Process the data, perform operations as needed
    % For example, you can store the data in a separate variable or perform other calculations

    % Example: Print the file name and data size
    disp(['File name: ' xlsFiles(i).name]);
    disp(['Data size: ' num2str(size(datasets{i,1}))]);
end

%% This code is used to analyze which channel has the signal with Cyclostationary processes.
% Although each signal has six channels, only one has the so-called periodic phenomenon

[numSamples, ~] = size(datasets);
NAddtionalSamples = 0;
for k = 1:numSamples
    data = datasets{k,1};

    switch getChannelMethod
        case 1
            % Binarize the signal based on 3σ, if the signal is close to a rectangular wave, it is a periodic signal.
            sigma = std(data);
            mu = mean(data);
            outliers = data > mu + 3*sigma;
            RecResults = arrayfun(@(i) rectangle_score(outliers(:,i)), 1:size(outliers, 2));
            validChannel = find(RecResults > rectangle_score_lim); % Selected channel is affected by rectangle_score_lim
            if (isempty(validChannel))
                % If nothing is found, analyze the channel with the maximum amplitude
                squareSum = sum(data.^2); % Calculate the sum of squares for each column
                [~,maxIdx] = max(squareSum);
                validChannel = ones(1,1) * maxIdx;
            end
            datasets{k,3} = strcat("Channel", num2str(validChannel(1)));
            datasets{k,4} = data(:,validChannel(1));
        
            for i = 2:size(validChannel)
                NAddtionalSamples = NAddtionalSamples + 1;
                datasets{numSamples+NAddtionalSamples,1} = datasets{k,1};
                datasets{numSamples+NAddtionalSamples,2} = datasets{k,2};
                datasets{numSamples+NAddtionalSamples,3} = strcat("Channel", num2str(validChannel(i)));
                datasets{numSamples+NAddtionalSamples,4} = data(:,validChannel(i));
            end
        case -1
            % Select all channels
            datasets{k,3} = strcat("Channel", num2str(1));
            datasets{k,4} = data(:,1);

            for i = 2:size(data,2)
                NAddtionalSamples = NAddtionalSamples + 1;
                datasets{numSamples+NAddtionalSamples,1} = datasets{k,1};
                datasets{numSamples+NAddtionalSamples,2} = datasets{k,2};
                datasets{numSamples+NAddtionalSamples,3} = strcat("Channel", num2str(i));
                datasets{numSamples+NAddtionalSamples,4} = data(:,i);
            end
        case 0
            squareSum = sum(data.^2); % Calculate the sum of squares for each column
            [~,maxIdx] = max(squareSum);
            signalData = data(:,maxIdx);
            datasets{k,3} = strcat("Channel", num2str(maxIdx));
            datasets{k,4} = signalData;
    end
end

% Through analysis, it is found that except for the signals of Basic Business EMG Signal-1 and Basic Business EMG Signal-2
% (indexed as 3 and 4 in the datasets), which appear in Channel 2, all others appear in Channel 1.

if (getChannelMethod == -1) % If all data is selected, sort them
    datasets = sortrows(datasets, 2);
end

%% Save data to file
save('RealTimeRecordData.mat', 'datasets');
