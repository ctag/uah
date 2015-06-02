%%
% Example 7_8
%
% General filter design 
%%
clear all;clf
N=10;Whp=10;
ind=input(' Butterworth HP (1); Elliptic LP (2); Chebyshev2  BP (3); Elliptic stopband (4)?   ')
if ind==1,
[b,a]=butter(N,Whp,'high','s') % B highpass
elseif ind==2,
[b,a]=ellip(N,0.1,40,10,'low','s') % E lowpass
elseif ind==3,
[b,a]=cheby2(N,60,[10 20],'s') % C2 bandpass
else
[b,a]=ellip(N/2,0.1,40,[10 11],'stop','s') % E stopband
end
W=0:0.01:30;
H=freqs(b,a,W);
figure(1)
subplot(211)
plot(W,abs(H)); grid; ylabel('|H(j\Omega)|'); xlabel('\Omega')
axis([0 30 0 1.1])
subplot(212)
plot(W,unwrap(angle(H))); grid; ylabel('<H(j\Omega)'); xlabel('\Omega')
axis([0 30 -10 10])