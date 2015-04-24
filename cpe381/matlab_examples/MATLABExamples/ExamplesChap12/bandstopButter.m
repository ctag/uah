%%
% Band-stop Butterworth/Chebyshev using buttercheby1 function
%%
clear all; clf
ind=input('Butterworth (1) or Chebyshev (2) band-stop?   ')
if ind==1,
[b,a]=buttercheby1(15,[0.4 0.6],0,4)
else
[b,a]=buttercheby1(15,[0.4 0.6],1,4)
end
% magnitude and phase
[H,w]=freqz(b,a); w=w/pi; M=length(H);
Ha=unwrap(angle(H));
% loss function
alpha=-20*log10(abs(H));

figure(1)
subplot(221)
zplane(b,a)
if ind==1,
    title(' Stop-band Butterworh')
else
    title(' Stop-band Butterworh')
end
subplot(222)
plot(w,abs(H)); grid; axis([0 1 0 1.1*max(abs(H))]); ylabel('|H(e^{j\omega})|'); xlabel('\omega/\pi')
subplot(223)
plot(w,Ha);grid; ylabel('<H(e^{j\omega}) (rad)'); xlabel('\omega/\pi')
axis([0 1 1.1*min(Ha) 1.1*max(Ha)]);
subplot(224)
plot(w,alpha); ylabel('\alpha(e^{j\omega}) dB'); xlabel('\omega/\pi');grid
axis([0 1 -20 250]);

