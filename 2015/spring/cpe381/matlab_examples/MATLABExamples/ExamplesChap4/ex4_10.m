%%
% Example 4.10 --- Simulation of Gibb's phenomenon             
%%
clf; clear all
w0=2*pi; DC=0; N=20;                        % parameters of periodic signal
% computation of Fourier series coefficients
for k=1:N,
X(k)=sin(k*pi/2)/(k*pi/2);
end
X=[DC X];                                   % Fourier series coefficients
% computation of periodic signal
Ts=0.001; t=0:Ts:1-Ts;
L=length(t); x=[ones(1,L/4) zeros(1,L/2) ones(1,L/4)]; x=2*(x-0.5);
% computation of approximate
figure(1)
xN=X(1)*ones(1,length(t));     
for k=2:N,
xN=xN+2*X(k)*cos(2*pi*(k-1).*t);            % approximate signal
plot(t,xN); axis([0  max(t) 1.1*min(xN) 1.1*max(xN)])
hold on; plot(t,x,'r')
ylabel('x(t), x_N(t)'); xlabel('t (sec)');grid
hold off
pause(0.2)
end
