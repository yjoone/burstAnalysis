1. Add in number of spikes for individual channels during a burst
**Obtain those values from "burstStruct.analysisData.chan_spikes"**

2. End of burst threshold
The original criterion was to seek for a period of 300ms after the burst without any spiking activity. Now, the default is to look for 300 ms period with less than or equal to 3 spikes. The varaible can be set in detectBurst line 17, "burstEndThresh"

3. Burst detection method using 3 consecutive firing of any channel within 10 ms
detectBurst_Eisenman
- Need to be sure that no noisy channels are included
- currently using threshold from 2 to mark the end of each burst. 
- Add in critical period

4. Synchronicity
- Stuck in an error
