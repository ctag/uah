function [ dat ] = loadIQdat( file )
% loadIQdat
% This function will parse a dat file output by rtl_sdr
% The .dat file is unsigned, so we have to center the signal.

% Open file handle
fid=fopen(file,'rb');

% Convert to double
dat=fread(fid,'uint8=>double');

% .dat is unsigned 0-255, center signal
dat=dat-127.5;

% Combine Real and Imaginary elements
dat=dat(1:2:end) + (1i*dat(2:2:end));

end

