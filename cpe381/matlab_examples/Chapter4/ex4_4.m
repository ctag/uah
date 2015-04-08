% Example 4.4
%
% Computation of harmonics and harmonic frequencies of y(t)=1+sin(100 t)
% using function fourierseries
%
clear all
syms t 
% signal
y=1+sin(100*t);T0=2*pi/100;N=5;
figure(1)
subplot(211)
ezplot(y,[0,0.25]);grid
xlabel('t (sec)');ylabel('y(t)')
% harmonics and harmonic frequencies
[Y, w]=fourierseries(y,T0,N);
subplot(223)
stem(w,abs(Y)); grid
axis([0 500 -0.1 1.1])
xlabel('k\Omega_0 (rad/sec)'); ylabel('|Y_k|')
subplot(224)
stem(w,angle(Y)); grid
xlabel('k\Omega_0 (rad/sec)'); ylabel('\angle{Y_k}')
axis([0 500 -1.8 0.1])