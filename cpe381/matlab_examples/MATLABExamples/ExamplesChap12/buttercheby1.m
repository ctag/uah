function [b,a,H,w]=buttercheby1(lp_order,wn,BC,type)
     %
     %  Design of frequency discriminating filters
     %  using Butterworh's method, the bilinear transformation and
     %  frequency transformations
     %
     %  lp_order : order of lowpass filter prototype
     %  wn : vector containing the cutoff normalized frequency(ies)
     %	(entries must be between 0 and 1)
     %  BC: Butterworth (0) or Chebyshev1 (1)
     %  type : type of filter desired
     %		1 = lowpass
     %		2 = highpass
     %		3 = bandpass
     %		4 = stopband
     %   [b,a] : numerator, denominator coefficients of designed filter
     %   [H,w] : frequency response, frequency range
     %  USE:
     %	[b,a] = butter_1(lp_order,wn,type)
     % 
     if BC==0; % Butterworth filter
         if type == 1
         [b,a]=butter(lp_order,wn);		% lowpas
         elseif type == 2
         [b,a]=butter(lp_order,wn,'high'); 	% highpass
         elseif type == 3
         [b,a]=butter(lp_order,wn);		% bandpass
         else
         [b,a]=butter(lp_order,wn,'stop'); % stopband
         end
     [H,w]=freqz(b,a,256); 
     else % Chebyshev1 filter
     R=0.01;
     if type == 1,
        [b,a]=cheby1(lp_order,R,wn);		    % lowpas
        elseif type == 2,
        [b,a]=cheby1(lp_order,R,wn,'high');  % highpass
        elseif type == 3,
        [b,a]=cheby1(lp_order,R,wn);		    % bandpass
        else
        [b,a]=cheby1(lp_order,R,wn,'stop');  % stopband
     end
     [H,w]=freqz(b,a,256);
     end
