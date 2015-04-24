%%
% Example 4.7
%
% Computation of harmonics and harmonic frequencies of full-wave rectified
% signal using function fourierseries
%%
clear all;clf
syms t
T0=1;N=20;
m=heaviside(t)-heaviside(t-T0);x=abs(cos(pi*t))*m;
[X,w]=fourierseries(x,T0,N);
figure(1)
subplot(221)
ezplot(x,[0 T0]);grid; title('period of x(t)')
subplot(223)
stem(w,abs(X)); grid; title('magnitude line spectrum')
axis([0 max(w) -0.1 0.7])
xlabel('k\Omega_0 (rad/sec)'); ylabel('|X_k|')
subplot(224)
stem(w,angle(X)); grid; title('phase line spectrum')
axis([0 max(w) 0  3.5])
xlabel('k\Omega_0 (rad/sec)'); ylabel('\angle{X_k}')

