X=[1 zeros(1,4)];
B=ones(1,5);
A=ones(1,5)/5;
y=filter(A,B,X);
x=[0:1:4];
stem(x,y);