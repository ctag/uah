function y=averager(M,x)
  % Moving average of signal x
  % Parameters
  % 	M: order of averager
  % 	x: input signal
  % USE
  %  	averager(M,x)
  % 
  b=(1/M)*ones(1,M);
  y=filter(b,1,x);
