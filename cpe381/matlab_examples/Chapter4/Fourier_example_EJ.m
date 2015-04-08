% In class example Chapter 4, Fourier series
%
% E. Jovanov
% 2014
%

Fs=100;
dt=1/Fs;
t=0:dt:5;
figure
x=2*sin(2*pi*t); % signal
plot(t,x),title('Signal sine 1 Hz'),grid
pause
c1=cos(2*pi*t);
s1=sin(2*pi*t);
c2=cos(2*pi*2*t);
s2=sin(2*pi*2*t);
subplot(211)
plot(t,x,'b',t,c1,'m',t,x.*c1,'r'),axis([0 1 -2 2]),title('x * cos1'),grid
subplot(212)
plot(t,x,'b',t,s1,'m',t,x.*s1,'r'),axis([0 1 -2 2]),title('x * sin1'),grid
pause
sum(dt*x.*c1/5)     % coefficient c1
sum(dt*x.*s1/5)        % coefficient d1 

subplot(211)
plot(t,x,'b',t,c2,'m',t,x.*c2,'r'),axis([0 1 -2 2]),title('x * cos2'),grid
subplot(212)
plot(t,x,'b',t,s2,'m',t,x.*s2,'r'),axis([0 1 -2 2]),title('x * sin2'),grid
sum(dt*x.*c2/5)        % coefficient c2
sum(dt*x.*s2/5)        % coefficient d2
