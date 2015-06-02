%
% Discrete-time simulation of AM
%
%
clear all; clf
load train
y1=y';
N=length(y1);
t1=0:1/Fs:(N-1)/Fs;

figure(1)
plot(t1,y1); grid; xlabel('t'); ylabel('y(t)'); title('message')
        
fmax=Fs/2;         % bandwith of train signal
fc=5*fmax;         % carrier frequency (rad/sec)
fs=2*(fc+fmax);    % sampling frequency of modulated signal
wc=2*pi*fc
L=ceil(fs/Fs);
y=interp(y1,L);
N1=1024*2
n=0:N1-1; 
t2=0:1/fs:(N1-1)/fs;
K=1*abs(min(y(1:N1)));
% Modulation
z=(y(1:N1)+K).*cos(wc*t2);

figure(2)
subplot(211)
plot(t2,y(1:N1));grid;ylabel('y(t)')
axis([0 max(t2) -1 1])
subplot(212)
plot(t2,z,':r');hold on
plot(t2,y(1:N1)+K,'k');hold on
plot(t2,-y(1:N1)-K,'k');grid;hold off
axis([0 max(t2) -2 2])  
xlabel('t');ylabel('z(t)')

figure(3)
w=0:N1-1;w=w*2*pi/N1;w=w-pi;W=w*fs;
subplot(211)
plot(W/(2*pi),abs(fftshift(fft(y(1:N1)))));grid;xlabel('f (Hz)'); ylabel('|Y(\Omega)|')
subplot(212)
plot(W/(2*pi),abs(fftshift(fft(z))));grid ;xlabel('f (Hz)'); ylabel('|Z(\Omega)|')

