function [ n, y ] = unit_impulse( n1, n2, n_p )
%unit_impulse: Returns a vector of the unit impulse

n=n1:n2;
y=((n-n_p)==0);
end

