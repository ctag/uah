%%
% Example 2.12
%%
clear all; clf 
Ts=0.01;Tend=2
t=0:Ts:Tend;M=6
h0=ustep(t,0)-ustep(t,-1);N=2^M
y=h0/N;	
for k=1:N-1,
y=y+(1/N)*(ustep(t,-k/N)-ustep(t,-1-k/N));
end 
t1=0:Ts:(length(y)-1)*Ts;
figure(1)
plot(t1,y);axis([0 2 0 1.1]);grid;xlabel('t (sec)');
ylabel('y_{64}(t)')
