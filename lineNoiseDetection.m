function noise_t = lineNoiseDetection(data,tlim,nspikelim)

% input for this function is data output from TDT

if nargin < 2
    tlim = 1e-3;
    % nspikelim = 3;
    nspikelim = 15;
elseif nargin < 3
    % nspikelim = 3;
    nspikelim = 15;
end

% unload time data for spikes
ts = data.snips.eNe1.ts;

% compute the differences between spikes
ts_d = diff(ts);

% get a moving average of time differences of spikes based on nspikelim
% nspikelim - 1 is in use because the moving average takes the difference.
% n spikes will have n-1 differences in time.
M = movmean(ts_d,nspikelim-1);

% multiply window size to get real time
Mt = M*(nspikelim-1);

noise_i = find(Mt < tlim);

noise_t = ts(noise_i-1);

