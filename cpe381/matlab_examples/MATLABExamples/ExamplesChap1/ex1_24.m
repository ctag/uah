%%
% Example 1.24
%
% Generation of an AM signal
%%
clear all;clf
% Message signal
t=-5:0.001:5;     
y1=ramp(t,2,2);
y2=ramp(t,-4,0);
y3=ramp(t,1,-2);
y4=ramp(t,1,-3);
y5=ustep(t,-3);
y=y1+y2+y3+y4+y5;   % message
% AM modulation      
x=sin(5*pi*t);      % carrier     
z=y.*x;
sound(100*z,10000)
figure(1)
plot(t,z,'k'); hold on
plot(t,y,'r',t,-y,'r'); axis([-5 5 -5 5]); grid
hold off 
xlabel('t'); ylabel('z(t)'); title('Example 1.24')
