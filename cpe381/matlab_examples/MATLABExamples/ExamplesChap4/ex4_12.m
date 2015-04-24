%%
% Example 4.12 --- Modulation             
%% 
syms t
T0=2;
m=heaviside(t)-heaviside(t-T0/2); % period of x1
m1=heaviside(t)-heaviside(t-T0);
x1=m*cos(20*pi*t);
x2=m1*sin(pi*t)*cos(20*pi*t);
[X1,w]=fourierseries(x1,T0,40);
[X2,w1]=fourierseries(x2,T0,40);
figure(1)
subplot(221)
ezplot(x1,[0 T0]);grid;xlabel('t');ylabel('x_1(t)');title('x_1(t)')
subplot(223)
stem(w,abs(X1));grid;xlabel('\Omega');ylabel('|X_{1k}|')
axis([0 max(w) 0 1.1*max(abs(X1))])
subplot(222)
ezplot(x2,[0 T0]);grid;xlabel('t');ylabel('x_2(t)');title('x_2(t)')
subplot(224)
stem(w1,abs(X2)); grid;xlabel('\Omega');ylabel('|X_{2k}|')
axis([0 max(w) 0 1.1*max(abs(X2))])