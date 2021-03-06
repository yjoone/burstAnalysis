function burstStruct = analyzeBurst(burstStruct,minBurstActivity,plotTF)

% this function takes in data from TDT synapse output and the burst_i from
% detectBurst.m to measure burst freq, duration, spike freq within a burst,
% and interburstinterval.

if nargin < 3
    plotTF = 'off';
end

warning('off','stats:mle:EvalLimit')

%%%%% bin size for burst detection is .5s

% unload all variables
data = burstStruct.data;
burst_ind = burstStruct.burst_ind;
bursts = burstStruct.bursts;
burstChans = burstStruct.burstChans;
burst_ind_binSize = burstStruct.burst_ind_binSize;
sc = burstStruct.data.snips.eNe1.sortcode;
ch = burstStruct.data.snips.eNe1.chan;
ts = burstStruct.data.snips.eNe1.ts;
% sc_rmv = burstStruct.data.sc_selected;
% ch_rmv = burstStruct.data.ch_selected;

max_ch = max(burstStruct.data.snips.eNe1.chan);
max_t = max(data.snips.eNe1.ts);

nBursts = length(bursts);
% duration = zeros(nBursts,1);
bursts_adj = {};
bursts_chan_adj = {};
duration = [];
noise = [];
start_i = [];
end_i = [];

box = [];
for i = 1:nBursts
    count = 1;

%    burst_ind_temp = burst_ind(i,:);
    bursts_temp = bursts{i};
    chans_temp = burstChans{i};
    if length(bursts{i}) < minBurstActivity % don't include small bursts
%        noise(i,1) = 1;
        bursts_adj = [bursts_adj; {bursts_temp}];
        bursts_chan_adj = [bursts_chan_adj; {chans_temp}];
        noise = [noise; 1];
        duration = [duration; NaN];
        start_i = [start_i; NaN];
        end_i = [end_i; NaN];
    else % compute burst characteristics
        
        %% compute burst duration with Eisenmann method
%         % burst duration
%         duration(i,1) = (diff(burst_ind_temp))/(1000/burst_ind_binSize);

        [duration_temp,noise_temp,start_i_temp,end_i_temp,doubleBurst] = ...
            getBurstDuration(bursts_temp,chans_temp);
        
        bursts_adj = [bursts_adj; {doubleBurst.firstBurst.ts}];
        bursts_chan_adj = [bursts_chan_adj; {doubleBurst.firstBurst.chan}];
        noise = [noise; noise_temp];
        duration = [duration; duration_temp];
        start_i = [start_i; start_i_temp];
        end_i = [end_i; end_i_temp];
        
        
        
        while isfield(doubleBurst,'ts')
            [duration_temp,noise_temp,start_i_temp,end_i_temp,doubleBurst] = ...
                getBurstDuration(doubleBurst.ts,doubleBurst.chan);
            
            bursts_adj = [bursts_adj; {doubleBurst.firstBurst.ts}];
            bursts_chan_adj = [bursts_chan_adj; {doubleBurst.firstBurst.chan}];
            noise = [noise; noise_temp];
            duration = [duration; duration_temp];
            start_i = [start_i; start_i_temp];
            end_i = [end_i; end_i_temp];
            
             count = count+1;
             
             if count > 2
                 box = [box; length(noise)];
             end
        end
         
%         % end test
%         if isfield(dbt,'ts')
%             doubleBurst = dbt;
%             [duration_temp,noise_temp,start_i_temp,end_i_temp,doubleBurst] = ...
%                 getBurstDuration(doubleBurst.ts,doubleBurst.chan);
%             
%             bursts_adj = [bursts_adj; {doubleBurst.firstBurst.ts}];
%             bursts_chan_adj = [bursts_chan_adj; {doubleBurst.firstBurst.chan}];
%             noise = [noise; noise_temp];
%             duration = [duration; duration_temp];
%             start_i = [start_i; start_i_temp];
%             end_i = [end_i; end_i_temp];
%         else
%             
%         end
%         % calculate spike frequency within a burst
%         % withinBurstSpikeRate_Hz(i,1) = length(bursts_temp)/range(bursts_temp);
%         withinBurstSpikeRate_Hz(i,1) = length(bursts_temp)/duration(i,1);
%         
%         noise(i,1) = 0;
    end
end

% calculate spike frequency within a burst
% withinBurstSpikeRate_Hz(i,1) = length(bursts_temp)/range(bursts_temp);
% withinBurstSpikeRate_Hz(i,1) = length(bursts_temp)/duration(i,1);
withinBurstSpikeRate_Hz = cellfun('length',bursts_adj)./duration;


% calculate burst frequency
burstFreq_Hz = sum(noise==0)/range(data.snips.eNe1.ts);

% calculate IBI
% IBI = mean(diff(burst_i_dn))/100; % divide by 100 because burst_i is in 10ms bins.
% IBI = diff(burst_ind(~noise,1))/(1000/burst_ind_binSize);
IBI = diff(start_i(~noise));

% load all the data to the output struct
% burstStruct.pdfType = 'gamma';
% burstStruct.pdfType = 'burr';
% burstStruct.pdfFit = pdfFit;
burstStruct.bursts_adj = bursts_adj;
burstStruct.bursts_chan_adj = bursts_chan_adj;
burstStruct.noise = noise;
% burstStruct.bursts = bursts{~noise}; % not simple to get rid of cell indexes. This contains noise bursts 
burstStruct.duration_s = duration;
burstStruct.burststarti = start_i;
burstStruct.burstendi = end_i;
% burstStruct.burst_i_dn = burst_i(~noise);
burstStruct.burstFreq_Hz = burstFreq_Hz;
burstStruct.withinBurstSpikeRate_Hz = withinBurstSpikeRate_Hz;
% burstStruct.IBI = IBI;

