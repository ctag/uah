%%
% Example 12.10
%
% Butterworth/Chebyshev filters for analog signal
%%
clear all; clf
wh=0.4*pi;ws=0.5*pi; alphamin=40;Fs=20000;
ind=input('Butterworth (1) or Chebyshev (2) ?  ');
if ind==1,
% Butterworth
N=log10((10^(0.1*alphamin)-1))/(2*log10(tan(ws/2)/tan(wh/2))); N=ceil(N)
[b,a]=butter(N,wh/pi)
disp('normalized whp')
whp=wh/pi
else
% Chebyshev
N=15  
alphamax=0.001;
epsi=sqrt(10^(0.1*alphamax)-1);
wp=2*atan(tan(0.5*wh)/(cosh(acosh(sqrt(10^(0.1*3.01)-1)/epsi)/N)));
disp(' normalized wp')
wp=wp/pi
[b,a]=cheby1(N,alphamax,wp)
end
% magnitude and phase
[H,w]=freqz(b,a);w=w/pi;M=length(H);f=w*Fs/2;

alpha0=-20;H=H*10;
spec2=alpha0+alphamin*ones(1,M);
hpf=alpha0+3.01*ones(1,M);
alpha=-20*log10(abs(H));
Ha=unwrap(angle(H));

figure(1)
subplot(221)
zplane(b,a)
if ind==1,
    title(' Butterworth LPF')
else
    title(' Chebyshev LPF')
end
subplot(222)
plot(f,abs(H)); grid; axis([0 max(f) 0 1.1*max(abs(H))]); ylabel('|H(f)|'); xlabel('f (Hz)')
subplot(223)
plot(f,Ha);grid; ylabel('<H(f)(rad)'); xlabel('f (Hz)')
axis([0 max(f) 1.1*min(Ha) 1.1*max(Ha)]);
subplot(224)
plot(f,alpha); ylabel('\alpha(f) dB'); xlabel('f (Hz)')
hold on
plot(f,hpf,'r--')
hold on
plot(f,spec2,'r--'); grid; axis([0 max(f) -25 25]); 
hold off

