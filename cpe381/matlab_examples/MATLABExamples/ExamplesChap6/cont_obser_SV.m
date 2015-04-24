%%
%  Transfer function to state variable representation of
% y^(2)(t)-y^(1)(t)-2 y(t)=w^(1)(t)- 2w(t)
%%
clear all
Num=[0 1 -2]; Den=[1 -1 -2];
% controller
disp('Controller form')
[A,b,c,d]=tf2ss(Num,Den)
[N,D]=ss2tf(A,b,c,d) % transfer function from state-variable equations
% observer
disp('Observer form')
Ao=A'
bo=c'
co=b'
do=d
[N,D]=ss2tf(Ao,bo,co,do)% transfer function from state-variable equations
% Application of Cramer's rule
syms x10 x20 w s
% controller
X1= det([x10+w -2;x20 s])/det([s-1 -2;-1 s])
X2= det([s-1 x10+w;-1  x20])/det([s-1 -2;-1 s])	
% observer
X1o= det([x10+w -1;x20-2*w s])/det([s-1 -1;-2 s])
