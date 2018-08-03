function [duration,start_i,end_i] = getBurstDuration(bursts,ch)

% This function takes in a single burst, and identifies beginning and
% ending time for that burst.

% Set the burst detection threshold: 100x overall firing rate % disregard.
initialBurstDetectionWindow = .1; %s
initialBurstSpikeCount = 10; %spikes
initialBurstChannelCount = 4;
finalBurstDetectionWindow = .1; %s
finalBurstChannelCount = 5;
burstEndThresh = 3;

ts = bursts;
duration = [];
burstLen = length(ts);

%% get the beginning channal count requirement
chanCount_i = 0;
spi = 1;

try
    while chanCount_i < initialBurstChannelCount
        % get all the spikes within the window
        b_ti = ts(spi);
        Cur_i = find(ts > b_ti & ts < (b_ti + initialBurstDetectionWindow));
        chCur_i = ch(Cur_i);
        chanCount_i = length(unique(chCur_i));
        if chanCount_i < initialBurstChannelCount
            spi = spi+1;
        end
    end
catch 
    duration = NaN;
    start_i = NaN;
    end_i = NaN;
    return
end
        
burstStart = spi;

%% get the ending channal count requirement
chanCount_f = 0;
spf = 1;


while chanCount_f < finalBurstChannelCount
    b_tf = ts(spf);
    Cur_i = find(ts > (b_tf + finalBurstDetectionWindow) & ts < b_tf);
    if isempty(Cur_i)
        spf = spf+1;
    else
    chCur_i = ch(Cur_i);
        chanCount_f = length(unique(chCur_i));
        if chanCount_f < finalBurstChannelCount
            spf = spf+1;
        end
    end
    
    if spf > burstLen 
        spf = spf-1; % take out the added +1 in line 47
        break
    end
    
end

duration = ts(spf) - ts(spi);
start_i = ts(spi);
end_i = ts(spf);
