

a1=input('Enter the value of a1:');
b1=input('Enter the value of b1:');
c1=input('Enter the value of c1:');
d1=input('Enter the value of d1:');

a2=input('Enter the value of a2:');
b2=input('Enter the value of b2:');
c2=input('Enter the value of c2:');
d2=input('Enter the value of d2:');

a3=input('Enter the value of a3:');
b3=input('Enter the value of b3:');
c3=input('Enter the value of c3:');
d3=input('Enter the value of d3:');

A=[a1 b1 c1; a2 b2 c2; a3 b3 c3];
d=[d1; d2; d3];

ans=inv(A)*d
