% Lab 04 - Problem 1
% EE384
% Christopher Bero

% P1.a
x=[1,2,3,4,5,6,7,8];
Y=fft(x);

% P1.b
Yi=ifft(Y);

% P1.c
bero_Y=bero_dft(x);
bero_x=bero_idft(bero_Y);