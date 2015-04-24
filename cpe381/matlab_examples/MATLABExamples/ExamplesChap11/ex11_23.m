%%
% Example 11.23 --- Filtering using convolution and FFT
%%
clear all; clf
N=100; n=0:N-1;
load laughter
x=5*y(1:N)'; x1=x+0.3*(-1).^n; 	% desired signal plus disturbance
h=fir1(40,0.9);[H1,w]=freqz(h,1); 	% low-pass FIR filter design
% filtering using convolution
y=conv(x,h); 						% convolution 
 % computing using FFT
M=length(x)+length(h)-1; 			% length of convolutions equal
X=fft(x,M);
 H=fft(h,M);
Y=X.*H;
y1=ifft(Y); 						% output of filtering
figure(1)
subplot(211)
stem(n,x); hold on;plot(n,x1,'r'); grid; hold off
ylabel('x[n], x_1[n]')
legend('clean signal','noisy signal');xlabel('n')
subplot(223)
stem(n(1:41),h);grid;xlabel('n');ylabel('h[n]')
axis([1 41 -0.2 1])
subplot(224)
plot(w,abs(H1)); grid; xlabel('\omega');ylabel('|H(e^{j\omega})|')
axis([0 max(w) 0 1.1])
figure(2)
subplot(211)
stem([1:length(y)],y);grid;axis([0 140 -1 1])
xlabel('n');ylabel('y[n]')
subplot(212)
e=y-y1;
stem([1:length(y)],e);grid;axis([0 140 1.1*min(e) 1.1*max(e)])
xlabel('n');ylabel('e[n]')