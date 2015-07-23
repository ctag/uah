function [ bmp_gray ] = ee384_rgb2gray( bmp )
% ee384_rgb2gray - ee384 - Lab 09
% This function will stack R, G, and B mxn pages
% from an input bitmap. The color values are weighted
% 30% Red, 60% Green, 10% Blue

bmp_gray = (0.3 * bmp(:,:,1)) + (0.6 * bmp(:,:,2)) + (0.1 * bmp(:,:,3));

end

