% 读取Excel数据并计算日收益率
data = xlsread('1.xlsx');
returns = diff(log(data));  % 计算日收益率

% 用直接法和移动平均法计算VaR
m = length(data) - 250;  % 移动窗口宽度
alpha = 0.05;  % 置信度为1-alpha
VaR_direct = -quantile(returns, alpha);  % 直接法

VaR_moving = zeros(length(returns)-m+1, 1);
for i = m:length(returns)
    VaR_moving(i-m+1) = -quantile(returns(i-m+1:i), alpha);  % 移动平均法
end

% 用蒙特卡罗模拟法计算VaR
mean_return = mean(returns);
std_return = std(returns);
n_simulation = 1000;  % 模拟路径条数
simulated_returns = randn(n_simulation, 1) * std_return + mean_return;
VaR_MC = -quantile(simulated_returns, alpha);  % 蒙特卡罗模拟法

% 绘制收益率和VaR图形
figure;
plot(returns);
hold on;
plot([m:length(returns)], VaR_moving, 'r');
hold off;
title('Returns and VaR');

% 结果比较分析
% （这一部分需要你根据具体的分析需求来完成）
