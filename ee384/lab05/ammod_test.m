t=0:.000001:.005;
Am1=.5;
fm1=400;
Am2=0.25;
fm2=800;
Ac=2.5;
fc=10000;

mt=Am1*cos(2*pi*fm1.*t)+Am2*cos(2*pi*fm2.*t);
ct=Ac*cos(2*pi*fc.*t);
st=(1+mt).*ct;

figure('Name','Time domain representations of FULL AM signals');
title('AM Modulation of Multitone sinusoidal Signal');
subplot(3,1,1)
plot(t,mt)
xlabel('Time'); ylabel('Message signal');

subplot(3,1,2)
plot(t,ct)
xlabel('Time'); ylabel('Carrier Signal');

subplot(3,1,3)
plot(t,st,t,Ac.*(1+mt),'r')
xlabel('Time'); ylabel('Modulated signal');

sprintf('Carrier frequency: %d Hz',fc)
sprintf('Message frequency: %d Hz and %d Hz',fm1,fm2)
sprintf('USB spectra at: %d Hz and %d Hz',fc+fm1,fc+fm2)
sprintf('LSB spectra at: %d Hz and %d Hz',fc-fm1,fc-fm2)