% HW1 Problem 3
% Christopher Bero
% CPE 381

% MATLAB instructs me to replace i and/or j with (1i).

p3_z = (1+((1i)*1));
p3_w = exp(p3_z);

p3_a=log(p3_w);
% 1.000000000000000 + 1.000000000000000i

% b)
% real: 1.0
% imag: 1.0i

p3_c=p3_w+(conj(p3_w));
% 2.937387879831771

p3_d1=abs(p3_w);
% 2.718281828459046

p3_d2=angle(p3_w);
% 1

p3_e=square(abs(log(p3_w)));
% 1

% f)
% e^(j1) = (cos(1) + jsin(1))
% (x^2)*(x^3) = x^5 = x^(2+3)
% w = (e^(1+j1)) = (e^(1) * e^(j1))
% w = e^(1)*(cos(1) + jsin(1))
% (cos(1) + jsin(1)) = w/(e^(1))
% cos(1) = w/(e^1) - jsin(1)







