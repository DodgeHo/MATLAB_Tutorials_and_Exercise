function plot_state(particles, landmarks)
    % Visualizes the state of the particles
    
    clf;
    hold on;
    grid on;

    % Landmarks
    L = struct2cell(landmarks);
    plot(cell2mat(L(2,:)), cell2mat(L(3,:)), 'k+', 'markersize', 10, 'linewidth', 5);

    % Particles
    ppos = [particles.pose];
    plot(ppos(1,:), ppos(2,:), 'b.', 'markersize', 10, 'linewidth', 3.5);

    xlim([-2, 12])
    ylim([-2, 12])
    hold off;
    drawnow;
end
