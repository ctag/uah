%%
% Inverse Z-transform
%%
syms n z
x1=iztrans((z*(z+1))/((z+0.5)*(z-0.5)))
x2=iztrans((2-z)/(2*(z-0.5)))
x3=iztrans((8-4*z^(-1))/(z^(-2)+6*z^(-1)+8))
