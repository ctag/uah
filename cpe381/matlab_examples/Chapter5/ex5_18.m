% 
% Example 5.18
% Frequency response of bandpass, highpass or allpass filters
% 
clear all; clf
ind=input('bandpass (1), highpass (2) or allpass(3) ?   ')
if ind==1,
n=[0 1 0]; d=[1 1 1];
elseif ind==2,
n=[1 0 0]; d=[1 1 1];
else
n=[1 -2.5 1]; d=[1 2.5 1];
end
wmax=10;
[w,Hm,Ha]=freqresp_s(n,d,wmax);
figure(1)
subplot(221)
plot(w,Hm)
axis([0 wmax 0 1.1*max(Hm)])
ylabel('|H(j \omega)|')
grid
xlabel('\omega')
title(' Magnitude response')
subplot(222)
plot(w,Ha)
axis([0 wmax 1.1*min(Ha) 1.1*max(Ha)])
ylabel('< H(j \omega)')
xlabel('\omega')
title(' Phase response')
grid
subplot(223)
splane(n,d)
title('Poles/Zeros')
grid
