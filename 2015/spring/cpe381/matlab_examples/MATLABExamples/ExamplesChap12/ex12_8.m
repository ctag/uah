%%
% Example 12.8
%
% filtering of analog signal
%%
clear all; clf
Fs=9000; fp=2250; fst=2700;                                             % analog freq spec
wh=2*pi*fp/Fs; ws=2*pi*fst/Fs; alphamin=9;                              % discrete filter specs
N=log10((10^(0.1*alphamin)-1))/(2*log10(tan(ws/2)/tan(wh/2)));N=ceil(N) % min order
[b,a]=butter(N,wh/pi);
[H,w]=freqz(b,a);w=w/pi; M=length(H);f=w*Fs/2;
alpha0=-18;
G=10^(-alpha0/20);H=H*G;
% normalized filter
disp(' filter coefficients ')
b=G*b
a
% spec verification
spec2=alpha0+alphamin*ones(1,M);
hpf=alpha0+3.01*ones(1,M);
disp('poles')
p=roots(a)
disp('zeros')
z=roots(b)
alpha=-20*log10(abs(H));
disp(' factorization')
D1=poly([p(1) p(2)])
D2=poly([p(3) p(4)])
N1=poly([z(1) z(2)])
N2=poly([z(3) z(4)])
Ha=unwrap(angle(H));

figure(1)
subplot(221)
zplane(b,a)
subplot(222)
plot(f,abs(H)); grid; axis([0 max(f) 0 1.1*max(abs(H))]); ylabel('|H(f)|'); xlabel('f (Hz)')
subplot(223)
plot(f,Ha);grid; ylabel('<H(f) (rad)'); xlabel('f (Hz)')
axis([0 max(f) 1.1*min(Ha) 1.1*max(Ha)]);
subplot(224)
plot(f,alpha); ylabel('\alpha(f) dB'); xlabel('f (Hz)')
hold on
plot(f,hpf,'r')
hold on
plot(f,spec2,'r'); grid; axis([0 max(f) -20 0]); hold off
