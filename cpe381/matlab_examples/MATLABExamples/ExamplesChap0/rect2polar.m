%%
% Rectangular--polar conversion
%%
z=8+j*3
v=9-j*2	
m=z+v
[theta,r]=cart2pol(real(m),imag(m));	% rectangular into polar form
disp(' magnitude of m');  r 			% display text in '  ' followed by r
disp(' phase of m');  theta  
[x,y]=pol2cart(theta,r)
