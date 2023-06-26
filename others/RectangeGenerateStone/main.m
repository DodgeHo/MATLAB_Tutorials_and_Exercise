%% 初始参数
Dmin = 20; %石块粒径范围
Dmax = 30; 
NumStone = 10; %石块个数
SideLengthOfSquare = 150; %正方形区域的边长
sigma = 0.1; % 定义夹角变化范围的参数

%% 生成石块
% 计算同心圆的半径:
Rmin = 0.5 * Dmin;
Rmax = 0.5 * Dmax;

StonePool = []; %石块计数池

%只要没有塞够NumStone个石块，程序就一直执行
while(length(StonePool)<NumStone)

    % 用函数generateStone生成一块石头
    newStone = generateStone(Rmin,Rmax,sigma,SideLengthOfSquare);
    overlap = false;
    % 这块新石头要和前面计数池里每一块石头做干涉检查
    for i=1:length(StonePool)
        oldStone = StonePool(i);
        %我们认为两块石头的中心距离小于二者最远顶点距离和，就是重叠
        %因此 应该有 d = sqrt((x1-x2)^2 +(y1-x2)^2) > l1max + l2max
        d = sqrt ((newStone.x-oldStone.x).^2+(newStone.y-oldStone.y).^2);
        %反之，出现了重叠干涉
        if (d < (newStone.Lmax + oldStone.Lmax))
            overlap = true;
            break;
        end
    end

    
    if (overlap == true)
        % 出现了重叠，这块石头没用了
        continue;
    else
        % 没出现重叠，这块石头可以加进池子里
        StonePool = [StonePool newStone];
    end
end


%% 开始画图

filename = 'stoneGenerateAnimated.gif';%准备一张gif来用动图记录绘制
figure;

% 绘制正方形边框
pos = [0 0 SideLengthOfSquare SideLengthOfSquare];
rectangle('Position', pos, 'EdgeColor', 'black');
axis([0 SideLengthOfSquare 0  SideLengthOfSquare]); % 保持坐标轴的比例，使正方形看起来
hold on;

% 将背景写成动图第一帧
frame = getframe(gcf);
im = frame2im(frame); % 将帧转换为索引图像
[imind, cmap] = rgb2ind(im, 256);
imwrite(imind, cmap, filename, 'gif', 'Loopcount', inf);  % 将帧写入 GIF 文件

for i=1:NumStone
    Stone = StonePool(i);

    % 每个石头顶点的坐标 x = x0 + L*cos(α), y = y0 +L*sin(α)
    peak_x_list = zeros(Stone.peaknum+1,1);
    peak_y_list = zeros(Stone.peaknum+1,1);
    for j = 1:Stone.peaknum
        peak_x_list(j) = Stone.x + Stone.Peaks(j).L .* cos(Stone.Peaks(j).alpha);
        peak_y_list(j) = Stone.y + Stone.Peaks(j).L .* sin(Stone.Peaks(j).alpha);
    end

    % 首尾相接准备画多边形
    peak_x_list(end) = peak_x_list(1);
    peak_y_list(end) = peak_y_list(1);    
    plot(peak_x_list, peak_y_list, 'Color', rand(1, 3));%随机一个颜色
    hold on;

    % 新增一帧到动图中
    frame = getframe(gcf);  % 获取当前帧
    im = frame2im(frame); % 将帧转换为索引图像
    [imind, cmap] = rgb2ind(im, 256);
    imwrite(imind, cmap, filename, 'gif', 'WriteMode', 'append'); % 将帧写入 GIF 文件

end
hold off