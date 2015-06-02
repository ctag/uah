%%
% Example 5.11
%%
clear all;clf
syms t w
ind=input('part 1 or 2?   ')
if ind==1
    x1=heaviside(t)-heaviside(t-1);
    X1=fourier(x1)
    figure(1)
    subplot(221)
    ezplot(x1,[-1,5]);grid;axis([-1 5 -0.2 1.2]); title(' '); 
    ylabel('x_1(t)'); xlabel('t (sec)')
    subplot(223)
    ezplot(sqrt((real(X1))^2+(imag(X1))^2),[-30,30]); grid; axis([-30 30 -0.2 1.2]);
    xlabel('\Omega'); ylabel('|X_1(\Omega)|'); title(' ')
    subplot(224)
    ezplot(imag(log(X1)),[-30,30]); grid; title(' ');
    axis([-30 30 -3.5 3.5]); xlabel('\Omega'); ylabel('<X_1(\Omega)');title(' ')
else
    x2=heaviside(t)*exp(-t)
    X2=fourier(x2)
    X2m=sqrt((real(X2))^2+(imag(X2))^2);
    X2a=imag(log(X2));
    figure(1)
    subplot(221)
    ezplot(x2,[-1,5]);grid;axis([-1 5 -0.2 1.2]); title(' '); 
    ylabel('x_2(t)'); xlabel('t (sec)')
    subplot(223)
    ezplot(X2m,[-30,30]); grid; axis([-30 30 -0.2 1.2]);
    xlabel('\Omega'); ylabel('|X_2(\Omega)|'); title(' ')
    subplot(224)
    ezplot(X2a,[-30,30]); grid; title(' ');
    axis([-30 30 -1.8 1.8]); xlabel('\Omega'); ylabel('<X_2(\Omega)');title(' ')

end