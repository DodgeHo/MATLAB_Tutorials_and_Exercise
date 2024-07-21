
% Read saved data
load('RealTimeRecordData.mat');
[numSamples, ~] = size(datasets);
ResultDatasets = datasets;

% Pre-set parameters
r = 10;
Nbins = 60;
drawOption = 0; % drawOption is used to set the drawing method, 0- Inoise is represented by a histogram of 5 different colors; 1- Inoise is represented by a vertical bar

% opens a file for recording the results, you can replace 'output.txt' with the filename you want
fid = fopen('RealTimeRecordResults.txt', 'w');

for selectNumberSample = 1:numSamples
    channeldata = datasets{selectNumberSample,4};
    DataName = strcat(datasets{selectNumberSample,2},datasets{selectNumberSample,3});
    PictureName = DataName; % If you pass "" to PictureName, the image will not be saved

    % Error prevention check
    SignalLength = size(channeldata);
    if (SignalLength < 1)
        continue;
    end

    ResultStructure = SMESAnalysis(channeldata, DataName, PictureName, drawOption, r, Nbins);
    ResultDatasets{selectNumberSample,5} = ResultStructure;

    disp(DataName);
    disp(ResultStructure);
    fprintf(fid, strcat(DataName,'\n'));
    fields = fieldnames(ResultStructure);
    for i = 1:numel(fields)
        fprintf(fid, '%s: %s\n', fields{i}, num2str(ResultStructure.(fields{i})));
    end
    
end

save('RealTimeRecordResult.mat', 'ResultDatasets');