%% 
% Example 11.26
%%
ind=input('fft vs dft (1) or conv and conv(ffT)(2)?  ')
if ind==1,
% fft vs dft
    clf; clear all
    time=zeros(1,5); time1=zeros(1,5);
    for r=8:12,
        N(r)=2^r;i=r-7;
        % fft elapsed time
        t=tic; X1=fft(ones(1,N(r)),N(r)); time(i)=toc(t);
        % dft elapsed time
        t=tic; Y1=dft(ones(N(r),1),N(r)); time1(i)=toc(t);
        % difference fft and dft
        sum(X1-Y1')
    end
    n=8:12;
    figure(1)
    stem(n,log10(time*10^6),'filled');title('FFT vs DFT')
    hold on
    stem(n,log10(time1),'r','filled')
    axis([7.99 12 -1 6])
    xlabel('n=log_2(N)'); ylabel('CPU time (sec)')
    grid; legend('6 log_{10}(fft time)', 'log_{10}(dft time)')
    hold on
    plot(n,log10(time1),'r--')
    hold off
else
% comparison of conv and fft
    clear all
    time1=zeros(1,10);time2=time1;
    for i=1:10,
      NN=1000*i; x=ones(1,NN);
    % elapsed time for convolution using conv
      t1=tic; y=conv(x,x); time1(i)=toc(t1);
    % elapsed time for convolution using fft
      x=[x zeros(1,NN)]; t2=tic; X=fft(x); X=fft(x); Y=X.*X; y1=real(ifft(Y));
      time2(i)=toc(t2);
    end
    n=1:10;n=2000*n;
    figure(3)
    stem(n,time1,'kx');title('conv vs FFT convolution')
    hold on
    stem(n,time2,'r','filled')
    hold on
    plot(n,time1,'k--'); hold on; plot(n,time2,'r--');grid
    legend('conv time','fft-conv time')
    xlabel('Length of convolution sum')
    ylabel('CPU time')
end

