function rect_score = rectangle_score(signal)
    % Calculate whether the signal is close to a rectangular wave and return a score, which is generally considered to be a positive value.
    mu = mean(signal);
    bin_signal = signal > mu;
    num_unique_values = length(unique(signal));
    num_transitions = sum(abs(diff(bin_signal)));
    high_durations = regionprops(bin_signal, 'Area');
    low_durations = regionprops(~bin_signal, 'Area');
    mean_high_duration = mean([high_durations.Area]);
    mean_low_duration = mean([low_durations.Area]);
    duration_difference = abs(mean_high_duration - mean_low_duration);

    rect_score = 1/num_unique_values + num_transitions - duration_difference;
end