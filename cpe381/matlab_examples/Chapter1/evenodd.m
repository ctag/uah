function [ye,yo]=evenodd(t,y)
% even/odd decomposition
% t: time
% y: analog signal
% ye, yo: even and odd components
% USE [ye,yo]=evenodd(t,y)
%
yr=reflect(t,y);
ye=0.5*(y+yr);
yo=0.5*(y-yr);

