%%
% Example 9.23
%
%%
clear all;clf
a=[1 -0.5];b=1;
d=[1 zeros(1,99)];
h=filter(b,a,d);
x=[ones(1,3) zeros(1,10)];
y=filter(b,a,x);
y1=conv(h,x);y1=y1(1:length(y));
n=0:19;
figure(1)
subplot(211)
stem(n,h(1:20)); grid; axis([0 19 -0.1 1.1]); ylabel('h[n]'); xlabel('n')
subplot(212)
stem(n(1:13),y(1:13)); grid; axis([0 12 -0.1 2.1]); ylabel('y[n]'); xlabel('n')
hold on
stem(n(1:13),y1(1:13),'rx')
hold off
legend('y[n]','y_1[n]')