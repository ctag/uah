% Lab 03, Problem 3

% 3.a
t1=0:(1/50000):1;
f1=2000;
y1=sin(2*pi*f1*t1);
subplot(3,1,1);
plot(t1,y1);
title('2kHz Signal');
xlabel('Time');
ylabel('Amplitude');
axis([0 0.01 -1 1]);
sound(y1,50000);

% 3.b
t2=0:(1/50000):1;
f2=6000;
y2=sin(2*pi*f2*t2);
subplot(3,1,2);
plot(t2,y2);
title('6kHz Signal');
xlabel('Time');
ylabel('Amplitude');
axis([0 0.01 -1 1]);
sound(y2,50000);

% b.c
t3=0:(1/50000):1;
f3=25000;
y3=sin(2*pi*f3*t3);
subplot(3,1,3);
plot(t3,y3);
title('25kHz Signal');
xlabel('Time');
ylabel('Amplitude');
axis([0 0.001 -1 1]);
sound(y3,50000);

