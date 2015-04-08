%
% Example 12.4
%
% comparison of conv and fft
%
clear all; clf
time1=zeros(1,10);time2=time1;
for i=1:10,
  NN=1000*i;
  x=ones(1,NN);
% elapsed time for convolution using conv
  t=tic;
  y=conv(x,x);
  time1(i)=toc(t);
% elapsed time for convolution using fft
  t=tic;
  X=fft(x);
  X=fft(x);
  Y=X.*X;
  y=ifft(Y);
  time2(i)=toc(t);
end
n=1:10;n=2000*n;
figure(3)
stem(n,time1/10,'ro');hold on
stem(n,time2,'kx')
%axis([min(n) max(n) 0 1.1*max(time1/20)])
grid
legend('conv/10','fft')
xlabel('Length of convolution sum')
ylabel('CPU time (sec)')


