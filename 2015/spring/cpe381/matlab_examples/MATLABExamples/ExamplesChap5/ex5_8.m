%%
% Example 5.8
%%
clear all;clf
syms t w x x1
T0=1;N=10;w0=2*pi/T0;
m=heaviside(t)-heaviside(t-T0/2);
m1=heaviside(t-T0/2)-heaviside(t-T0);
x=t*m+m1*(-t+T0);x=2*x;
[Xk, w]=fourierseries(x,T0,N); 
 for k=1:N,
     if k==1;
     x1=abs(Xk(k));
     else
     x1=x1+2*abs(Xk(k))*cos(w0*(k-1)*t+angle(Xk(k)));
     end
 end
figure(1)
subplot(211)
ezplot(x1,[0,5*T0]); grid; axis([0 5*T0 -0.2 1.2]); title(' '); xlabel('t'); ylabel('x(t)')
k=0:N-1;Xk1=2*pi*Xk;wk=[-fliplr(k(2:N-1)) k]*w0;Xk=[fliplr(Xk1(2:N-1)) Xk1];

subplot(212)
stem(wk,Xk,'filled');grid;axis([min(wk) -min(wk)  1.5*min(Xk) 1.5*max(Xk)]);
 xlabel('\Omega'); ylabel('X(\Omega)')