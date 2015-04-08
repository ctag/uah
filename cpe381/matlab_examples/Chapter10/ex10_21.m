

%
% Example 10.21
%
% Improving frequency resolution of FFT of periodic signals
%
f0=100; f1=4*f0; % frequency in Hz 
Ts=1/(3*f1); % sampling period
t=0:Ts:4/f0; % time for 4 periods
y=4*cos(2*pi*f0*t)-cos(2*pi*f1*t); % sampled signal (4 periods)
M=length(y);
Y=fft(y,M); Y=fftshift(Y)/4; % fft using 4 periods, shifting and normalizing

t1=0:Ts:12/f0; % time for 12 periods
y1=4*cos(2*pi*f0*t1)-cos(2*pi*f1*t1); % sampled signal (12 periods)
Y1=fft(y1);Y1=fftshift(Y1)/12; % fft using 12 periods, shifting and normalizing
w=2*[0:M-1]./M-1; f=w/(2*Ts); % frequency scale

figure(1)
subplot(211)
stem(t,y);grid
hold on
plot(t,y,'r')
hold off; xlabel('nT_s'); ylabel('x(nT_s)')
subplot(223)
plot(f,abs(Y));grid; xlabel('f (Hz)'); ylabel('|X(f)|'); axis([-600 600 0 28])
subplot(224)
plot(f,angle(Y));grid; xlabel('f (Hz)'); ylabel('<X(f)'); axis([-600 600 -4 4])

N=length(y1);
w=2*[0:N-1]./N-1;f=w/(2*Ts);

figure(2)
subplot(211)
stem(t1,y1);grid
hold on
plot(t1,y1,'r')
hold off; xlabel('nT_s'); ylabel('x(nT_s)')
subplot(223)
plot(f,abs(Y1));grid; ; xlabel('f (Hz)'); ylabel('|X(f)|'); axis([-600 600 0 28])
subplot(224)
plot(f,angle(Y1));grid; xlabel('f (Hz)'); ylabel('<X(f)'); axis([-600 600 -4 4])