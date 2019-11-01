
% help antx2update_sub

function antx2update_sub(varargin);



if nargin==0;
    help(mfilename); 
    return
end   

% ==============================================
%%   check input Type
% ===============================================

if length(varargin)>1
    par=cell2struct(varargin(2:2:end),varargin(1:2:end),2);
else
    if exist(varargin{1})==2
        par=load(varargin{1});par=par.par;
    else
        help(mfilename)
        return
    end
end

if 0
   antx2update('C:\Users\skoch\Desktop\github4\getTBX2\antx2update_temp\updatepara.mat') 
end

if ~isfield(par,'tempdir');      par.tempdir=fileparts(which(mfilename));   end
if    ~isfield(par,'antpath');   par.antpath=''                            ;end
    
if isempty(par.antpath)
    if isfield(par,'updatedir');
        par.antpath=fileparts(fileparts(par.updatedir)); %from updatefolder
    else
        par.antpath= fullfile(fileparts(par.tempdir),'antx2'); %from temp-folder --> critical because of TBX-naming/renaming
    end
end
    
disp(par);

% ===========================================================================
    %     antx2update_sub('C:\Users\skoch\Desktop\github4\getTBX2\antx2update_temp\updatepara.mat')
    % or
    %
    %     antx2update_sub('keepgit',1,'clone',0,'cloneforce',0)
    % or
    %      antx2update_sub('?'); for help
    
% ===========================================================================
check=checkgit;
if check==0; return; end

%-----------------------------------
'a'
par=checkANTXdir(par);
par=checkdotGIT(par);
par=checkCloningNecessary(par);

disp(par);


par=gitupdate(par);


return


function par=gitupdate(par);
% ==============================================
%%   [2] update client local side
% 24 files deleted: 6s
% ===============================================
if par.cloneforce==0
    % git branch --set-upstream-to=origin master
    % git init
    
    % git config --global user.name "pstkoch"
    % git config --global user.email “pstkoch@googlemail.com"
    
    % cd(fullfile('C:\Users\skoch\Desktop\github2\repo2\getTBX2','antx2'))
    paantx=par.antpath;
    atime=tic;
    cd(paantx);
    if exist('.git','dir')~=7
        disp('version control (".git") folder has been removed previously');
        disp('set [keepVersionControl] to true and re-clone repository')
    end
    
    
    fprintf(['updating using version control (".git")..please wait..\n']);
    git reset --hard HEAD;
    git pull;
    fprintf(['updating..done t=%2.3f min\n'],toc(atime)/60);
    
    
    % check before
    %     git fetch
    %     git diff master origin/master
    %     git diff --compact-summary master origin/master
end


function par=checkCloningNecessary(par);
if par.isDIRantx2==0; par.cloneforce =1;  end %HAVE TO CLONE  -dir is missing
if par.isDOTgit  ==0; par.cloneforce =1;  end %HAVE TO CLONE  -".git is missing


function par=checkANTXdir(par);
if exist(par.antpath)==7 && exist(fullfile(par.antpath,'mritools'))
    par.isDIRantx2=1;
else
    par.isDIRantx2=0;
end

function par=checkdotGIT(par);
if exist(fullfile(par.antpath,'.git'))==7 
    par.isDOTgit=1;
else
    par.isDOTgit=0;
end


function check=checkgit
check=1;
[er erlog]=system('git --version');
if isempty(strfind(erlog,'version')); %check GIT
    disp('GIT not installed') ; 
    check=0 ; return
else
    disp('..GIT installed [OK]') ;
end
if exist('git','file')==0; %check GIT
    disp('GIT-matlab function not installed') ;
    check=0; return
else
    disp('..GIT-matlab installed [OK]') ;
end







return
% ======================================================================
% ======================================================================
%%                     [2] DOWNLOAD                     
% ======================================================================
% ======================================================================
% ==============================================
%%    [1] clone  TBX
% 1st time: 308.056391 seconds.-->5min
% ===============================================
pamain='C:\Users\skoch\Desktop\github4\getTBX2';

clone     =1;
cloneforce=0;
keepgit     =1;  % keep version control(.git folder)

% -------------------
paantx=fullfile(pamain,'antx2');
cd(pamain);





if exist('antx2','dir')==0  ; %dir does not exist
    cloneforce=1;
elseif exist('antx2','dir')==7
    if exist(fullfile(paantx,'.git'))==0; %.git does not exist
        cloneforce=1;
    end
end

if exist('antx2','dir')==7 && cloneforce==1
    atime=tic;
    fprintf(['deleting old repository..please wait..']);
    rmdir(paantx,'s');
    fprintf(['done t=%2.3f min\n'],toc(atime)/60);
end
    
    



if cloneforce==1
    atime=tic;
    fprintf(['cloning repository..please wait..']);
    %%%%% git clone --depth=1 https://github.com/pstkoch/antx2.git
    % git clone https://github.com/pstkoch/antx2.git
    
    git clone --depth=1 https://github.com/pstkoch/antx2.git
    fprintf(['done t=%2.3f min\n'],toc(atime)/60);
    
    
    if keepgit==0
        atime=tic;
        fprintf(['removing version control (".git")..please wait..']);
        try; rmdir(fullfile(paantx,'.git'),'s');end
        fprintf(['done t=%2.3f min\n'],toc(atime)/60);
    end
end

% ==============================================
%%   [2] update client local side
% 24 files deleted: 6s
% ===============================================
if cloneforce==0
    % git branch --set-upstream-to=origin master
    % git init
    
    % git config --global user.name "pstkoch"
    % git config --global user.email “pstkoch@googlemail.com"
    
    % cd(fullfile('C:\Users\skoch\Desktop\github2\repo2\getTBX2','antx2'))
    atime=tic;
    cd(paantx);
    if exist('.git','dir')~=7
        disp('version control (".git") folder has been removed previously');
        disp('set [keepVersionControl] to true and re-clone repository')
    end
    
    
    fprintf(['updating using version control (".git")..please wait..\n']);
    git reset --hard HEAD;
    git pull;
    fprintf(['updating..done t=%2.3f min\n'],toc(atime)/60);
    
    
  % check before  
%     git fetch
%     git diff master origin/master
%     git diff --compact-summary master origin/master
end

% ==============================================
%%   prune on source
% ===============================================


% git checkout --orphan freshBranch
% git add -A
% git commit
% git branch -D master 
% git branch -m master 
% git push -f origin master 
% git gc --aggressive --prune=all
% git push -f origin master
