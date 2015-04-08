%
% Example 7.3 
%
% Two sinusoids of different frequencies being sampled 
% with same sampling period -- aliasing for signal with higher frequency
%
clear all; clf
% sinusoids
omega_0=1;omega_s=7;
T=2*pi/omega_0; t=0:0.001:T;    % one period of x1
x1=cos(omega_0*t);
x2=cos((omega_0+omega_s)*t);

N=length(t); Ts=2*pi/omega_s;
M=fix(Ts/0.001);
imp=zeros(1,N);

for k=1:M:N-1.
    imp(k)=1;
end

figure(1)
plot(t,x1,'b',t,x2,'k'); hold on
stem(t,imp.*x1,'r','filled');axis([0 max(t) -1.1 1.1]); xlabel('t'); grid
legend('x_1(t)','x_2(t)','x_1(nTs)'); xlabel('t'); ylabel('x_1(t), x_2(t), x_1(nTs)')