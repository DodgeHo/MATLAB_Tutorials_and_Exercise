% Kurtosis Calculation of Digital Signal
% By Dodge: asdsay@gmail.com

%%
clear all;clc;clf;close all

%% Signal synthesis
fs=1000;
SampFreq = fs;
t=0:1/fs:1;
A=2;
f0=100;
x=A*exp(1j*(2*pi*(f0+1/2*150*(t.^2))));

figure(1)
plot(t,real(x))  % draw the time waveform of the real part
title('Time-domain waveform')

%% frequency spectrum
Spec = 2*abs(fft(real(x)))/length(x);
Spec = Spec(1:round(end/2));
Freqbin = linspace(0,SampFreq/2,length(Spec));

figure(2)
plot(Freqbin,Spec,'linewidth',2);
xlabel('\FFrequency\fontname{Times New Roman}/Hz','FontSize',12);
ylabel('\Amplitude\fontname{Times New Roman}/(m^2 \cdot t^{-1})','FontSize',12);
% axis([0 500 0 1.2*max(Spec)])

%% Spectral kurtosis
bw=20;
%bw=3*f0;
step=1;
cf=bw/2:step:fs/2-bw/2;
% i =[cf-bw/2+1 cf+bw/2+1];
% Hy(i,:)= abs(hilbert(real(Spec(i,:))));
% a=kurtosis(Hy(i,:));
kurtosisArray = zeros(1, length(cf));

for idx = 1:length(cf)
    i = cf(idx)-bw/2 : cf(idx)+bw/2;
    i(i<1) = []; i(i>fs/2) = [];  % Values out of range are deleted
    if isempty(i)
        continue;
    end
    Hy = abs(hilbert(Spec(round(i))));
    kurtosisArray(idx) = kurtosis(Hy);
end

figure(1)
%plot(cf,a);
plot(cf, kurtosisArray);
xlabel('Center Frequency (Hz)');
ylabel('Kurtosis');
title('Kurtosis vs Center Frequency');
set(gcf,'color','w');
