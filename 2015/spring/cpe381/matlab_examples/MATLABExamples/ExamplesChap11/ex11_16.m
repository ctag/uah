%%
% Example 11.16
%
% A crude spectral analyzer
% Filtering of a periodic signal
%%
clear all; clf
N=500;n=0:N-1; x=cos(0.2*pi*n); x=sign(x); % train of pulses
X=fft(x)/50; X=X(1:250); % approximate DTFT of signal using fft
L=500;w1=0:2*pi/L:pi-2*pi/L;w1=w1/pi; % range of frequencies
h1=fir1(30,0.1); % low-pass filter
h2=fir1(30,0.6,'high'); % high-pass filter
h3=fir1(30,[0.1 0.6]); % band-pass filter
y1=filter(h1,1,x); y2=filter(h2,1,x); y3=filter(h3,1,x); y=y1+y2+y3;
[H1,w]=freqz(h1,1); [H2,w]=freqz(h2,1); [H3,w]=freqz(h3,1); H=H1+H2+H3;
N1=length(h1); n=0:length(h1)-1; n1=0:49;

figure(1)
subplot(311)
plot(w/pi,abs(H1)); grid; hold on
plot(w/pi,abs(H2),'r'); grid; hold on
plot(w/pi,abs(H3),'k'); grid; ylabel('|H_i(e^{j\omega})|'); xlabel('\omega/\pi'); hold off
legend('LPF','HPF','BPF')
subplot(312)
stem(n1,x(1:50)); grid; axis([0 49 1.1*min(x(1:50)) 1.1*max(x(1:50))])
ylabel('x[n]'); xlabel('n')
subplot(313)
plot(w1,abs(X)); grid; ylabel('|X(e^{j\omega})|'); xlabel('\omega/\pi')

figure(2)
subplot(311)
stem(y1(1:100)); grid; ylabel('y_1[n]')
subplot(312)
stem(y2(1:100)); grid; ylabel('y_2[n]')
subplot(313)
stem(y3(1:100)); grid; ylabel('y_3[n]'); xlabel('n')

figure(3)
subplot(211)
plot(w/pi, abs(H));grid;axis([min(w/pi) max(w/pi) 0 1.1]); ylabel('|H(e^{j\omega})|'); xlabel('\omega/\pi')
subplot(212)
stem(y(1:100)); grid; ylabel('y[n]'); xlabel('n')
