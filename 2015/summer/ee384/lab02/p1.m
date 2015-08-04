% Lab 02 - Problem 1
% EE384
% Christopher Bero

% n1=1;
% n2=10;
% n_p=7;
% [y,n]=unit_step(n1,n2,n_p);
%stem(n,y);

% n=-10:0.1:10;
% x=sin(n);
% n_d=2;
% [m,y]=time_shifting(x, n, n_d);
%plot(m,y);

% P2.2
n=-10:10;
x=(2*n+3);
% P2.2a
figure;
subplot(3,1,1);
stem(n,x);
title('Problem 2.2a, Unmodified');
xlabel('Domain');
ylabel('Range');
% P2.2b
n_d=3;
[m,y]=time_shifting(x, n, n_d);
subplot(3,1,2);
stem(m,y);
title('Problem 2.2b, Time Shifting');
xlabel('Domain');
ylabel('Range');
% P2.2c
[y,m]=time_reversal(x, n);
subplot(3,1,3);
stem(m,y);
title('Problem 2.2c, Time Reversal');
xlabel('Domain');
ylabel('Range');

% problem 2.3
n=-10:10;
[y1,m1]=unit_impulse(-10, 10, -4);
[y2,m2]=(unit_impulse(-10, 10, 2));
y1=y1*5;
y2=y2*2;
y=y1-y2;
figure;
stem(n, y);
title('Problem 2.3');
xlabel('Domain');
ylabel('Range');

% problem 2.4
n=-10:10;
[y1,m1]=unit_step(-10, 10, 0);
[y2,m2]=unit_step(-10, 10, 4);
y=y1-y2;
figure;
stem(n, y);
title('Problem 2.4');
xlabel('Domain');
ylabel('Range');

% fliplr

