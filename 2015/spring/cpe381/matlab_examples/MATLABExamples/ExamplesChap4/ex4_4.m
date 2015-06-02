%%
% Example 4.4
%
% Computation of harmonics and harmonic frequencies of y(t)=1+sin(100 t)
% using function fourierseries
%%
clear all; clf
syms t 
% signal
y=1+sin(100*t);T0=2*pi/100;N=3;
figure(1)
subplot(211)
ezplot(y,[0,0.25]);grid
xlabel('t (sec)');ylabel('y(t)')
% harmonics and harmonic frequencies
[Y1, w1]=fourierseries(y,T0,N);
Y=[conj(fliplr(Y1(2:N))) Y1];w=[-fliplr(w1(2:N)) w1];
subplot(223)
stem(w,abs(Y)); grid
axis([-400 400 -0.1 1.1])
xlabel('k\Omega_0 (rad/sec)'); ylabel('|Y_k|')
subplot(224)
stem(w,angle(Y)); grid
xlabel('k\Omega_0 (rad/sec)'); ylabel('\angle{Y_k}')
axis([-400 400 -2 2])