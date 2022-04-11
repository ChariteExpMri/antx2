% <b> perform region-based statistic for several images (twp-sample t-test)  using ROIs   </b>          
% <font color=fuchsia><u>description:</u></font> 
% performs a region-based statistic using several images and ROIs
% - statistically test the "mean"-parameter (mean intensity of a region) between groups for several images
% <font color=blue><b>here we use ROIs, i.e. a subselecton of regions defined in a regionfile:</b></font> 
%  - The regionfile is in its simplest form an excelfile containing only one column with regions to analyze
%    a header is mandatory, name of the header is arbitrary
%       _____________[content of the region-file excelfile]__________
%             'ROIS'
%             'R_Amygdalopiriform_Cortex_MODIF'
%             'L_Amygdalopiriform_Cortex_MODIF'
%             'L_Subiculum_MODIF'
%             'R_Subiculum_MODIF'
%             'R_Secondary_Cingular_Cortex_MODIF'
%             'L_Secondary_Cingular_Cortex_MODIF'
%       _________________________________________________
% 
% - region-based statistic can be performed after running "getanatomical labels" over a number of animals and images
% - the Excelfiles 'rw_ad.xlsx', 'rw_adc.xlsx', 'rw_fa.xlsx', 'rw_rd.xlsx' and 'rw_c1t2.xlsx' 
%     - were created using "getanatomical labels" in a previous step
%     - contain regions-based parameters (volume, mean, etc) 
% - here we are interested in the "mean"-parameter of each region, thus the sheet "mean" is used (v.dataSheet='mean') 
%   ...note that in the previous step ("getanatomical labels") the volume was extracted from images in native space 
% - a group-assignment file is necessary containing the animal IDs (names) and the assigned group 
% - in this example the group assignment file is 'group_assignment_24feb22.xlsx' 
%    - this Excelfile contains two columns where the 1st row is the header (header is mandatory)
%        - a column specifying the animals (animal-IDs)  ...same name as in the ANT animal-listbox
%        - a column specifying which animal belongs to which group (for example defined as 'control' vs 'stim')
%        - here we have three groups: 'LR','HR' and 'CTRL':
%       _____________[content of the group-assignment excelfile]__________
%         'animal'                          'groupName'    
%         '20200310PBS_ERANET_brain1062'    'LR'
%         '20200312PBS_ERANET_brain1067'    'LR'
%         ..                                ..
%         '20200305PBS_ERANET_brain1050'    'LR'
%         '20200227PBS_ERANET_brain1042'    'HR'
%         '20200309PBS_ERANET_brain1061'    'HR'
%         ..                                ..
%         '20200310PBS_ERANET_brain1044'    'HR'
%         '20210716PBS_ERANET_404_CTRL'     'CTRL'     
%         '20210717PBS_ERANET_405_CTRL'     'CTRL' 
%         ..                                ...
%         '20210719PBS_ERANET_406_CTRL'     'CTRL' 
%         ..
%       _________________________________________________
% - internally, the parameter of each region ("mean") is statistically compared between all pairwise groups: 
%       'CTRL' vs 'HR', 'CTRL' vs 'LR' and 'HR' vs 'LR'
% - the columns for animalID and assigned-groups are specified via 'v.id' 'v.f1'
% - here we use a two-sample ttest (v.typeoftest1='ttest2') and test both tails/two-sided (v.tail='both')
% - The FDR-q-level is set to 0.05 (v.qFDR=0.05) and is used (v.isfdr=1)
% - Only the significant, i.e. FDR-survived (v.showsigsonly=1), regions will be displayed in a sorted (v.issort=1) 
%  order
% - to set all paramters we run: xstatlabels(v);  
% - to caluclate the statistics we run: xstatlabels('run');
% - optionally the resulting statistics are exported as excelfiles:
%    - first we create an output filenname token : nameouttok=['_' fname '__' statistic];
%    - than we export the statistics: two excelfiles are created containing only the significant results and 
%      the results for all regions, respectively:
%        xstatlabels('export','file',fullfile(pwd,['statSIG_' nameouttok '.xlsx']),'sigonly',1); % % Export excelfile;significant regions only (enter proper filename for "_res_SIG_rw_t2.xlsx")
%        xstatlabels('export','file',fullfile(pwd,['statAll_' nameouttok '.xlsx']),'sigonly',0); % % Export excelfile;all regions (enter proper filename for "_res_ALL_rw_t2.xlsx")
% 


% ============================================================================================
%%  using several images and investigate the "mean"-parameter (mean intensity of a region)
% =============================================================================================
% [1]  path of the excelfiles
pain='F:\data5\eranet_round2_statistic\regionwise' ;%input-path

% [2] excelfiles containing the region-based parameters (from getanatomical labels)
excelfiles={ 'rw_ad.xlsx'  'rw_adc.xlsx'   'rw_fa.xlsx'  'rw_rd.xlsx' 'rw_c1t2.xlsx'  };
excelfilesFP= cellfun(@(a){[ pain,filesep a]} ,excelfiles)' ;%fullpath_excelfiles

% [3] group-assignment file (with animal-names and group assignment)
groupfile ='F:\data5\eranet_round2_statistic\regionwise\group_assignment_24feb22.xlsx';

% [4] regionfile, describing which regions should be analyzed 
regionfile='F:\data5\eranet_round2_statistic\regionwise\selectedRegions.xlsx';

% [5] output-path for the resulting excelfiles
paout=pain; %same as input path

% [6] 
statistic='ttest2'; % used statistic

% loop over excelsheets
for i=1:length(excelfilesFP)
    [~,fname]=fileparts(excelfilesFP{i});
    cf ;% close all figures
    v = [];      % % empty struct
    v.data         =  excelfilesFP{i};   % % excel data file
    v.dataSheet    =  'mean';            % % sheetname of excel data file
    v.aux          =  groupfile          % % excel group assignment file
    v.auxSheet     =  'group';           % % sheetname of excel group assignment file
    v.id           =  'animal';          % % name of the column containing the animal-id in the auxSheet
    v.f1           =  'groupName';       % % name of the column containing the group-assignment in the auxSheet
    v.f1design     =  [0];               % % type of test: [0]between, [1]within
    v.typeoftest1  =  statistic;         % % applied  statistical test (such as "ranksum" or "ttest2")
    v.tail         =  'both';            % %  Type of alternative hypothesis: both|left|right
    v.regionsfile  =  regionfile;        % % optional excelfile containing regions, only this regions will be tested
    v.qFDR         =  [0.05];            % % q-threshold of FDR-correction (default: 0.05)
    v.isfdr        =  [1];               % % use FDR correction: [0]no, [1]yes
    v.showsigsonly =  [1];               % % show significant results only:  [0]no, show all, [1]yes, show signif. results only
    v.issort       =  [1];               % % sort results according the p-value: [0]no, [1]yes,sort
    xstatlabels(v);      % % SET all Parameter
    xstatlabels('run');  % % RUN statistic
    
    % % OPTTIONAL: export results as excelfile:
    nameouttok=['_' fname '__' statistic]; %output filename token
    xstatlabels('export','file',fullfile(pwd,['statROI_SIG_'     nameouttok '.xlsx']),'sigonly',1); % % Export excelfile;significant regions only (enter proper filename for "_res_SIG_rw_t2.xlsx")
    xstatlabels('export','file',fullfile(pwd,['statROI_statAll_' nameouttok '.xlsx']),'sigonly',0); % % Export excelfile;all regions (enter proper filename for "_res_ALL_rw_t2.xlsx")
end






