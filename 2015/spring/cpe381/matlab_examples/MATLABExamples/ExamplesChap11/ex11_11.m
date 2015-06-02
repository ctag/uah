%% 
% Example 11.11
%
% Unwrapping of phase
%%
clear all;clf
h1=(1/10)*ones(1,10); % FIR filter 1
h2=[ zeros(1,3) 0.5 1.1 0.5 zeros(1,3)]; % FIR filter 1
H1=fft(h1,256);
H2=fft(h2,256);
H1m=abs(H1(1:128));H1p=angle(H1(1:128));H1up=unwrap(H1p);
H2m=abs(H2(1:128));H2p=angle(H2(1:128));H2up=unwrap(H2p);
L=length(H1);w=0:2*pi/L:pi-2*pi/L;w1=w/pi;

figure(1)
subplot(211)
plot(w1,H1m);grid;axis([min(w1) max(w1) -0.1 1.1*max(H1m)]) 
ylabel('|H_1(e^{j\omega})|');
subplot(212)
plot(w1,H2m);grid;axis([min(w1) max(w1) -0.1 1.1*max(H2m)])
ylabel('|H_2(e^{j\omega})|');xlabel('\omega/\pi')

figure(2)
subplot(221)
plot(w1,H1p);grid;axis([min(w1) max(w1) 1.1*min(H1p)  1.1*max(H1p)]);ylabel('<H_1(e^{j\omega}) (rad)')
subplot(222)
plot(w1,H1up);grid;axis([min(w1) max(w1) 1.1*min(H1up)  1.1*max(H1up)]);ylabel('<H_{1u}(e^{j\omega}) (rad)')
subplot(223)
plot(w1,H2p);grid;axis([min(w1) max(w1) 1.1*min(H2p)  1.1*max(H2p)]);
ylabel('<H_2(e^{j\omega}) (rad)'); xlabel('\omega/\pi')
subplot(224)
plot(w1,H2up);grid;axis([min(w1) max(w1) 1.1*min(H2up)  1.1*max(H2up)]);
ylabel('<H_{2u}(e^{j\omega}) (rad)'); xlabel('\omega/\pi')
