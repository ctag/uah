%%
% Example 3.2
%
% Laplace transforms of unit-step,delta 
% and pulse
%%
syms t s
% unit-step function
u=sym('heaviside(t)')
U=laplace(u)
% delta function
d=sym('dirac(t)')
D=laplace(d)
% pulse
p=heaviside(t)-heaviside(t-1)
P=laplace(p)