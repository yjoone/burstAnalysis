% script to create a simple raster plot of all the snips
% there should be a variable called data, which contains the snip data


max_ts = 0.1;
max_ch = max(data.snips.eNe1.chan);
for ch = 1:max_ch
    ind = find(data.snips.eNe1.chan == ch);
    ts = data.snips.eNe1.ts(ind);
    plot(ts, ch*ones(size(ts)),'k.');
    hold on
    max_ts = max(max(ts),max_ts);
%     if ~isempty(max_ts)
%         axis(handles.axes1,[0, max_ts, 0, max_ch+1]);
%     end
end
% set(gca,'Ydir','reverse')
xlabel('time, s')
set(gca,'ylim',[0 66])
hold off

set(gca,'fontsize',15)
set(gca,'xticks',[xlim(1):0.1:xlim(2)])