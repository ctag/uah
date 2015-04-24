%%
% Interactive graphing example
%%
clear all;  clf
f=input(' frequency in Hz  >>  ')       % input frequency of sinusoid
A=input(' amplitude (>0) >>   ')        % input amplitude of sinusoid
theta=input(' phase in degrees >>   ')	% input phase of sinusoid
omega=2*pi*f;                           % frequency in rad/sec
tmax=1/f;                               % one period of sinusoid
time=[ ];  n=0;                         % initialization of time and n
figure(1)                               % figure to display results
for t=0:tmax/36:tmax                    % loop from t=0 to tmax 36 times
   z=A*exp(j*(omega*t+theta*pi/180)); 	% phasor multiplied by exp(j*omega* t)
   x=real(z); y=imag(z);                %  projection on real/imaginary axes of phasor
   time=[time t];                       % time sequence
   subplot(121)                         % subplot 1 in figure 1
   compass(x,y);                        % plot of vector at each time 
   axis('square')                       % square axis
   subplot(122)                         % subplot 2 in figure 1
   plot(n*tmax/36,x,'*r')               % plot x point in red '*' symbol at each time
   axis('square');                      % square axis for plot
   axis([0 tmax -1.1*A  1.1*A]); grid 	% bounds of plot; grid on plot
   hold on                              % hold current plot
   if n==0                              % execute next statement when n is zero
   pause(1)                             % pause for 3 seconds
   else                                 % if n==0 not satisfied go next statement
   pause(0.1)
   end                                  % end of conditional execution
   n=n+1;                               % increment n by one
end                                     % end loop
hold off                                % dismiss hold on 