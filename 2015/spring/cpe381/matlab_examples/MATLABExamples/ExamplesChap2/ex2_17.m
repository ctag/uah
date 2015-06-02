%%
% Example 2_17
%%
clear all; clf
Ts=0.01; delay=1; Tend=2.5;
t=0:Ts:Tend;
ind=input( 'Example (type 1, 2, or 3) >> ')
if ind==1,
    x1=ustep(t,0)-ustep(t,-delay);
    h1=ustep(t,0)-ustep(t,-2*delay);
    x=x1;h=h1;
elseif ind==2,
    x2=ramp(t,1,0)+ramp(t,-2,-1)+ramp(t,1,-2);
    h2=x2;
    x=x2;h=h2;
else
    x3=exp(-2*t);
    h3=2*exp(-10*t);
    x=x3;h=h3;
end
y=Ts*conv(x,h);
t1=0:Ts:length(y)*Ts-Ts;
figure(1)
subplot(311)
plot(t,x); axis([0 2.5 -1.2 1.2]);grid;ylabel('x_3(t)');
subplot(312)
plot(t,h); axis([0 2.5 -1.2 2.1]);grid;ylabel('h_3(t)'); 
subplot(313)
plot(t1,y);; axis([0 5 -1.1 1.1]);grid;ylabel('y_3(t)'); 