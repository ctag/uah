% problem 5

A=1.0;
Omega=(2*pi);

x_axis=-3:0.01:3;

y_t=A*sin(Omega*x_axis);

x_t=A*cos(Omega*x_axis);

z_t=y_t + x_t;

plot(x_axis, y_t);
hold all
plot(x_axis, x_t);
hold all
plot(x_axis, z_t);

% p4_a
% Yes, the graph shows how a phasor will allow the functions to act
% interchangeably. It would take -(pi/2) radians to shift sine to match
% cosine.

% p4_b
% The phasor for z_t is -(pi/4) to relative to cosine



