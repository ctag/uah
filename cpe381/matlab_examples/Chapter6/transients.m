%
% Transient Analysis
%
clf; clear all
syms s t

ind=input('first (1) or second (2) order system?    ')

if ind==1,
num=[0 1];
for RC=1:10,
    den=[RC 1];
    figure(1)
    subplot(211)
    splane(num,den);grid
    hold on
    vc=ilaplace(1/(RC*s^2+s))
    subplot(212)
    ezplot(vc,[0,50]); axis([0 50 0 1.2]); grid; xlabel('t'); ylabel('v_c(t)')
    hold on
    RC
    pause
end
    
else
  num=[0 0 1];
  for phi=0:0.1:1,
    den=[1 2*phi 1] 
    figure(2)
    subplot(221)
    splane(num,den)
    hold on
    vc=ilaplace(1/(s^3+2*phi*s^2+s)) 
    subplot(222)
    ezplot(vc,[0,50]); axis([0 50 -0.1 2.5]); grid; xlabel('t'); ylabel('v_c(t)'); title('\phi < 0.707')
    hold on
    if phi>=0.707
      subplot(223)
      ezplot(vc,[0,50]); axis([0 50 -0.1 1.2]); grid; xlabel('t'); ylabel('v_c(t)'); title('\phi >= 0.707')
      hold on
    else
    end
  pause
end
hold off


end
