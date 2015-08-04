% Lab 05 - Problem 2
% EE384
% Christopher Bero

% P2.a
sfs=500;
fs=10;
t=0:(1/sfs):1;
sig=sin(2*pi*t*fs);
fig1=figure();
subplot(2,2,1);
plot(t,sig);
title('P2.a Message Signal');
xlabel('Time');
ylabel('Signal Value');


% P2.b
% No ammod available on R2012
% Procedure gathered from http://www.mathworks.com/matlabcentral/fileexchange/34590-amplitude-modulation-matlab-code
cfs=100;
carrier=sin(2*pi*t*cfs);
carrier_mod=sig.*carrier;
figure(fig1);
subplot(2,2,2);
plot(t,carrier);
title('P2.b Carrier');
xlabel('Time');
ylabel('Carrier Value');
subplot(2,2,4);
plot(t,carrier_mod);
title('P2.b Modulated Carrier');
xlabel('Time');
ylabel('Carrier Value');

% P2.c
% Plot the frequency spectrum of message and modulated signals
% What are the differences between the two plots?
[sig_bins, sig_resp]=freqSpec_2s(sig, sfs);
[carrier_bins, carrier_resp]=freqSpec_2s(carrier, sfs);

fig2=figure();
subplot(2,1,1);
plot(sig_bins,abs(sig_resp));
title('P2.c Message Response');
xlabel('Frequency');
ylabel('Message Response Magnitude');

subplot(2,1,2);
plot(carrier_bins,abs(carrier_resp));
title('P2.c Carrier Response');
xlabel('Frequency');
ylabel('Carrier Response Magnitude');

% The message plot shows our signal at low frequencies,
% while the carrier shows the same signal shifted and mirrored at
% a higher frequency

% P2.d
% No amdemod available
% Demodulate the modified signal and plot
% Compare result to plot of message signal
figure(fig1);
dem=2*carrier_mod.*carrier;
a=fir1(25,100*1.e-4);
b=1;
rec=filter(a,b,dem);
subplot(2,2,3);
plot(t,rec);
title('P2.d Recovered Signal');
xlabel('Time');
ylabel('Recovered Signal Value');





