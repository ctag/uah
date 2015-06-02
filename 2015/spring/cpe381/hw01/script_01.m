% HW1 - Problem 1
% Christopher Bero
% CPE 381

% Store 80 Minutes
store_minutes = 80;
seconds_per_minute = 60;


% a)
sample_hz = 8000;
bits_sample = 8;
space_a = sample_hz*bits_sample*store_minutes*seconds_per_minute;

% b)
sample_hz = 44100; % 44.1K Hz sampling frequency
bits_sample = 8; % 8 bits per sample
tracks = 2; % stereo
space_b = sample_hz*bits_sample*tracks*store_minutes*seconds_per_minute;

% c)
space_c = (space_b / 20.0);

% d)
video = (640 * 480);
colors = 3;
bits_color = 8;
sample_hz = 30;
space_d = (video*colors*bits_color*sample_hz*seconds_per_minute*store_minutes);












