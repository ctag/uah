%%
% Derivative and difference example 
%%
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
   t1=0:Ts:2*pi;				% sampled time
   y1=cos(t1.^2);				% sampled signal --notice difference with y above
   z1=diff(y1)./diff(t1);		% difference  -- approximation to derivative
   figure(1)
   subplot(211)
   stem(t1,y1,'k');axis([0 2*pi 1.1*min(y1) 1.1*max(y1)])
   subplot(212)
   stem(t1(1:length(y1)-1),z1,'k');axis([0 2*pi 1.1*min(z1) 1.1*max(z1)])
   legend('Derivative','Difference')
   hold off
