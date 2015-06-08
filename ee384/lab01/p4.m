% p4
% Prompt for and calculate an equation

x=input('Enter x:');
u=input('Enter mu:');

num=(log(1+(u*abs(x))));
den=(log(1+u));

y=((num/den).*sign(x));

figure;
p=plot(x,y);
set(p,'Color','black');
ylabel('output (y)');
xlabel('vector (x)');
title('Y according to X');

