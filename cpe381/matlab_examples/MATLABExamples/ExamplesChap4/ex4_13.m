%%
%  Example 13
%  Simulation of Convolution
%%
clear all; clf
Ts=0.01; Tend=2; t=0:Ts:Tend;
x=10*cos(20*pi*t+pi*(rand(1,1)-0.5));     % input signal
%x=y;
h=20*exp(-10.^t).*cos(40*pi*t);		% impulse response
% approximate convolution integral
y=Ts*conv(x,h);
M=length(x);
figure(1)
x1=[zeros(1,5) x(1:M)];
z=y(1);y1=[zeros(1,5) z zeros(1,M-1)];
t0=-5*Ts:Ts:Tend;
for k=0:M-6,
 h0=fliplr(h);
 h1=[h0(M-k-5:M) zeros(1,M-k-1)];
 subplot(211)
 plot(t0,h1,'r')
 hold on
 plot(t0,x1,'k')
 title('Convolution of x(t) and h(t)')
 ylabel('x(\tau), h(t-\tau)'); grid; axis([min(t0) max(t0) 1.1*min(x) 1.1*max(x)])
 hold off
 subplot(212)
 plot(t0,y1,'b')
 ylabel('y(t)=(x*h)(t)'); grid; axis([min(t0) max(t0) 0.1*min(x) 0.1*max(x)])
 z=[z y(k+2)];
 y1=[zeros(1,5) z zeros(1,M-length(z))];
 pause(0.2)
end  
