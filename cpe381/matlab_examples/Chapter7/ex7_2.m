%
% Example 7.2
%
% Parseval's relation and sampling
%
syms W 
for k=1:24;
    E(k)=simplify(int((sin(0.5*W)/(0.5*W))^2,W,0.0001,k*pi)/pi);
    e(k)=single(subs(E(k)))
end
stem(e) 
hold on
EE=0.9900*ones(1,24);
plot(EE,'r')
hold off
axis([1 24 0.98 1]); grid; xlabel('\Omega/\pi'); ylabel('Power')