%%%
% Computation with complex numbers
%%%
clear all; clf
z=8+j*3
v=9-j*2	% given complex numbers
a=real(z)+imag(v)	% addition of real part of z with imaginary part of v
b=abs(z+conj(v))	% absolute value of sum of z and conjugate of v
c=abs(z*v)          % absolute value of product of z and v
d=angle(z)+angle(v) % sum of angles of z and v in rad
d1=d*180/pi 		% conversion from radians to degrees
e=abs(v/z)          % absolute value of v divided by z
f=log(j*imag(z+v)) 	% natural log of the imaginary part of z+v