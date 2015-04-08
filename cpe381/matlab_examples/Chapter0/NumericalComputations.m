
% Soft Introduction to Matlab
% Numerical Computations

%********   CREATING VECTORS AND MATRICES *******************************
%************************************************************************
 clear all                % clear all variables
 clf	                  % clear all figures
display ('************ row and column vectors ******************')
% row and column vectors
 x=[ 1 2 3 4]	          % row vector
 y=x'                     % column vector
 
 pause
 display('how to check the dimensions of these vectors?')
 pause
 display('********** "whos" ********')
 pause
% To see the dimension use
 whos
 
 pause
 display('Another way to express the column vector:[. ; . ;  .]')
% Another way to express the column vector y
 y=[1;2;3;4] 
 
pause
display('what is the first entry if this vector?')
pause
% First entry of vector y
y(1)

display('what if we type y(0)?')
% y(0)
% Matlab indicates
% index must either be real positive integers or logicals
pause
display('ERROR: Subscript indices must either be real positive integers or logicals!!')

pause

display(' First to third entries of column vector y')
pause
% First to third entry of column vector y
y(1:3)

pause
display('Third  to first entry in the row vector x')
pause
% third to first entry in the row vector x
x(3:-1:1)
pause

display('matrix A with rows [1 2], [3 4] and [5 6]')
% Matrices are constructed as concatenation of rows (or columns)
A=[ 1 2; 3 4; 5 6]    % matrix A with rows [1 2], [3 4] and [5 6]

pause
display('***** Different approaches to create a vector *******')
pause
display('vector with entries 0 to 10 increased by 1, n=1:10')

% Different approaches to create a vector corresponding to a sequence of
% numbers
n=0:10     % vector with entries 0 to 10 increased by 1
display('n =[0:10] command returns the same with the above one')
% or
n=[0:10]

pause
display('vector with entries from 0 to 10 increased by 2')
pause
n1=0:2:10  % vector with entries from 0 to 10 increased by 2

pause
display('combination of these vectors: nn1')
nn1=[n n1]    % combination of vectors

pause

display('***********  VECTORIAL OPERATIONS  ******************')
%********   VECTORIAL OPERATIONS   ****************************************
%**************************************************************************
pause
display('multiplication by a constant: z=3x')
display('x=[1 2 3 4]')
% multiplication by a constant
z=3*x   
pause
display('multiplication of entries of two vectors x and x = elementwise!')
% multiplication of entries of two vectors
v=x.*x
pause
display(' multiplication of row vector x by column vector tranpose(x)')
% multiplication of x (row vector) by x'(column vector)
w=x*x' 
pause

display('*********** Solution of linear set of equations Ax=b ********')
% Solution of linear set of equations Ax=b
pause
display('lets say A is 3by3 matrix')
A=[1 0 0; 2 2 0;3 3 3]         % 3x3 matrix
pause

display('determinant A?')
pause
t=det(A)                     	% MATLAB function that calculates determinant
pause

display('...and b is a column vector')
b=[2 2 2]'        				% column vector
pause

display('if Ax=b, what is x?')
pause
x=inv(A)*b     				% MATLAB function that inverts a matrix
display('inv() command inverts a matrix')
pause

display('>>>>>>>>> Display <<<<<<<<<<<<<<<<<<')
display('MATLAB function that displays the text in command window')
% MATLAB function that displays the text in ' '
pause
disp(' Ax=b')	

pause

display('Another way to solve linear set of equations: x=b^T/A^T')
% Another way to solve this set of equations is
x=b'/A'
pause

display('************* special vectors and matrices **********************')
pause
display('**** ones ****')
 % special vectors and matrices
    x=ones(1,10)                % row of ten 1s
pause
    A=ones(5,5)                 % matrix of 5x5 1s
pause
display('**** zeros ****')
    x1=[x zeros(1,5)]           % vector with previous x and 5 0s
pause
    A(2:5,2:5)=zeros(4,4)       % zeros in rows 2-5, columns 2-5
