



%% uses other spm (xspm) for display (freiburg is broken)
function useotherspm(arg)
warning off;


if exist('arg')==0;
    arg=1;
end

if arg==1 %add
    dirx=fullfile( fileparts(fileparts(fileparts(which('ant.m')))) , 'xspm8' );
    addpath(dirx);
    
    old=fullfile(fileparts(fileparts(fileparts(which('ant.m')))),'freiburgLight\matlab\spm8\');
    rmpath(genpath(old))
elseif arg==0 %remove
    
    dirx=fullfile( fileparts(fileparts(fileparts(which('ant.m')))) , 'xspm8' );
    rmpath(genpath(dirx));
    
    new=fullfile(fileparts(fileparts(fileparts(which('ant.m')))),'freiburgLight\matlab\spm8\');
    addpath(genpath(new))
else
    error('cant use other SPMversion');
end


%spmmouse('load',which('mouse-C57.mat'))