% Lab 06 - Problem 3
% EE384
% Christopher Bero

% Filter from ECG section of lab 02 had the form:
% y=(x(n)+x(n-1)+x(n-2))/3;
% Plot the frequency response of this filter,
% mark the cutoff frequency
% Estimate the cutoff frequency in Hz
% Sampling Frequency: 512Hz

% I'm not very confident with this solution, but since we're using
% an averaging filter, this should be the frequency response.
% http://www.mathworks.com/help/matlab/data_analysis/filtering-data.html
% http://www.mathworks.com/matlabcentral/newsreader/view_thread/128289
% https://en.wikipedia.org/wiki/Cutoff_frequency
% http://www.mathworks.com/matlabcentral/answers/24055-how-to-see-the-frequency-response-of-difference-equation

a=1;
b=[1/3 1/3 1/3];
[h,f]=freqz(b,a,2048,512);
Db=20*log10(abs(h));
plot(f,Db);
axis([0 250 -80 10]);
title('3 Filter Frequency Response');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
hold on;
cutoff=ones(length(f),1)*(-3);
plot(f,cutoff);
cutoff_freq=0;
for index=1:length(f)
    if Db(index) < cutoff(index)
        cutoff_freq=f(index);
        break;
    end
end
plot(cutoff_freq,cutoff,'--x','MarkerSize', 20, 'MarkerEdgeColor', 'r');

% This crashes MATLAB
%text_str=sprintf('[%d Hz, %d dB]', cutoff_freq, cutoff);
%text(cutoff_freq,cutoff(1), text_str, 'FontName', 'FixedWidth');

% Cutoff frequency: ~80Hz



