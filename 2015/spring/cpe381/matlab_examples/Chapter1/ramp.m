function y=ramp(t,m,ad)
% ramp generation
% t: time support
% m: slope of ramp
% ad : advance (positive), delay (negative) factor
% USE: y=ramp(t,m,ad)
N=length(t);
y=zeros(1,N);
for i=1:N,
    if t(i)>=-ad,
    y(i)=m*(t(i)+ad);
    end
end
