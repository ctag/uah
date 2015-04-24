%%
% Example 9.24 --- Deconvolution
%%
clear all; clf
x=ones(1,100);
y=[1 zeros(1,100)]; 		% case (a), correct h
%y=[1 zeros(1,99)]; 		% case (b), wrong h
[h,r]=deconv(y,x)
figure(1)
n=0:length(h)+9;
stem(n,[h zeros(1,10)]);grid;xlabel('n');ylabel('h[n]')