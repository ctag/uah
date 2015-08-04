% Process an IQ .dat file

% Input IQ data:
% Fs - 2048000, 2.048 MHz
% Center freq - 130800000, 130.800 MHz
% 
% Sample:
% 15 seconds
% 30720000 complex samples
% 
% DTMF
% 8kHz audio

% Get the data
raw_iq=loadIQdat('/home/berocs/Documents/uah/ee384/final/data/signal.dat');

% Setup some convenience variables
iq_fs=2048000;
iq_size=size(raw_iq);
iq_seconds=(iq_size(1)/iq_fs);

% Filter other radio stations
decim=decimate(raw_iq,16,'fir');

% Get demodulated signal
demod=FM_IQ_Demod(decim);

% Lower sampling rate to 8KHz
demod_8k=decimate(demod,16,'fir');

% Write the audio
wavwrite(demod_8k, 8000, '/home/berocs/Documents/uah/ee384/final/data/signal.wav');

% Get audio signal
[tone,fs]=wavread('/home/berocs/Documents/uah/ee384/final/data/signal.wav');

% Parse with dtmfeDecode
keys=dtmfeDecode(tone,fs);











