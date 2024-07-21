function [I2d_lambda_BBT] = cal_I2d_lambda_BBT(m,n,lambda)
    Dm = sparse(diag([0; ones(m-1, 1)]) + diag(-ones(m-1, 1), -1));
    Dn = sparse(diag([0; ones(n-1, 1)]) + diag(-ones(n-1, 1), -1));
    In = sparse(eye(n));
    Im = sparse(eye(m));
    kron1 = kron(In, Dm);
    kron2 = kron(Dn, Im);
    BBt = [kron1 * kron1', kron1*kron2'; kron2*kron1', kron2*kron2'];
    I2d_lambda_BBT = speye(m*n*2) - BBt*lambda;

    clear kron1;
    clear kron2;
    clear BBt;
end

