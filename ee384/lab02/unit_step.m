function [ y, n ] = unit_step( n1, n2, n_p )
%Unit Step: Returns a vector of the unit step.

n=n1:n2;
y=((n-n_p)>=0);

end

