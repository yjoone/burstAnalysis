function allData = getAllMEAData(filePath)

if nargin < 1
    filePath = '/Users/JimKwon/Documents/WennerLab_MATLAB_Collaboration/MEA data/Data/BurstAnalysis';
end

d = dir(filePath);
allData = NaN;
for i = 3:length(d)
    if d(i).isdir
        dd = dir(fullfile(filePath,d(i).name));
        data = getDataFromDir(dd);
        if isstruct(allData)
            allData = [allData, data];
        else
            allData = data;
        end
    end
end
end

function [data] = getDataFromDir(Dir)
dd = Dir;
data = struct;
currLine = 1;

    for i = 3:length(dd)
        name = dd(i).name;
        
        if length(name) > 3 % get rid of short named files
            notData = 0;
        else
            notData = 1;
%            data = NaN;
        end
        
        if ~notData && strcmp(name(end-3:end),'.mat')
            load(fullfile(dd(i).folder,dd(i).name));
            wsdir = who;
            wsdirlen = length(wsdir);

            for j = 1:wsdirlen % get dataStruct variations
                curVarName = wsdir{j};
                if length(curVarName) > 4
                    notData = 0;
                else
                    notData = 1;
%                    data = NaN;
                end
                if ~notData && strcmp(wsdir{j}(1:5),'dataS')
                    eval(['data_temp = ' wsdir{j} ';']);
                    dataDir = dd(i).folder;
                    data(currLine).data = data_temp;
                    data(currLine).fileName = name;
                    data(currLine).dir = dataDir;
                    currLine = currLine+1;
                end
            end
        end
        
    end
    
    
    
    % final default for data
    if ~exist('data')
        data = NaN;
    end
    
   
end