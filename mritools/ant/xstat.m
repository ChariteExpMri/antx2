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
%   'pairedttest'       :AIM:  comparing two timepoints or two different parameters from the same mouse across mice (* pre vs post treatment)
%   'twosamplettest'    :AIM:  comparing two independet groups   (* disease group vs control group)
%   'regression'        :AIM:  voxelwise regression (data from one group) with a vector (* age or performance)
%   'onewayanova'       :AIM:  comparing two or more independet groups (* control vs. sham vs. disease)
%                       - onewayanova allows one/more additional covariates (* age, gender..) to add to the model
%   'fullfactorial'     :AIM:  Anova with several factors (between and or within).  
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
% % ������������������������������������������������������
% % #g TWO-SAMPLE-T-TEST
% % ������������������������������������������������������
% z=[];
% z.stattype       = 'twosamplettest';                                                  % % STATISTICAL TEST
% z.excelfile      = 'O:\data\voxelwise_Maritzen4tool\xstat_statistic_example.xlsx';     % % [Excelfile]: this file contains a column with mouseIDs (names) and a column assigning the group
% z.sheetnumber    = [1];                                                               % % this sheet contains columns with mouseIDs and group assignment
% z.mouseID_col    = [1];                                                               % % column number with the MouseIDs
% z.group_col      = [2];                                                               % % column number with group assignment  (used when comparing groups, "regress_col" must be empty)
% z.data_dir       = 'O:\data\voxelwise_Maritzen4tool\dat';                             % % data directory (upper directory) contains dirs with mice data
% z.inputimage     = 'JD.nii';                                                          % % image name (nifti) to run the statistic (datapath has to bee defined before using the icon)
% z.grp_comparison = '1vs2';                                                            % % groups to compare
% z.mask           = 'O:\data\voxelwise_Maritzen4tool\templates\AVGTmask.nii';          % % <optional> use brainmask [select a mask or type "local" to use the AVGTmask.nii from the templates folder]
% z.output_dir     = 's1_2sampleTtest';                                                          % % path for output/statistic
% z.showSPMbatch   = [1];                                                               % % [0|1] hide|show pipeline in SPM batch window, if [1] you have to run the code by yourself ( hit the green driangle), [0] piples runs automatically
% xstat(0,z);
% 
% % ������������������������������������������������������
% % #g  PAIRED T-TEST
% % ������������������������������������������������������
% z=[];
% z.stattype      = 'pairedttest';                                                     % % STATISTICAL TEST
% z.excelfile     = 'O:\data\voxelwise_Maritzen4tool\xstat_statistic_example.xlsx';     % % [Excelfile]: this file contains two columns with mouseIDs (names) for timepoint T1 and T2, respectively
% z.sheetnumber   = [2];                                                               % % this sheet contains columns with mouseIDs and group assignment
% z.mouseID_colT1 = [1];                                                               % % column number with the MouseIDs for T1
% z.mouseID_colT2 = [2];                                                               % % column number with the MouseIDs for T2
% z.data_dir      = 'O:\data\voxelwise_Maritzen4tool\dat';                             % % data directory (upper directory) contains dirs with mice data
% z.inputimage    = 'JD.nii';                                                          % % image name (nifti) to run the statistic (datapath has to bee defined before using the icon)
% z.mask          = 'O:\data\voxelwise_Maritzen4tool\templates\AVGTmask.nii';          % % <optional> use brainmask [select a mask or type "local" to use the AVGTmask.nii from the templates folder]
% z.output_dir    = 's2_pairedTtest';                                                          % % path for output/statistic
% z.showSPMbatch  = [1];                                                               % % [0|1] hide|show pipeline in SPM batch window, if [1] you have to run the code by yourself ( hit the green driangle), [0] piples runs automatically
% xstat(0,z);
% 
% % ������������������������������������������������������
% % #g       ONE-WAY-ANOVA
% % #b info :   2 groups, no additional covariates (same as TWO-SAMPLE-T-TEST)
% % ������������������������������������������������������
% z=[];
% z.stattype     = 'onewayanova';                                                     % % STATISTICAL TEST
% z.excelfile    = 'O:\data\voxelwise_Maritzen4tool\xstat_statistic_example.xlsx';     % % [Excelfile]: this file contains a column with mouseIDs (names) and a column with regression values
% z.sheetnumber  = [3];                                                               % % this sheet contains columns with mouseIDs and regression values
% z.mouseID_col  = [1];                                                               % % column number with the MouseIDs
% z.group_col    = [2];                                                               % % column number with group assignment  (used when comparing groups)
% z.regress_col  = [];                                                                % % <optional> column number(s) with regression values,otherwise empty (examples: age+gender --> regression columns are 4&5)
% z.data_dir     = 'O:\data\voxelwise_Maritzen4tool\dat';                             % % data directory (upper directory) contains dirs with mice data
% z.inputimage   = 'JD.nii';                                                          % % image name (nifti) to run the statistic (datapath has to bee defined before using the icon)
% z.mask         = 'O:\data\voxelwise_Maritzen4tool\templates\AVGTmask.nii';          % % <optional> use brainmask [select a mask or type "local" to use the AVGTmask.nii from the templates folder]
% z.output_dir   = 's3_1wANOVA';                                                   % % path for output/statistic
% z.showSPMbatch = [1];                                                               % % [0|1] hide|show pipeline in SPM batch window, if [1] you have to run the code by yourself ( hit the green driangle), [0] piples runs automatically
% xstat(0,z);
% 
% % ������������������������������������������������������
% % #g       ONE-WAY-ANOVA
% % #b info :   3 groups, 2 additional covariates
% % ������������������������������������������������������
% z=[];
% z.stattype     = 'onewayanova';                                                     % % STATISTICAL TEST
% z.excelfile    = 'O:\data\voxelwise_Maritzen4tool\xstat_statistic_example.xlsx';     % % [Excelfile]: this file contains a column with mouseIDs (names) and a column with regression values
% z.sheetnumber  = [4];                                                               % % this sheet contains columns with mouseIDs and regression values
% z.mouseID_col  = [1];                                                               % % column number with the MouseIDs
% z.group_col    = [2];                                                               % % column number with group assignment  (used when comparing groups)
% z.regress_col  = [3 4];                                                            % % <optional> column number(s) with regression values,otherwise empty (examples: age+gender --> regression columns are [4 5])
% z.data_dir     = 'O:\data\voxelwise_Maritzen4tool\dat';                             % % data directory (upper directory) contains dirs with mice data
% z.inputimage   = 'JD.nii';                                                          % % image name (nifti) to run the statistic (datapath has to bee defined before using the icon)
% z.mask         = 'O:\data\voxelwise_Maritzen4tool\templates\AVGTmask.nii';          % % <optional> use brainmask [select a mask or type "local" to use the AVGTmask.nii from the templates folder]
% z.output_dir   = 's4_1wANOVAregress';                                                          % % path for output/statistic
% z.showSPMbatch = [1];                                                               % % [0|1] hide|show pipeline in SPM batch window, if [1] you have to run the code by yourself ( hit the green driangle), [0] piples runs automatically
% xstat(0,z);
% 
% % ������������������������������������������������������
% % #g  REGRESSION
% % ������������������������������������������������������
% z=[];
% z.stattype     = 'regression';                                                      % % STATISTICAL TEST
% z.excelfile    = 'O:\data\voxelwise_Maritzen4tool\xstat_statistic_example.xlsx';     % % [Excelfile]: this file contains a column with mouseIDs (names) and a column with regression values
% z.sheetnumber  = [5];                                                               % % this sheet contains columns with mouseIDs and regression values
% z.mouseID_col  = [1];                                                               % % column number with the MouseIDs
% z.regress_col  = [2];                                                               % % column number with regression values (used for multiple regression,"group_col" must be empty)
% z.data_dir     = 'O:\data\voxelwise_Maritzen4tool\dat';                             % % data directory (upper directory) contains dirs with mice data
% z.inputimage   = 'JD.nii';                                                          % % image name (nifti) to run the statistic (datapath has to bee defined before using the icon)
% z.mask         = 'O:\data\voxelwise_Maritzen4tool\templates\AVGTmask.nii';          % % <optional> use brainmask [select a mask or type "local" to use the AVGTmask.nii from the templates folder]
% z.output_dir   = 's5_regress';                                                          % % path for output/statistic
% z.showSPMbatch = [1];                                                               % % [0|1] hide|show pipeline in SPM batch window, if [1] you have to run the code by yourself ( hit the green driangle), [0] piples runs automatically
% xstat(0,z);
% % ������������������������������������������������������
% % #g  FULLFACTTORIAL ANOVA
% % ������������������������������������������������������
% z=[];
% z.stattype=      'fullfactorial';                                                     % % STATISTICAL TEST
% z.excelfile=      'O:\data2\x03_yildirim\voxstatGroups_2x2.xlsx';	                    % % [Excelfile]: this file contains a column with mouseIDs (names) and columns containing the factors and optional a regression column
% z.sheetnumber=    [1];                                                                % % this sheet contains columns with mouseIDs, factors and regression values
% z.mouseID_col=    [1];                                                                % % column number with the MouseIDs
% z.group_col=      [3 4];                                                              % % columns containing the factors (example: column-3 is factor-A and column-4 is factor-B)
% z.regress_col=    [];                                                                 % % <optional> this column number addresses regression values,otherwise empty
% z.data_dir=       'O:\data2\x03_yildirim\dat';                                        % % data directory (upper directory) contains dirs with mice data
% z.inputimage=     'JD_fake.nii';                                                      % % NIFTI image name, from which the statistic is derived (datapath has to bee defined before using the icon)
% z.mask=           'local';                                                            % % <optional> use brainmask [select a mask or type "local" to use the AVGTmask.nii from the templates folder] 
% z.smoothing=      [0];                                                                % % <optional>smooth data
% z.smoothing_fwhm=[0.28  0.28  0.28];                                                  % % smoothing width (FWHM)
% z.output_dir=     'fullfac_fakedata_5';                                               % % path for output/statistic
% z.showSPMbatch=   [0];                                                                % % [0|1] hide|show pipeline in SPM batch window, if [1] you have to run the code by yourself ( hit the green driangle), [0] piples runs automatically 
% xstat(0,z)
% ______________________________________________________________________________________________
%% #ky batch:
% #g RE-USE BATCH: see 'anth' [..anthistory] variable in workspace


% modifications in spm
% spm_figure('close',allchild(0));   % line 347

%voxelvise statistic
function xstat(showgui,x )

if nargin>0
    
    
% xstat('loadspm','O:\data2\x03_yildirim\fullfac_fakedata_4')
% xstat('report','results_FDR')
    if ~isnumeric(showgui)
        if strcmp(showgui, 'report');
            if nargin==1; x=[];end
            report(x) ;
        end
        if strcmp(showgui, 'loadspm');
            if nargin==1; x=[];end
            loadspm(x) ;
        end
        return
    end
end



types={'regression' 'pairedttest' 'twosamplettest' 'onewayanova' 'fullfactorial'};
clear global xvv;
global xvv;
xvv={};


%�����������������������������������������������
%%   PARAMS
%�����������������������������������������������
if exist('showgui')==0 || isempty(showgui) ;    showgui=1                   ;end
if exist('x')==0                           ;    x=[]                        ;end




if 0
    
    
    % % ������������������������������������������������������
    % % #g FUNCTION:        [xstat.m]
    % % #b info :             modifications in spm
    % % ������������������������������������������������������
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
    
    % % ������������������������������������������������������
    % % #g FUNCTION:        [xstat.m]
    % % #b info :             modifications in spm
    % % ������������������������������������������������������
    z=[];
    z.stattype       = 'twosamplettest';                                                  % % STATISTICAL TEST
    z.excelfile      = 'O:\data\voxelwise_Maritzen4tool\Maritzen_Animal_groups.xlsx';     % % [Excelfile]: this file contains a column with mouseIDs (names) and a column assigning the group
    z.sheetnumber    = [1];                                                               % % this sheet contains columns with mouseIDs and group assignment
    z.mouseID_col    = [1];                                                               % % column number with the MouseIDs
    z.group_col      = [2];                                                               % % column number with group assignment  (used when comparing groups, "regress_col" must be empty)
    z.data_dir       = 'O:\data\voxelwise_Maritzen4tool\dat';                             % % data directory (upper directory) contains dirs with mice data
    z.inputimage     = 'JD.nii';                                                          % % image name (nifti) to run the statistic (datapath has to bee defined before using the icon)
    z.grp_comparison = '1vs2';                                                            % % groups to compare
    z.mask           = 'O:\data\voxelwise_Maritzen4tool\templates\AVGTmask.nii';          % % <optional> use brainmask [select a mask or type "local" to use the AVGTmask.nii from the templates folder]
    z.output_dir     = 'tests2';                                                           % % path for output/statistic
    z.showSPMbatch   = [0];                                                               % % [0|1] hide|show pipeline in SPM batch window, if [1] you have to run the code by yourself ( hit the green driangle), [0] piples runs automatically
    xstat(0,z);
    
    % % ������������������������������������������������������
    % % #g FUNCTION:        [xstat.m]
    % % #b info :             modifications in spm
    % % ������������������������������������������������������
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
    % % ������������������������������������������������������
    % % #g FUNCTION:        [xstat.m]
    % % #b info :             FFT Discrete Fourier transform.
    % % ������������������������������������������������������
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
    % % ������������������������������������������������������
    % % #g FUNCTION:        [xstat.m]
    % % #b info :             FFT Discrete Fourier transform.
    % % ������������������������������������������������������
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
    % % ������������������������������������������������������
    % % #g FUNCTION:        [xstat.m]
    % % #b info :             FFT Discrete Fourier transform.
    % % ������������������������������������������������������
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

