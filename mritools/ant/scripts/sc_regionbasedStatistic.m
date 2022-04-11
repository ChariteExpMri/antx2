% <b> perform region-based statistic (twp-sample t-test) , simple   </b>          
% <font color=fuchsia><u>description:</u></font> 
% performs a region-based statistic 
% - region-based statistic can be performed after running "getanatomical labels" over a number of animals
% - the excelfile "rw_t2.xlsx" contains the regions-based parameters (volume, mean, etc) which is used as input
% - here we are interested in the volume of each region, thus the sheet "vol" is used (v.dataSheet='vol') 
%   ...not that in the previous step ("getanatomical labels") the volume was extracted from an image in native space 
% - a group-assignment file is necessary containing the animal IDs (names) and the assigned group 
% - Here the group assignment file is 'group_assignment_24feb22.xlsx'
%    - . This Excelfile contains two columns (1st row serves as header)
%        - a column specifying the animals (animal-IDs)  ...same name as in the ANT animal-listbox
%        - a column specifying which animal belongs to which group (for example defind as 'control'/'stim')
%   
%         'animal'                          'groupName'
%         '20200310PBS_ERANET_brain1062'    'LR'
%         '20200312PBS_ERANET_brain1067'    'LR'
%         ..                                ..
%         '20200305PBS_ERANET_brain1050'    'LR'
%         '20200227PBS_ERANET_brain1042'     'HR'
%         '20200309PBS_ERANET_brain1061'     'HR'
%         ..                                ..
%         '20200310PBS_ERANET_brain1044'     'HR'
% 
% - the columns for animalID and assigned-groups are specified via 'v.id' 'v.f1'
% - here we use a two-sample ttest (v.typeoftest1='ttest2') and test both tails/two-sided (v.tail='both')
% - The FDR-q-level is set to 0.05 (v.qFDR=0.05) and is used (v.isfdr=1)
% - Only the significant, i.e. FDR-survived (v.showsigsonly=1), regions will be displayed in a sorted (v.issort=1) 
%  order
% - to set all paramters we run: xstatlabels(v);  
% - to caluclate the statistics we run: xstatlabels('run');
% - optional-1 create an excelfile containing only regions with significant results ; xstatlabels('export','file',fullfile(pwd,'_res_SIG_rw_t2.xlsx'),'sigonly',1)
% - optional-2 create an excelfile containing the results for all regions           ; xstatlabels('export','file',fullfile(pwd,'_res_All_rw_t2.xlsx'),'sigonly',0);
% 
%% ________________________________________________________________________________________________


% #by [xstatlabels.m] 
v = [];
v.data         =  'F:\data5\eranet_round2_statistic\regionwise\rw_t2.xlsx';                    % % excel data file
v.dataSheet    =  'vol';                                                                       % % sheetname of excel data file
v.aux          =  'F:\data5\eranet_round2_statistic\regionwise\group_assignment_24feb22.xlsx'; % % excel group assignment file
v.auxSheet     =  'group';                                                                     % % sheetname of excel group assignment file
v.id           =  'animal';                                                                    % % name of the column containing the animal-id in the auxSheet
v.f1           =  'groupName';                                                                 % % name of the column containing the group-assignment in the auxSheet
v.f1design     =  [0];                                                                         % % type of test: [0]between, [1]within
v.typeoftest1  =  'ttest2';                                                                    % % applied  statistical test (such as "ranksum" or "ttest2")
v.tail         =  'both';                                                                      % %  Type of alternative hypothesis: both|left|right 
v.regionsfile  =  '';                                                                          % % optional excelfile containing regions, only this regions will be tested
v.qFDR         =  [0.05];                                                                      % % q-threshold of FDR-correction (default: 0.05)
v.isfdr        =  [1];                                                                         % % use FDR correction: [0]no, [1]yes
v.showsigsonly =  [1];                                                                         % % show significant results only:  [0]no, show all, [1]yes, show signif. results only
v.issort       =  [1];                                                                         % % sort results according the p-value: [0]no, [1]yes,sort 
xstatlabels(v);      % % SET all Parameter   
xstatlabels('run');  % % RUN statistic
 
% % OPTTIONAL: export results as excelfile:
xstatlabels('export','file',fullfile(pwd,'_res_SIG_rw_t2.xlsx'),'sigonly',1); % % Export excelfile;significant regions only (enter proper filename for "_res_SIG_rw_t2.xlsx") 
xstatlabels('export','file',fullfile(pwd,'_res_All_rw_t2.xlsx'),'sigonly',0); % % Export excelfile;all regions (enter proper filename for "_res_ALL_rw_t2.xlsx") 






