close all;
clear all;
clc;

Amp = 1;
freqHz = 2;  % signal frequency  
fsHz = 4000; % sampling frequency
dt = 1/fsHz; % sampling dt

% sampled sine wave
signal = Amp * (cos(2*pi*freqHz*(0:dt:1-dt)));

N = 100000; % will lead to ~96% zero padding
% Matlab will automatically add zero padding to signal if N is larger than signal length!
transform = fft(signal, N) / N;
magTransform = abs(transform);

% Baseband frequency spectrum
faxis = linspace(-fsHz/2,fsHz/2,N);
stem(faxis,fftshift(magTransform));
xlim([-5 5]);
xlabel('Frequency')