%%
% Example 9.17
%
% Signal generation using ramps and usteps
% even and odd decomposition
%%
Ts=0.15;                                            % sampling period
t=-5:Ts:5; % time support
y1=ramp(t,3,3); y2=ramp(t,-6,1); y3=ramp(t,3,0);    % ramp components
y4=-3*ustep(t,-3);                                  % unit-step component
y=y1+y2+y3+y4;

N=length(y);
n=ceil(t/Ts);
figure(1)
stem(n,y,'k')
axis([min(n) max(n) -1 7]); ylabel('y[n]'); xlabel('n'); grid

% even-odd decomposition
[ye,yo]=evenodd(y);
figure(2)
subplot(211)
stem(n,ye,'k','filled'); axis([min(n) max(n) -2 5]); grid; ylabel('y_e[n]');xlabel('n')
subplot(212)
stem(n,yo,'r','filled'); axis([min(n) max(n) -2 5]); ylabel('y_o[n]'); xlabel('n'); grid