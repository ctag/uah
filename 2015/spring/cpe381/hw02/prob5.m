% 2.5

clear all;

syms s t u(t);

f = 5*(exp(-2*t))*(cos(8*t))*(u(t));

r = -5:0.01:5;

L = laplace(f,t,s);

plot(t,L);

%zplane();

f = 5*(exp(-4*t))*(cos(8*t))*(u(t));

r = -5:0.01:5;

L = laplace(f,t,s);
