close all; clear all; clc;

BLOCKPATH = 'C:\TDT\Synapse\Tanks\TestExperiment1-170822-085825\mouse_culture-093737';
%C:\TDT\Synapse\Tanks\TestExperiment1-170303-110044\mouse_culture-114005';

% %%%%% HARD CODE %%%%%
% spikerate_max = 600;
% spikerate_min = 0;
% %%%%%%%%%%%%%%%%%%%%%

SNIP_STORE = 'eNe1';
SORTID = 'TankSort';
%CHANNEL_RANGE = 1:64;
%SORTCODE = 0; % set to 0 to use all sorts

%data = TDT2mat(BLOCKPATH, 'TYPE', {'epocs', 'snips', 'scalars'}, 'SORTNAME', SORTID, 'CHANNEL', CHANNEL, 'NODATA', 1);
data = TDT2mat(BLOCKPATH, 'TYPE', {'epocs', 'snips', 'scalars'}, 'SORTNAME', SORTID, 'NODATA', 1);

figure;
max_ts = 0.1;
max_ch = max(data.snips.eNe1.chan);
for ch = 1:max_ch
    ind = find(data.snips.eNe1.chan == ch);
    ts = data.snips.eNe1.ts(ind);
    plot(ts, ch*ones(size(ts)),'k.');
    max_ts = max(max(ts),max_ts);
    if ~isempty(max_ts)
        axis([0, max_ts, 0, max_ch+1]);
    end
    hold on;
    box{ch,1} = ts;
end
set(gca,'Ydir','reverse')
xlabel('time, s')
title('Raster')
xlim_orig = get(gca,'xlim');
set(gca,'xlim',xlim_orig);
ylim_orig = get(gca,'ylim');

GuiCode(data)
% 
% % Sum the number of spikes for 1 sec bin
% nSpikes = zeros(max_ch,ceil(max_ts));
% for i = 1:max_ch
%     singleCh = box{i,1};
%     roundSC = ceil(singleCh);
%     % nSpikes(i,roundSC) = 1;
%     
%     for j = 1:length(roundSC)
%         t_i = roundSC(j);
%         nSpikes(i,t_i) = nSpikes(i,t_i)+1;
%     end
%     
% end
% nSpikes_out = sum(nSpikes);
% 
% % delete spikesrates outside of predefined range
% Max_i = nSpikes_out > spikerate_max;
% Min_i = nSpikes_out < spikerate_min;
% 
% nSpikes_out(Max_i) = 0;
% nSpikes_out(Min_i) = 0;
% 
% 
% figure;
% plot(nSpikes_out);



