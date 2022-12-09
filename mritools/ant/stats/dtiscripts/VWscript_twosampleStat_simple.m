% <b> script to perform two-sample voxel-wise statistic (simple)    </b>          
% <font color=fuchsia><u>description:</u></font> 
% performs a voxelwise two-sample t-t-test for the image "JD.nii".
% - group-assignment is defined in the excelfile ('gc_CTRL_VS_HR.xlsx') located in the 'group'-folder
% - this excelfile (sheet-number:1) contains the animal-IDs ("z.mouseID_col") in the 1st column and the 
%   belonging subgroup in column-2 ("z.group_col")
% -the data ("JD.nii" for each animal) is stored in the "z.data_dir"-folder
%       -each animal has it's own directory (this is the ANT-dat-structure), 
%       -animal-IDs in the group-assignment file (excelfile) must match with the data-folder names 
% -here we use the standard atlas as defined in "z.ANO":
% -output directory is defined in "z.output_dir": here stored in the folder "voxtest1" within the 
%  study-folder
% -data will be not smoothed! (z.smoothing is "0")
% -SPM-processing windows are shown, SPM-batch is shown, 
% - SPM-batch is executed, results will be displayed 
% -execution via xstat(0,z)  ...this is the silent mode (1st arg is "0", otherwise set to "1")
% 
%% ________________________________________________________________________________________________

pastudy='F:\data5\eranet_round2_statistic\voxstat'  ;% % study-path
z=[];                                                                                                                                                                                                                           
z.stattype       = 'twosamplettest';                                    % % STATISTICAL TEST                                                                                                                                    
z.excelfile      = fullfile(pastudy, 'groups','gc_CTRL_VS_HR.xlsx')  ;  % % [Excel-file]: file containing columns with animal-IDs and group/regressionValue and optional covariates                                             
z.sheetnumber    = [1];                                                 % % sheet-index containing the data (default: 1)                                                                                                        
z.mouseID_col    = [1];                                                 % % column-index containing the animal-IDs (default: 1)                                                                                                 
z.group_col      = [2];                                                 % % column-index containing  the group assignment (default: 2)                                                                                          
z.regress_col    = [];                                                  % % <optional>  column-index/indices containing covariates (otherwise: empty)                                                                           
z.data_dir       = fullfile(pastudy,'dat');                             % % main data directory (upper directory) containing the animal-dirs (default: the "dat"-dir of the study)                                              
z.inputimage     = 'JD.nii';                                            % % name of the NIFTI-image to analyze ("data_dir" has to bee defined before using the icon)                                                            
z.AVGT           = fullfile(pastudy,'templates',  'AVGT.nii');          % % [TEMPLATE-file]: select the TEMPLATE (default: fullpath-name of "AVGT.nii" from the templates-dir)                                                  
z.ANO            = fullfile(pastudy,'templates',  'ANO.nii');           % % [ATLAS-file]: select the ATLAS (default: fullpath-name of "ANO.nii" from the templates-dir)                                                         
z.mask           = fullfile(pastudy,'templates',  'AVGThemi.nii');      % % [MASK-file]: select the brain-maskfile (default: fullpath-name of "AVGTmask.nii" from the templates-dir)                                            
z.output_dir     = fullfile(pastudy,'voxtest1') ;                       % % path of the output-directory (SPM-statistic with SPM.mat and images)                                                                                
z.smoothing      = [0];                                                 % % <optional>smooth data, [0|1]; if [1] the NIFTI is smoothed & stored with prefix "s" in the animal-dir, the smoothed image is than used for analysis 
z.smoothing_fwhm = [0.28  0.28  0.28];                                  % % smoothing width (FWHM); example: tripple of the voxsize of the inputimage                                                                           
z.showSPMwindows = [0];                                                 % % hide|show SPM-WINDOWS, [0|1]; if [0] SPM-windows are hidden                                                                                         
z.showSPMbatch   = [1];                                                 % % hide|show SPM-batch, [0|1]; usefull for evaluation and postprocessing                                                                               
z.runSPMbatch    = [1];                                                 % % run SPM-batch, [0|1]; if [0] you have to start the SPM-batch by yourself,i.e hit the green triangle, [1] batch runs automatically                   
z.showResults    = [1];                                                 % % show results; [0|1]; if [1] voxelwise results will be shown afterwards                                                                              
xstat(0,z); 

