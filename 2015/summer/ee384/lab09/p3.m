% Lab 09 - Problem 3
% EE384
% Christopher Bero

% P3.a
lena_a=imread('/home/berocs/Documents/uah/ee384/lab09/lena.bmp','bmp');
lena_a2=ee384_rgb2gray(lena_a);
lena_a3=imnoise(lena_a2, 'salt & pepper');
figure();
image(lena_a3);

% P3.b
lena_b=medfilt2(lena_a3);
figure();
image(lena_b);

% P3.c
lena_c=medfilt2(lena_a3, [5 5]);
figure();
image(lena_c);

















