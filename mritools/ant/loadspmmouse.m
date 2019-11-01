


function loadspmmouse

mtlbfolder =fullfile(fileparts(fileparts(fileparts(which('ant.m')))),'spm12',...
    'toolbox','spmmouse');
addpath(mtlbfolder)
%  mtlbfolder = which('spmmouse');
if 0
    sprts = findstr(mtlbfolder,filesep);
    mtlbfolder=fullfile(mtlbfolder(1:sprts(end)),'mouse-C57.mat');
    spmmouse('load',mtlbfolder);
end
mousefi=fullfile(mtlbfolder,'mouse-C57.mat');
spmmouse('load',mousefi);

try
    global defaults
    global spmmouseset
    defaults.animal= spmmouseset.animal;
end