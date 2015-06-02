%%
%  Simulation of sampling and reconstruction
%% 
clf; clear all 
    fsim=20000;Tsim=1/fsim;                 % analog simulation 
    C=1; L=floor(C/Tsim);                   % L samples from 0 to C
    t=0:Tsim:C-Tsim;
ind=input(' example 1 or 2? ');
if ind==1,
    fo=1000; x=cos(2*pi*fo*t);
    fmax=fo
else
    fo=250; x=2-cos(2*pi*fo*t)-sin(4*pi*fo*t);
    fmax=4*fo
end
% sampling and reconstruction
    fs=input('sampling frequency (for no aliasing choose it bigger than 2fmax)? ')
    % sampling frequency
    [y,y1,X,fx,Y,fy]=sampling(x,L,fs);
    figure(1)
    subplot(311)
    plot(t(1:150),x(1:150),'k')
    hold on
    plot(t(1:150),y1(1:150),'r')
    legend('Analog signal', 'Sampled signal')
    xlabel('t(sec)') 
    hold off
    subplot(312)
    plot(fx,X)
    axis([min(fx) max(fx) 0 1.1*max(X)])
    title('|X|'); grid
    subplot(313)
    plot(fy,Y)
    axis([min(fy) max(fy) 0 1.1*max(Y)])
    title('|Y|'); xlabel('f (Khz)'); grid
y=y(1:40);N=length(y);
    figure(2)
% sinc interpolation     
[t,xx,xr]= sincinterp(y,1/fs); 
    figure(2)
    subplot(212)
    plot(t(1:4000),xx(1:4000),'r'); hold on
    plot(t(1:4000),xr(1:4000),'k'); grid; hold off
