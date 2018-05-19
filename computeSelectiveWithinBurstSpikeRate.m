function [burstStruct,mean_selectiveWithinBurstSpikeRate_Hz] = computeSelectiveWithinBurstSpikeRate(burstStruct,chanExclude)

% This function takes in the burstStruct, and computes the average within
% burst spike rate for only specific channels. 

% unload the data
channelWithinBurstSpikeRate_Hz = burstStruct.analysisData.channelWithinBurstSpikeRate_Hz;

% compute the average spike rate per channel during burst
avg_channelWithinBurstSpikeRate_Hz = ...
    mean(burstStruct.analysisData.channelWithinBurstSpikeRate_Hz,2);

% create an array for channels to compute the average
[chan,~] = size(channelWithinBurstSpikeRate_Hz);
channels = 1:chan;
channels(chanExclude) = [];

mean_selectiveWithinBurstSpikeRate_Hz = mean(avg_channelWithinBurstSpikeRate_Hz(channels),2);

% load it to the burstStruct
burstStruct.analysisData.selectiveChan.excludedChan = chanExclude;
burstStruct.analysisData.selectiveChan.mean_selectiveWithinBurstSpikeRate_Hz = ...
    mean_selectiveWithinBurstSpikeRate_Hz;