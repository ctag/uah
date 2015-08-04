function [ x ] = bero_idft( Y )
% bero_idft

    N=length(Y);
    x=zeros(N,1);

    for yi = 1:N;
        acc=0;
        for k = 0:(N-1)
            W=( exp( -1i*(2*pi/N)*-(yi-1)*k ) );
            acc = acc + (Y(k+1) * W);
        end
        x(yi)=(1/N)*acc;
    end
    
end
