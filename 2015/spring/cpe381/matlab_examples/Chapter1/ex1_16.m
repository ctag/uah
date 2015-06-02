% Example 1.16
%
% Generation of y(t)=3r(t+3)-6r(t+1)+3r(t)-3u(t-3), t in [-5,5],0 otherwise
%
clear all; clf
Ts=0.01; t=-5:Ts:5; % support of signal
% ramp with support [-5, 5], slope of 3 and advanced
% (shifted left) with respect to the origin by 3    
y1=ramp(t,3,3);
y2=ramp(t,-6,1);
y3=ramp(t,3,0);
% unit-step function with support [-5,5], delayed by 3
y4=-3*ustep(t,-3);
y=y1+y2+y3+y4;
plot(t,y,'k'); axis([-5 5 -1 7]); grid
xlabel('t (sec)'); ylabel('y(t)'); title(' Example 1.16')