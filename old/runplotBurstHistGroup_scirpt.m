% script to load all the burstStruct.mat and run plotBurstHist.m

d = 'E:\MEA_Analysis\L14_KO';

dd = dir(d);

len = length(dd);

for i = 3:len
    fName = dd(i).name;
    fullFilePath = fullfile(d,fName,'BurstStruct.mat');
    load(fullFilePath);
    
    % run plot burst
    plotBurstHist(burstStruct);
    
    burstFreq(i) = burstStruct.burstFreq_Hz;
    names{i} = burstStruct.data.info.blockname;
end