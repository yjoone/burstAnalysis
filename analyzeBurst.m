function burstStruct = analyzeBurst(burstStruct)

% this function takes in data from TDT synapse output and the burst_i from
% detectBurst.m to measure burst freq, duration, spike freq within a burst,
% and interburstinterval.

warning('off','stats:mle:EvalLimit')

%%%%% bin size for burst detection is .5s 

% unload all variables
data = burstStruct.data;
burst_i = burstStruct.burst_i;
bursts = burstStruct.bursts;

% calculate burst frequency
max_t = max(data.snips.eNe1.ts);
burstFreq_Hz = length(burst_i)/max_t;

% calculate burst duration
x = 0:0.001:1-0.001;
for i = 1:length(bursts)
    b = bursts{i};
    try
        phat = mle(b,'distribution','burr');
    catch
        phat = [NaN; NaN; NaN];
    end
    pdfFit(i,1:3) = phat;
    y = pdf('burr',x,phat(1),phat(2),phat(3));
    dur(i,1) = sum(y > (max(y)/2)); 
    
%     if ~isnan(phat(1))
%         % plot each bursts as histogram and fitted pdf
%         fh = figure('visible','off');
%         hist(b,50); 
%         counts = hist(b,50);
%         scale = max(counts)/max(y);
%         hold on;
%         plot(x,y*scale,'r')
%         title(['Burst id ' num2str(i) ' Histogram, dur = ' num2str(dur(i,1)) ', scale = ' num2str(scale)])
%         xlabel('time (ms)')
%         savefig(fh,['burstHist_' num2str(i) '.fig']);
%         print(fh,['burstHist_' num2str(i) '.png'],'-dpng');
%         clear fh
%     end
end

burstStruct.pdfType = 'burr';
burstStruct.pdfFit = pdfFit;
burstStruct.duration_ms = dur;


% calculate spike frequency within a burst
nburst = length(burst_i);

for i = 1:nburst
    bt_ms = burst_i(1,i);
    bt_s = bt_ms/100; % binsize 10ms
    spikeRate_Hz(i,1) = sum(data.snips.eNe1.ts >= bt_s - 0.1 & data.snips.eNe1.ts < bt_s + 0.4)*2;
end
    

% calculate IBI
IBI = mean(diff(burst_i))/100; % divide by 100 because burst_i is in 10ms bins.

burstStruct.burstFreq_Hz = burstFreq_Hz;

burstStruct.spikeRate_Hz = spikeRate_Hz;
burstStruct.IBI = IBI;


