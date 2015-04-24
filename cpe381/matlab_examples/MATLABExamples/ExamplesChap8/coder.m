function z1=coder(y,delta)
  %  Coder for 4-level quantizer
  %  input: y quantized signal from midriser
  %  output: z1 binary sequence
  %  USE z1=coder(y)
  % 
  z1='00';
  N=length(y);
  for n=1:N,
   y(n)
      if y(n)== delta
          z='01';
      elseif y(n)==0
          z='00';
      elseif y(n)== -delta
          z='11';
      else 
          z='10';
      end
      z1=[z1 z];
  end
  M=length(z1);
  z1=z1(3:M)