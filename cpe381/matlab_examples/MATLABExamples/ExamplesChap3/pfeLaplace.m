function pfeLaplace(num,den)
%
% function pfeLaplace
% Partial fraction expansion, zeros/poles, residues 
% plotting of poles/zeros (splane function)
% input: coefficients of numerator (num) and denominator (den) in
% decreasing order
% use pfeLaplace(num, den)
%
disp('>>>>>  Zeros <<<<<')
z=roots(num)
[r,p,k]=residue(num,den);
disp('>>>>>  Poles <<<<<')
p
disp('>>>>>  Residues <<<<<')
r
splane(num,den)

