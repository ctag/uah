function [ message ] = ee384_amdemod( mod_signal, carrier, sfs, pass, stop )
% ee384_amdemod to demodulate an AM signal.

% Equiripple Lowpass filter designed using the FIRPM function.
% All frequency values are in Hz.
Fs = sfs;  % Sampling Frequency
Fpass = pass;              % Passband Frequency
Fstop = stop;              % Stopband Frequency
Dpass = 0.057501127785;  % Passband Ripple
Dstop = 0.0001;          % Stopband Attenuation
dens  = 20;              % Density Factor

% Calculate the order from the parameters using FIRPMORD.
[N, Fo, Ao, W] = firpmord([Fpass, Fstop]/(Fs/2), [1 0], [Dpass, Dstop]);

% Calculate the coefficients using the FIRPM function.
b  = firpm(N, Fo, Ao, W, {dens});
Hd = dfilt.dffir(b);

message = filter(Hd, (2*carrier.*mod_signal));

end

