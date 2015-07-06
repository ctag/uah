% Lab 06 - Problem 1
% EE384
% Christopher Bero

% References:
% ftp://ftp.eri.ucsb.edu/pub/org/lakemix/matlibrary~/users/emery/general/other_peoples/signal/sigdemos/html/dfiltdemo.html
% http://www.gaussianwaves.com/2014/07/how-to-plot-fft-using-matlab-fft-of-basic-signals-sine-and-cosine-waves/

% Setup
sfs=8000;
t=0:(1/sfs):0.050; % 50ms
f1=1209;
f2=1336;
y1=cos(2*pi*t*f1)+cos(2*pi*t*f2);

% P1.a
% Plot the signal (y1) in both time and freq domains
fig1=figure();
subplot(2,1,1);
plot(t,y1);
title('1.a Signal in Time Domain');
xlabel('Time (s)');
ylabel('Signal Value');

[y1f_vals,y1f_sig]=freqSpec_1s(y1,sfs);

subplot(2,1,2);
plot(y1f_vals,abs(y1f_sig)); % abs() will return magnitude of complex num
title('1.a Signal in Frequency Domain');
xlabel('Frequency (Hz)');
ylabel('Magnitude');

% P1.b
fig2=figure();
highpass=p1_lowpass;
y2=filter(highpass,y1);
subplot(2,1,1);
plot(t,y2);
title('1.b Lowpass Filtered Signal');
xlabel('Time (s)');
ylabel('Signal Value');

[y2f_vals,y2f_sig]=freqSpec_1s(y2,sfs);

subplot(2,1,2);
plot(y2f_vals,abs(y2f_sig));
title('1.b Lowpass Filtered Signal in Frequency Domain');
xlabel('Frequency (Hz)');
ylabel('Magnitude');


% P1.c
fig3=figure();
highpass=p1_highpass;
y3=filter(highpass,y1);
subplot(2,1,1);
plot(t,y3);
title('1.c Highpass Filtered Signal');
xlabel('Time (s)');
ylabel('Signal Value');

[y3f_vals,y3f_sig]=freqSpec_1s(y3,sfs);

subplot(2,1,2);
plot(y3f_vals,abs(y3f_sig));
title('1.c Highpass Filtered Signal in Frequency Domain');
xlabel('Frequency (Hz)');
ylabel('Magnitude');


% P1.d
fig4=figure();
bandpass=p1_bandpass;
y4=filter(highpass,y1);
subplot(2,1,1);
plot(t,y4);
title('1.d Bandpass Filtered Signal');
xlabel('Time (s)');
ylabel('Signal Value');

[y4f_vals,y4f_sig]=freqSpec_1s(y4,sfs);

subplot(2,1,2);
plot(y4f_vals,abs(y4f_sig));
title('1.d Bandpass Filtered Signal in Frequency Domain');
xlabel('Frequency (Hz)');
ylabel('Magnitude');