% load in all the finalized analysis data
burstStruct.analysisData.duration_s = duration(find(noise==0));
% burstStruct.analysisData.burst_ind = burst_ind(find(noise == 0),:);
burstStruct.analysisData.burstFreq_Hz = burstFreq_Hz;
burstStruct.analysisData.IBI = IBI;
burstStruct.analysisData.withinBurstSpikeRate_Hz = withinBurstSpikeRate_Hz(find(noise==0));

% calculate the average and add to the burstStruct
burstStruct.analysisData.mean_duration_s = mean(burstStruct.analysisData.duration_s);
burstStruct.analysisData.mean_burstFreq_Hz = mean(burstStruct.analysisData.burstFreq_Hz);
burstStruct.analysisData.mean_IBI = mean(burstStruct.analysisData.IBI);
burstStruct.analysisData.mean_withinBurstSpikeRate_Hz = mean(burstStruct.analysisData.withinBurstSpikeRate_Hz);

burstStruct.box = box;

% % remove selected sort codes and channels
% sc_i = ismember(sc,sc_rmv);
% sc(sc_i) = NaN;
% ch_i = ismember(ch,ch_rmv);
% ch(ch_i) = NaN;

% % calculate burst duration
% x = 0:0.001:1-0.001;
% for i = 1:length(bursts)
%     b = bursts{i}; 
%     burstData = bursts{i};
%     burstLen = length(burstData);
% 
%     % special case when burst_i takes place within the first half second
%     % (rounding it will make the subscript 0)
%     if burst_i(i) < 50
%         burst_ii = ceil(burst_i(i)/100);
%     else
%         burst_ii = round(burst_i(i)/100); % because burst_i is in 10ms bins
%     end
%     
%     try
%         channel = ch(burst_ii:burst_ii+burstLen-1);
%         t_burst = t(burst_ii:burst_ii+burstLen-1);
%     catch
%         channel = ch(burst_ii:end);
%         t_burst = t(burst_ii:end);
%     end
%     
%     if burstLen < minBurstActivity
%         % phat = [NaN;NaN]; % gamma fit
%         phat = [NaN;NaN;NaN]; % burr fit
%         noise(i) = 1;
%     else
%         % phat = mle(b,'distribution','gamma');
%         % phat = mle(b,'distribution','burr');
%         phat = mle(b,'pdf',@(x,v,d)ncx2pdf(xvd),'start',[1,1]);
%         noise(i) = 0;
%     end
% %     pdfFit(i,1:2) = phat; % gamma fit
% %     y = pdf('gamma',x,phat(1),phat(2)); % gamma fit
%     
%     pdfFit(i,1:3) = phat; % burr fit
%     y = pdf('burr',x,phat(1),phat(2),phat(3)); % burr fit
%     
%     % calculate burst duration. half on/off period
%     dur(i,1) = sum(y > (max(y)/2));
%     
%     if ~isnan(phat(1))
%         if strcmp(plotTF,'on')
%             % plot each bursts as histogram and fitted pdf
%             fh = figure('visible','off');
%             hist(b,50);
%             counts = hist(b,50);
%             scale = max(counts)/max(y);
%             hold on;
%             plot(x,y*scale,'r')
%             title(['Burst id ' num2str(i) ' Histogram, dur = ' num2str(dur(i,1)) ', scale = ' num2str(scale)])
%             xlabel('time (ms)')
%             
%             % inner plot
%             ah = axes();
%             set(ah,'position',[.8 .8 .1 .1]);
%             for cha = 1:max(channel)
%                 ind = find(channel == cha);
%                 ts = burstData(ind);
%                 plot(ts, cha*ones(size(ts)),'k.');
%                 max_ts = max(max(ts),max_t);
%                 if ~isempty(max_ts)
%                     axis([0, max_ts, 0, max_ch+1]);
%                 end
%                 hold on;
%                 box{cha,1} = ts;
%             end
%             set(gca,'Ydir','reverse')
%             set(gca,'ylim',[0 max_ch]);
%             set(gca,'xlim',[0 1]);
%             
%             fPath = burstStruct.data.info.blockname;
%             % fullPath = ['E:/MEA_Analysis/' fPath]; % uncheck this for
%             % Wenner lab
%             fullPath = 'C:\Users\liulabuser\Desktop\Jim\WennerlabMatlab\test';
%             try
%                 % mkdir(fullPath) % uncheck this for wenner lab
%                 savefig(fh,[fullPath '\burstHist_' num2str(i) '.fig']);
%                 print(fh,[fullPath '\burstHist_' num2str(i) '.png'],'-dpng');
%             catch
%                 display('Please try valid address')
%                 keyboard
%             end
%             clear fh
%         end
%     end
% end
% 
% % calculate burst duration
% burst_dur = (burst_ind(:,2) - burst_ind(:,1))/(1000/burst_ind_binSize);
% 
% % calculate spike frequency within a burst
% 
%     
% burst_i_dn = burst_i(~noise);
% nburst = length(burst_i_dn);
% for i = 1:nburst
%     bt_ms = burst_i_dn(i,1);
%     bt_s = bt_ms/100; % binsize 10ms
%     withinBurstSpikeRate_Hz(i,1) = sum(data.snips.eNe1.ts >= bt_s - 0.1 & data.snips.eNe1.ts < bt_s + 0.4)*2;
% end
% 
% % calculate burst frequency
% burstFreq_Hz = length(burst_i_dn)/max_t;
% 
% % calculate IBI
% IBI = mean(diff(burst_i_dn))/100; % divide by 100 because burst_i is in 10ms bins.



