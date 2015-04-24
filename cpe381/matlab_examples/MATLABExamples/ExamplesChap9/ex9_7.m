%%
% Example 9.7
%
% Power computation 
%%
clear all;clf
n=0:100000;
x2=2*cos(0.1*n*3.2-pi/4); % non-periodic for positive n
x1=2*cos(0.1*n*pi-pi/4); % periodic for positive n
x22=[zeros(1,10) x2(1:40)];
x11=[zeros(1,10) x1(1:40)];
N=length(x1)
Px1=sum(x1.^2)/(2*N+1) % power of x1
Px2=sum(x2.^2)/(2*N+1) % power of x2
P1=sum(x1(1:20).^2)/(20); %power in period of x1

n1=-10:39;
figure(1)
subplot(221)
stem(n1,x22); grid; xlabel('n'); ylabel('x_2[n]'); axis([-10 39 -2.1 2.1])
subplot(222)
stem(n1,x11); grid; xlabel('n'); ylabel('x_1[n]'); axis([-10 39 -2.1 2.1])
subplot(212)
stem(n1,x22.^2)
hold on
stem(n1,x11.^2,'r'); grid; xlabel('n'); ylabel('x_1^2[n], x_2^2[n]')
axis([-10 39 -0.1 4.1]); legend('x_2^2[n]','x_1^2[n]')
hold off

Px1=x1(1)^2;N=length(x1);
Px2=x2(1)^2;
for k=2:N,
 Px1=Px1+x1(k)^2;
 Px2=Px2+x2(k)^2;
end
Px1=Px1/(2*N+1)
Px2=Px2/(2*N+1)

