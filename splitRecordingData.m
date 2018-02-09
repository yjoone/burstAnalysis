function [dataStruct_1,dataStruct_2] =splitRecordingData(dataStruct,timePeriods)

% this function takes in the dataStruct from GuiCode, and splits the
% dataset into chunks specified in time periods. The timePeriods input
% should be a n by 2 array of starting time and end time of each period

dataStruct_1 = dataStruct;
dataStruct_2 = dataStruct;

ts = dataStruct.snips.eNe1.ts;
chan = dataStruct.snips.eNe1.chan;
sortcode = dataStruct.snips.eNe1.sortcode;

ind_1 = find(ts > timePeriods(1,1) & ts < timePeriods(1,2));
ind_2 = find(ts > timePeriods(2,1) & ts < timePeriods(2,2));

dataStruct_1.snips.eNe1.ts = ts(ind_1);
dataStruct_1.snips.eNe1.chan = chan(ind_1);
dataStruct_1.snips.eNe1.sortcode = sortcode(ind_1);

dataStruct_2.snips.eNe1.ts = ts(ind_2);
dataStruct_2.snips.eNe1.chan = chan(ind_2);
dataStruct_2.snips.eNe1.sortcode = sortcode(ind_2);