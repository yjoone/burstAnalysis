function plotChannels(ts,chan,maxChan)

% This function takes in the MEA data from TDT and plots per channel
% spikes.

if nargin < 3
    maxChan = 64;
end

figure;
hold on;

for i = 1:maxChan
    ic = find(chan == i);
    plot(ts(ic),i*ones(size(ts(ic))),'k.')
end

set(gca,'ylim',[1 maxChan])
