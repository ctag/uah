%% 
% Example 9.12
%% 
a=-4*log(0.9);Ts=0.25;
alpha=exp(-a*Ts);
n=0:30; y=alpha.^n.*cos(pi*n/2);
t=0:0.001:max(n)*Ts; x=exp(-a*t).*cos(2*pi*t);
stem(n,y,'r')
hold on
plot(t/Ts,x);grid;legend('y[n]','x(t)'); xlabel('t/Ts')
hold off