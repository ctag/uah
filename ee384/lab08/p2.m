% Lab 08 - Problem 2
% EE384
% Christopher Bero

%P2.a
%uiopen('/home/berocs/Documents/uah/ee384/lab08/corrupted.wav',1);
% data and fs should now be available
[bins, data_resp]=freqSpec_1s(data, fs);

fig2=figure();
subplot(2,1,1);
plot(bins,abs(data_resp));
title('P2.a Corrupt Signal Response');
xlabel('Frequency');
ylabel('Response Magnitude');
% Bad frequencies around 3000Hz

%P2.b
bandpass=p2_filter();
clean_data=filter(bandpass, data);
[c_bins, clean_resp]=freqSpec_1s(clean_data, fs);

subplot(2,1,2);
plot(c_bins,abs(clean_resp));
title('P2.b Cleaned Signal Response');
xlabel('Frequency');
ylabel('Response Magnitude');

% Says: "Testing: one, two, three."






