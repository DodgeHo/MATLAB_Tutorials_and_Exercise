clear; clc; close all;

% make video (slower)
makeVideo = false;

% add the tools folder to the path
addpath('tools');

% read landmark data
landmarks = read_world('../data/landmarks.dat');

% read sensor readings (odometry and range-bearing sensor)
data = read_data('../data/sensor.dat');

% noise variance
actuation_noise = [0.005, 0.01, 0.005]';
perception_noise = [1, 1];

% number of particles
numParticles = 100;

figure(1);

% initialize video
if makeVideo
    myVideo = VideoWriter('../video/myvideo');
    myVideo.FrameRate = 20;
    open(myVideo);
end

% initialize the particles array
particles = struct;
for i = 1:numParticles
    particles(i).weight = 1. / numParticles;
    particles(i).pose = zeros(3,1);
    particles(i).history = cell(1);
end

% update the particles for each odometry and measurement
for t = 1:size(data.timestep, 2)

    % prediction step of the particle filter
    particles = actuation(particles, data.timestep(t).odometry, actuation_noise);

    % importance weights
    [weights, landmarks] = importance_weights(particles, data.timestep(t).sensor, landmarks, perception_noise);

    % resample the particles according to their weights
    particles = resample(particles, weights, "standard");

    % visualize the current state of the filter
    plot_state(particles, landmarks);

    % write the frame to the video
    if makeVideo
        writeVideo(myVideo, getframe(gcf));
    end
end

if makeVideo
    close(myVideo);
end
