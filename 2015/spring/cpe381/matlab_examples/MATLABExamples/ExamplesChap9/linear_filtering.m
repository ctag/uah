%%
%
% Linear filtering 
%%
clear all; clf
N=200;n=0:N-1;
x=cos(pi*n/16); % input signal
noise=0.2*randn(1,N); % noise
y=x+noise; % noisy signal
z=averager(3,y); % output of averaging filter of order 3
z1=averager(15,y); % output of averaging filter of order 15

figure(1)
subplot(211)
plot(n,y); hold on
plot(n,z,'r')
axis([0 N-1 1.2*min(x) 1.2*max(x)])
grid;ylabel('y[n],z[n]'); hold off; legend('y[n]','z[n]')
title('Averaging ---  M=3')
subplot(212)
plot(n,y); hold on
plot(n,z1,'r')
axis([0 N-1 1.2*min(x) 1.2*max(x)])
grid; ylabel('y[n],z_1[n]'); xlabel('n')
hold off; legend('y[n]','z_1[n]')
title('Averaging --- M=15')
