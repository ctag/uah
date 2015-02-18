%-- 1/21/2015 2:20 PM --%
T=1; % T=1 second
Fs=10;% sampling frequency is Fs=10Hz
Ts = 1/Fs;
n=1:20; % index (multiple of sampling intervals)
t=n*Ts;
f=1/T;
s=sin(2*pi*f*t);
figure
plot(t,s)
pause
stem(t,s)% stem plot (individual samples)
% let's improve sampling frequency
Fs=1000;% [Hz]
Ts = 1/Fs;
n=1:2000; % index (multiple of sampling intervals)
t=n*Ts; % new time
s=sin(2*pi*f*t); % new sine wave at 1Hz
plot(t,s),grid
s2=sin(2*pi*2*t);% another signal at 2 Hz
plot(t,s,t,s2),grid % plot both signals