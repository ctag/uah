%
% Example 6.8
%
% filtering with butterworth
%
clear all; clf 
syms t w
x=cos(10*t)-2*cos(5*t)+4*sin(20*t); % input signal
X=fourier(x)
N=3;Whp=5;  % filter order and half-power frequency
[b,a]=butter(N,Whp,'s') % coefficients of designed filter
% frequency response of filter
W=0:0.01:30;
Hm=abs(freqs(b,a,W));

figure(1)
subplot(121)
splane(b,a)
subplot(122)
plot(W,Hm);grid; xlabel('\Omega'); ylabel('|H(j\Omega)|')

% filter output
n=N:-1:0;
U=(j*w).^n
num=b*conj(U')
den=a*conj(U')
H=num/den
Y=X*H
y=ifourier(Y,t)

figure(2)
subplot(211)
ezplot(x,[0,20]); axis([0 20 -12 12]); xlabel('t'); ylabel('x(t)'); grid
subplot(212)
ezplot(y,[0,20]); axis([0 20 -3 3]); xlabel('t'); ylabel('y(t)'); grid
title(' ')
