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
% next button tone. In order to make the frequency detection more
% accurate, the tone slices of 0.05s will be stacked until silence
% is detected. Then the stacked tone is analyzed for frequencies.

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
cols=[1209 1336 1477]; % Frequencies from table
rows=[697 770 852 941]; % Frequencies from table
keys_list=[1 2 3; 4 5 6; 7 8 9; 11 10 12]; % Go backwards from frequency index to key
len=length(tone); % Length of input
keys_index=1; % Index for list of keys

% States
% 1 - Consuming silence
% 2 - Stacking tone chunks
state=2;

prev_sig=zeros(1,rd*fs);
prev_power=sum(prev_sig);
stacked_sig=zeros(1,len-1);

for section = 0:1:uint64(floor( ( (len)/fs )/rd )-1)
    % Extract 0.05s chunk of signal
    this_sig=tone( ((section*fs)*rd)+1 : ((section+1)*fs)*rd );
    
    % Get the power spectrum of this chunk
    [p_vals,p_sig]=freqSpec_1s(this_sig,fs);
    
    % Get a rough overall magnitude for comparison
    p_power=sum(abs(p_sig));
    
    % State 1
    if state == 1
        % Check for start of new tone
        if p_power > (prev_power*1.3)
            stacked_sig=zeros(1,len-1);
            state=2;
        end
    elseif state == 2
        % Stack signal slices
        stacked_sig( ((section*fs)*rd)+1 : ((section+1)*fs)*rd ) = this_sig;
        
        % Check for end of this tone
        if p_power < (prev_power/1.3)
            state=1;
            
            % Get the rough power spectrum
            [stacked_vals,stacked_p]=powerSpec(stacked_sig,fs);
            %figure();
            %plot(stacked_vals,stacked_p);
            
            % Create subranges to match the frequencies we're looking for
            %max_col_index=find(stacked_vals>1109,1);
            %min_col_index=find(stacked_vals<1577,1);
            max_col_range=find(stacked_vals>1109 & stacked_vals<1577);
            max_row_range=find(stacked_vals>597 & stacked_vals<1041);
            
            % Get the maximum frequencies
            %[C_col,I_col]=max(stacked_p(min_col_index:max_col_index));
            [C_col,I_col]=max(stacked_p(max_col_range));
            [C_row,I_row]=max(stacked_p(max_row_range));
            
            %col_button_freq=floor(stacked_vals(I_col+min_col_index-1));
            col_button_freq=floor(stacked_vals(I_col+min(max_col_range)-1));
            row_button_freq=floor(stacked_vals(I_row+min(max_row_range)-1));
            
            % Get the keys_list indecies
            col_index=find(cols>(col_button_freq-10) & cols<(col_button_freq+10));
			row_index=find(rows>(row_button_freq-10) & rows<(row_button_freq+10));
            
            % Find the key value and append to list
            keys(keys_index)=keys_list(row_index,col_index);
            keys_index=keys_index+1;
        end
    end
    prev_power=p_power;
end

end





