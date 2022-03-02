
%% <b> simple script to perform DTI-statistic   </b>
% <b><u><font color=red> STEPS </font></u></b>
% 1) Define INPUTS
% 2) SET PARAMETER  (such as: t-test and FDR-correction)
% 3) CALCULATE AND SHOW RESULTS
% 4) SAVE CALCULATION AND EXPORT SIGNIFICANT RESULTS
% 5) EXPORT ALL RESULTS (ALSO NON-SIGNIFICANT RESULTS) 
% 
% <b><u><font color=red> OUTPUT </font></u></b>
% - calculation of the statistic (*.mat-file)...(can be reloaded )
% - statistical results exported as excel-file(s)
% 
% -<b><font color=blue> 
% =================================================================
% 'This script requires the following inputs
% =================================================================
% <pre>
% [groupingfile] a group-assignment file (excel-file, see below) 
%  -this file contains the groups that should be compared
% [conpath]: main-data path contaning the animal-folder with the DTI-MRtrix-result-files
% [confile]: the short csv-file-name as priveded by MRtrix-DTI-pipeline
%   -use file name without paht
%   -example "eranet_connectome.csv"
% [lutfile]: the atlas-region-file (LUT-file, a "txt"-file; (fullpath-name)
%   -use fullpath-name:
%   -example: 'F:\data5\eranet_round2_statistic\DTI\dat\20200227PBS_ERANET_brain1042\atlas_lut.txt'
% [resultDir]: result folder, this folder will contain
%             -resulting excel-files and calculation-file (*.mat)
% </pre>
% -<b><font color=green> 
% =================================================================
% 'EXAMPLE-INPUT: group-assignment excel-file
% =================================================================
% <pre>
% -this is an excelfile with a sheet containing two rows:
% column-1: animal-IDs (names) as used in the dat-folder
%           (containing the DTI-data)
% column-2: -group-assignment (numeric or char) names
%          -splitting the sample into two subgroups (here: CTRL and LR)
%          
% example-content of the excel-sheet:
% 
%         NAMES                        GROUPS
%         20210723PBS_ERANET_165_LR      LR
%         20210713PBS_ERANET_151_LR      LR
%         20210725_PBS_ERANET_409_CTRL   LR
%         20210726PBS_ERANET_279_HR      LR 
%         20210720PBS_ERANET_301_HR      CTRL
%         20210727PBS_ERANET_410_CTRL    CTRL
%         ..                             ..
%         20210818PBS_ERANET_413_CTRL   CTRL



clear; warning off
% ==============================================
%%  1) Define INPUTS
% ===============================================
resultDir    ='F:\data5\eranet_round2_statistic\DTI\result_test'  ;% create folder for results (xls-files/mat-file)
 
groupingfile = 'F:\data5\eranet_round2_statistic\DTI\groups\gc_CTRL_VS_LR.xlsx'; % % group-assignment File (Excel-file) 
 
conpath      = 'F:\data5\eranet_round2_statistic\DTI\dat'; % % upper path containing connectivity files (csv)
confiles     = 'eranet_connectome.csv'; % % short-name of the connectivity file (csv)
lutfile      = 'F:\data5\eranet_round2_statistic\DTI\dat\20200227PBS_ERANET_brain1042\atlas_lut.txt'; % % LUT-File (txt-file) 

% ==============================================
%%   2) SET PARAMETER
% ===============================================

dtistat('set','inputsource','MRtrix' );
dtistat('group', groupingfile);                        % % LOAD groupAssignment (ExcelFile)
dtistat('conpath', conpath ,'confiles', confiles  ,'labelfile',lutfile); % % LOAD connectivity-Files & LUTfile
dtistat('set','within',0,'test','ttest2','tail','both' );
dtistat('set','FDR',1,'qFDR',0.05,'showsigsonly',1,'sort',1,'rc',0 );
dtistat('set','nseeds',1000000,'propthresh',1,'thresh','max','log',1 );
 
% ==============================================
%% 3) CALCULATE AND SHOW RESULTS
%  [1] calc, [2] showresult, 
% ==============================================
dtistat('calcconnectivity'); % % CALCULATION (uncomment line to execute) 
dtistat('showresult');       % % SHOW RESULT (uncomment line to execute) 


% ===============================================
%% 4) SAVE CALCULATION AND EXPORT SIGNIFICANT RESULTS
% ===============================================
[~,xlsname]=fileparts(groupingfile); % get group-assignment-file

dtistat('savecalc',fullfile(resultDir,['calc_'    xlsname '.mat']));  % %save calculation
dtistat('export'  ,fullfile(resultDir,['res_SIG_' xlsname '.xlsx']),'exportType',1);  % %save Result as ExelFile

% ==============================================
%%  5) EXPORT ALL RESULTS (ALSO NOT SIGNIFICANT RESULTS) 
% ===============================================
dtistat('set','showsigsonly',0); % show all results
dtistat('showresult','ResultWindow',0);% update result. but do not show the result
dtistat('export'  ,fullfile(resultDir,['res_ALL_' xlsname '.xlsx']),'exportType',1);  % %save Result as ExelFile



