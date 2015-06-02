%%
% Examples 5.3, 5.4
%%
clear all;clf
syms t w
ind=input('Example 5_(3 or 4?)')
if ind==3
    x=heaviside(t)-heaviside(t-1);
    x1=heaviside(t)-heaviside(t-0.5);
    X=fourier(x)
    X1=fourier(x1)
    
    figure(1)
    subplot(221)
    ezplot(x,[-0.5 1.5]); grid; xlabel('t'); ylabel('x(t)');title('')
    axis([-0.5 1.5 0 1.1])
    subplot(222)
    ezplot(x1,[-0.5 1.5]); grid; xlabel('t'); ylabel('x_1(t)');title('')
    axis([-0.5 1.5 0 1.1])
    subplot(223)
    ezplot(abs(X),[-50,50]); grid; xlabel('\Omega'); ylabel('|X(\Omega)|');title('')
    axis([-50 50 0 1])
    subplot(224)
    ezplot(abs(X1),[-50,50]); grid; xlabel('\Omega'); ylabel('|X_1(\Omega)|');title('')
    axis([-50 50 0 1])
else  
    x=exp(-abs(t))
    X=fourier(x)
    figure(1)
    subplot(221)
    ezplot(x,[-10,10]);grid;axis([-10 10 -0.2 1.2]); title(' ');
    ylabel('x(t)'); xlabel('t (sec)')
    subplot(223)
    ezplot(sqrt((real(X))^2+(imag(X))^2),[-30,30]); grid; axis([-10 10 -0.2 2.2]);
    xlabel('\Omega'); ylabel('|X(\Omega)|'); title(' ');
    subplot(224)
    ezplot(imag(log(X)),[-30,30]); grid; title(' ');
    axis([-10 10 -1.8 1.8]); xlabel('\Omega'); ylabel('<X(\Omega)')
end