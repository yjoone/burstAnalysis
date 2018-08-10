function [duration,noise,start_i,end_i,doubleBurst] = getBurstDuration(bursts,ch)

% This function takes in a single burst, and identifies beginning and
% ending time for that burst.

% Set the burst detection threshold: 100x overall firing rate % disregard.
initialBurstDetectionWindow = .1; %s
initialBurstSpikeCount = 10; %spikes % used to identify double bursts
initialBurstChannelCount = 4;
finalBurstDetectionWindow = .1; %s
finalBurstChannelCount = 3;
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
    
    doubleBurst.firstBurst.ts = ts;
    doubleBurst.firstBurst.chan = ch;
    duration = NaN;
    start_i = NaN;
    end_i = NaN;
    noise = 1;
    return
end
        
burstStart = spi;

%% get the ending channal count requirement
chanCount_f = inf;
% spf = 1;
spf = spi+initialBurstSpikeCount;


while chanCount_f > finalBurstChannelCount

    if spf > length(ts)
        spf = length(ts);
    end
    b_tf = ts(spf);
    % Cur_i = find(ts > (b_tf + finalBurstDetectionWindow) & ts < b_tf);
%     if isempty(Cur_i)
%         spf = spf+1;
%     else
%     chCur_i = ch(Cur_i);
%         chanCount_f = length(unique(chCur_i));
%         if chanCount_f < finalBurstChannelCount
%             spf = spf+1;
%         end
%     end
    Cur_i = find(ts < (b_tf + finalBurstDetectionWindow) & ts > b_tf);
    [chanCount_f,~] = size(Cur_i);
    if chanCount_f >= finalBurstChannelCount 
        spf = spf+1;
    end
    
    % stop the process if it reaches the end of the burst    
    if spf > burstLen 
        spf = spf-1; % take out the added +1 in line 47
        break
    end
    
end

%% identify double burst so that the later burst can be analyzed
% doubleBurst.ts = ts(spf:end);
% doubleBurst.chan = ch(spf:end);
% doubleBurst.firstBurst.ts = ts(1:spf);
% doubleBurst.firstBurst.chan = ch(1:spf);
% 
% if length(doubleBurst) < initialBurstSpikeCount
%     doubleBurst = NaN;
% end

doubleBurst.firstBurst.ts = ts(1:spf);
doubleBurst.firstBurst.chan = ch(1:spf);

if length(ts(spf:end)) >= initialBurstSpikeCount
    doubleBurst.ts = ts(spf:end);
    doubleBurst.chan = ch(spf:end);
end

duration = ts(spf) - ts(spi);
start_i = ts(spi);
end_i = ts(spf);
noise = 0;
