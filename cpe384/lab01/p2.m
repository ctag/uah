% p2a
t=0:1:50;
y1=cos(t);
y2=sin(t);
figure
plot(t,y1,t,y2);
title('Step Size: 1');
xlabel('Samples (t)');
ylabel('Amplitude of y1/y2');

%p2b
t=0:0.1:50;
y1=cos(t);
y2=sin(t);
figure
plot(t,y1,t,y2);
title('Step Size: 0.1');
xlabel('Samples (t)');
ylabel('Amplitude of y1/y2');