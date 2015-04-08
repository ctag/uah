%
% Example 6.9
%
% Filtering using Butterworth and Chebyshev filters with same
% half-power frequency
%
clear all;clf 
syms t w
x=cos(10*t)-2*cos(5*t)+4*sin(20*t);
X=fourier(x)
% butter
wp=5;ws=10;alphamax=0.1;alphamin=15
[N,whp]=buttord(wp,ws,alphamax,alphamin,'s')
[b,a]=butter(N,whp,'s')


% cheby 1
epsi=sqrt(10^(alphamax/10) -1)
wp=whp/cosh(acosh(1/epsi)/N)
[N1,wn]=cheb1ord(wp,ws,alphamax,alphamin,'s')
[b1,a1]=cheby1(N1,alphamax,wn,'s')
W=0:0.01:30;
Hm=abs(freqs(b,a,W));
Hm1=abs(freqs(b1,a1,W));
figure(1)
subplot(221)
splane(b,a); title(' Butterworth')
subplot(223)
splane(b1,a1); title(' Chebyshev')
subplot(122)
plot(W,Hm);grid
hold on
plot(W,Hm1,'r'); legend('Butterworth LPF','Chebyshev LPF')
hold off

n=N:-1:0;
n1=N1:-1:0;
U=(j*w).^n
U1=(j*w).^n1
num=b*conj(U')
den=a*conj(U')
num1=b1*conj(U1')
den1=a1*conj(U1')
H=num/den
H1=num1/den1

Y=X*H
Y1=X*H1
y=ifourier(Y,t)
y1=ifourier(Y1,t)
figure(2)
subplot(211)
ezplot(x,[0,20]); axis([0 20 -12 12]); ylabel('x(t)'); grid
subplot(223)
ezplot(y,[0,20]); axis([0 20 -3 3]); title('Output from Butterworth'); ylabel('y(t)'); xlabel('t');grid
subplot(224)
ezplot(y1,[0,20]); axis([0 20 -3 3]);  title('Output from Chebyshev'); ylabel('y_1(t)'); xlabel('t');grid

