function [] = plot_fft( signal, fs, fig )
% Helper function for CPE381 project phase 2
% Assembled by Christopher Bero [csb0019@uah.edu]

% get number of samples
signal_len=length(signal);
N_2 = ceil(signal_len/2);

% Nyquist frequency
fnyquist = fs/2;

% Magnitude of fft gives signal in f domain
signal_mag = abs(fft(signal));

% From http://www.lumerink.com/courses/ece697/docs/Papers/
% "The Fundamentals of FFT-Based Signal Analysis and Measurements.pdf"
%
% Multiply every element but the center point by 2 to get Magnitude for a
% one-sided plot. This is because half of the power is represented as
% negative values, and those are discarded for this plot, being as they are
% typically redundant in real-world signals.
signal_mag=[ signal_mag(1) ( signal_mag(2:length(signal_mag)) * 2.0 ) ];
signal_mag=signal_mag(1:N_2);

bin_vals = 0:signal_len-1;
fax_Hz = bin_vals*fs/signal_len;

% Begin plotting Magnitude in Freq Domain
figure(fig);
plot(fax_Hz(1:N_2), signal_mag);
hold on;
xlabel('Frequency (Hz)');
ylabel('Magnitude');
title('Single-sided Magnitude Spectrum');

% reimplemented from MATLAB help browser
% takes the largest peak and places a symbol over it
[peaks,locations] = findpeaks(signal_mag);
x=fax_Hz(1:N_2);
[C,I]=max(peaks);
max_loc=locations(I);
max_peak=peaks(I);
plot(x(max_loc),max_peak+0.05,'k^','markerfacecolor',[1 0 0]);

end







