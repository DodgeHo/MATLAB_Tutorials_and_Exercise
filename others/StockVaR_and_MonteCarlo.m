% Read Excel data and calculate daily yield
data = xlsread('1.xlsx');
returns = diff(log(data));  % daily yield

% VaR is calculated by direct method and moving average method
m = length(data) - 250;  % Move window width
alpha = 0.05;  % confidence level is 1-alpha
VaR_direct = -quantile(returns, alpha);  % directly

VaR_moving = zeros(length(returns)-m+1, 1);
for i = m:length(returns)
    VaR_moving(i-m+1) = -quantile(returns(i-m+1:i), alpha);  % moving average method
end

% VaR was calculated by Monte Carlo simulation method
mean_return = mean(returns);
std_return = std(returns);
n_simulation = 1000;  % Number of simulated paths
simulated_returns = randn(n_simulation, 1) * std_return + mean_return;
VaR_MC = -quantile(simulated_returns, alpha);  % monte carlo simulation

% Plot yield and VaR graphs
figure;
plot(returns);
hold on;
plot([m:length(returns)], VaR_moving, 'r');
hold off;
title('Returns and VaR');

