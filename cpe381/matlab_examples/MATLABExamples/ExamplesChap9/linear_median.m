%%
% Linear vs median filtering
%%
clear all; clf
N=200;n=0:N-1;
% impulsive noise
for m=1:N,
  d=rand(1,1);
  if d>=0.95,
      noise(m)=-1.5;
   else
      noise(m)=0 ;
   end
end
x=[2*cos(pi*n(1:100)/256) zeros(1,100)]; % clean signal
y1=x+noise; % noisy signal

% linear filtering
z2=averager(15,y1);

% nonlinear filtering
z1(1)=median([0 0 y1(1) y1(2) y1(3)]);
z1(2)=median([0 y1(1) y1(2) y1(3) y1(4)]);
z1(N-1)=median([y1(N-3) y1(N-2) y1(N-1) y1(N) 0]);
z1(N)=median([y1(N-2) y1(N-1) y1(N) 0 0]);
for k=3:N-2,
 z1(k)=median([y1(k-2) y1(k-1) y1(k) y1(k+1) y1(k+2)]);
end

figure(1)
subplot(211)
plot(n,y1); hold on;plot(n,x,'k-.'); hold off; axis([0 200 -2 2]); ylabel('x[n]. y[n]')
legend('noisy signal','clean signal'); grid
subplot(223)
plot(n,z1,'r'); hold on;plot(n,x,'k-.'); hold off; axis([0 200 -2 2]); ylabel('x[n], z_1[n]')
legend('denoised signal','clean signal'); grid; title('Median filtering')
subplot(224)
plot(n,z2,'r'); hold on; plot(n,x,'k-.'); hold off; axis([0 200 -2 2]); ylabel('x[n], z_2[n]')
legend('denoised signal','clean signal'); grid; title('Linear filtering')
