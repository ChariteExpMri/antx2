
%% <b> simple script to perform DTI-statistic, change proportional threshold   </b>
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
% propportthresh -set proportional Treshold: change here either 0 or 1 [0/1]
%                -default: 0
% outdirsub      -name of the output-dubdirectory (this folder will contain the results)
%                -here constructed from status of the "propportthresh"-variable
%                
% pastudy        -path of the study
%                -this folder contains the "dat"-folder (data) and all necessary stuff
%      
% resultDir    -fullpath output-directory             % create folder for results (xls-files/mat-file)
%              -here: fullfile(pastudy, 'result_DTI' ,outdirsub)  ;
% 
% groupingfile -fullpath name of the grouping file
%              -here created via : fullfile(pastudy, 'groupassignment_Ghost3.xlsx'); % % group-assignment File (Excel-file) 
%  
% conpath      -fullpath to the dat-folder         % % main data path containing connectivity files (csv)
%              -here: fullfile(pastudy, 'dat');    
% 
% confiles     -short name of the csv-file (Mrtrix-generated connection-file)   % % short-name of the connectivity file (csv)
%              -here: 'connectome_di_sy.csv';     
%              
% lutfile      -fullpath file-name to one of the lut-files (the file containing the conection-labels) % % LUT-File (txt-file) 
%              -here: fullfile(pastudy, 'dat', '20210819HPR_089236', 'mrtrix', 'atlas_lut.txt');
% 
% 
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
%% ===============================================



clear; warning off


% ==============================================
%%  1) Define INPUTS
% ===============================================
propportthresh =0; %using proportional Treshold [0/1]

outdirsub      =['propTR' num2str(propportthresh)];
pastudy        ='X:\Daten-2\Imaging\AG_Pruess\MRI_Ghost3_Aug2021\DTI' ;%studyPath

resultDir    =fullfile(pastudy, 'result_DTI' ,outdirsub)  ;% create folder for results (xls-files/mat-file)
groupingfile = fullfile(pastudy, 'groupassignment_Ghost3.xlsx'); % % group-assignment File (Excel-file) 
 
conpath      = fullfile(pastudy, 'dat');     % % upper path containing connectivity files (csv)
confiles     = 'connectome_di_sy.csv';       % % short-name of the connectivity file (csv)
lutfile      = fullfile(pastudy, 'dat', '20210819HPR_089236', 'mrtrix', 'atlas_lut.txt'); % % LUT-File (txt-file) 

% ==============================================
%%   2) SET PARAMETER
% ===============================================

dtistat('set','inputsource','MRtrix' );
dtistat('group', groupingfile);                        % % LOAD groupAssignment (ExcelFile)
dtistat('conpath', conpath ,'confiles', confiles  ,'labelfile',lutfile); % % LOAD connectivity-Files & LUTfile
dtistat('set','within',0,'test','ttest2','tail','both' );
dtistat('set','FDR',1,'qFDR',0.05,'showsigsonly',1,'sort',1,'rc',0 );
dtistat('set','nseeds',1000000,'propthresh',1,'thresh','max','log',1 );
 
dtistat('set','propthresh',propportthresh); %ser defined proportional Threshold
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