%�����������������������������������������������
%%   BACKUP
%�����������������������������������������������


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
    x.grp_comparison='1vs2'	;% groups to compare
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


%����������������������������������������������������������������������������������������������������
h2=uicontrol('style','pushbutton','units','norm') ;      %HELP
set(h2, 'string','help','callback',@helphere);
set(h2, 'position',[0 .0 .15 .05],'fontsize',6);
set(h2,'tooltipstring','help for this gui');
%����������������������������������������������������������������������������������������������������
%% setup
%����������������������������������������������������������������������������������������������������
h2=uicontrol('style','text','units','norm');            % SETUP  -TXT
set(h2, 'string','Setup');
set(h2, 'position',[.01 .8 .8 .05]);
set(h2,'tooltipstring','read groups from excelfile','backgroundcolor','w','fontweight','bold',...
    'HorizontalAlignment','left');

% h2=uicontrol('style','pushbutton','units','norm') ;      %READ GROUPS-excel
% set(h2, 'string','read group [xls]','callback',@readexcel);
% set(h2, 'position',[.01 .8 .5 .05]);
% set(h2,'tooltipstring','read groups from excelfile');


h2=uicontrol('style','pushbutton','units','norm') ;     %INDEpSTAT
set(h2,'string', 'indepStat','callback',@twosampleTest);
set(h2,'position',[0 .75 .3 .05]);
set(h2,'tooltipstring','independent/2-sample t-test');

h2=uicontrol('style','pushbutton','units','norm')   ;   %DEPSTAT
set(h2,'string', 'depStat','callback', @pairedsampleTest);
set(h2,'position',[.3 .75 .3 .05]);
set(h2,'tooltipstring','dependend/paired t-test');


h2=uicontrol('style','pushbutton','units','norm')   ;   %onewayanova
set(h2,'string', '1way-ANOVA','callback', @onewayanova);
set(h2,'position',[0 .7 .3 .05]);
set(h2,'tooltipstring','one-way-anova','fontsize',6);



h2=uicontrol('style','pushbutton','units','norm')   ;   %fullfactorial
set(h2,'string', 'fullfactorial','callback', @fullfactorial);
set(h2,'position',[0.3 .7 .3 .05]);
set(h2,'tooltipstring','fullfactorial','fontsize',7);


h2=uicontrol('style','pushbutton','units','norm')   ;   %multiple regression
set(h2,'string', 'm. regression','callback', @multipleregression);
set(h2,'position',[0.6 .7 .3 .05]);
set(h2,'tooltipstring','multiple regression','fontsize',7);


h2=uicontrol('style','pushbutton','units','norm')   ;  %USERDEFINED
set(h2,'string', 'userdefined','callback',@userdefined);
set(h2,'position',[.6 .75 .3 .05]);
set(h2,'tooltipstring','build your own analysis');

%����������������������������������������������������������������������������������������������������
%% view results
%����������������������������������������������������������������������������������������������������
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





%% �������� MCP ���������������������������������������
ttip=['multiple comparison problem' char(10) 'adjust p value to control FWE,FDR or none'];
h2=uicontrol('style','text','units','norm') ;      %TXT
set(h2, 'position',[0.2 .5 .11 .05]);
set(h2,'tooltipstring',ttip);
set(h2,'string','MCP','fontsize',6,'backgroundcolor','w');
set(h2,'HorizontalAlignment','left','fontweight','bold');


h2=uicontrol('style','edit','units','norm') ;      %number ofT
set(h2, 'position',[0.2 .5 .1 .03]);
set(h2,'tooltipstring',ttip,'tag','mcp');


%% �������� thresh ���������������������������������������
ttip=['sgnificance level' char(10) ' example: [0.05] or [0.001]'];
h2=uicontrol('style','text','units','norm') ;      %TXT
set(h2, 'position',[0.30 .5 .12 .05]);
set(h2,'tooltipstring',ttip);
set(h2,'string','thresh','fontsize',6,'backgroundcolor','w');
set(h2,'HorizontalAlignment','left','fontweight','bold');


h2=uicontrol('style','edit','units','norm') ;      %number ofT
set(h2, 'position',[0.31 .5 .1 .03]);
set(h2,'tooltipstring',ttip,'tag','thresh');


%% �������� clustersize ���������������������������������������
ttip=['clustersize (k)' char(10) ' minimum spatial extend of connected significant voxels '];
h2=uicontrol('style','text','units','norm') ;      %TXT
set(h2, 'position',[0.425 .5 .12 .05]);
set(h2,'tooltipstring',ttip);
set(h2,'string','CL-K','fontsize',6,'backgroundcolor','w');
set(h2,'HorizontalAlignment','left','fontweight','bold');


h2=uicontrol('style','edit','units','norm') ;      %number ofT
set(h2, 'position',[0.425 .5 .1 .03]);
set(h2,'tooltipstring',ttip,'tag','clustersize');

%���������������������������������������������������%���������������������������������������������������

%% �������� load spm.mat�����������������������������������
h2=uicontrol('style','pushbutton','units','norm') ;      %load spm-input
set(h2, 'string','load SPM.m','callback',@loadSPMmat);
set(h2, 'position',[.0 .55 .26 .05],'fontsize',7);
set(h2,'tooltipstring','load Results ("SPM.mat"), addit. parameters have to be defined');

%% �������� losd con-1 �����������������������������������

h2=uicontrol('style','pushbutton','units','norm') ;      %load1st contrast
set(h2, 'string','Load Con-1','callback',@loadSPMmatnoInput);
set(h2, 'position',[.26 .55 .26 .05],'fontsize',7);
set(h2,'tooltipstring','load the 1st contrast with standard parameters');

%% �������� contrasts (listbox)�����������������������������������

h2=uicontrol('style','text','units','norm');            %other contrasts -TXT
set(h2, 'string','contrasts','ButtonDownFcn',@loadothercontrastini);
set(h2, 'position',[.7 .6 .3 .02],'fontsize',6,'backgroundcolor','w');

h2=uicontrol('style','listbox','units','norm') ;      %other contrasts
set(h2, 'string','-','callback',@loadothercontrast,'tag','loadothercontrast');
set(h2, 'position',[.56 .2 .48 .4],'fontsize',5);
set(h2,'tooltipstring','show the other contrasts');



%% �������� show VOLUME(section)�����������������������������������
h2=uicontrol('style','pushbutton','units','norm') ;      %show sections
set(h2, 'string','show volume','callback',@showSections);
set(h2, 'position',[.0 .4 .28 .05],'fontsize',7);
set(h2,'tooltipstring','show 3 panel (sections) view');

h2=uicontrol('style','radiobutton','units','norm') ;      %show sections
set(h2, 'string','show vol','fontsize',6,'value',1);
set(h2, 'position',[.3 .405 .25 .05],'backgroundcolor','w',...
    'tooltipstring','always show volume','tag','showSectionstoggle');


%% �������� show table���������������������������������������
h2=uicontrol('style','pushbutton','units','norm') ;      %show table
set(h2, 'string','show table','callback',@showTable);
set(h2, 'position',[0    .35 .28 .05]);
set(h2,'tooltipstring',' show statistical table');

%% �������� clusters distance ���������������������������������������
ttip=['cluster distance ' char(10) 'minimum distance between clusters [mm]'];
h2=uicontrol('style','text','units','norm') ;      %TXT
set(h2, 'position',[0.4 .355 .11 .05]);
set(h2,'tooltipstring',ttip);
set(h2,'string','Cldist','fontsize',6,'backgroundcolor','w');
set(h2,'HorizontalAlignment','left','fontweight','bold');


h2=uicontrol('style','edit','units','norm') ;      %  clusterDistance
set(h2, 'position',[0.4 .355 .1 .03]);
set(h2,'tooltipstring',ttip,'tag','clustdist');

%% �������� number of clusters ���������������������������������������
h2=uicontrol('style','text','units','norm') ;      %TXT
set(h2, 'position',[0.29 .355 .11 .05]);
set(h2,'tooltipstring','Number of Peaks per cluster');
set(h2,'string','#P/Cl','fontsize',6,'backgroundcolor','w');
set(h2,'HorizontalAlignment','left','fontweight','bold');


h2=uicontrol('style','edit','units','norm') ;      %number of cluster EDIT
set(h2, 'position',[0.29 .355 .1 .03]);
set(h2,'tooltipstring','number of maxima per cluster','tag','nmaxclust');

%% �������� export table ���������������������������������������
h2=uicontrol('style','pushbutton','units','norm') ;      %export table
set(h2, 'string','export table','callback',@exporttable);
set(h2, 'position',[0   .3 .28 .05]);
set(h2,'tooltipstring','save the statistical table','fontsize',7);


%% �������� save vol���������������������������������������
h2=uicontrol('style','pushbutton','units','norm') ;      %save volume table
set(h2, 'string','save volume','callback',@save_threshvolume);
set(h2, 'position',[0    .25 .28 .05]);
set(h2,'tooltipstring','save thresholded volume as nifti-file','fontsize',7);

%% �������� show mricron ���������������������������������������
h2=uicontrol('style','pushbutton','units','norm') ;      %show volume MRICRON
set(h2, 'string','show MRicron','callback',@show_mricron);
set(h2, 'position',[0.28 .25 .28 .05]);
set(h2,'tooltipstring','show previously saved thresholded volume overlayed in MRICRON','fontsize',7);


%���������������������������������������������������
h2=uicontrol('style','pushbutton','units','norm') ;      %exit
set(h2, 'string','close','callback',@xclose);
set(h2, 'position',[0.66 .0 .33 .05]);
set(h2,'tooltipstring','close this gui','fontsize',7);




%% ��� set prefs��������������������������������������������

prefs=getprefs;

set(findobj(gcf,'tag','mcp'        ),'string',  prefs.mcp         ,'fontsize',6);
set(findobj(gcf,'tag','thresh'     ),'string',  prefs.thresh      ,'fontsize',6);
set(findobj(gcf,'tag','clustersize'),'string',  prefs.clustersize ,'fontsize',6);

set(findobj(gcf,'tag','nmaxclust'  ),'string',  prefs.nmaxclust    ,'fontsize',6);
set(findobj(gcf,'tag','clustdist'  ),'string',  prefs.clustdist    ,'fontsize',6);


%�����������������������������������������������

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
    elseif strcmp(xvv.x.stattype, 'fullfactorial') 
        fullfactorial;
    end
    
end








%����������������������������������������������������������������������������������������������������

%�����������������������������������������������
%%   subs
%�����������������������������������������������

function xclose(e,e2)
useotherspm(0); % swith to ANT version of SPM
hfig=findobj(0,'tag','vvstat');
set(hfig,'CloseRequestFcn','closereq');
close(hfig);




function loadothercontrastini(e,e2)
loadothercontrast('initialize',[]);


%�����������������������������������������������
%%   readexcel
%�����������������������������������������������

function readexcel(xtype)

s=get(gcf,'userdata');
wkdir=pwd;


if exist('xtype')==1;
else; return;
end

%�����������������������������������������������
%%   parmaeter
%�����������������������������

