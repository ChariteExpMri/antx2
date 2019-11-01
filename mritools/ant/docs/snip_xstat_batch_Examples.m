% % ••••••••••••••••••••••••••••••••••••••••••••••••••••••
% % #g TWO-SAMPLE-T-TEST
% % ••••••••••••••••••••••••••••••••••••••••••••••••••••••
z=[];
z.stattype       = 'twosamplettest';                                                  % % STATISTICAL TEST
z.excelfile      = 'O:\data\voxelwise_Maritzen4tool\xstat_statistic_example.xlsx';     % % [Excelfile]: this file contains a column with mouseIDs (names) and a column assigning the group
z.sheetnumber    = [1];                                                               % % this sheet contains columns with mouseIDs and group assignment
z.mouseID_col    = [1];                                                               % % column number with the MouseIDs
z.group_col      = [2];                                                               % % column number with group assignment  (used when comparing groups, "regress_col" must be empty)
z.data_dir       = 'O:\data\voxelwise_Maritzen4tool\dat';                             % % data directory (upper directory) contains dirs with mice data
z.inputimage     = 'JD.nii';                                                          % % image name (nifti) to run the statistic (datapath has to bee defined before using the icon)
z.grp_comparison = '1vs2';                                                            % % groups to compare
z.mask           = 'O:\data\voxelwise_Maritzen4tool\templates\AVGTmask.nii';          % % <optional> use brainmask [select a mask or type "local" to use the AVGTmask.nii from the templates folder]
z.output_dir     = 's1_2sampleTtest';                                                          % % path for output/statistic
z.showSPMbatch   = [1];                                                               % % [0|1] hide|show pipeline in SPM batch window, if [1] you have to run the code by yourself ( hit the green driangle), [0] piples runs automatically
xstat(0,z);

% % ••••••••••••••••••••••••••••••••••••••••••••••••••••••
% % #g  PAIRED T-TEST
% % ••••••••••••••••••••••••••••••••••••••••••••••••••••••
z=[];
z.stattype      = 'pairedttest';                                                     % % STATISTICAL TEST
z.excelfile     = 'O:\data\voxelwise_Maritzen4tool\xstat_statistic_example.xlsx';     % % [Excelfile]: this file contains two columns with mouseIDs (names) for timepoint T1 and T2, respectively
z.sheetnumber   = [2];                                                               % % this sheet contains columns with mouseIDs and group assignment
z.mouseID_colT1 = [1];                                                               % % column number with the MouseIDs for T1
z.mouseID_colT2 = [2];                                                               % % column number with the MouseIDs for T2
z.data_dir      = 'O:\data\voxelwise_Maritzen4tool\dat';                             % % data directory (upper directory) contains dirs with mice data
z.inputimage    = 'JD.nii';                                                          % % image name (nifti) to run the statistic (datapath has to bee defined before using the icon)
z.mask          = 'O:\data\voxelwise_Maritzen4tool\templates\AVGTmask.nii';          % % <optional> use brainmask [select a mask or type "local" to use the AVGTmask.nii from the templates folder]
z.output_dir    = 's2_pairedTtest';                                                          % % path for output/statistic
z.showSPMbatch  = [1];                                                               % % [0|1] hide|show pipeline in SPM batch window, if [1] you have to run the code by yourself ( hit the green driangle), [0] piples runs automatically
xstat(0,z);


