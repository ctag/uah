%%
% Lissajous figures
%%
clear all; clf
syms x y t
x=cos(2*pi*t);          % input of unit amplitude and frequency 2*pi
A=1;figure(1)           % amplitude of output in case 1
for i=1:2,
for k=0:3,
    theta=k*pi/4;       % phase of output
    y=A^k*cos(2*pi*t+theta);
   if k==0,subplot(221)
      elseif k==1,subplot(222)
      elseif k==2,subplot(223)
      else subplot(224)
   end
   ezplot(x,y);grid;hold on
end
A=0.5; figure(2)         % amplitude of output in case 2
end