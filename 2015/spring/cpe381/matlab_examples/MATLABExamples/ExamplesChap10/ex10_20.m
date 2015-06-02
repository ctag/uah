%%
% Example 10.20
%
% Approximate solution of RLC d.e. 
%%
clear all; clf
syms s
vc=ilaplace(1/(s^3+s^2+s))
figure(3)
ezplot(vc,[0,10]);grid;title(''); hold on
Ts=0.1;
a1=1/Ts^2+1/Ts+1;a2=-2/Ts^2-1/Ts;a3=1/Ts^2;
a=[1 a2/a1 a3/a1];b=1;
t=0:Ts:10;
N=length(t);
n=0:N-1;
vs=ones(1,N);
vca=filter(b,a,vs);vca=vca/vca(N);
plot(t,vca,'r--');grid
hold off
grid; legend('exact solution','approximate solution');
ylabel('v_c(t), v_{ca}(t)')