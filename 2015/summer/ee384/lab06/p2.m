% Lab 06 - Problem 2
% EE384
% Christopher Bero

% P2.a
% Load and plot DCG_Data
load('/home/berocs/Documents/uah/ee384/SAMPLE_ECG.mat');
sfs=512;
t=0:1/512:(2000*(1/512))-(1/512);
fig_a=figure();
subplot(2,1,1);
plot(t,ECG_Data);
title('2.a ECG Signal in Time Domain');
xlabel('Time (s)');
ylabel('ECG Value');
% Heart rate appears to be ~80 BPM

% P2.b
% Plot Frequency (two sided) of the ECG signal
[ecgf_vals,ecgf_sig]=freqSpec_2s(ECG_Data,sfs);
figure(fig_a);
subplot(2,1,2);
plot(ecgf_vals,abs(ecgf_sig));
%axis([0 100 -50000 300000]);
title('2.b ECG Signal in Frequency Domain');
xlabel('Frequency (Hz)');
ylabel('Spectrum Magnitude');

% P2.c
% Apply high pass filter to the ECG signal
highpass=p2_highpass; % Filter everything below 1Hz
yc=filter(highpass,ECG_Data);
fig_b=figure();
subplot(2,1,1);
plot(t,yc);
title('2.c Filtered ECG Signal in Time Domain');
xlabel('Time (s)');
ylabel('ECG Value');
[ecgf_vals,ecgf_sig]=freqSpec_2s(yc,sfs);
figure(fig_b);
subplot(2,1,2);
plot(ecgf_vals,abs(ecgf_sig));
title('2.c Filtered ECG Signal in Frequency Domain');
xlabel('Frequency (Hz)');
ylabel('Spectrum Magnitude');