if strcmp(xtype,'twosamplettest')
    p={
        'inf1'     '%  TWO-SAMPLE-TTEST'  '' ''
        'excelfile' ''          '[Excelfile]: this file contains a column with mouseIDs (names) and a column assigning the group' 'f'
        'sheetnumber'    1      'this sheet contains columns with mouseIDs and group assignment' ''
        'mouseID_col'    1      'column number with the MouseIDs' ''
        'group_col'      2      'column number with group assignment  (used when comparing groups, "regress_col" must be empty)' ''
        'data_dir'       ''     'data directory (upper directory) contains dirs with mice data' 'd'
        'inputimage'     ''     'image name (nifti) to run the statistic (datapath has to bee defined before using the icon)'  {@antcb,'selectimageviagui', 'data_dir' ,'single'}
        'grp_comparison' '1vs2' 'groups to compare, use EXCELgroupnames(example: "GroupNameString1vsGroupNameString2") or alphabet. order (example: "1vs2"), or ' {'1vs2' '1vs3' '2vs3'  };
        'mask'          'local' '<optional> use brainmask [select a mask or type "local" to use the AVGTmask.nii from the templates folder] ' {'d' 'f' 'local'};
        'smoothing'       1       '<optional>smooth data' 'b'
        'smoothing_fwhm'  [0.28 0.28 0.28]  'smoothing width (FWHM)'  ''
        'output_dir'   'test_10' 'path for output/statistic' 'd';
        'showSPMbatch'   1      '[0|1] hide|show pipeline in SPM batch window, if [1] you have to run the code by yourself ( hit the green driangle), [0] piples runs automatically ' 'b';
        };
elseif strcmp(xtype,'pairedttest')
    p={
        'inf1'     '%  PAIRED-SAMPLE-TTEST'  '' ''
        'excelfile' ''   '[Excelfile]: this file contains two columns with mouseIDs (names) for timepoint T1 and T2, respectively' 'f'
        'sheetnumber'    1  'this sheet contains columns with mouseIDs and group assignment' ''
        'mouseID_colT1'  1  'column number with the MouseIDs for T1' ''
        'mouseID_colT2'  1  'column number with the MouseIDs for T2' ''
        'data_dir'       '' 'data directory (upper directory) contains dirs with mice data' 'd'
        'inputimage'     '' 'image name (nifti) to run the statistic (datapath has to bee defined before using the icon)'  {@antcb,'selectimageviagui', 'data_dir' ,'single'}
        'mask'          'local' '<optional> use brainmask [select a mask or type "local" to use the AVGTmask.nii from the templates folder] ' {'d' 'f' 'local'};
        'smoothing'       1       '<optional>smooth data' 'b'
        'smoothing_fwhm'  [0.28 0.28 0.28]  'smoothing width (FWHM)'  ''
        'output_dir'   'test_11' 'path for output/statistic' 'd';
        'showSPMbatch'   1      '[0|1] hide|show pipeline in SPM batch window, if [1] you have to run the code by yourself ( hit the green driangle), [0] piples runs automatically ' 'b';

        };
    
elseif strcmp(xtype,'regression')
    p={
        'inf1'     '%  multiple regression'  '' ''
        'excelfile' ''   '[Excelfile]: this file contains a column with mouseIDs (names) and a column with regression values' 'mf'
        'sheetnumber'    1  'this sheet contains columns with mouseIDs and regression values' ''
        'mouseID_col'    1  'column number with the MouseIDs' ''
        'regress_col'    2  'column number with regression values (used for multiple regression,"group_col" must be empty)' ''
        'data_dir'       '' 'data directory (upper directory) contains dirs with mice data' 'd'
        'inputimage'     '' 'image name (nifti) to run the statistic (datapath has to bee defined before using the icon)'  {@antcb,'selectimageviagui', 'data_dir' ,'single'}
        'mask'          'local' '<optional> use brainmask [select a mask or type "local" to use the AVGTmask.nii from the templates folder] ' {'d' 'f' 'local'};
        'smoothing'       1       '<optional>smooth data' 'b'
        'smoothing_fwhm'  [0.28 0.28 0.28]  'smoothing width (FWHM)'  ''
        'output_dir'   'test_13' 'path for output/statistic' 'd';
        'showSPMbatch'   1      '[0|1] hide|show pipeline in SPM batch window, if [1] you have to run the code by yourself ( hit the green driangle), [0] piples runs automatically ' 'b';

        };
elseif strcmp(xtype,'onewayanova')
    p={
        'inf1'     '%  ONE-WAY-ANOVA'  '' ''
        'excelfile' ''   '[Excelfile]: this file contains a column with mouseIDs (names) and a column with regression values' 'f'
        'sheetnumber'    2  'this sheet contains columns with mouseIDs and regression values' ''
        'mouseID_col'    1  'column number with the MouseIDs' ''
        'group_col'      3   'column number with group assignment  (used when comparing groups)' ''
        'regress_col'    []  '<optional> column number(s) with regression values,otherwise empty (examples: age+gender --> regression columns are [4 5])' ''
        'data_dir'       '' 'data directory (upper directory) contains dirs with mice data' 'd'
        'inputimage'     '' 'image name (nifti) to run the statistic (datapath has to bee defined before using the icon)'  {@antcb,'selectimageviagui', 'data_dir' ,'single'}
        'mask'          'local' '<optional> use brainmask [select a mask or type "local" to use the AVGTmask.nii from the templates folder] ' {'d' 'f' 'local'};
        'smoothing'       1       '<optional>smooth data' 'b'
        'smoothing_fwhm'  [0.28 0.28 0.28]  'smoothing width (FWHM)'  ''
        'output_dir'   'test_13' 'path for output/statistic' 'd';
        'showSPMbatch'   1      '[0|1] hide|show pipeline in SPM batch window, if [1] you have to run the code by yourself ( hit the green driangle), [0] piples runs automatically ' 'b';
        };  
 elseif strcmp(xtype,'fullfactorial')
    p={
        'inf1'     '%  fullfactorial ANOVA'  '' ''
        'excelfile'      ''     '[Excelfile]: this file contains a column with mouseIDs (names) and columns containing the factors' 'f'
        'sheetnumber'    1      'this sheet contains columns with mouseIDs, factors and regression values' ''
        'mouseID_col'    1      'column number with the MouseIDs' ''
        'group_col'      [4 5]  'columns containing the factors (example: column-4 is factor-A and column-5 is factor-B)' ''
        'regress_col'    []     '<optional>  column number addressing regression values,otherwise empty' ''
        'data_dir'       ''     'data directory (upper directory) contains dirs with mice data' 'd'
        'inputimage'     ''     'NIFTI image name, from which the statistic is made (datapath has to bee defined before using the icon)'  {@antcb,'selectimageviagui', 'data_dir' ,'single'}
        'mask'          'local' '<optional> use brainmask [select a mask or type "local" to use the AVGTmask.nii from the templates folder] ' {'d' 'f' 'local'};
        'smoothing'       1       '<optional>smooth data' 'b'
        'smoothing_fwhm'  [0.28 0.28 0.28]  'smoothing width (FWHM)'  ''
        'output_dir'   'test_13' 'path for output/statistic' 'd';
        'showSPMbatch'   1      '[0|1] hide|show pipeline in SPM batch window, if [1] you have to run the code by yourself ( hit the green driangle), [0] piples runs automatically ' 'b';
        };   
    
end
  


global xvv
p=paramadd(p,xvv.x);

showgui=xvv.showgui;
if showgui==1
    hlp=help(mfilename); hlp=strsplit2(hlp,char(10))';
    
    try
    [m x a paras]=paramgui(p,'uiwait',1,'close',1,'editorpos',[.03 0 1 1],'figpos',[.2 .3 .6 .3 ],'info',hlp); %% {@doc,'paramgui.m'}
    if isempty(m); 
       error('__process terminated___________________');
    end
    catch
       error('process canceled'); 
    end
    xvv.paramguilist=m;
    fn=fieldnames(x);
    x=rmfield(x,fn(regexpi2(fn,'^inf\d')));
    if isempty(m); return; end
else
   x=param2struct(p); 
end

global vxx
% vxx.p=p;

 
% %% ed
% 
% eval(m);
% 
% keyboard;
% 
% if 0
%     p=paramadd(p,x);%add/replace parameter
%     %     [m z]=paramgui(p,'uiwait',0,'close',0,'editorpos',[.03 0 1 1],'figpos',[.2 .3 .7 .5 ],'title','PARAMETERS: LABELING');
%     % %% show GUI
%     if showgui==1
%         hlp=help(mfilename); hlp=strsplit2(hlp,char(10))';
%         [m z a params]=paramgui(p,'uiwait',1,'close',1,'editorpos',[.03 0 1 1],'figpos',[.2 .3 .8 .6 ],...
%             'title','SETTINGS','pb1string','OK','info',hlp);
%         fn=fieldnames(z);
%         z=rmfield(z,fn(regexpi2(fn,'^inf\d')));
%     else
%         z=param2struct(p);
%     end
% end


if 0
    %% EXAMPLE: PAIRED TTEST
    x.excelfile=     { 'O:\data\voxelwise_Maritzen4tool\Maritzen_Animal_groups.xlsx' };	% [Excelfile]: this file contains two columns with mouseIDs (names) for timepoint T1 and T2, respectively
    x.sheetnumber=   [1];	% this sheet contains columns with mouseIDs and group assignment
    x.mouseID_colT1= [8];	% column number with the MouseIDs for T1
    x.mouseID_colT2= [9];	% column number with the MouseIDs for T2
    x.data_dir=      'O:\data\voxelwise_Maritzen4tool\dat';	% data directory (upper directory) contains dirs with mice data
    x.inputimage=    'JD.nii';	% image name (nifti) to run the statistic (datapath has to bee defined before using the icon)
    x.mask=          'local';	% <optional> use brainmask [select a mask or type "local" to use the AVGTmask.nii from the templates folder]
    x.output_dir=    'test_2';	% path for output/statistic
end


%�����������������������������������������������
%%   working with 'x'
%�����������������������������������������������


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

%�����������������������������������������������
%%   read excel
%�����������������������������������������������
[~,~,a]=xlsread(x.excelfile, x.sheetnumber);
he=a(1,:); %header

if strcmp(xtype,'twosamplettest')
    d=a(2:end,[ x.mouseID_col x.group_col ]);
    d(:,1)=cellfun(@(a){[num2str(a)]},d(:,1));
    d(:,2)=cellfun(@(a){[num2str(a)]},d(:,2));
    s.d=d;
