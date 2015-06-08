
% Variables: n1, n2, n_p

n1=1;
n2=10;
n_p=7;
[y,n]=unit_step(n1,n2,n_p);
%stem(n,y);

n=-10:0.1:10;
x=sin(n);
n_d=2;
[m,y]=time_shifting(x, n, n_d);
%plot(m,y);

n=-10:10;
x=(2*n+3);
n_d=3;
[m,y]=time_reversal(x, n);
%stem(m,y);

n=-10:10;
%y=(5*(unit_impulse(-10, 10, -4)))-(2*(unit_impulse(-10, 10, 2)));
[m1,y1]=unit_impulse(-10, 10, -4);
[m2,y2]=(unit_impulse(-10, 10, 2));
y1=y1*5;
y2=y2*2;
y=y1-y2;
% problem 2.3
stem(m1, y);

% problem 2.4


%fliplr

