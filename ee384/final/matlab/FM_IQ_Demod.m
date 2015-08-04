function [y_FM_demodulated] = FM_IQ_Demod(y) 
% FM_IQ_Demod
% This function demodualtes an FM signal. It is assumed that the FM signal
% is complex (i.e. an IQ signal) centered at DC and occupies less than 90%
% of total bandwidth. 

% Design filter / differentiator 
filter=firls(30,[0 .9],[0 1],'differentiator'); 

% Get the normalized signal?
diff=y./abs(y);

% Real portion of the signal 
rd=real(diff); 

% Imaginary portion of the signal.
id=imag(diff); 

% Detected signal 
y_FM_demodulated=(rd.*conv(id,filter,'same')-id.*conv(rd,filter,'same'))./(rd.^2+id.^2); 

end