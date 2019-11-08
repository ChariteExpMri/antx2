%% potential startup file
% can be copied to matlabroot or matlab's userpath or another path 
% the copy must be renamed to "startup.m"
% - userpath or another path must be added & saved in the matlab's path list to take effect
% - please modify antpath-variable in this new "startup.m" file (do not modify the orig file "__startup.m")
% see also: https://de.mathworks.com/help/matlab/ref/startup.html?requestedDomain=de.mathworks.com

 
function startup


antpath='o:\antx2'  ;%replace path with yours
disp(['<a href="matlab: cd(''' antpath ''');antlink">' 'add paths of [ANTx2]' '</a>' ' ']);
