%
% Example 6.4 -- Control toolbox
%
clear all; clf
ind=input('system (1) or (2)?   ')
if ind==1,
% H_1(s) 
nu=[1 1];de=[1 1 1];
else
% H_2(s)
nu=[1 0];de=[1 1 1 1]; %  unstable
end
h=response(nu,de,1);
s=response(nu,de,2);
r=response(nu,de,3);
