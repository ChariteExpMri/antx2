function dtipath
% add subfolder-path to matlabpath

thisdir=regexprep(which(mfilename),{mfilename,[ filesep '.m']},{'' ,''});
addpath(genpath(thisdir));
% disp('..PATHS:  [ANT/MRITOOLS] added to matlab-path');

% k=(dir(thisdir))