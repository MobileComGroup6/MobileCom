clear all;
close all;
clc;

Fs = 10000;
dt = 1/Fs;

t = (0:dt:1-dt);

f = 200;

signal = wgn(1,length(t),0);
figure; plot(signal); ylim([-3,3]); title('Signal');

% FFT
NFFT = 2^nextpow2(length(signal));
fft_signal = abs(fft(signal, NFFT));
faxis = Fs/2*linspace(0,1,NFFT/2+1);

figure;plot(faxis, fft_signal(1:NFFT/2+1)); title('FFT(signal)');

sigma = 20;
sigma_f = 1 / 2 / pi / sigma;
w = 2*ceil(1.5*sigma)+1;
filter = 1/(sqrt(2*pi)*sigma)*exp(-(-w:w).^2/(2*sigma^2));
figure;plot((-w:w), filter), title('Filter');  ylim([-1, 2]);

fft_filter = abs(fft(filter, NFFT));
figure;plot(faxis, fft_filter(1:NFFT/2+1)), title('Filter Freq. Domain'); ylim([-1, 2]);

filtered = conv(signal, filter, 'same');
figure;plot(filtered);title('Filtered Signal');

fft_filtered = abs(fft(filtered, NFFT));
figure;plot(faxis, fft_filtered(1:NFFT/2+1)); title('FFT(filtered signal)');

modulated = pmmod(filtered, 500, Fs, pi/2);
fft_modulated = abs(fft(modulated, NFFT));
figure;plot(faxis, fft_modulated(1:NFFT/2+1)); title('FFT(modulated signal)');
%%
clear all;
close all;
clc;
%%

Fs = 10000;

medium = Medium;
jammer = Jammer(medium, Fs, 'narrowband');
jammer.jam(200, 2); % Jam 200Hz band with 2db

