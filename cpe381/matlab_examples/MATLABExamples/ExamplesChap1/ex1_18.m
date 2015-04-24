%%
% Example 1.18
%%
% (a) Generation of a damped sinusoid x(t)=exp(-t)cos(2pi t) and its 
% envelope using symbolic matlab
%%
t=sym('t');
y=exp(-t)*cos(2*pi*t);
ye=exp(-t);
figure(1)
ezplot(y,[-2,4])
grid
hold on
ezplot(ye,[-2,4])
hold on
ezplot(-ye,[-2,4])
axis([-2 4 -8 8])
hold off
xlabel('t'); ylabel('y(t)'); title('Example 1.18(a)')
%%
% (b) Generation of x_1(t)=1+1.5 cos(0.2 pi t)-0.6 cos(0.4 pi t)
% using symbolic matlab
%%
figure(2)
t=sym('t');
x=1+1.5*cos(2*pi*t/10)-.6*cos(4*pi*t/10);
ezplot(x,[-10,10]); grid  
xlabel('t'); ylabel('x(t)'); title('Example 1.18(b)')