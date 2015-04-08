%
% simulation of spread spectrum
%
clear all; clf
f0=input(' frequency of analog carrier (2,000 to 200,000)?  ')
sigma=input(' variance of additive noise (0 to 1)?   ')
%  message
m1=rand(1,12)>0.5; m1=(m1-0.5)*2;
m=zeros(1,100);
m(1:9:100)=m1;
h=ones(1,9);
m=filter(h,1,m);
% spreading code
c1=rand(1,25)>0.5; c1=(c1-0.5)*2;
c=zeros(1,100);
c(1:4:100)=c1;
h1=ones(1,4);
c=filter(h1,1,c);
Ts=0.0001;t=[0:99]*Ts;
s=m.*c;

figure(1)
subplot(311)
bar(t,m); axis([0 max(t) -1.2 1.2]); grid; ylabel('m(t)')
subplot(312)
bar(t,c); axis([0 max(t) -1.2 1.2]); grid; ylabel('c(t)')
subplot(313)
bar(t,s); axis([0 max(t) -1.2 1.2]); grid; ylabel('s(t)'); xlabel('t')

% spectrum of message and spread message
M=fftshift(abs(fft(m)));
S=fftshift(abs(fft(s)));
N=length(M); K=[0:N-1]; w=2*K*pi/N-pi; f=w/(2*pi*Ts);
figure(2)
subplot(211)
plot(f,M); grid; axis([min(f) max(f) 0 1.1*max(M)]); ylabel('M(f)')
subplot(212)
plot(f,S); grid; axis([min(f) max(f) 0 1.1*max(S)]); ylabel('S(f)');xlabel('f (Hz)')
% analog modulation
sa=s.*cos(2*pi*f0*t);
noise=sigma*randn(1,length(s));
SNR=10*log10(var(sa)/var(noise))
sa=sa+noise;
% analog demodulation
r=sa.*cos(2*pi*f0*t);
% despreading
ma=r.*c;
for k=1:length(ma);
if ma(k)>0
    m1(k)=1;
else
    m1(k)=-1;
end
end

figure(3)
subplot(411)
plot(t,sa); axis([0 max(t) 1.1*min(sa) 1.1*max(sa)]); grid; ylabel('s_a(t)')
subplot(412)
plot(t,r); axis([0 max(t) 1.1*min(r) 1.1*max(r)]); grid; ylabel('r(t)')
subplot(413)
plot(t,ma); axis([0 max(t) 1.1*min(ma) 1.1*max(ma)]); grid; ylabel('m_a(t)')
subplot(414)
bar(t,m1); axis([0 max(t) -1.2 1.2]);grid; ylabel('m_1(t)'); xlabel('t') 
error=sum(abs((m-m1)/2))/100
