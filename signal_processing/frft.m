function Faf = frft(f, a)
% The fast Fractional Fourier Transform
% input: f = samples of the signal
%        a = fractional power
% output: Faf = fast Fractional Fourier transform

    error(nargchk(2, 2, nargin));
    
    f = f(:);
    N = length(f);
    shft = rem((0:N-1)+fix(N/2),N)+1;
    sN = sqrt(N);
    a = mod(a,4);
    
    % do special cases
    if (a==0), Faf = f; return; end;
    if (a==2), Faf = flipud(f); return; end;
    if (a==1), Faf(shft,1) = fft(f(shft))/sN; return; end 
    if (a==3), Faf(shft,1) = ifft(f(shft))*sN; return; end
    
    % reduce to interval 0.5 < a < 1.5
    if (a>2.0), a = a-2; f = flipud(f); end
    if (a>1.5), a = a-1; f(shft,1) = fft(f(shft))/sN; end
    if (a<0.5), a = a+1; f(shft,1) = ifft(f(shft))*sN; end
    
    % the general case for 0.5 < a < 1.5
    alpha = a*pi/2;
    tana2 = tan(alpha/2);
    sina = sin(alpha);
    f = [zeros(N-1,1) ; interp(f) ; zeros(N-1,1)];
    % chirp premultiplication
    chrp = exp(-i*pi/N*tana2/4*(-2*N+2:2*N-2)'.^2);
    f = chrp.*f;
    
    % chirp convolution
    c = pi/N/sina/4;
    Faf = fconv(exp(i*c*(-(4*N-4):4*N-4)'.^2),f);
    Faf = Faf(4*N-3:8*N-7)*sqrt(c/pi);
    
    % chirp post multiplication
    Faf = chrp.*Faf;
    
    % normalizing constant
    Faf = exp(-i*(1-a)*pi/4)*Faf(N:2:end-N+1);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%
end
%%
function xint=interp(x)
    % sinc interpolation
    
    N = length(x);
    y = zeros(2*N-1,1);
    y(1:2:2*N-1) = x;
    xint = fconv(y(1:2*N-1), sinc([-(2*N-3):(2*N-3)]'/2));
    xint = xint(2*N-2:end-2*N+3);
end



%%%%%%%%%%%%%%%%%%%%%%%%%
function z = fconv(x,y)
 % convolution by fft
    
    N = length([x(:);y(:)])-1;
    P = 2^nextpow2(N);
    z = ifft( fft(x,P) .* fft(y,P));
    z = z(1:N);
    clc;clear;close all
    
    fs = 4e9;
    T = 1e-7;
    B = 1e9;
    Ts = 1/fs;
    t = -T/2:Ts:T/2;
    A = 1;
    f0=0;
    k = B/T;
    x = A*exp(1i*2*pi*(f0*t+k*t.^2));
    N = length(x);
    w=boxcar(101);
    w = [zeros(1,200),w',zeros(1,100)];
    y = x+w;
    ssf = linspace(-fs/2,fs/2,N);


    figure;
    subplot(211);
    plot(t, real(x)); xlabel('Time/s'); ylabel('Amplitude');
    title('Time-domain waveform of linear frequency-modulated signal');
    fxs = fftshift(fft(x));
    subplot(212);
    plot(ssf, abs(fxs)/N2);
    xlabel('Frequency/Hz')
    ylabel('Amplitude');
    title('Frequency spectrum of linear frequency-modulated signal');
    figure;
    subplot(211);
    plot(t, real(y)); xlabel('Time/s'); ylabel('Amplitude');
    title('Time-domain waveform of linear frequency-modulated signal with window function applied');
    fxsy = fftshift(fft(y));
    subplot(212);
    plot(ssf, abs(fxsy)/N2);
    xlabel('Frequency/Hz')
    ylabel('Amplitude');
    title('Frequency spectrum of linear frequency-modulated signal with window function applied');
    
    i = 1;
    p = 0.5:0.001:1.5;
    for i = 1:length(p)
        Faf(:,i) = frft(y,p(i));
    end
    [X,Y] = meshgrid(p,ssf);
    figure;surf(X,Y,abs(Faf));
    xlabel('Transformation order p');ylabel('Transformation domain')
    shading interp
    end