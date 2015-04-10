function yr=reflect(y)
% reflection of signals
% t: time
% y: input signal
% yr: reflected signal
% USE yr=reflect(t,y)
% 10.6.03
yr=fliplr(y);
