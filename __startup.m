%% potential startup file
% can be copied to matlabroot or matlab's userpath or another path 
% - userpath or another path must be saved in the matlab's path  list to take effect
% - please modify antpath in this function
% -don't forget to rename this function to "startup.m"

 
function startup


antpath='o:\antx2'  ;%replace path with yours
disp(['<a href="matlab: cd(''' antpath ''');antlink">' 'add paths of [ANTx2]' '</a>' ' ']);
