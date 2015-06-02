%%
% Example 3.26
%%
clear all; clf
syms s 
num=[1 0];
den=[1 3 4 2];
figure(1)
subplot(211)
splane(num, den)
disp('>>>>> Inverse Laplace <<<<<')
x=ilaplace(s/(s^3+3*s^2+4*s+2)) 		% inverse Laplace transform
subplot(212)
ezplot(x,[0,12]); 
axis([0 7 -0.15 0.25]); grid
