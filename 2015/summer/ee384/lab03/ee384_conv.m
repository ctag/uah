function [ y, len ] = ee384_conv( x, h )
%ee384_conv generate the convolution of two vectors

% Convolution function:
% y[n] = SUMMATION from j of (x[j]h[n-j+1])
% The plus 1 is to make up for matlab not having zero indexed matrices

% EX:
% x[n] = [1 2 3]; -> M
% h[n] = [4 5]; -> N
% Len = M + N -1

M=length(x);
N=length(h);
len=1:(M+N-1);

if M >= N
    subLen=M;
else
    subLen=N;
end

y=len;

for n = len
    acc=0;
    for j = 1:subLen
        if (n-j+1)<=0
            continue
        end
        if (n-j+1)>N
            continue
        end
        acc=acc+(x(j)*h(n-j+1));
    end
    y(n)=acc;
end

end















