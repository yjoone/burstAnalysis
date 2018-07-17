% script to create a simple raster plot of all the snips
% there should be a variable called data, which contains the snip data
clear all
%load('/Users/JimKwon/Documents/WennerLab_MATLAB_Collaboration/MEA_Analysis/Sample Datasets/Archive/PennyMatlabsortdata.mat')
% load('/Users/JimKwon/Documents/WennerLab_MATLAB_Collaboration/MEA_Analysis/BurstFigure_060118_2/data/L14_dataStruct_postNBQX_45-51hr.mat')
% data = dataStruct_2;
load('/Users/JimKwon/Library/Containers/com.apple.mail/Data/Library/Mail Downloads/F2787473-1A75-4B7A-8C82-07C3B0FB6E25/L12_KO_082033.mat')
data = dataStruct;
% set the xlim
% xlims = [3.949 3.9525]*10^4;
xlims = [5.50    9.20] *10^2;
sxlims = [8.213    8.217] * 10^3;
chrm = [4, 8, 9,10, 17, 18, 22, 31 , 39, 56, 58];

max_ts = 0.1;
max_ch = max(data.snips.eNe1.chan);
for ch = 1:max_ch
    if ~ismember(ch,chrm)
        ind = find(data.snips.eNe1.chan == ch);
        ts = data.snips.eNe1.ts(ind);
        plot(ts, ch*ones(size(ts)),'k.');
        hold on
        max_ts = max(max(ts),max_ts);
    end
%     if ~isempty(max_ts)
%         axis(handles.axes1,[0, max_ts, 0, max_ch+1]);
%     end
end
% set(gca,'Ydir','reverse')
xlabel('time, s')
set(gca,'ylim',[0 66])
set(gca,'xlim',xlims) % 
hold off

set(gca,'fontsize',15)
xlabel('Time (s)')
ylabel('Channels')
title('Example burst')
set(gca,'xticklabel',{'0' '10' '20' '30' '40' '50' '60'});
saveFigure('longerWindow','fig')
saveFigure('longerWindow','eps')
saveFigure('longerWindow','png')
saveFigure('longerWindow','pdf')
saveFigure('longerWindow','svg')
saveFigure('longerWindow','psc')

% shorter figure

set(gca,'xlim',sxlims);
set(gca,'xticklabel',{'0' ' ' '1' ' ' '2' ' ' '3' ''});
saveFigure('shorterWindow','fig')
saveFigure('shorterWindow','eps')
saveFigure('shorterWindow','png')
saveFigure('shorterWindow','pdf')
saveFigure('shorterWindow','svg')
saveFigure('shorterWindow','psc')

% firing rate
% stop line 45 of detectBurst and edit the figure. I know it's a hassle but
% a quick get around.

% run this when it's stopped at the previously indicated spot
figure; plot(Nm*100);
xlims = xlims*100;
xlabel('time, s')
set(gca,'xlim',xlims) %
set(gca,'fontsize',15)
xlabel('Time (s)')
ylabel('Firing Rate (Hz)')
set(gca,'xticklabel',{'0' '10' '20' '30' '40' '50' '60'});
saveFigure('FiringRate','fig')
saveFigure('FiringRate','eps')
saveFigure('FiringRate','png')
saveFigure('FiringRate','pdf')
saveFigure('FiringRate','svg')
saveFigure('FiringRate','psc')


% set(gca,'xticks',[xlim(1):0.1:xlim(2)])