function [burst_i,burstStruct,candBurst_i_orig,burstThresh] = detectBurst(data,postBurstTimeThresh,plotOF)

% Issues with detecting repeating line noise needs to be worked out. 120417
% JK

% burst_i and burstStruct indexes are in 10ms bins

if nargin < 2
    plotOF = 'off'; 
end

%%% HARD CODE %%%
binSize = 10; %ms
% burstThresh HARD CODED BELOW AS 100
%%% END HARD CODE %%%

% % import excel or csv file
% data = csvread(fileName);

% unload data 
ts = data.snips.eNe1.ts;
tms = ts*1000;

% scale the threshold to binsize
postBurstTimeThresh = postBurstTimeThresh/binSize;

% discretize data
binEdges = 0:binSize:round(max(tms))+binSize;
% tmsBin = discretize(tms,binEdges);
N = histcounts(tms,binEdges);

% if you want to plot the 10ms bin data 
% figure; plot(N);


%%%%%%%%%% HARD CODED %%%%%%%%%%%%%
% Set the burst detection threshold: 100x overall firing rate
% burstThresh = mean(N)*100; % this should be only pretreatment firing rate. %%%CHANGE%%%
burstThresh = 3.9;

% detect candidate bursts
candBurst_i = find(N>burstThresh);
candBurst_i_orig = candBurst_i;

% for each candidate Burst, ignore 1s window after bursting. Also check for
% continuous bursting (consecutive bins).
candBurstNum = length(candBurst_i);
overlap = 0;
for i = 1:candBurstNum-1
    if ~overlap
        if candBurst_i(i)+1 ~= candBurst_i(i+1) % if bursting is continuous, keep all of it and deal with it below (consecutive bins)
            tms_i = candBurst_i(i);
            postBurstn_c{i} = find(candBurst_i<tms_i+postBurstTimeThresh & candBurst_i > tms_i);
            if ismember(i+1,postBurstn_c{i})
                overlap = 1;
            end
        end
    else
        overlap = 0;
    end
end
postBurstn = cell2mat(postBurstn_c);
burst_i = candBurst_i;
burst_i(postBurstn) = [];

% burst_i = candBurst_i(candBurst_i ~=0);

% another QC for burst_i. Get rid of consecutive bursts that are 10 ms
% apart.
burst_i_d = (diff(burst_i));
di = find(burst_i_d == 1);
burst_i(di+1) = [];

% extract bursts
burstStruct = saveBursts(burst_i,data,candBurst_i_orig,burstThresh);

if strcmp(plotOF,'on')
    figure; 
    plot(N);
    hold on;
    plot(burst_i,40,'r*');
    xlabel('In 10ms bins');
    ylabel('Firing Rate per 10ms');
end
    
