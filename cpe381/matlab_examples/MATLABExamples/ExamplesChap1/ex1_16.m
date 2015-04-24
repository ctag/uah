%%
% Example 1.16
%
% Generation of y(t)=3r(t+3)-6r(t+1)+3r(t)-3u(t-3), t in [-5,5],0 otherwise
%%
clear all; clf
Ts=0.01; t=-5:Ts:5;                 % support of signal
% ramps with support [-5,5]
y1=ramp(t,3,3);                     % slope 3, advanced by 3
y2=ramp(t,-6,1);                    % slope -6, advanced by 1     
y3=ramp(t,3,0);                     % slope 3,
% unit-step with support [-5,5]
y4=-3*ustep(t,-3);                  % amplitude -3, delayed by 3 
y=y1+y2+y3+y4;
figure(1)
plot(t,y,'k'); axis([-5 5 -1 7]); grid
xlabel('t (sec)'); ylabel('y(t)'); title(' Example 1.16')