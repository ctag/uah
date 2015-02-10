% problem 8

x_axis = -5:0.01:5;

x_t = cos(2.*2.*pi.*x_axis) + 2.*cos(2.*pi.*x_axis);

plot(x_axis, x_t);

% a)
% T0 = 1s

% from pg 85
fun = @(x) square(cos(2.*2.*pi.*x) + 2.*cos(2.*pi.*x));
q = (1/(1))*integral(fun, 0, 1);

% b)
% P(q) = -0.238563468046797

fun_a = @(x) square(cos(2.*pi.*x));
q_a = (1/(1))*integral(fun_a, 0, 1);

% q_a = 1.613811758020811e-11

fun_b = @(x) square(cos(2.*cos(pi.*x)));
q_b = (1/(1))*integral(fun_b, 0, 1);

% q_b = 0.150167170794685

% P(q) != q_a + q_b











