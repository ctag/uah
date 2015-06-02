function xy= sintable(theta)
% This function generates sine values of input theta
% theta: angle in degrees, converted into radians
% xy: array with values for theta and y    
y=sin(theta*pi/180);		% sine computes the argument in radians
xy=[theta' y'];  			% array with 2 columns: theta' and y'