function [Bx] = cal_Bx_by_x(X,m,n)
    d = m*n;
    Bx1 = zeros(d, 1);
    Bx2 = zeros(d, 1);
    Dm = sparse(diag([0; ones(m-1, 1)]) + diag(-ones(m-1, 1), -1));
    % For each column Xi of X
    for i = 1:n
        % Compute Dm * Xi and store it in the appropriate position in Y
        Bx1((i-1)*m+1:i*m, 1) = Dm * X(:, i);
    end
    
    % For each column Xi of X
    for i = 2:n
        % Compute Dm * Xi and store it in the appropriate position in Y
        Bx2((i-1)*m+1:i*m, 1) = X(:, i) - X(:, i-1);
    end
    
    Bx = [Bx1;Bx2];
    clear Bx1;
    clear Bx2;
end

