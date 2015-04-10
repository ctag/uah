%
% Example 10.10
%
% Phase of sinusoid in noise
%
clear all; clf
n=0:99;
x=sin(pi*n/2)+0.1*randn(1,100);     % sine plus noise
X=fftshift(fft(x)); % fft of signal
X1=abs(X); theta=angle(X); 
theta1=theta.*X1/max(X1);    % masked phase
L=length(X);w=0:2*pi/L:2*pi-2*pi/L;w1=(w-pi)/pi;

figure(1)
subplot(311)
plot(w1,X1);grid;axis([min(w1) max(w1) -5 1.1*max(X1)]);ylabel('|X|')
subplot(312)
plot(w1,theta); grid;axis([min(w1) max(w1) 1.1*min(theta) 1.1*max(theta)]);
ylabel('\theta (rad)');
subplot(313)
plot(w1,theta1);grid;axis([min(w1) max(w1) 1.1*min(theta1) 1.1*max(theta1)]);
ylabel('\theta_1 (rad)'); xlabel( '\omega/\pi')


