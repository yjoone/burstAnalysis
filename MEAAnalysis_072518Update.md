1. Add in number of spikes for individual channels during a burst
Obtain those values from "burstStruct.analysisData.chan_spikes"

2. End of burst threshold
The original criterion was to seek for a period of 300ms after the burst without any spiking activity. Now, the default is to look for 300 ms period with less than or equal to 3 spikes. The varaible can be set in detectBurst line 17, "burstEndThresh"
