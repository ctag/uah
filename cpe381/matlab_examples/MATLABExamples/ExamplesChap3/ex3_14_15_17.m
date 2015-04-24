%%
% Examples 3.14, 3.15 and 3.17
%
% Inverse Laplace transform of 
% example 3.14: X(s)=(2s+3)/(s^2+2s+4) 
% example 3.15: X(s)=4/(s^3+4s^2+4s)
% example 3.17: X(s)=(3s^2+2s-5)/(s^3+6s^2+11s+6) 
%
% To get results in each of the three examples, input the number of the 
% example
%%
clear all; clf
number=input(' example 3.(14,15 or 17?)  ')
syms s t w
% numerators and denominators
if number==14,
     num=[0 2 3]; den=[1 2 4]; % example 3.14
    elseif number==15,
   num=[0 0 0 4]; den=[1 4 4 0]; % example 3.15

else
    num=[0 3 2 -5]; den=[1 6 11 6]; % example  3.17
end

figure(1)
subplot(121)
pfeLaplace(num,den);

% inverse Laplace
disp('>>>>> Inverse Laplace <<<<<')

if number==14,  
    x=ilaplace((2*s+3)/(s^2+2*s+4)) % example 3.14
elseif number==15,
    x=ilaplace( 4/(s^3+4*s^2+4*s)); % example 3.15
else
    x=ilaplace((3*s^2+2*s-5)/(s^3+6*s^2+11*s+6)) % example  3.16
end
  subplot(122)
  ezplot(x,[0,12]); title('x(t)')
  axis([0 12 -1 4]); grid