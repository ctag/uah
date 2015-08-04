function [ chars ] = dtmfeDecode( tone, fs )
% dtmfeDecode - Extract ASCII from audio
% input - 1x? audio matrix, sampling frequency
% output - 1x? matrix of chars

% From previous dtmf homework:
% I plan to check 0.05 second chunks since the smallest
% audio (silence) is 0.1s. So we're employing Nyquist's Frequency 
% to make sure that the silence is noticed. Then we'll parse the 
% incoming signal by using silence as a cue to move on to the 
% next button tone. In order to make the frequency detection more
% accurate, the tone slices of 0.05s will be stacked until silence
% is detected. Then the stacked tone is analyzed for frequencies.

% Specific to this file:
% Things left to do include:
% - Creating some graphical output of the signal during manipulation 
% and the text recovered
% - Implementing a more robust detection for silence between tones.
% I don't understand the derivation of power for a signal very well,
% and believe there are better ways to calculate it.
% - Perform a rough size estimation before detecting characters, and then
% initialize 'chars' with a reasonable guess at the # of chars.
% 

% Variables
rd=0.05; % Reference duration
cols=[1209 1336 1477 1633 1805 1994 2201 2427 2672 2938 3226 3537]; % Column frequencies
rows=[697  770  852  941  1035 1132 1230 1307 1421 1510 1592 1665]; % Row frequencies
len=length(tone); % Length of input
chars_index=1; % Index for list of keys
prev_sig=zeros(1,rd*fs); % Holds the audio for the precious rd*fs chunk
prev_power=sum(prev_sig); % Holds the cumulative power of the previous chunk
stacked_sig=zeros(1,len-1); % Stacked sig holds all previous chunks for a given tone
% States
% 1 - Consuming silence
% 2 - Stacking tone chunks
state=2;
chars_list={
'1'     '2'     '3'     'A'     'R'     'S'     'r'     's'     '/'     'NUL'   'NA11'  'NA12';	
'4'     '5'     '6'     'B'     'Q'     'T'     'q'     't'     '.'     'SOH'   'NA10'  'NA13';
'7'     '8'     '9'     'C'     'P'     'U'     'p'     'u'     '-'     'STX'   'NA9'   'NA14';	
'*'     '0'     '#'     'D'     'O'     'V'     'o'     'v'     ','     'ETX'	'NA8'   'NA15';
'H'     'G'     'F'     'E'     'N'     'W'     'n'     'w'     '+'     'EOT'   'NA7'   'NA16';
'I'     'J'     'K'     'L'     'M'     'X'     'm'     'x'     ')'     'ENQ'	'NA6'   'NA17';
'd'     'c'     'b'     'a'     'Z'     'Y'     'l'     'y'     '('     'ACK'	'NA5'   'NA18';
'e'     'f'     'g'     'h'     'I'     'j'     'k'     'z'     ''''	'BEL'	'NA4'   'NA19';
'<'     ';'     ':'     'DEL'	'~'     '}'     '|'     '{'     '&'     'BS'	'NA3'   'NA20';
'='     '>'     '?'     '@'     'SPACE'	'!'     '“'     '$'     '%'     'TAB'	'NA2'   'NA21';
'DC3'   'DC2'	'DC1'	'DLE'	'SI'	'SO'	'CR'	'FF'	'VT'	'LF'	'NA1'   'NA22';
'DC4'	'NAK'	'SYN'	'ETB'	'CAN'	'EM'	'SUB'	'ESC'	'FS'	'RS'	'US'    'NA23';
}; % Go backwards from frequency index to key



for section = 0:1:uint64(floor( ( (len)/fs )/rd )-1)
    
    % Extract 0.05s chunk of signal
    this_sig=tone( ((section*fs)*rd)+1 : ((section+1)*fs)*rd );
    
    % Get the power spectrum of this chunk
    [p_vals,p_sig]=freqSpec_1s(this_sig,fs);
    
    %figure();
    plot(p_vals, abs(p_sig));
    title('Frequency Spectrum of 0.05s Signal');
    xlabel('Frequency');
    ylabel('Magnitude');
    
    % Get a rough overall magnitude for comparison
    p_power=sum(abs(p_sig));
    
    % State 1, listen for start of new tone
    if state == 1
        
        % Check for start of new tone
        if p_power > (prev_power*1.1)
            stacked_sig=zeros(1,len-1);
            state=2;
        end
        
    % State 2, college new tone and find ASCII frequencies
    elseif state == 2
        
        % Stack signal slices
        stacked_sig( ((section*fs)*rd)+1 : ((section+1)*fs)*rd ) = this_sig;
        
        % Check for end of this tone
        if p_power < (prev_power/1.1)
            state=1;
            
            % Get the rough power spectrum
            [stacked_vals,stacked_p]=powerSpec(stacked_sig,fs);
            [peak_power, peak_I]=max(stacked_p);
            
            col_index = 1;
            row_index = 1;
            col_range_min = 1;
            row_range_min = 1;
            
            for iterator = 1:12
                
                % Create subranges to match the frequencies we're looking for
                range=10;
                max_col_range=find(stacked_vals>(cols(iterator)-range) & stacked_vals<(cols(iterator)+range));
                max_row_range=find(stacked_vals>(rows(iterator)-range) & stacked_vals<(rows(iterator)+range));

                % Get the index of maximum value
                [C_col,I_col]=max(stacked_p(max_col_range));
                [C_row,I_row]=max(stacked_p(max_row_range));
                
                % Safety net to ensure only suitably large tones are
                % recognized
                if C_col > (peak_power/3) && C_col > stacked_p(col_index)
                    col_index = I_col;
                    col_range_min = min(max_col_range);
                end

                if C_row > (peak_power/3) && C_row > stacked_p(row_index)
                    row_index = I_row;
                    row_range_min = min(max_row_range);
                end
                
            end
            
            % Find the corresponding frequency
            col_button_freq=floor(stacked_vals(col_index+col_range_min-1));
            row_button_freq=floor(stacked_vals(row_index+row_range_min-1));

            % Get the chars_list index
            col_index=find(cols>(col_button_freq-10) & cols<(col_button_freq+10));
            row_index=find(rows>(row_button_freq-10) & rows<(row_button_freq+10));
            
            % Safety net, only stored detected chars
            if isempty(col_index)
                continue;
            elseif isempty(row_index)
                continue;
            end
            
            % Find the key value and append to list
            chars(chars_index)=chars_list(row_index,col_index);
            chars_index=chars_index+1;
        end % End of frequency gathering
    end % End of state model
    prev_power=p_power;
end

if isempty(chars)
    chars(1:5)={'E' 'r' 'r' 'o' 'r'};
end

end





