% Lab 03, Problem 1

% 1.a
% Load and plot ECG data
% Replace this path with wherever the SAMPLE_ECG.mat is located
load('/home/berocs/Documents/uah/ee384/lab02/SAMPLE_ECG.mat');
n=1:2000;
subplot(2,2,1);
plot(n,ECG_Data);
title('1.a Raw ECG');
xlabel('Time');
ylabel('Amplitude'); % Likely voltage from ecg sensor?
hold all;
retA=filter([1/3 1/3 1/3],1,ECG_Data);
subplot(2,2,2);
plot(n,retA);
title('1.a Filtered ECG');
xlabel('Time');
ylabel('Amplitude');

% 1.b
h=[1/3 1/3 1/3];
retB=conv(ECG_Data,h);
subplot(2,2,3);
countb=(length(n)+length(h)-1);
nb=1:countb;
plot(nb,retB);
title('1.a Filtered ECG');
xlabel('Time');
ylabel('Amplitude');

% 1.c
h=[1/3 1/3 1/3];
retB=ee384_conv(ECG_Data,h);
subplot(2,2,4);
countb=(length(n)+length(h)-1);
nb=1:countb;
plot(nb,retB);
title('1.a conv.m filetered');
xlabel('Time');
ylabel('Amplitude');

