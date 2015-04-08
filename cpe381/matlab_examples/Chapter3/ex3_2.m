% Example 3.2
%
% Laplace transforms of unit-step and delta function
%
syms t s
% unit-step function
u=sym('heaviside(t)')
U=laplace(u)
% delta function
d=sym('dirac(t)')
D=laplace(d)
