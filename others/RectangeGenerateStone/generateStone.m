function [stone] = generateStone(Rmin,Rmax,sigma,SideLengthOfSquare)

Rmid = 0.5 * (Rmin + Rmax);  % 石块半径范围中值

stone = struct();
stone.peaknum = 0; % 统计石块的边数
stone.Lmax = 0; % 统计石块的最远顶点
stone.Peaks = [];
accumulated_alpha = 0; %统计累加的alpha内角和

n = randi([4, 10]); %随机石块的边数

%% 生成石块的顶点
while(accumulated_alpha < 2*pi)
    newPeak = struct();
    lambda = rand(1);
    eta = rand(1);

    newPeak.L = Rmid + (2*lambda - 1) * (Rmax - Rmin) / 2; %随机生成顶点
    if(newPeak.L > stone.Lmax)
        stone.Lmax = newPeak.L;
    end

    alpha = 2 * pi * (1 + (2*eta - 1) * sigma) / n;%随机生成角
    if (alpha + accumulated_alpha > 2*pi) % 由于多边形的总夹角和等于2pi，校正最后一个角
        accumulated_alpha = 2*pi;
    else
        accumulated_alpha = accumulated_alpha + alpha;
    end
    newPeak.alpha = accumulated_alpha; %但是要记得我们记录的角是从x轴正方向开始的读书，而不是上一个顶点开始

    %新顶点加入石块
    stone.Peaks = [stone.Peaks newPeak];
    stone.peaknum = stone.peaknum + 1;
end

%% 生成石块的位置
% 现在Lmax已经确定，我们要在 矩形范围(Lmax<x<正方形边长-Lmax, Lmax<y<正方形边长-Lmax)里随机一个石块的中心位置。
rectangle = [stone.Lmax, stone.Lmax, SideLengthOfSquare-stone.Lmax, SideLengthOfSquare-stone.Lmax]; % [a, b, c, d]
stone.x = rectangle(1) + rand * (rectangle(3) - rectangle(1));
stone.y = rectangle(2) + rand * (rectangle(4) - rectangle(2));

end

