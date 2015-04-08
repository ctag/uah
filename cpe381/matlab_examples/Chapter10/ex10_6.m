% downsampling, decimation, upsampling and interpolation
clear all; clf
ind=input(' band-limited (1) or non-bandlimited signal? ')
if ind==1,
Nx=200;n=0:Nx-1; x=cos(pi*n/4);
else
x=[ones(1,10) zeros(1,100)];Nx=length(x);n=0:Nx-1;
end
n1=0:19;
y=x(1:2:Nx-1);
X=fft(x,256);Y=fft(y,256);
L=length(X);w=0:2*pi/L:2*pi-2*pi/L;w1=(w-pi)/pi;

figure(1)
subplot(321)
stem(n1,x(1:20));grid;axis([0 19 1.2*min(x(1:20)) 1.2*max(x(1:20))])
ylabel('x[n]')
subplot(322)
plot(w1,fftshift(abs(X)));grid;axis([min(w1) max(w1) 0 1.1*max(abs(X))])
ylabel('|X(e^{j\omega})|')
subplot(323)
stem(n1,y(1:20));grid;axis([0 19 1.2*min(x(1:20)) 1.2*max(x(1:20))])
ylabel('y[n]')
subplot(324)
plot(w1,fftshift(abs(Y)));axis([min(w1) max(w1) 0 1.1*max(abs(X))]);grid
ylabel('|Y(e^{j\omega})|')
z=decimate(x,2,'fir');
Z=fft(z,256);
 subplot(325)
 stem(n1,z(1:20));grid;axis([0 19 1.2*min(x(1:20)) 1.2*max(x(1:20))])
ylabel('z[n]'),xlabel('n'); title(' using decimate')
 subplot(326)
plot(w1,fftshift(abs(Z)));grid;axis([min(w1) max(w1) 0 1.1*max(abs(X))])
ylabel('|Z(e^{j\omega})|');xlabel('\omega/\pi')

s=interp(y,2);n2=0:39;
figure(2)
subplot(211)
stem(n2,s(1:40));grid;axis([0 39 1.6*min(s) 1.6*max(s)])
ylabel('s[n]'); title(' interpolation using interp')
hold on
plot(n2,x(1:40),'r')
hold off; legend('interpolated', 'exact')
subplot(212)
eps=s-x;
stem(n2,eps(1:40));grid;axis([0 39 1.6*min(eps) 1.6*max(eps)])
ylabel('\epsilon[n]');xlabel('n'); title('interpolation error')
