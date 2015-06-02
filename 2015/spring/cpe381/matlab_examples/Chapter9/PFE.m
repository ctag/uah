%
% Partial fraction expansion with MATLAB
%
ind=input(' example (1) or example (2)?  ')
if ind==1,
p1=poly(0.5); p2=poly(-0.5); 
a=conv(p1,p2)	% denominator coefficients
z1=poly(0); z2=poly(-1);
b=conv(z1,z2)	% numerator coefficients
else
a=[1 -0.5 -0.25 0.125]
b=[0 0.5 0 0 ];
end
z=roots(b)		% zeros of X(z)
[r,p,k]=residuez(b,a)	% partial fraction expansio;n, poles and gain

figure(1)
subplot(121)
zplane(b,a); grid	% plot of poles and zeros
d=[1 zeros(1,99)];
x=filter(b,a,d);
n=0:99;
if ind==1;
   x1=r(1)*p(1).^n+r(2)*p(2).^n;
else
    xx=p(1).^n;yy=xx.*n;
    x1=(r(1)+r(2)).*xx+r(2).*yy+r(3)*p(3).^n;
end
    subplot(122)
stem(n(1:20),x(1:20),'r')
hold on
stem(n(1:20),x1(1:20),'x'); grid; axis([0 19 -0.1 1.1]); xlabel('n')
ylabel('x[n], x_1[n]'); legend('using filter', 'using residue')
hold off

