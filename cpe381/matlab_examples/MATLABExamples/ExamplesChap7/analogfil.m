function [b,a]=analogfil(Wp,Ws,alphamax,alphamin,Wmax,ind)
%
% Analog filter design
% Parameters
% Input: loss specifications (alphamax, alphamin), corresponding
%  frequencies (Wp,Ws), frequency range [0,Wmax] and indicator ind (1 for
%  Butterworth, 2 for Chebyshev1, 3 for Chebyshev2 and 4 for elliptic).
% Output: coefficients of designed filter.
% Function plots magnitude, phase responses, poles and zeros of filter, and 
%  verifies loss specifications
%
if ind==1,% Butterworth low-pass
    [N,Wn]=buttord(Wp,Ws,alphamax,alphamin, 's')
    [b,a]=butter(N,Wn,'s')
elseif ind==2, % Chebyshev low-pass
    [N,Wn]=cheb1ord(Wp,Ws,alphamax, alphamin,'s')
    [b,a]=cheby1(N,alphamax,Wn,'s')
elseif ind==3, % Chebyshev2 low-pass
    [N,Wn]=cheb2ord(Wp,Ws,alphamax, alphamin,'s')
    [b,a]=cheby2(N,alphamin,Wn,'s')
else % Elliptic low-pass
    [N,Wn]=ellipord(Wp,Ws,alphamax,alphamin,'s')
    [b,a]=ellip(N,alphamax,alphamin,Wn,'s')
end
W=0:0.001:Wmax; % frequency range for plotting
H=freqs(b,a,W);Hm=abs(H);Ha=unwrap(angle(H)); % magnitude (Hm) and phase (Ha)
N=length(W); alpha1=alphamax*ones(1,N); alpha2=alphamin*ones(1,N); % loss specs
subplot(221)
plot(W,Hm);grid;axis([0 Wmax 0 1.1*max(Hm)])
xlabel('\Omega');ylabel('|H(\Omega)|')
subplot(222)
plot(W,Ha);grid;axis([0 Wmax 1.1*min(Ha) 1.1*max(Ha)])
xlabel('\Omega');ylabel('<H(\Omega)')
subplot(223)
splane(b,a)
subplot(224)
plot(W,-20*log10(abs(H)))
hold on
plot(W,alpha1,'r',W,alpha2,'r');grid; axis([0 max(W) -0.1 100])
xlabel('\Omega');ylabel('<\alpha(\Omega)')

