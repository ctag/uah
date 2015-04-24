%%
% Example 12.6
%
% Bilinear transformation
%%
clear all; clf
b=[1 0 0]; a=[1 sqrt(2) 1];                             % coefficients of analog filter
whp=0.5*pi;                                             % desired half-power frequency of discrete filter
Kb=1/tan(whp/2); Fs=Kb/2; [num, den]=bilinear(b,a,Fs);  % bilinear transf.
ind=input('sum of cosine (1) or handel signal (2) ?  ')
if ind==1,
Ts=1/500;                                               % sampling period
n=0:49; x1=cos(2*pi*20*n*Ts)+cos(2*pi*250*n*Ts);        % sampled signal   
else
load handel
n=0:499;x1=y(1:500)';Ts=1/Fs
end
t=n*Ts;
[H,w]=freqz(num,den);                                   % frequency response of discrete filter
f=w/pi/(2*Ts);                                          % analog frequency in Hz
phi=unwrap(angle(H));
y=filter(num,den,x1);

figure(1)
subplot(311)
zplane(num, den)                                        % poles/zeros of discrete filter
subplot(312)
plot(f,abs(H)); grid; axis([0 max(f) 0 1.1]);
hold on
plot(f,0.707*ones(1,length(w)),'r')
hold off
ylabel('|H(f)|'); xlabel('f (Hz)')
subplot(313)
plot(f,phi); grid; axis([0 max(f) 1.1*min(phi) 1.1*max(phi)]);
ylabel('<H(f)'); xlabel('f (Hz)')

figure(2)
subplot(211)
plot(t,x1); grid; xlabel('t'); ylabel('x(t)'); axis([0 max(t) 1.1*min(x1) 1.1*max(x1)])
subplot(212)
plot(t,y); grid; xlabel('t'); ylabel('y(t)'); axis([0 max(t) 1.1*min(y) 1.1*max(y)])
