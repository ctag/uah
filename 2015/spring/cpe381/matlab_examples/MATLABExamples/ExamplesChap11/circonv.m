function xy=circonv(x,y,N)
M=max(length(x),length(y))
if M>N
   disp('Increase N')
end
x=[x zeros(1,N-M)];
y=[y zeros(1,N-M)];
% circular convolution
X=fft(x,N);Y=fft(y,N);XY=X.*Y;
xy=real(ifft(XY,N));
