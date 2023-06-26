function [bw3, D, wb, bw2, bw, mask] = Watershed(opened_image)
    %% WATERSHED algorithm
    
    % distance transformation 
    bw=opened_image;
    D = -bwdist(~bw);
    % Transform the dam based on this image
    Ld = watershed(D);
    wb = label2rgb(Ld);
    % The white line here is the edge of the split. 
    % Since the original image is a binary graph, 
    % it is easy to distinguish between the foreground and the background.
    bw2 = bw;
    bw2(Ld == 0) = 0;
    % Using imextendedmin will only create small dots in the middle of the block we wish to split.
    % We then use imshowpair to overlay the template onto the original.
    mask = imextendedmin(D,2);
    % Finally, we modify the result of the distance transformation,
    % makes it have a local minimum only in the desired location. And then watershed.
    % This is the result we want.
    D2 = imimposemin(D,mask);
    Ld2 = watershed(D2);
    bw3 = bw;
    bw3(Ld2 == 0) = 0;
 
end

