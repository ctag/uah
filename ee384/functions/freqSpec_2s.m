function [ f_vals, f_sig ] = freqSpec_2s( signal, sfs )
% freqSpec_2s: Generate two sided frequency spectrum for plotting
% Usage:    [x,y]=freqSpec_1s(time_signal,sample_freq);
%           plot(x,y);

t_len=length(signal); % number of samples
nfft=2^ceil(log2(t_len)); % number of FFT bins
f_vals=sfs*(-nfft/2:nfft/2-1)/nfft; % Frequency range (w/ neg)
f_sig=fftshift(fft(signal,nfft)); % Two sided, zero centered FFT

end