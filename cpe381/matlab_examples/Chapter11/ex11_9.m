% 
% Example 11.9
%
% LP Chebyshev
%
clear all; clf
alphamax=2;  alphamin=9; % loss specs
figure(1)
for i=1:2,
 wp=0.47+(i-1)*0.01; ws=0.6; % normalized frequency specifications
 [N,wh]=cheb1ord(wp,ws,alphamax,alphamin); % min order and passband frequency
 [b,a]=cheby1(N,alphamax,wh); % filter coefficients
 wp=wh*pi;
 % magnitude and phase
 [H,w]=freqz(b,a); w=w/pi; M=length(H); H=H/H(1);
 % ripple and half-power freq
 epsi=sqrt(10^(0.1*alphamax)-1);
 whp= 2*atan(tan(0.5*wp)*cosh(acosh(sqrt(10^(0.1*3.01)-1)/epsi)/N));whp=whp/pi
 
 % spec verification
 spec0=zeros(1,M);
 spec1=alphamax*ones(1,M)*(-1)^(N+1);
 spec2=alphamin*ones(1,M);
 alpha=-20*log10(abs(H));
 hpf=(3.01+alpha(1))*ones(1,M);
 disp('poles');
 roots(a);
 disp('zeros');
 roots(b);
 
 subplot(221)
 zplane(b,a)
 subplot(222)
 plot(w,abs(H)); grid; ylabel('|H(e^{j\omega})|'); axis([0 max(w) 0 1.1*max(abs(H))])
 subplot(223)
 plot(w,unwrap(angle(H)));grid; ylabel('<H(e^{j\omega}) (rad)'); xlabel('\omega/\pi)')
 subplot(224)
 plot(w,alpha); ylabel('\alpha((e^{j\omega})) dB'); xlabel('\omega/\pi')
 hold on; plot(w,spec0,'r'); hold on; plot(w,spec1,'r'); hold on; plot(w,hpf,'k'); hold on
 plot(w,spec2,'r'); grid; axis([0 max(w) 1.1*min(alpha) 1.1*(alpha(1)+3)]); hold off
 figure(2)
end