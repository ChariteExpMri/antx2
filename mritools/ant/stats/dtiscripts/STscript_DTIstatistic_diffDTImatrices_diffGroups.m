
%% <b> perform DTI-statistic for different DTI-matrices and different group-comparisons   </b>
% Here we test for different subgroup-comparisons and different DTI-matrices the connections
% 
% The DTI-matrices (CSV-files) can be created via [change mateix]-button
%  and could for instance contain different connections, or a subset of connections
% arbitrary example:
%     'eranet_connectome.csv'         : csv-file with all connections
%     'eranet_connectome_6vsAll.csv'  :subset of 6 regions agains all other regions
%     'eranet_connectome__3x3.csv'    : subset 6 regions agains the same 6 regions
% <b> <font color=blue> --> with this script we test this different matrices
% for different subgroups</font></b>
%
% 
% <b><u><font color=red> STEPS </font></u></b>
% 1) Define INPUTS
% 2) SET PARAMETER  (such as: t-test and FDR-correction)
% 3) CALCULATE AND SHOW RESULTS
% 4) SAVE CALCULATION AND EXPORT SIGNIFICANT RESULTS
% 5) EXPORT ALL RESULTS (ALSO NON-SIGNIFICANT RESULTS)
% 6) make PPT-summary
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
% [csv_and_lut] cell-array, with two columns:
%     column-1 '*.csv-file'
%     column-2 '*.lut-file'
%     accordingly each row contains a csf-file and its corresponding lut-file
%     see example
% [groupfiles]: cell-array with group-comparison-files (excel-files)
%     exampe:
%     groupfiles={  %defferent group-comparison-files
%         'gc_CTRL_VS_HR.xlsx'
%         'gc_CTRL_VS_LR.xlsx'
%         'gc_HR_VS_LR.xlsx'
%         };
% 
% [resultDir]: result folder, this folder will contain
%             -resulting excel-files and calculation-file (*.mat)
% [conpath]  : main-data path contaning the animal-folder with the DTI-MRtrix-result-files
% [lutpath]  : path where the lut-files are stored
% [grouppath]: path of the group-assignment files (listed in [groupfiles])
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
csv_and_lut={  % each row is a csv-file and its corresponding lut-file
    'eranet_connectome.csv'          'atlas_lut.txt'
    'eranet_connectome_6vsAll.csv'   'LUT_eranet_connectome_6vsAll.txt'
    'eranet_connectome__3x3.csv'     'LUT_eranet_connectome__3x3.txt'
    };
groupfiles={  %defferent group-comparison-files
    'gc_CTRL_VS_HR.xlsx'
    'gc_CTRL_VS_LR.xlsx'
    'gc_HR_VS_LR.xlsx'
    };

resultDir    = 'F:\data5\eranet_round2_statistic\DTI\result_test3'  ;% create folder for results (xls-files/mat-file)
conpath      = 'F:\data5\eranet_round2_statistic\DTI\dat'; % % upper path containing connectivity files (csv)
lutpath      = 'F:\data5\eranet_round2_statistic\DTI\dat\20200227PBS_ERANET_brain1042'; % % path of a single LUT-File
grouppath    = 'F:\data5\eranet_round2_statistic\DTI\groups' % path of the group-assignment files
% ==============================================
%%   loop over "csv_and_lut"-rows
% ===============================================
for j=1:length(groupfiles)
    groupingfile = fullfile(grouppath, groupfiles{j} ); % % group-assignment File (Excel-file)
    
    
    for i=1:size(csv_and_lut,1)
        
        % ==============================================
        %%  loop-dependent cahnges
        % ===============================================
        cf
        confiles= csv_and_lut{i,1};
        lutfile =fullfile(lutpath, csv_and_lut{i,2});
        
        % ==============================================
        %%   2) SET PARAMETER
        % ===============================================
        
        dtistat('set','inputsource','MRtrix' );
        dtistat('group', groupingfile);                        % % LOAD groupAssignment (ExcelFile)
        dtistat('conpath', conpath ,'confiles', confiles  ,'labelfile',lutfile); % % LOAD connectivity-Files & LUTfile
        dtistat('set','within',0,'test','ttest2','tail','both' );
        dtistat('set','FDR',1,'qFDR',0.05,'showsigsonly',1,'sort',1,'rc',0 );
        dtistat('set','nseeds',1000000,'propthresh',1,'thresh','max','log',1 );
        
        dtistat('set','propthresh',0); %proportional threshold
        % ==============================================
        %% 3) CALCULATE AND SHOW RESULTS
        %  [1] calc, [2] showresult,
        % ==============================================
        dtistat('calcconnectivity'); % % CALCULATION
        dtistat('showresult','ResultWindow',0);% update result. but do not show the result
        
        
        % ===============================================
        %% 4) SAVE CALCULATION AND EXPORT SIGNIFICANT RESULTS
        % ===============================================
        [~,ga_name ]=fileparts(groupingfile)    ; % get name of group-assignment-file
        [~,csv_name]=fileparts(csv_and_lut{i,1}); % get name of CSV-file
        
        nameout=[ csv_name '__' ga_name ];
        resultDir2=fullfile(resultDir,csv_name);
        
        dtistat('savecalc',fullfile(resultDir2,['calc_'    nameout '.mat']));  % %save calculation
        dtistat('export'  ,fullfile(resultDir2,['res_SIG_' nameout '.xlsx']),'exportType',1);  % %save Result as ExelFile
        
        % ==============================================
        %%  5) EXPORT ALL RESULTS (ALSO NOT SIGNIFICANT RESULTS)
        % ===============================================
        dtistat('set','showsigsonly',0); % show all results
        dtistat('showresult','ResultWindow',0);% update result. but do not show the result
        dtistat('export'  ,fullfile(resultDir2,['res_ALL_' nameout '.xlsx']),'exportType',1);  % %save Result as ExelFile
        
    end % i:csv-matrices
    
end% j:grouping-files

% ==============================================
%%  6) make PPT-summary
% ===============================================
for i=1:size(csv_and_lut,1)
    [~,csv_name]=fileparts(csv_and_lut{i,1}); % get name of CSV-file
    resultDir2=fullfile(resultDir,csv_name);
    xls2ppt(resultDir2,'^res_SIG_',2,fullfile(resultDir2,'summary.pptx'),'append',0);
end
