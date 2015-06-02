%%
% Example 1.17
%
% Even and odd components of y(t)=2r(t+2.5)-5r(t)+3r(t-2)+u(t-4), for 
% t in[-5,5], 0 otherwise
%%
clear all; clf

% generation of y(t)
t=-5:0.01:5;
y1=ramp(t,2,2.5);
y2=ramp(t,-5,0);
y3=ramp(t,3,-2);
y4=ustep(t,-4);
y=y1+y2+y3+y4;
figure(1)
plot(t,y,'k'); axis([-5 5 -3 5]); grid 
xlabel('t (sec)'); ylabel('y(t)'); title( 'Example 1.17')

% even and odd decomposition
[ye, yo]=evenodd(t,y);
figure(2)
subplot(211)
plot(t,ye); grid
axis([min(t) max(t) -2 5])
xlabel('t'); ylabel('y_e(t)')
subplot(212)
plot(t,yo,'r'); grid
axis([min(t) max(t) -1 5])
xlabel('t'); ylabel('y_o(t)')