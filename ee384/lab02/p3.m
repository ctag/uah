% Lab02 Problem 3

% 3.1
% Load and plot ECG data
% Change this to match your path
load('/home/berocs/Documents/uah/ee384/lab02/SAMPLE_ECG.mat');
n=1:2000;
figure;
subplot(2,1,1);
plot(n,ECG_Data);
axis([0 2000 100 220]);
title('Problem 3.1, RAW ECG');
xlabel('Time');
ylabel('Amplitude');

% 3.2 & 3.3
y=zeros(2000,1);
for index = n
    if index+2 > 2000
        break
    end
    y(index)=(ECG_Data(index)+ECG_Data(index+1)+ECG_Data(index+2))/3;
end
subplot(2,1,2);
plot(n,y);
axis([0 2000 100 220]);
title('Problem 3.2&3.3, FILTERED ECG');
xlabel('Time');
ylabel('Amplitude');

