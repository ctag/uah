% creating your own function 

% The following file is for a function  f with input a scalar x and
% output the scalar y related by a mathematical function:
function y=f(x)
    y=x*exp(-sin(x))/(1+x^2);
