% Lab 05 - Problem 1
% EE384
% Christopher Bero

% P1.a
% Read and listen to test.wav
% What do you hear?
% What is the sampling frequency?
[sig,fs]=wavread('/home/berocs/Documents/uah/ee384/lab05/test.wav');
%sound(sig,fs);
% Audio: "One, two, three."
% Sampling Frequency: 8000Hz

% P1.b
% Plot the sound data vs time
seconds=(length(sig)/fs);
t=0:(1/fs):seconds-(1/fs);
plot(t,sig);
title('test.wav');
xlabel('Time (t)');
ylabel('WAV Value (sig)');