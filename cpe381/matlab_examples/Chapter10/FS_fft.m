%
% Fourier series using FFT
%
clear all; clf
N=10; M=10; N1=M*N;n=0:N1-1; L=N1; w=0:2*pi/L:2*pi-2*pi/L;w1=(w-pi)/pi; P=5*N
x=cos(2*pi*n/N);
figure(1)
ind=input('sinusoid (1) or sign(sinusoid) (2) or sinusoid-sign (3)?  ')
if ind==1,
X=fft(x)/N1;
subplot(121)
stem(n(1:P),x(1:P));grid;axis([0 P-1 1.5*min(x(1:P)) 1.5*max(x(1:P))]);ylabel('x_1[n]'); xlabel('n')
subplot(122)
stem(w1,fftshift(abs(X)));grid;axis([min(w1) max(w1) 0 1.1*max(abs(X))]);ylabel('|X_1(e^{j\omega})|'); xlabel('\omega/\pi')
elseif ind==2
x1=sign(x);X1=fft(x1)/N1;
subplot(121)
stem(n(1:5*N),x1(1:5*N));grid;axis([0 P-1 1.5*min(x1(1:P)) 1.5*max(x1(1:P))]);ylabel('x_2[n]'); xlabel('n')
subplot(122)
stem(w1,fftshift(abs(X1)));grid;;axis([min(w1) max(w1) 0 1.1*max(abs(X1))]);ylabel('|X_2(e^{j\omega})|');xlabel('\omega/\pi')
else
x2=x-sign(x); X2=fft(x2)/N1;
subplot(121)
stem(n(1:5*N),x2(1:5*N));grid;axis([0 P-1 1.5*min(x2(1:P)) 1.5*max(x2(1:P))]);ylabel('x_3[n]'); xlabel('n')
subplot(122)
stem(w1,fftshift(abs(X2)));;grid;axis([min(w1) max(w1) 0 1.1*max(abs(X2))]);ylabel('|X_3(e^{j\omega})|');xlabel('\omega/\pi')
end

