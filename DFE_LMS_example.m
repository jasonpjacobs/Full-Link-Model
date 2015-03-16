clear all;


% https://www.youtube.com/watch?v=FLTN6Gwg8-4&list=PLC79262E787A9CBA9&t=214

N_symbols = 5000;
N_taps = 4;		% DFE size
Mu = 0.0005;          % iteration step size
vref = 0.75;

% Input symbols, either random:
if 1
    tx = sign(randn(N_symbols,1)); 
else
    % Or use a pulse
    tx = -1*ones(N_symbols);
    tx(10) = 1;
end

% Tx channel distortion
%h_tx = [.95 .15 .05 0 0];

%h_tx = [0.9 .1 0 0 .0];

h_tx = [.6 .2 -0.05 .0 .1];


% convolve channel with the input
x = filter(h_tx, 1, tx);

% Initialized variable that will be computed during the simulation
w = zeros(N_taps,1);
y = zeros(N_taps, 1);
g = ones(N_taps,1);
z = zeros(N_taps + 1,1);
y_h = zeros(N_taps + 1,1);
dw = zeros(N_taps + 1,1);

e = zeros(N_symbols,1);
c=zeros(N_symbols,N_taps);
gain=1.0;

% Expected values after convergence
expected_gain = 1/h_tx(1);
expected_c = h_tx(2:5)'*expected_gain;



for n  = N_taps+1 : length(x);
        
    % Compute the output of the VGA
    y(n) = gain*x(n);
    
    % Compute the output of the DFE with the current set of weights.
    z(n) = y(n) - sum(w.*y_h(n-1:-1:n-N_taps));
    
    % Output of the slicer
    y_h(n) = sign(z(n));

    % compute error
    ep = z(n) > vref;
    en = z(n) > -1*vref;
    if ( y_h(n) > 0)
        e(n) = ep;
        e(n) = z(n) - vref;
    else
        e(n) = en;
        e(n) = z(n) + vref;
    end
    

    % Update DFE weights
    updates = Mu*sign(e(n))*sign(y_h(n-1 : -1 : n - N_taps));
    dw(n) = updates(1);

    % Record current settings
    c(n,:) = w;    
    g(n) = gain;
    c0(n) = w(1);
    c1(n) = w(2);
    c2(n) = w(3);
    c3(n) = w(4);
    
    % Update DFE coefficient weight
    w = w + updates;
    
    % Update VGA gain settings
    gain = gain - Mu*sign(y_h(n))*sign(e(n));
end

% Plot the results
figure(1);
clf;
subplot(3,1,1);
hold off;
semilogy(abs(e));
title(['DFE Error Magnitude', num2str(Mu)]);

subplot(3,1,2);
stairs(-0.5 + 0:N_taps+1, [h_tx h_tx(end)]);
title('Normalized DFE coefficients vs. TX FIR filter coefficients');
hold on;
stem(w/gain);
legend('Channel response', 'DFE response');
hold off;

subplot(3,1,3);
hold on;
plot(g);
title('VGA gain, DFE Coefficient Evolution');
plot(c0);
plot(c1);
plot(c2);
plot(c3);
legend('gain', 'c0', 'c1', 'c2', 'c2');
hold off;


figure(2);
clf;
subplot(4,1,1);
x(1) = 1.1;
x(2) = -1.1;
stairs(x);
title('Channel output (x)');

subplot(4,1,2);
y(1) = 1.1;
y(2) = -1.1;
stairs(y);
title('VGA Output (y)');

subplot(4,1,3);
stairs(z);
title('DFE Output (z)');

subplot(4,1,4);
stairs(y_h);
title('Sampler Output (y_h)');

