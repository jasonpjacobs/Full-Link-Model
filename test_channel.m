ch = Channel('peters_01_0605_T20_thru.s4p');
%ch.plot('s11')
%ch.plot('s21')
[h t] = ch.impulse();

%hold
%subplot(2,1,1)
plot(real(h));

%subplot(2,1,2)
H = ch.s21;
Tsym=100e-12;	%%% Symbol Rate: e.g., Tsym = 1/fsym = 1/10 Gb/s
Ts=Tsym/100;		%%% CppSim internal time step, also used to sample
f = ch.freqs;
h = xfr_fn_to_imp(f,H,Ts,Tsym);
%h = ch.imp2();
%plot(h)