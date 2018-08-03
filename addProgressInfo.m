function addProgressInfo(listLen,i,increments)

% This function takes in whatever is being looped in the for loop and
% displays the progress of it. 

if nargin < 3
    increments = 21;
end

marki = floor(linspace(1,listLen,increments));

if ismember(i,marki)
    disp(['Currently finished analyzing ' num2str(floor(i/listLen*100)) '% of the data'])
end
