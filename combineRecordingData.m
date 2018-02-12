function [dataStruct] =combineRecordingData(dataStruct_1,dataStruct_2)

% this function takes in the dataStruct from GuiCode, and combines the
% dataset into a single dataStructure. This may result in small
% discrepencies in ts, but it does not affect any spike ts. 

% dataStruct_1 is the main structure. All the information will be that of
% dataStruct_1. 

dataStruct = dataStruct_1;

ts_1 = dataStruct_1.snips.eNe1.ts;
chan_1 = dataStruct_1.snips.eNe1.chan;
sortcode_1 = dataStruct_1.snips.eNe1.sortcode;

ts_2 = dataStruct_2.snips.eNe1.ts;
chan_2 = dataStruct_2.snips.eNe1.chan;
sortcode_2 = dataStruct_2.snips.eNe1.sortcode;

dataStruct.snips.eNe1.ts = [ts_1; (max(ts_1)+ts_2)];
dataStruct.snips.eNe1.chan = [chan_1; chan_2];
dataStruct.snips.eNe1.sortcode = [sortcode_1; sortcode_2];

