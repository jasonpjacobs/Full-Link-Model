close;
clear all;

%% Create a time domain signal
N = 1001; % Number of samples in the signal
t_final = 1;
dt = t_final/N;  % Sample rate
t = 0:dt:(N-1)*dt;
fs=1/dt;  % Sample rate, in Hertz

% Create the signal
F1=1;
F2=3;
y = sin(2*pi*F1*t) + 0.5*sin(2*pi*F2*t);

figure;
subplot(3,1,1);
plot(t,y);
title('Original time domain');

%% Create its frequency domain response
[Y, f] = fft_f(y, dt);

% Create a single sided verson
if (mod(N,2) == 0)
%     L = (floor((N-1)/2) + 1);
%     fb = fftshift(f);
%     Yb = fftshift(Y);
% 
%     f2 = fliplr(fb(1:L+1));
%     Y2 = fliplr(Yb(1:L+1));
    
    [Y2 f2] = ds_to_ss(Y, f);
    [Y2ds f2ds] = ss_to_ds(Y2, f2);
else
%     L = (floor((N-1)/2) + 1);
%     fb = fftshift(f);
%     Yb = fftshift(Y);
% 
%     f2 = abs(fliplr(fb(1:L)));
%     Y2 = abs(fliplr(Yb(1:L)));
    [Y2 f2] = ds_to_ss(Y, f);
    [Y2ds f2ds] = ss_to_ds(Y2, f2);
end
[Y2 f2] = ds_to_ss(Y, f);

subplot(3,1,2);
stem(f,abs(Y));
title('Frequency Domain');
hold on
stem(f2, abs(Y2), '-r');
legend('Full FFT ouput','SS->DS FFT');

%% IFFT and compare to the original;
% y1 = N*ifft(Y);
[y1, t] = ifft_t(Y, f);

subplot(3,1,3);
plot(t,y1, '-r');
title('Time domain');

hold on;

[y2, t2] = ifft_t(Y2, f2);
plot(t2, real(y2), '-b');
