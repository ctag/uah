%%
% Example 5.7
%%
clear all;clf
syms t w 
ind=input('part 1 or 2?   ')
if ind==1.
    y=exp(-abs(t)); 
    y1=y*0.5*exp(-j*10*t)+y*0.5*exp(j*10*t)
    Y1=fourier(y1);
    Ym=abs(Y1); Ya=atan(imag(Y1)/real(Y1));
    figure(1)
    subplot(221)
    ezplot(y1,[-6,6]);grid;axis([-6 6 -1.2 1.2]); title(' '); xlabel('t'); ylabel('y_1(t)')
    subplot(223)
    ezplot(Ym,[-20,20]); grid; axis([-20 20 -0.1 1.5]);title(' '); xlabel('\Omega'); ylabel('|Y_1(\Omega)|')
    subplot(224)
    ezplot(Ya,[-20,20]); grid; title(' '); xlabel('\Omega'); ylabel('<Y_1(\Omega)')
    axis([-20 20 -1.5 1.5]);
    xlabel('\Omega')
else
    m=heaviside(t+5)-heaviside(t)
    m1=heaviside(t)-heaviside(t-5);
    x2=(t+5)*m+m1*(-t+5);x2=x2/5;
    y2=x2*exp(-j*10*t)/2+x2*exp(+j*10*t)/2;
    X2=int(x2*exp(-j*w*t), t,-5,5);X2m=abs(X2);
    Y2=int(y2*exp(-j*w*t), t,-5,5);Y2m=abs(Y2);
    figure(2)
    subplot(221)
    ezplot(x2,[-6,6]);grid;axis([-6 6 -0.2 1.2]); title(' '); xlabel('t'); ylabel('x_2(t)')
    subplot(222)
    ezplot(y2,[-6,6]);grid;axis([-6 6 -1.2 1.2]); title(' '); xlabel('t'); ylabel('y_2(t)=x_2(t) cos(10t)')
    subplot(223)
    ezplot(X2m,[-8,8]); grid; axis([-8 8 -0.1 5.5]); title(' ')
    xlabel('\Omega'); ylabel('|X_2(\Omega)|')
    subplot(224)
    ezplot(Y2m,[-20,20]); grid; axis([-20 20 -0.1 5.5]); title(' ')
    xlabel('\Omega'); ; ylabel('|Y_2(\Omega)|')
end