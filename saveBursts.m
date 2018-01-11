function burstStruct = saveBursts(burst_i,data,candBurst_i_orig,burstThresh,filePath)

if nargin < 3
    filePath = '/Users/JimKwon/Documents/WennerLabMatlab/test';
end

%%% IMPORTANT %%%
% burst_i is in 10ms bins and data ts is in 1s bins. Therefore divide it
% by 100 to fit the scale
% get 250ms before and 750ms after burst has been called to save the burst

for i = 1:length(burst_i)
    t = burst_i(i)/100;
    bi = data.snips.eNe1.ts > (t-0.25) & data.snips.eNe1.ts < (t+0.75);
    bursts{i} = data.snips.eNe1.ts(bi)-(t-0.25);
end

burstStruct.bursts = bursts;
burstStruct.burst_i = burst_i;
burstStruct.candBurst_i_orig = candBurst_i_orig;
burstStruct.burstThresh = burstThresh;
burstStruct.data = data;

