% Example 4.5
%
% Computation of harmonics and harmonic frequencies of train of pulses
% using function fourierseries
%
clear all;clf
syms t
T0=1;
% signal
m=heaviside(t)-heaviside(t-T0/4)+heaviside(t-3*T0/4);x=2*m;
% harmonics and harmonic frequencies
[X,w]=fourierseries(x,T0,20);

figure(1)
subplot(211)
ezplot(x,[0 T0]);grid; title('period of x(t)')
subplot(223)
stem(w,abs(X)); grid; title('magnitude line spectrum')
axis([0 max(w) -0.1 1.1])
xlabel('k\Omega_0 (rad/sec)'); ylabel('|X_k|')
subplot(224)
stem(w,angle(X)); grid; title('phase line spectrum')
axis([0 max(w) -0.1  3.5])
xlabel('k\Omega_0 (rad/sec)'); ylabel('\angle{X_k}')

