function data = initializeMEAData(BLOCKPATH)

SNIP_STORE = 'eNe1';
SORTID = 'TankSort';
%CHANNEL_RANGE = 1:64;
%SORTCODE = 0; % set to 0 to use all sorts

%data = TDT2mat(BLOCKPATH, 'TYPE', {'epocs', 'snips', 'scalars'}, 'SORTNAME', SORTID, 'CHANNEL', CHANNEL, 'NODATA', 1);
data = TDT2mat(BLOCKPATH, 'TYPE', {'epocs', 'snips', 'scalars'}, 'SORTNAME', SORTID, 'NODATA', 1);

GuiCode(data)
