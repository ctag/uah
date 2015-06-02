function [b]=fir(N,wc,wo,wind)	
%  
% FIR filter design using window method and
% frequency modulation
%
%  N : order of the FIR filter
%  wc : normalized cutoff frequency (between 0 and 1)
% 	of low-pass prototype
%  wo : normalized center frequency (between 0 and 1)
%	of highpass, bandpass filters
%  wind : type of window function 
%		1 : rectangular
%		2 : hanning
% 		3 : hamming
%		4 : kaiser
%  [b] : coefficients of designed filter
%
%  USE:
%	[b]=fir(N,wc,wo,wind)	
% 
n=0:N;
if wind ==1
window=boxcar(N+1);
disp(' ***** RECTANGULAR WINDOW  *****') 
elseif wind ==2
window=hanning(N+1);
disp(' *****HANNING WINDOW *****')
elseif wind == 3
window=hamming(N+1);
disp(' *****   HAMMING WINDOW *****')
else
window=kaiser(N+1,4.55);
disp(' *****   KAISER WINDOW *****')
end
% calculation of ideal impulse response
den=pi*(n-N/2);
num=sin(wc*den);
% if N even, this prevents 0/0
if fix(N/2)==N/2,
num(N/2+1)=wc;
den(N/2+1)=1;
end
b=(num./den).*window';
% frequency shifting
[H,w]=freqz(b,1,256); %% low-pass 
if wo>0 & wo<1,
b=2*b.*cos(wo*pi*(n-N/2))/H(1);   
elseif wo==0,
    b=b/abs(H(1));
elseif wo==1;
    b=b.*cos(wo*pi*(n-N/2));
end



