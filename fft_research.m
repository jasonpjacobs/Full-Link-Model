close;
clear all;

%% Create a time domain signal
N = 10; % Number of samples in the signal
t_final = 1;
dt = t_final/N;  % Sample rate
t = 0:dt:(N-1)*dt;
fs=1/dt;  % Sample rate, in Hertz

% Create the signal
F1=1;
F2=3;
y = sin(2*pi*F1*t) + 0*sin(2*pi*F2*t);

figure;
subplot(3,1,1);
plot(t,y);

%% Create its frequency domain response
[Y, f] = fft_f(y, dt);

% Create a single sided verson
L = (floor((N-1)/2) + 1);
fb = fftshift(f);
Yb = fftshift(Y);

f2 = -1*fliplr(fb(1:L+1));
Y2 = -1*fliplr(Yb(1:L+1));

subplot(3,1,2);
stem(f,abs(Y));
hold on
stem(f2, abs(Y2), '-r');

%% IFFT and compare to the original;
% y1 = N*ifft(Y);
[y1, t] = ifft_t(Y, f);

subplot(3,1,3);
plot(t,y1, '-r');
hold on;

[y2, t2] = ifft_t(Y2, f2);
plot(t2, real(y2), '*b');
