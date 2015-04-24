function [y,y1,X,fx,Y,fy]=sampling(x,L,fs)
%
% Sampling 
%   x  analog signal
%   L  length of simulated x   
%   fs sampling rate
%   y sampled signal
%   X,Y magnitude spectra of x,y
%   fx,fy frequency ranges for X,Y
%
fsim=20000; % analog signal sampling frequency
% sampling with rate fsim/fs
delta=floor(fsim/fs);
y1=zeros(1,L);
y1(1:delta:L)=x(1:delta:L);
y=x(1:delta:L);
% analog FT and DTFT of signals
dtx=1/fsim; 
X=fftshift(abs(fft(x)))*dtx;
N=length(X); k=0:(N-1); fx=1/N.*k; fx=fx*fsim/1000-fsim/2000;
dty=1/fs;
Y=fftshift(abs(fft(y)))*dty; 
N=length(Y); k=0:(N-1); fy=1/N.*k; fy=fy*fs/1000-fs/2000;
