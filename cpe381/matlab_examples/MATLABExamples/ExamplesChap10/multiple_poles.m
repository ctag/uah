%%
%  Inverse Z-transform --- multiple poles
%%        
clear all; clf        
b=[0 0.5 0 0 ];
a=[1 -0.5 -0.25 0.125]
[r,p,k]=residuez(b,a)	   		
figure(1)
subplot(121)
zplane(b,a)								  % plot of poles and zeros
n=0:99; xx=p(1).^n; yy=xx.*n;
x1=(r(1)+r(2)).*xx+r(2).*yy+r(3)*p(3).^n; % inverse
subplot(122)
stem(n(1:10),x1(1:10))
hold off