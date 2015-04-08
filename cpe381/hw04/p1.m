% HW4 - P1
% Christopher Bero

clear all;

syms s;

% H1(s)
numerator=((s-1)*(s-(1+pi))*(s-(1-pi)));
denominator=((s+1)*(s-(-1+pi))*(s-(-1-pi)));
fig1=figure;
magnitudeResponse(numerator, denominator, fig1);

% H2(s)
numerator=((s-pi)*(s+pi));
denominator=((s+1)*(s-(-1+pi))*(s-(-1-pi)));
fig2=figure;
magnitudeResponse(numerator, denominator, fig2);

% H3(s)
numerator=(s-1);
denominator=((s+1)*(s-(-1+pi))*(s-(-1-pi)));
fig3=figure;
magnitudeResponse(numerator, denominator, fig3);