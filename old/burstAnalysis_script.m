% burst analysis script

% first thing you'd want to do is to run the GUI using GuiCode(data) to
% identify channels and sortcodes to be removed

% Then click on 'save for analysis' button
% This will save a output struct called DataStruct into the current
% directory

% The run burstAnalysis_main(dataStruct)

load('test.mat'); % change it to the output file of GUI 

% preprocess the data. Get rid of line noise and remove ch, sc;
dataStruct = preProcessData(dataStruct);

% detect burst
[burst_i,burstStruct,candBurst_i_orig,burstThresh] = detectBurst(data);

% analyze burst
burstStruct = analyzeBurst(burstStruct);