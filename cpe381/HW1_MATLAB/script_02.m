% HW1 Problem 2
% Christopher Bero
% CPE 381

% Setup x axis and sampling rate
p2_x_a = 0:0.0001:3;
p2_x_t01 = 0:0.1:3;
p2_x_t05 = 0:0.5:3;
p2_x_t10 = 0:1.0:3;

% Setup y(x)
p2_y_a = (2*cos(p2_x_a*2*pi));
p2_y_t01 = (2*cos(p2_x_t01*2*pi));
p2_y_t05 = (2*cos(p2_x_t05*2*pi));
p2_y_t10 = (2*cos(p2_x_t10*2*pi));

% Plot all y(x)
figure('Name', 'This is indeed a figure', 'NumberTitle', 'off')
subplot(2,2,1);
plot(p2_x_a, p2_y_a);
hold all
%stem(p2_x_a, p2_y_a);
xlabel('x(t)');
ylabel('y()');
title('analog');

subplot(2,2,2);
plot(p2_x_a, p2_y_a);
hold all
stem(p2_x_t01, p2_y_t01);
xlabel('x(t)');
ylabel('y()');
title('T=0.1');

subplot(2,2,3);
plot(p2_x_a, p2_y_a);
hold all
stem(p2_x_t05, p2_y_t05);
xlabel('x(t)');
ylabel('y()');
title('T=0.5');

subplot(2,2,4);
plot(p2_x_a, p2_y_a);
hold all
stem(p2_x_t10, p2_y_t10);
xlabel('x(t)');
ylabel('y()');
title('T=1.0');

% Analog information lost after Ts=0.5 sec.




