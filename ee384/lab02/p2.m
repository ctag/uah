% P2

% 2.2
n=-10:10;
x=(2*n)+3;

% % 2.2 a
% h1=figure;
% plot(n,x);
% title('2.2a: Unmodified X');
% xlabel('N: -10:10');
% ylabel('X: 2n+3');
% xlim([-15 15]);
% ylim([-15 25]);
% 
% % 2.2 b
% h2=figure;
% [x_delay, n_delay]=time_shifting(x, n, 3);
% plot(n_delay,x_delay);
% title('2.2b: X shifted by 3 samples');
% xlabel('N-modified');
% ylabel('X-modified');
% xlim([-15 15]);
% ylim([-15 25]);
% 
% % 2.2 c
% h3=figure;
% [x_rev, n_rev]=time_reversal(x, n);
% plot(n_rev,x_rev);
% title('2.2c: X reversed');
% xlabel('N-modified');
% ylabel('X-modified');
% xlim([-15 15]);
% ylim([-15 25]);

% % 2.3
% h4=figure;
% n=-10:10;
% [d4,nd4]=unit_impulse(-10, 10, -4);
% %[d4,nd4]=time_shifting(d4, nd4, (-4));
% [d2,nd2]=unit_impulse(-10, 10, 2);
% %[d2,nd2]=time_shifting(d2, nd2, 2);
% y=(5*d4)-(2*d2);
% stem(n, y);

% 2.4
h5=figure;
n=-10:10;
[u4,nu4]=unit_step(-10, 10, 4);
[u,nu]=unit_step(-10, 10, 0);
y=(u)-(u4);
stem(n, y);






