% 
% Example 12.3
%
% fft vs dft
%
clf; clear all
time=zeros(1,4);
time1=zeros(1,4);
for r=8:11,
N(r)=2^r;
i=r-7;
% fft elapsed time
t=tic;
X1=fft(ones(1,N(r)),N(r));
time(i)=toc(t);
% dft elapsed time
t=tic;
Y1=dft(ones(N(r),1),N(r));
time1(i)=toc(t);
% difference fft and dft
sum(X1-Y1');
end

n=8:11;
figure(1)
stem(n,10^5*time,'ko')
hold on
stem(n,time1,'rx')
axis([min(n) max(n) 0 1.2*max(time1)])
hold off
xlabel('n=log_2(N)'); ylabel('CPU time (sec)')
grid; legend('10^5 fft time', 'dft time')