%%
% Two methods for inverse Z-transform
%%
p1=poly(0.5); p2=poly(-0.5); 	% generation of terms in denominator
a=conv(p1,p2)					% denominator coefficients
 z1=poly(0); z2=poly(-1); 		% generation of terms in numerator
 b=conv(z1,z2)					% numerator coefficients
 z=roots(b)						% zeros of X(z)
 [r,p,k]=residuez(b,a)			% residues, poles and gain
 figure(1)
 subplot(121)
 zplane(b,a)					% plot of poles and zeros
 d=[1 zeros(1,99)];				% impulse delta[n]
 x=filter(b,a,d);				% x[n] computation from filter
 n=0:99;
 x1=r(1)*p(1).^n+r(2)*p(2).^n;	% x[n] computation from residues
 subplot(122)
 stem(n(1:20),x(1:20))
 hold on
 stem(n(1:20),x1(1:20),'rx')
 hold off