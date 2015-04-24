%%
% Example 12.7
%
% low-pass Butterworth
%%
alphamax=2; alphamin=9;                     % loss specifications
wp=0.47; ws=0.6;                            % passband and stop-band normalized frequencies
[N,wh]=buttord(wp, ws, alphamax, alphamin)  % min order, half-power freq
[b,a]=butter(N,wh)                          % coefficients of designed filter
[H,w]=freqz(b,a); w=w/pi; M=length(H);      % frequency response for normalized frequency
% specs verification
spec1 = alphamax* ones(1,M); spec2=alphamin* ones(1,M); % specs lines
hpf=3.01* ones(1,M);                        % half-power frequency line
disp('poles')                               % display poles
p=roots(a)
disp('zeros')                               % display zeros
z=roots(b)
alpha=-20*log10(abs(H));                    % loss in dB
Ha=unwrap(angle(H));
figure(1)
subplot(221)
zplane(b,a)
subplot(222)
plot(w,abs(H)); grid; axis([0 1 0 1.1*max(abs(H))]); ylabel('|H(e^{j\omega})|'); xlabel('\omega/\pi')
subplot(223)
plot(w,Ha);grid; ylabel('<H(e^{j\omega}) (rad)'); xlabel('\omega/\pi')
axis([0 1 1.1*min(Ha) 1.1*max(Ha)]);
subplot(224)
plot(w,alpha); ylabel('\alpha(e^{j\omega}) dB'); xlabel('\omega/\pi')
hold on
plot(w,hpf,'r--')
hold on
plot(w,spec1,'r--'); hold on
plot(w,spec2,'r--'); grid; hold off; axis([0 1 0 12])
