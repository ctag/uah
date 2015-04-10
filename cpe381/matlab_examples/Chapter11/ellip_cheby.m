%
% Elliptic and Cheby2 filters
%
clear all; clf
ind=input('elliptic bpf (1) or cheby2 hpf (2)?  ')
if ind==1,
[b1,a1]=ellip(10,0.1,40,[0.45 0.55]);
else
[b1,a1]=cheby2(10,40, 0.55,'high');
end
[H1,w]=freqz(b1,a1);
figure(1)
subplot(221)
zplane(b1,a1)
mag=abs(H1);
phase=unwrap(angle(H1));
subplot(222)
plot(w/pi,mag)
axis([0 1 -0.1 1.1*max(mag)])
ylabel('Magnitude')
xlabel('w/pi')
grid
thres=3*ones(1,length(w));
thres2=40*ones(1,length(w));
subplot(223)
plot(w/pi,-20*log10(mag),w/pi,thres,'r'); axis([0 1 -10  100])
hold on
plot(w/pi,thres2,'r')
hold off
ylabel('Loss(dB)'); xlabel('w/pi'); grid
subplot(224)
plot(w/pi,phase)
axis([0 1 1.1*min(phase) 1.1*max(phase)])
ylabel('Phase (rad)')
xlabel('w/pi')
grid

