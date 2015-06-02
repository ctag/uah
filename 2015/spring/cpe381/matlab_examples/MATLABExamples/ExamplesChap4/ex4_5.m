%%
% Example 4.5
%
% Computation of harmonics and harmonic frequencies of train of pulses
% using function fourierseries
%%
clear all;clf
syms t
T0=1;N=20;
% signal
m=heaviside(t)-heaviside(t-T0/4)+heaviside(t-3*T0/4);x=2*m;
% harmonics and harmonic frequencies
[X1,w1]=fourierseries(x,T0,N);
X=[conj(fliplr(X1(2:N))) X1];w=[-fliplr(w1(2:N)) w1];
figure(1)
subplot(221)
ezplot(x,[0 T0]);grid; title('period of x(t)')
subplot(222)
stem(w,X); grid; axis([min(w) max(w) -0.5 1.1]); title('real X(k)')
xlabel('k\Omega_0 (rad/sec)'); ylabel('X_k')

subplot(223)
stem(w,abs(X)); grid; title('magnitude line spectrum')
axis([min(w) max(w) -0.1 1.1])
xlabel('k\Omega_0 (rad/sec)'); ylabel('|X_k|')
subplot(224)
stem(w,[-angle(X1(2:N)) angle(X1)]); grid; title('phase line spectrum')
axis([min(w) max(w) -3.5  3.5])
xlabel('k\Omega_0 (rad/sec)'); ylabel('\angle{X_k}')

