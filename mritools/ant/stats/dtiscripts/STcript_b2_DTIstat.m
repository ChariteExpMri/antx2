
%% <b> perform DTI-statistic for single DTI-matrices with different group-comparisons   </b>
% a DTI-matrix (csv-file) is tested for different subgroup-comparisons w.r.t. connection-strength 
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
% [csv_and_lut]: cell-array, with two columns:
%     column-1 '*.csv-file'
%     column-2 '*.lut-file'
%     accordingly each row contains a csf-file and its corresponding lut-file
% 
% [studyDir]  : dir of the study
% [groupDir]  : dir containing the group-assignment files (excel-files)
% [resultDir] : output directory for results
%               excel-files and calculation-files (*.mat) will be stored here
% [datDir]    : upper data-path containing connectivity files (csv)
% [groupfiles]: cell-array with group-comparison-files (excel-files)from
%               the "groupDir"-folder obtained via filename-prefix-filter
%     exampe:
%     groupfiles={  %defferent group-comparison-files
%         'gr01_g4__vs__g3.xlsx'
%         'gr02_g4__vs__g2.xlsx'
%         ..
%         'gr06_g2__vs__g1.xlsx'
%         };
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
    'connectome_di_sy.csv'          'atlas_lut.txt'
    };

studyDir  = 'H:\Daten-2\Imaging\AG_Harms\2021_Exp7_Exp8_Reinfarkte_jung\DTI'; %dir of the study
groupDir  = fullfile(studyDir,'group');         %dir containing the group-assignment files (excel-files)
resultDir = fullfile(studyDir,'DTIstat1');     %output directory
datDir    = fullfile(studyDir,'dat');           %upper data-path containing connectivity files (csv)

[groupfiles] = spm_select('List',groupDir,'^gr_');%obtain all group-comparison-files starting with 'gr'
groupfiles=cellstr(groupfiles);

%% ----not mandatory to modify-------------------------------
[dirs] = spm_select('FPList',datDir,'dir'); dirs=cellstr(dirs);
lutDir =dirs{1};  % 1st animal-directory is used to obtain the LUT-file



% ==============================================
%%   loop over "csv_and_lut"-rows
% ===============================================
for j=1:length(groupfiles)
    groupingfile = fullfile(groupDir, groupfiles{j} ); % % group-assignment File (Excel-file)
    
    
    for i=1:size(csv_and_lut,1)
        
        % ==============================================
        %%  loop-dependent changes
        % ===============================================
        cf; %close figure
        confiles= csv_and_lut{i,1};
        lutfile =fullfile(lutDir, csv_and_lut{i,2});
        
        % ==============================================
        %%   2) SET PARAMETER
        % ===============================================
        
        dtistat('set','inputsource','MRtrix' );
        dtistat('group', groupingfile);                        % % LOAD groupAssignment (ExcelFile)
        dtistat('conpath', datDir ,'confiles', confiles  ,'labelfile',lutfile); % % LOAD connectivity-Files & LUTfile
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