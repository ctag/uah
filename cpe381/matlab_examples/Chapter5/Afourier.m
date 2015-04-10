function X = Afourier(x,T0)
%
syms t w
    if T0==Inf
X=int(x*exp(-j*w*t), t,-T0,T0)
    else
        X=int(x*exp(-j*w*t), t,-T0,T0)
end

