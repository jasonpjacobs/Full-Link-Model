clear all;
%% System is a simple RC filter
ff = logspace(1,6, 1000);
R = 22e3;
C = 2.2e-9;
tau = R*C;
f_low = 1/(2*pi*R*C);
p1 = f_low;
w1 = 2*pi*p1;


%% Calculate the response the old fashioned way
ww = 2*pi*ff;
Hf2 = 1./(1 + j*ww*R*C);

%% Old fasioned digital filter
% x = e^ (-2*pi*f_c)
x0 = exp(-2*w1);
a = 1- x0;
b = x0;


%% Calculate using a Control System LTI system
sys_c = zpk( [], w1, w1);
%bode(sys_c);
[b a] = tfdata(tf(sys_c),'v');
[Hf1] = freqs(b,a,2*pi*ff);


%% Recreate system as a discrete system
Ts = 1e-12;
sys_d = zpk([], w1, w1, Ts);
[n d ts] = tfdata(tf(sys_d),'v');

ir_input = zeros(100,1);
ir_input(1) = 1;

ir = filter(n, d, ir_input);

%% Plotting
figure;
grid on;
subplot(2,1,1)
xlim([1e1, 1e6]);
semilogx(ff, 20*log10(abs(Hf1)));
hold on;
fl = 1/(2*pi*R*C);
stem(fl, -3);
hold off;

subplot(2,1,2);
semilogx(ff, 20*log10(abs(Hf2)));
hold on;
fl = 1/(2*pi*R*C);
stem(fl, -3);



