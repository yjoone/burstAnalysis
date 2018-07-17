

%
minChanActivity = 3;

%
i = 5;
ts = burstStruct.bursts{i};
chan = burstStruct.burstChans{i};

[C,ia,ic] = unique(chan);
ia_b = ia >= minChanActivity;
chanCount = sum(ia_b);

ts_diff = diff(ts);
ts_sumsqrt = sum(ts.^2);
ts_sqrtsum = sqrt(sum(ts));
ts_sum = sum(ts);

B = ((sqrt(ts_sumsqrt - ts_sqrtsum)/ts_sum)-1)/sqrt(chanCount)
