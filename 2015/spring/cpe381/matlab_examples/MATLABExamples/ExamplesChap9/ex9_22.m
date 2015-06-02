%%
% Example 9.22
%
% Convolution sum
%%
x1=[0 0 ones(1,20)]         % unit-step input
n=-2:19; n1=0:19
x2=[0 0 cos(2*pi*n1/3)];    % sinusoidal input
h=(1/3)*ones(1,3);          % impulse response
y=conv(x1,h);y1=y(1:length(n));
y=conv(x2,h);y2=y(1:length(n));
figure(1)
subplot(221)
stem(n,x1);axis([-2 19 -0.1 1.1]); grid; xlabel('n'); ylabel('x_1[n]')
subplot(222)
stem(n(1:22),y1(1:22));axis([-2 19 -0.1 1.1]); grid; xlabel('n'); ylabel('y_1[n]')
subplot(223)
stem(n,x2);;axis([-2 19 -1.1 1.1]); grid; xlabel('n'); ylabel('x_2[n]')
subplot(224)
stem(n(1:22),y2(1:22));axis([-2 19 -0.1 0.4]); grid; xlabel('n'); ylabel('y_2[n]')
