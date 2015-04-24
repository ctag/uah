%%
% Example 12.12
%
% filter from fir
%%
N=20;fc=125;Fs=1000;
wc=2*fc/Fs;wo=0;
ind= input(' rectangular (1) or hamming (2) windows?  ')
if ind==1,
 wind=1;
else
  wind=3;
end
[b]=fir(N,wc,wo,wind);
disp(' impulse respose')
h=b
[H,w]=freqz(b,1,256);
n=0:N;

figure(1)
subplot(221)
stem(n,b)
axis([0 N 1.2*min(b) 1.2*max(b)]); ylabel('h[n]');xlabel('n'); grid
subplot(222)
plot(w/pi,abs(H));grid; xlabel('\omega/\pi'); ylabel('|H(e^{j\omega})|')
axis([0 1 -0.1 1.1*max(abs(H))])
subplot(223)
plot(w/pi,20*log10(abs(H)));axis([0 1 -100 10]) 
xlabel('\omega/\pi'); ylabel('20 log10|H(e^{j\omega})| (dB)'); grid
subplot(224)
phase=unwrap(angle(H));
plot(w/pi,phase); axis([0 1 1.1*min(phase) 1.1*max(phase)])
xlabel('\omega/\pi'); ylabel('<H(e^{j\omega})'); grid