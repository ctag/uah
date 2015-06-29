% Lab 04 Problem 2

% P2.a
fs=8000;
f1=697;
f2=1209;
t=0:(1/fs):1;
y_t=sin(2*pi*f1*t) + sin(2*pi*f2*t);
figure
plot(t,y_t);
title('Combined Sine Waves');
xlabel('Time');
ylabel('Amplitude');
axis([0 0.05 -2 2]);

% P2.c
L=8001;
nfft=2^nextpow2(L);
fq=fft(y_t,nfft)/L;
f=fs/2*linspace(0,1,nfft/2+1);
figure
plot(f,2*abs(fq(1:nfft/2+1)));
title('Signal Spectrum');
xlabel('Frequency');
ylabel('Magnitude');