


% <b> register "t2.nii" to standard-space -without GUI  </b>          
% <font color=fuchsia><u>description:</u></font>
% This script shows how to transform the "t2.nii" image of several animals to standard-space
% <b><font color=orange>select either: 
%      [1] WITHOUT ANTx-GUI or  
%      [2] WITH ANTx-GUI !! 
% </font>
% - a project-file from a study is loaded
% -from all animals in the study's "dat"-folder the "t2.nii" image of the first two animals
% is registered to standard space (aka atlas/templat-space)
% -The registraion steps are [1]initialization, [2] coregistration, [3] segmentation and [4] warping.
% Thus the "tasks" are all 4 steps: [1:4]
% <b>Input parameter for "xwarp3" </b>
% 'task',[1:4]: ... perform all registration steps
% 'autoreg',1 : ... use automatic registration for rough preregistration
% 'parfor',1, : ... use parallel processing
%  'mdirs',mdirs(:): ... cell-array containing the animal-folders for which to perform this task
%% ===============================================

% ==============================================
%%  [1] WITHOUT GUI: register to standard-space
% ===============================================
clear all
pain='F:\data5\nogui' ;              % % study-path
loadconfig(fullfile(pain,'proj.m')); % % project-file
padat=fullfile(pain,'dat') ; %       % % data-path
[dirs] = spm_select('FPList',padat,'dir');mdirs=cellstr(dirs); % % get all animals
mdirs=mdirs(1:2)  % use only the first two animals
xwarp3('batch','task',[1:4],'autoreg',1,'parfor',1,'mdirs',mdirs(:) ); % register to standard-space


% ==============================================
%%  [2] WITH GUI: register to standard-space
% ===============================================
clear all
pain='F:\data5\nogui' ;               % % study-path
ant;                                  % % open ANTx-GUI
antcb('load',fullfile(pain,'proj.m')) % % load project-file

% ====alternative options to select the animals ===========================================
% (1) using short-names
% mdirs={'1001_a1' ,'1001_a2'} ; % use this animals (animal-shortname)
% antcb('selectdirs', mdirs);    % select his animals in ANT-GUI-listbox
% (2) using fullpath-names
% mdirs={
%     'F:\data5\nogui\dat\1001_a1'  % use this animals (animal-fullpath-name)
%     'F:\data5\nogui\dat\1001_a2'
%      };
% antcb('selectdirs', mdirs);    % select his animals in ANT-GUI-listbox
% (3) select all animals
% antcb('selectdirs', 'all');
% (4) select animals via dat-folder
padat=fullfile(pain,'dat') ; %       % % data-path
[dirs] = spm_select('FPList',padat,'dir');mdirs=cellstr(dirs); % % get all animals
mdirs=mdirs(1:2)  ;% use only the first two animals
antcb('selectdirs', mdirs);

% =========alternative options to register the animals to standard-space======================================
% [1]% with additional mdir-parameter (animals)
% mdirs=antcb('getsubjects'); % get selected animals from ANT-GUI-listbox
% xwarp3('batch','task',[1:4],'autoreg',1,'parfor',1,'mdirs',mdirs(:) ); % register to standard-space
% [2] easiest way (see help for xwarp3-parameter)
xwarp3('batch','task',[1:4],'autoreg',1,'parfor',1); % register to standard-space









