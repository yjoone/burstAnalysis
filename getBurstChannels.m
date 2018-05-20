function burstStruct = getBurstChannels(burstStruct)

% this function identifies the channels that recorded each action potential
% and stores it in a output field

% unload data
% ts = burstStruct.data.snips.eNe1.ts;
% ch = burstStruct.data.snips.eNe1.chan;
% sc = burstStruct.data.snips.eNe1.sortcode;
% burst_ind = burstStruct.burst_ind; % this is in 10ms bin size. divide by 100 to get to seconds
burstChans = burstStruct.burstChans;
noise = burstStruct.noise;
dur = burstStruct.duration_s;

% get the length of bursts to loop
bursts_len = length(burstChans);
chan_spikes = zeros(64,bursts_len);

for i = 1:bursts_len
%         start_i = burst_ind(i,1)/100;
%         stop_i = burst_ind(i,2)/100;
%         
%         burst_i = find(ts> start_i & ts < stop_i);
%         ch_i = ch(burst_i);
%         sc_i = sc(burst_i);

        ch_i = burstChans{i};
        
        [C,ia,ic] = unique(ch_i); % lazy way of doing this
        
        C_len = length(C);
            for j = 1:C_len
                c_i = C(j); % get the channel for each C
                count = sum(ch_i == c_i);
                chan_spikes(c_i,i) = count;
            end
        
end

% get the total duration of bursts
% burstDuration = (sum(diff(burst_ind,1,2)) - length(burst_ind))/100; % burst_ind in 10 ms bin

% % sum it across columns to get total spike numbers for each channel
% chanSpikes_sum = sum(chan_spikes,2);
% 
% % calculate each channel within burst spike rate
% channelWithinBurstSpikeRate = chanSpikes_sum/burstDuration;

% store 
burstStruct.chan_spikes = chan_spikes;
% burstStruct.channelWithinBurstSpikeRate_Hz = channelWithinBurstSpikeRate;
burstStruct.channelWithinBurstSpikeRate_Hz = chan_spikes./dur';

burstStruct.analysisData.chan_spikes = chan_spikes(:,~noise);
burstStruct.analysisData.channelWithinBurstSpikeRate_Hz = burstStruct.channelWithinBurstSpikeRate_Hz(:,~noise);
burstStruct.analysisData.mean_channelWithinBurstSpikeRate_Hz = mean(burstStruct.analysisData.channelWithinBurstSpikeRate_Hz,2);


end
% calculate total duration of burst
