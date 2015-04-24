%%
% Computing and saving angles and corresponding sine values
%%
theta=0:3:360; % angles from 0 to 360 degrees in intervals of 3 degrees
thetay=sintable(theta);
save sine.mat thetay
%% loading and plotting sine table 
load sine
figure(1)
plot(thetay(:,1),thetay(:,2))
axis([0 360 -1.1 1.1 ])
xlabel('\theta (degrees)');ylabel('sin(\theta)')