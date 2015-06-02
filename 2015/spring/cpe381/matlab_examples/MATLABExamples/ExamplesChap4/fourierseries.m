function [X, w]=fourierseries(x,T0,N) 
% function fourierseries 
% Computes harmonics of the Fourier series of a continuous-time signal 
% symbolically
% input: periodic signal x(t), its period (T0), number of harmonics (N)
% output: harmonics X and corresponding harmonic frequency w
% use: [X, w]=fourier(x,T0,N)

syms t
for k=1:N,
    X1(k)=int(x*exp(-j*2*pi*(k-1)*t/T0),t,0,T0)/T0;
    X(k)=subs(X1(k));
    w(k)=(k-1)*2*pi/T0;
end

    