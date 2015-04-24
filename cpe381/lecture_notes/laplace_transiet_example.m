%-- From Laplace to Fourier --%
syms s t

tt=(1:20000)./1000; % 15 seconds @ 1000Hz

s1=cos(2*pi*2*tt);
s2=1+0.5*cos(2*pi*0.5*tt);

% 2Hz cosine wave
Y1=laplace(heaviside(t)+cos(2*pi*2*t)); % step + 
ilaplace(Y1/(s+1))    % RC low pass filter
y1=(cos(4*pi*tt) + 4*pi*sin(4*pi*tt))/(16*pi^2 + 1) - (exp(-tt)*(16*pi^2 + 2))/(16*pi^2 + 1) + 1;
% 
Y2=laplace(heaviside(t)+0.5*cos(2*pi*0.5*t))
ilaplace(Y2/(s+1))%
y2=(cos(pi*tt) + pi*sin(pi*tt))/(2*pi^2 + 2) - (exp(-tt)*(2*pi^2 + 3))/(2*pi^2 + 2) + 1;

subplot(211)
plot(tt,s2,tt,y2,'r')
subplot(212)
plot(tt,y1,tt,y2,'r')
