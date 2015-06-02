%%
% Example 7_7
%
% Filter design using analogfil
%%
clear all; clf
alphamax=0.1;
alphamin=60;
Wp=10;Ws=15;
Wmax=25;
ind=input(' Butterworth (1), Chevyshev (2), Chebyshev2 (3) Elliptic (4) LPF?   ')
if ind==1,
    disp('Butterworth LPF')
elseif ind==2,
    disp('Chebyshev LPF')
elseif ind==3,
    disp('Chebyshev2 LPF')
else
    disp('Chebyshev2 LPF')
end
[b,a]=analogfil(Wp,Ws,alphamax,alphamin,Wmax,ind);
