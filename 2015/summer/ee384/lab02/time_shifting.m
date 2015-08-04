function [ m, y ] = time_shifting( x, n, n_d )
%Time Shifting, Move a signal by n_d samples
y=x;
m=n+n_d;
end

