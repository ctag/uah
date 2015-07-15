function [ keys ] = dtmfdecode( tone, fs )
% dtmfdecode - Receiving end for dtmfdial()
% input - 1x? audio matrix, sampling frequency
% output - 1x? matrix of key values 

% This function could be built to take 0.6 second chunks at a time
% since we know where the audio is coming from.
% I'm going to try to make it more robust though, so that the audio
% can be shifted in the incoming signal.
% To do this, I plan to check 0.05 second chunks since the smallest
% audio (silence) is 0.1s. So we're employing Nyquist's Frequency 
% to make sure that the silence is noticed. Then we'll parse the 
% incoming signal by using silence as a cue to move on to the 
% next button tone.

% DTMF
%  ___________________________
% | Freq | 1209 | 1336 | 1477 |
% |  697 |   1  |  2   |  3   |
% |  770 |   4  |  5   |  6   |
% |  852 |   7  |  8   |  9   |
% |  941 | *(11)| 0(10)| #(12)|
% |______|______|______|______|

% Variables
rd=0.05; % Reference duration
cols=[1209 1336 1477];
rows=[697 770 852 941];
keys_list=[1 2 3; 4 5 6; 7 8 9; 11 10 12];
len=length(tone);
keys_index=1;
%keys=[];
prev_f=0;



% States
% 1 - Consuming silence
% 2 - Stacking tone chunks
state=2;

prev_sig=zeros(1,rd*fs);
prev_power=sum(prev_sig);
stacked_sig=zeros(1,len-1);

for section = 0:1:uint16(floor( ( (len)/fs )/rd )-1)
    this_sig=tone( ((section*fs)*rd)+1 : ((section+1)*fs)*rd );
    [p_vals,p_sig]=powerSpec(this_sig,fs);
    %plot(p_vals,p_sig);
    %hold on;
    stacked_sig( ((section*fs)*rd)+1 : ((section+1)*fs)*rd ) = this_sig;
    p_power=sum(abs(p_sig));
    
    % State 1
    if state == 1
		stacked_sig=zeros(1,len-1);
		if p_power > (prev_power*3)
			%disp('Found signal');
			state=2;
		end
		
	end
    
    % State 2
    if state == 2
        if p_power < (prev_power/3)
            %disp('Found silence');
            state=1;
            
            [stacked_vals,stacked_p]=powerSpec(stacked_sig,fs);
            max_col_range=find(stacked_vals>1109&stacked_vals<1577);
            max_row_range=find(stacked_vals>597&stacked_vals<1041);
            [C,I]=max(stacked_p(max_col_range));
            col_button_freq=floor(stacked_vals(I+(min(max_col_range)-1)));
            [C,I]=max(stacked_p(max_row_range));
            row_button_freq=floor(stacked_vals(I+min(max_row_range)-1));
            
            col_index=find(cols>(col_button_freq-10) & cols<(col_button_freq+10)); %mod((button-1),3)+1;
			row_index=find(rows>(row_button_freq-10) & rows<(row_button_freq+10)); %int8(ceil(button/3));
            keys(keys_index)=keys_list(row_index,col_index);
            keys_index=keys_index+1;
        else
			
        end
    end
    
    prev_power=p_power;
end



end





