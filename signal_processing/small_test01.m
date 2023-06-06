%% 1. Generate discrete signal x[k]=2k, where k∈[-3,7],
% and plot it with time and amplitude labeled.

% Define the range of k, Calculate x[k] according to the formula
k = -3:7;
x = 2 * k;

% Plot the discrete signal
figure;
stem(k, x, 'filled');

% Label the time and amplitude
title('Discrete Signal x[k] = 2k');
xlabel('Time (k)');
ylabel('Amplitude x[k]');

%% 2. Use MATLAB to calculate the partial fraction expansion of 
% x(z) = (z^5-0.25z^4 -0.5z^3 -14z^2-3)/(z^5+0.6z^3 -0.7z^2 -0.14z-1.6)

% Coefficients of the numerator and denominator polynomials
num = [1 -0.25 -0.5 -14 0 -3];
den = [1 0 0.6 -0.7 -0.14 -1.6];

% Use the residue function to perform partial fraction expansion
[r, p, k] = residue(num, den);

% Initialize a symbolic variable z, Add terms of k to the fraction
syms z;
F = sum(k);

% Accumulate according to each partial fraction term
for i = 1:length(r)
    F = F + r(i)/(z - p(i));
end

F = simplify(F);  % Simplify the expression

disp(F);


%% 3. Use MATLAB to compute x[k]* h[k] using DFT, 
% Analyze the error between DFT calculation results and linear convolution calculation results,
% In one picture, respectively display the calculation results and calculation errors.
% where, x[k]={1,2,3,4,k=0,1,2,3} 
% h[k]=(1,2,1,2,1; k=0,1,2 3,4, 5)

% Define signals x[k] and h[k]
x = [1, 2, 3, 4];
h = [1, 2, 1, 2, 1];

% Compute linear convolution
y_linear = conv(x, h);

% Compute DFT convolution (circular convolution)
N = length(x) + length(h) - 1; % Select an appropriate zero-padding length
x_padded = [x, zeros(1, N-length(x))]; % Zero-pad x[k]
h_padded = [h, zeros(1, N-length(h))]; % Zero-pad h[k]

X = fft(x_padded); % Compute the DFT of x[k]
H = fft(h_padded); % Compute the DFT of h[k]
y_dft = ifft(X .* H); % Element-wise multiplication of X and H, then perform inverse DFT to get the circular convolution result

% Compute error
error = y_dft - y_linear;

% Plot
figure;
subplot(3,1,1);
stem(y_linear, 'filled');
title('Linear Convolution');
xlabel('Time (k)');
ylabel('Amplitude');

subplot(3,1,2);
stem(y_dft, 'filled');
title('DFT Convolution');
xlabel('Time (k)');
ylabel('Amplitude');

subplot(3,1,3);
stem(error, 'filled');
title('Error (DFT Convolution - Linear Convolution)');
xlabel('Time (k)');
ylabel('Amplitude');

