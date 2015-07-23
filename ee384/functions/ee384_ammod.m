function [ mod_signal ] = ee384_ammod( message, carrier )
% ee384_ammod is a function to compute the AM signal
% from a message signal transcribed to a carrier signal.
% Part of lab 08

mod_signal = message .* carrier;

end

