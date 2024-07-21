function newParticles = resample(particles, weights, type)
    % Resample the set of particles based on their importance weights.

    numParticles = size(particles, 2);

    % Normalize the weights
    weights = weights / sum(weights);

    % Initialize the new particles array
    newParticles = particles;
    for i = 1:numParticles
        newParticles(i).weight = 0;  
        newParticles(i).pose = zeros(size(particles(i).pose)); 
        % Empty each cell
        num_history_elements = numel(particles(i).history);  
        for j = 1:num_history_elements
            newParticles(i).history{j} = []; 
        end
    end

    if type == "low-variance"
        % Implement low-variance resampling (if needed)
        % This is left as an exercise
    else
        % Standard resampling
        indices = randsample(1:numParticles, numParticles, true, weights);
        for i = 1:numParticles
            newParticles(:, i) = particles(:, indices(i));
        end
    end
end
