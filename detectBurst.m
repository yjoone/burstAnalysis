function [burst_i,burstStruct,candBurst_i_orig,burstThresh] = detectBurst(data,preBurstTimeThresh,plotOF)

% Issues with detecting repeating line noise needs to be worked out. 120417
% JK

% burst_i and burstStruct indexes are in 10ms bins

if nargin < 2
    preBurstTimeThresh = 1000; %ms %%%CHANGE%%%
    plotOF = 'off'; 
elseif nargin < 3
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

% discretize data
binEdges = 0:binSize:round(max(tms))+binSize;
% tmsBin = discretize(tms,binEdges);
N = histcounts(tms,binEdges);

% if you want to plot the 10ms bin data 
% figure; plot(N);


%%%%%%%%%% HARD CODED %%%%%%%%%%%%%
% Set the burst detection threshold: 100x overall firing rate
% burstThresh = mean(N)*100; % this should be only pretreatment firing rate. %%%CHANGE%%%
burstThresh = 5;

% detect candidate bursts
candBurst_i = find(N>burstThresh);
candBurst_i_orig = candBurst_i;

% for each candidate Burst, ignore 1s window after bursting. Also check for
% continuous bursting (consecutive bins).
candBurstNum = length(candBurst_i);

for i = 1:candBurstNum-1
    if candBurst_i(i)+1 ~= candBurst_i(i+1)
        tms_i = candBurst_i(i);
        postBurstn = find(candBurst_i<tms_i+preBurstTimeThresh);
        if max(postBurstn) > i
            candBurst_i(i+1:max(postBurstn))=0;
        end
    end
end

burst_i = candBurst_i(candBurst_i ~=0);

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
    
