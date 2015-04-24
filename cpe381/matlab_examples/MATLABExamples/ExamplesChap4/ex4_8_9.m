%%
% Examples 4.8 and 9
%%
clear all
syms t
T0=2;
m=heaviside(t)-heaviside(t-T0/2);
m1=heaviside(t-T0/2)-heaviside(t-T0);
ind=input('example 8 or 9?>>  ')
if ind==8
y=(1-t)*m+(t-1)*m1;
x=-m+m1;
else
x=t*m+(t-2)*m1;y=int(x);
end
[Y,w]= fourierseries(y,T0,20);
[X,w]=fourierseries(x,T0,20);
figure(1)
subplot(221)
ezplot(y,[0 T0]);grid;xlabel('t');ylabel('y(t)')
subplot(223)
stem(w,abs(Y));grid;xlabel('\Omega');ylabel('|Y_k|')
subplot(224)
stem(w,angle(Y));grid;xlabel('\Omega');ylabel('\angle{Y_k}')
figure(2)
subplot(221)
ezplot(x,[0 T0]);grid;xlabel('t');ylabel('x(t)')
subplot(223)
stem(w,abs(X)); grid;xlabel('\Omega');ylabel('|X_k|')
subplot(224)
stem(w,angle(X));grid;xlabel('\Omega');ylabel('\angle{X_k}')