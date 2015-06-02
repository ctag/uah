%
% Sampling, quantizing and coding
%
clear all; clf
% analog signal
t=0:0.01:1; x=4*sin(2*pi*t);

% sampled signal	
Ts=0.01; N=length(t); n=0:N-1;
xs=4*sin(2*pi*n*Ts);
figure(1)
subplot(221)
plot(t,x,'k'); axis([0 1 -4.5 4.5])
xlabel('t (sec)'); ylabel('x(t)'); grid
subplot(222)
stem(n,xs,'b'); axis([0 N-1 -4.5 4.5])
xlabel('n'); ylabel('x[n]'); grid

%quantized signal
Q=2;		% quantization levels is 2Q
[d,y,e]=quantizer(x,Q);
subplot(223)
plot(n,x,'k'); grid; hold on
stem(n,y,'r'); title('Quantized signal'); ylabel('x(t), quantized signal'); hold off
subplot(224)
stem(n,e,'g');axis([0 N-1 -0.1 1.5*max(e)]); ylabel('e[n]'); xlabel('n');grid  

% binary signal
z=coder(y,d)