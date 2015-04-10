%
% FM signal generation
% Discrete simulation of narrow and wide-band FM 
%
clear all; clf;
Ts=0.001;Fs=1/Ts;	% sampling period and frequency
t=[0:Ts:0.2];
ind=input('narrow-band (1) or wide-band (2) FM?     ')
if ind==1,
    K=0.1*pi % narrow-band FM  
    fc=100
    N=length(t);
    m=80*sin(20*pi*t); 	% sine message in NBFM
else
    Ts=0.0001;Fs=1/Ts;	% sampling period and frequency
    t=[0:Ts:0.1];
    K=50*pi;		% wbfm
    m=80*sin(20*pi*t); 	% sine message in NBFM
    fc=2500
    % fc=25; 		%  ramp
    % m=2000*t;   	% ramp message in WBFM
 end

% integration
int(1)=0;
for n=1:length(t)-1,
   int(n+1)= int(n)+m(n)*Ts;
end
x=cos(2*pi*fc*t+K*int);
%  spectra
M=fft(m)*Ts;
X=fft(x)*Ts;
N=length(X);
w=((2*pi/N)*[0:N-1]-pi)*Fs/(2*pi);
figure(1)
subplot(211)
plot(t,m); grid; axis([0 max(t) min(m) max(m)]);ylabel('m(t)')
subplot(212)
plot(t,x); grid; axis([0 max(t) min(x) max(x)])
ylabel('x(t)'); xlabel('t (sec)')

figure(2)
subplot(211)
plot(w,fftshift(abs(M))); grid; ylabel('|M(\Omega)|')
subplot(212)
plot(w,fftshift(abs(X))); grid; xlabel('\Omega');				ylabel('|X(\Omega)|')

figure(3)
%specgram(x,128,1E2,128,120)
%spectrogram(x,128,1E2,128,256)
%axis([ 0 max(f)*2600/128 0 0.9])

%% CHECK the following

F=0:1:280*2;
[y,f,t,p] = spectrogram(x,128,100,F,1E3,'yaxis'); 
      % NOTE: This is the same as calling SPECTROGRAM with no outputs.
      surf(t,f,10*log10(abs(p)),'EdgeColor','none');   
      axis xy; axis tight; colormap(jet); view(0,90);
      xlabel('Time');
      ylabel('Frequency (Hz)');
