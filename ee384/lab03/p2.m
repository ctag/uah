% Lab 03, Problem 2

% 2.a
t1=0:(1/50):1;
f1=10;
y1=sin(2*pi*f1*t1);
subplot(1,2,1);
plot(t1, y1);
hold all;
title('');
xlabel('');
ylabel('');

% 2.b
t2=0:(1/50):1;
f2=60;
y2=sin(2*pi*f2*t2);
subplot(1,2,2);
plot(t2, y2);
title('');
xlabel('');
ylabel('');