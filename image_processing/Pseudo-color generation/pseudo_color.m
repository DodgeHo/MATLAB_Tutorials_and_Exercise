FileName = 'Test_image.tiff';% Image file name or relative file path

matrix = pseudo_color_generate(FileName);

%% save csv file
dotIndex = strfind(FileName, '.'); % Find the starting position of the file suffix
CSVFilename = strcat(FileName(1:dotIndex-1), '.csv'); % Rename
writematrix(matrix, CSVFilename);


%% function of Pseudocolor Generation
function [matrix] = pseudo_color_generate(FileName)
    
    matrix = imread(FileName);  % Read image
    [x, y] = meshgrid(1:size(matrix, 2), 1:size(matrix, 1)); % Create a corresponding grid the same size as the image
    
    figure
    surf(x, y, double(matrix), 'EdgeColor', 'none');    % Use the surf function to draw a false-color image
    view(2)
    title(FileName);
    colormap('jet');                                    % Use colormap to generate pseudo-color map as 'jet' colormap
    colorbar 
    axis equal
    caxis([0 255]); 
end