function plotBurstHist(burstStruct)
% this function takes in burstStruct which is an output of MEAMain.m It
% will create histograms of burst duration and within burst spike frequency
% and save the figures.


% xbins to be used for histogram
xbins = 0:10:1000;

% get fileName and Path to save the figures and set the title
fileName = burstStruct.data.info.blockname;
fullPath = ['E:\MEA_Analysis\TestJim'];

% % plot a histogram of duration
% dfh = figure; 
% hist(burstStruct.duration_ms, xbins)
% title([fileName ' Duration (ms)'])
% 
% % plot a histogram of within burst spike rate
% wfh = figure;
% hist(burstStruct.withinBurstSpikeRate_Hz, xbins)
% title([fileName ' withinBurstSpikeRate (Hz)'])

% plot dur and wbsr together
fh = figure;
subplot(2,1,1)
hist(burstStruct.duration_ms, xbins)
title([fileName ' Duration (ms) BurstFrequency = ' num2str(burstStruct.burstFreq_Hz)])
subplot(2,1,2)
hist(burstStruct.withinBurstSpikeRate_Hz, xbins)
title([fileName ' withinBurstSpikeRate (Hz)'])




% fullPath = ['C:\Users\MEA setup\Desktop'];
% 
try
    mkdir(fullPath)
    print(fh,['burst_duration_hist.png'],'-dpng');
    % print(wfh,['within_burst_Spike_rate_hist.png'],'-dpng');
    % save('test.mat','xbins');
    % savefig(dfh,['burst_duration_hist.fig']);
catch
    display('Please try valid address')
    keyboard
end