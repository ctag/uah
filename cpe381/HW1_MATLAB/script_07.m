% problem 7

x_axis=-10:0.1:10;

x_t = exp(-(abs(x_axis)));
abs_x_t = abs(x_t);


%plot(x_axis, x_t);
%hold all
%plot(abs_x_t);
%hold all
%plot(square(abs_x_t));

% p7_a
% The integral is infinite because the function is based upon e^(x). 

% p7_c
y_t = exp(-x_axis)*cos(2*pi*x_axis)*x_t;
plog(x_axis, y_t);


