function data_out = selectChannelSortData(data)

max_ch = max(data.snips.eNe1.chan);
sortCodes = unique(data.snips.eNe1.sortcode);

