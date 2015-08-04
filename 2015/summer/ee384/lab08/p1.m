% Lab 08 - Problem 1
% EE384
% Christopher Bero

% P1.a
% Well, AM as we commonly use it operates by taking a low frequency
% signal, such as voice or music, and migrating it to the FM radio
% band, which consumes the 80~110 MHz range. I think that this 
% is very similar to superimposed signals like the DTMF.
% To recover the voice signal, our low pass filter will keep voice
% ranged frequencies and attenuate the radio frequencies.


% P1.b
sfs=500; % Sampling frequency
fs=10; % Message frequency
t=0:(1/sfs):1; % Domain
message=sin(2*pi*t*fs); % Message signal
cfs=100; % Carrier frequency
carrier=sin(2*pi*t*cfs); % Carrier signal 
carrier_mod=ee384_ammod(message, carrier); % Generate the modulated signal

[m_bins, message_resp]=freqSpec_1s(message, sfs);
[c_bins, mod_resp]=freqSpec_1s(carrier_mod, sfs);

fig2=figure();
subplot(2,2,1);
plot(m_bins,abs(message_resp));
title('P1.b Message Response');
xlabel('Frequency');
ylabel('Response Magnitude');

subplot(2,2,2);
plot(c_bins,abs(mod_resp));
title('P1.b Modulated Carrier Response');
xlabel('Frequency');
ylabel('Response Magnitude');

% P1.c
recovered=ee384_amdemod(carrier_mod, carrier, sfs, 30, 80);
[r_bins, rec_resp]=freqSpec_1s(recovered, sfs);

subplot(2,2,3);
plot(t,recovered);
title('P1.c Recovered Signal');
xlabel('Time');
ylabel('Signal');

subplot(2,2,4);
plot(r_bins,abs(rec_resp));
title('P1.c Recovered Signal Response');
xlabel('Frequency');
ylabel('Response Magnitude');
% We can see from this frequency response that the original signal
% has been returned with very little distortion








