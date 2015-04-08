function [ ] = magnitudeResponse( numerator , denominator, fig )
% Helper function for CPE381 homework #4
% Expected input format: un-tiered polynomial: (s-1)*(s-(z))*(s-(-z))

% expand() to break equation into polynomial form
% coeffs() to pull just coefficients from the equation
% double() to turn syms matrix back into numerical form
% roots() to calculate the roots of the polynomial,
%       which are plotted with splane()

% Sections adapted from ex5_18.m

syms s;

numerator_poly=fliplr(double(coeffs(expand(numerator),s)));
denominator_poly=fliplr(double(coeffs(expand(denominator),s)));

%n=roots(numerator_poly)
%d=roots(denominator_poly)

n=numerator_poly;
d=numerator_poly;

wmax=50;
[w,Hm,Ha]=freqresp_s(n,d,wmax);
figure(fig);
subplot(211)
plot(w,Hm)
axis([0 wmax 0 1.1*max(Hm)])
ylabel('|H(j \omega)|')
grid
xlabel('\omega')
title(' Magnitude response')
subplot(212)
plot(w,Ha)
axis([0 wmax 1.1*min(Ha) 1.1*max(Ha)])
ylabel('< H(j \omega)')
xlabel('\omega')
title(' Phase response')
grid
%subplot(223)
%splane(n,d)
%title('Poles/Zeros')
%grid

end