elseif strcmp(xtype,'pairedttest')
    d=a(2:end,[ x.mouseID_colT1 x.mouseID_colT2 ]);
    d(:,1)=cellfun(@(a){[num2str(a)]},d(:,1));
    d(:,2)=cellfun(@(a){[num2str(a)]},d(:,2));
    
    itvec=([1:size(d,1)]');
    tvec=[cellfun(@(a){[ 'T1-' num2str(a) ]},num2cell(itvec))
        cellfun(@(a){[ 'T2-' num2str(a) ]},num2cell(itvec))];
    
    d=[[d(:,1); d(:,2)]   tvec ];
    s.d=d;
    
elseif strcmp(xtype,'regression')
    d=a(2:end,[ x.mouseID_col x.regress_col ]);
    d(:,1)=cellfun(@(a){[num2str(a)]},d(:,1));
    s.d=d;
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
%�����������������������������������������������
%%   check existence of nifti-file
%�����������������������������������������������
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
elseif strcmp(xtype,'onewayanova')
     s.dh=[{'excelID' 'regressval'     'existNifti' 'niftiPath'} he(x.regress_col) ];
end


%�����������������������������������������������
%%   CLASSES AND SUBGROUPS
%�����������������������������������������������

if  strcmp(xtype,'twosamplettest')
    s.classes=unique(s.d(:,2))';
    for i=1:length(s.classes)
        nifiles=s.d(  find(strcmp(s.d(:,2),s.classes{  i  })) ,4);
        s= setfield(s,['grp_' num2str(i)],nifiles );
    end
elseif  strcmp(xtype,'pairedttest')
     s.classes={'T1' 'T2'};
     is=find(cellfun('isempty',regexpi(s.d(:,2),'^T1'))==0);
     pairids=str2num(cell2mat(regexprep(s.d(is,2),'T1-','')));
     
     ifind=@(a) find(~cellfun('isempty',a));
   
     s.grp_1={};
     s.grp_2={};
     nok=1;
     for i=1:length(pairids)
         t1=ifind(regexpi(s.d(:,2),['^T1-'  num2str(pairids(i)) '$']));
         t2=ifind(regexpi(s.d(:,2),['^T2-'  num2str(pairids(i)) '$']));
         
         if  sum([isempty(t2) isempty(t1)]) ==0  % matching string found
             if  sum([ s.d{t1,3} s.d{t2,3}])  ==2   % files exist
                 s.grp_1{nok,1} = s.d{t1,4};
                 s.grp_2{nok,1} = s.d{t2,4};
                 nok=nok+1;
             end
         end
     end
         
     
elseif  strcmp(xtype,'regression')
    s.dh={'excelID' 'grp' 'regressval' 'niftiPath'};
    s.grp_1=s.d(find(cell2mat(s.d(:,3))==1),4);
    
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
    if isempty(fileparts(x.output_dir))
        outdir=  fullfile(fileparts(x.excelfile), x.output_dir);
        mkdir(outdir);
        s.output_dir=outdir;
        
    end
end
set(gcf,'userdata',s);

xvv.x=x;
xvv.s=s;
xvv.p=p;








% function prefs


function pref=getprefs

pref.nmaxclust= 3    ; %    ; - number of maxima per cluster [3]
pref.clustdist= 0.5  ; %mm  ; - distance among clusters {mm} [8]

pref.thresh       =  0.05 ;
pref.clustersize  =    1 ;
pref.mcp          = 'FWE' ;



function spmsetup

if sum([~isempty(findobj(0,'tag','Graphics'))
        ~isempty(findobj(0,'tag','Interactive'))
        ~isempty(findobj(0,'tag','Interactive'))])  ~=3
    
    
    
    delete(findobj(0,'tag','Graphics'));
    delete(findobj(0,'tag','Interactive'));
    delete(findobj(0,'tag','Interactive'));
    
    useotherspm(1);
    spm fmri
end
%����������������������������������������������������������������������������������������������������
%% local defs

pref=getprefs;

pref.mip=which('AllenMip.mat');

pref.anofile   =which('sANO.nii' );
pref.fibfile   =which('sFIBT.nii' );

pref.template  =which('sAVGT.nii');
% pref.nmaxclust= 3    ; %    ; - number of maxima per cluster [3]
% pref.clustdist= 0.5  ; %mm  ; - distance among clusters {mm} [8]
% 
% pref.thresh       =  0.05 ;
% pref.clustersize  =    30 ;
% pref.mcp          = 'FWE' ;



global lab
if isempty(lab)
    [lab.ha lab.a  lab.xyz lab.xyzind]=rgetnii(pref.anofile)  ;% rgetnii(fullfile('O:\data\voxelwise_Maritzen4tool\templates','ANO.nii'));
    [lab.hf lab.f  lab.fxyz lab.fxyzind]=rgetnii(pref.fibfile)  ;% r
    xx = load('gematlabt_labels.mat');
    [table at] = buildtable(xx.matlab_results{1}.msg{1});
    lab.at=at;
    disp('..loading atlas');
end

if isfield(lab,'template')==0
    lab.template= pref.template ;%'O:\data\voxelwise_Maritzen4tool\templates\AVGT.nii';
end

lab.pref=pref;








%����������������������������������������������������������������������������������������������������
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




%�����������������������������������������������
%%   loadSPMmat-input
%�����������������������������������������������
function loadSPMmat(e,e2)

global lab; %remove previous cluster
try; lab=rmfield(lab,'clusterregions'); end
spmsetup
[hReg,xSPM,SPM] = spm_results_ui;


try; assignin('base','hReg', hReg); end
try; assignin('base','xSPM', xSPM); end
try; assignin('base','SPM', SPM); end

loadothercontrast('initialize');

%�����������������������������������������������
%%   loadSPMmat- fast
%�����������������������������������������������
function loadSPMmatnoInput(e,e2,spmfile)

global lab; %remove previous cluster
try; lab=rmfield(lab,'clusterregions'); end

spmsetup

if exist('spmfile')==0
    [files,dirs] = spm_select(1,'mat','select [SPM.mat]',[],pwd,'SPM.mat');
else
    files=spmfile;
end

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
spm_jobman('run',mb);

try; assignin('base','hReg', hReg); end
try; assignin('base','xSPM', xSPM); end
try; assignin('base','SPM', SPM); end

loadothercontrast('initialize');

drawnow;
hfig=findobj(0,'tag','vvstat');   
figure(hfig);
uicontrol(findobj(hfig,'tag','loadothercontrast'));


%�����������������������������������������������
%%  showSections
%�����������������������������������������������
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
ixatlas =find([lab.at(:).id]==id);

idfib       =lab.f(ca(1),ca(2),ca(3));
ixfibatlas  =find([lab.at(:).id]==idfib);

if isempty(ixatlas);
    atlasname=[' &empty;GM '] ;%'no GM region'; %disp('no region found');
else
    atlasname=lab.at(ixatlas).name;
end

if isempty(ixfibatlas);
    atlasfibname=[' &empty;WM ']; %disp('no region found');
else
    atlasfibname=lab.at(ixfibatlas).name;
end


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
        ixatlas =find([lab.at(:).id]==id);
        if isempty(ixatlas);
            %             disp('no region found');
            %clusterregions{i}=lab.at(ixatlas).name
        else
            %             disp(lab.at(ixatlas).name);
            clusterregions{i}=lab.at(ixatlas).name;
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


function exporttable(e,e2);
tb=maketable;
if isempty(tb); return; end
% uhelp(plog({}, [he;d2],0,'','s=0'),1)
uhelp(tb,1);

[fi pa]=uiputfile('*.txt','save table as textfile');
if ischar(fi)
    [~,fi,~]=fileparts(fi);
    fiout=fullfile(pa,[fi '.txt']);
    pwrite2file(fiout,tb);
   try
     disp(['saved table <a href="matlab: explorerpreselect(''' fiout ''')">' fiout '</a>']);
   end
end



function tb=maketable
% spm_list('TxtList',r,1)


global lab

TabDat=evalin('base','TabDat');
r=TabDat;
if isempty(r.dat)
    disp(['no suprathreshold clusters found - nothing saved']);
    tb=[];
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

add={};
add(end+1,1)={r.str};
for i=1:size(r.ftr,1)
    add(end+1,1)={  sprintf(r.ftr{i,1},r.ftr{i,2})   };
end

r2=plog({}, [he;d2],0,'','s=0;plotlines=0');
lin={repmat('=',1,length(r2{1}))};
tb=[lin; r2(1:2);lin; r2(3:end);lin; add];




function show_mricron(e,e2)
global lab


f1=lab.template ;%'o:\antx\mritools\ant\templateBerlin_hres\sAVGT.nii'
[fi pa]=uigetfile('*.nii','select NIFTI to overlay');
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

function save_threshvolume(e,e2)

xSPM = evalin('base','xSPM;');
XYZ  = xSPM.XYZ;

action='thresh'
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


[fi pa]=uiputfile('*.nii','save thresholded nifti-volume as..');
if isnumeric(fi); return; end

fileoutname=fullfile(pa, [strrep(fi,'.nii','.nii') ]);
spm_write_filtered(Z, XYZ, xSPM.DIM, xSPM.M,...
    sprintf('SPM{%c}-filtered: u = %5.3f, k = %d',xSPM.STAT,xSPM.u,xSPM.k),fileoutname);



%����������������������������������������������������������������������������������������������������
%�����������������������������������������������
%%              MODELS
%�����������������������������������������������
%����������������������������������������������������������������������������������������������������



%�����������������������������������������������
%%   userdefined
%�����������������������������������������������

function userdefined(e,e2)
spmsetup ;
spm_jobman;

%�����������������������������������������������
%%   paired-sample ttest
%�����������������������������������������������

function pairedsampleTest(e,e2,varargin)
warning off;
global xvv
xvv.xtype='pairedttest';
readexcel(xvv.xtype);
fmakebatch(mfilename );

% disp('fun: pairedsampleTest');
% return;%*
% -------------------------
spmsetup;

hfig=findobj(0,'tag','vvstat');
s=get(hfig,'userdata');
try ;     cd(s.workpath); end
%---------------------------------

% set(  findobj(0,'tag','vvstat') ,'userdata',s)


outdir   =  s.output_dir   ;          
rmdir(outdir,'s');
mkdir(outdir);

mask     =  s.mask         ;
g1       =  s.grp_1        ;
g2       =  s.grp_2        ;

mb={};
for i=1:size(g1,1)
    dv={[g1{i} ,',1']; [g2{i} ,',1'] };
    %disp([i]);     disp(char(dv));
    mb{1}.spm.stats.factorial_design.des.pt.pair(i).scans =dv;
    
end
    
mb{1}.spm.stats.factorial_design.dir ={outdir}  ;% {'O:\data\voxelwise_Maritzen4tool\test_1'};


% mb{1}.spm.stats.factorial_design.des.pt.pair(1).scans = {
%                                                                   'O:\data\voxelwise_Maritzen4tool\bla.nii,1'
%                                                                   'O:\data\voxelwise_Maritzen4tool\bla2.nii,1'
%                                                                   };
% mb{1}.spm.stats.factorial_design.des.pt.pair(2).scans = {
%                                                                   'O:\data\voxelwise_Maritzen4tool\bla.nii,1'
%                                                                   'O:\data\voxelwise_Maritzen4tool\bla2.nii,1'
%                                                                   };
% mb{1}.spm.stats.factorial_design.des.pt.pair(3).scans = {
%                                                                   'O:\data\voxelwise_Maritzen4tool\bla.nii,1'
%                                                                   'O:\data\voxelwise_Maritzen4tool\bla2.nii,1'
%                                                                   };
% mb{1}.spm.stats.factorial_design.des.pt.pair(4).scans = {
%                                                                   'O:\data\voxelwise_Maritzen4tool\bla.nii,1'
%                                                                   'O:\data\voxelwise_Maritzen4tool\bla2.nii,1'
%                                                                   };
% mb{1}.spm.stats.factorial_design.des.pt.pair(5).scans = {
%                                                                   'O:\data\voxelwise_Maritzen4tool\bla.nii,1'
%                                                                   'O:\data\voxelwise_Maritzen4tool\bla2.nii,1'
%                                                                   };
mb{1}.spm.stats.factorial_design.des.pt.gmsca = 0;
mb{1}.spm.stats.factorial_design.des.pt.ancova = 0;
mb{1}.spm.stats.factorial_design.cov = struct('c', {}, 'cname', {}, 'iCFI', {}, 'iCC', {});
mb{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
mb{1}.spm.stats.factorial_design.masking.im = 1;
mb{1}.spm.stats.factorial_design.masking.em =  {mask};  % {'O:\data\voxelwise_Maritzen4tool\templates\AVGTmask.nii'};
mb{1}.spm.stats.factorial_design.globalc.g_omit = 1;
mb{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
mb{1}.spm.stats.factorial_design.globalm.glonorm = 1;
mb{2}.spm.stats.fmri_est.spmmat(1) = cfg_dep;
mb{2}.spm.stats.fmri_est.spmmat(1).tname = 'Select SPM.mat';
mb{2}.spm.stats.fmri_est.spmmat(1).tgt_spec{1}(1).name = 'filter';
mb{2}.spm.stats.fmri_est.spmmat(1).tgt_spec{1}(1).value = 'mat';
mb{2}.spm.stats.fmri_est.spmmat(1).tgt_spec{1}(2).name = 'strtype';
mb{2}.spm.stats.fmri_est.spmmat(1).tgt_spec{1}(2).value = 'e';
mb{2}.spm.stats.fmri_est.spmmat(1).sname = 'Factorial design specification: SPM.mat File';
mb{2}.spm.stats.fmri_est.spmmat(1).src_exbranch = substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1});
mb{2}.spm.stats.fmri_est.spmmat(1).src_output = substruct('.','spmmat');
mb{2}.spm.stats.fmri_est.method.Classical = 1;

mb{3}.spm.stats.con.spmmat(1) = cfg_dep;
mb{3}.spm.stats.con.spmmat(1).tname = 'Select SPM.mat';
mb{3}.spm.stats.con.spmmat(1).tgt_spec{1}(1).name = 'filter';
mb{3}.spm.stats.con.spmmat(1).tgt_spec{1}(1).value = 'mat';
mb{3}.spm.stats.con.spmmat(1).tgt_spec{1}(2).name = 'strtype';
mb{3}.spm.stats.con.spmmat(1).tgt_spec{1}(2).value = 'e';
mb{3}.spm.stats.con.spmmat(1).sname = 'Model estimation: SPM.mat File';
mb{3}.spm.stats.con.spmmat(1).src_exbranch = substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1});
mb{3}.spm.stats.con.spmmat(1).src_output = substruct('.','spmmat');
mb{3}.spm.stats.con.consess{1}.tcon.name = '1>2';
mb{3}.spm.stats.con.consess{1}.tcon.convec = [1 -1];
mb{3}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
mb{3}.spm.stats.con.consess{2}.tcon.name = '1<2';
mb{3}.spm.stats.con.consess{2}.tcon.convec = [-1 1];
mb{3}.spm.stats.con.consess{2}.tcon.sessrep = 'none';
mb{3}.spm.stats.con.delete = 0;

mb{4}.spm.stats.results.spmmat(1) = cfg_dep;
mb{4}.spm.stats.results.spmmat(1).tname = 'Select SPM.mat';
mb{4}.spm.stats.results.spmmat(1).tgt_spec{1}(1).name = 'filter';
mb{4}.spm.stats.results.spmmat(1).tgt_spec{1}(1).value = 'mat';
mb{4}.spm.stats.results.spmmat(1).tgt_spec{1}(2).name = 'strtype';
mb{4}.spm.stats.results.spmmat(1).tgt_spec{1}(2).value = 'e';
mb{4}.spm.stats.results.spmmat(1).sname = 'Contrast Manager: SPM.mat File';
mb{4}.spm.stats.results.spmmat(1).src_exbranch = substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1});
mb{4}.spm.stats.results.spmmat(1).src_output = substruct('.','spmmat');
mb{4}.spm.stats.results.conspec(1).titlestr = '1>2';
mb{4}.spm.stats.results.conspec(1).contrasts = 1;
mb{4}.spm.stats.results.conspec(1).threshdesc = 'FWE';
mb{4}.spm.stats.results.conspec(1).thresh = 0.05;
mb{4}.spm.stats.results.conspec(1).extent = 0;
mb{4}.spm.stats.results.conspec(1).mask = struct('contrasts', {}, 'thresh', {}, 'mtype', {});
mb{4}.spm.stats.results.conspec(2).titlestr = '1<2';
mb{4}.spm.stats.results.conspec(2).contrasts = 2;
mb{4}.spm.stats.results.conspec(2).threshdesc = 'FWE';
mb{4}.spm.stats.results.conspec(2).thresh = 0.05;
mb{4}.spm.stats.results.conspec(2).extent = 0;
mb{4}.spm.stats.results.conspec(2).mask = struct('contrasts', {}, 'thresh', {}, 'mtype', {});
mb{4}.spm.stats.results.units = 1;
mb{4}.spm.stats.results.print = false;



%% smoothing
% change [1] Data Smoothing [2]data for factDesignSpecif. [3] dependency-order
if s.smoothing==1
    try
        smoothfwhm=str2num(s.smoothing_fwhm);
    catch
        smoothfwhm=        (s.smoothing_fwhm);
    end
    ms={};
    ms{1}.spm.spatial.smooth.data = [g1;g2];
    ms{1}.spm.spatial.smooth.fwhm = smoothfwhm ;% [0.28 0.28 0.28];
    ms{1}.spm.spatial.smooth.dtype = 0;
    ms{1}.spm.spatial.smooth.im = 0;
    ms{1}.spm.spatial.smooth.prefix = 's';
    
    
    %change inputfiles to smoothed images
    mb{1}.spm.stats.factorial_design.des.t2.scans1 = stradd(g1,'s',1);
    mb{1}.spm.stats.factorial_design.des.t2.scans2 = stradd(g2,'s',1);
    
    for i=1:size(g1,1)
        %dv={[g1{i} ,',1']; [g2{i} ,',1'] };
        dv={[stradd(g1{i},'s',1) ,',1']; [stradd(g2{i},'s',1) ,',1'] };
        %disp([i]);     disp(char(dv));
        mb{1}.spm.stats.factorial_design.des.pt.pair(i).scans =dv;
    end

    
    mb=  [ms mb ]  ;% add smoothing job
    %% UPDATE dependency-order
    mb{3}.spm.stats.fmri_est.spmmat(1).src_exbranch   = substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1});
    mb{4}.spm.stats.con.spmmat(1).src_exbranch        = substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1});
    mb{5}.spm.stats.results.spmmat(1).src_exbranch    = substruct('.','val', '{}',{4}, '.','val', '{}',{1}, '.','val', '{}',{1}); 

end

%..........................................
idmb=spm_jobman('interactive',mb);
matlabbatch=mb;
save(fullfile(s.output_dir,'job'),'matlabbatch'); %SAVE BATCH
drawnow;

if xvv.x.showSPMbatch==0
    spm_jobman('run',mb);
end


try ;    cd(s.workpath); end



if 0
    %get batch from grui
    [ee mb]=spm_jobman('harvest',idmb)
    
end


%�����������������������������������������������
%%   onewayanova
%�����������������������������������������������

function onewayanova(e,e2,varargin)
warning off;
global xvv
xvv.xtype='onewayanova';
readexcel(xvv.xtype);
fmakebatch(mfilename );

disp('fun: onewayanova');
% return;%*
% -------------------------
spmsetup;
hfig=findobj(0,'tag','vvstat');
s=get(hfig,'userdata');
try ;     cd(s.workpath); end


%�����������������������������������������������
%  get niftis and regressors
%�����������������������������������������������
x=xvv.x;
grps=unique(s.d(:,2),'stable');
niftis    ={};
regresvals=[];
for i=1:length(grps)
    ix=find(strcmp(s.d(:,2),grps{i}));
    %niftis{i,1}=s.d(ix,4)
     niftis{i,1}=cellfun(@(a){[ a ',1']},s.d(ix,4));
    if ~isempty(x.regress_col)
            regresvals=[regresvals;  cell2mat(s.d(ix,5:5+length(x.regress_col)-1)) ];
    end
end
regressnames=s.regressname;

%�����������������������������������������������
%   get other parans
%�����������������������������������������������
outdir    = s.output_dir; 
rmdir(outdir,'s');
mkdir(outdir);

mask      = s.mask;

%�����������������������������������������������
%  batch
%�����������������������������������������������
mb={};
mb{1}.spm.stats.factorial_design.dir = {outdir};

for i=1:length(grps)
    mb{1}.spm.stats.factorial_design.des.anova.icell(i,1).scans =   niftis{i};
end

% mb{1}.spm.stats.factorial_design.des.anova.icell(1).scans = {
%                                                                       'O:\data\voxelwise_Maritzen4tool\dat\20161215TM_M6590_neu\JD.nii'
%                                                                       'O:\data\voxelwise_Maritzen4tool\dat\20161215TM_M6591\JD.nii'
%                                                                       'O:\data\voxelwise_Maritzen4tool\dat\20170112TM_M6615\JD.nii'
%                                                                       'O:\data\voxelwise_Maritzen4tool\dat\20170112TM_M6617\JD.nii'
%                                                                       };
% mb{1}.spm.stats.factorial_design.des.anova.icell(2).scans = {
%                                                                       'O:\data\voxelwise_Maritzen4tool\dat\20170112TM_M7065\JD.nii'
%                                                                       'O:\data\voxelwise_Maritzen4tool\dat\20170112TM_M7067\JD.nii'
%                                                                       'O:\data\voxelwise_Maritzen4tool\dat\20170113TM_M7068\JD.nii'
%                                                                       'O:\data\voxelwise_Maritzen4tool\dat\20170113TM_M7070\JD.nii'
%                                                                       };
% mb{1}.spm.stats.factorial_design.des.anova.icell(3).scans = {
%                                                                       'O:\data\voxelwise_Maritzen4tool\dat\20170113TM_M7334\JD.nii'
%                                                                       'O:\data\voxelwise_Maritzen4tool\dat\20170113TM_M7338\JD.nii'
%                                                                       'O:\data\voxelwise_Maritzen4tool\dat\20170223TM_M9513\JD.nii'
%                                                                       'O:\data\voxelwise_Maritzen4tool\dat\20170223TM_M9515\JD.nii'
%                                                                       };
mb{1}.spm.stats.factorial_design.des.anova.dept = 0;
mb{1}.spm.stats.factorial_design.des.anova.variance = 1;
mb{1}.spm.stats.factorial_design.des.anova.gmsca = 0;
mb{1}.spm.stats.factorial_design.des.anova.ancova = 0;
%%
%% without covariates
if isempty(x.regress_col)
   mb{1}.spm.stats.factorial_design.cov = struct('c', {}, 'cname', {}, 'iCFI', {}, 'iCC', {}); 
else
    %% WITH covariates
    for i=1:size(x.regress_col,2)
        mb{1}.spm.stats.factorial_design.cov(i).c       = regresvals(:,i);
        mb{1}.spm.stats.factorial_design.cov(i).cname   = regressnames{i};
        mb{1}.spm.stats.factorial_design.cov(i).iCFI    = 1;
        mb{1}.spm.stats.factorial_design.cov(i).iCC     = 1;
    end
    
    
end

% mb{1}.spm.stats.factorial_design.cov(1).c = [1
%                                                       2
%                                                       3
%                                                       4
%                                                       5
%                                                       6
%                                                       7
%                                                       8
%                                                       9
%                                                       10
%                                                       11
%                                                       12];
% %%
% mb{1}.spm.stats.factorial_design.cov(1).cname = 'blob1';
% mb{1}.spm.stats.factorial_design.cov(1).iCFI = 1;
% mb{1}.spm.stats.factorial_design.cov(1).iCC = 1;
% %%
% mb{1}.spm.stats.factorial_design.cov(2).c = [1
%                                                       2
%                                                       1
%                                                       2
%                                                       3
%                                                       2
%                                                       1
%                                                       3
%                                                       4
%                                                       3
%                                                       4
%                                                       1];
% %%
% mb{1}.spm.stats.factorial_design.cov(2).cname = 'blob2';
% mb{1}.spm.stats.factorial_design.cov(2).iCFI = 1;
% mb{1}.spm.stats.factorial_design.cov(2).iCC = 1;

mb{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
mb{1}.spm.stats.factorial_design.masking.im = 1;
mb{1}.spm.stats.factorial_design.masking.em = {mask};
mb{1}.spm.stats.factorial_design.globalc.g_omit = 1;
mb{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
mb{1}.spm.stats.factorial_design.globalm.glonorm = 1;

mb{2}.spm.stats.fmri_est.spmmat(1) = cfg_dep;
mb{2}.spm.stats.fmri_est.spmmat(1).tname = 'Select SPM.mat';
mb{2}.spm.stats.fmri_est.spmmat(1).tgt_spec{1}(1).name = 'filter';
mb{2}.spm.stats.fmri_est.spmmat(1).tgt_spec{1}(1).value = 'mat';
mb{2}.spm.stats.fmri_est.spmmat(1).tgt_spec{1}(2).name = 'strtype';
mb{2}.spm.stats.fmri_est.spmmat(1).tgt_spec{1}(2).value = 'e';
mb{2}.spm.stats.fmri_est.spmmat(1).sname = 'Factorial design specification: SPM.mat File';
mb{2}.spm.stats.fmri_est.spmmat(1).src_exbranch = substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1});
mb{2}.spm.stats.fmri_est.spmmat(1).src_output = substruct('.','spmmat');
mb{2}.spm.stats.fmri_est.method.Classical = 1;

mb{3}.spm.stats.con.spmmat(1) = cfg_dep;
mb{3}.spm.stats.con.spmmat(1).tname = 'Select SPM.mat';
mb{3}.spm.stats.con.spmmat(1).tgt_spec{1}(1).name = 'filter';
mb{3}.spm.stats.con.spmmat(1).tgt_spec{1}(1).value = 'mat';
mb{3}.spm.stats.con.spmmat(1).tgt_spec{1}(2).name = 'strtype';
mb{3}.spm.stats.con.spmmat(1).tgt_spec{1}(2).value = 'e';
mb{3}.spm.stats.con.spmmat(1).sname = 'Model estimation: SPM.mat File';
mb{3}.spm.stats.con.spmmat(1).src_exbranch = substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1});
mb{3}.spm.stats.con.spmmat(1).src_output = substruct('.','spmmat');



% v=allcomb(grps,grps);
%�����������������������������������������������
%  contrasts
%�����������������������������������������������
v=nchoosek([1:length(grps)],2);
pat={'>'   1 -1
    '<'   -1 1 };
cons={};
for i=1:size(v,1)
    n=1;
    dzero=zeros(1,10);
    dzero([v(i,1)  v(i,2)] ) =  [pat{n,2}  pat{n,3}];
    cons(end+1,:)=  {[grps{v(i,1)} pat{n,1}  grps{v(i,2)}  ]   dzero(1:v(i,2))   };
    
    n=2;
    dzero=zeros(1,10);
    dzero([v(i,1)  v(i,2)] ) =  [pat{n,2}  pat{n,3}];
    cons(end+1,:)=  {[grps{v(i,1)} pat{n,1}  grps{v(i,2)}  ]   dzero(1:v(i,2))   };
end

for i=1:size(cons,1)
    mb{3}.spm.stats.con.consess{i}.tcon.name    = cons{i,1}   ;%'a1>a2';
    mb{3}.spm.stats.con.consess{i}.tcon.convec  = cons{i,2}   ;%[1 -1];
    mb{3}.spm.stats.con.consess{i}.tcon.sessrep = 'none';
end


% % % mb{3}.spm.stats.con.consess{1}.tcon.name = 'a1>a2';
% % % mb{3}.spm.stats.con.consess{1}.tcon.convec = [1 -1];
% % % mb{3}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
% % % 
% % % mb{3}.spm.stats.con.consess{2}.tcon.name = 'a1<a2';
% % % mb{3}.spm.stats.con.consess{2}.tcon.convec = [-1 1];
% % % mb{3}.spm.stats.con.consess{2}.tcon.sessrep = 'none';

mb{3}.spm.stats.con.delete = 0;



mb{4}.spm.stats.results.spmmat(1) = cfg_dep;
mb{4}.spm.stats.results.spmmat(1).tname = 'Select SPM.mat';
mb{4}.spm.stats.results.spmmat(1).tgt_spec{1}(1).name = 'filter';
mb{4}.spm.stats.results.spmmat(1).tgt_spec{1}(1).value = 'mat';
mb{4}.spm.stats.results.spmmat(1).tgt_spec{1}(2).name = 'strtype';
mb{4}.spm.stats.results.spmmat(1).tgt_spec{1}(2).value = 'e';
mb{4}.spm.stats.results.spmmat(1).sname = 'Contrast Manager: SPM.mat File';
mb{4}.spm.stats.results.spmmat(1).src_exbranch = substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1});
mb{4}.spm.stats.results.spmmat(1).src_output = substruct('.','spmmat');
mb{4}.spm.stats.results.conspec(1).titlestr = '';
mb{4}.spm.stats.results.conspec(1).contrasts = 1;
mb{4}.spm.stats.results.conspec(1).threshdesc = 'FWE';
mb{4}.spm.stats.results.conspec(1).thresh = 0.05;
mb{4}.spm.stats.results.conspec(1).extent = 0;
mb{4}.spm.stats.results.conspec(1).mask = struct('contrasts', {}, 'thresh', {}, 'mtype', {});


% mb{4}.spm.stats.results.conspec(2).titlestr = '';
% mb{4}.spm.stats.results.conspec(2).contrasts = 2;
% mb{4}.spm.stats.results.conspec(2).threshdesc = 'FWE';
% mb{4}.spm.stats.results.conspec(2).thresh = 0.05;
% mb{4}.spm.stats.results.conspec(2).extent = 0;
% mb{4}.spm.stats.results.conspec(2).mask = struct('contrasts', {}, 'thresh', {}, 'mtype', {});
mb{4}.spm.stats.results.units = 1;
mb{4}.spm.stats.results.print = false;


%%  smoothing
if s.smoothing==1
    % change [1] Data Smoothing [2]data for factDesignSpecif. [3] dependency-order
    try
        smoothfwhm=str2num(s.smoothing_fwhm);
    catch
        smoothfwhm=        (s.smoothing_fwhm);
    end
    
    nifti_all={};
    for i=1:length(grps)
        nifti_all=[nifti_all;  niftis{i} ] ;
    end

    
    
    
    ms={};
    ms{1}.spm.spatial.smooth.data = [nifti_all];
    ms{1}.spm.spatial.smooth.fwhm = smoothfwhm ;% [0.28 0.28 0.28];
    ms{1}.spm.spatial.smooth.dtype = 0;
    ms{1}.spm.spatial.smooth.im = 0;
    ms{1}.spm.spatial.smooth.prefix = 's';
    
    
    %change inputfiles to smoothed images
    for i=1:length(grps)
        mb{1}.spm.stats.factorial_design.des.anova.icell(i,1).scans = stradd( niftis{i},'s',1);   
    end

    
    
    mb=  [ms mb ]  ;% add smoothing job
    %% UPDATE dependency-order
    mb{3}.spm.stats.fmri_est.spmmat(1).src_exbranch   = substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1});
    mb{4}.spm.stats.con.spmmat(1).src_exbranch        = substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1});
    mb{5}.spm.stats.results.spmmat(1).src_exbranch    = substruct('.','val', '{}',{4}, '.','val', '{}',{1}, '.','val', '{}',{1});
    
end


%..........................................
idmb=spm_jobman('interactive',mb);
matlabbatch=mb;
save(fullfile(s.output_dir,'job'),'matlabbatch'); %SAVE BATCH
drawnow;
if xvv.x.showSPMbatch==0
    spm_jobman('run',mb);
end
try ;    cd(s.workpath); end






%�����������������������������������������������
%%   fullfactorial
%�����������������������������������������������

function fullfactorial(e,e2,varargin)
warning off;
global xvv
xvv.xtype='fullfactorial';
readexcel(xvv.xtype);
fmakebatch(mfilename );

disp(['fun: ' xvv.xtype]);
% return;%*
% -------------------------
spmsetup;
hfig=findobj(0,'tag','vvstat');
s=get(hfig,'userdata');
try ;     cd(s.workpath); end


%�����������������������������������������������
%  get niftis and regressors
%�����������������������������������������������
x=xvv.x;

% REMOVE MISSING DATA
ivalid=find(cell2mat(s.d(:,end-1)));
nonvalid=find(cell2mat(s.d(:,end-1))==0);
if ~isempty(nonvalid)
    disp('### files not found :');
    disp(char(cellfun(@(a) {[ ' not found... ' a]},s.d(nonvalid,end))));
end
s.d=s.d(ivalid,:);

levels    =s.d(:,2:length(s.dfactornames)+1);
levels    =cell2mat(cellfun(@(a){[str2num(a)]},levels));
regressors=[];
if ~isempty(s.regressname)
    regressors=s.d(:,length(s.dfactornames)+2: length(s.dfactornames)+2 +length(s.regressname)-1);
   regressors=regressors(:,1) ;
end
comb=unique(levels,'rows');


scans  ={};
lev    ={};
nlev   =max(comb);
covars =[];
factors=s.dfactornames;
for i=1:size(comb,1)
    ix=find(sum(abs(levels-repmat(comb(i,:),[size(levels,1) 1])),2)==0);
    scans{i,1}=s.d(ix,end);                   % # NIFTIS
    lev{i,1}  =comb(i,:)  ;                   % # LEVEL
    if ~isempty(s.regressname)
        covars=[covars; [regressors(ix,:)] ]; %  # RGRESSORS
        regressname=s.regressname{1};
    end
end

if ~isempty(covars);     covars=cell2mat(covars);          end


%�����������������������������������������������
%   get other parans
%�����������������������������������������������
outdir    = s.output_dir; 
try; rmdir(outdir,'s'); end
try;mkdir(outdir);end
mask      = s.mask;

%�����������������������������������������������
%%  batch
%�����������������������������������������������
mb={};
mb{1}.spm.stats.factorial_design.dir ={outdir}                ;% {'O:\data2\x03_yildirim\v00_fullfactorial_test\'};

for i=1:length(factors) %FACTOR
    mb{1}.spm.stats.factorial_design.des.fd.fact(i).name =        factors{i} ;% 'desease';
    mb{1}.spm.stats.factorial_design.des.fd.fact(i).levels =      nlev(i);
    mb{1}.spm.stats.factorial_design.des.fd.fact(i).dept = 0;
    mb{1}.spm.stats.factorial_design.des.fd.fact(i).variance = 1;
    mb{1}.spm.stats.factorial_design.des.fd.fact(i).gmsca = 0;
    mb{1}.spm.stats.factorial_design.des.fd.fact(i).ancova = 0;
end

for i=1:size(lev,1)  % SCANS for each COMBI
    mb{1}.spm.stats.factorial_design.des.fd.icell(i).scans =       scans{i};      % # SCANS
    mb{1}.spm.stats.factorial_design.des.fd.icell(i).levels =      lev{i}  ; % # FACT-COMBI  ([2  1])
end

% mb{1}.spm.stats.factorial_design.cov = struct('c', {}, 'cname', {}, 'iCFI', {}, 'iCC', {});
mb{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
mb{1}.spm.stats.factorial_design.masking.im         = 1;
mb{1}.spm.stats.factorial_design.masking.em         = {mask};

mb{1}.spm.stats.factorial_design.globalc.g_omit         = 1;
mb{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
mb{1}.spm.stats.factorial_design.globalm.glonorm        = 1;

if ~isempty(covars)           %COVARIANCE
    mb{1}.spm.stats.factorial_design.cov.c      = covars ;
    mb{1}.spm.stats.factorial_design.cov.cname  = regressname ;
    mb{1}.spm.stats.factorial_design.cov.iCFI   = 1;
    mb{1}.spm.stats.factorial_design.cov.iCC    = 1;
else
    mb{1}.spm.stats.factorial_design.cov = struct('c', {}, 'cname', {}, 'iCFI', {}, 'iCC', {});

end

mb{2}.spm.stats.fmri_est.spmmat(1) = cfg_dep;
mb{2}.spm.stats.fmri_est.spmmat(1).tname = 'Select SPM.mat';
mb{2}.spm.stats.fmri_est.spmmat(1).tgt_spec{1}(1).name = 'filter';
mb{2}.spm.stats.fmri_est.spmmat(1).tgt_spec{1}(1).value = 'mat';
mb{2}.spm.stats.fmri_est.spmmat(1).tgt_spec{1}(2).name = 'strtype';
mb{2}.spm.stats.fmri_est.spmmat(1).tgt_spec{1}(2).value = 'e';
mb{2}.spm.stats.fmri_est.spmmat(1).sname = 'Factorial design specification: SPM.mat File';
mb{2}.spm.stats.fmri_est.spmmat(1).src_exbranch = substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1});
mb{2}.spm.stats.fmri_est.spmmat(1).src_output = substruct('.','spmmat');
mb{2}.spm.stats.fmri_est.method.Classical = 1;

mb{3}.spm.stats.con.spmmat(1) = cfg_dep;
mb{3}.spm.stats.con.spmmat(1).tname = 'Select SPM.mat';
mb{3}.spm.stats.con.spmmat(1).tgt_spec{1}(1).name = 'filter';
mb{3}.spm.stats.con.spmmat(1).tgt_spec{1}(1).value = 'mat';
mb{3}.spm.stats.con.spmmat(1).tgt_spec{1}(2).name = 'strtype';
mb{3}.spm.stats.con.spmmat(1).tgt_spec{1}(2).value = 'e';
mb{3}.spm.stats.con.spmmat(1).sname = 'Model estimation: SPM.mat File';
mb{3}.spm.stats.con.spmmat(1).src_exbranch = substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1});
mb{3}.spm.stats.con.spmmat(1).src_output = substruct('.','spmmat');
mb{3}.spm.stats.con.delete = 0;

if length(factors)>=2
    mb{3}.spm.stats.con.consess{1}.tcon.name    = ['negative effect of ' factors{1}];
    mb{3}.spm.stats.con.consess{1}.tcon.convec  = [-ones(1,nlev(1)) ones(1,prod(nlev(2:end)))] ;% [-1 -1 1 1];
    mb{3}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
    
    mb{3}.spm.stats.con.consess{2}.tcon.name    =['negative effect of ' factors{2}];;
    mb{3}.spm.stats.con.consess{2}.tcon.convec  = [-1 1 -1 1];
    mb{3}.spm.stats.con.consess{2}.tcon.sessrep = 'none';
    
    mb{3}.spm.stats.con.consess{3}.tcon.name    = ['negative Interaction: ' factors{1} ' x ' factors{2}];
    mb{3}.spm.stats.con.consess{3}.tcon.convec  = [-1 1 1 -1];
    mb{3}.spm.stats.con.consess{3}.tcon.sessrep = 'none';
    mb{3}.spm.stats.con.delete = 0;
end


mb{4}.spm.stats.results.spmmat(1) = cfg_dep;
mb{4}.spm.stats.results.spmmat(1).tname = 'Select SPM.mat';
mb{4}.spm.stats.results.spmmat(1).tgt_spec{1}(1).name = 'filter';
mb{4}.spm.stats.results.spmmat(1).tgt_spec{1}(1).value = 'mat';
mb{4}.spm.stats.results.spmmat(1).tgt_spec{1}(2).name = 'strtype';
mb{4}.spm.stats.results.spmmat(1).tgt_spec{1}(2).value = 'e';
mb{4}.spm.stats.results.spmmat(1).sname = 'Contrast Manager: SPM.mat File';
mb{4}.spm.stats.results.spmmat(1).src_exbranch = substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1});
mb{4}.spm.stats.results.spmmat(1).src_output = substruct('.','spmmat');
mb{4}.spm.stats.results.conspec(1).titlestr = '';
mb{4}.spm.stats.results.conspec(1).contrasts = 1;
mb{4}.spm.stats.results.conspec(1).threshdesc = 'FWE';
mb{4}.spm.stats.results.conspec(1).thresh = 0.05;
mb{4}.spm.stats.results.conspec(1).extent = 0;
mb{4}.spm.stats.results.conspec(1).mask = struct('contrasts', {}, 'thresh', {}, 'mtype', {});
% mb{4}.spm.stats.results.conspec(2).titlestr = '';
% mb{4}.spm.stats.results.conspec(2).contrasts = 2;
% mb{4}.spm.stats.results.conspec(2).threshdesc = 'FWE';
% mb{4}.spm.stats.results.conspec(2).thresh = 0.05;
% mb{4}.spm.stats.results.conspec(2).extent = 0;
% mb{4}.spm.stats.results.conspec(2).mask = struct('contrasts', {}, 'thresh', {}, 'mtype', {});
mb{4}.spm.stats.results.units = 1;
mb{4}.spm.stats.results.print = false;


%%  smoothing
if s.smoothing==1
    % change [1] Data Smoothing [2]data for factDesignSpecif. [3] dependency-order
    try ;        smoothfwhm=str2num(s.smoothing_fwhm);
    catch;       smoothfwhm=        (s.smoothing_fwhm);
    end
    
    nifti_all={};
    for i=1:size(scans,1)
        nifti_all=[nifti_all;  scans{i} ] ;
    end

    ms={};
    ms{1}.spm.spatial.smooth.data = [nifti_all];
    ms{1}.spm.spatial.smooth.fwhm = smoothfwhm ;% [0.28 0.28 0.28];
    ms{1}.spm.spatial.smooth.dtype = 0;
    ms{1}.spm.spatial.smooth.im = 0;
    ms{1}.spm.spatial.smooth.prefix = 's';
    
    %change inputfiles to smoothed images
    for i=1:size(scans,1)
        mb{1}.spm.stats.factorial_design.des.fd.icell(i).scans =      stradd( scans{i},'s',1);
    end
  
    mb=  [ms mb ]  ;% add smoothing job
    %% UPDATE dependency-order
    mb{3}.spm.stats.fmri_est.spmmat(1).src_exbranch   = substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1});
    mb{4}.spm.stats.con.spmmat(1).src_exbranch        = substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1});
    mb{5}.spm.stats.results.spmmat(1).src_exbranch    = substruct('.','val', '{}',{4}, '.','val', '{}',{1}, '.','val', '{}',{1});  
end


%..........................................
idmb=spm_jobman('interactive',mb);
matlabbatch=mb;
save(fullfile(s.output_dir,'job'),'matlabbatch'); %SAVE BATCH
drawnow;
if xvv.x.showSPMbatch==0
    spm_jobman('run',mb);
end
try ;    cd(s.workpath); end











%�����������������������������������������������
%%   twosampleTest
%�����������������������������������������������

function twosampleTest(e,e2,varargin)
global xvv
xvv.xtype='twosamplettest';
warning off;
readexcel(xvv.xtype);
fmakebatch(mfilename );

% disp('fun: twosampleTest');
% return;%*
% -------------------------
spmsetup;

hfig=findobj(0,'tag','vvstat');
s=get(hfig,'userdata');
try ;     cd(s.workpath); end

if isfield(s,'grp_comparison') && ~isempty(s.grp_comparison)
    groups=str2num(strrep(s.grp_comparison,'vs' ,' '));
    if isempty(groups) % explicit GROUP-name comparison , example 'AvsB' instead of '1vs2'
        gstr=strsplit(strrep(s.grp_comparison,' ','') ,'vs') ;
        groups=[ find(strcmp(s.classes,gstr{1}))  find(strcmp(s.classes,gstr{2}))];
    end
    
    g1=getfield(s,['grp_' num2str(groups(1))] );
    g2=getfield(s,['grp_' num2str(groups(2))] );
    if isempty(g1{1})==1;        g1={}; end
    if isempty(g2{1})==1;        g2={}; end
    groupLabels=[s.classes(groups(1)) s.classes(groups(2))];
    
    
else
    
    groupLabels=[s.classes(1) s.classes(2)]; 
    
end

outdir=s.output_dir;
try; delete(fullfile(outdir,'SPM.mat'));end
try; rmdir(outdir,'s'); end
mkdir(outdir);

% 
%remove xls-indicated subjects that have no data (path or volume)
g1=g1(~cellfun('isempty',g1));
g2=g2(~cellfun('isempty',g2));







mb{1}.spm.stats.factorial_design.dir ={outdir};% {'O:\data\voxelwise_Maritzen4tool\_test_results1\'};
%
mb{1}.spm.stats.factorial_design.des.t2.scans1 = g1;
% {
%                                                            'O:\data\voxelwise_Maritzen4tool\dat\20161215TM_M6590_neu\JD.nii'
%                                                            'O:\data\voxelwise_Maritzen4tool\dat\20170112TM_M6615\JD.nii'
%                                                            'O:\data\voxelwise_Maritzen4tool\dat\20170112TM_M7067\JD.nii'
%                                                            'O:\data\voxelwise_Maritzen4tool\dat\20170113TM_M7070\JD.nii'
%                                                            'O:\data\voxelwise_Maritzen4tool\dat\20170113TM_M7334\JD.nii'
%                                                            'O:\data\voxelwise_Maritzen4tool\dat\20170223TM_M9513\JD.nii'
%                                                            'O:\data\voxelwise_Maritzen4tool\dat\20170223TM_M9533\JD.nii'
%                                                            'O:\data\voxelwise_Maritzen4tool\dat\20170223TM_M9534\JD.nii'
%                                                            'O:\data\voxelwise_Maritzen4tool\dat\20170223TM_M9535\JD.nii'
%                                                            };
%
%
mb{1}.spm.stats.factorial_design.des.t2.scans2 = g2;
% {
%                                                            'O:\data\voxelwise_Maritzen4tool\dat\20161215TM_M6591\JD.nii'
%                                                            'O:\data\voxelwise_Maritzen4tool\dat\20170112TM_M6617\JD.nii'
%                                                            'O:\data\voxelwise_Maritzen4tool\dat\20170112TM_M7065\JD.nii'
%                                                            'O:\data\voxelwise_Maritzen4tool\dat\20170113TM_M7068\JD.nii'
%                                                            'O:\data\voxelwise_Maritzen4tool\dat\20170113TM_M7338\JD.nii'
%                                                            'O:\data\voxelwise_Maritzen4tool\dat\20170223TM_M9515\JD.nii'
%                                                            'O:\data\voxelwise_Maritzen4tool\dat\20170224TM_M9536_echte\JD.nii'
%                                                            'O:\data\voxelwise_Maritzen4tool\dat\20170224TM_M9536\JD.nii'
%                                                            'O:\data\voxelwise_Maritzen4tool\dat\20170224TM_M9539\JD.nii'
%                                                            };
%
mb{1}.spm.stats.factorial_design.des.t2.dept = 0;
mb{1}.spm.stats.factorial_design.des.t2.variance = 1;
mb{1}.spm.stats.factorial_design.des.t2.gmsca = 0;
mb{1}.spm.stats.factorial_design.des.t2.ancova = 0;
mb{1}.spm.stats.factorial_design.cov = struct('c', {}, 'cname', {}, 'iCFI', {}, 'iCC', {});
mb{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
mb{1}.spm.stats.factorial_design.masking.im = 1;
mb{1}.spm.stats.factorial_design.masking.em = {s.mask};% {'O:\data\voxelwise_Maritzen4tool\templates\AVGTmask.nii,1'};
mb{1}.spm.stats.factorial_design.globalc.g_omit = 1;
mb{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
mb{1}.spm.stats.factorial_design.globalm.glonorm = 1;

mb{2}.spm.stats.fmri_est.spmmat(1) = cfg_dep;
mb{2}.spm.stats.fmri_est.spmmat(1).tname = 'Select SPM.mat';
mb{2}.spm.stats.fmri_est.spmmat(1).tgt_spec{1}(1).name = 'filter';
mb{2}.spm.stats.fmri_est.spmmat(1).tgt_spec{1}(1).value = 'mat';
mb{2}.spm.stats.fmri_est.spmmat(1).tgt_spec{1}(2).name = 'strtype';
mb{2}.spm.stats.fmri_est.spmmat(1).tgt_spec{1}(2).value = 'e';
mb{2}.spm.stats.fmri_est.spmmat(1).sname = 'Factorial design specification: SPM.mat File';
mb{2}.spm.stats.fmri_est.spmmat(1).src_exbranch = substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1});
mb{2}.spm.stats.fmri_est.spmmat(1).src_output = substruct('.','spmmat');
mb{2}.spm.stats.fmri_est.method.Classical = 1;

mb{3}.spm.stats.con.spmmat(1) = cfg_dep;
mb{3}.spm.stats.con.spmmat(1).tname = 'Select SPM.mat';
mb{3}.spm.stats.con.spmmat(1).tgt_spec{1}(1).name = 'filter';
mb{3}.spm.stats.con.spmmat(1).tgt_spec{1}(1).value = 'mat';
mb{3}.spm.stats.con.spmmat(1).tgt_spec{1}(2).name = 'strtype';
mb{3}.spm.stats.con.spmmat(1).tgt_spec{1}(2).value = 'e';
mb{3}.spm.stats.con.spmmat(1).sname = 'Model estimation: SPM.mat File';
mb{3}.spm.stats.con.spmmat(1).src_exbranch = substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1});
mb{3}.spm.stats.con.spmmat(1).src_output = substruct('.','spmmat');
mb{3}.spm.stats.con.consess{1}.tcon.name = [ groupLabels{1} '>'  groupLabels{2}]  ;% ### 'grp1>grp2';
% mb{3}.spm.stats.con.consess{1}.tcon.name = [ s.classes{1} '>'   s.classes{2}]  ;% ### 'grp1>grp2';
mb{3}.spm.stats.con.consess{1}.tcon.convec = [1 -1];
mb{3}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
mb{3}.spm.stats.con.consess{2}.tcon.name = [ groupLabels{1} '<'   groupLabels{2}]  ;% ### 'grp1<grp2';
% mb{3}.spm.stats.con.consess{2}.tcon.name = [ s.classes{1} '<'   s.classes{2}]  ;% ### 'grp1<grp2';
mb{3}.spm.stats.con.consess{2}.tcon.convec = [-1 1];
mb{3}.spm.stats.con.consess{2}.tcon.sessrep = 'none';
mb{3}.spm.stats.con.delete = 0;

mb{4}.spm.stats.results.spmmat(1) = cfg_dep;
mb{4}.spm.stats.results.spmmat(1).tname = 'Select SPM.mat';
mb{4}.spm.stats.results.spmmat(1).tgt_spec{1}(1).name = 'filter';
mb{4}.spm.stats.results.spmmat(1).tgt_spec{1}(1).value = 'mat';
mb{4}.spm.stats.results.spmmat(1).tgt_spec{1}(2).name = 'strtype';
mb{4}.spm.stats.results.spmmat(1).tgt_spec{1}(2).value = 'e';
mb{4}.spm.stats.results.spmmat(1).sname = 'Contrast Manager: SPM.mat File';
mb{4}.spm.stats.results.spmmat(1).src_exbranch = substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1});
mb{4}.spm.stats.results.spmmat(1).src_output = substruct('.','spmmat');
mb{4}.spm.stats.results.conspec(1).titlestr =[ groupLabels{1} '>'   groupLabels{2}] ;%### 'grp1>grp2';
% mb{4}.spm.stats.results.conspec(1).titlestr =[ s.classes{1} '>'   s.classes{2}] ;%### 'grp1>grp2';
mb{4}.spm.stats.results.conspec(1).contrasts = 1;
mb{4}.spm.stats.results.conspec(1).threshdesc = 'FWE';
mb{4}.spm.stats.results.conspec(1).thresh = 0.05;
mb{4}.spm.stats.results.conspec(1).extent = 0;
mb{4}.spm.stats.results.conspec(1).mask = struct('contrasts', {}, 'thresh', {}, 'mtype', {});

mb{4}.spm.stats.results.conspec(2).titlestr =[ groupLabels{1} '<'   groupLabels{2}];% ### 'grp1<grp2';
% mb{4}.spm.stats.results.conspec(2).titlestr =[ s.classes{1} '<'   s.classes{2}];% ### 'grp1<grp2';
mb{4}.spm.stats.results.conspec(2).contrasts = 2;
mb{4}.spm.stats.results.conspec(2).threshdesc = 'FWE';
mb{4}.spm.stats.results.conspec(2).thresh = 0.05;
mb{4}.spm.stats.results.conspec(2).extent = 0;
mb{4}.spm.stats.results.conspec(2).mask = struct('contrasts', {}, 'thresh', {}, 'mtype', {});
mb{4}.spm.stats.results.units = 1;
mb{4}.spm.stats.results.print = false;


%% smoothing
% change [1] Data Smoothing [2]data for factDesignSpecif. [3] dependency-order
if s.smoothing==1
    try
        smoothfwhm=str2num(s.smoothing_fwhm);
    catch
        smoothfwhm=        (s.smoothing_fwhm);
    end
    ms={};
    ms{1}.spm.spatial.smooth.data = [g1;g2];
    ms{1}.spm.spatial.smooth.fwhm = smoothfwhm ;% [0.28 0.28 0.28];
    ms{1}.spm.spatial.smooth.dtype = 0;
    ms{1}.spm.spatial.smooth.im = 0;
    ms{1}.spm.spatial.smooth.prefix = 's';
    
    
    %change inputfiles to smoothed images
    mb{1}.spm.stats.factorial_design.des.t2.scans1 = stradd(g1,'s',1);
    mb{1}.spm.stats.factorial_design.des.t2.scans2 = stradd(g2,'s',1);
    
    mb=  [ms mb ]  ;% add smoothing job
    %% UPDATE dependency-order
    mb{3}.spm.stats.fmri_est.spmmat(1).src_exbranch   = substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1});
    mb{4}.spm.stats.con.spmmat(1).src_exbranch        = substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1});
    mb{5}.spm.stats.results.spmmat(1).src_exbranch    = substruct('.','val', '{}',{4}, '.','val', '{}',{1}, '.','val', '{}',{1});  
end




%..........................................
idmb=spm_jobman('interactive',mb);
matlabbatch=mb;
save(fullfile(outdir,'job'),'matlabbatch'); %SAVE BATCH
drawnow;

if xvv.x.showSPMbatch==0
    spm_jobman('run',mb);
end

try ;    cd(s.workpath); end


% hgfeval(get(gco,'ButtonDownFcn'),gco)






%�����������������������������������������������
%%  %% multiple regression
%�����������������������������������������������
function multipleregression(e,e2,varargin)
global xvv
xvv.xtype  = 'regression';
warning off;
readexcel(xvv.xtype);
fmakebatch(mfilename );


% disp('fun: multipleregression');
% return;%*
% -------------------------


spmsetup;
hfig=findobj(0,'tag','vvstat');
s=get(hfig,'userdata');
try ;     cd(s.workpath); end


g1        = s.grp_1;

outdir    = s.output_dir; 
rmdir(outdir,'s');
mkdir(outdir);

regressvec= cell2mat(s.d(:,2));
mask      = s.mask;



mb{1}.spm.stats.factorial_design.dir ={outdir};% {'O:\data\voxelwise_Maritzen4tool\regress_1'};
%%
mb{1}.spm.stats.factorial_design.des.mreg.scans = g1;
mb{1}.spm.stats.factorial_design.des.mreg.mcov.c = regressvec;
%%
mb{1}.spm.stats.factorial_design.des.mreg.mcov.cname = 'mycovar';
mb{1}.spm.stats.factorial_design.des.mreg.mcov.iCC = 1;
mb{1}.spm.stats.factorial_design.des.mreg.incint = 1;
mb{1}.spm.stats.factorial_design.cov = struct('c', {}, 'cname', {}, 'iCFI', {}, 'iCC', {});
mb{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
mb{1}.spm.stats.factorial_design.masking.im = 1;
mb{1}.spm.stats.factorial_design.masking.em ={mask};% {'O:\data\voxelwise_Maritzen4tool\templates\AVGTmask.nii'};
mb{1}.spm.stats.factorial_design.globalc.g_omit = 1;
mb{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
mb{1}.spm.stats.factorial_design.globalm.glonorm = 1;

mb{2}.spm.stats.fmri_est.spmmat(1) = cfg_dep;
mb{2}.spm.stats.fmri_est.spmmat(1).tname = 'Select SPM.mat';
mb{2}.spm.stats.fmri_est.spmmat(1).tgt_spec{1}(1).name = 'filter';
mb{2}.spm.stats.fmri_est.spmmat(1).tgt_spec{1}(1).value = 'mat';
mb{2}.spm.stats.fmri_est.spmmat(1).tgt_spec{1}(2).name = 'strtype';
mb{2}.spm.stats.fmri_est.spmmat(1).tgt_spec{1}(2).value = 'e';
mb{2}.spm.stats.fmri_est.spmmat(1).sname = 'Factorial design specification: SPM.mat File';
mb{2}.spm.stats.fmri_est.spmmat(1).src_exbranch = substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1});
mb{2}.spm.stats.fmri_est.spmmat(1).src_output = substruct('.','spmmat');
mb{2}.spm.stats.fmri_est.method.Classical = 1;

mb{3}.spm.stats.con.spmmat(1) = cfg_dep;
mb{3}.spm.stats.con.spmmat(1).tname = 'Select SPM.mat';
mb{3}.spm.stats.con.spmmat(1).tgt_spec{1}(1).name = 'filter';
mb{3}.spm.stats.con.spmmat(1).tgt_spec{1}(1).value = 'mat';
mb{3}.spm.stats.con.spmmat(1).tgt_spec{1}(2).name = 'strtype';
mb{3}.spm.stats.con.spmmat(1).tgt_spec{1}(2).value = 'e';
mb{3}.spm.stats.con.spmmat(1).sname = 'Model estimation: SPM.mat File';
mb{3}.spm.stats.con.spmmat(1).src_exbranch = substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1});
mb{3}.spm.stats.con.spmmat(1).src_output = substruct('.','spmmat');
mb{3}.spm.stats.con.consess{1}.tcon.name = 'pos';
mb{3}.spm.stats.con.consess{1}.tcon.convec = [0 1];
mb{3}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
mb{3}.spm.stats.con.consess{2}.tcon.name = 'neg';
mb{3}.spm.stats.con.consess{2}.tcon.convec = [0 -1];
mb{3}.spm.stats.con.consess{2}.tcon.sessrep = 'none';
mb{3}.spm.stats.con.delete = 0;

mb{4}.spm.stats.results.spmmat(1) = cfg_dep;
mb{4}.spm.stats.results.spmmat(1).tname = 'Select SPM.mat';
mb{4}.spm.stats.results.spmmat(1).tgt_spec{1}(1).name = 'filter';
mb{4}.spm.stats.results.spmmat(1).tgt_spec{1}(1).value = 'mat';
mb{4}.spm.stats.results.spmmat(1).tgt_spec{1}(2).name = 'strtype';
mb{4}.spm.stats.results.spmmat(1).tgt_spec{1}(2).value = 'e';
mb{4}.spm.stats.results.spmmat(1).sname = 'Contrast Manager: SPM.mat File';
mb{4}.spm.stats.results.spmmat(1).src_exbranch = substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1});
mb{4}.spm.stats.results.spmmat(1).src_output = substruct('.','spmmat');
mb{4}.spm.stats.results.conspec.titlestr = 'xdff';
mb{4}.spm.stats.results.conspec.contrasts = 1;
mb{4}.spm.stats.results.conspec.threshdesc = 'FWE';
mb{4}.spm.stats.results.conspec.thresh = 0.05;
mb{4}.spm.stats.results.conspec.extent = 0;
mb{4}.spm.stats.results.conspec.mask = struct('contrasts', {}, 'thresh', {}, 'mtype', {});
mb{4}.spm.stats.results.units = 1;
mb{4}.spm.stats.results.print = false;


%%  smoothing
if s.smoothing==1
    % change [1] Data Smoothing [2]data for factDesignSpecif. [3] dependency-order
    try
        smoothfwhm=str2num(s.smoothing_fwhm);
    catch
        smoothfwhm=        (s.smoothing_fwhm);
    end
    ms={};
    ms{1}.spm.spatial.smooth.data = [g1];
    ms{1}.spm.spatial.smooth.fwhm = smoothfwhm ;% [0.28 0.28 0.28];
    ms{1}.spm.spatial.smooth.dtype = 0;
    ms{1}.spm.spatial.smooth.im = 0;
    ms{1}.spm.spatial.smooth.prefix = 's';
    
    
    %change inputfiles to smoothed images
    mb{1}.spm.stats.factorial_design.des.mreg.scans = stradd(g1,'s',1);
    
    
    mb=  [ms mb ]  ;% add smoothing job
    %% UPDATE dependency-order
    mb{3}.spm.stats.fmri_est.spmmat(1).src_exbranch   = substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1});
    mb{4}.spm.stats.con.spmmat(1).src_exbranch        = substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1});
    mb{5}.spm.stats.results.spmmat(1).src_exbranch    = substruct('.','val', '{}',{4}, '.','val', '{}',{1}, '.','val', '{}',{1});
    
    %     mb{2}.spm.stats.fmri_est.spmmat(1).src_exbranch   = substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1});
    %     mb{3}.spm.stats.con.spmmat(1).src_exbranch        = substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1});
    %     mb{4}.spm.stats.results.spmmat(1).src_exbranch    = substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1});
    
end



%..........................................
idmb=spm_jobman('interactive',mb);
matlabbatch=mb;
save(fullfile(s.output_dir,'job'),'matlabbatch'); %SAVE BATCH
drawnow;

if xvv.x.showSPMbatch==0
    spm_jobman('run',mb);
end

try ;    cd(s.workpath); end


% global xvv
% % xmakebatch(z,p, mfilename);
% % hgfeval(get(gco,'ButtonDownFcn'),gco)




function fmakebatch(callingfile )
global xvv
x=xvv.x;
x.stattype = xvv.xtype;
x=orderfields(x,[length(fieldnames(x)) 1:length(fieldnames(x))-1]);
% xmakebatch(xvv.x ,  xvv.p   , mfilename);
p=[  {'stattype' '' 'STATISTICAL TEST' ''  } ;xvv.p ];
xmakebatch(x , p   , mfilename);


function loadothercontrast(e,e2,varargin)




try; xSPM=evalin('base','xSPM');catch; return; end
try; SPM=evalin('base','SPM'); catch; return; end



if ischar(e) && strcmp(e,'initialize')
    %% initialize
    e2=findobj(0,'tag','loadothercontrast');
    u.cons={SPM.xCon(:).name}';
    set(e2,'userdata',u);
    
    %thiscon=find(~cellfun('isempty',strfind(u.cons,xSPM.title)));
    thiscon=find(strcmp(u.cons,xSPM.title));
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
    
    
    [hReg,xSPM,SPM] = spm_results_ui('setup',  w);
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
%     thiscon=find(~cellfun('isempty',strfind(u.cons,xSPM.title)));
%     cons=u.cons;
%     cons{thiscon}=['<html><font color="green"><b>' u.cons{thiscon} '</font>'];
%     % web('text://<font color="green">This is some text!</font>')
%     set(findobj(0,'tag','loadothercontrast'),'string',[cons],'value',thiscon);
end


function loadspm(file)


xstat;

file=strrep(file,[filesep 'SPM.mat'],'');
file=fullfile(file,'SPM.mat');
loadSPMmatnoInput([],[],file);


function report(pptfile)


hg=findobj(0,'tag','vvstat');
lb=findobj(hg,'tag','loadothercontrast');

%% Start new presentation
isOpen  = exportToPPTX();
if ~isempty(isOpen),
    % If PowerPoint already started, then close first and then open a new one
    exportToPPTX('close');
end
exportToPPTX('new','Dimensions',[12 6], ...
    'Title','Example Presentation', ...
    'Author','MatLab', ...
    'Subject','Automatically generated PPTX file', ...
    'Comments','This file has been automatically generated by exportToPPTX');
% Additionally background color for all slides can be set as follows:
% exportToPPTX('new','BackgroundColor',[0.5 0.5 0.5]);
%% Add some slides
% figH = figure('Renderer','zbuffer'); mesh(peaks); view(0,0);
hfig= findobj(0,'tag','Graphics');
figH=hfig.Number;
for islide=1:size(get(lb,'string'),1)   %1:1,
    
    
    set(lb,'value',islide);
    hgfeval(get(lb,'callback'),lb);
    drawnow;
    %----------------------------
    
    slideNum = exportToPPTX('addslide');
    fprintf('Added slide %d\n',slideNum);
    exportToPPTX('addpicture',figH);
    exportToPPTX('addtext',sprintf('Slide Number %d',slideNum));
    exportToPPTX('addnote',sprintf('Notes data: slide number %d',slideNum));
    % Rotate mesh on each slide
%     view(18*islide,18*islide);
end
% close(figH)
%% Check current presentation
fileStats   = exportToPPTX('query');
if ~isempty(fileStats),
    fprintf('Presentation size: %f x %f\n',fileStats.dimensions);
    fprintf('Number of slides: %d\n',fileStats.numSlides);
end
%% Save presentation and close presentation -- overwrite file if it already exists
% Filename automatically checked for proper extension

if exist('pptfile')==0
    pptfile='result';
end

newFile = exportToPPTX('saveandclose',pptfile);
fprintf('New file has been saved: <a href="matlab:open(''%s'')">%s</a>\n',newFile,newFile);





function helphere(e,e2)

uhelp(mfilename,1);







%�����������������������������������������������
%%   COPYNPASTE INTO GUI
%�����������������������������������������������
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
x.grp_comparison='1vs2';	% groups to compare
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
