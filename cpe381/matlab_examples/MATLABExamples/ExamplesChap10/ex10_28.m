%%
% Example 10_28
%%
% state models  
clear all; clf
num1=[1 0]; den1=[1 0.5];
[A1,B1,C1,D1]=tf2ss(num1,den1)
num2=[0.8 -0.2 0]; den2=[1 -1 0.5];
[A2,B2,C2,D2]=tf2ss(num2,den2)
% verification
[nu,de]=ss2tf(A1,B1,C1,D1,1)
[nu1,de1]=ss2tf(A2,B2,C2,D2,1)