% % ••••••••••••••••••••••••••••••••••••••••••••••••••••••
% % #g       ONE-WAY-ANOVA
% % #b info :   2 groups, no additional covariates (same as TWO-SAMPLE-T-TEST)
% % ••••••••••••••••••••••••••••••••••••••••••••••••••••••
z=[];
z.stattype     = 'onewayanova';                                                     % % STATISTICAL TEST
z.excelfile    = 'O:\data\voxelwise_Maritzen4tool\xstat_statistic_example.xlsx';     % % [Excelfile]: this file contains a column with mouseIDs (names) and a column with regression values
z.sheetnumber  = [3];                                                               % % this sheet contains columns with mouseIDs and regression values
z.mouseID_col  = [1];                                                               % % column number with the MouseIDs
z.group_col    = [2];                                                               % % column number with group assignment  (used when comparing groups)
z.regress_col  = [];                                                                % % <optional> column number(s) with regression values,otherwise empty (examples: age+gender --> regression columns are 4&5)
z.data_dir     = 'O:\data\voxelwise_Maritzen4tool\dat';                             % % data directory (upper directory) contains dirs with mice data
z.inputimage   = 'JD.nii';                                                          % % image name (nifti) to run the statistic (datapath has to bee defined before using the icon)
z.mask         = 'O:\data\voxelwise_Maritzen4tool\templates\AVGTmask.nii';          % % <optional> use brainmask [select a mask or type "local" to use the AVGTmask.nii from the templates folder]
z.output_dir   = 's3_1wANOVA';                                                   % % path for output/statistic
z.showSPMbatch = [1];                                                               % % [0|1] hide|show pipeline in SPM batch window, if [1] you have to run the code by yourself ( hit the green driangle), [0] piples runs automatically
xstat(0,z);



% % ••••••••••••••••••••••••••••••••••••••••••••••••••••••
% % #g       ONE-WAY-ANOVA
% % #b info :   3 groups, 2 additional covariates
% % ••••••••••••••••••••••••••••••••••••••••••••••••••••••
z=[];
z.stattype     = 'onewayanova';                                                     % % STATISTICAL TEST
z.excelfile    = 'O:\data\voxelwise_Maritzen4tool\xstat_statistic_example.xlsx';     % % [Excelfile]: this file contains a column with mouseIDs (names) and a column with regression values
z.sheetnumber  = [4];                                                               % % this sheet contains columns with mouseIDs and regression values
z.mouseID_col  = [1];                                                               % % column number with the MouseIDs
z.group_col    = [2];                                                               % % column number with group assignment  (used when comparing groups)
z.regress_col  = [3 4];                                                            % % <optional> column number(s) with regression values,otherwise empty (examples: age+gender --> regression columns are [4 5])
z.data_dir     = 'O:\data\voxelwise_Maritzen4tool\dat';                             % % data directory (upper directory) contains dirs with mice data
z.inputimage   = 'JD.nii';                                                          % % image name (nifti) to run the statistic (datapath has to bee defined before using the icon)
z.mask         = 'O:\data\voxelwise_Maritzen4tool\templates\AVGTmask.nii';          % % <optional> use brainmask [select a mask or type "local" to use the AVGTmask.nii from the templates folder]
z.output_dir   = 's4_1wANOVAregress';                                                          % % path for output/statistic
z.showSPMbatch = [1];                                                               % % [0|1] hide|show pipeline in SPM batch window, if [1] you have to run the code by yourself ( hit the green driangle), [0] piples runs automatically
xstat(0,z);



% % ••••••••••••••••••••••••••••••••••••••••••••••••••••••
% % #g  REGRESSION
% % ••••••••••••••••••••••••••••••••••••••••••••••••••••••
z=[];
z.stattype     = 'regression';                                                      % % STATISTICAL TEST
z.excelfile    = 'O:\data\voxelwise_Maritzen4tool\xstat_statistic_example.xlsx';     % % [Excelfile]: this file contains a column with mouseIDs (names) and a column with regression values
z.sheetnumber  = [5];                                                               % % this sheet contains columns with mouseIDs and regression values
z.mouseID_col  = [1];                                                               % % column number with the MouseIDs
z.regress_col  = [2];                                                               % % column number with regression values (used for multiple regression,"group_col" must be empty)
z.data_dir     = 'O:\data\voxelwise_Maritzen4tool\dat';                             % % data directory (upper directory) contains dirs with mice data
z.inputimage   = 'JD.nii';                                                          % % image name (nifti) to run the statistic (datapath has to bee defined before using the icon)
z.mask         = 'O:\data\voxelwise_Maritzen4tool\templates\AVGTmask.nii';          % % <optional> use brainmask [select a mask or type "local" to use the AVGTmask.nii from the templates folder]
z.output_dir   = 's5_regress';                                                          % % path for output/statistic
z.showSPMbatch = [1];                                                               % % [0|1] hide|show pipeline in SPM batch window, if [1] you have to run the code by yourself ( hit the green driangle), [0] piples runs automatically
xstat(0,z);