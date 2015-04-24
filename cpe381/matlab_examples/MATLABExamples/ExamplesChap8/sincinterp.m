function [t,xx,xr]= sincinterp(x,Ts)
%
% Sinc interpolation
% x sampled signal
% Ts sampling period of x
% xx,xr original samples and reconstructed in range t

% interpolation of first three samples
dT=1/100; t=0:dT:3;
m=zeros(1,4);M=m;
x1=x(1)*sinc(t); m(1)=min(x1);M(1)=max(x1);
x2=x(2)*sinc(t-1);m(2)=min(x2);M(2)=max(x2);
x3=x(3)*sinc(t-2);m(3)=min(x3);M(3)=max(x3);
xr1=x1+x2+x3;m(4)=min(xr1);M(4)=max(xr1);
xx1=[x(1) zeros(1,99) x(2) zeros(1,99) x(3) zeros(1,100)]; NN1=length(xx1);
t1=0:NN1-1;t1=t1*Ts/100;
mi=min(m);Ma=max(M);
subplot(211)
plot(t1,x1,'m');grid; hold on
plot(t1,x2,'r'); hold on
plot(t1,x3,'g');hold on
stem(t1,xx1,'filled'); hold on
plot(t1,xr1,'k');axis([0 max(t1) 1.5*mi 1.5*Ma]);hold off

% interpolation of sampled signal
N=length(x);
t=0:dT:N;
xr=zeros(1,N*100+1);
for k=1:N,
  xr=xr+x(k)*sinc(t-(k-1));    
end
xx(1:100:N*100)=x(1:N);
xx=[xx zeros(1,99)];
NN=length(xx);
t=0:NN-1;t=t*Ts/100;
     