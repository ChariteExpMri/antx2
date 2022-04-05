
% <b> warp GM-image of all animals to standard-space, than,  export the new image to a new folder   </b>          
% <font color=fuchsia><u>description:</u></font>
% The gray-matter image ("c1t2.nii") of all animals of a study is transformed to standard-space.
% For this we use linear interpolation (4th input arg of 'doelastix')
% The resulting image is "x_c1t2.nii"
% In a subsequent step the GM-image in standard-space is exported to a new folder
% the export-folder is "H:\Daten-2\Imaging\AG_Winter\round1234\dat" 
% Here, the animal-folder structure is preserved

% ==============================================
%%  [1] transform GM-image to standard-space
% ===============================================
pain='H:\Daten-2\Imaging\AG_Winter\round4'; %study-path
antcb('load',fullfile(pain,'proj_pk.m')); % load project

%% [1] __deform GM_image to SS__
antcb('selectdirs','all');  % select all animals
mdirs=antcb('getsubjects'); % get selected animals
F1={'c1t2.nii'}           ; % image(s) to transform
doelastix(1, mdirs,F1,1,'local' ,struct('source','intern')); %transform image in "F1" to standard space(1st arg is "1"), for animal in "mdir", using linear interpolaton("1")

% ==============================================
%%  [2] export GM-image (standard-space) to a new folder
% ===============================================
z=[];                                                                                                                                                                                                             
z.sourcePath          = pain;                                          % % source path: this folder will be recursively checked                                                                                   
z.fileNames           = { 'x_c1t2.nii' };                              % % filenames recoursively searched in "sourcePath" to export                                                                              
z.destinationPath     = 'H:\Daten-2\Imaging\AG_Winter\round1234';      % % destination path to export files, required to fill                                                                                    
exportfiles(0,z);     % % export files