function runAllMEAData(allData)

% This function runs all the burst analysis for the allData input. 
% allData input is from getAllMEAData, specifically for Jim's mac. Changes
% need to be made to run it in other machines.

nData = length(allData);

for i = 1:nData
    dataStruct = allData(i).data;
    fileName = allData(i).fileName;
    fileDir = allData(i).dir;
    
    burstStruct = MEAMain(dataStruct);
    
    