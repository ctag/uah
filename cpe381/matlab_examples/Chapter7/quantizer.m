function [d,y,e]=quantizer(x,Q)
  %  Input: x, signal to be quantized at 2Q levels
  %  Outputs: y, quantized signal
  %          e, quantization error
  %  USE [y,e]=midriser(x,Q)
  % 
N=length(x);
d=max(abs(x))/Q;
for k=1:N,
  if x(k)>=0,
    y(k)=floor(x(k)/d)*d;
  else
    if x(k)==min(x),
       y(k)=(x(k)/abs(x(k)))*(floor(abs(x(k))/d)*d);
    else
       y(k)=(x(k)/abs(x(k)))*(floor(abs(x(k))/d)*d+d);
    end
  end
  if y(k)==2*d,
    y(k)=d;%
  end
end
e=x-y