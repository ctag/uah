function splane(num,den)
%
%
disp('>>>>>  Zeros <<<<<')
z=roots(num)
disp('>>>>>  Poles <<<<<')
p=roots(den)
A1=[min(imag(z)) min(imag(p))];A1=min(A1)-1;
B1=[max(imag(z)) max(imag(p))];B1=max(B1)+1;
N=20;
D=(abs(A1)+abs(B1))/N;
im=A1:D:B1;
Nq=length(im);
re=zeros(1,Nq);
A=[min(real(z)) min(real(p))];A=min(A)-1;
B=[max(real(z)) max(real(p))];B=max(B)+1;

stem(real(z),imag(z),'o:')
hold on
stem(real(p),imag(p),'x:')
hold on
plot(re,im,'k');xlabel('\sigma');ylabel('j\Omega')
grid 
axis([A 3 min(im) max(im)])
%hold off
