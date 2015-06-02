%%
% Example 4.18
%
% FS of triangular pulse using integration
%%
clf; clear all
w0=2*pi; N=100;  % parameters of periodic signal
% computation of mean value
DC=0;
for m=1:N,
  DC=DC+2*(-1)^(m)*(cos(pi*m)-1)/(pi*m)^2;
end
% computation of Fourier series coefficients
Ts=0.001; t=0:Ts:2-Ts;
for k=1:N,
    X(k)=(-1)^(k+1)*(cos(pi*k)-1)/((pi*k)^2);
end
X=[DC X]; % Fourier series coefficients
xa=X(1)*ones(1,length(t));     
figure(1)
for k=2:N,
    xa=xa+2*abs(X(k))*cos(w0 *(k-1).*t+angle(X(k))); % approximate signal
end
plot(t,xa); xlabel('t (sec)'); ylabel('x_N(t)'); grid
axis([0 2 -0.1 1.1])