%
%  Simulation of sampling and reconstruction
% 
clf; clear all 
    fsim=20000;Tsim=1/fsim;         % analog simulation 
    C=1; L=floor(C/Tsim);                   % L samples from 0 to C
    t=0:Tsim:C-Tsim;
ind=input(' example 1, 2 or 3? ');
if ind==1,

fo=500; x=2-cos(2*pi*(fo/2)*t)-1*sin(2*pi*fo.*t);
    elseif ind==2,
 fo=1000; x=cos(2*pi*fo*t);
    else
    fo=500; x=1-cos(2*pi*fo/2.*t.^2)-5*sin(2*pi*fo.*t);
end
 % no aliasing
    fs=6000;						% sampling frequency >> fo
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
 %   sinc interpolation     
[t,xx,xr]= sincinterp(y,1/fs); 
figure(2)
     subplot(212)
      plot(t(1:4000),xx(1:4000),'r'); hold on
      plot(t(1:4000),xr(1:4000),'k'); grid; hold off

      % aliasing

    fs=800;                          % sampling frequency << fo
    
    [y,y1,X,fx,Y,fy]=sampling(x,L,fs);
    figure(3)
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
    figure(4)
    %sinc interpolation
    [t,xx,xr]= sincinterp(y,1/fs);
    figure(4) 
    subplot(212)
      plot(t(1:4000),xx(1:4000),'r'); hold on
      plot(t(1:4000),xr(1:4000),'k'); grid; hold off