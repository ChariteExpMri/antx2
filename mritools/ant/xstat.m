%% xstat: voxelwise statistic [SPM-statistic] for normalized data (nifti volumes)
%
% #yk xstat.m
%% #b performs voxelwise (univariate) statistic and displays the results onto mouse template
%% #b The anatmical regions will be displayed and the table with anat. regions is created
% #g [SETUP]
% - This function reads an excelfile containing mouse-ids (i.e. the mousefolders) and depending on the
%    model a column for group assignment/columns of factors or covariate/regression values
% #r Excel file example : see ~\antx\mritools\ant\docs\xstat-statistic-example.xlsx
% - select the statistic you want to perform (currently implemented):
%   'pairedttest'       : comparing two timepoints or two different parameters from the same mouse across mice (* pre vs post treatment)
%   'twosamplettest'    : comparing two independet groups   (* disease group vs control group)
%   'regression'        : voxelwise regression (data from one group) with a vector (* age or performance)
%   'onewayanova'       : comparing two or more independet groups (* control vs. sham vs. disease)
%                         onewayanova allows one/more additional covariates (* age, gender..) to add to the model
%   'onewayanova_within': comparing a group over time , example (time1, time2, time3)
%   'fullfactorial'     : Anova with several factors, default: between (between and or within).
%   'userdefined'       :define one of the following designs from SPM (see <spm-->[batch]-->>spm/stats/Factorial design specification)
%       One-sample t-test, Two-sample t-test, Paired t-test, Multiple regression, One-way ANOVA,
%       One-way ANOVA - within subject, Full factorial, Flexible factorial
% #g [VIEW RESULTS]
% -if a model has been created/estimated (see [setup]) the [VIEW RESULTS] panel allows to visualize the results
% [load SPM]: load a SPM.mat -this mat-file contains all data, additonal parameters must be applied
% [load 1st Contrast]: loads the first contrast with default paramters (no other parameters will be needed)
% [contrasts]: the pulldown menu allows to switch between contrasts (see also SPM's "Interactive"-window: menu>>Contrasts>change contrast)
% [show sections]: overlay the results onto a defined template (default: Allen's AVGT.nii)
% [show table]: displays the table of significant voxels/clusters with anat. regions
% [cl-dist]: minimum distance between cluster
% [#max/cluster]: number of maxima for each cluster
%   [#max/cluster] & [cl-dist] strongly change the resulting table !!
% [export table]: saves the statistical table
% [save volume]: saves the thresholded (based on FWE/FDR + cluster-size threshold "k") statistical volume as nifti (mostly t-map)
% [show MRICRON]: if statistical map is save, this button alllows to show the overlay og the template image and the statistical map using Mricron
% ______________________________________________________________________________________________
%% #ky PARAMETERS:
% -parameters differ slightly between designs, see examples below
%  xstat(1,z); /xstat(0,z);    : runs this functions with/without opening the gui,  submits the parameterstruct [z]
% ______________________________________________________________________________________________
%% #ky EXAMPLES:
%% ===============================================
% % #g TWO-SAMPLE-T-TEST
%% ===============================================
% z=[];                                                                                                                                                                                                                           
% z.stattype       = 'twosamplettest';                                    % % STATISTICAL TEST                                                                                                                                    
% z.excelfile      = 'F:\data6\voxwise\group\groupassignment_covars.xlsx';     % % [Excel-file]: file containing columns with animal-IDs and group/regressionValue and optional covariates                                             
% z.sheetnumber    = [1];                                                 % % sheet-index containing the data (default: 1)                                                                                                        
% z.mouseID_col    = [1];                                                 % % column-index containing the animal-IDs (default: 1)                                                                                                 
% z.group_col      = [2];                                                 % % column-index containing  the group assignment (default: 2)                                                                                          
% z.regress_col    = [];                                                  % % <optional>  column-index/indices containing covariates (otherwise: empty)                                                                           
% z.data_dir       = 'F:\data6\voxwise\dat';                              % % main data directory (upper directory) containing the animal-dirs (default: the "dat"-dir of the study)                                              
% z.inputimage     = 'vimg.nii';                                          % % name of the NIFTI-image to analyze ("data_dir" has to bee defined before using the icon)                                                            
% z.AVGT           = 'F:\data6\voxwise\templates\AVGT.nii';               % % [TEMPLATE-file]: select the TEMPLATE (default: fullpath-name of "AVGT.nii" from the templates-dir)                                                  
% z.ANO            = 'F:\data6\voxwise\templates\ANO.nii';                % % [ATLAS-file]: select the ATLAS (default: fullpath-name of "ANO.nii" from the templates-dir)                                                         
% z.mask           = 'F:\data6\voxwise\templates\AVGThemi.nii';           % % [MASK-file]: select the brain-maskfile (default: fullpath-name of "AVGTmask.nii" from the templates-dir)                                            
% z.output_dir     = 'voxtest1_NOcovars';                                 % % path of the output-directory (SPM-statistic with SPM.mat and images)                                                                                
% z.smoothing      = [1];                                                 % % <optional>smooth data, [0|1]; if [1] the NIFTI is smoothed & stored with prefix "s" in the animal-dir, the smoothed image is than used for analysis 
% z.smoothing_fwhm = [0.28  0.28  0.28];                                  % % smoothing width (FWHM); example: tripple of the voxsize of the inputimage                                                                           
% z.showSPMwindows = [0];                                                 % % hide|show SPM-WINDOWS, [0|1]; if [0] SPM-windows are hidden                                                                                         
% z.showSPMbatch   = [1];                                                 % % hide|show SPM-batch, [0|1]; usefull for evaluation and postprocessing                                                                               
% z.runSPMbatch    = [1];                                                 % % run SPM-batch, [0|1]; if [0] you have to start the SPM-batch by yourself,i.e hit the green triangle, [1] batch runs automatically                   
% z.showResults    = [1];                                                 % % show results; [0|1]; if [1] voxelwise results will be shown afterwards                                                                              
% xstat(0,z);   
%% ===============================================
% % #g  PAIRED T-TEST
%% ===============================================
% z=[];                                                                                                                                                                                                                                           
% z.stattype       = 'pairedttest';                                                       % % STATISTICAL TEST                                                                                                                                    
% z.excelfile      = 'F:\data6\voxtestPairedTtest\group\groupassignment_covars.xlsx';     % % [Excel-file]: file containing columns with animal-IDs and group/regressionValue and optional covariates                                             
% z.sheetnumber    = [1];                                                                 % % sheet-index containing the data (default: 1)                                                                                                        
% z.mouseID_col    = [1];                                                                 % % column-index containing the animal-IDs (default: 1)                                                                                                 
% z.group_col      = [2];                                                                 % % column-index containing  the group assignment (default: 2)                                                                                          
% z.regress_col    = [];                                                                  % % <optional>  column-index/indices containing covariates (otherwise: empty)                                                                           
% z.data_dir       = 'F:\data6\voxtestPairedTtest\dat';                                   % % main data directory (upper directory) containing the animal-dirs (default: the "dat"-dir of the study)                                              
% z.inputimage     = 'vimg.nii';                                                          % % name of the NIFTI-image to analyze ("data_dir" has to bee defined before using the icon)                                                            
% z.AVGT           = 'F:\data6\voxtestPairedTtest\templates\AVGT.nii';                    % % [TEMPLATE-file]: select the TEMPLATE (default: fullpath-name of "AVGT.nii" from the templates-dir)                                                  
% z.ANO            = 'F:\data6\voxtestPairedTtest\templates\ANO.nii';                     % % [ATLAS-file]: select the ATLAS (default: fullpath-name of "ANO.nii" from the templates-dir)                                                         
% z.mask           = 'F:\data6\voxtestPairedTtest\templates\AVGTmask.nii';                % % [MASK-file]: select the brain-maskfile (default: fullpath-name of "AVGTmask.nii" from the templates-dir)                                            
% z.output_dir     = 'voxtest1_NOcovars';                                                 % % path of the output-directory (SPM-statistic with SPM.mat and images)                                                                                
% z.smoothing      = [1];                                                 % % <optional>smooth data, [0|1]; if [1] the NIFTI is smoothed & stored with prefix "s" in the animal-dir, the smoothed image is than used for analysis 
% z.smoothing_fwhm = [0.28  0.28  0.28];                                  % % smoothing width (FWHM); example: tripple of the voxsize of the inputimage                                                                           
% z.showSPMwindows = [0];                                                 % % hide|show SPM-WINDOWS, [0|1]; if [0] SPM-windows are hidden                                                                                         
% z.showSPMbatch   = [1];                                                 % % hide|show SPM-batch, [0|1]; usefull for evaluation and postprocessing                                                                               
% z.runSPMbatch    = [1];                                                 % % run SPM-batch, [0|1]; if [0] you have to start the SPM-batch by yourself,i.e hit the green triangle, [1] batch runs automatically                   
% z.showResults    = [1];                                                 % % show results; [0|1]; if [1] voxelwise results will be shown afterwards                                                                              
% xstat(0,z);  
%% ===============================================
% % #g       ONE-WAY-ANOVA
%% ===============================================
% z=[];                                                                                                                                                                                                                                                    
% z.stattype       = 'onewayanova';                                                                % % STATISTICAL TEST                                                                                                                                    
% z.excelfile      = 'F:\data6\voxwise_1wayANOVA\group\groupassignment_1wayANOVA_covars.xlsx';     % % [Excel-file]: file containing columns with animal-IDs and group/regressionValue and optional covariates                                             
% z.sheetnumber    = [1];                                                                          % % sheet-index containing the data (default: 1)                                                                                                        
% z.mouseID_col    = [1];                                                                          % % column-index containing the animal-IDs (default: 1)                                                                                                 
% z.group_col      = [2];                                                                          % % column-index containing  the group assignment (default: 2)                                                                                          
% z.regress_col    = [];                                                                           % % <optional>  column-index/indices containing covariates (otherwise: empty)                                                                           
% z.data_dir       = 'F:\data6\voxwise_1wayANOVA\dat';                                             % % main data directory (upper directory) containing the animal-dirs (default: the "dat"-dir of the study)                                              
% z.inputimage     = 'vimg.nii';                                                                   % % name of the NIFTI-image to analyze ("data_dir" has to bee defined before using the icon)                                                            
% z.AVGT           = 'F:\data6\voxwise_1wayANOVA\templates\AVGT.nii';                              % % [TEMPLATE-file]: select the TEMPLATE (default: fullpath-name of "AVGT.nii" from the templates-dir)                                                  
% z.ANO            = 'F:\data6\voxwise_1wayANOVA\templates\ANO.nii';                               % % [ATLAS-file]: select the ATLAS (default: fullpath-name of "ANO.nii" from the templates-dir)                                                         
% z.mask           = 'F:\data6\voxwise_1wayANOVA\templates\AVGTmask.nii';                          % % [MASK-file]: select the brain-maskfile (default: fullpath-name of "AVGTmask.nii" from the templates-dir)                                            
% z.output_dir     = 'voxtest1_nocovars';                                                          % % path of the output-directory (SPM-statistic with SPM.mat and images)                                                                                
% z.smoothing      = [1];                                                 % % <optional>smooth data, [0|1]; if [1] the NIFTI is smoothed & stored with prefix "s" in the animal-dir, the smoothed image is than used for analysis 
% z.smoothing_fwhm = [0.28  0.28  0.28];                                  % % smoothing width (FWHM); example: tripple of the voxsize of the inputimage                                                                           
% z.showSPMwindows = [0];                                                 % % hide|show SPM-WINDOWS, [0|1]; if [0] SPM-windows are hidden                                                                                         
% z.showSPMbatch   = [1];                                                 % % hide|show SPM-batch, [0|1]; usefull for evaluation and postprocessing                                                                               
% z.runSPMbatch    = [1];                                                 % % run SPM-batch, [0|1]; if [0] you have to start the SPM-batch by yourself,i.e hit the green triangle, [1] batch runs automatically                   
% z.showResults    = [1];                                                 % % show results; [0|1]; if [1] voxelwise results will be shown afterwards                                                                              
% xstat(0,z); 
%% ===============================================
% % #g       within ONE-WAY-ANOVA WITH COVARIATES
%% ===============================================
% z=[];                                                                                                                                                                                                                                                    
% z.stattype       = 'onewayanova_within';                                                         % % STATISTICAL TEST                                                                                                                                    
% z.excelfile      = 'F:\data6\voxwise_1wayANOVA\group\groupassignment_1wayANOVA_covars.xlsx';     % % [Excel-file]: file containing columns with animal-IDs and group/regressionValue and optional covariates                                             
% z.sheetnumber    = [1];                                                                          % % sheet-index containing the data (default: 1)                                                                                                        
% z.mouseID_col    = [1];                                                                          % % column-index containing the animal-IDs (default: 1)                                                                                                 
% z.group_col      = [2];                                                                          % % column-index containing  the group assignment (default: 2)                                                                                          
% z.regress_col    = [3  4];                                                                       % % <optional>  column-index/indices containing covariates (otherwise: empty)                                                                           
% z.data_dir       = 'F:\data6\voxwise_1wayANOVA\dat';                                             % % main data directory (upper directory) containing the animal-dirs (default: the "dat"-dir of the study)                                              
% z.inputimage     = 'vimg.nii';                                                                   % % name of the NIFTI-image to analyze ("data_dir" has to bee defined before using the icon)                                                            
% z.AVGT           = 'F:\data6\voxwise_1wayANOVA\templates\AVGT.nii';                              % % [TEMPLATE-file]: select the TEMPLATE (default: fullpath-name of "AVGT.nii" from the templates-dir)                                                  
% z.ANO            = 'F:\data6\voxwise_1wayANOVA\templates\ANO.nii';                               % % [ATLAS-file]: select the ATLAS (default: fullpath-name of "ANO.nii" from the templates-dir)                                                         
% z.mask           = 'F:\data6\voxwise_1wayANOVA\templates\AVGTmask.nii';                          % % [MASK-file]: select the brain-maskfile (default: fullpath-name of "AVGTmask.nii" from the templates-dir)                                            
% z.output_dir     = 'voxtest2_within_covars';                                                     % % path of the output-directory (SPM-statistic with SPM.mat and images)                                                                                
% z.smoothing      = [1];                                                 % % <optional>smooth data, [0|1]; if [1] the NIFTI is smoothed & stored with prefix "s" in the animal-dir, the smoothed image is than used for analysis 
% z.smoothing_fwhm = [0.28  0.28  0.28];                                  % % smoothing width (FWHM); example: tripple of the voxsize of the inputimage                                                                           
% z.showSPMwindows = [0];                                                 % % hide|show SPM-WINDOWS, [0|1]; if [0] SPM-windows are hidden                                                                                         
% z.showSPMbatch   = [1];                                                 % % hide|show SPM-batch, [0|1]; usefull for evaluation and postprocessing                                                                               
% z.runSPMbatch    = [1];                                                 % % run SPM-batch, [0|1]; if [0] you have to start the SPM-batch by yourself,i.e hit the green triangle, [1] batch runs automatically                   
% z.showResults    = [1];                                                 % % show results; [0|1]; if [1] voxelwise results will be shown afterwards                                                                              
% xstat(0,z);  
%% ===============================================
% % #g  MULTIPLE REGRESSION   (WITH TWO REGRESSION-SCORES)
%% ===============================================
% z=[];                                                                                                                                                                                                                                          
% z.stattype       = 'regression';                                                       % % STATISTICAL TEST                                                                                                                                    
% z.excelfile      = 'F:\data6\voxwise_regression\group\groupassignment_multi.xlsx';     % % [Excel-file]: file containing columns with animal-IDs and group/regressionValue and optional covariates                                             
% z.sheetnumber    = [1];                                                                % % sheet-index containing the data (default: 1)                                                                                                        
% z.mouseID_col    = [1];                                                                % % column-index containing the animal-IDs (default: 1)                                                                                                 
% z.regress_col    = [2  3];                                                             % % <optional>  column-index/indices containing covariates (otherwise: empty)                                                                           
% z.data_dir       = 'F:\data6\voxwise_regression\dat';                                  % % main data directory (upper directory) containing the animal-dirs (default: the "dat"-dir of the study)                                              
% z.inputimage     = 'vimg.nii';                                                         % % name of the NIFTI-image to analyze ("data_dir" has to bee defined before using the icon)                                                            
% z.AVGT           = 'F:\data6\voxwise_regression\templates\AVGT.nii';                   % % [TEMPLATE-file]: select the TEMPLATE (default: fullpath-name of "AVGT.nii" from the templates-dir)                                                  
% z.ANO            = 'F:\data6\voxwise_regression\templates\ANO.nii';                    % % [ATLAS-file]: select the ATLAS (default: fullpath-name of "ANO.nii" from the templates-dir)                                                         
% z.mask           = 'F:\data6\voxwise_regression\templates\AVGTmask.nii';               % % [MASK-file]: select the brain-maskfile (default: fullpath-name of "AVGTmask.nii" from the templates-dir)                                            
% z.output_dir     = 'voxtest1_mutli';                                                   % % path of the output-directory (SPM-statistic with SPM.mat and images)                                                                                
% z.smoothing      = [1];                                                 % % <optional>smooth data, [0|1]; if [1] the NIFTI is smoothed & stored with prefix "s" in the animal-dir, the smoothed image is than used for analysis 
% z.smoothing_fwhm = [0.28  0.28  0.28];                                  % % smoothing width (FWHM); example: tripple of the voxsize of the inputimage                                                                           
% z.showSPMwindows = [0];                                                 % % hide|show SPM-WINDOWS, [0|1]; if [0] SPM-windows are hidden                                                                                         
% z.showSPMbatch   = [1];                                                 % % hide|show SPM-batch, [0|1]; usefull for evaluation and postprocessing                                                                               
% z.runSPMbatch    = [1];                                                 % % run SPM-batch, [0|1]; if [0] you have to start the SPM-batch by yourself,i.e hit the green triangle, [1] batch runs automatically                   
% z.showResults    = [1];                                                 % % show results; [0|1]; if [1] voxelwise results will be shown afterwards                                                                              
% xstat(0,z);          
%% ===============================================
% % #g  FULLFACTTORIAL ANOVA with 2 covariates
%% ===============================================
% z=[];                                                                                                                                                                                                                                                        
% z.stattype       = 'fullfactorial';                                                                % % STATISTICAL TEST                                                                                                                                      
% z.excelfile      = 'F:\data6\voxwise_fullfactorial\group\groupassignment_fullfac_covars.xlsx';     % % [Excel-file]: file containing columns with animal-IDs and group/regressionValue and optional covariates                                               
% z.sheetnumber    = [1];                                                                            % % sheet-index containing the data (default: 1)                                                                                                          
% z.mouseID_col    = [1];                                                                            % % column-index containing the animal-IDs (default: 1)                                                                                                   
% z.group_col      = [2  3];                                                                         % % column-index containing  the group assignment (default: 2)                                                                                            
% z.regress_col    = [4  5];                                                                         % % <optional>  column-index/indices containing covariates (otherwise: empty)                                                                             
% z.data_dir       = 'F:\data6\voxwise_fullfactorial\dat';                                           % % main data directory (upper directory) containing the animal-dirs (default: the "dat"-dir of the study)                                                
% z.inputimage     = 'vimg.nii';                                                                     % % name of the NIFTI-image to analyze ("data_dir" has to bee defined before using the icon)                                                              
% z.AVGT           = 'F:\data6\voxwise_fullfactorial\templates\AVGT.nii';                            % % [TEMPLATE-file]: select the TEMPLATE (default: fullpath-name of "AVGT.nii" from the templates-dir)                                                    
% z.ANO            = 'F:\data6\voxwise_fullfactorial\templates\ANO.nii';                             % % [ATLAS-file]: select the ATLAS (default: fullpath-name of "ANO.nii" from the templates-dir)                                                           
% z.mask           = 'F:\data6\voxwise_fullfactorial\templates\AVGTmask.nii';                        % % [MASK-file]: select the brain-maskfile (default: fullpath-name of "AVGTmask.nii" from the templates-dir)                                              
% z.output_dir     = 'voxtest1_covars';                                                              % % path of the output-directory (SPM-statistic with SPM.mat and images)                                                                                  
% z.smoothing      = [1];                                                 % % <optional>smooth data, [0|1]; if [1] the NIFTI is smoothed & stored with prefix "s" in the animal-dir, the smoothed image is than used for analysis 
% z.smoothing_fwhm = [0.28  0.28  0.28];                                  % % smoothing width (FWHM); example: tripple of the voxsize of the inputimage                                                                           
% z.showSPMwindows = [0];                                                 % % hide|show SPM-WINDOWS, [0|1]; if [0] SPM-windows are hidden                                                                                         
% z.showSPMbatch   = [1];                                                 % % hide|show SPM-batch, [0|1]; usefull for evaluation and postprocessing                                                                               
% z.runSPMbatch    = [1];                                                 % % run SPM-batch, [0|1]; if [0] you have to start the SPM-batch by yourself,i.e hit the green triangle, [1] batch runs automatically                   
% z.showResults    = [1];                                                 % % show results; [0|1]; if [1] voxelwise results will be shown afterwards                                                                              
% xstat(0,z);                                                                                                                                                                                                                                             
%             
% ______________________________________________________________________________________________
%% #ky batch:
% #g RE-USE BATCH: see 'anth' [..anthistory] variable in workspace
%
%% #ok *** PROGRAMMABEL POST-HOC CHANGES *** 
% 
%% #ko Programmatically load a SPM-stiastic
% xstat('loadspm',fullfile(pwd,'SPM.mat')); %if pwd is path to SPM-folder
% or
% xstat('loadspm',pwd);                     %if pwd is path to SPM-folder
% 
%% #ko Programmatically set parameter and show result
% the example below sets the following parameter
% 'MCP','none', : set multiple-comparison to 'none' (..uncorrected)
%                 options: {'none','MCP','FWE'}
% 'thresh',0.001: set p-threshold to 0.001
% 'clk',1       : set clustersize k=1
% 'con',1       : use 1st contrast here
%                options: standard: 1 or 2 or another number the corresponding
%                contrast was previously defined 
% 'show',1      : show result, i.e. update SPM-Graphics 
%                 options: [1]update SPM-Graphics, [0] do not update
% #g example: 
%  xstat('set',struct('MCP','none','thresh',0.001,'clk',1,'con',1,'show',1)); 
% 
%% #ko Programmatically set parameter & save output as powerpoint-file
% #b example to programatically change paramteres and save PPT
% con=1  % or 2  %contrast-to display/to save as PPT
% PPTFILE:  fullpath-file for PPT to save the result
% DOC:  'new'or 'add'  (new PPTdoc...overwrite old one or append to existing PPT)
% bgcol: PPT-slide backgroundcolor (default is [1 1 1]; i.e. white)
% % [1]uncorrected  -------
%% #m set parameter, but do not update SPM-Graphics
% xstat('set',struct('MCP','none','thresh',0.001,'clk',1,'con',con,'show',0));
%% #m display TABLE --> make statistical table in powerpoint
% xstat('report',PPTFILE,struct('doc',DOC,'con',con,'bgcol',bgcol  ));
%  ---optional output: obtain resulting output file and info-struct
% [fiout gg]=xstat('report',PPTFILE,struct('doc',DOC,'con',con,'bgcol',bgcol  ));;
%% #m display volume --> make orthoview volume-plot in powerpoint
% xstat('report',PPTFILE,struct('show','volume','doc','add','con',con,'bgcol',bgcol  ));
%
% % [2]uncorrected with clusterSize-estimation -------
% clustersize = cp_cluster_Pthresh(xSPM, 0.001)
% xstat('set',struct('MCP','none','thresh',0.001,'clk',clustersize,'con',con,'show',0));
% xstat('report',PPTFILE,struct('doc','add','con',con,'bgcol',bgcol    ));
%
% % [3]FDR-CORRECTION-------
% xstat('set',struct('MCP','FDR','thresh',0.05,'clk',1,'con',con,'show',0));
% xstat('report',PPTFILE,struct('doc','add','con',con,'bgcol',bgcol    ));
% 
% % [4]FWE-CORRECTION-------
% xstat('set',struct('MCP','FWE','thresh',0.05,'clk',20,'con',con,'show',0));
% xstat('report',PPTFILE,struct('doc','add','con',con,'bgcol',bgcol    ));
%
%% DELETE EXISTING CONTRASTS
% HIT [deleteC]-button to select Contrasts in a new GUI which will be removed from the SPM.mat
% xstat('deletecontrast')         ;%delete contrast from SPM-mat,selected by subsequent GUI
% xstat('deletecontrast','all')   ;%delete all existing contrast from SPM-mat
% xstat('deletecontrast',[1 3])   ;%delete contrast s1 and 3 from SPM-mat
% 
%% #ko Programmatically write staistical table as TXT-file or Excel-file
% howto: xstat('export', path/filename, *struct)
% 'export': command to access the export-routine
%  path/filename: 
%      filename: output-filename (fullpath)
%      path - if output path is specified only the filename is constructed 
%             using the followong internal paramters:   
%                  inputFile, contrastName, statMethod(FDR,uncorr..), 
%                   stat.threshold & k-clusterSize
%  struct: <optional> with additional parameter
%     'type'   - save as: {numeric value}, [1] excelfile or [2] textfile
%     'prefix' - <optional> add prefix string  to fileName
%
%% #wb programmatically save as *TXT-file*
%% save as file 'testZ.txt' as TXT-file (type=2)
%  xstat('export',fullfile(pwd,'testZ.txt'),struct('type',2));
%  ---optional output: obtain resulting output file and info-struct
% [fiout gg]=xstat('export',fullfile(pwd,'testZ.txt'),struct('type',2));
%% save as file ('x_c_radial_dif__1ko2ko_GT_1wt2ko__FWE0.txt'), filename
%% is constructed from internal parameter , as TXT-file (type=2)
%  xstat('export',pwd,struct('type',2));
%% save as file ('myPrefix_x_c_radial_dif__1ko2ko_GT_1wt2ko__FWE0.txt'),
%% filename is constructed from internal parameter , as TXT-file (type=2),
%% add prefix 'myPrefix_'
%  xstat('export',pwd,struct('type',2,'prefix','myPrefix_'));
%% save as file 'myPrefix_testZ2.txt' as TXT-file (type=2), add prefix 'myPrefix_'
%  xstat('export',fullfile(pwd,'testZ2.txt'),struct('type',2,'prefix','myPrefix_'));
% 
%% #wb programmatically save as *EXCEL-file*
%% save as file 'testZ.xlsx' as Excel-file
%  xstat('export',fullfile(pwd,'testZ.xlsx'))
%% same as...
%  xstat('export',fullfile(pwd,'testZ.xlsx'),struct('type',1));
%% save as file ('x_c_radial_dif__1ko2ko_GT_1wt2ko__FWE0.xlsx'), filename
%% is constructed from internal parameter , as Excel-file (type=1)
%  xstat('export',pwd);
%% same as..
%  xstat('export',pwd,struct('type',1));
%% save as file ('myPrefix_x_c_radial_dif__1ko2ko_GT_1wt2ko__FWE0.xlsx'),
%% filename is constructed from internal parameter , as Excel-file (type=1),
%% add prefix 'myPrefix_'
%  xstat('export',pwd,struct('type',1,'prefix','myPrefix_'));
%% save as file 'myPrefix_testZ3.txt' as Excel-file (type=1), add prefix 'myPrefix_'
%  xstat('export',fullfile(pwd,'testZ3.txt'),struct('type',1,'prefix','myPrefix_'));
% 
%% #ko Programmatically save thresholded volume
% howto: xstat('savevolume', path/filename, *struct)
% 'savevolume': command to access the savevolume-routine
%  path/filename: 
%      filename: output-filename (fullpath)
%      path - if output path is specified only the filename is constructed 
%             using the followong internal paramters:   
%                  inputFile, contrastName, statMethod(FDR,uncorr..), 
%                   stat.threshold & k-clusterSize
%  struct: <optional> with additional parameter
%     'prefix' - <optional> add prefix string  to fileName
% 
%% save thresholded Volume as "dum2.nii"
%  xstat('savevolume',fullfile(pwd,'dum2.nii'));
%% save thresholded volume in current path with filename contructed based on
%% internal parameter (InputImage,contrast-name,correctionMethoc,threshold,clusterSize)
%% fileName here is  "x_c_radial_dif__1ko2ko_GT_1wt2ko__none0.nii"
%  xstat('savevolume',pwd);
%  ---optional output: obtain resulting output file and info-struct
% [fiout gg]=xstat('savevolume',pwd);
%% .. as previous example but prefix 'myPrefix_' is added to outputfile
%% Filename is "myPrefix_x_c_radial_dif__1ko2ko_GT_1wt2ko__none0.nii"
%  xstat('savevolume',pwd,struct('prefix','myPrefix_'));
%% save thresholded volume as "myPrefix_dum3.nii"
%  xstat('savevolume',fullfile(pwd,'dum3.nii'),struct('prefix','myPrefix_'))
%
% #wb *** REPAIR MIP-FILE / CHANGE POSTHOC-ATLAS ***
% #m see <b> xstat-MENU: misc/create MIP,change Atlas
% type :  xstat('repairMIP?')          to obtain help
%% ________________________________________________________________________________________________
%% EXAMPLES
%% ________________________________________________________________________________________________
% [extract data]: extract single animal data based on the results.table
% xstat('extractdata');                                              % extract data and store in predefined folder and predefined filename:  stored folder: [res_+"SPManalysisfolder"/data]
% xstat('extractdata','path',pwd,'filename','_extractedData.xlsx');  % ...with specified path and filename of outputfile
% xstat('extractdata',struct('isGUI',1)) ;                           %extract data, user specifies path and filename of outputfile via GUI
%% ________________________________________________________________________________________________
% [savevolume]: save result-based threholded volume
% xstat('savevolume');      %store NIFTI in predefined pwd with predefined name
% xstat('savevolume',pwd);  %store NIFTI in pwd with predefined name
% xstat('savevolume',fullfile(pwd,'result2.nii')); save NIFTI with user-defined path/name
%% ________________________________________________________________________________________________
% [export XLSfile]: save resultsTable as Excelfile
% xstat('export');                                    %save table as Excelfile with predefined path/name
% xstat('export',pwd);                                %save table as Excelfile with user-defined path and predefined name
% xstat('export' ,fullfile(pwd,'result_123.xlsx'));   %save table as Excelfile with userdefined path/name
%% ________________________________________________________________________________________________
% [make full report]: make powerpoint file, save results as excelfile and NIFTI-file
% xstat('fullreport');     %SIMPLEST,  write fullreport, all methods(uncor, cluster-based, FWE), for all contrast,  write xls-files and nifti-files
% xstat('fullreport',struct('method',[1 2 3],'xls',0,'nifti',0)); % all methods,for all contrast, do not save xls-file/NIfti-file
% xstat('fullreport',struct('method',[3],'con',[1],'xls',0,'nifti',0)) ;% FWE only for contrast-1, no nifti, no xls-file written
% xstat('fullreport',struct('method',[3],'con',[1],'xls',1,'nifti',1)) % same but write xls-file and nifti-file
% xstat('fullreport',struct('method',[3],'con',[1],'xls',1,'nifti',1)) % same but write xls-file and nifti-file
% xstat('fullreport',struct('method',[2],'con',[1:2],'xls',0,'nifti',0)); % clusterbased approch for contrast 1 & 2, do not save xls-file/NIfti-file
% xstat('fullreport',struct('method',[2],'xls',0,'nifti',0)); % clusterbased approch for all contrast, do not save xls-file/NIfti-file



% ==============================================
%%   
% ===============================================


%% ________________________________________________________________________________________________
% modifications in spm
% spm_figure('close',allchild(0));   % line 347

%voxelvise statistic
function varargout=xstat(showgui,x,s )

if nargin>0
    
    
    % xstat('loadspm','O:\data2\x03_yildirim\fullfac_fakedata_4')
    % xstat('report','results_FDR')
    if ~isnumeric(showgui)
        if strcmp(showgui, 'repairMIP');
            if exist('x')~=1; x=1       ; end
            if exist('s')~=1; s=struct(); end
            repairMIP(x,s);
        end
        if strcmp(showgui, 'repairMIP?');
             repairMIP_help();         
        end
        
        if strcmp(showgui, 'report');
            if nargin==1; x=[];end
            [fiout g]=report(x,s) ;
            varargout{1}=fiout;
            varargout{2}=g;
        end
        if strcmp(showgui, 'loadspm');
            if nargin==1; x=[];end
            loadspm(x) ;
        end
        if strcmp(showgui, 'set');
            setparam(x);
        end
        if strcmp(showgui, 'export');
            if nargin==2;
               [fiout g]= export(x,[]);
            else
                if nargin==1;
                    s.filename=-1;
                    x=[];
                end
               [fiout g]= export(x,s);
            end 
            varargout{1}=fiout;
            varargout{2}=g;
        end
        if strcmp(showgui, 'savevolume');
            fiout=[];
            if nargin==2;
                [fiout g]=savevolume(x,[]);
            else
                if nargin==1;
                   s.filename=-1; 
                   x=[];
                end
                [fiout g]=savevolume(x,s);
            end
            varargout{1}=fiout;
            varargout{2}=g;
        end
        if strcmp(showgui, 'extractdata');
            fiout=[]; g=[];
           % x.dummi1=1;
           x.dummi=1;
           [fiout g]= extractdata(x);
           varargout{1}=fiout;
           varargout{2}=g;
        end
        
        if strcmp(showgui, 'deletecontrast');
            if exist('x')==0; x=[];            end
            deleteContrasts([],[],x);
        end
        %-------------------------internal: obtain group-file +data ---------------
        if strcmp(showgui, 'obtainGroupfile');
            isOK=readexcel(x);
            varargout{1}=isOK;
            % runcmd: isOK=xstat('obtainGroupfile','twosamplettest');
        end
        %-------------------------internal: %make batch for statistical models -------
        if strcmp(showgui, 'makeBatch');  
            fmakebatch('xstat' );
            % runcmd: xstat('makeBatch')
        end
        %-------------------------internal: setUP SPM -------
        if strcmp(showgui, 'spmsetup');
            if exist('x')~=1
                spmsetup;
            else
                if exist('s')==1
                    visualmode=s;
                    spmsetup(x,visualmode)
                end
            end
            % runcmd: isOK=xstat('obtainGroupfile','twosamplettest');
        end
        
        if strcmp(showgui, 'fullreport');
            fiout=[]; g=[];
            if exist('x')~=1;         x.dummi=1;         end
           summary_contrastAllMethods(x);
%            x.dummi=1;
%            [fiout g]= extractdata(x);
%            varargout{1}=fiout;
%            varargout{2}=g;
        end
        
        return
    end
end

% function [fileout gg]=export(file,s)
% fileout=[];
% gg=   struct([]);


types={'regression' 'pairedttest' 'twosamplettest' 'onewayanova' 'fullfactorial' 'onewayanova_within'};

global xvv;
fs=7;
try
   fs=xvv.fs; 
end

clear global xvv;
global xvv;
xvv={};
xvv.fs=fs;


%———————————————————————————————————————————————
%%   PARAMS
%———————————————————————————————————————————————
if exist('showgui')==0 || isempty(showgui) ;    showgui=1                   ;end
if exist('x')==0                           ;    x=[]                        ;end




if 0
    
    
    % % ••••••••••••••••••••••••••••••••••••••••••••••••••••••
    % % #g FUNCTION:        [xstat.m]
    % % #b info :             modifications in spm
    % % ••••••••••••••••••••••••••••••••••••••••••••••••••••••
    z=[];
    z.stattype      = 'pairedttest';                                                     % % STATISTICAL TEST
    z.excelfile     = 'O:\data\voxelwise_Maritzen4tool\Maritzen_Animal_groups.xlsx';     % % [Excelfile]: this file contains two columns with mouseIDs (names) for timepoint T1 and T2, respectively
    z.sheetnumber   = [1];                                                               % % this sheet contains columns with mouseIDs and group assignment
    z.mouseID_colT1 = [8];                                                               % % column number with the MouseIDs for T1
    z.mouseID_colT2 = [9];                                                               % % column number with the MouseIDs for T2
    z.data_dir      = 'O:\data\voxelwise_Maritzen4tool\dat';                             % % data directory (upper directory) contains dirs with mice data
    z.inputimage    = 'JD.nii';                                                          % % image name (nifti) to run the statistic (datapath has to bee defined before using the icon)
    z.mask          = 'O:\data\voxelwise_Maritzen4tool\templates\AVGTmask.nii';          % % <optional> use brainmask [select a mask or type "local" to use the AVGTmask.nii from the templates folder]
    z.output_dir    = 'tests1';                                                          % % path for output/statistic
    z.showSPMbatch  = [0];                                                               % % [0|1] hide|show pipeline in SPM batch window, if [1] you have to run the code by yourself ( hit the green driangle), [0] piples runs automatically
    xstat(0,z);
    
    % % ••••••••••••••••••••••••••••••••••••••••••••••••••••••
    % % #g FUNCTION:        [xstat.m]
    % % #b info :             modifications in spm
    % % ••••••••••••••••••••••••••••••••••••••••••••••••••••••
    z=[];
    z.stattype       = 'twosamplettest';                                                  % % STATISTICAL TEST
    z.excelfile      = 'O:\data\voxelwise_Maritzen4tool\Maritzen_Animal_groups.xlsx';     % % [Excelfile]: this file contains a column with mouseIDs (names) and a column assigning the group
    z.sheetnumber    = [1];                                                               % % this sheet contains columns with mouseIDs and group assignment
    z.mouseID_col    = [1];                                                               % % column number with the MouseIDs
    z.group_col      = [2];                                                               % % column number with group assignment  (used when comparing groups, "regress_col" must be empty)
    z.data_dir       = 'O:\data\voxelwise_Maritzen4tool\dat';                             % % data directory (upper directory) contains dirs with mice data
    z.inputimage     = 'JD.nii';                                                          % % image name (nifti) to run the statistic (datapath has to bee defined before using the icon)
%     z.grp_comparison = '1vs2';                                                            % % groups to compare
    z.mask           = 'O:\data\voxelwise_Maritzen4tool\templates\AVGTmask.nii';          % % <optional> use brainmask [select a mask or type "local" to use the AVGTmask.nii from the templates folder]
    z.output_dir     = 'tests2';                                                           % % path for output/statistic
    z.showSPMbatch   = [0];                                                               % % [0|1] hide|show pipeline in SPM batch window, if [1] you have to run the code by yourself ( hit the green driangle), [0] piples runs automatically
    xstat(0,z);
    
    % % ••••••••••••••••••••••••••••••••••••••••••••••••••••••
    % % #g FUNCTION:        [xstat.m]
    % % #b info :             modifications in spm
    % % ••••••••••••••••••••••••••••••••••••••••••••••••••••••
    z=[];
    z.stattype     = 'regression';                                                      % % STATISTICAL TEST
    z.excelfile    = 'O:\data\voxelwise_Maritzen4tool\Maritzen_Animal_groups.xlsx';     % % [Excelfile]: this file contains a column with mouseIDs (names) and a column with regression values
    z.sheetnumber  = [1];                                                               % % this sheet contains columns with mouseIDs and regression values
    z.mouseID_col  = [1];                                                               % % column number with the MouseIDs
    z.regress_col  = [4];                                                               % % column number with regression values (used for multiple regression,"group_col" must be empty)
    z.data_dir     = 'O:\data\voxelwise_Maritzen4tool\dat';                             % % data directory (upper directory) contains dirs with mice data
    z.inputimage   = 'JD.nii';                                                          % % image name (nifti) to run the statistic (datapath has to bee defined before using the icon)
    z.mask         = 'O:\data\voxelwise_Maritzen4tool\templates\AVGTmask.nii';          % % <optional> use brainmask [select a mask or type "local" to use the AVGTmask.nii from the templates folder]
    z.output_dir   = 'tests3';                                                      % % path for output/statistic
    z.showSPMbatch = [0];                                                               % % [0|1] hide|show pipeline in SPM batch window, if [1] you have to run the code by yourself ( hit the green driangle), [0] piples runs automatically
    xstat(0,z);
    
    
    
    %   ONE-WAY-ANOVA
    % % ••••••••••••••••••••••••••••••••••••••••••••••••••••••
    % % #g FUNCTION:        [xstat.m]
    % % #b info :             FFT Discrete Fourier transform.
    % % ••••••••••••••••••••••••••••••••••••••••••••••••••••••
    z=[];
    z.stattype     = 'onewayanova';                                                     % % STATISTICAL TEST
    z.excelfile    = 'O:\data\voxelwise_Maritzen4tool\Maritzen_Animal_groups.xlsx';     % % [Excelfile]: this file contains a column with mouseIDs (names) and a column with regression values
    z.sheetnumber  = [2];                                                               % % this sheet contains columns with mouseIDs and regression values
    z.mouseID_col  = [1];                                                               % % column number with the MouseIDs
    z.group_col    = [3];                                                               % % column number with group assignment  (used when comparing groups)
    z.regress_col  = [4  5];                                                            % % <optional> column number(s) with regression values,otherwise empty (examples: age+gender --> regression columns are [4 5])
    z.data_dir     = 'O:\data\voxelwise_Maritzen4tool\dat';                             % % data directory (upper directory) contains dirs with mice data
    z.inputimage   = 'JD.nii';                                                          % % image name (nifti) to run the statistic (datapath has to bee defined before using the icon)
    z.mask         = 'O:\data\voxelwise_Maritzen4tool\templates\AVGTmask.nii';          % % <optional> use brainmask [select a mask or type "local" to use the AVGTmask.nii from the templates folder]
    z.output_dir   = 'anov44';                                                          % % path for output/statistic
    z.showSPMbatch = [1];                                                               % % [0|1] hide|show pipeline in SPM batch window, if [1] you have to run the code by yourself ( hit the green driangle), [0] piples runs automatically
    xstat(1,z);
    
    
    %   ONE-WAY-ANOVA-TEST2
    % % ••••••••••••••••••••••••••••••••••••••••••••••••••••••
    % % #g FUNCTION:        [xstat.m]
    % % #b info :             FFT Discrete Fourier transform.
    % % ••••••••••••••••••••••••••••••••••••••••••••••••••••••
    z=[];
    z.stattype     = 'onewayanova';                                                     % % STATISTICAL TEST
    z.excelfile    = 'O:\data\voxelwise_Maritzen4tool\Maritzen_Animal_groups.xlsx';     % % [Excelfile]: this file contains a column with mouseIDs (names) and a column with regression values
    z.sheetnumber  = [3];                                                               % % this sheet contains columns with mouseIDs and regression values
    z.mouseID_col  = [1];                                                               % % column number with the MouseIDs
    z.group_col    = [2];                                                               % % column number with group assignment  (used when comparing groups)
    z.regress_col  = [];                                                            % % <optional> column number(s) with regression values,otherwise empty (examples: age+gender --> regression columns are 4&5)
    z.data_dir     = 'O:\data\voxelwise_Maritzen4tool\dat';                             % % data directory (upper directory) contains dirs with mice data
    z.inputimage   = 'JD.nii';                                                          % % image name (nifti) to run the statistic (datapath has to bee defined before using the icon)
    z.mask         = 'O:\data\voxelwise_Maritzen4tool\templates\AVGTmask.nii';          % % <optional> use brainmask [select a mask or type "local" to use the AVGTmask.nii from the templates folder]
    z.output_dir   = 'anov_example2';                                                          % % path for output/statistic
    z.showSPMbatch = [1];                                                               % % [0|1] hide|show pipeline in SPM batch window, if [1] you have to run the code by yourself ( hit the green driangle), [0] piples runs automatically
    xstat(1,z);
    
    
    %   ONE-WAY-ANOVA
    % % ••••••••••••••••••••••••••••••••••••••••••••••••••••••
    % % #g FUNCTION:        [xstat.m]
    % % #b info :             FFT Discrete Fourier transform.
    % % ••••••••••••••••••••••••••••••••••••••••••••••••••••••
    z=[];
    z.stattype     = 'fullfactorial';                                                     % % STATISTICAL TEST
    z.excelfile    = 'O:\data2\x03_yildirim\voxstatGroups_2x2.xlsx';     % % [Excelfile]: this file contains a column with mouseIDs (names) and a column with regression values
    z.sheetnumber  = [1];                                                               % % this sheet contains columns with mouseIDs and regression values
    z.mouseID_col  = [1];                                                               % % column number with the MouseIDs
    z.group_col    = [3 4];                                                               % % column number with group assignment  (used when comparing groups)
    z.regress_col  = [];                                                            % % <optional> column number(s) with regression values,otherwise empty (examples: age+gender --> regression columns are [4 5])
    z.data_dir     = 'O:\data2\x03_yildirim\dat';                             % % data directory (upper directory) contains dirs with mice data
    z.inputimage   = 'JD.nii';                                                          % % image name (nifti) to run the statistic (datapath has to bee defined before using the icon)
    z.mask         = 'O:\data2\x03_yildirim\templates\AVGTmask.nii';          % % <optional> use brainmask [select a mask or type "local" to use the AVGTmask.nii from the templates folder]
    z.output_dir   = 'v01_fullfactorial';                                                          % % path for output/statistic
    z.showSPMbatch = [1];                                                               % % [0|1] hide|show pipeline in SPM batch window, if [1] you have to run the code by yourself ( hit the green driangle), [0] piples runs automatically
    xstat(1,z);
    
end

%———————————————————————————————————————————————
%%   BACKUP
%———————————————————————————————————————————————


if 0
    %% EXAMPLE: PAIRED TTEST
    
    
    showgui=1
    
    x={};
    x.stattype =     'pairedttest';
    x.excelfile=     { 'O:\data\voxelwise_Maritzen4tool\Maritzen_Animal_groups.xlsx' };	% [Excelfile]: this file contains two columns with mouseIDs (names) for timepoint T1 and T2, respectively
    x.sheetnumber=   [1];	% this sheet contains columns with mouseIDs and group assignment
    x.mouseID_colT1= [8];	% column number with the MouseIDs for T1
    x.mouseID_colT2= [9];	% column number with the MouseIDs for T2
    x.data_dir=      'O:\data\voxelwise_Maritzen4tool\dat';	% data directory (upper directory) contains dirs with mice data
    x.inputimage=    'JD.nii';	% image name (nifti) to run the statistic (datapath has to bee defined before using the icon)
    x.mask=          'local';	% <optional> use brainmask [select a mask or type "local" to use the AVGTmask.nii from the templates folder]
    x.output_dir=    'test_2';	% path for output/statistic
    xstat(showgui,x)
    
    
    %% 2sampleTtest
    x={};
    x.stattype =     'twosamplettest';
    x.excelfile=      { 'O:\data\voxelwise_Maritzen4tool\Maritzen_Animal_groups.xlsx' };	% [Excelfile]: this file contains a column with mouseIDs (names) and a column assigning the group
    x.sheetnumber=    [1];	% this sheet contains columns with mouseIDs and group assignment
    x.mouseID_col=    [1];	% column number with the MouseIDs
    x.group_col=      [2];	% column number with group assignment
    x.data_dir=       'O:\data\voxelwise_Maritzen4tool\dat';	% data directory (upper directory) contains dirs with mice data
    x.inputimage=     { 'JD.nii' };	% image name (nifti) to run the statistic (datapath has to bee defined before using the icon)
%     x.grp_comparison='1vs2'	;% groups to compare
    x.output_dir=     'res_3';	% path for
    xstat(showgui,x)
    
    
    %%   multiple regression
    x={};
    x.stattype =     'regression';
    x.excelfile=   { 'O:\data\voxelwise_Maritzen4tool\Maritzen_Animal_groups.xlsx' };	% [Excelfile]: this file contains a column with mouseIDs (names) and a column assigning the group
    x.sheetnumber= [1];	% this sheet contains columns with mouseIDs and group assignment
    x.mouseID_col= [1];	% column number with the MouseIDs
    x.regress_col= [4];	% column number with regression values (used for multiple regression,"group_col" must be empty)
    x.data_dir=    'O:\data\voxelwise_Maritzen4tool\dat';	% data directory (upper directory) contains dirs with mice data
    x.inputimage=  'JD.nii';	% image name (nifti) to run the statistic (datapath has to bee defined before using the icon)
    x.mask=        'local';	% <optional> use brainmask [select a mask or type "local" to use the AVGTmask.nii from the templates folder]
    x.output_dir=  'regress_33';	% path for output/statistic
    xstat(showgui,x)
    
end






s={};


hfig=findobj(0,'tag','vvstat');
if ~isempty(hfig)
    set(hfig,'CloseRequestFcn',[]);
    delete(hfig);
    
    % delete(findobj(0,'tag','vvstat'));
end
useotherspm(1);

fg;
set(gcf,'tag','vvstat','menubar','none','units','norm','name','xstat','NumberTitle','off');
set(gcf,'position',[0.7049    0.4189    0.1503    0.4667]    ); %figure

% ==============================================
%%   menu
% ===============================================

hu = uimenu(gcf,'Label','misc');
h1 = uimenu(hu,'Label','find cluster-size threshold at p=0.001', 'Callback',{@miscTask,'findClusterTresh,p0.001'});
h1 = uimenu(hu,'Label','find cluster-size threshold, at userdefined  p-value', 'Callback',{@miscTask,'findClusterTresh,user'});
h1 = uimenu(hu,'Label','create MIP,change Atlas', 'Callback',{@miscTask,'repairMIP'},'separator','on');

hu = uimenu(gcf,'Label','posthoc');
h1 = uimenu(hu,'Label','<html>create summary of <font color=blue>current<font color=black> contrast',        ...
    'Callback',{@posthoc,'summary_thiscontrast'});
h1 = uimenu(hu,'Label','<html>create summary <font color=fuchsia>all<font color=black> contrasts',            ...
    'Callback',{@posthoc,'summary_allcontrasts'});
h1 = uimenu(hu,'Label','<html>create summary & export tables of <font color=blue>current<font color=black> contrast',...
    'Callback',{@posthoc,'summary_thiscontrastFull'},'separator','on');
h1 = uimenu(hu,'Label','<html>create summary & export tables <font color=fuchsia>all<font color=black> contrasts', ...
    'Callback',{@posthoc,'summary_allcontrastsFull'});
h1 = uimenu(hu,'Label','<html><font color=red>all methods<font color=black> summary & export tables <font color=red>all<font color=black> contrasts', ...
    'Callback',{@posthoc,'summary_allcontrastsallMethods'});


% ==============================================
%%   help
% ===============================================
h2=uicontrol('style','pushbutton','units','norm') ;      %HELP
set(h2, 'string','help','callback',@helphere);
set(h2, 'position',[0 .0 .15 .05],'fontsize',6);
set(h2,'tooltipstring','help for this gui');

% % ==============================================
% %%   scripts
% % ===============================================
% 
% h2=uicontrol('style','pushbutton','units','norm') ;      
% set(h2, 'string','scripts','callback',@scripts_call);
% set(h2, 'position',[0.0043616 0.098779 0.2 0.05],'fontsize',7,'foregroundcolor',[0 0 1]);
% set(h2,'tooltipstring',['<html><b>collection of scripts</b><br>' ...
%     'open scripts-gui with collection of scripts<br>'...
%     '-scripts can be costumized and applied']);
% ==============================================
%%   setup
% ===============================================
h2=uicontrol('style','text','units','norm');            % SETUP  -TXT
set(h2, 'string','Setup');
set(h2, 'position',[0.008982 0.95348 0.8 0.05]);
set(h2,'tooltipstring','read groups from excelfile','backgroundcolor','w','fontweight','bold',...
    'HorizontalAlignment','left');

% h2=uicontrol('style','pushbutton','units','norm') ;      %READ GROUPS-excel
% set(h2, 'string','read group [xls]','callback',@readexcel);
% set(h2, 'position',[.01 .8 .5 .05]);
% set(h2,'tooltipstring','read groups from excelfile');


h2=uicontrol('style','pushbutton','units','norm') ;     %INDEpSTAT
set(h2,'string', 'indepStat','callback',@twosampleTest);
set(h2,'position',[0 0.9249 .3 .05]);
set(h2,'tooltipstring','independent/2-sample t-test');

h2=uicontrol('style','pushbutton','units','norm')   ;   %DEPSTAT
set(h2,'string', 'depStat','callback', @pairedsampleTest);
set(h2,'position',[.3 0.9249 .3 .05]);
set(h2,'tooltipstring','dependend/paired t-test');



h2=uicontrol('style','pushbutton','units','norm')   ;   %onewayanova
set(h2,'string', '1xANOVA','callback', @onewayanova);
set(h2,'position',[0 .875 .3 .05]);
set(h2,'tooltipstring','one-way-anova','fontsize',7);

h2=uicontrol('style','pushbutton','units','norm')   ;   %onewayanova-within
set(h2,'string', '1xANOVA-within','callback', @onewayanova_within);
set(h2,'position',[0.3 0.875 0.3 0.05]);
set(h2,'tooltipstring','one-way-anova within subjects','fontsize',7);


h2=uicontrol('style','pushbutton','units','norm')   ;   %fullfactorial
set(h2,'string', 'fullfactorial','callback', @fullfactorial);
set(h2,'position',[-0.00025874 0.80825 0.3 0.05]);
set(h2,'tooltipstring','full-factorial model ','fontsize',7);

h2=uicontrol('style','pushbutton','units','norm')   ;   %fullfactorial
set(h2,'string', 'flex.factorial','callback', @flexfactorial);
set(h2,'position',[0.3 0.80825 0.3 0.05]);
set(h2,'tooltipstring','flexible-factorial model','fontsize',7);


h2=uicontrol('style','pushbutton','units','norm')   ;   %fullfactorial
set(h2,'string', 'add contrasts','callback', @addcontrast);
set(h2,'position',[0.0043616 0.77492 0.3 0.03]);
set(h2,'tooltipstring','<html>for fullfactorial design only: <br> add additional contrasts from textfile',...
    'fontsize',7,'foregroundcolor',[0 .5 1]);

h2=uicontrol('style','pushbutton','units','norm')   ;   %multiple regression
set(h2,'string', 'm. regression','callback', @multipleregression);
set(h2,'position',[0.6 .925 .3 .05]);
set(h2,'tooltipstring','multiple regression','fontsize',7);

h2=uicontrol('style','pushbutton','units','norm')   ;  %USERDEFINED
set(h2,'string', 'userdefined','callback',@userdefined);
set(h2,'position',[[0.6697 0.82492 0.3 0.05]]);
set(h2,'tooltipstring','build your own analysis');
% ==============================================
%%   view results GUI
% ===============================================

h2=uicontrol('style','text','units','norm');            % SHOW RESULTS  -TXT
set(h2, 'string','View Results');
set(h2, 'position',[.01 .62 .8 .05]);
set(h2,'tooltipstring','view results','backgroundcolor','w','fontweight','bold',...
    'HorizontalAlignment','left');


h2=uicontrol('style','text','units','norm');            % SPM-path
set(h2, 'string','PATH: <>','fontsize',6,'foregroundcolor',[0 0 1]);
set(h2, 'position',[.01 .595 .7 .03]);
set(h2,'tooltipstring','view results','backgroundcolor','w','fontweight','bold',...
    'HorizontalAlignment','left','tag', 'txtpath');


%% ———————— preselection ———————————————————————————————————————
h2=uicontrol('style','popupmenu','units','norm') ;      %TXT
set(h2, 'position',[0 .49 .15 .05]);
set(h2, 'position',[0 .485 .19 .05],'fontsize',7);
set(h2,'tag','selcorecttion');
set(h2,'tooltipstring','select statistical correction method here');
%%
lis={...
    'uncorrected at 0.001, clustersize=1'     {'none' '0.001'  '1' }
    'uncorrected at 0.001, clustersize=100'   {'none' '0.001'  '100' }
    'uncorrected at 0.005, clustersize=1'     {'none' '0.005'  '1' }
    'uncorrected at 0.005, clustersize=100'   {'none' '0.005'  '100' }
    'uncorrected at 0.0001, clustersize=1'    {'none' '0.0001' '1' }
    'uncorrected at 0.0001, clustersize=100'  {'none' '0.0001' '100' }
    'FWE at 0.05, clustersize=1'              {'FWE'  '0.05'   '1' }
    'FWE at 0.01, clustersize=1'              {'FWE'  '0.01'   '1' }
    'FWE at 0.001, clustersize=1'             {'FWE'  '0.001'  '1' }
    'FDR at 0.05, clustersize=1'              {'FDR'  '0.05'   '1' }
    'clusterbased, at 0.001'                  {'none' '0.001'  '1'}   
    'clusterbased, at 0.0005'                 {'none' '0.0005'   '1'}
    'clusterbased, at 0.0001'                 {'none' '0.0001'   '1'}
    };
set(h2,'string',lis(:,1));
set(h2,'userdata',lis,'callback',@radio_selectStatCorect);
%%


%% ———————— MCP ———————————————————————————————————————
ttip=['multiple comparison problem' char(10) 'adjust p value to control FWE,FDR or none'];
h2=uicontrol('style','text','units','norm') ;      %TXT
set(h2, 'position',[0.2 .5 .11 .05]);
set(h2,'tooltipstring',ttip);
set(h2,'string','MCP','fontsize',6,'backgroundcolor','w');
set(h2,'HorizontalAlignment','left','fontweight','bold');


h2=uicontrol('style','edit','units','norm') ;      %number ofT
set(h2, 'position',[0.2 .5 .1 .03]);
set(h2,'tooltipstring',ttip,'tag','mcp');


%% ———————— thresh ———————————————————————————————————————
ttip=['sgnificance level' char(10) ' example: [0.05] or [0.001]'];
h2=uicontrol('style','text','units','norm') ;      %TXT
set(h2, 'position',[0.30 .5 .12 .05]);
set(h2,'tooltipstring',ttip);
set(h2,'string','thresh','fontsize',6,'backgroundcolor','w');
set(h2,'HorizontalAlignment','left','fontweight','bold');


h2=uicontrol('style','edit','units','norm') ;      %number ofT
set(h2, 'position',[0.31 .5 .1 .03]);
set(h2,'tooltipstring',ttip,'tag','thresh');


%% ———————— clustersize ———————————————————————————————————————
ttip=['clustersize (k)' char(10) ' minimum spatial extend of connected significant voxels '];
h2=uicontrol('style','text','units','norm') ;      %TXT
set(h2, 'position',[0.425 .5 .12 .05]);
set(h2,'tooltipstring',ttip);
set(h2,'string','CL-K','fontsize',6,'backgroundcolor','w');
set(h2,'HorizontalAlignment','left','fontweight','bold');


h2=uicontrol('style','edit','units','norm') ;      %number ofT
set(h2, 'position',[0.425 .5 .1 .03]);
set(h2,'tooltipstring',ttip,'tag','clustersize');

%•••••••••••••••••••••••••••••••••••••••••••••••••••%•••••••••••••••••••••••••••••••••••••••••••••••••••

%% ———————— new contrast———————————————————————————————————
h2=uicontrol('style','pushbutton','units','norm') ;      %load spm-input
set(h2, 'string','new contrast','callback',@loadSPMmat);
set(h2, 'position',[.0 .55 .26 .05],'fontsize',7);
set(h2,'tooltipstring','load Results ("SPM.mat"), addit. parameters have to be defined');
set(h2,'foregroundcolor',[repmat(0.3,[1 3])]);
%% ———————— load con-1 ———————————————————————————————————

h2=uicontrol('style','pushbutton','units','norm') ;      %load1st contrast
set(h2, 'string','Load Con-1','callback',@loadSPMmatnoInput);
set(h2, 'position',[.26 .55 .26 .05],'fontsize',7);
set(h2,'tooltipstring','load the 1st contrast with standard parameters');
set(h2,'foregroundcolor','b');

%% ———————— contrasts (listbox)———————————————————————————————————

h2=uicontrol('style','text','units','norm');            %other contrasts -TXT
set(h2, 'string','contrasts','ButtonDownFcn',@loadothercontrastini);
set(h2, 'position',[0.55881 0.645 .3 0.03],'fontsize',6,'backgroundcolor','w',...
    'horizontalalignment','left','tag','contraststring','foregroundcolor','m','fontweight','bold');


h2=uicontrol('style','listbox','units','norm') ;      %other contrasts
set(h2, 'string','-','callback',@loadothercontrast,'tag','loadothercontrast');
set(h2, 'position',[0.56343 0.25115 0.48 0.4],'fontsize',5);
set(h2,'tooltipstring',['<html><b>contrast-list</b><br>' ...
    'select a contrast here to display this contrast <br>' ...
    'if the list is empty..just click here to update the contrast-list<br>'...
    '<b>shortcut [+/-] to change fontsize</b>']);
set(h2,'KeyPressFcn',@KeyPress);
set(findobj(0,'tag','vvstat'),'KeyPressFcn',@KeyPress);


try
global xvv
% xvv.fs=7;
set(h2,'fontsize',xvv.fs);
end

%% ———————— delete contrasts———————————————————————————————————
h2=uicontrol('style','pushbutton','units','norm') ;      %show sections
set(h2, 'string','deleteC','callback',@deleteContrasts,'tag','deleteContrasts');
set(h2, 'position',[[0.85451 0.22258 0.15 0.03]],'fontsize',6);
set(h2,'tooltipstring','delete contrasts');


%% ———————— recreate———————————————————————————————————
h2=uicontrol('style','pushbutton','units','norm') ;      %show sections
set(h2, 'string','restore','callback',@restoreContrasts,'tag','restoreContrasts');
set(h2, 'position',[0.84989 0.65112 0.15 0.03],'fontsize',6);
set(h2,'tooltipstring','restore contrasts after closing this GUI');


%% ———————— show VOLUME(section)———————————————————————————————————
h2=uicontrol('style','pushbutton','units','norm') ;      %show sections
set(h2, 'string','show volume','callback',@showSections,'tag','showvolume');
set(h2, 'position',[.0 .4 .28 .05],'fontsize',7);
set(h2,'tooltipstring','show 3 panel (sections) view');

h2=uicontrol('style','radiobutton','units','norm') ;      %show sections
set(h2, 'string','show vol','fontsize',6,'value',1);
set(h2, 'position',[.3 .405 .25 .05],'backgroundcolor','w',...
    'tooltipstring','always show volume','tag','showSectionstoggle');


%% ———————— show table———————————————————————————————————————
h2=uicontrol('style','pushbutton','units','norm') ;      %show table
set(h2, 'string','show table','callback',@showTable,'tag','showTable');
set(h2, 'position',[0    .35 .28 .05]);
set(h2,'tooltipstring',' show statistical table');

%% ———————— show table-in CMD-WIN———————————————————————————————————————
h2=uicontrol('style','pushbutton','units','norm') ;      %show table
set(h2, 'string','table-2-CMD','callback',@showTable_CMD,'tag','showTable_CMD');
set(h2, 'position',[-0.00025874 0.31543 0.28 0.03],'fontsize',7);
set(h2,'tooltipstring',' show statistical table in command window');

%% ———————— clusters distance ———————————————————————————————————————
ttip=['cluster distance ' char(10) 'minimum distance between clusters [mm]'];
h2=uicontrol('style','text','units','norm') ;      %TXT
set(h2, 'position',[0.4 .355 .11 .05]);
set(h2,'tooltipstring',ttip);
set(h2,'string','Cldist','fontsize',6,'backgroundcolor','w');
set(h2,'HorizontalAlignment','left','fontweight','bold');


h2=uicontrol('style','edit','units','norm') ;      %  clusterDistance
set(h2, 'position',[0.4 .355 .1 .03]);
set(h2,'tooltipstring',ttip,'tag','clustdist');

%% ———————— number of clusters ———————————————————————————————————————
h2=uicontrol('style','text','units','norm') ;      %TXT
set(h2, 'position',[0.29 .355 .11 .05]);
set(h2,'tooltipstring','Number of Peaks per cluster');
set(h2,'string','#P/Cl','fontsize',6,'backgroundcolor','w');
set(h2,'HorizontalAlignment','left','fontweight','bold');


h2=uicontrol('style','edit','units','norm') ;      %number of cluster EDIT
set(h2, 'position',[0.29 .355 .1 .03]);
set(h2,'tooltipstring','number of maxima per cluster','tag','nmaxclust');


%% ———————— export table excel ———————————————————————————————————————
h2=uicontrol('style','pushbutton','units','norm') ;      %export table
set(h2, 'string','export xlsx','callback',@exporttableXLS);
set(h2, 'position',[0   .25 .28 .05]);
set(h2,'tooltipstring','save statistical table as Excel-file','fontsize',7);

%% ———————— export table txt ———————————————————————————————————————
h2=uicontrol('style','pushbutton','units','norm') ;      %export table
set(h2, 'string','export txt','callback',@exporttable);
set(h2, 'position',[0.28158 0.25 0.28 0.05]);
set(h2,'tooltipstring','save statistical table as txt-file','fontsize',7);

%% ———————— extract data ———————————————————————————————————————
h2=uicontrol('style','pushbutton','units','norm') ;      %export table
set(h2, 'string','extract data','callback',@extractData_call);
set(h2, 'position',[0 0.14878 0.28 0.05]);
set(h2,'tooltipstring','extract animal''s -peak data and store as Excel-file','fontsize',7);

%% ———————— save vol———————————————————————————————————————
h2=uicontrol('style','pushbutton','units','norm') ;      %save volume table
set(h2, 'string','save volume','callback',@save_threshvolume);
set(h2, 'position',[0    .2 .28 .05]);
set(h2,'tooltipstring','save thresholded volume as nifti-file','fontsize',7);

%% ———————— show mricron ———————————————————————————————————————
h2=uicontrol('style','pushbutton','units','norm') ;      %show volume MRICRON
set(h2, 'string','show MRicron','callback',@show_mricron);
set(h2, 'position',[0.28 .2 .28 .05]);
set(h2,'tooltipstring','show previously saved thresholded volume overlayed in MRICRON','fontsize',7);

%% ———————— show vol in extraFigure ———————————————————————————————————————
h2=uicontrol('style','pushbutton','units','norm') ;      %show volume MRICRON
set(h2, 'string','show VolOrtho','callback',@show_vol_extrafigure);
set(h2, 'position',[0.56343 0.2 0.28 0.05]);
set(h2,'tooltipstring','show previously saved thresholded volume in another figure','fontsize',6);

%% ======= code posthoc ========================================

h2=uicontrol('style','pushbutton','units','norm') ;      %show volume MRICRON
set(h2, 'string','code posthoc','callback',@code_posthoc);
set(h2, 'position',[0 0.058305 0.32 0.045],'fontsize',7);
set(h2,'tooltipstring',[...
    'code-snippet to create post-hoc summary' char(10) ....
    ' - create powerpoint-file with table volume view ' char(10)...
    ' - create statistical results (excel-files) ' char(10)...
    ' - save thresholded volume (Nifti)'
    ]);
set(h2,'BackgroundColor',[0.9608    0.9765    0.9922],'foregroundcolor',[0 0 1]);

% % ==============================================
%%   scripts
% % ===============================================

h2=uicontrol('style','pushbutton','units','norm') ;      
set(h2, 'string','scripts','callback',@scripts_call);
set(h2, 'position',[0.32317 0.058305 0.2 0.045],'fontsize',7,'foregroundcolor',[0 0 1]);
set(h2,'BackgroundColor',[0.9608    0.9765    0.9922])
set(h2,'tooltipstring',['<html><b>collection of scripts</b><br>' ...
    'open scripts-gui with collection of scripts<br>'...
    '-scripts can be costumized and applied']);


% h2=uicontrol('style','pushbutton','units','norm') ;      
% set(h2, 'string','scripts','callback',@scripts_call);
% set(h2, 'position',[0.33241 0.15116 0.2 0.045],'fontsize',7,'foregroundcolor',[0 0 1]);
% set(h2,'BackgroundColor',[0.9608    0.9765    0.9922])
% set(h2,'tooltipstring',['<html><b>collection of scripts</b><br>' ...
%     'open scripts-gui with collection of scripts<br>'...
%     '-scripts can be costumized and applied']);


% ==============================================
%%   close
% ===============================================
h2=uicontrol('style','pushbutton','units','norm') ;      %exit
set(h2, 'string','close','callback',@xclose);
set(h2, 'position',[0.66 .0 .33 .05]);
set(h2,'tooltipstring','close this gui','fontsize',7);




%% ——— set prefs————————————————————————————————————————————

prefs=getprefs;

set(findobj(gcf,'tag','mcp'        ),'string',  prefs.mcp         ,'fontsize',6);
set(findobj(gcf,'tag','thresh'     ),'string',  prefs.thresh      ,'fontsize',6);
set(findobj(gcf,'tag','clustersize'),'string',  prefs.clustersize ,'fontsize',6);

set(findobj(gcf,'tag','nmaxclust'  ),'string',  prefs.nmaxclust    ,'fontsize',6);
set(findobj(gcf,'tag','clustdist'  ),'string',  prefs.clustdist    ,'fontsize',6);


%———————————————————————————————————————————————

set(gcf,'userdata',s);
drawnow
set(gcf,'ButtonDownFcn',@loadothercontrastini);
set(gcf,'CloseRequestFcn',[]);


xvv.x=x;
xvv.showgui=showgui;

if isfield(xvv.x,'stattype')
    xvv.xtype=xvv.x.stattype;
    if strcmp(xvv.x.stattype,     'regression')
        multipleregression;
    elseif strcmp(xvv.x.stattype, 'pairedttest')
        pairedsampleTest;
    elseif strcmp(xvv.x.stattype, 'twosamplettest')
        twosampleTest;
    elseif strcmp(xvv.x.stattype, 'onewayanova')
        onewayanova;
    elseif strcmp(xvv.x.stattype, 'onewayanova_within')
        onewayanova_within;
    elseif strcmp(xvv.x.stattype, 'fullfactorial')
        fullfactorial;
    elseif strcmp(xvv.x.stattype, 'flexfactorial')
        flexfactorial;    
    end
    
end




function miscTask(e,e2,task)

if strcmp(task, 'repairMIP')
    repairMIP(1);
elseif strcmp(task, 'findClusterTresh,p0.001') || strcmp(task, 'findClusterTresh,user')
    try
        xSPM = evalin('base','xSPM');
        if ~isempty(strfind(task, 'user'))
            p=str2num(input('cluster-threshold, PLEASE ENTER DESIRED P-THRESHOLD: ','s')) ;
        else
            p=0.001;
        end
        
        clustersize=cp_cluster_Pthresh(xSPM, p);
    end
end


function repairMIP_help()
g={ '=================================='
    '    repair MIP/change ATLAS (xstat)      '
    '=================================='
    'The  SPM-analysis-folder must contain the following two files: "xstatMIP.mat" and "xstatParameter.mat" '
    'For this the some parameter have to be specified (AVGT,ANO,SPM-anylsis-folder).'
    '___ GUI_____________________________'
    '_to repair/ posthoc create those files via GUI use : '
    'xstat(''repairMIP'')'
    '___ NO GUI_____________________________'
    'or without GUI using the followng parameters'
    'z=[];'
    'z.AVGT  =''F:\data6\voxwise\templates\AVGT.nii''; % your AVGT-file'
    'z.ANO   =''F:\data6\voxwise\templates\ANO.nii'';  % your ANO-file (ATLAS)'
    'z.SPMdir=''F:\data6\voxwise\voxw_test2'';         % your SPM_analysis-folder'
    'xstat(''repairMIP'',0,z); % silent mode'
    ''
    
    };


disp(char(g));




function repairMIP(show,x)

if exist('x')~=1; x=struct(); end
%% ===============================================
p={
    'AVGT'     '' 'select the TEMPLATE-file (path of "AVGT.nii")' 'f'
    'ANO'      '' 'select the ATLAS-file (path of "ANO.nii")' 'f'
    'SPMdir'   '' 'path of SPM.mat-folder' 'd';
    };
p=paramadd(p,x);%add/replace parameter
if show==1
    [m z a paras]=paramgui(p,'uiwait',1,'close',1,'editorpos',[.03 0 1 1],...
        'figpos',[0.2000    0.4278    0.4944    0.2233],...
        'title',['create repair MIP/ATLAS']);
    if isempty(m); return; end
    fn=fieldnames(z);
    z=rmfield(z,fn(regexpi2(fn,'^inf\d')));
    if isempty(m); disp('--canceled');return; end
else
    z=param2struct(p);
end

    
    %% =======[save 'xstatParameter.mat' ]========================================

    par=z;
    SPMdir=par.SPMdir;
    F1=fullfile(SPMdir,'xstatParameter.mat');
    
    save(F1,'par');
    showinfo2('..created/repaired PARMETER: ',F1,[],1,[' -->[' F1 ']']);
    %% ==========[create MIP-file ]=====================================
    mipfile=fullfile(SPMdir,'xstatMIP.mat');
    makeMIP(par.AVGT,'show',0,'save', mipfile);
    
    %% ===============================================
    
    

%———————————————————————————————————————————————
%%   subs
%———————————————————————————————————————————————

function posthoc(e,e2,task)

if strcmp(task,'summary_allcontrasts')
    summary_contrast('all');
elseif strcmp(task,'summary_thiscontrast')
    summary_contrast('this');
elseif strcmp(task,'summary_allcontrastsFull')
    summary_contrast('all_full');
elseif strcmp(task,'summary_thiscontrastFull')
    summary_contrast('this_full');
elseif strcmp(task,'summary_allcontrastsallMethods')
    summary_contrastAllMethods('summary_allcontrastsallMethods');    
end



% ==============================================
%%   
% ===============================================
function summary_contrastAllMethods(pin)
cprintf('*[1 0 1]',[ 'MAKE SUMMARY ...please wait' '\n' ]);
% ===============================================
% task='all';
waitspin(1,'wait...');

% =========== [which con] ====================================
hf=findobj(0,'tag','vvstat');
ht=findobj(hf,'tag','loadothercontrast');
cons=1:length(get(ht,'string'));


% =========== [which con] ====================================
xSPM = evalin('base','xSPM');
SPM  = evalin('base','SPM');
spmdir=SPM.swd;
currdir=pwd;
cd(spmdir);
[~,spmdirsShort]=fileparts(spmdir); % shortNames of the SPM-dirs..used for PPT-file-names
outdir=fullfile(fileparts(spmdir), ['res_' spmdirsShort] );
if exist(outdir)~=7
    mkdir(outdir); % make outdir-folder
end

%% =====LOAD SPMmat=+ make Dataoutdir =========================================
cd(spmdir);  
if 1
    outdirData=fullfile(outdir,'data');
    if exist(outdirData)~=7
        mkdir(outdirData);
    end
end

% ==============================================
%%   what to do
% ===============================================
% xstat('fullreport'); % write fullreport, all methods(uncor, cluster-based, FWE), for all contrast,  write xls-files and nifti-files
% xstat('fullreport',struct('method',[1 2 3],'xls',0,'nifti',0)); % all methods,for all contrast, do not save xls-file/NIfti-file
% xstat('fullreport',struct('method',[3],'con',[1],'xls',0,'nifti',0)) ;% FWE only for contrast-1, no nifti, no xls-file written
% xstat('fullreport',struct('method',[3],'con',[1],'xls',1,'nifti',1)) % same but write xls-file and nifti-file
% xstat('fullreport',struct('method',[3],'con',[1],'xls',1,'nifti',1)) % same but write xls-file and nifti-file
% xstat('fullreport',struct('method',[2],'con',[1:2],'xls',0,'nifti',0)); % clusterbased approch for contrast 1 & 2, do not save xls-file/NIfti-file
% xstat('fullreport',struct('method',[2],'xls',0,'nifti',0)); % clusterbased approch for all contrast, do not save xls-file/NIfti-file


p=struct();
p.method=[1:3];%methods to use [1]uncorected,[2]cluster-based,[3]FWE; example: use all methods: [1,2,3]
p.con   =cons;%contrast to include
p.xls   =1   ;%write xls-file
p.nifti =1   ;%write NIFTI-file
if exist('pin')==1 && isstruct(pin)
    p=catstruct(p,pin);
end

cons=p.con;

% ==============================================
%%   [1] uncorrected
% ===============================================
if ~isempty(find(p.method==1))
    for i=1:length(cons)
        con=cons(i);
        
        if i==1;  DOC='new'; else;    DOC='add';    end                    % add PPT-slide to existing PPT-file
        if mod(con,2)==1; bgcol=[1 1 1]; else; bgcol=[0.894 0.9412 0.9]; end % PPT-bgColor % alterate PPT-backgroundcolor for each contrast
        
        xstat('set',struct('MCP','none','thresh',0.001,'clk',1,'con',con,'show',0)); % set PARAMETER
        [p2 nametag2 paramtag]=getparameter();% get mainParameter
        PPTFILE=fullfile(outdir,['sum_UNCOR_'  paramtag '.pptx'   ]);
        
        xstat('report',PPTFILE,struct('doc',DOC,'con',con,'bgcol',bgcol  )); % save stat. table in PPT
        xstat('report',PPTFILE,struct('show','volume','doc','add','con',con,'bgcol',bgcol  )); % save volume in PPT
        
        if p.nifti==1
            F1=fullfile(outdirData,[ nametag2 '.nii'   ]);
            xstat('savevolume',F1);     % save tresholded volume
        end
        if p.xls==1
            F2=fullfile(outdirData,[ nametag2 '.xlsx'   ]);
            xstat('export',F2);     % save stat. table as excelfile
        end
    end
    cprintf('*[.0 0 1]',[ 'PPT-SUMMARY_UNCORRECTED' ]);
    showinfo2('',PPTFILE);
end
    
% ==============================================
%%    [2] SUMMARY: Peak-cluster with estimated clusterSize 
% ===============================================
if ~isempty(find(p.method==2))
    for i=1:length(cons)
        con=cons(i);

        if i==1;  DOC='new'; else;    DOC='add';    end                    % add PPT-slide to existing PPT-file
        if mod(con,2)==1; bgcol=[1 1 1]; else; bgcol=[0.894 0.9412 0.9]; end % PPT-bgColor % alterate PPT-backgroundcolor for each contrast
        
        xstat('set',struct('MCP','none','thresh',0.001,'clk',1,'con',con,'show',1));
        xSPM = evalin('base','xSPM');
        clustersize = cp_cluster_Pthresh(xSPM, 0.001); %estimate clusterSize
        xstat('set',struct('MCP','none','thresh',0.001,'clk',clustersize,'con',con,'show',0)); % set PARAMETER
        [p2 nametag2 paramtag]=getparameter();% get mainParameter
        nametag2=strrep(nametag2,'none','CLUST');
        paramtag=strrep(paramtag,'none','CLUST');
        PPTFILE=fullfile(outdir,['sum_CLUST_'  paramtag '.pptx'   ]);
        paramtag=[paramtag(1:max(strfind(paramtag,'k'))-1) '' ]; %remove clusterSize..as this might change over contrasts
        xstat('report',PPTFILE,struct('doc',DOC,'con',con,'bgcol',bgcol  )); % save stat. table in PPT
        xstat('report',PPTFILE,struct('show','volume','doc','add','con',con,'bgcol',bgcol  )); % save volume in PPT
        
        if p.nifti==1
            F1=fullfile(outdirData,[ nametag2 '.nii'   ]);
            xstat('savevolume',F1);     % save tresholded volume
        end
        if p.xls==1
            F2=fullfile(outdirData,[ nametag2 '.xlsx'   ]);
            xstat('export',F2);     % save stat. table as excelfile
        end
    end
    cprintf('*[.0 0 1]',[ 'PPT-SUMMARY_CLUSTERBASED' ]);
    showinfo2('',PPTFILE);
end

% ==============================================
%%    [3] SUMMARY: FWE_CORRECTION, at p=0.05,  clusterSize k=1 
% ===============================================
if ~isempty(find(p.method==3))
    for i=1:length(cons)
        con=cons(i);

        if i==1;  DOC='new'; else;    DOC='add';    end                    % add PPT-slide to existing PPT-file
        if mod(con,2)==1; bgcol=[1 1 1]; else; bgcol=[0.894 0.9412 0.9]; end % PPT-bgColor % alterate PPT-backgroundcolor for each contrast
        
        xstat('set',struct('MCP','FWE','thresh',0.05,'clk',1,'con',con,'show',0))
        [p2 nametag2 paramtag]=getparameter();% get mainParameter
        nametag2=strrep(nametag2,'none','CLUST');
        paramtag=strrep(paramtag,'none','CLUST');
        PPTFILE=fullfile(outdir,['sum_FWE_'  paramtag '.pptx'   ]);
        
        xstat('report',PPTFILE,struct('doc',DOC,'con',con,'bgcol',bgcol  )); % save stat. table in PPT
        xstat('report',PPTFILE,struct('show','volume','doc','add','con',con,'bgcol',bgcol  )); % save volume in PPT
        
        if p.nifti==1
            F1=fullfile(outdirData,[ nametag2 '.nii'   ]);
            xstat('savevolume',F1);     % save tresholded volume
        end
        if p.xls==1
            F2=fullfile(outdirData,[ nametag2 '.xlsx'   ]);
            xstat('export',F2);     % save stat. table as excelfile
        end
    end
    cprintf('*[.0 0 1]',[ 'PPT-SUMMARY_FWE' ]);
    showinfo2('',PPTFILE);
end

cd(currdir);
try; waitspin(0,'Done'); end
cprintf('*[1 0 1]',[ 'DONE!' '\n' ]);  
return
    
    
%     if 0
%         xstat('set',struct('MCP','none','thresh',0.001,'clk',1,'con',con,'show',0)); % set PARAMETER
%         xstat('report',PPTFILE,struct('doc',DOC,'con',con,'bgcol',bgcol  )); % save stat. table in PPT
%         xstat('report',PPTFILE,struct('show','volume','doc','add','con',con,'bgcol',bgcol  )); % save volume in PPT
%         xstat('savevolume',outdir); % save tresholded volume
%         xstat('export',outdir);     % save stat. table as excelfile
%         
%         % #m [2] SUMMARY: Peak-cluster with estimated clusterSize -------
%         clustersize = cp_cluster_Pthresh(xSPM, 0.001); %estimate clusterSize
%         xstat('set',struct('MCP','none','thresh',0.001,'clk',clustersize,'con',con,'show',0)); % set PARAMETER
%         xstat('report',PPTFILE,struct('doc','add','con',con,'bgcol',bgcol    )); % save stat. table in PPT
%         xstat('report',PPTFILE,struct('show','volume','doc','add','con',con,'bgcol',bgcol  ));% save volume in PPT
%         xstat('savevolume',outdir); % save tresholded volume
%         xstat('export',outdir);     % save stat. table as excelfile
%         
%         % #m [3] SUMMARY: FWE_CORRECTION, at p=0.05,  clusterSize k=1 -------
%         xstat('set',struct('MCP','FWE','thresh',0.05,'clk',1,'con',con,'show',0)); % set PARAMETER
%         xstat('report',PPTFILE,struct('doc','add','con',con,'bgcol',bgcol    )); % save stat. table in PPT
%         xstat('report',PPTFILE,struct('show','volume','doc','add','con',con,'bgcol',bgcol  )); % save volume in PPT
%         xstat('savevolume',outdir); % save tresholded volume
%         xstat('export',outdir);     % save stat. table as excelfile
%     end
    
% end
% cd(currdir);
% waitspin(0,'Done');











function summary_contrast(task)
%% ===============================================
% ==============================================
% #b   get parameter
% ===============================================
[ps nametag]=getparameter();% get mainParameter
ps.TR=str2num(ps.TR);
ps.k=str2num(ps.k);
ps.nmaxclust=str2num(ps.nmaxclust);


waitspin(1,'wait...');

% =========== [which con] ====================================

hf=findobj(0,'tag','vvstat');
ht=findobj(hf,'tag','loadothercontrast');
if strcmp(task,'this') || strcmp(task,'this_full')
    cons=ht.Value;
    constr=['con' num2str(cons) '__' regexprep(ps.con,{'<' '>'},{'_LT_' '_GT_'}) '_'];
    outfileName=[ strrep(ps.img,'.nii','') '_' constr '_' ps.mcp num2str(ps.TR) 'k' num2str(ps.k) ];
% outfileName
    % svimg__control_LT_mani__FWE0.05k1
elseif strcmp(task,'all') || strcmp(task,'all_full')
    cons=1:length(get(ht,'string'));
    constr=['conAll'];
    outfileName=[ strrep(ps.img,'.nii','') '_' constr '_' ps.mcp num2str(ps.TR) 'k' num2str(ps.k) ];   
end




% =========== [which con] ====================================
xSPM = evalin('base','xSPM');
SPM  = evalin('base','SPM');
spmdir=SPM.swd;
currdir=pwd;
cd(spmdir);
[~,spmdirsShort]=fileparts(spmdir); % shortNames of the SPM-dirs..used for PPT-file-names
outdir=fullfile(fileparts(spmdir), ['res_' spmdirsShort] );
if exist(outdir)~=7
    mkdir(outdir); % make outdir-folder
end
% ==============================================
% #b   outdir-PPT
% ===============================================
PPTFILEprefix='sum_';
thisDir=char(spmdirsShort);
% PPTFILE=fullfile(outdir,[PPTFILEprefix '_' thisDir  '_' constr '.pptx'   ]);
PPTFILE=fullfile(outdir,[PPTFILEprefix '_' outfileName '.pptx'   ]);


%%   =====LOAD SPMmat==========================================
cd(spmdir);
% cf; xstat('loadspm',fullfile(pwd,'SPM.mat'));

isfull=0;
if ~isempty(strfind(task,'_full'))
    isfull=1;
end  
    
if isfull==1
    outdirData=fullfile(outdir,'data');
    if exist(outdirData)~=7
        mkdir(outdirData);
    end
end

% #b =====loop over the two directional contrasts (x larger y, x smaller y)=============
for i=1:length(cons)
    
    con=cons(i);
    if i==1
        DOC='new';  % for each SPM-DIR, if contrast is 1--> create "new" PPTfile
    else
        DOC='add';   % add PPT-slide to existing PPT-file
    end
    
    
    if mod(con,2)==1 % alterate PPT-backgroundcolor for each contrast
        bgcol=[1 1 1]; % PPT-bgColor
    else
        bgcol=[0.8941    0.9412    0.9020];
    end
    
    % #m [1] SUMMARY: uncorrected, at p=0.001, clusterSize k=1 -------
    xstat('set',struct('MCP',ps.mcp,'thresh',ps.TR,'clk',ps.k,'con',con,'show',0)); % set PARAMETER
    xstat('report',PPTFILE,struct('doc',DOC,'con',con,'bgcol',bgcol  )); % save stat. table in PPT
    xstat('report',PPTFILE,struct('show','volume','doc','add','con',con,'bgcol',bgcol  )); % save volume in PPT
    if isfull==1
        
        [p2 nametag2]=getparameter();% get mainParameter
        p2.TR=str2num(p2.TR);
        p2.k=str2num(p2.k);
        p2.nmaxclust=str2num(p2.nmaxclust);


        constr2=['con' num2str(con) '__' regexprep(p2.con,{'<' '>'},{'_LT_' '_GT_'}) '_'];
        outfileName2=[ strrep(p2.img,'.nii','') '_' constr2 '_' p2.mcp num2str(p2.TR) 'k' num2str(p2.k) ];
    
        
        F1=fullfile(outdirData,[ outfileName2 '.nii'   ]);
        %F1=fullfile(outdirData,[ regexprep(outfileName,{'\.' },{'d'}) '.nii'   ]);
        xstat('savevolume',F1); % save tresholded volume
        F2=fullfile(outdirData,[ outfileName2 '.xlsx'   ]);
        xstat('export',F2);     % save stat. table as excelfile
    end
    
    
    if 0
        xstat('set',struct('MCP','none','thresh',0.001,'clk',1,'con',con,'show',0)); % set PARAMETER
        xstat('report',PPTFILE,struct('doc',DOC,'con',con,'bgcol',bgcol  )); % save stat. table in PPT
        xstat('report',PPTFILE,struct('show','volume','doc','add','con',con,'bgcol',bgcol  )); % save volume in PPT
        xstat('savevolume',outdir); % save tresholded volume
        xstat('export',outdir);     % save stat. table as excelfile
        
        % #m [2] SUMMARY: Peak-cluster with estimated clusterSize -------
        clustersize = cp_cluster_Pthresh(xSPM, 0.001); %estimate clusterSize
        xstat('set',struct('MCP','none','thresh',0.001,'clk',clustersize,'con',con,'show',0)); % set PARAMETER
        xstat('report',PPTFILE,struct('doc','add','con',con,'bgcol',bgcol    )); % save stat. table in PPT
        xstat('report',PPTFILE,struct('show','volume','doc','add','con',con,'bgcol',bgcol  ));% save volume in PPT
        xstat('savevolume',outdir); % save tresholded volume
        xstat('export',outdir);     % save stat. table as excelfile
        
        % #m [3] SUMMARY: FWE_CORRECTION, at p=0.05,  clusterSize k=1 -------
        xstat('set',struct('MCP','FWE','thresh',0.05,'clk',1,'con',con,'show',0)); % set PARAMETER
        xstat('report',PPTFILE,struct('doc','add','con',con,'bgcol',bgcol    )); % save stat. table in PPT
        xstat('report',PPTFILE,struct('show','volume','doc','add','con',con,'bgcol',bgcol  )); % save volume in PPT
        xstat('savevolume',outdir); % save tresholded volume
        xstat('export',outdir);     % save stat. table as excelfile
    end
    
end
cd(currdir);
waitspin(0,'Done');



function scripts_call(e,e2)

scripts={...
    'VWscript_DWIimages_and_results.m'
    'VWscript_twosampleStat_simple.m'
    'VWscript_MakeSummary_simple.m'
    'VWscript_twosampleStat_severalimages.m'
    'VWscript_MakeSummary_severalimages.m'
    'VWscript_twosampleStat_severalimages_severalgroups.m'
    'VWscript_MakeSummary_severalimages_severalgroups.m'
    };
scripts_gui([],'figpos',[.3 .2 .4 .4], 'pos',[0 0 1 1],'name','scripts: voxelwise statistic','closefig',1,'scripts',scripts)
% scripts_gui(gcf, 'pos',[0 0 1 1],'name','scripts: voxelwise statistic','closefig',1,'scripts',scripts)


function xclose(e,e2)
useotherspm(0); % swith to ANT version of SPM
hfig=findobj(0,'tag','vvstat');
set(hfig,'CloseRequestFcn','closereq');
close(hfig);

function radio_selectStatCorect(e,e2)
hr=findobj(gcf,'tag','selcorecttion');
lis=get(hr,'userdata');
sel=lis{hr.Value,2};
if isempty(strfind(lis{hr.Value,1},'clusterbased'))
    set(findobj(gcf,'tag','mcp'),        'string', sel{1});
    set(findobj(gcf,'tag','thresh'),     'string', sel{2});
    set(findobj(gcf,'tag','clustersize'),'string', sel{3});
else
    set(findobj(gcf,'tag','mcp'),        'string', sel{1});
    set(findobj(gcf,'tag','thresh'),     'string', sel{2});
    set(findobj(gcf,'tag','clustersize'),'string', sel{3}); 
    
    hf=findobj(0,'tag','vvstat');
    ht=findobj(hf,'tag','loadothercontrast');
    con=ht.Value;
    xSPM = evalin('base','xSPM');
    SPM  = evalin('base','SPM');
    pthresh=str2num(sel{2});
    xstat('set',struct('MCP','none','thresh',pthresh,'clk',1,'con',con,'show',1)); % se
    xSPM = evalin('base','xSPM');
    SPM  = evalin('base','SPM');
    clustersize = cp_cluster_Pthresh(xSPM, pthresh); %estimate clusterSize
    xstat('set',struct('MCP','none','thresh',pthresh,'clk',clustersize,'con',con,'show',1)); % set PARAMETER
    
    
end


function loadothercontrastini(e,e2)
loadothercontrast('initialize',[]);


%———————————————————————————————————————————————
%%   readexcel
%———————————————————————————————————————————————

function chkOK=readexcel(xtype)
chkOK=0;
s=get(gcf,'userdata');
wkdir=pwd;


if exist('xtype')==1;
else; return;
end

global an
v.data_dir='';
v.AVGT    ='';
v.ANO     ='';
v.mask    ='';
v.output_dir = 'voxtest1';
if ~isempty(an)
    v.data_dir   = an.datpath;
    v.AVGT       = fullfile(fileparts(an.datpath),'templates', 'AVGT.nii');
    v.ANO        = fullfile(fileparts(an.datpath),'templates', 'ANO.nii');
    v.mask       = fullfile(fileparts(an.datpath),'templates', 'AVGTmask.nii');
end

%———————————————————————————————————————————————
%%   parmaeter
%—————————————————————————————
% stat test                    first comment in GUI
stattests={...
    'twosamplettest'     '% TWO-SAMPLE-TTEST'
    'pairedttest'        '% PAIRED-SAMPLE-TTEST'
    'regression'         '% multiple regression' 
    'onewayanova'        '% ONE-WAY-ANOVA' 
    'onewayanova_within' '% within-ONE-WAY-ANOVA' 
    'fullfactorial'      '% fullfactorial ANOVA'
    'flexfactorial'      '% flexfactorial ANOVA'
    };


p={
    'inf1'            '% ##'  '' ''
    'excelfile'       ''     '[Excel-file]: file containing columns with animal-IDs and group/regressionValue and optional covariates' 'f'
    'sheetnumber'     1      'sheet-index containing the data (default: 1)' ''
    'mouseID_col'     1      'column-index containing animal-IDs (default: 1)' ''
    'group_col'       2      'column-index with group assignment, for fullfactorial-design several columns has to be assigned (default: 2)' ''
    'regress_col'     []     '<optional>  column-index/indices containing covariates (otherwise: empty)' ''
    
    'inf2a'           ''  '' ''
    'inf2'     '_____ DataDIR & NIFTI ________________________'  '' ''
    'data_dir'        v.data_dir     'main data directory (upper directory) containing the animal-dirs (default: the "dat"-dir of the study)' 'd'
    'inputimage'      ''             'name of the NIFTI-image to analyze ("data_dir" has to bee defined before using the icon)'  {@antcb,'selectimageviagui', 'data_dir' ,'single'}
    
    'inf3a'           ''  '' ''
    'inf3'     '_____ TEMPLATE/ATLAS/MASK & OUTPUT ________________________'  '' ''
    'AVGT'            v.AVGT         '[TEMPLATE-file]: select the TEMPLATE (default: fullpath-name of "AVGT.nii" from the templates-dir)' 'f'
    'ANO'             v.ANO         '[ATLAS-file]: select the ATLAS (default: fullpath-name of "ANO.nii" from the templates-dir)' 'f'
    'mask'            v.mask         '[MASK-file]: select the brain-maskfile (default: fullpath-name of "AVGTmask.nii" from the templates-dir)' 'f'
    'output_dir'      v.output_dir   'path of the output-directory (SPM-statistic with SPM.mat and images)' 'd';
    'inf4a'           ''  '' ''
    'inf4'     '_____ OTHER PARAMETER ________________________'  '' ''
    'smoothing'       1                 '<optional>smooth data, [0|1]; if [1] the NIFTI is smoothed & stored with prefix "s" in the animal-dir, the smoothed image is than used for analysis ' 'b'
    'smoothing_fwhm'  [0.28 0.28 0.28]  'smoothing width (FWHM); example: tripple of the voxsize of the inputimage '  ''
    'showSPMwindows'  1                  'hide|show SPM-WINDOWS, [0|1]; if [0] SPM-windows are hidden' 'b';
    'showSPMbatch'    1                  'hide|show SPM-batch, [0|1]; usefull for evaluation and postprocessing' 'b';
    'runSPMbatch'     1                  'run SPM-batch, [0|1]; if [0] you have to start the SPM-batch by yourself,i.e hit the green triangle, [1] batch runs automatically ' 'b';
    'showResults'     1                  'show results; [0|1]; if [1] voxelwise results will be shown afterwards' 'b'; 
    };

%for fullfactorial design add in/dependency-option
if strcmp(xtype,'fullfactorial')
    pbk=p;
    isep=find(strcmp(pbk(:,1),'group_col'));
    pq1=pbk(1:isep    ,:);
    pq2=pbk(isep+1:end,:);
    dep={'factorDependency'  [0] 'dependencies of factor(s):[0]independent/between; [1] dependent/within (repeated measures); specify each factor (number of factors must match number of columns s "group_col")'...
        {...
        [0];[1]; ...
        [0 0];[1 1];[0 1];[1 0];...
        [0 0 0];[1 1 1];[1 0 0];[0 1 0];[0 0 1]; [1 1 0]; [1 0 1]; [0 1 1]}...
        };
    p=[pq1;dep;pq2];
end
if strcmp(xtype,'flexfactorial')
    %% ===============================================
    
 'a'  
 pbk=p;
 isep=find(strcmp(pbk(:,1),'group_col'));
 pq1=pbk(1:isep    ,:);
 pq2=pbk(isep+1:end,:);
 
 subjfact={'subjectFactor_col'  [] 'column of within subject-factor (column contains integers, same integer for the same animals (identical integers for repeated measurements of the same animal))',[]};
 
 dep={'factorDependency'  [0] 'dependencies of factor(s):[0]independent/between; [1] dependent/within (repeated measures); specify each factor (number of factors must match number of columns s "group_col")'...
     {...
     [0];[1]; ...
     [0 0];[1 1];[0 1];[1 0];...
     [0 0 0];[1 1 1];[1 0 0];[0 1 0];[0 0 1]; [1 1 0]; [1 0 1]; [0 1 1]}...
     };
 pq2=pbk(isep+1:end,:);
 varia={'factorVariance'  [0] 'variance of factor(s):[0]unequal; [1] equal; specify each factor (number of factors must match number of columns s "group_col")'...
     {...
     [0];[1]; ...
     [0 0];[1 1];[0 1];[1 0];...
     [0 0 0];[1 1 1];[1 0 0];[0 1 0];[0 0 1]; [1 1 0]; [1 0 1]; [0 1 1]}...
     };
    
    
 %% ===============================================
 p=[pq1;subjfact;dep;varia; pq2];
    
    
%  displine();
% return
end


istat=strcmp(stattests(:,1),xtype);
if isempty(istat)
   cprintf('*[0 0 1]',['Available statistical models: ' '\n']);
   disp(stattests(:,1));
   error('undefined statistical model!');
end
p{1,2}= [ strrep( stattests{istat,2} ,'%','% DESIGN:')  ' (' stattests{istat,1} ')']    ;% replace comment in 1st row
if strcmp(xtype, 'regression'); %remove "group_col"
    p(strcmp(p(:,1),'group_col'),:)=[];
end

% ==============================================
%%   
% ===============================================


global xvv
p=paramadd(p,xvv.x);

showgui=xvv.showgui;
if showgui==1
    hlp=help(mfilename); hlp=strsplit2(hlp,char(10))';
    
    try
        [m x a paras]=paramgui(p,'uiwait',1,'close',1,'editorpos',[.03 0 1 1],'figpos',[.2 .3 .6 .45 ],...
            'info',hlp,'title',[mfilename '.m']);
        if isempty(m);
            disp('...process terminated by user...');
            return
        end
    catch
        disp('...process aborted..issues...');
        return
    end
    xvv.paramguilist=m;
    fn=fieldnames(x);
    x=rmfield(x,fn(regexpi2(fn,'^inf\d')));
    if isempty(m); return; end
else
    x=param2struct(p);
end

global vxx

%———————————————————————————————————————————————
%%   working with 'x'
%———————————————————————————————————————————————


if iscell(x.excelfile);    x.excelfile  =char(x.excelfile); end
if ischar(x.sheetnumber);  x.sheetnumber=str2num(x.sheetnumber);   end
if iscell(x.data_dir   );  x.data_dir   =char(x.data_dir); end
if iscell(x.inputimage );  x.inputimage =char(x.inputimage); end
if iscell(x.output_dir );  x.output_dir =char(x.output_dir); end


try; if ischar(x.mouseID_col);         x.mouseID_col=str2num(x.mouseID_col);     end; end
try; if ischar(x.mouseID_colT1);       x.mouseID_colT1=str2num(x.mouseID_colT1); end; end
try; if ischar(x.mouseID_colT2);       x.mouseID_colT2=str2num(x.mouseID_colT2); end; end




if iscell(x.mask       );  x.mask       =char(x.mask); end

if isfield(x,'regress_col')
    if ischar((x.regress_col));  x.regress_col=str2num(x.regress_col); end
end
if isfield(x,'group_col')
    if ischar((x.group_col));  x.group_col=str2num(x.group_col); end
end




%% GETTING MASK
if ~isempty(x.mask)
    if exist(x.mask)~=2
        if regexpi(x.mask,'local')
            r1={
                fullfile(fileparts(x.excelfile),'templates','AVGTmask.nii');
                fullfile(fileparts(x.excelfile),'AVGTmask.nii');
                fullfile(fileparts(x.data_dir),'templates','AVGTmask.nii');
                fullfile(fileparts(x.data_dir),'AVGTmask.nii');
                fullfile(pwd,'templates','AVGTmask.nii')};
            
            for j=1:size(r1,1)
                if exist(r1{j})==2
                    isexist(j)=1;
                end
            end
            try
                x.mask=r1{min(find(isexist))};
            catch
                x.mask='';
            end
        else
            x.mask='';
        end
    end
else
    x.mask='';
end


%
% xlfile  = fullfile(pwd,'Maritzen_Animal_groups.xlsx')
% s.dat   = fullfile(pwd,'dat')
% s.nifti = 'JD.nii'
%
% s.out=fullfile(pwd,'res2perm'); mkdir(s.out)

%———————————————————————————————————————————————
%%   read excel
%———————————————————————————————————————————————

if exist(x.excelfile)~=2
    cprintf('*[1 0 .5]',['ERROR: group-assignmment-file does not exist ' '\n']);
    error(['misSING FILE: ' char(x.excelfile)]);
end

[~,sheets]=xlsfinfo(x.excelfile);
try
    sheets(x.sheetnumber);
catch
    cprintf('*[1 0 .5]',['ERROR: sheet-index does not exist ' '\n']);
    error(['wrong sheet-index: ' num2str(x.sheetnumber)]);
end

[~,~,a]=xlsread(x.excelfile, x.sheetnumber);
if numel(a)==1
    msgbox(['error: sheet-' num2str(x.sheetnumber) ' has only 1-element' char(10) ...
        'most likely the sheet-index is not correct']) ;
    error('abbort: sheet is empty');
end
% =========remove non-existend-folders======================================
ack=cellfun(@(a){[num2str(a)]} ,a(2:end,x.mouseID_col));
ackFP=stradd(ack,[x.data_dir filesep]);
imissdir=find(existn(ackFP)~=7);
if ~isempty(imissdir)
     cprintf('*[1 0 .5]',['The following animal-folders where not found' '\n']);
    disp(ack(imissdir));
    cprintf('*[1 0 .5]',['..animals where excluded form analysis' '\n']);
    a(imissdir+1,:)=[];
end
% =========remove covars that do not fit ()======================================
if 1
    try
        if ~isempty(x.regress_col)
            try
                covs=a(2:end,x.regress_col);
                
                is_noNumeric=cell2mat(cellfun(@(a){[~isnumeric(a)]} ,covs));
                is_NAN      =cell2mat(cellfun(@(a){[strcmp(num2str(a),'NaN')]} ,covs));
                ix_notOK    =find(sum(is_noNumeric+is_NAN,2));
                
                if ~isempty(ix_notOK)
                    cprintf('*[1 0 .5]',['non-numeric values or NaN or spaces for covars/regressValues found!' '\n']);
                    cprintf('*[1 0 .5]',['excel-rows: '  regexprep(num2str(ix_notOK'),'\s+',',') '\n']);
                    disp(covs(ix_notOK,:));
                    
                    cprintf('*[1 0 .5]',['..please remove those values from group-assignment file!!!!' '\n']);
                    error('abbort: covars/regression values ...not numeric or contain NANs/spaces');
                end
                
            catch
                cprintf('*[1 0 .5]',['index/indices of regress_col does not match ' '\n']);
                error(['wrong regress_col-index/indices: ' num2str(x.regress_col)]);
            end
        end
    end
end
% ===============================================


he=a(1,:); %header
%% ===============================================
% ==============================================
%%   newer version 
% ===============================================
s.m.x_info='_inputStruct___';
s.m.x=x;
s.m.a_info='_groupfile___';
s.m.a=a;
s.m.s_info='_fields___';
if isfield(x,'group_col')
    s.m.d       =cellfun(@(a){num2str(a)},a(2:end,[ x.mouseID_col x.group_col ])   );
    s.m.dh      =a(1,[ x.mouseID_col x.group_col ]) ;
else
    s.m.d       =cellfun(@(a){num2str(a)},a(2:end,[ x.mouseID_col x.regress_col ])   );
    s.m.dh      =a(1,[ x.mouseID_col x.regress_col ]) ;
end
% s.m.d(:,2)  =regexprep(s.m.d(:,2),{'\^|\.|\s|,|;|#|\d^|/|\'},{''});
s.m.d=regexprep(s.m.d,{'\^|\.|\s|,|;|#|\d^|/|\'},{''});

s.m.isCovar =0;
if isfield(x,'regress_col')
    if ~isempty(x.regress_col)
        s.m.covar     =a(2:end,x.regress_col);
        s.m.covar     =cellfun(@(a){[str2num(num2str(a))]} ,s.m.covar);
        s.m.covarName =a(1,x.regress_col);
        s.m.isCovar   =1;
    end
end

[files,~] = spm_select('FPListRec',x.data_dir,['^' x.inputimage '$']);  files=cellstr(files);
if isempty(x.inputimage)
    msgbox('no image selected!!');
    error('image must be selected');
end
s.m.files={};
% s.m.filesExist=[];
s.m.misses={};
s.m.missesIDX=[];
for i=1:size(s.m.d,1)
    ix=find(~cellfun('isempty',  strfind(files,[filesep  s.m.d{i,1}  filesep  ])  )  );% regexpi(files,s.d(i,1))));
    if length(ix)>1 ; error(['ix: more nifti-files found than expected']); end
    if ~isempty(ix)
        %s.m.filesExist(i,1) = 1;
        s.m.files(i,1)      = files(ix);
    else
        %s.m.filesExist(i,1)    = 0;
        s.m.misses{end+1,1}    = s.m.d{i,1};
        s.m.missesIDX(end+1,1) = i;
    end
end

if ~isempty(s.m.missesIDX)
    cprintf('*[1 0 .5]',['IMPORTANT: the inputfile "' x.inputimage '" does not exist for: ' '\n']);
    msgmiss=cellfun(@(a,b){[ '[' (num2str(a))  '] ' b ]} ,num2cell(s.m.missesIDX),s.m.misses);
    disp(char(msgmiss));
    cprintf('*[1 0 .5]',['..animals where excluded form analysis' '\n']);
end


% ====[remove not existing cases]=====================================
if ~isempty(s.m.missesIDX)
    if strcmp(xtype,'pairedttest')
        %remove groupwise
        misspair=[];
        for i=1:length(s.m.missesIDX)
            thisgrp=s.m.d(s.m.missesIDX(i),2);
            iv=strcmp(s.m.d(:,2),thisgrp);
            ivother=find(iv==0);
            misspair(i,:)=[ s.m.missesIDX(i) ivother(s.m.missesIDX(i) )];
        end
        misspairvec=misspair(:);
        s.m.files(  misspairvec  ) = [];
        s.m.d(      misspairvec,: ) = [];
        if s.m.isCovar==1
            s.m.covar(   misspairvec, :) = [];
        end
        
    else
        s.m.files(  s.m.missesIDX   ) = [];
        s.m.d(      s.m.missesIDX,: ) = [];
        if s.m.isCovar==1
            s.m.covar(   s.m.missesIDX, :) = [];
        end
    end

end
% =======UPDATE========================================


s.d=s.m.d;
%% ===============================================

if strcmp(xtype,'twosamplettest')
    d=a(2:end,[ x.mouseID_col x.group_col ]);
    d(:,1)=cellfun(@(a){[num2str(a)]},d(:,1));
    d(:,2)=cellfun(@(a){[num2str(a)]},d(:,2));
    s.d=d;
elseif strcmp(xtype,'pairedttest')
    d=a(2:end,[ x.mouseID_col x.group_col ]);
    d(:,1)=cellfun(@(a){[num2str(a)]},d(:,1));
    d(:,2)=cellfun(@(a){[num2str(a)]},d(:,2));
    s.d=d;
    
%     d=a(2:end,[ x.mouseID_colT1 x.mouseID_colT2 ]);
%     d(:,1)=cellfun(@(a){[num2str(a)]},d(:,1));
%     d(:,2)=cellfun(@(a){[num2str(a)]},d(:,2));
%     
%     itvec=([1:size(d,1)]');
%     tvec=[cellfun(@(a){[ 'T1-' num2str(a) ]},num2cell(itvec))
%         cellfun(@(a){[ 'T2-' num2str(a) ]},num2cell(itvec))];
%     
%     d=[[d(:,1); d(:,2)]   tvec ];
%     s.d=d;
    
elseif strcmp(xtype,'regression')
    d=a(2:end,[ x.mouseID_col x.regress_col ]);
    d(:,1)=cellfun(@(a){[num2str(a)]},d(:,1));
    s.d=d;
    s.regressNames=a(1,x.regress_col);
    
    r=cell2mat(cellfun(@(a){[str2num(num2str(a))]} ,a(2:end,[ x.regress_col ]) ));
    s.regvars     =r;
 
    
elseif strcmp(xtype,'onewayanova')
    d=a(2:end,[ x.mouseID_col x.group_col ]);
    d(:,1)=cellfun(@(a){[num2str(a)]},d(:,1));
    d(:,2)=cellfun(@(a){[num2str(a)]},d(:,2));
    
    if ~isempty(x.regress_col) %add regressvalues
        d(:, 5:5+length(x.regress_col)-1   ) = a(2:end,[ x.regress_col ]);
        s.regressname=he(x.regress_col);
    else
        s.regressname='';
    end
    
    s.d=d;
    %he(x.regress_col)
elseif strcmp(xtype,'fullfactorial')
    d=a(2:end,[ x.mouseID_col x.group_col ]);
    dfactornames=he(x.group_col);
    for i=1:length(dfactornames)
        d(:,i+1)=cellfun(@(a){[num2str(a)]},d(:,1+i))  ;
    end
    
    
    
    
    if ~isempty(x.regress_col) %add regressvalues
        d = [ d  [a(2:end,[ x.regress_col ]) ]   ];
        s.regressname=he(x.regress_col);
    else
        s.regressname='';
    end
    s.dfactornames=dfactornames;
    s.d=d;
    
end

s.d=s.d(cellfun('isempty',regexpi(s.d(:,1),'Nan')),:); %remove trailing NANs
s.d(:,1)=strrep(s.d(:,1),' ','');  %remove blanks
try
    s.d(:,2)=strrep(s.d(:,2),' ','');
end
%———————————————————————————————————————————————
%%   check existence of nifti-file
%———————————————————————————————————————————————
[files,~] = spm_select('FPListRec',x.data_dir,['^' x.inputimage '$']);  files=cellstr(files);

if strcmp(xtype,'fullfactorial')
    tbsize=1+length(s.dfactornames)+length(s.regressname);
    for i=1:size(s.d,1)
        ix=find(~cellfun('isempty',  strfind(files,[filesep  s.d{i,1}  filesep  ])  )  );% regexpi(files,s.d(i,1))));
        if length(ix)>1 ; error(['ix: more nifti-files found than expected']); end
        if ~isempty(ix)
            s.d(i,tbsize+1)={1};
            s.d(i,tbsize+2)=files(ix);
        else
            s.d(i,tbsize+1)={0};
        end
    end
    
    s.dh =   ['excelID' s.dfactornames he(x.regress_col)  'existNifti' 'niftiPath'] ;
elseif strcmp(xtype,'regression') 
    ncol=size(s.d,2);
    for i=1:size(s.d,1)
        ix=find(~cellfun('isempty',  strfind(files,[filesep  s.d{i,1}  filesep  ])  )  );% regexpi(files,s.d(i,1))));
        if length(ix)>1 ; error(['ix: more nifti-files found than expected']); end
        if ~isempty(ix)
            s.d(i,ncol+1)={1};
            s.d(i,ncol+2)=files(ix);
        else
            s.d(i,ncol+1)={0};
        end
    end  
    
%     for i=1:size(s.d,1)
%         ix=find(~cellfun('isempty',  strfind(files,[filesep  s.d{i,1}  filesep  ])  )  );% regexpi(files,s.d(i,1))));
%         if length(ix)>1 ; error(['ix: more nifti-files found than expected']); end
%         if ~isempty(ix)
%             s.d(i,3)={1};
%             s.d(i,4)=files(ix);
%         else
%             s.d(i,3)={0};
%         end
%     end
     
    
else
    for i=1:size(s.d,1)
        ix=find(~cellfun('isempty',  strfind(files,[filesep  s.d{i,1}  filesep  ])  )  );% regexpi(files,s.d(i,1))));
        if length(ix)>1 ; error(['ix: more nifti-files found than expected']); end
        if ~isempty(ix)
            s.d(i,3)={1};
            s.d(i,4)=files(ix);
        else
            s.d(i,3)={0};
        end
    end
end




if   strcmp(xtype,'twosamplettest')
    s.dh={'excelID' 'grp'            'existNifti' 'niftiPath'};
elseif strcmp(xtype,'pairedttest')
    s.dh={'excelID' 'timepoint'      'existNifti' 'niftiPath'};
elseif strcmp(xtype,'regression')
    s.dh={'excelID' 'regressval'     'existNifti' 'niftiPath'};
    
    reglabel=cellfun(@(a){['regrvec' num2str(a)]} ,num2cell(1:length(x.regress_col)) );
    
    s.dh=...
    ['excelID'   reglabel  'existNifti' 'niftiPath'];
    
elseif strcmp(xtype,'onewayanova')
    s.dh=[{'excelID' 'regressval'     'existNifti' 'niftiPath'} he(x.regress_col) ];
end


%———————————————————————————————————————————————
%%   CLASSES AND SUBGROUPS
%———————————————————————————————————————————————

if  strcmp(xtype,'twosamplettest')
    s.classes=unique(s.d(:,2))';
    for i=1:length(s.classes)
        nifiles=s.d(  find(strcmp(s.d(:,2),s.classes{  i  })) ,4);
        s= setfield(s,['grp_' num2str(i)],nifiles );
    end
elseif  strcmp(xtype,'pairedttest')
    
    s.classes=unique(s.d(:,2))';
    for i=1:length(s.classes)
        nifiles=s.d(  find(strcmp(s.d(:,2),s.classes{  i  })) ,4);
        s= setfield(s,['grp_' num2str(i)],nifiles );
    end
    
    
%     s.classes={'T1' 'T2'};
%     is=find(cellfun('isempty',regexpi(s.d(:,2),'^T1'))==0);
%     pairids=str2num(cell2mat(regexprep(s.d(is,2),'T1-','')));
%     ifind=@(a) find(~cellfun('isempty',a));
%     s.grp_1={};
%     s.grp_2={};
%     nok=1;
%     for i=1:length(pairids)
%         t1=ifind(regexpi(s.d(:,2),['^T1-'  num2str(pairids(i)) '$']));
%         t2=ifind(regexpi(s.d(:,2),['^T2-'  num2str(pairids(i)) '$']));
%         
%         if  sum([isempty(t2) isempty(t1)]) ==0  % matching string found
%             if  sum([ s.d{t1,3} s.d{t2,3}])  ==2   % files exist
%                 s.grp_1{nok,1} = s.d{t1,4};
%                 s.grp_2{nok,1} = s.d{t2,4};
%                 nok=nok+1;
%             end
%         end
%     end
    
    
elseif  strcmp(xtype,'regression')
    s.dh={'excelID' 'grp' 'regressval' 'niftiPath'};
%     s.grp_1=s.d(find(cell2mat(s.d(:,3))==1),4);
    
elseif  strcmp(xtype,'onewayanova')
    %     s.classes=unique(s.d(:,2))';
    %     for i=1:length(s.classes)
    %         nifiles=s.d(  find(~cellfun('isempty',regexpi(s.d(:,2),s.classes{  i  }))),4);
    %         s= setfield(s,['grp_' num2str(i)],nifiles );
    %     end
    %
    
end

f = fieldnames(x);
for i = 1:length(f)
    s=setfield(s, f{i}, getfield(x,f{i})   );
end

%% WORKDIR
%% OUTDIR
s.workpath=pwd;
outdir={};
if ~isempty(char(x.output_dir))
    if isempty(fileparts(x.output_dir)) %local path
        outdir=  fullfile(fileparts(x.data_dir), x.output_dir);
        mkdir(outdir);
        s.output_dir=outdir;
    else %fullPath
        outdir=char(x.output_dir);
        mkdir(outdir);
        s.output_dir=outdir;
    end
end

try
    if exist(fullfile(s.output_dir,'SPM.mat'))==2 %remove existing folder...if it contains SPM.mat
        if strcmp(pwd,s.output_dir)==1
            cd('..')
            s.workpath=pwd;
        end
        rmdir(s.output_dir,'s');
        mkdir(outdir);
    end
end

set(gcf,'userdata',s);


xvv.x=x;
xvv.s=s;
xvv.p=p;

% ==============================================
%%  save parameter
% ===============================================
par=x;
save(fullfile(outdir,'xstatParameter.mat'),'par');

% ==============================================
%%   save MIP
% ===============================================
mipfile=fullfile(outdir,'xstatMIP.mat');
makeMIP(x.AVGT,'show',0,'save', mipfile);


chkOK=1; % make OK-check



function repair_xstatParameter
% b.par
% ans = 
%          excelfile: 'F:\data6\voxwise\groupassignment.xlsx'
%        sheetnumber: 1
%        mouseID_col: 1
%          group_col: 2
%           data_dir: 'F:\data6\voxwise\dat'
%         inputimage: 'vimg.nii'
%               AVGT: 'F:\data6\voxwise\templates\AVGT.nii'
%                ANO: 'F:\data6\voxwise\templates\ANO.nii'
%     grp_comparison: '1vs2'
%               mask: 'F:\data6\voxwise\templates\AVGThemi.nii'
%          smoothing: 1
%     smoothing_fwhm: [0.2800 0.2800 0.2800]
%         output_dir: 'voxw_test2'
%       showSPMbatch: 1

%% === test : mandatory inputs============================================

par.ANO='F:\data6\voxwise\templates\ANO.nii';
par.AVGT= 'F:\data6\voxwise\templates\AVGT.nii';

F1=fullfile('F:\data6\voxwise\voxw_test2', 'xstatParameter.mat');
save(F1,'par');
showinfo2('..created/repaired',F1,[],1,[' -->[' F1 ']']);

%% ===============================================


function pref=getprefs

pref.nmaxclust= 3    ; %    ; - number of maxima per cluster [3]
pref.clustdist= 0.5  ; %mm  ; - distance among clusters {mm} [8]

pref.thresh       =  0.05 ;
pref.clustersize  =    1 ;
pref.mcp          = 'FWE' ;



function spmsetup(spmfile,visualmode)

if exist('visualmode')~=1
    visualmode=1;
end

if sum([~isempty(findobj(0,'tag','Graphics'))
        ~isempty(findobj(0,'tag','Interactive'))
        ~isempty(findobj(0,'tag','Interactive'))])  ~=3
    
    
    
    delete(findobj(0,'tag','Graphics'));
    delete(findobj(0,'tag','Interactive'));
    delete(findobj(0,'tag','Interactive'));
    
    %useotherspm(1);
    hf=findobj(0,'tag','vvstat');
    try; us=get(hf,'userdata'); end
    global xvv
    xvv_bk=xvv;
    
    if visualmode==1
        spm fmri
    else
        disp('..silent mode...');
        spm('defaults', 'fmri');
        spm_jobman('initcfg');
        spm_get_defaults('cmdline',true);
    end
    hf=findobj(0,'tag','vvstat');
    if isempty(hf)
        try
            xstat;
            hf=findobj(0,'tag','vvstat');
            set(hf,'userdata',us);
            global xvv
            xvv=xvv_bk;
        end
    end
    
end
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
%% local defs

pref=getprefs;
% ==============================================
%%
% ===============================================
global xvv
if ~isempty(xvv)
    if isfield(xvv,'s')==0
        if exist('spmfile') && exist(spmfile)==2 %SPM.mat-file
            outdir=fileparts(spmfile);
        elseif exist('spmfile') && exist(spmfile)==7 %its a path
            outdir=spmfile;
        else
            outdir=uigetdir(pwd,'select outdir-directory (location of "SPM.mat")');
        end
        if isnumeric(outdir)==1; disp('user cancelation'); return; end
        xvv.s.output_dir=outdir;
        par=load(fullfile(outdir,'xstatParameter.mat')); par=par.par;
        
        xvv.s.ANO =par.ANO;
        xvv.s.AVGT=par.AVGT;
    end
    
    
    outdir=xvv.s.output_dir;
    pref.mip = fullfile(outdir, 'xstatMIP.mat');
    pref.anofile   =xvv.s.ANO  ;%'F:\data3\eranet_VBM_test\templates\ANO.nii' ;%  which('sANO.nii' );
    pref.template  =xvv.s.AVGT  ;%which('sAVGT.nii');
    
else
    disp('xvv: empty');
end





% ==============================================
%%
% ===============================================




if 0
    pref.mip=which('AllenMip.mat');
    pref.anofile   =which('sANO.nii' );
    pref.fibfile   =which('sFIBT.nii' );
    pref.template  =which('sAVGT.nii');
end
% pref.nmaxclust= 3    ; %    ; - number of maxima per cluster [3]
% pref.clustdist= 0.5  ; %mm  ; - distance among clusters {mm} [8]
%
% pref.thresh       =  0.05 ;
% pref.clustersize  =    30 ;
% pref.mcp          = 'FWE' ;

if 0
    pref.mip= 'F:\data3\eranet_VBM_test\testmip.mat';
    file='F:\data3\eranet_VBM_test\templates\AVGT.nii';
    pref.mips      =makeMIP(file);
    % pref.mip=which('AllenMip.mat');
    pref.anofile   ='F:\data3\eranet_VBM_test\templates\ANO.nii' ;%  which('sANO.nii' );
    % pref.fibfile   =which('sFIBT.nii' );
    pref.template  ='F:\data3\eranet_VBM_test\templates\AVGT.nii'  ;%which('sAVGT.nii');
end

%% atlas
[atpa atname atext]=fileparts(pref.anofile);
pref.anofileXLS=fullfile(atpa,[atname '.xlsx']);
[~,~,a]=xlsread(pref.anofileXLS);
a(find(strcmp(cellfun(@(a){[ num2str(a)]} ,(a(:,1))),'NaN')),:)=[];

%----------------------------
global lab
if isempty(lab)
    [lab.ha lab.a  lab.xyz lab.xyzind]=rgetnii(pref.anofile)  ;% rgetnii(fullfile('O:\data\voxelwise_Maritzen4tool\templates','ANO.nii'));
    %[lab.hf lab.f  lab.fxyz lab.fxyzind]=rgetnii(pref.fibfile)  ;% r
    
    %% OLD VEERSION
    if 0
        xx = load('gematlabt_labels.mat');
        [table at] = buildtable(xx.matlab_results{1}.msg{1});
        lab.at=at;
        disp('..loading atlas');
    end
    
    %% NEW ANT-VERSION
    
    lab.at =a(2:end,:);%xlsTable
    lab.hat=a(1    ,:);%header
end

if isfield(lab,'template')==0
    lab.template= pref.template ;%'O:\data\voxelwise_Maritzen4tool\templates\AVGT.nii';
end

lab.pref=pref;








%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
global defaults
defaults.stats.results.mipmat={pref.mip};

hstat=findobj(0,'tag','vvstat');

h2=findobj(hstat,'tag','clustdist');
if isempty(get(h2,'string'))
    set(h2,'string',pref.clustdist);
    defaults.stats.results.volume.distmin = pref.clustdist;
end

h2=findobj(hstat,'tag','nmaxclust');
if isempty(get(h2,'string'))
    set(h2,'string',pref.nmaxclust);
    defaults.stats.results.volume.nbmax = pref.nmaxclust;
end

% ==============================================
%%   delete contrasts
% ===============================================
function deleteContrasts(e,e2,contrasts2delete)

%% ===============================================
hf=findobj(0,'tag','vvstat');
hb=findobj(0,'tag','loadothercontrast');
con=hb.String;
SPM=evalin('base','SPM');
if exist('contrasts2delete')~=1 || isempty(contrasts2delete)
    id=selector2(con,{'contrasts'},'position',[0.1285    0.1728    0.3674    0.6589],...
        'note' ,{'select contrasts to delete'},'title','delete contrasts');
else
    if ischar(contrasts2delete) && strcmp(contrasts2delete,'all');
    id=[1:length(SPM.xCon)];
    else
       id=intersect([1:length(SPM.xCon)],contrasts2delete);
    end
end





if isempty(id) || (length(id)==1 && id==-1); return; end
%% === test ============================================

% id=[1 3 5];
cprintf('*[1 0 1]',['deleting CONTRASTS' '\n']);
%% ===============================================


con0=SPM.xCon;
ncon=length(con0);
conkeep=setdiff([1:ncon],id);
conkeepNewName=[1: length(conkeep)];
spmpath=SPM.swd;
con1=con0(conkeep);

%delete NIFTIs
for i=1:length(id)
    f1=fullfile(spmpath,con0(id(i)).Vspm.fname );
    f2=fullfile(spmpath,con0(id(i)).Vcon.fname );
    if exist(f1)==2; delete(f1); end
    if exist(f2)==2; delete(f2); end 
end
%% ===============================================

%rename files
for i=1:length(con1)
% for i=1:length(con1)
    %-----Vspm
    n1=con1(i).Vspm.fname;
    [pa fin ext]=fileparts(n1);       n1=[fin ext];
    n2=[strtok(n1,'_') '_' pnum(i,4) '.nii'];
    
    f1=fullfile(spmpath, n1);
    f2=fullfile(spmpath, n2);
    if strcmp(f1,f2)==0
        movefile(f1,f2,'f');
    end
    
    % update struct
    con1(i).Vspm.fname=n2;
    hx=spm_vol(f2);
    des=hx.descrip; %change description
    des=regexprep(des,'- contrast.*:',['- contrast ' num2str(i) ':' ]);
    hx.descrip=des;
    spm_create_vol(hx);
    con1(i).Vspm=spm_vol(f2);
    
    %-----Vcon
    n1=con1(i).Vcon.fname;
    [pa fin ext]=fileparts(n1);       n1=[fin ext];
    n2=[strtok(n1,'_') '_' pnum(i,4) '.nii'];
         f1=fullfile(spmpath, n1);
        f2=fullfile(spmpath, n2);
   if strcmp(f1,f2)==0
        movefile(f1,f2,'f');
    end
    
    % update struct
    con1(i).Vcon.fname=n2;
    hx=spm_vol(f2);
    des=hx.descrip; %change description
    des=regexprep(des,' contrast.*:',[' contrast ' num2str(i) ':' ]);
    hx.descrip=des;
    spm_create_vol(hx);
    con1(i).Vcon=spm_vol(f2);
end

%% =======update struct========================================
SPM.xCon=con1;

save(fullfile(spmpath,'SPM.mat') ,'SPM' );
try; assignin('base','SPM', SPM); end
xstat('loadspm',spmpath);

%% ===============================================


%———————————————————————————————————————————————
%%   loadSPMmat-input
%———————————————————————————————————————————————
function loadSPMmat(e,e2)

global lab; %remove previous cluster
try; lab=rmfield(lab,'clusterregions'); end
spmsetup;
% [hReg,xSPM,SPM] = spm_results_ui;

[cmdmsg, hReg,xSPM,SPM] = evalc('spm_results_ui');
spmfile=fullfile(xSPM.swd,'SPM.mat');
cprintf('*[1 0 1]',[ 'Loading: '  ]); fprintf([ strrep(spmfile,[filesep],[filesep filesep]) '\n' ]);

try; assignin('base','hReg', hReg); end
try; assignin('base','xSPM', xSPM); end
try; assignin('base','SPM', SPM); end

loadothercontrast('initialize');
% update xstat-parameter
%% ===============================================

hf=findobj(0,'tag','vvstat');

thresh=xSPM.thresDesc;
if ~isempty(strfind(thresh,'unc.'));
    w.meth= 'none';
elseif ~isempty(strfind(thresh,'FWE'));
    w.meth= 'FWE';
elseif ~isempty(strfind(thresh,'FDR'));
    w.meth= 'FDR';
end

w.p=str2num(strrep(strtok(thresh,'('),'p<',''));
w.con=xSPM.Ic;
w.k =xSPM.k;


set(findobj(hf,'tag','mcp')        ,'string', w.meth);
set(findobj(hf,'tag','thresh')     ,'string', num2str(w.p));
set(findobj(hf,'tag','clustersize'),'string', num2str(w.k));

ht=findobj(hf,'tag','loadothercontrast');
set(ht,'value',w.con);

%———————————————————————————————————————————————
%%   loadSPMmat- fast
%———————————————————————————————————————————————
function loadSPMmatnoInput(e,e2,spmfile)

global lab; %remove previous cluster
try; lab=rmfield(lab,'clusterregions'); end

% spmsetup(spmfile);

if exist('spmfile')==0
    [files,dirs] = spm_select(1,'mat','select [SPM.mat]',[],pwd,'SPM.mat');
    spmfile=files;
else
    files=spmfile;
end

% spmsetup(spmfile);
evalc('spmsetup(spmfile)');

if isempty(files); return; end

%% get values from editfield___________________________________________
hg=findobj(0,'tag','vvstat');
prefs.mcp        = get(findobj(hg,'tag','mcp'           ),'string') ;
prefs.thresh     = get(findobj(hg,'tag','thresh'        ),'string') ;
prefs.clustersize= get(findobj(hg,'tag','clustersize'   ),'string') ;
try; prefs.thresh       =str2num(prefs.thresh      ); end
try; prefs.clustersize  =str2num(prefs.clustersize ); end




mb={};
mb{1}.spm.stats.results.spmmat = {files}; %{'O:\data\voxelwise_Maritzen4tool\test_1\SPM.mat'};
mb{1}.spm.stats.results.conspec.titlestr = '';
mb{1}.spm.stats.results.conspec.contrasts = 1;
mb{1}.spm.stats.results.conspec.threshdesc =prefs.mcp ;% 'FWE';
mb{1}.spm.stats.results.conspec.thresh     =prefs.thresh;%  0.05;
mb{1}.spm.stats.results.conspec.extent     =prefs.clustersize;% 0;
mb{1}.spm.stats.results.conspec.mask = struct('contrasts', {}, 'thresh', {}, 'mtype', {});
mb{1}.spm.stats.results.units = 1;
mb{1}.spm.stats.results.print = false;
% spm_jobman('run',mb);

% ___check contrasts__
aspm=load(fullfile(files));
%% ________________________________________________________________________________________________

if length(aspm.SPM.xCon)==0
   cprintf('*[1 0 1]',['This SPM-mat contains no contrasts. NO CONTRASTS DEFINED' '\n']); 
   cprintf('*[1 0 1]',['SOLUTION: ' '\n']); 
   disp([ 'HIT [new contrast]-button to manually define contrasts' ]);
   disp([ 'HIT [add contrast]-button to set contrasts from text-file' ]);
else
    evalc('spm_jobman(''run'',mb);');
end
%% ________________________________________________________________________________________________


cprintf('*[1 0 1]',[ 'Loading: '  ]); fprintf([ strrep(spmfile,[filesep],[filesep filesep]) '\n' ]); 

try; assignin('base','hReg', hReg); end
try; assignin('base','xSPM', xSPM); end
try; assignin('base','SPM', SPM); end

loadothercontrast('initialize');

drawnow;
hfig=findobj(0,'tag','vvstat');
figure(hfig);
uicontrol(findobj(hfig,'tag','loadothercontrast'));


%———————————————————————————————————————————————
%%  showSections
%———————————————————————————————————————————————
function showSections(e,e2)


spmsetup;
global lab
% if isem;pty(lab)
%     [lab.ha lab.a  lab.xyz lab.xyzind]=rgetnii(which('sANO.nii'))  ;% rgetnii(fullfile('O:\data\voxelwise_Maritzen4tool\templates','ANO.nii'));
%     xx = load('gematlabt_labels.mat');
%     [table at] = buildtable(xx.matlab_results{1}.msg{1});
%     lab.at=at;
%     disp('..loading atlas');
% end
%
% if isfield(lab,'template')==0
%     lab.template= 'O:\data\voxelwise_Maritzen4tool\templates\AVGT.nii';
% end



xSPM=evalin('base','xSPM');
hReg=evalin('base','hReg');
% pa=xSPM.swd
% avgt=which('sAVGT.nii');
spm_sections(xSPM,hReg,lab.template);



%% HOOK SPM  overlay
hgraph=findobj(0,'tag','Graphics');
if 1
    himg=get(findobj(hgraph,'tag','Transverse'),'parent');
    for i=1:3
        iptaddcallback(himg{i}, 'ButtonDownFcn', @fun_getlabel);
    end
end

%% add text for current anat. label
if isempty(ishandle(findobj(hgraph,'tag','anatomicallabel')))
    pos=get(himg{1},'position');
    hu=uicontrol('style','text','units','normalized');
    set(hu,'string','-','position',[.01  pos(2)+pos(4)+.01 1.3 .02 ] ,'backgroundcolor','w');
    set(hu,'tag','anatomicallabel','foregroundcolor',[0 .5 0],'HorizontalAlignment','left');
end

















function fun_getlabel(e,e2)
global lab
% global lab
% if isempty(lab)
%     [lab.ha lab.a  lab.xyz lab.xyzind]=rgetnii(which('sANO.nii'))  ;% rgetnii(fullfile('O:\data\voxelwise_Maritzen4tool\templates','ANO.nii'));
%
%     xx = load('gematlabt_labels.mat');
%     [table at] = buildtable(xx.matlab_results{1}.msg{1});
%     lab.at=at
%     disp('..loading atlas');
% end


hgraph=findobj(0,'tag','Graphics');
%% HOOK SPM  overlay
if 0
    himg=get(findobj(hgraph,'tag','Transverse'),'parent');
    for i=1:3
        iptaddcallback(himg{i}, 'ButtonDownFcn', @fun_getlabel);
    end
end

% if 0
%    c=findobj(gcf,'tag','hMIPax')
%    cimg=findobj(c,'type','image')
%     iptaddcallback(cimg, 'ButtonDownFcn', @fun_inside);
% end

%% MIPCURSOR
if 0
    c = findobj(0,'ButtonDownFcn','spm_mip_ui(''MoveStart'')')
    %     c=findobj(gcf,'tag','hMIPax')
    %  cimg=findobj(c,'type','image')
    iptaddcallback(c(1), 'ButtonDownFcn', @fun_inside);
    iptaddcallback(c(2), 'ButtonDownFcn', @fun_inside);
    iptaddcallback(c(3), 'ButtonDownFcn', @fun_inside);
end

if 0
    
    mipmat = spm_get_defaults('stats.results.mipmat');
    load(char(mipmat), 'DXYZ', 'CXYZ', 'scale');
    % DMIP = [DXYZ(2)+DXYZ(1), DXYZ(1)+DXYZ(3)];
    %-Coordinates of Talairach origin in multipane MIP image (Axes are 'ij' + rot90)
    % Transverse: [Po(1), Po(2)]
    % Sagittal  : [Po(1), Po(3)]
    % Coronal   : [Po(4), Po(3)]
    % 4 voxel offsets in Y since using character '<' as a pointer.
    Po(1)  =                  CXYZ(2) -2;
    Po(2)  = DXYZ(3)+DXYZ(1) -CXYZ(1) +2;
    Po(3)  = DXYZ(3)         -CXYZ(3) +2;
    Po(4)  = DXYZ(2)         +CXYZ(1) -2;
    
end





% %% INI GLOBAL for ATLAS
% if 0
%     global lab
%     [lab.ha lab.a  lab.xyz lab.xyzind]=rgetnii(fullfile('O:\data\voxelwise_Maritzen4tool\templates','ANO.nii'));
%
%     xx = load('gematlabt_labels.mat');
%     [table at] = buildtable(xx.matlab_results{1}.msg{1});
%     lab.at=at
%
% end

% if strcmp(get(get(e,'Parent'),'tag'),'hMIPax')
%     e2.IntersectionPoint([1 2])
% %   r1=findobj(gcf,'tag','hX1r')
% %  set(r1,'position',e2.IntersectionPoint([1 2]))
%     'bummmmmmmmmmmmmmmmmmmmmmmmmmmmmm'
%     return
% end



co=spm_mip_ui('getCoords');
global lab
co        =    single(co);
lab.xyz   =single(lab.xyz);
d         = lab.xyz-repmat(co,[1 size(lab.xyz,2)]);
d2        =sqrt(sum(  d(1,:).^2+d(2,:).^2+d(3,:).^2 ,1));
ix        =find(d2==min(d2));

ca      =lab.xyzind(:,ix);
id      =lab.a(ca(1),ca(2),ca(3));

% ==============================================
%%   old ANT-version
% ===============================================

% ixatlas =find([lab.at(:).id]==id);  % OLD-antVersion
% idfib       =lab.f(ca(1),ca(2),ca(3));
% ixfibatlas  =find([lab.at(:).id]==idfib);
% if isempty(ixatlas);
%     atlasname=[' &empty;GM '] ;%'no GM region'; %disp('no region found');
% else
%     atlasname=lab.at(ixatlas).name;
% end
%
% if isempty(ixfibatlas);
%     atlasfibname=[' &empty;WM ']; %disp('no region found');
% else
%     atlasfibname=lab.at(ixfibatlas).name;
% end
% ==============================================
%%   new VERSION via xls-file
% ===============================================
ixatlas =find(cell2mat(lab.at(:,4))==id);
if isempty(ixatlas);
    atlasname=[' &empty;GM '];
else
    atlasname=lab.at{ixatlas,1};
end
ixfibatlas=[];
atlasfibname='';%[' &empty;WM '];



%% get value
if 1
    xSPM=evalin('base','xSPM');
    distco=sum((xSPM.XYZmm-repmat(co,[1 size(xSPM.XYZmm,2)])).^2,1);
    ix2=find(distco==min(distco));
    %     disp([ xSPM.XYZmm(:,ix2)']);
    %     disp([co']);
    %     disp([xSPM.Z(ix2)]);
end


ht=findobj(hgraph,'tag','anatomicallabel');

set(ht,'style','popupmenu','string',['-'],'backgroundcolor',[1 1 1],'enable','on');
% set(ht,'style','popupmenu','string',['<html><b><font color="blue"> ERDE <font color="green">1<2</font>'],'backgroundcolor',[1 1 1],'enable','on')


% set(ht,'string',['<html><b><font color="gray"> raum <font color="blue"> ERDE <font color="green">1<2</font>'],'backgroundcolor',[1 1 1],'enable','on')

msg=[ '<html><b>' ...
    '<font color="red">'           [sprintf('Y=%2.3f ',xSPM.Z(ix2))]               ...
    '<font color="gray">'          [ ' [' sprintf('%2.3f %2.3f %2.3f',co)  '] ']    ...
    '<font color="blue">'          [atlasname ' '  ] ...
    '<font color="green">'         [atlasfibname] ...
    '</font>'];


% tx=['[' sprintf('%2.3f %2.3f %2.3f',co)  '] '  atlasname ];
tx=[ sprintf('Y=%2.3f ',xSPM.Z(ix2))   '[' sprintf('%2.3f %2.3f %2.3f',co)  '] '  atlasname ' |'  atlasfibname];
if isempty(ht);
    %disp(lab.at(ixatlas).name);
    cprintf([0 .4 0],[tx   '\n']);
else
    %     set(ht,'string',tx,'fontweight','bold');
    set(ht,'string',msg)
    
end

function extractData_call(e,e2)

extractdata(struct('isGUI',1));

function  [fiout g]=extractdata(e)
if 0
    [f1 f2]=xstat('extractdata'); %GUI-input
    [f1 f2]=xstat('extractdata',struct('path',pwd));
      [f1 f2]=xstat('extractdata',struct('path',pwd,'filename','extract_this.xlsx'));
end

cprintf('*[.6 .6 .6]',[ '..Extracting data ...wait...' ]);
[fiout g]=deal([]);
%% ====== [get data -1]=========================================
showTable();
TabDat=evalin('base','TabDat');
global lab
region=lab.clusterregions(:)';
t=TabDat.dat;
if isempty(t); 
    disp('...no results ...no data extraction possible...');
    return;
end
%% ===============check if original groupassignment-file exist================================
xSPM=evalin('base','xSPM');
SPM  = evalin('base','SPM');
par_file=fullfile(xSPM.swd, 'xstatParameter.mat');
if exist(par_file)==2
    par=load(par_file); par=par.par;
    if isfield(par,'excelfile')
        try
        [~,~,a]=xlsread(par.excelfile,par.sheetnumber);
        a=a(:,[par.mouseID_col par.group_col]);
        a=xlsprunesheet(a);
        ha=a(1,:);
        a=a(2:end,:);
        
        %a=a([2 1 5 4 3 6:end],:), %check resort
        
        
        files={SPM.xY.VY(:).fname}; files=files(:);
        [~,animal]=fileparts2(fileparts2(files));
        
      [c1 c2] = ismember([a],animal);
      group_resorted=a(c2(:,1),:);
        catch
            group_resorted=[];
        end
    end
end


%% ============[filename]===================================


[p nametag]=getparameter();% get mainParameter
finame=[ nametag '_NPC' p.nmaxclust '_SINGLEDATA' '.xlsx'];
paout=(fullfile(stradd(xSPM.swd,'res_',1),'data'));
if exist(paout)~=7
    mkdir(paout);
end
fpfile=fullfile(paout,finame);
% [fi pa]=uiputfile(fpfile,'save table as textfile');

if isfield(e,'path')~=1
    if isfield(e,'isGUI') && e.isGUI==1
    [fi pa]=uiputfile(fpfile,'save extrated data as excelfile');
    if isnumeric(fi); disp('..aborted'); return; end
    [~,fi,~]=fileparts(fi);
    fiout=fullfile(pa,[fi '.xlsx']);
    else
       fiout=fpfile;
    end
else
   
   if exist(e.path)~=7; mkdir(e.path); end
   
   if isfield(e,'filename')==1
      [~,fi,~]=fileparts(e.filename);
      fiout=fullfile(e.path,[fi '.xlsx']);
   else
      fiout=fullfile(e.path,finame) ; 
   end
end

f2=fiout;

% return




%% ====== [filename to save ]=========================================

% paout0=pwd;
% if isfield(e,'file')==1
%     [paout fi ext]=fileparts(e.file);
%     if isempty(paout)
%         paout=paout0;
%     end
%     f2=fullfile(paout,[ fi '.xlsx' ]);
% else
%     % GUI here!!!!
%     [fis pas]=uiputfile(fullfile(pwd,'*.xlsx'),' filename to save the extracted data');
%     if isnumeric(fis); disp('..aborted...'); return; end
%     f2=fullfile(pas,fis);
%     %f2=fullfile(pwd,'test.xlsx');
% end


%% ====== [extract data -1]=========================================
cords=zeros(size(t,1),3);
xyz_str={};
animal={};
for i=1:size(t,1)
    cords(i,:)=t{i,12};
    [d u]=spm_extractData(cords(i,:));
    if ~isempty(d)
        animal=u.animal;
    end
    if i==1
        d2=zeros(size(d,1), size(t,1) );
    end
    d2(:,i)=d;
    xyz_str{1,i}=['[' regexprep(num2str(cords(i,:)),'\s+',',') ']'];
end

if ~isempty(group_resorted)
    group=  group_resorted(:,2);
else
    group=   repmat({''},[length(animal) 1]);
end

b  =[ animal group num2cell(d2) ];
hb1 =['animal' 'group'  region  ];
hb2 =[{''}     {''}  xyz_str  ];


%% ====== [save data ]=========================================
sheetname='extractdata';
pwrite2excel(f2,{1 sheetname},hb1,hb2,b);

% colorize
if ~isempty(group_resorted)
    try
        warning off;
        unigroup=unique(group);
        col=cbrewer('qual','Pastel1',max([length(unigroup) 3 ]));
        for i=1:length(unigroup)
            ix=find(strcmp(group,unigroup{i}))+2;
            xlscolorizeCells(f2,sheetname,['[' num2str(ix(:)') '],[2]'],col(i,:) );
        end
    end
end
cprintf('*[.6 .6 .6]',[ 'DONE!' ' \n']);
showinfo2(' data extracted',f2);


fiout=f2;
g.hb1=hb1;
g.hb2=hb2;
g.b=b;

%% ===============================================
function showTable_CMD(e,e2)

hgraph=findobj(0,'tag','Graphics');
htable=findobj(hgraph,'tag','SPMList');
if isempty(htable)
    showTable();
end
%% ===============================================
global temp_out
[p nametag]=getparameter();% get mainParameter
% tb=maketable;
[tb s info]=maketable;
% s=cell2struct(s(:,2),s(:,1));
if ~isempty(regexpi2(tb,'no suprathreshold clusters found'))
    tb(cell2mat(cellfun(@(a){isempty(a)} ,tb )))=[];
    cprintf('*[1 0 1]',[ ' [' p.con '] Result: no suprathreshold clusters found' ' \n']);
    temp_out.con=p.con;
    temp_out.tb =tb;
    disp('<a href="matlab:global temp_out; disp(char(temp_out.tb));clear temp_out;">show information</a>')
  
   
else
  cprintf('*[0 .5 0]',[ ' [' p.con '] Result: ' ' \n']);
  disp(char(tb));
end

 %% ===============================================
 

function showTable(e,e2)
% TabDat = spm_list('List',xSPM,hReg);



spmsetup;

hgraph=findobj(0,'tag','Graphics');
set(hgraph,'units','norm');
pos=get(hgraph,'position');
pos(3)=.3;
set(hgraph,'position',pos);
% set(hgraph,'units','norm');

xSPM=evalin('base','xSPM');
hReg=evalin('base','hReg');


clustdist=get(findobj(0,'tag','clustdist'),'string');
nmaxclust=get(findobj(0,'tag','nmaxclust'),'string');
if ischar(clustdist); clustdist=str2num(clustdist); end
if ischar(nmaxclust); nmaxclust=str2num(nmaxclust); end

% TabDat = spm_list('List',xSPM,hReg,10,1,'')  ;%10 clusters 1mm appart
TabDat = spm_list('List',xSPM,hReg,nmaxclust,clustdist,'')  ;%10 clusters 1mm appart


assignin('base','TabDat', TabDat);


set(hgraph,'units','norm');
pos=get(hgraph,'position');
pos(3)=.6;
set(hgraph,'position',pos);

addlabels2table;


hpage1= findobj(hgraph,'tag','NextPage');
if ~isempty(hpage1)
    iptaddcallback(hpage1, 'Callback', @addlabels2table);
end

hpage2= findobj(hgraph,'tag','PrevPage');
if ~isempty(hpage2)
    iptaddcallback(hpage2, 'Callback', @addlabels2table);
end
function addlabels2table(e,e2)

TabDat=evalin('base','TabDat');
hgraph=findobj(0,'tag','Graphics');

%get TABLE
hgraph=findobj(0,'tag','Graphics');
htag=findobj(hgraph,'tag','ListXYZ');
cotab=str2num(char( (get(htag,'string'))))'; %table Coordinates

%% get labels
delete(findobj(hgraph,'tag', 'atlasregions'));
cc=[TabDat.dat{:,end}];
global lab
clusterregions=repmat({'-'},[ size(cc,2) 1]);


%% PREPARE THE LABELS
%regions do not exist
if isfield(lab,'clusterregions');
    if     size(cc,2)~=size(lab.clusterregions,1)
        lab=rmfield(lab,'clusterregions');
    end
end

if isfield(lab,'clusterregions')==0
    for i=1:size(cc,2)
        co=cc(:,i);
        co        = single(co);
        
        
        % find idx in table
        disttab=sum((cotab-repmat(co,[1 size(cotab,2)])).^2,1);
        ixtab=find(disttab==min(disttab));
        
        lab.xyz   = single(lab.xyz);
        d         = lab.xyz-repmat(co,[1 size(lab.xyz,2)]);
        d2        = sqrt(sum(  d(1,:).^2+d(2,:).^2+d(3,:).^2 ,1));
        ix        = find(d2==min(d2));
        
        ca      =lab.xyzind(:,ix);
        id      =lab.a(ca(1),ca(2),ca(3));
        % OLD-ANTver
        %ixatlas =find([lab.at(:).id]==id);
        % NEW ANTver
        ixatlas =find(cell2mat(lab.at(:,4))==id);
        if isempty(ixatlas);
            %             disp('no region found');
            %clusterregions{i}=lab.at(ixatlas).name
        else
            %             disp(lab.at(ixatlas).name);
            %clusterregions{i}=lab.at(ixatlas).name;  % OLD VERSION
            clusterregions{i} =lab.at{ixatlas,1}  ; % NEW VERSION
        end
    end
    lab. clusterregions=clusterregions;
else
    clusterregions=lab.clusterregions;
end





for i=1:size(cc,2)
    co=cc(:,i);
    co        = single(co);
    
    
    % find idx in table
    disttab=sum((cotab-repmat(co,[1 size(cotab,2)])).^2,1);
    ixtab=find(disttab==min(disttab));
    
    if strcmp(get(htag(ixtab),'visible'),'on')
        lab.xyz   = double(lab.xyz);
        
        %         d         = lab.xyz-repmat(co,[1 size(lab.xyz,2)]);
        %         d2        = sqrt(sum(  d(1,:).^2+d(2,:).^2+d(3,:).^2 ,1));
        %         ix        = find(d2==min(d2));
        %
        %         ca      =lab.xyzind(:,ix);
        %         id      =lab.a(ca(1),ca(2),ca(3));
        %         ixatlas =find([lab.at(:).id]==id);
        %         if isempty(ixatlas);
        %             %             disp('no region found');
        %             %clusterregions{i}=lab.at(ixatlas).name
        %         else
        %             %             disp(lab.at(ixatlas).name);
        %             clusterregions{i}=lab.at(ixatlas).name;
        %         end
        
        
        
        fs=get(htag(ixtab),'fontsize');
        units=get(htag(ixtab),'units');
        set(htag(ixtab),'units','characters');
        xyzpos=get(htag(ixtab),'position');
        %te=text( xyzpos(2)+3*fs, xyzpos(2) ,['BALU'],'hittest','off','units','characters',...
        te=text( xyzpos(1)+3*fs, xyzpos(2) ,clusterregions{i},'units','characters');
        set(te, 'color','b','fontweight','bold','tag', 'atlasregions');
        set(te,'ButtonDownFcn', @clickRegionInTable );
        set(htag(ixtab),'units','data');
        userdata=double(co);
        %         userdata=htag(ixtab);
        set(te,'userdata',userdata);
        
    end
    
end

%  set(hgraph,'units','normalized')


%  set(hgraph,'units','characters')


function clickRegionInTable(e,e2)
% ['disp(get(gcbo,''string''))'
% hxyz=get(e,'userdata')

xSPM=evalin('base','xSPM');
hReg=evalin('base','hReg');
%
% hgfeval(get(hxyz,'ButtonDownFcn'),hxyz)
% return
cprintf([0 .5 0],[get(e,'string') ' \n']);
hMIPax = findobj('tag','hMIPax');

spm_mip_ui('SetCoords',get(gcbo,'UserData'),hMIPax);
% %% ========show table in CMD-win =======================================
% if 0
%     TabDat=evalin('base','TabDat');
%     global lab
%     
%     tb=maketable;
%     disp(char(tb));
%     
% end


%% ===============================================
% create post-hoc code snippet
function code_posthoc(e,e2)
disp('...wait..');
t=preadfile(which([mfilename '.m'])); t=t.all;
il=[
    max(regexpi2(t,'%_###anchor_code_posthoc_start##'))
    max(regexpi2(t,'%_###anchor_code_posthoc_stop##'))
    ];
t=t(il(1)+1:il(2)-1);
uhelp(t,1,'name','code snippet post-hoc summary');
disp('Done');

return

%_###anchor_code_posthoc_start###

%% #ko  generate voxwise analysis output for each folder that contains an SPM-analysis
% #r COPY ENTIRE CONTENT AND MODIFY ACCODINGLY..
% 
% #b OUTPUT:
% [1] a powerpoint-file for each SPM-analysis-folder (filename based on SPM-dir-name)
% [2] an output-folder containing:
%      -the stat.table as excelfile
%      -the thresholded-volume accord. to the applied statistical specifications
% * here the following is PPT/excelfiles & volumes are made for
%   a) uncorrected at p=0.001
%   b) peak-cluster-threshold at p=0.001 with clusterSize-estimation
%   c) FWE-coorection at p=0.05
% ===============================================

warning off;
clc

 % ==============================================
 %% #km  mandatory inputs (change these paramters)
 % ===============================================
 % [1] pabase is the main-folder containing subfolders with SPM-analiys
pabase='H:\Daten-2\Imaging\AG_Maritzen\Processing_ANTX\allmice\voxwiseRes_24jan22\SMOnone';

 % [2] get DIRS of SPM-analysis, the folder "pabase" contains one or several subdirs with SPM-analyses
 % subfolders containing SPM-analyses starting with 'r_x_'  ..thus use '^r_x_.*' as filter
 % alternatively "spmdirs" (cell) can contain a list of manually set full-path-folders
 % note that each of the folders must contain a 'SPM.mat'-file
[spmdirs]=spm_select('FPList',pabase,'dir','^r_x_.*'); spmdirs=cellstr(spmdirs);

 % [3] fileName prefix of the resulting powerPoint file (stored in "pabase"-dir)
PPTFILEprefix  = 'result_voxw_26jan22';              % PowerPoint - fileNamePrefix

 % [4] output-folder of excel-files and thresholded volumes
outdir         = fullfile(pabase,'results_26jan22'); % output-folder for Excelfiles & volumes

% ==============================================
%% #b    some settings
% ===============================================
cd(pabase);
[~,spmdirsShort]=fileparts2(spmdirs); % shortNames of the SPM-dirs..used for PPT-file-names
mkdir(outdir); % make outdir-folder
% ==============================================
%% #b   loop over SPM-dirs
% ===============================================

for g=1:length(spmdirs) % SPM_folders
    thisDir=spmdirs{g};
    PPTFILE=fullfile(pabase,[PPTFILEprefix '_' spmdirsShort{g} '.pptx'   ]);
    
    % #b  =====LOAD SPMmat==========================================
    cd(thisDir);
    cf; xstat('loadspm',fullfile(pwd,'SPM.mat'));  

    % #b =====loop over directional contrasts (x<y, x>y)=============
    for con=1:2
        if mod(con,2)==1 % alterate PPT-backgroundcolor for each contrast
            bgcol=[1 1 1]; % PPT-bgColor
            DOC='new';  % for each SPM-DIR, if contrast is 1--> create "new" PPTfile
        else
            bgcol=[0.8941    0.9412    0.9020];
            DOC='add';   % add PPT-slide to existing PPT-file
        end
        
        % #m [1] SUMMARY: uncorrected, at p=0.001, clusterSize k=1 -------
        xstat('set',struct('MCP','none','thresh',0.001,'clk',1,'con',con,'show',0)); % set PARAMETER
        xstat('report',PPTFILE,struct('doc',DOC,'con',con,'bgcol',bgcol  )); % save stat. table in PPT
        xstat('report',PPTFILE,struct('show','volume','doc','add','con',con,'bgcol',bgcol  )); % save volume in PPT
        xstat('savevolume',outdir); % save tresholded volume
        xstat('export',outdir);     % save stat. table as excelfile
        
        % #m [2] SUMMARY: Peak-cluster with estimated clusterSize -------
        clustersize = cp_cluster_Pthresh(xSPM, 0.001); %estimate clusterSize
        xstat('set',struct('MCP','none','thresh',0.001,'clk',clustersize,'con',con,'show',0)); % set PARAMETER
        xstat('report',PPTFILE,struct('doc','add','con',con,'bgcol',bgcol    )); % save stat. table in PPT
        xstat('report',PPTFILE,struct('show','volume','doc','add','con',con,'bgcol',bgcol  ));% save volume in PPT
        xstat('savevolume',outdir); % save tresholded volume
        xstat('export',outdir);     % save stat. table as excelfile
        
        % #m [3] SUMMARY: FWE_CORRECTION, at p=0.05,  clusterSize k=1 -------
        xstat('set',struct('MCP','FWE','thresh',0.05,'clk',1,'con',con,'show',0)); % set PARAMETER
        xstat('report',PPTFILE,struct('doc','add','con',con,'bgcol',bgcol    )); % save stat. table in PPT
        xstat('report',PPTFILE,struct('show','volume','doc','add','con',con,'bgcol',bgcol  )); % save volume in PPT
        xstat('savevolume',outdir); % save tresholded volume
        xstat('export',outdir);     % save stat. table as excelfile
        
    end
end
cd(pabase);

%_###anchor_code_posthoc_stop###




function [fileout gg]=export(file,s)
fileout=[];
gg=   struct();
%===================================================================================================
% ==============================================
%%   examples:
% ===============================================
% xstat('export');                                    %save table as Excelfile with predefined path/name
% xstat('export',pwd);                                %save table as Excelfile with user-defined path and predefined name
% xstat('export' ,fullfile(pwd,'result_123.xlsx'));   %save table as Excelfile with userdefined path/name

%% examples
%     %% programmatically save as *TXT-file*
%     % save as file 'testZ.txt' as TXT-file (type=2)
%     xstat('export',fullfile(pwd,'testZ.txt'),struct('type',2));
%     % save as file ('x_c_radial_dif__1ko2ko_GT_1wt2ko__FWE0.txt'), filename
%     % is constructed from internal parameter , as TXT-file (type=2)
%     xstat('export',pwd,struct('type',2));
%     % save as file ('myPrefix_x_c_radial_dif__1ko2ko_GT_1wt2ko__FWE0.txt'),
%     %filename is constructed from internal parameter , as TXT-file (type=2),
%     %add prefix 'myPrefix_'
%     xstat('export',pwd,struct('type',2,'prefix','myPrefix_'));
%     % save as file 'myPrefix_testZ2.txt' as TXT-file (type=2), add prefix 'myPrefix_'
%     xstat('export',fullfile(pwd,'testZ2.txt'),struct('type',2,'prefix','myPrefix_'));
%     
%     %% programmatically save as *EXCEL-file*
%     % save as file 'testZ.xlsx' as Excel-file
%     xstat('export',fullfile(pwd,'testZ.xlsx'))
%     % same as...
%     xstat('export',fullfile(pwd,'testZ.xlsx'),struct('type',1));
%     % save as file ('x_c_radial_dif__1ko2ko_GT_1wt2ko__FWE0.xlsx'), filename
%     % is constructed from internal parameter , as Excel-file (type=1)
%     xstat('export',pwd);
%     %same as..
%     xstat('export',pwd,struct('type',1));
%     % save as file ('myPrefix_x_c_radial_dif__1ko2ko_GT_1wt2ko__FWE0.xlsx'),
%     %filename is constructed from internal parameter , as Excel-file (type=1),
%     %add prefix 'myPrefix_'
%     xstat('export',pwd,struct('type',1,'prefix','myPrefix_'));
%     % save as file 'myPrefix_testZ3.txt' as Excel-file (type=1), add prefix 'myPrefix_'
%     xstat('export',fullfile(pwd,'testZ3.txt'),struct('type',1,'prefix','myPrefix_'));
%     
    

% "export"-structParameter -----
s0.type=1 ; %save as: {numeric value}, [1] excelfile or [2] textfile
s0.prefix=''; % <optional> add prefix string  to fileName

if isempty(s)==1
    s=struct();
end
s=catstruct(s0,s);

%% =======[get tabl+info]========================================
[p,nametag,~,q]=getparameter();% get mainParameter
[tb tbnumeric add]=maketable; %get TABLES
% ==============================================
%%   [1] SAVE as txt-file
% ===============================================

if s.type==2 %text--file
    if isdir(file)
        pa=file;
        fi=[ nametag];
    else
        [pa fi ext]=fileparts(file);
    end
    [~,fi,~]=fileparts(fi);
    fiout=fullfile(pa,[s.prefix fi '.txt']);
    pwrite2file(fiout,tb);
    
    fileout=fiout;
    g.tb=tb;
    try
        disp(['saved table <a href="matlab: explorerpreselect(''' fiout ''')">' fiout '</a>']);
    end
    
    return
end
% ==============================================
%%   [2] SAVE as Excel-file
% ===============================================
if isempty(file)
   pa= fullfile(q.resultsDataDir  );
   fi= nametag;
else
    if isdir(file)
        pa=file;
        fi=[ nametag];
    else
        [pa fi ext]=fileparts(file);
    end
end
% [~,fi,~]=fileparts(fi);
fiout=fullfile(pa,[s.prefix fi '.xlsx']);



% disp(fiout);
% return
%% =========get table and info ======================================
xSPM=evalin('base','xSPM');
SPM=evalin('base','SPM');
hg=findobj(0,'tag','vvstat');
%% ===============================================
% char(SPM.xY.P)
% xSPM.Ic
nifiles=SPM.xY.P;
[pani fini exni]=fileparts2(nifiles);
[~,  subdir ]  =fileparts2(pani);
NIIfiles=cellfun(@(a,b){[ a b ]}, fini,exni);
% ==============IPARAMETER=================================
lg={};
lg(end+1,1:2)= {'Image         ' NIIfiles{1}};
lg(end+1,1:2)= {'contrast      ' xSPM.title};
lg(end+1,1:2)= {'MCP           ' get(findobj(hg,'tag','mcp'),'string')};
lg(end+1,1:2)= {'Threshold     ' ['p<' num2str(get(findobj(hg,'tag','thresh'),'string'))]};
lg(end+1,1:2)= {'CLustersize   ' ['k=' get(findobj(hg,'tag','clustersize'),'string')]};
lg(end+1,1:2)= {'contrastName  ' SPM.xCon(xSPM.Ic).name};
lg(end+1,1:2)= {'contrastNo    ' ['No-' num2str(xSPM.Ic)]};
lg(end+1,1:2)= {'statstic      ' SPM.xCon(xSPM.Ic).STAT };
if min(size(SPM.xCon(xSPM.Ic).c))==1
    lg(end+1,1:2)= {'contrastDir  ' [ '[' num2str(SPM.xCon(xSPM.Ic).c(:)') ']']};
else
    %lg=[ lg;{'contrastDir: '} ;plog([],num2cell(SPM.xCon(xSPM.Ic).c),0,'','plotlines=0')  ]
    lg(end+1,1:2)= {'contrastDir ' ''};
    dx=plog([],num2cell(SPM.xCon(xSPM.Ic).c),0,'','plotlines=0');
    lg=[lg;[ repmat({''},size(dx,1),1) dx ]];
end
lg(end+1,1:2)={'dir           : ' xSPM.swd };
% ==============INPUT data rable=================================
lg(end+1,1:2)={['']};
lg(end+1,1)= {['INPUT-DATA*** ']};
dx=[ subdir nifiles  num2cell(SPM.xX.X)   ];
hdx= repmat({''},[1 size(dx,2) ]);
hdx([ 1 2 ])={'ANIMAL/Dir'  'Path' };
lg(end+1:end+size(dx,1)+1,1:size(dx,2) )=[hdx; dx];
lg(end+1,1:2)={['']};
% ===========ADD INFO====================================
lg(end+1,1)= {['ADDITIONAL INFO*** ']};
lg(end+1:end+size(add,1),2 )=[add];

% ======[1]WRITE INFO-sheet=========================================
hlg=repmat({''},[1 size(lg,2) ]);
hlg(1:2)={'Field' ,'value'};
pwrite2excel(fiout,{1 'info'},hlg,[],lg);

% ========[2]WRITE DATA-sheet =======================================
%% (b)---write data
% pwrite2excel(fiout,{2 sheetname},tbnumeric(1,:),tbnumeric(2,:),tbnumeric(3:end,:));
pwrite2excel(fiout,{2 'voxstat'},tbnumeric(1,:),tbnumeric(2,:),tbnumeric(3:end,:));
fileout=fiout;
gg.hlg=hlg;
gg.lg=lg;
% ========[3]WRITE NOTE =======================================
try
    note={
        ['img: ' NIIfiles{1}]
        ['con: '  xSPM.title]
        ['MCP: ' get(findobj(hg,'tag','mcp'),'string')  ]
        ['TR: ' num2str(get(findobj(hg,'tag','thresh'),'string')) ]
        ['k : ' get(findobj(hg,'tag','clustersize'),'string')]
        };
    xlsinsertComment(fiout,note, 2, 6, 11);
end
%% ===============================================
showinfo2('voxSTAT-excelfile',fiout);


function exporttable(e,e2); %textfile
tb=maketable;
if isempty(tb); return; end
% uhelp(plog({}, [he;d2],0,'','s=0'),1)
uhelp(tb,1);
%% ======name suggestion+ UI-save as  ================================
[p,nametag,~,q]=getparameter();% get mainParameter
finame=[nametag '.txt'];
pa=q.resultsDataDir;
fpfile=fullfile(pa,finame);
[fi pa]=uiputfile(fpfile,'save table as textfile');
if ischar(fi)
    [~,fi,~]=fileparts(fi);
    fiout=fullfile(pa,[fi '.txt']);
    pwrite2file(fiout,tb);
    try
%         disp(['saved table <a href="matlab: explorerpreselect(''' fiout ''')">' fiout '</a>']);
        showinfo2('saved TXT-table',fiout);
    end
end

function exporttableXLS(e,e2)

[p,nametag,~,q]=getparameter();% get mainParameter
finame=[nametag '.xlsx'];
pa=q.resultsDataDir;
fpfile=fullfile(pa,finame);
% [fi pa]=uiputfile(fpfile,'save table as textfile');

[fi pa]=uiputfile(fpfile,'save table as excelfile');
if isnumeric(fi); return; end
[~,fi,~]=fileparts(fi);
fiout=fullfile(pa,[fi '.xlsx']);
disp('...export table..wait..');
xstat('export',fiout);
disp('DONE!');


function [tb tbnumeric info]=maketable
% spm_list('TxtList',r,1)

[p nametag]=getparameter();% get mainParameter
global lab

TabDat=evalin('base','TabDat');
r=TabDat;
%----------
add={};
add(end+1,1)={r.str};
for i=1:size(r.ftr,1)
    add(end+1,1)={  sprintf(r.ftr{i,1},r.ftr{i,2})   };
end
% [3]----info
info=add;
%---------

if isempty(r.dat)
   % disp(['no suprathreshold clusters found - nothing saved']);
    %tb=[];
    tbnumeric=[fieldnames(p) struct2cell(p) ];
    tbnumeric(end+1,:)={'Result' 'no suprathreshold clusters found'} ;
    
    tb=plog([],tbnumeric,0,'','plotlines=0');
    tb=[tb ; repmat({''},5,1) ;add ];
    return
end

dat=[r.dat(:,1:end-1) num2cell([r.dat{:,end}]')];
dat(:,end+1)=lab.clusterregions;
d2=dat;
for i=1:size(d2,2)-1
    d2(:,i)=cellfun(@(a){ sprintf('%10.5g', a)},dat(:,i));
end
v=[12:14];
for i=v
    d2(:,i)=cellfun(@(a){ sprintf('%5.2f', a)},dat(:,i));
end

d2(:,9)  =cellfun(@(a){ sprintf('%4.3f', a)},dat(:,9));
d2(:,10) =cellfun(@(a){ sprintf('%4.3f', a)},dat(:,10));
d2(:,2)  =cellfun(@(a){ sprintf('%4.0i', a)},dat(:,2));
d2(:,5)  =cellfun(@(a){ sprintf('%6.0i', a)},dat(:,5));

he=r.hdr(1:2,1:end-1);
he=[he {'x' 'y' 'z'  'Labels'; 'mm' 'mm' 'mm' '-'}];
% %----------
% add={};
% add(end+1,1)={r.str};
% for i=1:size(r.ftr,1)
%     add(end+1,1)={  sprintf(r.ftr{i,1},r.ftr{i,2})   };
% end
% % [3]----info
% info=add;
% %---------

r2=plog({}, [he;d2],0,'','s=0;plotlines=0');
lin={repmat('=',1,length(r2{1}))};
tb=[lin; r2(1:2);lin; r2(3:end);lin; add];

%[2] numeric table for excel-export ------------
tbnumeric=[he;dat];

function show_vol_extrafigure(e,e2)
global lab
[p nametag paramtag  q]=getparameter();
f1=lab.template ;%'o:\antx\mritools\ant\templateBerlin_hres\sAVGT.nii'
[fi pa]=uigetfile(fullfile(q.resultsDataDir,'*.nii'),'select NIFTI to overlay');
if isnumeric(fi); return ; end
f2=fullfile(pa,fi);

% orthoslice({lab.template,'thresh_svimg__control_LT_mani__FWE0.05k1.nii'},'mode','ovl','alpha',.5,'blobthresh',0);
orthoslice({lab.template,f2},'mode','ovl','alpha',.5,'blobthresh',0);

% function getpaths()
% xSPM=evalin('base','xSPM');
% [root sub]=fileparts(xSPM.swd)


function show_mricron(e,e2)
global lab

[p nametag paramtag  q]=getparameter();
if exist(q.resultsDataDir)~=7
    mkdir(q.resultsDataDir);
end

f1=lab.template ;%'o:\antx\mritools\ant\templateBerlin_hres\sAVGT.nii'
[fi pa]=uigetfile(fullfile(q.resultsDataDir, '*.nii'),'select NIFTI to overlay');
if isnumeric(fi); return ; end
f2=fullfile(pa,fi);

exefile=fullfile(fileparts(fileparts(fileparts(which('ant.m')))),'mricron','mricron.exe' );

[ha a]=rgetnii(f2);
lim=[min(a(:)) max(a(:))];
v1=['!start ' exefile ' ' f1 ' '];
v2=['-o ' f2 ' '];
v3=['-c -28 -l ' num2str(lim(1)) ' -h ' num2str(lim(2)) ' -b 40'];
% v3=['-c -28 -l ' num2str(lim(1)) ' -h ' num2str(lim(2)) ];
eval([v1 v2 v3]);

% !start o:\antx\mricron\mricron.exe o:\antx\mritools\ant\templateBerlin_hres\sAVGT.nii -o O:\data\voxelwise_Maritzen4tool\bla2.nii -c -28 -l 6 -h 10 -b -0
% !start o:\antx\mricron\mricron.exe o:\antx\mritools\ant\templateBerlin_hres\sAVGT.nii -o O:\data\voxelwise_Maritzen4tool\bla2.nii -c -28 -l 6.5488 -h 13.4955 -b -0

function [fileout g]=savevolume(file,s)

% "savevolume"-structParameter -----
% s0.type=1 ; %save as: {numeric value}, [1] excelfile or [2] textfile
s0.prefix=''; % <optional> add prefix string  to fileName
if isempty(s)==1
    s=struct();
end
s=catstruct(s0,s);

[fileout g]=save_threshvolume([],[],file,s);

% examples:
% xstat('savevolume');      %store NIFTI in predefined pwd with predefined name
% xstat('savevolume',pwd);  %store NIFTI in pwd with predefined name
% xstat('savevolume',fullfile(pwd,'result2.nii')); save NIFTI with user-defined path/name
% 
function [fileout g]=save_threshvolume(e,e2,file,s)
fileout=[];
g=struct();

xSPM = evalin('base','xSPM;');
XYZ  = xSPM.XYZ;

action='thresh';
switch lower(action)
    case 'thresh'
        Z = xSPM.Z;
        
    case 'binary'
        Z = ones(size(xSPM.Z));
        
    case 'n-ary'
        Z       = spm_clusters(XYZ);
        num     = max(Z);
        [n, ni] = sort(histc(Z,1:num), 2, 'descend');
        n       = size(ni);
        n(ni)   = 1:num;
        Z       = n(Z);
        
    case 'current'
        [xyzmm,i] = spm_XYZreg('NearestXYZ',...
            spm_results_ui('GetCoords'),xSPM.XYZmm);
        spm_results_ui('SetCoords',xSPM.XYZmm(:,i));
        
        A   = spm_clusters(XYZ);
        j   = find(A == A(i));
        Z   = ones(1,numel(j));
        XYZ = xSPM.XYZ(:,j);
        
    otherwise
        error('Unknown action.');
end
%% =========[get parameter]======================================

[p nametag]=getparameter();% get mainParameter

[root sub]=fileparts(xSPM.swd);
outdir=fullfile(root, ['res_' sub],'data');
if exist(outdir)~=7
    mkdir(outdir);
end


%% ======check inputs=========================================
if exist('s')~=1
    s.prefix='';
end

if exist('file')~=1
    [fi pa]=uiputfile(fullfile(outdir,[ 'thresh_' nametag  '.nii']),'save thresholded nifti-volume as..');
    if isnumeric(fi); return; end
    fiout=fullfile(pa, [s.prefix strrep(fi,'.nii','.nii') ]);
else
    
    if isempty(file)
        pa =outdir;
        fi =nametag;
    else
        if isdir(file)
            pa =file;
            fi =nametag;
        else
            [pa fi ext]=fileparts(file);
        end
    end
    %[~,fi,~]=fileparts(fi);
    fi=regexprep(fi,{'#',':' '\s+'},'_') ; % issue with writing
    fiout=fullfile(pa,[s.prefix fi '.nii']);
end

%  disp(fiout);
% return
%% ==========[save volume]=====================================
global lab
disp('...saving volume...wait..');

spm_write_filtered(Z, XYZ, xSPM.DIM, xSPM.M,...
    sprintf('SPM{%c}-filtered: u = %5.3f, k = %d',xSPM.STAT,xSPM.u,xSPM.k),fiout);
% showinfo2('voxSTAT-volume',lab.template,fiout);
showinfo2('voxSTAT-volume',lab.template,fiout,7);
disp('Done!');

fileout=fiout;
g.bgimg=lab.template;


% ==============================================
%%     MODELS
% ===============================================
%———————————————————————————————————————————————
%%   userdefined
%———————————————————————————————————————————————
function userdefined(e,e2)
spmsetup ;
spm_jobman;
%———————————————————————————————————————————————
%%   paired-sample ttest
%———————————————————————————————————————————————
function pairedsampleTest(e,e2,varargin)
voxstat_pairedsampleTest();
%———————————————————————————————————————————————
%%   onewayanova
%———————————————————————————————————————————————
function onewayanova(e,e2,varargin)
voxstat_onewayANOVA();
%———————————————————————————————————————————————
%%   onewayanova-within
%———————————————————————————————————————————————
function onewayanova_within(e,e2,varargin)
voxstat_onewayANOVAwithin();
%———————————————————————————————————————————————
%%   fullfactorial
%———————————————————————————————————————————————
function fullfactorial(e,e2,varargin)
voxstat_multifactorial();
%———————————————————————————————————————————————
%%   flexfactorial
%———————————————————————————————————————————————
function flexfactorial(e,e2,varargin)
voxstat_flexfactorial();

%———————————————————————————————————————————————
%%   twosampleTest
%———————————————————————————————————————————————
function twosampleTest(e,e2,varargin)
voxstat_twosampleTest();
%———————————————————————————————————————————————
%%  %% multiple regression
%———————————————————————————————————————————————
function multipleregression(e,e2,varargin)
voxstat_regression();


function fmakebatch(callingfile )
global xvv
x=xvv.x;
x.stattype = xvv.xtype;
x=orderfields(x,[length(fieldnames(x)) 1:length(fieldnames(x))-1]);
% xmakebatch(xvv.x ,  xvv.p   , mfilename);
p=[  {'stattype' '' 'STATISTICAL TEST' ''  } ;xvv.p ];
xmakebatch(x , p   , mfilename);


function restoreContrasts(e,e2)
isok=1;
try; xSPM=evalin('base','xSPM');
catch;
    isok=0;   
end
try; SPM=evalin('base','SPM');
catch;
    isok=0;
end
if isok==0;
    disp('..nothing to restore use [Load-Con1]-Btn to select SPM.mat!');
    return
end
spmfile=fullfile(xSPM.swd,'SPM.mat');
loadspm(spmfile);


function updateContrastindex
%% ===============================================

hf=findobj(0,'tag','vvstat');
ht=findobj(hf,'tag','contraststring');

hl=findobj(hf,'tag','loadothercontrast');

s=['contrast:' num2str(hl.Value) '/' num2str(length(hl.String))];
set(ht,'string',s);
%% ===============================================

function loadothercontrast(e,e2,varargin)




try; xSPM=evalin('base','xSPM');catch; return; end
try; SPM=evalin('base','SPM'); catch; return; end



if ischar(e) && strcmp(e,'initialize')
    %% initialize
    e2=findobj(0,'tag','loadothercontrast');
    u.cons={SPM.xCon(:).name}';
    set(e2,'userdata',u);
    
    %thiscon=find(~cellfun('isempty',strfind(u.cons,xSPM.title)));
    thiscon=(find(strcmp(u.cons,xSPM.title)));
    if length(thiscon)>1
        if e2.Value<=length(u.cons)
           thiscon=e2.Value; 
        else
           thiscon=thiscon(1) ;
        end
    end
    cons=u.cons;
    %     cons{thiscon}=['<html><font color="green"><b>' u.cons{thiscon} '</font>'];
    %     % web('text://<font color="green">This is some text!</font>')
    set(findobj(0,'tag','loadothercontrast'),'string',[cons],'value',thiscon);
    
    
    ht=findobj(0,'tag','txtpath');
    try
        SPM=evalin('base','SPM');
        [~,spmpath]=fileparts(SPM.swd);
        set(ht,'string',['SPM.mat: ' spmpath]);
    catch
        set(ht,'string',['SPM.mat: <not specified>']);
    end
    updateContrastindex();
    return
end

%% change contrast
if ishandle(e)
    e2=findobj(0,'tag','loadothercontrast');
    ic=get(e2,'value');
    
    w.swd=xSPM.swd ;% 'O:\data\voxelwise_Maritzen4tool\tests3'
    w.units= {'mm'  'mm'  'mm'};
    w.Ic= ic;
    w.Im= [];
    w.pm= [];
    w.Ex= [];
    w.title= '';
    w.thresDesc= 'FWE';
    w.u= 0.0500;
    w.k= 0;
    
    %% get values from editfield___________________________________________
    
    prefs.mcp        = get(findobj(gcf,'tag','mcp'           ),'string') ;
    prefs.thresh     = get(findobj(gcf,'tag','thresh'        ),'string') ;
    
    % get cluster-Size
    if strcmp(get(findobj(gcf,'tag','clustersize'   ),'string'),'auto')
        clustersize=cp_cluster_Pthresh(xSPM, str2num(prefs.thresh)  )
        set(findobj(gcf,'tag','clustersize'),'string', num2str(clustersize));
    end
    
    prefs.clustersize= get(findobj(gcf,'tag','clustersize'   ),'string') ;
    
    try; prefs.thresh       =str2num(prefs.thresh      ); end
    try; prefs.clustersize  =str2num(prefs.clustersize ); end
    w.thresDesc = prefs.mcp;
    w.u         = prefs.thresh;
    w.k         = prefs.clustersize;
    
    
    
    if 0
        %% OVERRIDE BASED ON PREVIOUSLY LOADED CONTRAST
        try
            %     [num2str(xSPM.k)   xSPM.thresDesc]
            xSPMold=evalin('base','xSPM');
            thresh=xSPMold.thresDesc;
            if ~isempty(strfind(thresh,'unc.'));
                w.thresDesc= 'none';
            else
                w.thresDesc= 'FWE';
            end
            w.u=str2num(strrep(strtok(thresh,'('),'p<',''));
            w.k        = xSPMold.k        ;
            w.Ex       = xSPMold.Ex;
        end
    end
    
    
   % [hReg,xSPM,SPM] = spm_results_ui('setup',  w);
    [cmd hReg,xSPM,SPM] = evalc('spm_results_ui(''setup'',  w)');
    try; assignin('base','hReg', hReg); end
    try; assignin('base','xSPM', xSPM); end
    try; assignin('base','SPM', SPM); end
    
    loadothercontrast('initialize',[]);
    
    
    hfig=findobj(0,'tag','vvstat');    %SHOW SECTIONS
    showvol=get(findobj(hfig,'tag','showSectionstoggle'),'value') ;
    if showvol==1 ;        showSections([],[]) ;     end
    
    %BACK TO GUI
    drawnow;
    figure(hfig);
    updateContrastindex();
    %     thiscon=find(~cellfun('isempty',strfind(u.cons,xSPM.title)));
    %     cons=u.cons;
    %     cons{thiscon}=['<html><font color="green"><b>' u.cons{thiscon} '</font>'];
    %     % web('text://<font color="green">This is some text!</font>')
    %     set(findobj(0,'tag','loadothercontrast'),'string',[cons],'value',thiscon);
end

function addcontrast(e,e2)
xaddContrasts();


function KeyPress(e,e2)
hf=findobj(0,'tag','vvstat');
if strcmp(e2.Character,'+') | strcmp(e2.Character,'-')
    hb=findobj(hf,'tag','loadothercontrast');
    fs=hb.FontSize;
    if strcmp(e2.Character,'+')
        fs=fs+1;
    else
        fs=fs-1; 
    end
    if fs>1
        hb.FontSize=fs;
        global xvv;
        xvv.fs=fs;
    end
    
    
end


function loadspm(file)


xstat;

file=strrep(file,[filesep 'SPM.mat'],'');
file=fullfile(file,'SPM.mat');
if isempty(findobj(0,'tag','Graphics'))
    cprintf('*[1 0 1]',[ '...please wait...loading SPM' '\n' ]);
end
loadSPMmatnoInput([],[],file);

function setparam(s)

if isfield(s,'show')==0
    s.show=0;
end

hf=findobj(0,'tag','vvstat');
figure(hf);

if isfield(s,'MCP')
    set(findobj(hf,'tag','mcp'),'string', s.MCP );
end
if isfield(s,'thresh')
    set(findobj(hf,'tag','thresh'),'string', s.thresh );
end
if isfield(s,'clk')
    set(findobj(hf,'tag','clustersize'),'string', s.clk );
end

if isfield(s,'con')
    lb=findobj(hf,'tag','loadothercontrast');
    if isnumeric(s.con) && s.con>0 && s.con<=length(lb.String);
        lb.Value=s.con;
    end
end

if  s.show==1;
    hgfeval(get(lb,'callback'),lb);
end

%         ['TR: ' get(findobj(hg,'tag','thresh'),'string')]
%         ['CLustersize: ' get(findobj(hg,'tag','clustersize'),'string')]
function [p nametag paramtag  q]=getparameter()
%% create parameter
%% p     : struct with main critical parameters
% nametag:
%% ===========[p: struct with main critical parameters ]=====================
drawnow;drawnow;drawnow;
xSPM=evalin('base','xSPM');
SPM=evalin('base','SPM');
hg=findobj(0,'tag','vvstat');


ht=findobj(hg,'tag','loadothercontrast');

nifiles=SPM.xY.P;
[pani fini exni]=fileparts2(nifiles);
exni=strrep(exni,',1','');
[~,  subdir ]  =fileparts2(pani);
NIIfiles=cellfun(@(a,b){[ a b ]}, fini,exni);
p.img       =NIIfiles{1};
p.connum    =num2str(ht.Value) ;%xSPM.title;
p.con       =ht.String{ht.Value} ;%xSPM.title;
p.mcp       =get(findobj(hg,'tag','mcp'),'string');
p.TR        = num2str(get(findobj(hg,'tag','thresh'),'string')) ;
p.k         = num2str(get(findobj(hg,'tag','clustersize'),'string'));
p.nmaxclust = num2str(get(findobj(hg,'tag','nmaxclust'),'string'));

% ===========[nametag: file-name suggestion ]====================================
%
c={};
c(end+1,:)={'img' NIIfiles{1}};
c(end+1,:)={'con' ['C' num2str(p.connum) '_']};
c(end+1,:)={'con' ['_' num2str(p.con) '__']};
c(end+1,:)={'mcp' num2str(p.mcp)};
c(end+1,:)={'TR'  num2str(p.TR)};
% c(end+1,:)={'k'   [ 'k' num2str(p.k) ]};
c(end+1,:)={'k'   [ 'k' num2str( p.k ) ]};
cj=strjoin(reshape(c(:,2),[size(c,1) 1]),'');
nametag=regexprep(cj,{'\s+','<' '>','.nii'},{'#','_LT_' '_GT_','_'});
%parameter tag without con-number and contrast-name
ck=strjoin(reshape(c([1 4:end],2),[size(c,1)-2 1]),'');
paramtag=regexprep(ck,{'\s+','<' '>','.nii'},{'#','_LT_' '_GT_','_'});

nametag  =[ regexprep(nametag ,{'#' '[' ']'},{'_','',''})  ];
paramtag =[ regexprep(paramtag,{'#' '[' ']'},{'_','',''})  ];

%% ===============================================
[root sub]=fileparts(xSPM.swd);
q=struct();
q.root          =root;
q.resultsDir    =fullfile(q.root,['res_' sub ]);
q.resultsDataDir=fullfile(q.resultsDir,'data');

if exist(q.resultsDataDir)~=7
   mkdir(q.resultsDataDir);
end

%  p
%  nametag
%% ===============================================

        






function [fiout g]=report(pptfile0,s)
fiout=[];
g     =struct();


figure(findobj(0,'tag','vvstat'));
if exist('s')~=1
    s.doc='new'; %new pptfile, atherwise 'add' to add to existing pptfile
end
% if isfield(s,'table')==0;    s.show='table'; end % show table
if isfield(s,'doc')==0;      s.doc ='new'; end % new doc
if isfield(s,'bgcol')==0;    s.bgcol =[1 1 1]; end % new doc
if isfield(s,'show')==0;     s.show='table'; end % show table



paSPM=pwd;
currDir=pwd;
[paPPT pptfile ]=fileparts(pptfile0);
% if exist(pa)==7
%     cd(pa);
% end
[~,foldername]=fileparts(paSPM);

hg=findobj(0,'tag','vvstat');
lb=findobj(hg,'tag','loadothercontrast');

cd(paPPT);
%% Start new presentation
isOpen  = exportToPPTX();
if ~isempty(isOpen),
    % If PowerPoint already started, then close first and then open a new one
    exportToPPTX('close');
end
try
    %evalc('system(''taskkill /f /im powerpnt.exe'')');
end
%% =======new PPT/add to ppt ========================================

if strcmp(s.doc,'add') && exist([pptfile,'.pptx'])
    exportToPPTX('open',[pptfile,'.pptx'])
else
    exportToPPTX('new','Dimensions',[12 6], ...
        'Title','Example Presentation', ...
        'Author','MatLab', ...
        'Subject','Automatically generated PPTX file', ...
        'Comments','This file has been automatically generated by exportToPPTX');
end
%% ===============================================

% Additionally background color for all slides can be set as follows:
% exportToPPTX('new','BackgroundColor',[0.5 0.5 0.5]);
%% Add some slides
% figH = figure('Renderer','zbuffer'); mesh(peaks); view(0,0);
hfig= findobj(0,'tag','Graphics');
figH=hfig.Number;

if isfield(s,'con')==0;  s.con =[1:size(get(lb,'string'),1)]; end % number of contrast to plot

cons=s.con;

for jj=1:length(cons)   %:   size(get(lb,'string'),1)   %1:1,
    islide=cons(jj);
    cd(paSPM);
    
    %--update contrast --------------------------
    figure(hg)
    set(lb,'value',islide);
    hgfeval(get(lb,'callback'),lb);
    if isfield(s,'pointer')
        figure(hfig)
        if isnumeric(s.pointer) && length(s.pointer)==3
            %xyz=spm_mip_ui('GetCoords')
            spm_mip_ui('SetCoords',s.pointer);
        elseif ischar(s.pointer) && strcmp(s.pointer,'max')
            [xyz,d] = spm_mip_ui('Jump',spm_mip_ui('FindMIPax'),'glmax'); %jump to max cluster
        end
    else
        try
            %spm_mip_ui('Jump',findobj(findobj(0,'tag','Graphics'),'tag','hMIPax'),'glmax');
            evalc('spm_mip_ui(''Jump'',findobj(findobj(0,''tag'',''Graphics''),''tag'',''hMIPax''),''glmax'')');
        end
    end
        
    drawnow;
    if strcmp(s.show,'table')
        %--show table --------------------------
        lt=findobj(hg,'tag','showTable');
        hgfeval(get(lt,'callback'),lt);
        %----------------------------
        drawnow;
    elseif strcmp(s.show,'volume')
        lt=findobj(hg,'tag','showvolume');
        hgfeval(get(lt,'callback'),lt);
        % go to local maximum
%         try
%         spm_mip_ui('Jump',findobj(findobj(0,'tag','Graphics'),'tag','hMIPax'),'glmax');
%         end
        %----------------------------
        drawnow;
    end
    %% ----get info ------------------------
    mspm=struct();
    mspm.title ='';
    mspm.nsigvox=nan;
    mspm.stat='';
    try;    xspm=evalin('base','xSPM'); end
    try;    mspm.nsigvox=length(xspm.Z);     end
    try;    mspm.title  =xspm.title;       end
    try;    mspm.stat  =xspm.STAT;       end
    
    %msp
    % ===============================================
    
    info=...
        {
        %['Contrast: ' lb.String{lb.Value} ]
        ['Contrast-' [ num2str(cons(1)) ': '] mspm.title ]
        ['MCP: ' get(findobj(hg,'tag','mcp'),'string')]
        ['TR: ' get(findobj(hg,'tag','thresh'),'string')]
        ['CLustersize: ' get(findobj(hg,'tag','clustersize'),'string')]
        ['DIR: '         foldername]
        ['statistic: '         mspm.stat]
        ['no sign. voxel: '         num2str(mspm.nsigvox)]
        };
    
   % disp(char(info))
    
    %% ----------------------------
    
    cd(paPPT);
    slideNum = exportToPPTX('addslide','BackgroundColor',s.bgcol);
    %fprintf('Added slide %d\n',slideNum);
    exportToPPTX('addpicture',figH);
    %     exportToPPTX('addtext',lb.String{lb.Value});
    exportToPPTX('addtext',[['C' num2str(cons(1))] ': '  lb.String{lb.Value}]);
    %exportToPPTX('addtext',    [['C' num2str(cons(1))] ': '  lb.String{lb.Value}]   );
    exportToPPTX('addtext',strjoin(info,char(10)),'FontSize',10,...
        'Position',[0 1 3 3  ]);
    
    %exportToPPTX('addnote',sprintf('Notes data: slide number %d',slideNum));
    exportToPPTX('addnote',['source: '  pwd ]);
    % Rotate mesh on each slide
    %     view(18*islide,18*islide);
end
% close(figH)
%% Check current presentation
cd(paPPT);
fileStats   = exportToPPTX('query');
if ~isempty(fileStats),
    %fprintf('Presentation size: %f x %f\n',fileStats.dimensions);
   % fprintf('Number of slides: %d\n',fileStats.numSlides);
end
%% Save presentation and close presentation -- overwrite file if it already exists
% Filename automatically checked for proper extension

if exist('pptfile')==0
    pptfile='result';
end

% [pa file ext]=fileparts(pptfile);
% if isempty(pa)
%
% else
%     thisdir=pwd;
%     cd(pa)
%     newFile = exportToPPTX('saveandclose',file);
%
% end



newFile = exportToPPTX('saveandclose',pptfile);
% fprintf('New file has been saved: <a href="matlab:open(''%s'')">%s</a>\n',newFile,newFile);
showinfo2('summary saved ',newFile);

cd(currDir);
%% =========out======================================
fiout=newFile;
g.slideNum=slideNum;
g.pptshortname=pptfile;





function helphere(e,e2)

uhelp(mfilename,1);







%———————————————————————————————————————————————
%%   COPYNPASTE INTO GUI
%———————————————————————————————————————————————
if 0
    %% PAIRED TTEST
    x.excelfile=     { 'O:\data\voxelwise_Maritzen4tool\Maritzen_Animal_groups.xlsx' };	% [Excelfile]: this file contains two columns with mouseIDs (names) for timepoint T1 and T2, respectively
    x.sheetnumber=   [1];	% this sheet contains columns with mouseIDs and group assignment
    x.mouseID_colT1= [8];	% column number with the MouseIDs for T1
    x.mouseID_colT2= [9];	% column number with the MouseIDs for T2
    x.data_dir=      'O:\data\voxelwise_Maritzen4tool\dat';	% data directory (upper directory) contains dirs with mice data
    x.inputimage=    'JD.nii';	% image name (nifti) to run the statistic (datapath has to bee defined before using the icon)
    x.mask=          'local';	% <optional> use brainmask [select a mask or type "local" to use the AVGTmask.nii from the templates folder]
    x.output_dir=    'test1';	% path for output/statistic
    x.showSPMbatch=  [1];	% [0|1] hide|show pipeline in SPM batch window, if [1] you have to run the code by yourself ( hit the green driangle), [0] piples runs automatically
    
    %%   TWO-SAMPLE-TTEST
    x.excelfile=      { 'O:\data\voxelwise_Maritzen4tool\Maritzen_Animal_groups.xlsx' };	% [Excelfile]: this file contains a column with mouseIDs (names) and a column assigning the group
    x.sheetnumber=    [1];	% this sheet contains columns with mouseIDs and group assignment
    x.mouseID_col=    [1];	% column number with the MouseIDs
    x.group_col=      [2];	% column number with group assignment  (used when comparing groups, "regress_col" must be empty)
    x.data_dir=       'O:\data\voxelwise_Maritzen4tool\dat';	% data directory (upper directory) contains dirs with mice data
    x.inputimage=     'JD.nii';	% image name (nifti) to run the statistic (datapath has to bee defined before using the icon)
%     x.grp_comparison='1vs2';	% groups to compare
    x.mask=           'local';	% <optional> use brainmask [select a mask or type "local" to use the AVGTmask.nii from the templates folder]
    x.output_dir=     'test2';	% path for output/statistic
    x.showSPMbatch=   [0];	% [0|1] hide|show pipeline in SPM batch window, if [1] you have to run the code by yourself ( hit the green driangle), [0] piples runs automatically
    
    %% regression
    x.excelfile=    { 'O:\data\voxelwise_Maritzen4tool\Maritzen_Animal_groups.xlsx' };	% [Excelfile]: this file contains a column with mouseIDs (names) and a column with regression values
    x.sheetnumber=  [1];	% this sheet contains columns with mouseIDs and regression values
    x.mouseID_col=  [1];	% column number with the MouseIDs
    x.regress_col=  [4];	% column number with regression values (used for multiple regression,"group_col" must be empty)
    x.data_dir=     'O:\data\voxelwise_Maritzen4tool\dat';	% data directory (upper directory) contains dirs with mice data
    x.inputimage=   'JD.nii';	% image name (nifti) to run the statistic (datapath has to bee defined before using the icon)
    x.mask=         'local';	% <optional> use brainmask [select a mask or type "local" to use the AVGTmask.nii from the templates folder]
    x.output_dir=   'test3';	% path for output/statistic
    x.showSPMbatch=[0];	% [0|1] hide|show pipeline in SPM batch window, if [1] you have to run the code by yourself ( hit the green driangle), [0] piples runs automatically
    
    
    %%  ONE-WAY-ANOVA
    x.excelfile=    'O:\data\voxelwise_Maritzen4tool\Maritzen_Animal_groups.xlsx';	% [Excelfile]: this file contains a column with mouseIDs (names) and a column with regression values
    x.sheetnumber=  [2];	% this sheet contains columns with mouseIDs and regression values
    x.mouseID_col=  [1];	% column number with the MouseIDs
    x.group_col=    [3];	% column number with group assignment  (used when comparing groups)
    x.regress_col=  [4  5];	% <optional> column number(s) with regression values,otherwise empty (examples: age+gender --> regression columns are [4 5])
    x.data_dir=     'O:\data\voxelwise_Maritzen4tool\dat';	% data directory (upper directory) contains dirs with mice data
    x.inputimage=   'JD.nii';	% image name (nifti) to run the statistic (datapath has to bee defined before using the icon)
    x.mask=         'O:\data\voxelwise_Maritzen4tool\templates\AVGTmask.nii';	% <optional> use brainmask [select a mask or type "local" to use the AVGTmask.nii from the templates folder]
    x.output_dir=   'test4';	% path for output/statistic
    x.showSPMbatch=[0];	% [0|1] hide|show pipeline in SPM batch window, if [1] you have to run the code by yourself ( hit the green driangle), [0] piples runs automatically
    
    
    
    
    
    
end
