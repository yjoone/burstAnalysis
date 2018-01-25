function burstStruct = MEAMain(dataStruct)

% This is the main function to run MEA analysis. Input is the saved
% dataStruct from GUI

%%%%%%% HARD CODES %%%%%%%%
preBurstTimeThresh = 1000; %ms;

% %% get data from TDT
% 
% SNIP_STORE = 'eNe1';
% SORTID = 'TankSort';
% %CHANNEL_RANGE = 1:64;
% %SORTCODE = 0; % set to 0 to use all sorts
% 
% %data = TDT2mat(BLOCKPATH, 'TYPE', {'epocs', 'snips', 'scalars'}, 'SORTNAME', SORTID, 'CHANNEL', CHANNEL, 'NODATA', 1);
% data = TDT2mat(BLOCKPATH, 'TYPE', {'epocs', 'snips', 'scalars'}, 'SORTNAME', SORTID, 'NODATA', 1);

%%
% pre-process data
dataStruct = preProcessData(dataStruct);

% detect burst
[burst_i,burstStruct,candBurst_i_orig,burstThresh] = detectBurst(dataStruct,preBurstTimeThresh,'on');

% analyze burst
burstStruct = analyzeBurst(burstStruct);

% save data
fPath = burstStruct.data.info.blockname;
fullPath = ['E:/MEA_Analysis/' fPath];
try
    mkdir(fullPath)
    ffPath = [fullPath '/BurstStruct.mat'];
    save(ffPath,'burstStruct_f');
catch
    display('Please try valid address')
end

