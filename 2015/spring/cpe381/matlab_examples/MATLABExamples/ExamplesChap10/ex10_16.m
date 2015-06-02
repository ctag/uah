%%
% Example 10.16
%% 
N=100;n=0:N-1;
x=[ones(1,10) zeros(1,N-10)];
den=[1 -0.8]; num=[1 0];
y=filter(num, den,x)
n1=[-3 -2 -1 n(1:30)];
x1=[0 0 0 x(1:30)];
y1=[0 0 0 y(1:30)];
figure(1)
subplot(211)
stem(n1,x1); grid; xlabel('n'); ylabel('x[n]'); axis([-3 30 0 3])
subplot(212)
stem(n1,y1); grid; xlabel('n'); ylabel('y[n]'); axis([-3 30 0 6])
