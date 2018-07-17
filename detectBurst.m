function [burstStruct] = detectBurst(data,postBurstTimeThresh,preBurstPeriod,plotOF)

% Issues with detecting repeating line noise needs to be worked out. 120417
% JK

% burst_i and burstStruct indexes are in 10ms bins
% postBurstTimeThresh was set at 300 when developing this code - 02/01/18

if nargin < 3
    plotOF = 'off'; 
end

%%% HARD CODE %%%
binSize = 10; %ms
% Set the burst detection threshold: 100x overall firing rate
burstThresh = .5;
burstEndThresh = 3;
%%% END HARD CODE %%%

% % import excel or csv file
% data = csvread(fileName);

% unload data 
ts = data.snips.eNe1.ts;
ch = data.snips.eNe1.chan;
sc = data.snips.eNe1.sortcode;
tms = ts*1000;

% scale the threshold to binsize
postBurstTimeThresh_bin = postBurstTimeThresh/binSize;
preBurstPeriod_s = preBurstPeriod/1000;

% discretize data
binEdges = 0:binSize:round(max(tms))+binSize;
% tmsBin = discretize(tms,binEdges);
N = histcounts(tms,binEdges);
Nm = movmean(N,10); % get moving average over 10 consecutive bins to detect missing bursts

% if exist('burstThresh')
%     display('Are you sure you want to overwrite the burst Threshold?')
%     burstThresh = mean(N)*100; % this should be only pretreatment firing rate. %%%CHANGE%%%
% end


% detect candidate bursts
candBurst_i = find(Nm>=burstThresh);
% candBurst_i = find(N>=burstThresh);
candBurst_i_orig = candBurst_i;

% for each candidate burst index, see how long it will take to get 200ms of
% inactivity and mark that as a burst.
candBurst_len = length(candBurst_i);
overlap = 0;

for i = 1:candBurst_len
    if ~overlap
        N_sum = 1;
        N_sum_ind = candBurst_i(i);
        % while N_sum > 0
        while N_sum > burstEndThresh
            try
                N_sum = sum(N((N_sum_ind+1):(N_sum_ind+postBurstTimeThresh_bin)));
            catch
                N_sum = sum(N((N_sum_ind+1):end));
            end
            N_sum_ind = N_sum_ind + 1;
        end
        bursts_sf(i,1:2) = [candBurst_i(i) N_sum_ind];
    else
        overlap = 0;
    end
    
    if i < candBurst_len % does not apply for the last index
        if candBurst_i(i+1) < max(bursts_sf(:,2)) % check if next burst index overlaps with the burst period
            overlap = 1;
        end
    end
end

burst_ind = bursts_sf(find(bursts_sf(:,1)),:);

% extract ts for bursts 
[burst_num,~] = size(burst_ind);
bursts = cell(burst_num,1);
for b = 1:burst_num
    burst_ind_bin = burst_ind(b,:)/100;
    burst_ts_i = find(ts > (burst_ind_bin(1,1) - preBurstPeriod_s/1000) ...
        & ts < burst_ind_bin(1,2));
    bursts{b,1} = ts(burst_ts_i);
    burstsChans{b,1} = ch(burst_ts_i);
end


% extract bursts
% burstStruct = saveBursts(burst_i,data,candBurst_i_orig,burstThresh);


burstStruct.bursts = bursts;
burstStruct.burstChans = burstsChans;
burstStruct.burst_ind = burst_ind;
burstStruct.burst_ind_binSize = binSize; %ms
burstStruct.candBurst_i = candBurst_i_orig;
burstStruct.burstThresh = burstThresh;
burstStruct.data = data; %preprocessed data
burstStruct.burst_i_dn = []; % create this field for mid-way analysis purpose

if strcmp(plotOF,'on')
    figure; 
    plot(N);
    hold on;
    % plot(burst_i,40,'r*');
    plot(burst_ind(:,1),20,'r*');
    xlabel('In 10ms bins');
    ylabel('Firing Rate per 10ms');
end
    
