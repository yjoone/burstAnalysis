function [dataStruct_1,dataStruct_2] =splitRecordingData(dataStruct,timePeriods)

% this function takes in the dataStruct from GuiCode, and splits the
% dataset into chunks specified in time periods. The timePeriods input
% should be a n by 2 array of starting time and end time of each period

% example: [dataStruct_1,dataStruct_2] =splitRecordingData(dataStruct,[0 12*3600; 12*3600 24*2600])

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

dataStruct_2.snips.eNe1.ts = (ts(ind_2)-timePeriods(2,1)); % change the start time based on the timePeriods
dataStruct_2.snips.eNe1.chan = chan(ind_2);
dataStruct_2.snips.eNe1.sortcode = sortcode(ind_2);