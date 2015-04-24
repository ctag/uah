%%
% Example 11.22 --- Linear and circular convolution%
%%
clear all; clf
N=20; x=ones(1,N);
% linear convolution
z=conv(x,x);z=[z zeros(1,10)];
% circular convolution
y=circonv(x,x,N);
y1=circonv(x,x,N+10);
y2=circonv(x,x,2*N+9);
Mz=length(z); My=length(y); My1=length(y1);My2=length(y2);
y=[y zeros(1,Mz-My)]; y1=[y1 zeros(1,Mz-My1)]; y2=[y2 zeros(1,Mz-My2)];
N=length(z); n=0:N-1;
figure(1)
subplot(221)
stem(n,z); grid; axis([0 N-1 0 25]);xlabel('n'); ylabel('z(n)'); title('Linear convolution')
subplot(222)
stem(n,y); grid; axis([0 N-1 0 25]);xlabel('n'); ylabel('y(n)'); title('Circular convolution (L=20)')
subplot(223)
stem(n,y1); grid; axis([0 N-1 0 25]);xlabel('n'); ylabel('y_1(n)'); title('Circular convolution (L=30)')

subplot(224)
stem(n,y2); grid; axis([0 N-1 0 25]);xlabel('n'); ylabel('y_2(n)'); title('Circular convolution (L=49)')
