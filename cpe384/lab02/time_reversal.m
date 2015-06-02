function [ y, m ] = time_reversal( x, n )
%Time Reversal: Flips function about the y axis.
y=fliplr(x);
m=-fliplr(n);
end