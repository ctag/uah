% Plot_Signals.m
% use plot_fft function to display available audio
% in frequency domain. Marks dominant spectral component.
% Assembled by Christopher Bero [csb0019@uah.edu]

clear all;
%echo plot_fft on;

[signal_sine, fs_sine]=wavread('/home/berocs/Documents/MATLAB/bero_christopher-csb_sine.wav');
[signal_orig,fs_orig]=wavread('/home/berocs/Documents/MATLAB/bero_christopher-csb_orig.wav');
[signal_mod,fs_mod]=wavread('/home/berocs/Documents/MATLAB/bero_christopher-csb_mod.wav');

fig=figure(1);
plot_fft(signal_sine, fs_sine, fig);

fig=figure(2);
plot_fft(signal_orig, fs_orig, fig);

fig=figure(3);
plot_fft(signal_mod, fs_mod, fig);
