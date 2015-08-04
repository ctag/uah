% Lab 09 - Problem 1
% EE384
% Christopher Bero

%P1.a
% Read and show lena.bmp
lena_a=imread('/home/berocs/Documents/uah/ee384/lab09/lena.bmp','bmp');
figure();
image(lena_a);

%P1.b
% Convert to greyscale with built-in function rgb2gray
lena_b=rgb2gray(lena);
figure();
image(lena_b);

% P1.c
% Write and use your own rgb2gray function
lena_c=ee384_rgb2gray(lena);
figure();
image(lena_c);











