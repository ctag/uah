
x=input('Enter x:');
u=input('Enter mu:');

NUM=(log(1+(u*abs(x))));
DEN=(log(1+u));

y=((NUM/DEN).*sign(x));

p=plot(x,y);
set(p,'Color','black');
ylabel('output (y)');
xlabel('vector (x)');
title('Y according to X');

