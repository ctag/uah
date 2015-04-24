%%
% DTFT of sampled signal
%%
Ts=0.01; t=0:Ts:(L-1)*Ts; x=5.^(-2*t);
X=fft(x);
figure(1)
w=0:2*pi/L:2*pi-2*pi/L;w1=(w-pi)/Ts;
n=0:length(x)-1;
subplot(311)
stem(t,x); axis([0 max(t) 1.1*min(x) 1.1*max(x)]); grid
xlabel('nT_s (sec)'); ylabel('x(nT_s)')
subplot(312)
plot(w1,fftshift(abs(X)));axis([min(w1) max(w1) 0 1.1*max(abs(X))])
ylabel('|X(e^{j\Omega T_s})|'); grid
subplot(313)
plot(w1,fftshift(angle(X)))
axis([min(w1) max(w1) 1.1*min(angle(X)) 1.1*max(angle(X))])
ylabel('<X(e^{j\Omega T_s})'); xlabel('\Omega (rad/sec)'); grid
