% update via GUT 
% 
% antx2update('?') HELP

function antx2update(varargin)

if nargin==0
    if 0
        s      =input('cloning [0,1]: ', 's');
        clone=str2num(s);
        s      =input('cloneforce [0,1]: ', 's');
        cloneforce=str2num(s);
        s     =input('keepgit [0,1]: ', 's');
        keepgit=str2num(s);
    end
    
    if ~exist('clone'     ,'var') || isempty(clone)      ; clone     =0; end
    if ~exist('cloneforce','var') || isempty(cloneforce) ; cloneforce=0; end
    if ~exist('keepgit'   ,'var') || isempty(keepgit);   ; keepgit   =1; end
    
    par.clone       = clone;
    par.cloneforce  = cloneforce;
    par.keepgit     = keepgit;
    par.antpath     = fileparts(which('antlink2.m'));%[ANTX-SUBDIR,] might be empty !!!
 
    par.updatedir   = fileparts(which('antx2update_sub.m')); %[AN`TX-UPDATE-DIR],always EXIST!!
    par.tempdir     = fullfile(fileparts(fileparts(fileparts(par.updatedir))),'antx2update_temp');%[TEMP-PATH FOR CLONING]
    
    par.parafile    = fullfile(par.tempdir,'updatepara.mat');
    
    
    copyfile(par.updatedir,par.tempdir,'f');   %COPY UPDATEDIR
    save(par.parafile,'par');                  %SAVE PARAMETER
    
    try; antlink(0); end
    cd(par.tempdir);
    
    if exist(fullfile(fileparts(par.tempdir),'masterdrive.txt'))==2
        disp(['cannot update master-drive, location "' fileparts(par.tempdir) '"-drive' ]);
        return
        
    end
    
    antx2update_sub(par.parafile);
    
    return
end





