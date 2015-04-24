function [ye,yo]=evenodd(y)
% even/odd decomposition
% NOTE: the support of the signal should be
%       symmetric about the origin
% y: analog signal
% ye, yo: even and odd components
% USE [ye,yo]=evenodd(y)
% 1.2.04
yr=reflect(y);
ye=0.5*(y+yr);
yo=0.5*(y-yr);

