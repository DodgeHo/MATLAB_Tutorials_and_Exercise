function [stats] = calCC(region_images,stats)
%% Count the chromosomes in each cell
    for k = 1:length(region_images)
        region_image = region_images{k};
        
        % The red and green chromosomes were segmented respectively
        red_chromosomes = imbinarize(region_image(:,:,1));
        green_chromosomes = imbinarize(region_image(:,:,2));
    
        % The red and green chromosomes were labeled with connected regions
        red_CC = bwconncomp(red_chromosomes);
        green_CC = bwconncomp(green_chromosomes);
    
        % Count the number of red and green chromosomes
        num_red = red_CC.NumObjects;
        num_green = green_CC.NumObjects;
        stats(k).num_red = num_red;
        stats(k).num_green = num_green;
    end
end

