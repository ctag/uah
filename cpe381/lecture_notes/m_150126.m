%-- 1/26/2015 2:24 PM --%
T=1; % T=1 second
Fs=1000;% sampling frequency is Fs=10Hz
Ts = 1/Fs;
n=1:2000; % index (multiple of sampling intervals)
t=n*Ts;
f=1/T;
s=sin(2*pi*f*t);
figure
e1=exp(-t);	% exponential decrease of amplitude
e2=exp(-2*t);	% more dumping?
plot(t,e1,'b',t,e2,'r'),grid
figure
subplot(211)
plot(t,s)
subplot(212)
plot(t,s.*e1,'r',t,e1,'b:',t,-e1,':') % dumped sine wave
grid
