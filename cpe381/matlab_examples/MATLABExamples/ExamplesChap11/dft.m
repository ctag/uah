function X=dft(x,N)
n=0:N-1;
W=ones(1,N);
for k=1:N-1,
    W=[W; exp(-j*2*pi*n*k/N)];
end
X=W*x;

