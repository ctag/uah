% Lab 03 - Problem 2
% EE384
% Christopher Bero

% 2.a
fs=50;
t1=0:(1/fs):1;
f1=10;
y1=sin(2*pi*f1*t1);
subplot(1,2,1);
plot(t1, y1);
hold all;
title('10Hz Signal');
xlabel('Time');
ylabel('Amplitude');

% 2.b
fs=50
t2=0:(1/fs):1;
f2=60;
y2=sin(2*pi*f2*t2);
subplot(1,2,2);
plot(t2, y2);
title('60Hz Signal');
xlabel('Time');
ylabel('Amplitude');