function data_dn = denoise(data)

% This function identifies line noises and denoises the data from synapse
% TDT output. Every line noise detected will be taken out with ***20ms*** bin size

% copy the entire struct. The important data on the struct is located on
% data.snips.eNe1.ts (the times of spikes)
data_dn = data;

% get all the important info into a temporary box
box = [data.snips.eNe1.chan data.snips.eNe1.sortcode data.snips.eNe1.ts];

% identify noise
noise_t = lineNoiseDetection(data);

noise_u = unique(noise_t);
ni_all = [];

for i = 1:length(noise_u)
    nt = noise_u(i);
    ni = (box(:,3) >= nt & box(:,3) < (nt+0.02));
    ni_all = [ni_all; find(ni==1)];
end

% check for out of array size
maxi = find(ni_all > length(box));
ni_all(maxi) = [];

ni_u = unique(ni_all);
box(ni_u,:) = [];

data_dn.snips.eNe1.chan = box(:,1);
data_dn.snips.eNe1.sortcode = box(:,2);
data_dn.snips.eNe1.ts = box(:,3);

end
