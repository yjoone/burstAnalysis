function [interBurstFR] = calcInterburstFR(data,burst_i,preBurstThreshold,postBurstThreshold)

% this function takes in the original TDT outputed data and output of the
% detectBurst function. 

if nargin < 3
    preBurstThreshold = 2000;
    postBurstThreshold = 8000;
elseif nargin < 4
    postBurstThreshold = 8000;
end

binSize = 10; %ms


% unload spike data
ts = data.snips.eNe1.ts;
tms = ts*1000;

% discretize data
binEdges = 0:binSize:round(max(tms))+binSize;
% tmsBin = discretize(tms,binEdges);
N = histcounts(tms,binEdges);

% delete 2s before and 8s after bursting to eliminate the possibility of
% counting any build-up or residual activity.

burstNum = length(burst_i);
cleanN = N;

for i = 1:burstNum-1
    burstt_i = burst_i(i);
    if burstt_i < preBurstThreshold
        cleanN(1:burstt_i+postBurstThreshold) = 0;
    elseif burstt_i > max(tms)+postBurstThreshold
        cleanN(burstt_i-preBurstThreshold:end) = 0;
    else
        cleanN(burstt_i-preBurstThreshold:burstt_i+postBurstThreshold) = 0;
    end
    
    % count number of spikes in between bursts
    interBurstFR(i,1) = sum(cleanN(burst_i(i):burst_i(i+1)));
end

end