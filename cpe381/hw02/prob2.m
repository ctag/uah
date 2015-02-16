% 2.2

clear all; clf;

% This was not covered in class or in the book.
load handel.mat;

% Ostensibly, 'y' and 'Fs' are now available.

t = 0:Fs:1;

l = 0.5;

x1 = y;
x2 = 0.8*(y-l);
x3 = 0.5*(y-(2*l));

x = x1 + x2 + x3;

sound(x, Fs);
% Can then be compared against the command: sound(y, Fs);

