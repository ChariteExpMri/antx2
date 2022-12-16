
% <b> run voxelwise statistic for all DWI-images and summarize results (PowerPoint-/Excel-files) </b>  
% <font color=fuchsia><u>DESCRIPTION:</u></font> 
% [1] a factorial design is used as described in group-assignment file 'groupassignmentFactorial.xlsx' 
% [2] The voxelwise statistic is performed over all images in the "img"-variable (cell)
% [3] When done, a FULL-REPORT is made, i.e. resulting TABLES(XLS-FILES) & SUMMARIES (PPT-FILES) are
%    written for the methods: [1]FWE, [2]CLUSTERBASED-APPROACH AND [3]UNCORRECTED at p=0.001 for 
%    ALL CONTRASTS
% The output is stored in the 'voxstat'-folder. Here for each image a subfolder (image-name) is created
% Summaries are stored in the respective folder: "res_"+image-name
% <font color=red><u> ... COPY ENTIRE CONTENT AND MODIFY ACCODINGLY..</u></font>

% ==============================================
%%   for all images
% ===============================================

pamain     ='H:\Daten-2\Imaging\AG_Groeschel_LAERMRT';       %PLEASE MODIFY: THE STUDY-FOLDER
paout      =fullfile(pamain,'voxstat');                      %PLEASE MODIFY: THE MAIN-OUTPUT-FOLDER   
groupfile  =fullfile(pamain,'group','groupassignmentFactorial.xlsx' ); %PLEASE MODIFY: NAME OF THE GROUP-ASSIGNMENT FILE

img={            %PLEASE MODIFY: THE IMAGES TO RUN THE VOXWISE ANALYSIS (MUST BE IN STANDARD-SPACE)
    'x_ad.nii'
    'x_c1t2.nii'
    'x_rd.nii'
    'x_adc.nii'
    'x_fa.nii'
    'x_t2.nii'
    };

if exist(paoutmain)~=7; mkdir(paoutmain); end
for i=1:length(img)
    
    [~,imgNameShort]=fileparts(img{i});
    
    z=[];
    z.stattype       = 'fullfactorial';           % % STATISTICAL TEST
    z.excelfile      = groupfile;                 % % [Excel-file]: file containing columns with animal-IDs and group/regressionValue and optional covariates
    z.sheetnumber    = [1];                                           % % sheet-index containing the data (default: 1)
    z.mouseID_col    = [1];                                           % % column-index containing the animal-IDs (default: 1)
    z.group_col      = [2:3];                                         % % column-index containing  the group assignment (default: 2)
    z.regress_col    = [];                                            % % <optional>  column-index/indices containing covariates (otherwise: empty)
    z.data_dir       = fullfile(pamain,'dat');                        % % main data directory (upper directory) containing the animal-dirs (default: the "dat"-dir of the study)
    z.inputimage     = img{i}   ;                                     % % name of the NIFTI-image to analyze ("data_dir" has to bee defined before using the icon)
    z.AVGT           = fullfile(pamain, 'templates', 'AVGT.nii');     % % [TEMPLATE-file]: select the TEMPLATE (default: fullpath-name of "AVGT.nii" from the templates-dir)
    z.ANO            = fullfile(pamain, 'templates', 'ANO.nii');      % % [ATLAS-file]: select the ATLAS (default: fullpath-name of "ANO.nii" from the templates-dir)
    z.mask           = fullfile(pamain, 'templates', 'AVGTmask.nii'); % % [MASK-file]: select the brain-maskfile (default: fullpath-name of "AVGTmask.nii" from the templates-dir)
    z.output_dir     = fullfile(paout, ['vx_' imgNameShort] )  ;      % % path of the output-directory (SPM-statistic with SPM.mat and images)
    z.smoothing      = [1];                                           % % <optional>smooth data, [0|1]; if [1] the NIFTI is smoothed & stored with prefix "s" in the animal-dir, the smoothed image is than used for analysis
    z.smoothing_fwhm = [0.28  0.28  0.28];                            % % smoothing width (FWHM); example: tripple of the voxsize of the inputimage
    z.showSPMwindows = [1];                                           % % hide|show SPM-WINDOWS, [0|1]; if [0] SPM-windows are hidden
    z.showSPMbatch   = [1];                                           % % hide|show SPM-batch, [0|1]; usefull for evaluation and postprocessing
    z.runSPMbatch    = [1];                                           % % run SPM-batch, [0|1]; if [0] you have to start the SPM-batch by yourself,i.e hit the green triangle, [1] batch runs automatically
    z.showResults    = [1];                                           % % show results; [0|1]; if [1] voxelwise results will be shown afterwards
    xstat(0,z);                                                       % % Do not show GUI!
    
    xstat('fullreport');    % % MAKE FULL-REPORT, WRITE TABLES(XLS-FILES) & SUMMARIES (PPT-FILES), FOR [1]FWE,[2]CLUSTERBASED-APPROACH AND [3]UNCORRECTED, FOR ALL CONTRASTS
end



