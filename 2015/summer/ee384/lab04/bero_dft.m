function [ Y ] = bero_dft( x )
% bero_dft

    N=length(x);
    Y=zeros(N,1);

    for yi = 1:N;
        acc=0;
        for k = 0:(N-1)
            W=( exp( -1i*(2*pi/N)*(yi-1)*k ) );
            acc = acc + (x(k+1) * W);
        end
        Y(yi)=acc;
    end

end

