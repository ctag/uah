%
% Example 11.13
%
% filter from fir
%
N=14;wc=0.2;wo=1;wind=4;
[b]=fir(N,wc,wo,wind);
disp(' impulse respose')
h=b
[H,w]=freqz(b,1,256);
n=0:N;

figure(1)
subplot(221)
stem(n,b)
axis([0 N 1.1*min(b) 1.1*max(b)]); ylabel('h[n]');xlabel('n'); grid
subplot(222)
plot(w/pi,abs(H));grid; xlabel('\omega/\pi'); ylabel('|H(e^{j\omega})|')
axis([0 1 0 1.1*max(abs(H))])
subplot(223)
plot(w/pi,20*log10(abs(H)));axis([0 1 -100 10]) 
xlabel('\omega/\pi'); ylabel('20 log10|H(e^{j\omega})| (dB)'); grid
subplot(224)
phase=unwrap(angle(H));
plot(w/pi,phase); axis([0 1 min(phase) max(phase)])
xlabel('\omega/\pi'); ylabel('<H(e^{j\omega})'); grid