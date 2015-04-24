%%
% Time vs Frequency 
%%
clear all; clf
syms t w
for i=1:2,
    tau=0.5+(i-1)*1.5;
    x=heaviside(t+tau)-heaviside(t-tau);
    X=fourier(x);
    if(i==1)
        figure(1)
        subplot(211)
        ezplot(x,[-3 3]);axis([-3 3 -0.1 1.1]);grid;ylabel('x_1(t)');xlabel('t')
        subplot(212)
        ezplot(X,[-50 50]);axis([-50 50 -1 5]);grid;ylabel('X_1(\Omega)');xlabel('\Omega')
    else
        figure(2)
        subplot(211)
        ezplot(x,[-3 3]);axis([-3 3 -0.1 1.1]);grid;ylabel('x_2(t)');xlabel('t')
        subplot(212)
        ezplot(X,[-50 50]);axis([-50 50 -1 5]);grid;ylabel('X_2(\Omega)');xlabel('\Omega')
    end
end
