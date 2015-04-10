% % Soft Introduction to Matlab
% % Symbolic Computations
% %********   Derivatives and Differences *********************************
% %************************************************************************
disp('********   Derivatives and Differences *******')
clf; clear all
 % symbolic
   syms t y z				    % define the symbolic variables
   y=cos(t^2)				    % chirp signal -- notice no . before ^ since 
                                % t is no vector
   z=diff(y)					% derivative
   figure(1)
   subplot(211)
   ezplot(y,[0,2*pi]);grid		% plotting for symbolic y between 0 and 2*pi
   hold on
   subplot(212)
   ezplot(z,[0,2*pi]);grid
   hold on
  %numeric
   Ts=0.1;						% sampling period
   t1=0:Ts:2*pi;					% sampled time
   y1=cos(t1.^2);				% sampled signal --notice difference with y above
   z1=diff(y1)./diff(t1);		% difference  -- approximation to derivative
   figure(1)
   subplot(211)
   stem(t1,y1,'r');axis([0 2*pi 1.1*min(y1) 1.1*max(y1)])
   subplot(212)
   stem(t1(1:length(y1)-1),z1,'r');axis([0 2*pi 1.1*min(z1) 1.1*max(z1)])
   legend('Derivative (blue)','Difference (red)')
   hold off
   
pause   
% ******** The sinc function and integration*******************************
disp('******** The sinc function and integration*******')
clf; clear all
% symbolic
  syms t z
  for k=1:10,
      z=int(sinc(t)^2,t,0,k);   % integral of sinc^2 from 0 to k
      zz(k)=subs(2*z);          % substitution to numeric value zz
  end
% numeric
  t1=linspace(-4, 4);       % 100 equally spaced points in [-4,4]
  y=sinc(t1).^2;            % numeric definition of the squared sinc function
  
  n=1:10;
  figure(1)
  subplot(211)
  plot(t1,y);grid; title('y(t)=sinc^2(t)');
  xlabel('t')
  subplot(212)
  stem(n(1:10),zz(1:10)); hold on
  plot(n(1:10),zz(1:10),'r');grid;title('\int y(\tau) d\tau'); hold off
  
  
pause  
% ***************  Chebyshev polynomials **********************************
disp('************  Chebyshev polynomials ***********')
  clear all;clf
  syms x y t
  x=cos(2*pi*t);theta=0;
  figure(1)
  for k=1:4,
      y=cos(2*pi*k*t+theta);
     if k==1, subplot(221)
       elseif k==2, subplot(222)
       elseif k==3, subplot(223)
       else subplot(224)
     end
      ezplot(x,y);grid;hold on
  end
  hold off

pause

% ************* Lissajous figures *****************************************
disp('************* Lissajous figures **************')
clear all;clf
syms x y t
x=cos(2*pi*t); % input of unit amplitude and frequency 2*pi
A=1;figure(1)	% amplitude of output in case 1
for i=1:2,
for k=0:3,
    theta=k*pi/4; 	% phase of output
    y=A^k*cos(2*pi*t+theta);
   if k==0,subplot(221)
      elseif k==1,subplot(222)
      elseif k==2,subplot(223)
      else subplot(224)
   end
   ezplot(x,y);grid;hold on
end
A=0.5; figure(2) % amplitude of output in case 2
end

pause
% ************* Ramp, unit-step and impulse responses *********************
disp('******** Ramp, unit-step and impulse responses ********')
clear all; clf
syms y t x z
% input a unit-step  (heaviside) response
y=dsolve('D2y+5*Dy+6*y=heaviside(t)','y(0)=0','Dy(0)=0','t');
x=diff(y); % impulse response
z=int(y); % ramp response
figure(1)
subplot(311)
ezplot(y,[0,5]);title('Unit-step response')
subplot(312)
ezplot(x,[0,5]);title('Impulse response')
subplot(313)
ezplot(z,[0,5]);title('Ramp response')