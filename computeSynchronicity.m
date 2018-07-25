function [synchro,minChanActivity] = computeSynchronicity(burst,burstChan,minChanActivity)

if nargin < 2
    minChanActivity = 3;
end

ts = burst;
chan = burstChan;

[C,ia,ic] = unique(chan);
ia_b = ia >= minChanActivity;
chanCount = sum(ia_b);

ts_diff = diff(ts);
ts_sumsqrt = sum(ts.^2);
ts_sqrtsum = sqrt(sum(ts));
ts_sum = sum(ts);

B = ((sqrt(ts_sumsqrt - ts_sqrtsum)/ts_sum)-1)/sqrt(chanCount));
synchro = B;