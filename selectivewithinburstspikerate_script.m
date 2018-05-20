% script to recompute getBurstChannels (part of MEAMain), and compute the 
% selective within burst spike rate

chanExclude = [5,7,8,10];
% chanExclude = [];

% have burstStruct in the workspace

if ~exist('burstStruct')
    display('Please make sure that you have the burstStruct in the workspace');
    keyboard
end

% recompute burstStruct
burstStruct = MEAMain(burstStruct.data);

% compute selective within burst spike rate
[burstStruct,~] = computeSelectiveWithinBurstSpikeRate(burstStruct,chanExclude);
