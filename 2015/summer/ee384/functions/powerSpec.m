function [ p_vals, p_sig ] = powerSpec( signal, sfs )

t_len=length(signal); % number of samples
nfft=2^ceil(log2(t_len)); % number of FFT bins

p_vals=sfs*(0:nfft/2-1)/nfft; % Frequency range (positive only)
y1_f=(fft(signal,nfft)); % Two sided, zero centered FFT
Py1=y1_f.*conj(y1_f)/(nfft*t_len);
p_sig=Py1(1:nfft/2);

end

