%%
% Example 7_6
%
% Frequency transformations
%%
clear all;clf 
syms w W
N=5;
[b,a]=butter(N,1,'s') % low-pass prototype
omega0=40;BW=10
n=N:-1:0;
% low-pass to low-pass
U=(j*w).^n;
num=b*conj(U');
den=a*conj(U');
H=num/den;
figure(1)
subplot(221)
ezplot(abs(H),[0:10]); axis([0 10 -0.1 1.2]);grid;
title('LPF');xlabel('\Omega');ylabel('|H(j\Omega)|')
% low-pass to high-pass
U1=(omega0/(j*w)).^n;
num1=b*conj(U1');
den1=a*conj(U1');
H1=num1/den1;
subplot(222)
ezplot(abs(H1),[0:60]);axis([0 60 -0.1 1.2]);grid;
title('HPF');xlabel('\Omega');ylabel('|H_1(j\Omega)|')
% low-pass to band-pass
U2=((-w^2+omega0)/(BW*j*w)).^n;
num2=b*conj(U2');
den2=a*conj(U2');
H2=num2/den2;
subplot(223)
ezplot(abs(H2),[0:40]);axis([0 40 -0.1 1.2]);grid;
title('BPF');xlabel('\Omega');ylabel('|H_2(j\Omega)|')
% low-pass to band-eliminating
U3=((BW*j*w)/(-w^2+omega0)).^n;
num3=b*conj(U3');
den3=a*conj(U3');
H3=num3/den3;
subplot(224)
ezplot(abs(H3),[0:40]);axis([0 40 -0.1 1.2]);grid;
title('BEF');xlabel('\Omega');ylabel('|H_3(j\Omega)|')

