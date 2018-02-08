function dataStruct = preProcessData(dataStruct)

% This function takes out all the sort code and channels selected from GUI
% to remove it from further analysis. Also it will denoise the data from
% the line noise

% unload the original data 
dataStruct.snips_orig = dataStruct.snips;

% get sortcode and channels to remove
ch = dataStruct.ch_selected;
sc = dataStruct.sc_selected;

% unload all the data to be processed
chan = dataStruct.snips.eNe1.chan;
sortcode = dataStruct.snips.eNe1.sortcode;
ts = dataStruct.snips.eNe1.ts;
data_Len = length(ts);

% identify which channels to remove 
len_ch = length(ch);
ch_i = logical(zeros(data_Len,1));

for i = 1:len_ch
    ch_i_temp = chan == ch(i);
    ch_i = ch_i | ch_i_temp;
end

% identify which sortcode to remove
len_sc = length(sc);
sc_i = false(data_Len,1);

for i = 1:len_sc
    sc_i_temp = sortcode == sc(i);
    sc_i = sc_i | sc_i_temp;
end

% take out the line noise
noise_t = lineNoiseDetection(dataStruct);
dataStruct.lineNoise_t = noise_t;
noise_i = false(length(ts),1);

for n_i = 1:length(noise_t)
    noise_i_temp = noise_t(n_i) == ts;
    noise_i = noise_i | noise_i_temp;
end

% combine channels and sortcodes to be removed
remove_i = sc_i | ch_i | noise_i;

dataStruct.snips.eNe1.chan = chan(~remove_i);
dataStruct.snips.eNe1.sortcode = sortcode(~remove_i);
dataStruct.snips.eNe1.ts = ts(~remove_i);
dataStruct.denoise = 1;
end
