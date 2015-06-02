%
%  DTFT of aperiodic signals
%  (pulse, windowed sinusoid, chirp)
%
clear all; clf
L=256; % length of signal (including zeros)

% signals
ind=input(' Pulse (1) or windowed sinusoid (2) or chirp (3)  ?  ')
if ind==1,
N=21;x=[ones(1,N) zeros(1,L-N)];                         % pulse
elseif ind==2,
N=200; n=0:N-1;x=[cos(4*pi*n/N) zeros(1,L-N)];   % windowed sinusoid
else
n=0:L-1;x=cos(pi*n.^2/(4*L));                                  % chirp
end

% DTFT
X=fft(x);
w=0:2*pi/L:2*pi-2*pi/L;w1=(w-pi)/pi; % frequencies
n=0:length(x)-1;

figure(1)
subplot(311)
stem(n,x); axis([0 length(n)-1 1.1*min(x) 1.1*max(x)]); grid
xlabel('n'); ylabel('x[n]')
subplot(312)
plot(w1,fftshift(abs(X)));axis([min(w1) max(w1) 0 1.1*max(abs(X))])
ylabel('|X(e^{j\omega})|'); grid
subplot(313)
plot(w1,fftshift(angle(X)))
axis([min(w1) max(w1) 1.1*min(angle(X)) 1.1*max(angle(X))])
ylabel('<X(e^{j\omega})'); xlabel('\omega/\pi'); grid
