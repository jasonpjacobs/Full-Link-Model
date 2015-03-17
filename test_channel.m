clear all;
ch = Channel('.\Full Link Model\peters_01_0605_T20_thru.s4p');
%ch.plot('s11')
%ch.plot('s21')
%[h t] = ch.impulse();

%hold
%subplot(2,1,1)
%plot(t,h);

subplot(3,1,1)
H = ch.s21;
plot(ch.freqs, 20*log10(abs(H)));

hold on;
Y = ch.s21;
f = ch.freqs;
Y = [Y(1:end-1) -1*fliplr(Y(2:end))]
f = [f(1:end-1) -1*fliplr(f(2:end))]
plot(f, 20*log10(abs(Y)));

%% Reference version

Tsym=100e-12;	%%% Symbol Rate: e.g., Tsym = 1/fsym = 1/10 Gb/s
Ts=Tsym/100;		%%% CppSim internal time step, also used to sample
f = ch.freqs;
h = xfr_fn_to_imp(f,H,Ts,Tsym);
num_fft_pts=2^16;

% set the symbol frequency
f_sym=1/Tsym;
% get the maximum sampling frequency from the transfer function
f_sym_max=2*max(f);
% stop the simulation if the symbol frequency is smaller than the maximum
% measured sampling frequency
if (f_sym > f_sym_max), 
   error('Max input frequency too low for requested symbol rate, can''t interpolate!');
end	

f_sym_max=f_sym*floor(f_sym_max/f_sym);     % Originally 2*15GHz
Hm=abs(H);
Hp=angle(H);

%%% need to force phase to zero at zero frequency to avoid funky behavior
if f(1)==0,
   Hm_ds=[fliplr(Hm(2:end-1)) Hm];
   Hp_ds=[fliplr(-Hp(2:end-1)) Hp];
   fds=[-fliplr(f(2:end-1)) f];
   fds_m = fds; 
   fds_p = fds;
else
   Hm_ds=[fliplr(Hm(1:end-1)) Hm];
   Hp_ds=[fliplr(-Hp(1:end-1)) Hp];
   fds_m=[-fliplr(f(1:end-1)) f];
   fds_p=[-fliplr(f(1:end-1)) 0 f];
end

H_ds=Hm_ds.*exp(j*Hp_ds)

%h = ch.imp2();
if 0
    subplot(3,1,2);
    title('reference');
    plot(fds_m, 20*log10(abs(H_ds)));

    hold on;
    Y = ch.s21;
    f = ch.freqs;
    Y = [Y(1:end-1) -1*fliplr(Y(2:end))];
    f = [f(1:end-1) -1*fliplr(f(2:end))];
    plot(f, 20*log10(abs(Y))-1);
end

subplot(3,1,3);
imp=ifft(H_ds);
imp_r=real(imp)
plot(imp);