pause
display('******* samples from Uniform pdf ****************')
    y=rand(1,10)                % row vector with 10 random values (uniformly
                                % distributed in [0,1]
pause
display('******** samples from Gaussian pdf ****************')
    y1=randn(1,10) 			    % row vector with 10 random values
                                % (Gaussian distribution)
pause                                

display('********** Using BUILT-IN FUNCTIONS ******************************')
% ********** Using Built-in Functions *************************************
% *************************************************************************
display('MATLAB provides a large number of built-in functions. The following script uses some of them: cos,plot,stem,,sound etc. ')
pause
display('plot the function x=cos(2*pi*t/0.1)')
pause
% using built-in functions
    t=0:0.01:1;    % time vector from 0 to 1 with interval of 0.01
    x=cos(2*pi*t/0.1);   	% cos processes each of the entries in
       						% vector t to get the corresponding value in vector x
    % plotting the function x
    figure(1)   % numbers the figure
    plot(t,x)   % interpolated continuous plot
    xlabel('t (sec)')   % label of x-axis
    ylabel('x(t)')      % label of y-axis
    pause
    display('lets hear it : sound ()')
     % let's hear it
    %sound(1000*x,10000)

 pause
 display('>>>> create a CHIRP <<<<<<')
% create a chirp which is a sinusoid for which the frequency is varying with time
    y=sin(2*pi*t.^2/.1);    % notice the dot in the squaring
                                     % t was defined before
                                     display(' y=sin(2*pi*t.^2/.1)')
    %sound(1000*y,10000) 	% to listen to the sinusoid
    figure(2)			    % numbering of the figure
pause
display('plot the chirp y')
    plot(t(1:100),y(1:100)) % plotting of 100 values of y
pause
display('plotting x(sinusoid) and y(chirp)on same plot')
    figure(3)
    plot(t(1:100),x(1:100),'k',t(1:100),y(1:100),'r') % plotting x and y on same plot
pause

display('Other built-in functions are...')
display('sin, tan, acos, asin, atan, atan2, log, log10, exp, etc.')

display('Find out what each does using "help" and obtain a listing of all the functions in the signal processing toolbox.')

pause
display('////////////   pi and j /////////////////')
% pi and j
 pi = pi
 j = j
 i = i
 
pause

display('*********** Creating your Own Functions ***********************')
%********** Creating your Own Functions ***********************************
%**************************************************************************
pause
display('!check out f.m file to see how the function "f= y=x*exp(-sin(x))/(1+x^2" is built')
display('y=f(2)')
% !check out the function f.m file to see how it is built

%% The following file is for a function  f with input a scalar x and
%% output the scalar y related by a mathematical function:
 %% function y=f(x)
 %%    y=x*exp(-sin(x))/(1+x^2)

y = f(2)

pause

display('To compute the value of the function for a vector as input:x=0:0.1:100; ')
pause
display('find y=f(x) and plot')
%To compute the value of the function for a vector as input
x=0:0.1:100;                % create an input vector x
N=length(x);                % find the length of x
y=zeros(1,N);               % initialize the output y to zeros
    for n=1:N,              % for the variable n from 1 to N, compute
        y(n)=f(x(n));       % the function
    end
figure(3)
plot(x,y)
grid                        % put a grid on the figure
title('Function f(x)')	
xlabel('x')	
ylabel('y')	

pause

%  !check out the ff.m file for to see how function "ff" is built

%% function yy=ff(x)		
%%        % vectorial function
%%        yy=x.*exp(-sin(x))./(1+x);

 pause
 display('NOTE: When we use a function, the names of the variables used in the script')
  display('that calls the function do not need to coincide with the ones in the definition of the function')
 % When we use a function, the names of the variables used in the script
 % that calls the function do not need to coincide with the ones in the 
 % definition of the function ---consider the following script:   
 pause
 
 display('Another function: ff')
 pause
 display('compute z=ff(x) and plot z vs x')
 z=ff(x);     % x defined before,
              % z instead of yy is the output of the function ff
 figure(4)
 plot(x,z); grid
 title('Function ff(x)') % MATLAB function that puts title in plot
 xlabel('x') % MATLAB function to label x-axis
 ylabel('z')  % MATLAB function to label y-axis
 pause
 
 display('****** Difference between "plot" and "stem" *********')
 % Difference between "plot" and "stem"
 pause
 display('stem(x(1:30),z(1:30))')
 stem(x(1:30),z(1:30))
 grid
 title('Function ff(x)')
 xlabel('x')
 ylabel('z')
 
 pause
 display('$$$$$$$$$  More on Plotting  $$$$$$$$$$$$$')
 pause
% ************ More on Plotting *******************************************
% *************************************************************************
display('plot 4figures in one plot!')
 subplot(221)
 plot(x,y)
 subplot(222)
 plot(x,z)
 subplot(223)
 stem(x,y)
 subplot(224)
 stem(x,z)
 
 pause
 
 %modification of the above code
 subplot(221)
 plot(x,y)
 axis([0 100 0 3])
 subplot(222)
 plot(x,z)
 axis([0 100 0 3])
 subplot(223)
 stem(x,y)
 axis([0 100 0 3])
 subplot(224)
 stem(x,z)
 axis([0 100 0 3])
 
 display('$$$$$$$$$ Saving and Loading Data $$$$$$$$$$$$$')
% ************ Saving and Loading Data ************************************
% *************************************************************************
pause
display('generate a vector with 2 columns and save it')
 x=0:3:360;
 y=sin(x*pi/180);    % sine computes the argument in radians
 xy=[x' y'];         % vector with 2 columns one for x'
                     % and  another for y'
 save sine.mat xy
 pause
 display('!!!Check your current folder to see the saved sine.mat file')
 pause
 
 display('...first clear workspace')
 clear all
 
 pause
 display('...then load this)')
 load sine
 
 pause
 display('you know how to check its size now...')
 whos            %to check its size
 
 pause
 display('Verify this and plot the values ')
 %Verify this and plot the values by using
  x=xy(:,1);
  y=xy(:,2);
  stem(x,y)
 
 pause
 
 display('(((((  close all figures for visual peace )))))')
 close all
 pause
 
 display('>>>>>>>>> Using Matlab data files  <<<<<<<<<<<<<<<')

% ************ Using Matlab data files ************************************
% *************************************************************************
pause
display('load recording of a train whistle, which accompanies the sampled signal y(n) ')
% recording of a train whistle, sampled at the rate of Fs samples/second,
% which accompanies the sampled signal y(n)
 clear all
 load train
 whos
 pause
 display('plot y')
 %sound(y,Fs)
 figure(2)
 plot(y)
 
pause

display('MATLAB also provides two-dimensional signals, or images, such as...')
% MATLAB also provides two-dimensional signals, or images, such as...
clear all
load clown
whos
pause
display('display in gray')
% display in gray
colormap('gray')
imagesc(X)
pause
display('or display in color')

%or display in color
colormap('hot')
imagesc(X) 

 