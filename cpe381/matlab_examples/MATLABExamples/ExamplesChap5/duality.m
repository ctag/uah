%%
% Duality
%% 
clear all; clf
syms t w 
m=heaviside(t+0.5)-heaviside(t-0.5); A=10;
x=A*m;
X=fourier(x);
xx=ifourier(2*pi*x)
figure(1)
subplot(221)
ezplot(x,[-1,1]);grid;axis([-1 1 -0.2 11]); title(' '); xlabel('t'); ylabel('x_1(t)')
subplot(222)
ezplot(X,[-100,100]); grid; axis([-100 100 -3 11]); title(' '); xlabel('\Omega'); ylabel('X_1(\Omega)')
subplot(223)
ezplot(xx,[-100,100]);grid;axis([-100 100 -3 11]); title('');xlabel('t'); ylabel('x(t)=X_1(t)')
subplot(224)
ezplot(2*pi*x,[-1,1]);grid;axis([-1 1 -0.5 11*2*pi]); title(' '); xlabel('\Omega'); ylabel('X(\Omega)=2\pi x_1(-\Omega)')