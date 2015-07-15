function [ p_vals, p_sig ] = powerSpec( signal, sfs )



t_len=length(signal); % number of samples
nfft=2^ceil(log2(t_len)); % number of FFT bins

p_vals=sfs*(0:nfft/2-1)/nfft; % Frequency range (positive only)
y1_f=(fft(signal,nfft)); % Two sided, zero centered FFT
Py1=y1_f.*conj(y1_f)/(nfft*t_len);
p_sig=Py1(1:nfft/2);


% NFFT=1024;	 	 
% L=length(x);	 	 
% X=fftshift(fft(x,NFFT));	 	 
% Px=X.*conj(X)/(NFFT*L); %Power of each freq components	 	 
% fVals=fs*(-NFFT/2:NFFT/2-1)/NFFT;	 	 
% plot(fVals,10*log10(Px),'b');	 	 
% title('Power Spectral Density');	 	 
% xlabel('Frequency (Hz)')	 	 
% ylabel('Power');

% L=length(x);	 	 
% NFFT=1024;	 	 
% X=fft(x,NFFT);	 	 
% Px=X.*conj(X)/(NFFT*L); %Power of each freq components	 	 
% fVals=fs*(0:NFFT/2-1)/NFFT;	 	 
% plot(fVals,Px(1:NFFT/2),'b','LineSmoothing','on','LineWidth',1);	 	 
% title('One Sided Power Spectral Density');	 	 
% xlabel('Frequency (Hz)')	 	 
% ylabel('PSD');

end

