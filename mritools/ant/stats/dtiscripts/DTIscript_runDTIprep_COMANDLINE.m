

%% <b> script to run DTIprep from COMMAND LINE </b>
% This script does the following:
% <b><u><font color="fuchsia"> (1) Prepare data  </font></b></u>
% -make DTI-folder & create DTIprep-struct
% -assign a sample Bruker-raw data to extract the b-tables
% -assign dti-atlas (d.DTItemplate & d.DTItemplateLUT)
% -assign DWI/DTI-files (d.DTIfileName)
% <b><u><font color="fuchsia"> (2) perform the following tasks: </font></b></u>
%   1. distribute files -> copy DTI-atlas/lutfile & b-tables to animal-dirs
%   2. deform files     -> transform DTIatlas, brainmask etc to native space
%   3. register files   -> register "t2.nii" to DWI-file, than apply trafo to native space files
%                          ("ix_"+DTIatlas, "ix"+brainmask etc)
%   4. rename files      -> rename files (names are fixed and expected from shellscripts)
%   5  export files      -> export files to #r "DTI_export4mrtrix"-folder (OPTIONAL STEP!)
%   6  check registration-> create HTML-files with overlays of images to visualize the coregistration
%                         -this step is done using the data from the 'dat'-folder (not the export-folder!)
%                         -HTML-files are stored in the "checks"-folder within the studie's folder
%                         -OPTIONAL STEP!
%
%

%% ===============================================

% [1] LOAD PROJECT
cd('H:\Daten-2\Imaging\Paul\groeschel_test'); % go to studyfolder
loadconfig(fullfile(pwd,'proj.m')); %load this project


% [2] ==== [initialize struct and import data] ====
DTIprep('delete'); %delete existing "DTI"-folder
clear d
d.brukerdata     ='H:\Daten-2\Imaging\Paul\groeschel_test\raw\20200925_132436_20200925MG_LAERMRT_MGR000027_1_1'  ; % % sample Bruker-rawdata set from one animal to obtain the b-table(s)
d.DTItemplate    ='H:\Daten-2\Imaging\Paul\groeschel_test\atl_auditsys_08dec20_v1\atl_auditsys_08dec20.nii'      ; % % DTI-atlas NIFTI-file
d.DTItemplateLUT ='H:\Daten-2\Imaging\Paul\groeschel_test\atl_auditsys_08dec20_v1\atl_auditsys_08dec20_INFO.txt' ; % % DTI-atlas txt-file with labels
d.DTIfileName    ={'q_b100.nii' 'q_b900.nii' 'q_b1600.nii' 'q_b2500.nii'}; % % filenames of the DWI/DTI-files located in animal folders
DTIprep('ini',d);  % % initialize DTIprep-struct and fill requested parameters
DTIprep('import'); % % import b-table and DTItemplate/DTItemplateLUT

% [2a] === [optional: reorder 'DTIfileName' and/or 'btable'] ====
% aim (1) 'DTIfileName'and 'btable' match in order
%     (2) appear from lowest to highest number of aqu. angles (b100,b900,b1600, b2500)
% ---------[btable] -------------
% 'H:\Daten-2\Imaging\Paul\groeschel_test\DTI\grad_b100.txt'
% 'H:\Daten-2\Imaging\Paul\groeschel_test\DTI\grad_b900.txt'
% 'H:\Daten-2\Imaging\Paul\groeschel_test\DTI\grad_b1600.txt'
% 'H:\Daten-2\Imaging\Paul\groeschel_test\DTI\grad_b2500.txt'
% ---------[DTIfileName] --------
% 'q_b100.nii'
% 'q_b900.nii'
% 'q_b1600.nii'
% 'q_b2500.nii'
% ===============================================
%if 0
%    DTIprep('reorder','b',[1 4 3 2])  ; %reoder files of 'DTIfileName'
%    DTIprep('reorder','d',[1 2 4 3])  ; %reoder files of 'btable'
%end


% [3] ==== [check if struct is filles: __INI____ is "yes"; '__IMPORT_____' is "yes"] ====
DTIprep('check'); % check struct (check if everything is initialized/imported/tasks performed)

% [4] ==== [run all tasks] ====
mdirsAll=antcb('getallsubjects');% get all animals
mdirs=mdirsAll(:)               ;% example here; use only the first animal
DTIprep('run','all',mdirs)      ;% same as: DTIprep('run',[1:6]); % for arrayNumber see help DTIprep 




