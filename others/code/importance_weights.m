function [weights,landmarks] = importance_weights(particles, measurements, landmarks, noise)
    % Compute the importance weight of each particle based on the measurements.
    % Assume the measurements are independent, so the probability for multiple
    % measurements is the product of the probability for each measurement.

    % Extract measurement variances
    sigma_r   = noise(1);
    sigma_phi = noise(2);

    num_particles = numel(particles); % Change size to numel for struct arrays
    num_measurements = size(measurements, 2);

    weights = ones(1, num_particles);

    for i = 1:num_particles
        particle = particles(i);
        weight = 1;
        for j = 1:num_measurements
            measurement = measurements(:, j);
            for k = 1:size(landmarks, 1) % Iterate over the rows of landmarks
                landmark = landmarks(k, :); % Get k-th landmark
                % Extract landmark coordinates directly from the columns
                landmark_x = landmark.x; % Column Var1 corresponds to x-coordinate
                landmark_y = landmark.y; % Column Var2 corresponds to y-coordinate
                % Calculate the difference between landmark and particle position
                delta_x = landmark_x - particle.pose(1);
                delta_y = landmark_y - particle.pose(2);
                % Compute range and bearing
                r = sqrt(delta_x^2 + delta_y^2);
                phi = atan2(delta_y, delta_x) - particle.pose(3);
                % Calculate probability for range and bearing
                p_r = normpdf(measurement.range - r, 0, sigma_r);
                p_phi = normpdf(wrapToPi(measurement.bearing - phi), 0, sigma_phi);
                % Multiply probabilities for each measurement and landmark
                weight = weight * p_r * p_phi;
            end
        end
        weights(i) = weight;
    end

    landmarks = landmarks(2:end);
end
