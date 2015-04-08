%
% Example 10.20
%
% FFT of causal and non-causal signals
% 
clear all; clf
N=512; % order of fft
n=0:N-1;
% causal signal
x=[ones(1,33) zeros(1,N-33)];x=x.*sin(pi*n/32); % zero-padding
X=fft(x); X=fftshift(X); % fft and its shifting to [-1 1] frequency scale
w=2*[0:N-1]./N-1; % normalized frequencies
n1=[-10:39]; % time scale
figure(1)
subplot(211)
stem(n1,[zeros(1,10) x(1:40)]);grid; axis([-10 39 -0.1 1.2]); xlabel('n'); ylabel('x[n]')
subplot(223)
plot(w,abs(X));grid; ylabel('|X(e^{j\omega})|'); xlabel('\omega/\pi')
subplot(224)
plot(w,angle(X));grid; ylabel('<X(e^{j\omega})'); xlabel('\omega/\pi')

% non-causal signal
xnc=[zeros(1,3) x(1:33) zeros(1,3)]; % non-causal signal
x=[x(17:33) zeros(1,N-33) x(1:16)]; % periodic extension and zero-padding
X=fft(x); X=fftshift(X);
n1=[-19:19];
figure(2)
subplot(211)
stem(n1,xnc);grid; axis([-19 19 -0.1 1.2]); xlabel('n'); ylabel('x_1[n]') 
subplot(223)
plot(w,abs(X));grid; ylabel('|X_1(e^{j\omega})|'); xlabel('\omega/\pi')
subplot(224)
plot(w,angle(X));grid; ylabel('<X_1(e^{j\omega})'); xlabel('\omega/\pi')

