%%
% Impulse, unit--step and ramp responses of linear systems
%%
clear all; clf
syms y t x z
% input a unit-step  (heaviside) response
y=dsolve('D2y+5*Dy+6*y=heaviside(t)','y(0)=0','Dy(0)=0','t');
x=diff(y);              % impulse response
z=int(y);               % ramp response
figure(1)
subplot(311)
ezplot(y,[0,5]);title('Unit-step response');grid
subplot(312)
ezplot(x,[0,5]);title('Impulse response');grid
subplot(313)
ezplot(z,[0,5]);title('Ramp response');grid