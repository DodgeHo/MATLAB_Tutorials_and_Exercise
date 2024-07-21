function particles = actuation(particles, u, noise)
% Updates the particles by drawing from the motion model
% Use u.r1, u.t, and u.r2 to access the rotation and translation values
% which have to be perturbed with Gaussian noise.
% The position of the i-th particle is given by the 3D vector
% particles(i).pose which represents (x, y, theta).

% noise parameters
% Assume Gaussian noise in each of the three parameters of the motion model.
% These three parameters may be used as standard deviations for sampling.
r1Noise    = noise(1);
transNoise = noise(2);
r2Noise    = noise(3);

for i = 1:length(particles)
    % Append the old position to the history of the particle
    particles(i).history{end+1} = particles(i).pose;

    % Sample a new pose for the particle
    t  = u.t  + transNoise * randn;
    r1 = u.r1 + r1Noise * randn;
    r2 = u.r2 + r2Noise * randn;

    % Update the orientation of the particle
    theta = particles(i).pose(3);

    % Update the position of the particle based on the motion model
    particles(i).pose = particles(i).pose + [t * cos(theta + r1); t * sin(theta + r1); r1 + r2];
end

end
