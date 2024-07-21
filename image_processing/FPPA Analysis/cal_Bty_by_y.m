function [BTY] = cal_Bty_by_y(Y,m,n)
    d = m*n;
    P = reshape(Y(1:d, :), [m, n]);  
    Q = reshape(Y(d+1:2*d, :), [m, n]);  
    BTY1 = zeros(d, 1);
    BTY2 = zeros(d, 1);
    
    Dm = sparse(diag([0; ones(m-1, 1)]) + diag(-ones(m-1, 1), -1));

    for i = 1:n
        % Compute Dm * Xi and store it in the appropriate position in Y
        BTY1((i-1)*m+1:i*m, 1) = Dm' * P(:,i);
    end
    
    BTY2(1:m, 1) = Q(:, 2)*(-1);
    for i = 2:n-1
        % Compute Dm * Xi and store it in the appropriate position in Y
        BTY2((i-1)*m+1:i*m, 1) = Q(:,i) - Q(:,i+1);
    end
    BTY2((n-1)*m+1:n*m, 1) = Q(:,n);
    BTY = BTY1+BTY2;
    clear BTY1;
    clear BTY2;
end

