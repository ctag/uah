% HW1 problem 9
% Christopher Bero

x_axis = -5:0.01:5;

x_1t = (4*cos(pi*x_axis));

x_2t = (-sin((3*pi*x_axis)+(pi/2)));



plot(x_axis, x_1t); % a) T1t=2s
hold all
plot(x_axis, x_2t); % a) T2t=0.66s
hold all
plot(x_axis, (x_1t + x_2t)); % b) yes, Txt=2s

%p9_c: T=12

%p9_d:
x_1t = (4*cos(2*pi*x_axis));
x_2t = (-sin((3*pi*x_axis)+(pi/2)));
hold all
plot(x_axis, (x_1t + x_2t)); % yes

x_1t = (4*cos(2*x_axis));
x_2t = (-sin((3*pi*x_axis)+(pi/2)));
hold all
plot(x_axis, (x_1t + x_2t)); % yes











