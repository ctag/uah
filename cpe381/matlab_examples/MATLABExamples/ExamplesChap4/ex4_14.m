%%
% Example 4.14
%
% Filtering of periodic signal
%%
clear all; clf
% Freq response of H(s)=1/(s/scale+1) -- low-pass filter
w0=2*pi;    % fundamental frequency of input
M=20; k=0:M-1; w1=k.*w0;   % harmonic frequencies
H=1./(1+j*w1/100);  Hm=abs(H); Ha=angle(H); % frequency response
figure(1)
subplot(211)
stem(w1,Hm,'filled'); grid; ylabel('|H(j\omega)|')
axis([0 max(w1) 0 1.3])
subplot(212)
stem(w1,Ha,'filled'); grid
axis([0 max(w1) -1 0])
ylabel('<H(j \omega)'); xlabel('w (rad/sec)')

% low-pass filtering
% FS coefficients of input
X(1)=0; % mean value
for k=2:M-1,
    X(k)=sin((k-1)*pi/2)/((k-1)*pi/2);
end
% periodic signal
Ts=0.001; t1=0:Ts:1-Ts;L=length(t1);
x1=[ones(1,L/4) zeros(1,L/2) ones(1,L/4)]; x1=x1-0.5; x=[x1 x1];
% output of filter 
t=0:Ts:2-Ts;
y=X(1)*ones(1,length(t))*Ha(1);
figure(2)
plot(t,y); axis([0 max(t) -.6 .6]); 
for k=2:M-1,
    y=y+X(k)*Hm(k)*cos(w0*(k-1).*t+Ha(k));
    plot(t,y); axis([0 max(t) -.6 .6]); hold on
    plot(t,x,'r'); axis([0 max(t) -0.6 0.6]); grid
    ylabel('x(t), y(t)'); xlabel('t (sec)') ; hold off
    pause(0.1)
end 
legend('y(t)','x(t)')
