%% 
% Z-transformation (one-sided)
%% 
syms n w0
h1=0.9.^n;H1 = ztrans(h1)
h2=heaviside(n)-heaviside(n-10); H2= ztrans(h2)
h3=cos(w0*n); H3=ztrans(h3)
H4=ztrans(h1*h3)
  