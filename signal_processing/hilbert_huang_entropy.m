% Entropy Calculation in Hilbert-Huang Transformation
% By Dodge: asdsay@gmail.com

function [hht, tfe, block_energies] = hilbert_huang_entropy(signal, num_blocks)
    % Perform Empirical Mode Decomposition
    imf = emd(signal);
    
    % Perform Hilbert Transform on each IMF
    hht = zeros(size(signal));
    for k = 1:size(imf,2)
        h_transform = hilbert(imf(:,k));
        hht = hht + abs(h_transform).^2;
    end
    
    % Normalize the Hilbert-Huang Spectrum
    hht = hht ./ sum(hht(:));
    
    % Divide the Hilbert-Huang Spectrum into equal size blocks
    block_size = length(signal) / num_blocks;
    block_energies = zeros(1, num_blocks);
    for i = 1:num_blocks
        start_index = round((i-1)*block_size) + 1;
        end_index = round(i*block_size);
        block_energies(i) = sum(hht(start_index:end_index));
    end
    
    % Normalize the block energies
    block_energies = block_energies ./ sum(block_energies);
    
    % Compute the time-frequency entropy
    tfe = -sum(block_energies .* log2(block_energies));
end
