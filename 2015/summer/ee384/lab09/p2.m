% Lab 09 - Problem 2
% EE384
% Christopher Bero

% P2.a
figa=figure();
lc_a=imread('/home/berocs/Documents/uah/ee384/lab09/lowcontrast.jpg');
imshow(lc_a);

% P2.b
figb=figure();
imhist(lc_a);

% P2.c
figc=figure();
lc_c=histeq(lc_a,256);
imshow(lc_c);
figc2=figure();
imhist(lc_c);













