function burstStruct = analyzeBurst(burstStruct,plotTF)

% this function takes in data from TDT synapse output and the burst_i from
% detectBurst.m to measure burst freq, duration, spike freq within a burst,
% and interburstinterval.

if nargin < 2
    plotTF = 'off';
end

warning('off','stats:mle:EvalLimit')

%%%%% bin size for burst detection is .5s 

% unload all variables
data = burstStruct.data;
burst_i = burstStruct.burst_i;
bursts = burstStruct.bursts;
sc = burstStruct.data.snips.eNe1.sortcode;
ch = burstStruct.data.snips.eNe1.chan;
t = burstStruct.data.snips.eNe1.ts;
sc_rmv = burstStruct.data.sc_selected;
ch_rmv = burstStruct.data.ch_selected;

max_ch = max(burstStruct.data.snips.eNe1.chan);

% remove selected sort codes and channels
sc_i = ismember(sc,sc_rmv);
sc(sc_i) = NaN;
ch_i = ismember(ch,ch_rmv);
ch(ch_i) = NaN;

% calculate burst frequency
max_t = max(data.snips.eNe1.ts);
burstFreq_Hz = length(burst_i)/max_t;

% calculate burst duration
x = 0:0.001:1-0.001;
for i = 1:length(bursts)
    b = bursts{i};
    burstData = burstStruct.bursts{i};
    burstLen = length(burstData);
    
    % special case when burst_i takes place within the first half second
    % (rounding it will make the subscript 0)
    if burstStruct.burst_i(i) < 50
        burst_ii = ceil(burstStruct.burst_i(i)/100);
    else
        burst_ii = round(burstStruct.burst_i(i)/100); % because burst_i is in 10ms bins
    end
    
    try
        channel = ch(burst_ii:burst_ii+burstLen-1);
        t_burst = t(burst_ii:burst_ii+burstLen-1);
    catch
        channel = ch(burst_ii:end);
        t_burst = t(burst_ii:end);
    end
    
    try
        phat = mle(b,'distribution','burr');
        noise(i) = 0;
    catch
        phat = [NaN; NaN; NaN];
        noise(i) = 1;
    end
    pdfFit(i,1:3) = phat;
    y = pdf('burr',x,phat(1),phat(2),phat(3));
    % calculate burst duration. half on/off period
    dur(i,1) = sum(y > (max(y)/2));
    
    if ~isnan(phat(1))
        if strcmp(plotTF,'on')
            % plot each bursts as histogram and fitted pdf
            fh = figure('visible','off');
            hist(b,50);
            counts = hist(b,50);
            scale = max(counts)/max(y);
            hold on;
            plot(x,y*scale,'r')
            title(['Burst id ' num2str(i) ' Histogram, dur = ' num2str(dur(i,1)) ', scale = ' num2str(scale)])
            xlabel('time (ms)')
            
            % inner plot
            ah = axes();
            set(ah,'position',[.8 .8 .1 .1]);
            for cha = 1:max(channel)
                ind = find(channel == cha);
                ts = burstData(ind);
                plot(ts, cha*ones(size(ts)),'k.');
                max_ts = max(max(ts),max_t);
                if ~isempty(max_ts)
                    axis([0, max_ts, 0, max_ch+1]);
                end
                hold on;
                box{cha,1} = ts;
            end
            set(gca,'Ydir','reverse')
            set(gca,'ylim',[0 max_ch]);
            set(gca,'xlim',[0 1]);
            
            fPath = burstStruct.data.info.blockname;
            fullPath = ['E:/MEA_Analysis/' fPath];
            try
                mkdir(fullPath)
                savefig(fh,['burstHist_' num2str(i) '.fig']);
                print(fh,['burstHist_' num2str(i) '.png'],'-dpng');
                clear fh
            catch
                display('Please try valid address')
                keyboard
            end
           
        end
    end
end

burstStruct.pdfType = 'burr';
burstStruct.pdfFit = pdfFit;
burstStruct.noise = noise;
burstStruct.duration_ms = dur(~noise);


% calculate spike frequency within a burst
nburst = length(burst_i);

for i = 1:nburst
    bt_ms = burst_i(1,i);
    bt_s = bt_ms/100; % binsize 10ms
    withinBurstSpikeRate_Hz(i,1) = sum(data.snips.eNe1.ts >= bt_s - 0.1 & data.snips.eNe1.ts < bt_s + 0.4)*2;
end
    

% calculate IBI
IBI = mean(diff(burst_i))/100; % divide by 100 because burst_i is in 10ms bins.

burstStruct.burstFreq_Hz = burstFreq_Hz;

burstStruct.withinBurstSpikeRate_Hz = withinBurstSpikeRate_Hz(~noise);
burstStruct.IBI = IBI;


