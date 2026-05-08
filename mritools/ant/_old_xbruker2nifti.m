%% #b convert brukerData to nifti-data
%
%% function xbruker2nifti(pain,sequence,trmb)
%% INPUT
% pain  : bruker-Metafolder, this folder contains all mouseFolder (! do not specify  a specific
%         mouseFolder here),
%        OPTIONS for pain  :
%            bruker_metapath        % this is the Bruker-Raw-metafolder <no GUI>
%            []                     % opens a dialog box, the starting folder is the current Dir
%            {'guidir' start_path } % opens a dialog box with the starting folder specified by start_path
%  sequence: which sequence to read  (number, string or empty)
%           [0] all sequences, [1] RARE,  [2] FLASH,  [3] FISP
%           other sequence can be coded as string, (n.b. sequence= 'RARE' is equal to sequence=1)
%                    (case sensitivity (lower/opper letters) is ignored)
%           []        % read all data
%  trmb: filesize lower threshold in mbyte-->ignore files with lower filesize
%            []      : trmb is set to 1 (=0Mb,predefined)
%% examples
% xbruker2nifti;                                                % all inputs provided by guis
% xbruker2nifti( 'O:\harms1\harmsTest_ANT\pvraw', 'Rare' )      % METAFOLDER is explicitly defined, read Rare, trmb is 1Mb
% xbruker2nifti({'guidir' 'O:\harms1\harmsTest_ANT\'}, 'Rare' ) % startfolder for GUI is defined,  read Rare, trmb is 1Mb
%% ===============================================
%% output
% if specified, the output (struct) contains the following fields (after conversion):
%          hd: header of 'd', columnnames  {cell}
%           d: data-array, each row represent a Bruker raw-data file with parameters {cell}
%         raw: raw data file, fullpath {cell}
%       nifti: converted nifti-files {cell}
%     success: success of conversion, bool-array,  [double]
%      errmsg: error messages for failed conversion {cell}
%% ===============================================
%% OPTIONAL PAIRWISE INPUT ARGUMENTS
% gui: [0/1] : [1]show [0]hide gui (fileselection+parameter specification)
% show: [0/1/2]: display files, if show is [1] or [2] no files are converted, only displayed
%         [1]: display files in cmd-window
%         [2]: display files in extra window
% paout: output-path for converted files
%       - if not specified the dat-folder of the loaded ANT-project is used. For this, the
%         ANT-project must be loaded
%       - otherwise specify a fullpath folder
%
% first - n, numeric number; for testing purpose , convert only the first n-files
%        - example to convert only the first two files: ..,'first',2,..
% set   - the set-number to display or import
%        -example: 'set',[ 1 3 5]  -->  display or import sets 1,3, and 5
%        -         'set','all'     -->  display or import all sets (same as is 'set' is not specified)
%
% prefix: -(string), add a prefix string to the converted NIFTI-filenames
% suffix: -(string), add a suffix string to the converted NIFTI-filenames
% flt   : filter option
%        - if empty ( '' ,[],{''} ) show all files  , example :   .. 'flt','',..
%        - otherwise a cell with pairwise inputs: abbreviation of column-name (ACN) and search string (SS)
%          in this case the searchstring is searched in the data of the respective column
%        - filters can be combined using : {ACN,SS,ACN,SS,...ACN,SS}:
%          example: all files from set 2,3,5,6,7,8 with string 'RARE' or 'FISP' in protocol-name
%                    .. 'flt',{'set' [2 3 5:8] 'pro','RARE|FISP'}
%                  'flt',{'protocol','Loc|DTI'}    ..show/import all files where protocol-Names contain 'Loc'
%                   or 'DTI'
% overwrite -[0,1]; default:[1] overwrite all files, [0] write only nonexisting files ...use with caution!
%
% ==========================================================
%% NO GUI (silent mode)
%
%=============[IMPORT ALL FILES]================
% [1] import all Bruker-rawdata from path fullfile(pwd,'raw_Ernst'), no gui (silent mode)
% xbruker2nifti(fullfile(pwd,'raw_Ernst'),0,[],[],'gui',0);
%
% [2] import all data to a specific directory (paout), no GUI
% xbruker2nifti(fullfile(pwd,'raw_Ernst'),0,[],[],'gui',0,'paout',fullfile(pwd,'dat2'));
%
% ===========[DISPLAY ONLY] ===================================
%% just display the BRUKERDATA (no DATA-import!) in CMD-WINDOW
% xbruker2nifti(fullfile(pwd,'raw_Ernst'),0,[],[],'show',1);
%% just display the BRUKERDATA (no DATA-import!) in extra-WINDOW
% xbruker2nifti(fullfile(pwd,'raw_Ernst'),0,[],[],'show',2);
%
% ===========[FILTER] ===================================
%% import specific files via filter ("flt"+cell)
% 'flt', {columnName   string}
% columnName: short name of the column to address:
%    AVAILABLE COLUMNS:
%     'set'     'SubjectId'  'StudNo'  'ExpNo'  'PrcNo'        'MRseq'   'protocol'
%     'sizeMB'  'date'       'file'    'StudId'  'SubjectName' 'CoreDim'
%     --> example 'si' for 'sizeMB'; 'pro' for 'protocol'
% string: string to find in columnName
%
% flt-options-snips-example
% {'pro'    'RARE'}  import all file with string 'RARE' in protocol-column
% {'pro'    'T2'}    import all file with string 'T2' in protocol-column
% {'pro'    'T2|DTI_EPI'} import all files with string T2 or DTI_EPI in protocol-column
% {'pro'    '^T2|^DTI_EPI'}  import all files starting with string T2 or DTI_EPI in protocol-column
% {'date'    '2020'}  import all files from 2020 (date-column)
% {'date'    'Jun-2021'} import all files from Jun-2020 (date-column)
% {'date'    '2020|2021'} import all files 2020 or 2021 (date-column)
% {'MR'    'Fisp|Rare'} import all files with string Fisp or Rare in 'MR'-column
% {'si'    '>20'} import all larger than 20MB (sizeMB-column)
% {'si'    '<20'}  import all below 20MB (sizeMB-column)
% {'si'    '>20 & <30'} import all between 20MB and 30MB (sizeMB-column)
% flt-options-EXAMPLES:
% xbruker2nifti(fullfile(pwd,'raw_Ernst'),0,[],[],'gui',0,'paout',fullfile(pwd,'dat2'),'flt',{'pro' 'RARE'}); % import only files with "RARE" from protocol-column
% xbruker2nifti(fullfile(pwd,'raw_Ernst'),0,[],[],'gui',0,'paout',fullfile(pwd,'dat2'),'flt',{'si' '>20 & <30'});% import all between 20MB and 30MB (sizeMB-column)
%
% -to obtain the table WITHOUT data-import just type (with your raw-data-path):
% xbruker2nifti(fullfile(pwd,'raw_Ernst'),0,[],[],'show',1)
% -se also "BRUKER DATA EXAMPLE-TABLE" below
%
%%  filter: import all files from sets (datasets) 1 and 2
% xbruker2nifti(fullfile(pwd,'raw_mix'),0,[],[],'gui',0,'show',1,'paout',fullfile(pwd,'dat'),'flt',{'set',1:2});
%
% ===========[MULTI-FILTER] ===================================
% combine filter options (pairwise: abbreviation of column & search string,abbreviation of column & search string... )
%% multi-filter: from sets 2 and 3 only, import all files with protocol RARE or FISP
% xbruker2nifti(fullfile(pwd,'raw_mix'),0,[],[],'gui',0,'show',1,'paout',fullfile(pwd,'dat'),'flt',{'set' '2|3' 'pro','RARE|FISP'});
%
%% multi-filter: from sets 1 and 2 only, import all files with size >2MB
% xbruker2nifti(fullfile(pwd,'raw_mix'),0,[],[],'gui',0,'show',1,'paout',fullfile(pwd,'dat'),'flt',{'set',1:2,'si','>2'});
%
%% multi-filter: from sets 2 and 3 only, import all files with protocol RARE or FISP and size >0.1MB
% xbruker2nifti(fullfile(pwd,'raw_mix'),0,[],[],'gui',0,'show',1,'paout',fullfile(pwd,'dat'),'flt',{'set' 2:3,'pro' 'RARE|FISP','si' '>0.1'});
%
%% multi-filter: from sets 1,2,3 only, import all files with protocol RARE or FISP and size >0.001MB and date 2021 or 2022
% xbruker2nifti(fullfile(pwd,'raw_mix'),0,[],[],'gui',0,'show',1,'paout',fullfile(pwd,'dat'),'flt',{'set' 1:3,'pro' 'RARE|FISP','si' '>0.001','dat','2021|2022'});
%
%%  adding prefix- and/or suffix-string to output data-filenames
% xbruker2nifti(fullfile(pwd,'raw_mix'),0,[],[],'gui',0,'show',1,'paout',fullfile(pwd,'dat'),'prefix','MOS_');
% xbruker2nifti(fullfile(pwd,'raw_mix'),0,[],[],'gui',0,'show',1,'paout',fullfile(pwd,'dat'),'suffix','_MOS');
% xbruker2nifti(fullfile(pwd,'raw_mix'),0,[],[],'gui',0,'show',1,'paout',fullfile(pwd,'dat'),'prefix','MOS_','suffix','_MOS');
%
%
% ===========[EXAMPLE FILTER DTI-data] ===================================
% show only DTI-filtered files (no data import):
% xbruker2nifti(fullfile(pwd,'raw'),0,[],[],'gui',0,'show',1,'flt',{'pro' 'DTI_EPI_seg_b'});
% import DTI-filtered files
% xbruker2nifti(fullfile(pwd,'raw'),0,[],[],'gui',0,'paout',fullfile(pwd,'dat'),'flt',{'pro' 'DTI_EPI_seg_b'});
% import DTI-filtered files, open GUI with preselected DTI-files
% xbruker2nifti(fullfile(pwd,'raw'),0,[],[],'gui',1,'paout',fullfile(pwd,'dat'),'flt',{'pro' 'DTI_EPI_seg_b'});
%
% ==============================================
%%   LARGE DATA (MANY BRUKER RAW DATA FILES)
% ===============================================
% In case of many Bruker raw data files the loading time could be long.
% In this case, one can first read all raw-dara files to a struct (output argument of 'xbruker2nifti.m')
% and with a 2nd/3rd.. call select specifc files (to import). For this the struct is parsed as 1st input
% argument to 'xbruker2nifti.m'
% example:
% FIRST READ ALL DATA TO STRUCT "w1"
% [1] first read all raw-data and output as struct "w1"
% w1=xbruker2nifti(fullfile(pwd,'raw_mix'),0,[],[],'gui',0,'show',1,'paout',fullfile(pwd,'dat'),'flt',{''});
% -use w1.showtable(w1)  to see table in cmd-window
% -use w1.showtable2(w1) to see table in extra window
% [2a] show all files with 'FISP' or 'FLASH' in 'MR' (MRseq)
% w2=xbruker2nifti(w1,0,[],[],'gui',0,'show',1,'flt',{'MRs','FISP|FLASH'});
% ..to display the data use w2.showtable(w2) or w2.showtable2(w2)
%
% [3a] convert all files with 'FISP' or 'FLASH' in 'MR' (MRseq) to 'dat4'-folder
% w2=xbruker2nifti(w1,0,[],[],'gui',0,'show',0,'flt',{'MRs','FISP|FLASH'},'paout',fullfile(pwd,'dat4'));
%
% [3b] convert all files SELECTED VIA INTACTIVE GUI ('paout' is a test output-folder)
% w2=xbruker2nifti(w1,0,[],[],'gui',1,'show',0,'paout',fullfile(pwd,'dat4'))
%
% [3c] convert first-two files with 'RARE' in 'MR' (MRseq) to 'dat4'-folder  ("first" is for testing purpose)
% w2=xbruker2nifti(w1,0,[],[],'gui',0,'show',0,'flt',{'MRs','RARE'},'paout',fullfile(pwd,'dat4'),'first',2);
%
%
%
% ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
%    EXAMPLE  BRUKER DATA-TABLE
% ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
% set SubjectId                      StudNo ExpNo PrcNo MRseq        protocol                sizeMB   date                 file                                                                                      StudId                 SubjectName           CoreDim
% 1   Kevin                          12     1     1     FLASH        1_Localizer_multi_slice  1.10592 17-Jun-2021 11:46:44 F:\data5\nogui\raw_mix\20180808_082822_Kevin_1_12\1\pdata\1\2dseq                         20180808_A1812081_GADO BreinDMD_Alzet        2
% 1   Kevin                          12     10    1     RARE         RARE-T1W-7min            1.73538 17-Jun-2021 11:46:44 F:\data5\nogui\raw_mix\20180808_082822_Kevin_1_12\10\pdata\1\2dseq                        20180808_A1812081_GADO BreinDMD_Alzet        2
% 1   Kevin                          12     11    1     FLASH        1_Localizer_multi_slice  1.10592 17-Jun-2021 11:46:26 F:\data5\nogui\raw_mix\20180808_082822_Kevin_1_12\11\pdata\1\2dseq                        20180808_A1812081_GADO BreinDMD_Alzet        2
% 1   Kevin                          12     12    1     FieldMap     B0Map-ADJ_B0MAP          1.04858 17-Jun-2021 11:46:34 F:\data5\nogui\raw_mix\20180808_082822_Kevin_1_12\12\pdata\1\2dseq                        20180808_A1812081_GADO BreinDMD_Alzet        3
% 1   Kevin                          12     2     1     DtiEpi       DTI_EPI_3D_40dir_sat     23.3856 17-Jun-2021 11:46:06 F:\data5\nogui\raw_mix\20180808_082822_Kevin_1_12\2\pdata\1\2dseq                         20180808_A1812081_GADO BreinDMD_Alzet        3
% 1   Kevin                          12     2     2     DtiEpi       nan                       29.399 17-Jun-2021 11:45:56 F:\data5\nogui\raw_mix\20180808_082822_Kevin_1_12\2\pdata\2\2dseq                         20180808_A1812081_GADO BreinDMD_Alzet        3
% 1   Kevin                          12     3     1     RARE         T2_TurboRARE_highres       2.375 17-Jun-2021 11:46:20 F:\data5\nogui\raw_mix\20180808_082822_Kevin_1_12\3\pdata\1\2dseq                         20180808_A1812081_GADO BreinDMD_Alzet        2
% 1   Kevin                          12     4     1     RARE         RARE-T1W-7min            1.73538 17-Jun-2021 11:46:38 F:\data5\nogui\raw_mix\20180808_082822_Kevin_1_12\4\pdata\1\2dseq                         20180808_A1812081_GADO BreinDMD_Alzet        2
% 1   Kevin                          12     5     1     RARE         RARE-T1W-7min            1.73538 17-Jun-2021 11:46:24 F:\data5\nogui\raw_mix\20180808_082822_Kevin_1_12\5\pdata\1\2dseq                         20180808_A1812081_GADO BreinDMD_Alzet        2
% 1   Kevin                          12     6     1     RARE         RARE-T1W-7min            1.73538 17-Jun-2021 11:45:38 F:\data5\nogui\raw_mix\20180808_082822_Kevin_1_12\6\pdata\1\2dseq                         20180808_A1812081_GADO BreinDMD_Alzet        2
% 1   Kevin                          12     7     1     RARE         RARE-T1W-7min            1.73538 17-Jun-2021 11:46:30 F:\data5\nogui\raw_mix\20180808_082822_Kevin_1_12\7\pdata\1\2dseq                         20180808_A1812081_GADO BreinDMD_Alzet        2
% 1   Kevin                          12     8     1     RARE         RARE-T1W-7min            1.73538 17-Jun-2021 11:46:12 F:\data5\nogui\raw_mix\20180808_082822_Kevin_1_12\8\pdata\1\2dseq                         20180808_A1812081_GADO BreinDMD_Alzet        2
% 1   Kevin                          12     9     1     RARE         RARE-T1W-7min            1.73538 17-Jun-2021 11:46:34 F:\data5\nogui\raw_mix\20180808_082822_Kevin_1_12\9\pdata\1\2dseq                         20180808_A1812081_GADO BreinDMD_Alzet        2
% 2   20201118CH_Exp10_9258          1      1     1     FLASH        1-1_TriPilot-multi       1.96608 18-Nov-2020 12:46:12 F:\data5\nogui\raw_mix\20201118CH_Exp10_9258.5c1\1\pdata\1\2dseq                          1                      20201118CH_Exp10_9258 2
% 2   20201118CH_Exp10_9258          1      2     1     FISP         1-2_FISP_sagittal         0.0256 18-Nov-2020 12:46:16 F:\data5\nogui\raw_mix\20201118CH_Exp10_9258.5c1\2\pdata\1\2dseq                          1                      20201118CH_Exp10_9258 2
% 2   20201118CH_Exp10_9258          1      3     1     RARE         2_1_T2_ax_mousebrain      4.1943 18-Nov-2020 12:46:14 F:\data5\nogui\raw_mix\20201118CH_Exp10_9258.5c1\3\pdata\1\2dseq                          1                      20201118CH_Exp10_9258 2
% 3   20220301_ECM_Round11_Cage1_M04 1      1     1     FLASH        1_Localizer             0.393216 10-Mrz-2022 11:24:24 F:\data5\nogui\raw_mix\20220301_093711_20220301_ECM_Round11_Cage1_M04_1_1\1\pdata\1\2dseq ECM longitudinal       Cage1_M04             2
% 3   20220301_ECM_Round11_Cage1_M04 1      2     1     RARE         03_T2_TurboRARE           2.0736 10-Mrz-2022 11:24:28 F:\data5\nogui\raw_mix\20220301_093711_20220301_ECM_Round11_Cage1_M04_1_1\2\pdata\1\2dseq ECM longitudinal       Cage1_M04             2
% 3   20220301_ECM_Round11_Cage1_M04 1      3     1     RARE         RARE                      0.3584 10-Mrz-2022 11:24:22 F:\data5\nogui\raw_mix\20220301_093711_20220301_ECM_Round11_Cage1_M04_1_1\3\pdata\1\2dseq ECM longitudinal       Cage1_M04             2
% 3   20220301_ECM_Round11_Cage1_M04 1      4     1     User:epi_mre 07_epi_mre                 3.402 10-Mrz-2022 11:24:26 F:\data5\nogui\raw_mix\20220301_093711_20220301_ECM_Round11_Cage1_M04_1_1\4\pdata\1\2dseq ECM longitudinal       Cage1_M04             2
% 3   20220301_ECM_Round11_Cage1_M04 1      4     3     User:epi_mre 07_epi_mre                 3.402 10-Mrz-2022 11:24:26 F:\data5\nogui\raw_mix\20220301_093711_20220301_ECM_Round11_Cage1_M04_1_1\4\pdata\3\2dseq ECM longitudinal       Cage1_M04             2
% 3   20220301_ECM_Round11_Cage1_M04 1      6     1     FieldMap     B0Map-ADJ_B0MAP          1.04858 10-Mrz-2022 11:24:22 F:\data5\nogui\raw_mix\20220301_093711_20220301_ECM_Round11_Cage1_M04_1_1\6\pdata\1\2dseq ECM longitudinal       Cage1_M04             3
% ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
%
% ==============================================
%%  commandline example: BRUKER DATA  using Anastasia's data
% ===============================================
% ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
% set    SubjectId           StudNo  ExpNo  PrcNo  MRseq         protocol                  sizeMB   date                  file                                                                                            StudId  SubjectName  CoreDim
% 1      2021517_aj_T7_271   1       1      1      FLASH         01_Localizer_multi_slice  0.49152  01-Jun-2023 10:22:04  F:\data7\brukerImport_revisited\raw\20210517_101301_2021517_aj_T7_271_d13_1_1\1\pdata\1\2dseq   40G_1   T7_271       2
% 1      2021517_aj_T7_271   1       2      1      DtiEpi        02_DWI_Trace_EPI_sat       4.7186  01-Jun-2023 10:22:04  F:\data7\brukerImport_revisited\raw\20210517_101301_2021517_aj_T7_271_d13_1_1\2\pdata\1\2dseq   40G_1   T7_271       2
% 1      2021517_aj_T7_271   1       2      2      DtiEpi        nan                        5.2429  01-Jun-2023 10:22:04  F:\data7\brukerImport_revisited\raw\20210517_101301_2021517_aj_T7_271_d13_1_1\2\pdata\2\2dseq   40G_1   T7_271       2
% 1      2021517_aj_T7_271   1       3      1      RARE          03_T2_TurboRARE            4.1943  01-Jun-2023 10:22:04  F:\data7\brukerImport_revisited\raw\20210517_101301_2021517_aj_T7_271_d13_1_1\3\pdata\1\2dseq   40G_1   T7_271       2
% 1      2021517_aj_T7_271   1       4      1      RARE          04_T1_RARE_32slices        4.1943  01-Jun-2023 10:22:08  F:\data7\brukerImport_revisited\raw\20210517_101301_2021517_aj_T7_271_d13_1_1\4\pdata\1\2dseq   40G_1   T7_271       2
% 1      2021517_aj_T7_271   1       5      1      User:epi_mre  05_epi_mre                 3.8016  01-Jun-2023 10:22:06  F:\data7\brukerImport_revisited\raw\20210517_101301_2021517_aj_T7_271_d13_1_1\5\pdata\1\2dseq   40G_1   T7_271       2
% 1      2021517_aj_T7_271   1       5      2      User:epi_mre  05_epi_mre                 3.8016  01-Jun-2023 10:22:06  F:\data7\brukerImport_revisited\raw\20210517_101301_2021517_aj_T7_271_d13_1_1\5\pdata\2\2dseq   40G_1   T7_271       2
% 1      2021517_aj_T7_271   1       6      1      FieldMap      B0Map-ADJ_B0MAP            1.0486  01-Jun-2023 10:22:08  F:\data7\brukerImport_revisited\raw\20210517_101301_2021517_aj_T7_271_d13_1_1\6\pdata\1\2dseq   40G_1   T7_271       3
% 1      2021517_aj_T7_271   1       7      1      User:epi_mre  05_epi_mre                 3.8016  01-Jun-2023 10:22:10  F:\data7\brukerImport_revisited\raw\20210517_101301_2021517_aj_T7_271_d13_1_1\7\pdata\1\2dseq   40G_1   T7_271       2
% 1      2021517_aj_T7_271   1       7      2      User:epi_mre  05_epi_mre                 3.8016  01-Jun-2023 10:22:10  F:\data7\brukerImport_revisited\raw\20210517_101301_2021517_aj_T7_271_d13_1_1\7\pdata\2\2dseq   40G_1   T7_271       2
% 1      2021517_aj_T7_271   1       8      1      User:epi_mre  05_epi_mre                 3.8016  01-Jun-2023 10:22:06  F:\data7\brukerImport_revisited\raw\20210517_101301_2021517_aj_T7_271_d13_1_1\8\pdata\1\2dseq   40G_1   T7_271       2
% 1      2021517_aj_T7_271   1       8      2      User:epi_mre  05_epi_mre                 3.8016  01-Jun-2023 10:22:06  F:\data7\brukerImport_revisited\raw\20210517_101301_2021517_aj_T7_271_d13_1_1\8\pdata\2\2dseq   40G_1   T7_271       2
% 2      2021517_aj_T13_277  1       1      1      FLASH         01_Localizer_multi_slice  0.49152  01-Jun-2023 10:22:12  F:\data7\brukerImport_revisited\raw\20210517_101522_2021517_aj_T13_277_d13_1_1\1\pdata\1\2dseq  40G_1   T13_277      2
% 2      2021517_aj_T13_277  1       2      1      DtiEpi        02_DWI_Trace_EPI_sat       4.7186  01-Jun-2023 10:22:16  F:\data7\brukerImport_revisited\raw\20210517_101522_2021517_aj_T13_277_d13_1_1\2\pdata\1\2dseq  40G_1   T13_277      2
% 2      2021517_aj_T13_277  1       2      2      DtiEpi        nan                        5.2429  01-Jun-2023 10:22:16  F:\data7\brukerImport_revisited\raw\20210517_101522_2021517_aj_T13_277_d13_1_1\2\pdata\2\2dseq  40G_1   T13_277      2
% 2      2021517_aj_T13_277  1       3      1      FieldMap      B0Map-ADJ_B0MAP            1.0486  01-Jun-2023 10:22:10  F:\data7\brukerImport_revisited\raw\20210517_101522_2021517_aj_T13_277_d13_1_1\3\pdata\1\2dseq  40G_1   T13_277      3
% 2      2021517_aj_T13_277  1       4      1      RARE          03_T2_TurboRARE            4.1943  01-Jun-2023 10:22:12  F:\data7\brukerImport_revisited\raw\20210517_101522_2021517_aj_T13_277_d13_1_1\4\pdata\1\2dseq  40G_1   T13_277      2
% 2      2021517_aj_T13_277  1       5      1      RARE          04_T1_RARE_32slices        4.1943  01-Jun-2023 10:22:14  F:\data7\brukerImport_revisited\raw\20210517_101522_2021517_aj_T13_277_d13_1_1\5\pdata\1\2dseq  40G_1   T13_277      2
% 2      2021517_aj_T13_277  1       6      1      User:epi_mre  05_epi_mre                 3.8016  01-Jun-2023 10:22:18  F:\data7\brukerImport_revisited\raw\20210517_101522_2021517_aj_T13_277_d13_1_1\6\pdata\1\2dseq  40G_1   T13_277      2
% 2      2021517_aj_T13_277  1       6      2      User:epi_mre  05_epi_mre                 3.8016  01-Jun-2023 10:22:18  F:\data7\brukerImport_revisited\raw\20210517_101522_2021517_aj_T13_277_d13_1_1\6\pdata\2\2dseq  40G_1   T13_277      2
% 2      2021517_aj_T13_277  1       7      1      User:epi_mre  05_epi_mre                 3.8016  01-Jun-2023 10:22:14  F:\data7\brukerImport_revisited\raw\20210517_101522_2021517_aj_T13_277_d13_1_1\7\pdata\1\2dseq  40G_1   T13_277      2
% 2      2021517_aj_T13_277  1       7      2      User:epi_mre  05_epi_mre                 3.8016  01-Jun-2023 10:22:14  F:\data7\brukerImport_revisited\raw\20210517_101522_2021517_aj_T13_277_d13_1_1\7\pdata\2\2dseq  40G_1   T13_277      2
% 2      2021517_aj_T13_277  1       8      1      User:epi_mre  05_epi_mre                 3.8016  01-Jun-2023 10:22:16  F:\data7\brukerImport_revisited\raw\20210517_101522_2021517_aj_T13_277_d13_1_1\8\pdata\1\2dseq  40G_1   T13_277      2
% 2      2021517_aj_T13_277  1       8      2      User:epi_mre  05_epi_mre                 3.8016  01-Jun-2023 10:22:16  F:\data7\brukerImport_revisited\raw\20210517_101522_2021517_aj_T13_277_d13_1_1\8\pdata\2\2dseq  40G_1   T13_277      2
% ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
% %
% % OPTION-[1]: import all Anastasia Bruker data (no gui)
% w1=xbruker2nifti(fullfile(pwd,'raw'),0,[],[],'gui',0);
%
% % OPTION-[2]: import only a preselection of Anastasia Bruker data (no gui)
% %preselection
% w1=xbruker2nifti(fullfile(pwd,'raw'),0,[],[],'gui',0,'show',1);  %read Bruker data
% w1.showtable(w1)    % show table with all Bruker-data
% %import data with strings 'nan' or 'T1 or 'T2' found in field 'protocol' ..these files
% % correspond to 'nan', '04_T1_RARE_32slices' and '03_T2_TurboRARE' in the 'protocol'-field
% w2=xbruker2nifti(w1,0,[],[],'gui',0,'show',0,'flt',{'protocol','nan|T1|T2'},'paout',fullfile(pwd,'dat'));
%
%% ===============================================
%% additional nonGUI-parameter
%% ===============================================
% 'prefix_Dir'      add arbitrary string as PREFIX-STRING to animal directory
%                     string, default: ''
% 'StudNo_Dir'      add VisuStudyNumber as SUFFIX-STRING to animal directory
%                      {0|1}, default: 0
% 'ExpNo_Dir'       add VisuExperimentNumber (parent folder of "pdata") as SUFFIX-STRING to animal directory
%                     {0|1}, default: 0
% 'PrcNo_Dir'       add VisuProcessingNumber/ReconstructionNumber(subfolder of "pdata") as SUFFIX-STRING to animal directory
%                     {0|1}, default: 0
% 'StudID_Dir'      add StudId as SUFFIX to animal directory
%                     {0|1}, default: 1
% 'SubjectName_Dir' add SubjectName as SUFFIX to animal directory
%                     {0|1}, default: 0
%
% 'ExpNo_File'     add VisuExperimentNumber as suffix to new file
%                      {0|1}, default: 0
% 'PrcNo_File'     add VisuProcessingNumber/ReconstructionNumber as suffix to new file
%                      {0|1}, default: 0
% 'prefix'        add prefix to new file
%                      string, default: ''
% 'suffix'        add suffix to new file
%                      string, default: ''
% 'outname'       (for single-file import only!) - specify name of the resulting NIFTI-file (see example)
%                      type: string
% 'overwrite'    force to overwrite file; if [0] file is creates only if not existed before
%                {0|1}, default: 1
%
%
%% example: import files which Protocol contains string 'T1rho', adding EXPerimentNumber to file
% w1=xbruker2nifti(fullfile(pwd,'raw'),0,[],[],'gui',0,'show',1);
% w2=xbruker2nifti(w1,0,[],[],'gui',0,'show',0,'flt',{'protocol','T1rho'},...
%     'paout',fullfile(pwd,'dat'),'ExpNo_File',1);
%
%% example: import files which Protocol contains string 'T1rho', addding EXPerimentNumber & ProcNumber to file
% w2=xbruker2nifti(w1,0,[],[],'gui',0,'show',0,'flt',{'protocol','T1rho'},...
%     'paout',fullfile(pwd,'dat'),'ExpNo_File',1,'PrcNo_File',1);
%
%% examples of single file import
% v.study=antcb('getstudypath')
% v.paraw=fullfile(v.study,'raw')
% w1=xbruker2nifti(v.paraw,0,[],[],'gui',0,'show',1); %GET ALL Bruker raw-data files
% 
% %FILTER ONLY THE TURBORARE
% w2=xbruker2nifti(w1,0,[],[],'gui',0,'show',1,'flt',{'protocol','TurboRARE'});
% 
% %% import only a single file
% % output-file with orignal name ('03_T2_TurboRARE.nii')
% w3=xbruker2nifti(w2,0,[],[],'gui',0,'show',0);
% % output file with orignal name + ExperimentNumber+ProcessingNumber ('03_T2_TurboRARE_2_1.nii')
% w3=xbruker2nifti(w2,0,[],[],'gui',0,'show',0,'ExpNo_File',1,'PrcNo_File',1)
% % 
% % rename turborare as 't2.nii'
% w3=xbruker2nifti(w2,0,[],[],'gui',0,'show',0,'outname','t2.nii');
% % 
% % rename turborare and add ExperimentNumber+ProcessingNumber, output is: 't2_2_1.nii'
% w3=xbruker2nifti(w2,0,[],[],'gui',0,'show',0,'outname','t2.nii','ExpNo_File',1,'PrcNo_File',1);



function varargout=xbruker2nifti(pain,sequence,trmb,x,varargin)
if nargout==1
    varargout{1}=[];
end
warning off;

if exist('pain')==0
    global an
    pain={'guidir' fileparts(an.datpath)};
    sequence=0
end
%% =========Pairwise inputs======================================
p0.gui=1; % [0,1] show guis
p0.overwrite=1; %force to overwrite
if nargin>4
    pin= cell2struct(varargin(2:2:end),varargin(1:2:end),2);
    %p0=catstruct2(p0,pin);
    p0=catstruct(p0,pin);
end
%% =========declare additional vars ========================
if isfield(p0,'paout') && ~isempty(p0.paout)
    paout=p0.paout;
    if exist(paout)~=7; mkdir(paout); end
end

if isfield(p0,'show') && ~isempty(p0.show) && p0.show>0 %display only
    paout='dummy_path';
end

%% ===============================================



fprintf('...reading Bruker-data:      ');

warning off;
format compact;
if 0
    pain='O:\harms1\harmsStaircaseTrial\pvraw'
    pain={'guidir'  'O:\harms1\harmsTest_ANT'}  %PRESELECT PATH for GUI-->this is not the definitive Brukerpath
    
    sequence=1;  % sequence: 0: all sequences,   1:RARE,     , 2:FLASH,  3:FISP,  other sequence coded as string
    trmb     = 1 %lower Mbyte threshold  to skeep datasets for fast recursive file/methods-search [in MB!]
end
%==============================================================================
%% missing inputs
% using defaults
gui1     =0;
prefdir =pwd;  %preDIR for GUI

if    ~exist('pain','var') || isempty(pain)   ||              ( iscell(pain) && strcmp(pain{1},'guidir')    )
    gui1=1;
    try
        if    ( iscell(pain) && strcmp(pain{1},'guidir')    )  %get rough preDIR for GUI
            prefdir=pain{2};
        end
    end
end


if gui1==1
    %     pain=uigetdir2(pwd,'select META-mousePath');
    %    prefdir='c:\'
    msg={'BRUKER-IMPORT',...
        'select the "main"-BRUKER Folder [such as "raw"-dir] that contains the import data'...
        'Note: this folder must contain a folder for each mouse',...
        'alternatively, select one or more mouse folders',...
        '    -use upper fields and lower left panel to navigate',...
        '    -select the "main"-BRUKER Folder or one/several mouse folders from the right panel',...
        '    >>folders in the lower panels will be processed..',...
        '  press [Done]'};
    [pain,sts] = cfg_getfile2(inf,'dir',msg,[],prefdir);
    pain=char(pain);
    
    
    
    if isempty(pain); return; end
    
    ret=ones(size(pain,1),1)
    for i=1:size(pain,1)
        if isdir(pain(i,:))==0
            ret(i)=0
        end
    end
    if ~isempty(find(ret==0))
        if isdir(pain)==0; return;end
    end
    
    
end

if ~exist('paout','var') || isempty(paout)
    global an
    %paout=fullfile(fileparts(pain),'dat');
    paout=an.datpath;
    disp(['META-outfolder: ' paout]);
end

if ~exist('sequence','var') || isempty(sequence)
    sequence=1;
end

if ~exist('trmb','var') || isempty(trmb)
    trmb=0;
end

if size(pain,1)>1
    pain=char(regexprep(cellstr(pain),[filesep filesep '$'],''))
    if strcmp(pain(end),filesep)==1 %remove ending filesep
        pain(end)=[];
    end
end

%==============================================================================

if ~isstruct(pain)
    
    if size(pain,1)>1
        pain0=cellstr(pain)
        files={}; dirs={};
        for i=1:size(pain0,1)
            [files0,dirs0] = spm_select('FPListRec',pain0{i},'^2dseq$');
            files0=cellstr(files0);
            dirs0 =cellstr(dirs0);
            
            
            files=[files; files0];
            dirs =[dirs; dirs0];
        end
    else
        [files,dirs] = spm_select('FPListRec',pain,'^2dseq$');
        files=cellstr(files);
        dirs=cellstr(dirs);
    end
    
    % sequence: 0: all sequences,   1:RARE,     , 2:FLASH,  3:FISP,  other sequence coded as string
    if        sequence==0              sequence='';    %all
    elseif sequence==1;             sequence='RARE';
    elseif sequence==2      sequence='FLASH';
    elseif sequence==3       sequence='FISP';
    end
    
    if 0
        try
            %     Stack  = dbstack;
            disp('######## tester: first 30 trials');
            %     disp(['remove this in LINE: ' num2str(Stack.line)]);
            disp(['remove this in LINE: ' num2str(100)]);
            files=files(1:100);
        end
    end
    %==============================================================================
    %% skipp files below Mbyte-threshold (trmb)
    for i=1:size(files,1);     k(i)=dir(files{i});end
    mbytes=cell2mat({k(:).bytes}')/1e6;
    daterec={k(:).date}';
    
    del=find(mbytes<trmb);
    mbytes(del)         =[];
    files(del)             =[];
    daterec(del)       =[];
    
    %==============================================================================
    %% get sequence
    
    % seq=cell(length(files),1);
   % disp('*** READ IN BRUKER DATA ***     ....            ');
    tic
    
    ikeep=[];
    num=1;
    for i=1:length(files)
        [pa fi]=fileparts(files{i});
        pa2=pa(1:strfind(pa,'pdata')-1);
        
        
        %S = sprintf('read file %d',i);
        S = sprintf('%d',i);
        fprintf(repmat('\b',1,numel(S)));
        fprintf(S);
        drawnow;
        
        %     if i==4
        %        keyboard
        %     end
        
        
        try
            %get ExperimentNumber and RECO-Number
            slash   =strfind(pa,filesep);
            expNrA  =pa(slash(end-2)+1:slash(end-1)-1);
            recoNrA =pa(slash(end)+1:end);
            %disp(pa);
            
            
            methodfile=fullfile(pa2,'method');
            
            me=preadfile2(methodfile);
            me2=me{regexpi2(me,'\$Method')};
            
            
            seqA=[num2str(num) '_'  me2];
            visuxA      = readBrukerParamFile(fullfile(pa,'visu_pars'));
            try;         protocolA   = visuxA.VisuAcquisitionProtocol;
            catch;       protocolA   = 'nan';
            end
            
            
            %---------------------
            seq{num,1}      = seqA; %sequence
            visux{num}      = visuxA;%visu-struct
            meth{num}       =me; %methodfile
            protocol{num,1} = protocolA;%protocol-name
            recoNr{num,1} = recoNrA;%recontructionNumber (subfolder after pdata)
            expNr{num,1} = expNrA  ;%ExperimentNumber   (subfolder before pdata)
            
            
            num=num+1;
            ikeep(end+1,1)=i;
            
        end
        % O:\data\brukerImport2\20151126_162717_20151126_TF_LT16_1_1\2\pdata\1
        
        
        
        %     disp([i num]);
        if mod(i,10)==0
            fclose('all');
        end
    end
    %==============================================================================
    %% add parrams
    addparanames={
        'VisuSubjectId'
        'VisuStudyNumber'
        'VisuExperimentNumber'
        'VisuProcessingNumber'
        %
        'VisuStudyId'
        'VisuSubjectName'
        'VisuCoreDim'
        };
    addparanamesShort=regexprep(addparanames,'^Visu',''); % shortParametername for listbox
    
    addpara=[];
    for i=1:length(visux)
        for j=1:length(addparanames);
            try
                dum=getfield(visux{i}, addparanames{j});
                try
                    dum=num2str(dum);
                end
            catch
                dum='x';
            end
            addpara{i,j}=dum;
        end
    end
    
    %% replace ExpNumber from Path if empty in visu-file
    icol  =regexpi2(addparanames,'VisuExperimentNumber');
    iempty=regexpi2(addpara(:,icol),'x');
    addpara(iempty,icol) =expNr(iempty);
    
    %% replace RecoNumber/ProcessingNumber from Path if empty in visu-file
    icol  =regexpi2(addparanames,'VisuProcessingNumber');
    iempty=regexpi2(addpara(:,icol),'x');
    addpara(iempty,icol) =recoNr(iempty);
    
    % %% add also these parameters
    % addpara          =[recoNr    addpara ];
    % addparanamesShort=['recoNo' ;addparanamesShort];
    
    addparanamesShort=regexprep(addparanamesShort,'^Study',     'Stud'); % shortParametername for listbox
    addparanamesShort=regexprep(addparanamesShort,'^Experiment','Exp'); % shortParametername for listbox
    addparanamesShort=regexprep(addparanamesShort,'^Processing','Prc'); % shortParametername for listbox
    addparanamesShort=regexprep(addparanamesShort,'Number',     'No'); % shortParametername for listbox
    
    
    %==============================================================================
    %%keep parameters
    mbytes = mbytes(ikeep)   ;
    files  = files(ikeep)   ;
    daterec=daterec(ikeep) ;
    
    
    %prune seqstring
    [dum seq]=strtok(seq,'=');
    seq=regexprep(seq,{'=' '<' '>' 'Bruker:' ' '},'');
    
    if ~isempty(sequence)
        id= regexpi2(seq,sequence);
        files           =files(id);
        mbytes      =mbytes(id);
        seq             =seq(id);
        daterec     =daterec(id);
        
        protocol   =protocol(id);
    end
    
    %==============================================================================
    %% selectionGUI
    % tb=[strrep(files,[pain filesep],'') cellstr(num2str(mbytes)) daterec seq];
    % id=selector(tb,'Columns:  file, sizeMB, date, MRsequence');
    
    % tb=[strrep(files,[pain filesep],'') cellstr(num2str(mbytes)) daterec seq protocol];
    % id=selector(tb,'Columns:  file, sizeMB, date, MRsequence, protocol');
    
    % tb=[strrep(files,[pain filesep],'') cellstr(num2str(mbytes)) daterec seq protocol];
    tb=[files cellstr(num2str(mbytes)) daterec seq protocol];
    
    tbhead={'file' 'sizeMB' 'date' 'MRseq' 'protocol'};
    
    if size(tb,1)~=size(addpara,1)
        addpara=addpara(id,:);
    end
    d =[tb addpara];
    dh=[tbhead addparanamesShort(:)'];
    
    %rearange-database for display
    is=[ [6] [7 8 9   ] [4 5]     [2 3 1] [ 10 11 12 ] ];
    d=d(:,is);
    dh=dh(:,is);
    
    % if 1 %% full parameterview
    %     id=selector2(d,dh);
    % end
    %% ----internal animal-unifier-----
    if 1
        intnumUni=unique(d(:,1),'stable');
        [~,ia ]=ismember(d(:,1),intnumUni);
        intnum=cellfun(@(a){[ num2str(a) ]} ,num2cell(ia));
        dh=['set ' dh];
        d=[intnum d];
    end
    %% ________________________________________________
    
    % ==============================================
    %%  contextmenu-fileselector
    % ===============================================
    cm=contextmenu_fileselector();
    
    %     cc1=['us=get(gcf,''userdata'');'...
    %         'lb1=findobj(gcf,''tag'',''lb1'');'...
    %         'va=min(get(lb1,''value''));'...
    %         'fname=us.raw{va,11};'...
    %         'explorer(fileparts(fname));'  ];
    %     cc2=['us=get(gcf,''userdata'');'       'lb1=findobj(gcf,''tag'',''lb1'');'...
    %         'va=min(get(lb1,''value''));'...
    %         'fname=us.raw{va,11};'...
    %         'tx=preadfile(strrep(fname,''2dseq'',''visu_pars''));'...
    %         'if  us.showinbrowser==0; uhelp([{'' #yg VISU_PARS ''}; tx.all  ], 1);   set(findobj(gcf,''tag'',''txt''),''backgroundcolor'',''w'');'...
    %         'else   ;r=tx.all; e=[''<html><pre>'' ;r ;''</pre></html>'']; hfile=''____deleteMeSoon.html'' ;pwrite2file2(hfile,e,[]); eval([''! start  '' hfile]);'...
    %         'end;'];
    %     cc3=['us=get(gcf,''userdata'');'       'lb1=findobj(gcf,''tag'',''lb1'');'...
    %         'va=min(get(lb1,''value''));'...
    %         'fname=us.raw{va,11};'...
    %         'tx=preadfile(fullfile(fileparts(fileparts(fileparts(fname))),''method''));'...
    %         'if  us.showinbrowser==0; uhelp([{'' #yg METHOD ''}; tx.all  ], 1);  set(findobj(gcf,''tag'',''txt''),''backgroundcolor'',''w'');'...
    %         'else   ;r=tx.all; e=[''<html><pre>'' ;r ;''</pre></html>'']; hfile=''____deleteMeSoon.html'' ;pwrite2file2(hfile,e,[]); eval([''! start  '' hfile]);'...
    %         'end;'];
    %     cc4=['us=get(gcf,''userdata'');'       'lb1=findobj(gcf,''tag'',''lb1'');'...
    %         'va=min(get(lb1,''value''));' ...
    %         'fname=us.raw{va,11};'...
    %         'tx=preadfile(fullfile(fileparts(fileparts(fileparts(fname))),''acqp''));'...
    %         'if  us.showinbrowser==0; uhelp([{'' #yg ACQP ''}; tx.all  ], 1);   set(findobj(gcf,''tag'',''txt''),''backgroundcolor'',''w'');'...
    %         'else   ;r=tx.all; e=[''<html><pre>'' ;r ;''</pre></html>'']; hfile=''____deleteMeSoon.html'' ;pwrite2file2(hfile,e,[]); eval([''! start  '' hfile]);'...
    %         'end;'];
    %     cc5=['us=get(gcf,''userdata'');'...
    %         'lb1=findobj(gcf,''tag'',''lb1'');'...
    %         'va=min(get(lb1,''value''));'...
    %         'fname=us.raw{va,11};'...
    %         'montage2(fname);'  ];
    %
    %
    %     cm={'open folder  [1].[].shortcut', cc1
    %         'show VISU_PARS [2] '         , cc2
    %         'show METHOD [3]'             , cc3
    %         'show ACQP  [4]'              , cc4
    %         'show VOLUME  [5]'            , cc5};
else
    %===================================================================================================
    % ==============================================
    %%  1st input is a STRUCT
    % ===============================================
    
    
    w=pain;
    if isfield(w,'hd');         dh       =w.hd  ; end
    if isfield(w,'d' );         d        =w.d   ; end
    if isfield(w,'raw' );       files    =w.raw ; end
    if isfield(w,'seq' );       seq      =w.seq ; end
    if isfield(w,'visux' );     visux    =w.visux    ; end
    if isfield(w,'meth' );      meth     =w.meth     ; end
    if isfield(w,'protocol' );  protocol =w.protocol ; end
    id=1:size(d,1);
    
    cm=contextmenu_fileselector(); ;%contextMenu for fileselector
    
end %pain: is struct

%% =============[visualize only]==================================
% if isfield(p0,'show')==1 && isfield(p0,'flt')==0
%     disp('..');
%     cprintf('*[0 .5 .8]',[' BRUKER DATA ...no data imported,.. display only  \n']);
%     if p0.show==1
%         disp(char(plog([],[dh; d],0,'BRUKER DATA ','al=1')));
%     elseif p0.show==2
%         uhelp(plog([],[dh; d],0,'BRUKER DATA ','al=1'));
%     end
%
%     return
% end
%% ===========[ GUI: file selection]========================
disp(' ');
if p0.gui==1 %with open gui otherwise import all files
    
    if isfield(p0,'flt') && ~isempty(p0.flt) %FILTER OPTION
        try
            id=filterfiles(d,dh,p0);
            id=selector2(d,dh,'iswait',1,'contextmenu',cm,'finder',1,'preselect',id);
        catch
            id=selector2(d,dh,'iswait',1,'contextmenu',cm,'finder',1);
        end
        
    else
        id=selector2(d,dh,'iswait',1,'contextmenu',cm,'finder',1);
    end
    %     if isempty(id);
    %
    %         return;
    %     end
else
    
    
    if isfield(p0,'flt') && ~isempty(p0.flt) %FILTER OPTION
        id=filterfiles(d,dh,p0);
    else
        id=[1:size(d,1)]';
    end
    
    
end

if isempty(id)
    disp('  ');
    cprintf('*[0 .5 .8]',[' no files selected or found...no data imported..  \n']);
    return
end
if id==-1
    disp('  ');
    cprintf('*[0 .5 .8]',[' GUI aborted by user...no data imported..  \n']);
    return
end


% ==============================================
%%   reduce by ID
% ===============================================
set=cell2mat(cellfun(@(a){[str2num(a)]}, d(:,1)));
if isfield(p0,'first') && isnumeric(p0.first) && p0.first<=length(id) ;% reduce via 'first'-option
    id= id(1:p0.first);
end
% explicit set-numbers uded here: like: 'set',[1 3]  or 'set',[9]
if isfield(p0,'set') && isnumeric(p0.set)
    if length(intersect(unique(set),p0.set))==length(p0.set)
        setids=find(ismember(set,p0.set));
        id=intersect(id,setids);
    else
        isec=intersect(1:length(id),p0.set);
        mis=setdiff(p0.set,isec);
        disp(['  setNo found    : ' strjoin(cellstr(num2str(isec')),',')] );
        disp(['  setNo not found: ' strjoin(cellstr(num2str(mis')),',')] );
        disp('..import aborted .. please remove set');
        return
    end
elseif  isfield(p0,'set') && ischar(p0.set) && strcmp(p0.set,'all')
    %do nothing...here
end


dx       =d(id,:);
files    =files(id);
seq      =seq(id);
visux    =visux(id)';
meth     =meth(id)';
protocol =protocol(id);

% clear d





%% =============[visualize only]==================================
% if isfield(p0,'show')==1 && isfield(p0,'flt')==1 && p0.show~=0
if isfield(p0,'show')==1 && p0.show~=0
    disp('..');
    cprintf('*[0 .5 .8]',[' BRUKER DATA ...no data imported,.. display only  \n']);
    if p0.show==1
        disp(char(plog([],[dh; dx],0,'BRUKER DATA ','al=1')));
    elseif p0.show==2
        uhelp(plog([],    [dh; dx],0,'BRUKER DATA ','al=1'));
    end
    if nargout==1
        out.info='display only';
        out.hd =dh;
        out.d  =dx;
        out.raw      =files; %bruker raw files
        out.seq      =seq;
        out.visux    =visux;
        out.meth     =meth;
        out.protocol =protocol;
        
        out.showtable  = @(structname) disp(char(plog([],[structname.hd; structname.d],0,'BRUKER DATA ','al=1')));
        out.showtable2 = @(structname) uhelp(plog([],[structname.hd; structname.d],0,'BRUKER DATA ','al=1'),1);
        varargout{1}=out;
    end
    
    return
end
%% ===============================================
%==============================================================================
%%  PARAMETER-gui
%==============================================================================
if exist('x')~=1;        x=[]; end
% % % showgui=1
p={...
    'inf97'      [repmat('=',[1,100])]                           '' ''
    'inf98'       '              *** BrukerIMPORT  ***              '                        ,'' ''
    'inf99'       ' -define names of output-dirs and imported filenames '                    ,'' ''
    'inf991'      ' -the suffixes for ExperimentNumber (ExpNo_Dir/ExpNo_File) and ProcessingNumber (PrcNo_Dir/PrcNo_File)   will critically determine the existence & location of a generated file ','' ''
    'inf992'      '  CRITICAL-1: if both ExpNo_Dir/ExpNo_File are not specified and the same protocol is used multiple times [ RUNS] in the same mouse (=same SubjectId) ... ', '' ''
    'inf993'      '       .. than the resulting file is overwritten by subsequent runs of the experiment (e.g.: three subsequent MPRAGE-runs --> [..1\pdata\1\2dseq, 2\pdata\1\2dseq, 3\pdata\1\2dseq] ->result: only ONE file generated due to the missing ExperimentNumber-tag in the folder-/filename-->not good!!!!)','' ''
    'inf994'      '    SOLUTION:  (1) if there is only one RUNS/EXPERIMENTNUMBER for the same protocol: ExpNo_Dir/ExpNo_File is not necessary   ','' ''
    'inf995'      '    SOLUTION:  (2) if there are multiple RUNS/EXPERIMENTNUMBERS for the same protocol: either ExpNo_Dir/ExpNo_File is necessary   ','' ''
    'inf996'      '  CRITICAL-2: if both PrcNo_Dir/PrcNo_File are not specified and different [RECONSTRUCTIONS] (i.e. processings) of the same protocol exist for this mouse (=SubjectId), ... ','' ''
    'inf997'      '       .. the the resulting file is overwritten by subsequent reconstructions (e.g: three processingNumbers in experimentNumber-4 [..4\pdata\1\2dseq, 4\pdata\2\2dseq, 4\pdata\3\2dseq]  ->result: only ONE file generated due to the missing ProcessingNumber-tag in the folder-/filename-->not good!!!!) ','' ''
    'inf998'      '    SOLUTION:  (1) if there is only one RECONSTRUCTION for the same protocol: PrcNo_Dir/PrcNo_File is not necessary   ','' ''
    'inf999'      '    SOLUTION:  (2) if there are multiple RECONSTRUCTIONS for the same protocol: either PrcNo_Dir or PrcNo_File is necessary   ','' ''
    %
    %'inf100'      [repmat('=',[1,50])]                           '' ''
    %
    'inf101'      [repmat('=',[1,100])]                                    ''  ''
    'inf1'      '  [1] ANIMAL DIRECTORY NAME (added to "SubjectId")         '                                    ''  ''
    'inf102'      [repmat('=',[1,100])]                                    ''  ''
    'prefix_Dir'        ''    'add arbitrary string as PREFIX-STRING to the new animal directory '  {'' 'test_' 'other_'}
    'StudNo_Dir'        0     'add VisuStudyNumber as SUFFIX-STRING,  (bool)'  'b'
    'ExpNo_Dir'         0     'add VisuExperimentNumber (parent folder of "pdata") as SUFFIX-STRING,(bool)'  'b'
    'PrcNo_Dir'         0     'add VisuProcessingNumber/ReconstructionNumber(subfolder of "pdata") as SUFFIX-STRING,(bool)'  'b'
    'StudID_Dir'        1     'add StudId as SUFFIX to animal directory name' 'b'
    'SubjectName_Dir'   0     'add SubjectName as SUFFIX to animal directory name' 'b'
    
    
    %
    'inf103'      '% arrangement of suffixes       '                                    ''  ''
    'delimiter'     '_'        'delimiter between suffixes (cell); e.g: "s20141009_01sr_121" vs "s20141009_01sr_1_2_1" '  {'' '_' }
    'suffixLetter'  0          'add first letter of suffix variable name prior to variable value (bool); e.g: "s20141009_01sr_s1e2p1" vs "s20141009_01sr_1_2_1" '  'b'
    %
    %
    'inf200'      [repmat('=',[1,100])]                                    ''  ''
    'inf22'      ' [2] SUFFIXES of FILENAMES  (added to "protocoll-name")        '                                    ''  ''
    'inf201'      [repmat('=',[1,100])]                                    ''  ''
    'ExpNo_File'     0        'VisuExperimentNumber (parent folder of "pdata"),(bool)'  'b'
    'PrcNo_File'     0        'VisuProcessingNumber/ReconstructionNumber(subfolder of "pdata"),(bool)'  'b'
    'renameFiles'   ''   'rename files   -->via GUI'  {@renamefiles,protocol,[]}
    'prefix'        ''   'add prefix to filename' {'NI_' [regexprep(datestr(now),{':' ' '},'_') '_'] ''}
    'suffix'        ''   'add suffix to filename' {'_NI' ['_' regexprep(datestr(now),{':' ' '},'_')] ''}
    %
    'inf300'      [repmat('=',[1,100])]                                    ''  ''
    'inf32'      '  [3] ADDITIONAL OPTIONS       '                                    ''  ''
    'inf301'      [repmat('=',[1,100])]               ''  ''
    'origin'       'brukerOrigin'        'define center(origin) of volume'  {'brukerOrigin' 'volumeCenter'}
    };

if p0.gui==1
    showgui=1;
else
    showgui=0;
end

if isfield(p0,'prefix')==1; x.prefix=p0.prefix  ; end
if isfield(p0,'suffix')==1; x.suffix=p0.suffix  ; end

p=paramadd(p,x);%add/replace parameter
if showgui==1
    [m z ]=paramgui(p,'uiwait',1,'close',1,'editorpos',[.03 0 1 1],'figpos',[.15 .2 .84 .7 ],...
        'title','BrukerImport');
else
    z=param2struct(p);
end
if isempty(z);
    %     cprintf([0 .5 .8],[' ..user abort!  \n']);
    return
end
fn=fieldnames(z);
z=rmfield(z,fn(regexpi2(fn,'^inf\d')));

%==============================================================================
%% RENAME AFTER PROTOCOL
%==============================================================================
tbrename=repmat(unique(protocol(:)),[1 2]);
if ~isempty(z.renameFiles) && ~isempty(char(z.renameFiles));
    tbrename   =z.renameFiles;
    unchanged =setdiff(unique(protocol), tbrename(:,1));
    rest    =[ [unchanged] unchanged];
    tbrename=[tbrename; rest];
end
tbrename(:,2)=regexprep(tbrename(:,2),{'[\s&$%,\\.;:()[]{}<>"!?=/}@#+*]'},{''});%PRUNE

% ==============================================
%%   some more variables to assign
% ===============================================
if ~isempty(char(z.prefix))
    p0.prefix=char(z.prefix);
end
if ~isempty(char(z.suffix))
    p0.suffix=char(z.suffix);
end





%==============================================================================
%% BRUKER IMPORT
warning off;
mkdir(paout);

%% loop trhoug all 2dseq-files

if showgui==1
    h = waitbar(0,'Please wait...');
end
%% ===============================================

% ==============================================
%%  non-GUI input parameter
% ===============================================
if exist('p0')==1 && isstruct(p0)
    
    paratab={
        % DIR
        'prefix_Dir'        ''    'add arbitrary string as PREFIX-STRING to the new animal directory '  {'' 'test_' 'other_'}
        'StudNo_Dir'        0     'add VisuStudyNumber as SUFFIX-STRING,  (bool)'  'b'
        'ExpNo_Dir'         0     'add VisuExperimentNumber (parent folder of "pdata") as SUFFIX-STRING,(bool)'  'b'
        'PrcNo_Dir'         0     'add VisuProcessingNumber/ReconstructionNumber(subfolder of "pdata") as SUFFIX-STRING,(bool)'  'b'
        'StudID_Dir'        1     'add StudId as SUFFIX to animal directory name' 'b'
        'SubjectName_Dir'   0     'add SubjectName as SUFFIX to animal directory name' 'b'
        
        % FILE                            ''  ''
        'ExpNo_File'     0        'VisuExperimentNumber (parent folder of "pdata"),(bool)'  'b'
        'PrcNo_File'     0        'VisuProcessingNumber/ReconstructionNumber(subfolder of "pdata"),(bool)'  'b'
        'renameFiles'   ''   'rename files   -->via GUI'  {@renamefiles,protocol,[]}
        'prefix'        ''   'add prefix to filename' {'NI_' [regexprep(datestr(now),{':' ' '},'_') '_'] ''}
        'suffix'        ''   'add suffix to filename' {'_NI' ['_' regexprep(datestr(now),{':' ' '},'_')] ''}
        };
    
    for i=1:size(paratab)
        if isfield(p0,paratab{i,1})
            z=setfield(z, paratab{i,1},getfield(p0,paratab{i,1}));
        end
    end
    
    
    
end




%% ===============================================

% PARAMETER-OUTPUT __
%   if nargout==1



out.info='bruker-imported files';
out.hd=dh;
out.d =d(id,:);


out.forceoverwrite=ones([size(files,1) 1]);
out.raw     =files;
out.nifti   =repmat({''},[size(files,1) 1]);
out.success =repmat(0,[size(files,1) 1]);
out.errmsg  =repmat({''},[size(files,1) 1]);
%  output-function
out.showtable  = @(structname) disp(char(plog([],[structname.hd; structname.d],0,'BRUKER DATA ','al=1')));
out.showtable2 = @(structname) uhelp(plog([],[structname.hd; structname.d],0,'BRUKER DATA ','al=1'),1);


for i=1:size(files,1)
    
    try
        
        brukerfile=files{i};
        [pa fi]=fileparts(brukerfile);
        if showgui==1
            waitbar(i/size(files,1),h,[' convert2nifti:  ' num2str(i) '/' num2str(size(files,1)) ]);
        end
        %%===============================================
        %% MAKE DIRS AND FILENAMES
        %%===============================================
        
        %% MAKE MOUSE-FOLDER-name  [mfold outdir]
        delimiter=z.delimiter;
        mfold='';
        mfold=[mfold  dx{i, strcmp( dh,    'SubjectId'  )}];
        
        if z.StudNo_Dir==1;
            if z.suffixLetter==1  ; let='s'; else ;let=''; end
            mfold=[mfold delimiter let dx{i, strcmp( dh,    'StudNo'  )}] ;
        end
        if z.ExpNo_Dir==1;
            if z.suffixLetter==1  ; let='e'; else ;let=''; end
            mfold=[mfold delimiter let dx{i, strcmp( dh,    'ExpNo'  )}] ;
        end
        if z.PrcNo_Dir==1;
            if z.suffixLetter==1  ; let='p'; else ;let=''; end
            mfold=[mfold delimiter let dx{i, strcmp( dh,    'PrcNo'  )}] ;
        end
        
        if z.StudID_Dir==1;
            mfold=  [mfold delimiter char(dx(i,strcmp(dh,'StudId')))];
        end
        if z.SubjectName_Dir==1;
            mfold=  [mfold delimiter char(dx(i,strcmp(dh,'SubjectName')))];
        end
        
        
        
        
        
        if ~isempty(char(z.prefix_Dir))
            mfold= [char(z.prefix_Dir) mfold ];
        end
        
        %delete specialChars in mfolder-name
        mfold= regexprep(mfold,'\s+',''); %delete spaces
        mfold= regexprep(mfold,{'[\s&$%,\\.;:()[]{}<>"!?=/}@#+*]'},{''});
        
        % make MOUSEFOLDR-FOLDER  and FP-filename
        outdir=fullfile(paout,mfold);%% make DIR
        mkdir(outdir);
        
        %==============================================================================
        %% MAKE FILENAME  [fname fpname]
        idrename=find(strcmp(tbrename(:,1),protocol{i}));
        fname=[ tbrename{idrename,2}];
        
        if isfield(p0,'outname') && ischar(p0.outname)
            [~,nname, next]=fileparts(p0.outname);
              nname=regexprep(nname,'\s+','');
              if ~isempty(nname)
              fname=[ nname ];%remove spaces and add '.nii'
              end
        end
        
        
        
        if z.ExpNo_File==1;
            if z.suffixLetter==1  ; let='e'; else ;let=''; end
            fname=[fname delimiter let dx{i, strcmp( dh,    'ExpNo'  )}]   ;
        end
        if z.PrcNo_File==1;
            if z.suffixLetter==1  ; let='p'; else ;let=''; end
            fname=[fname delimiter let dx{i, strcmp( dh,    'PrcNo'  )}]   ;
        end
        fname=[fname '.nii'];
        
        % FULLPATH-FILENAME
        fpname=fullfile(outdir, fname );
        % add prefix
        if isfield(p0,'prefix') && ischar(p0.prefix)
            fpname= stradd(fpname,p0.prefix,1);
        end
        % add suffix
        if isfield(p0,'suffix') && ischar(p0.suffix)
            fpname= stradd(fpname,p0.suffix,2);
        end
        
        % file exist
        % file does not exist  
        writeFile=1;
        filealreadyExist=0;
        if exist(fpname)==2
            filealreadyExist=1;
        end
        
        
        if p0.overwrite==0 && exist(fpname)==2
            writeFile=0;
            out.forceoverwrite(i,1)=0;
        end
        
        
        
        if writeFile==1
                       
            %disp([pnum(i,4) '] create <a href="matlab: explorer('' ' outdir '  '')">' fpname '</a>' '; SOURCE: ' '<a href="matlab: explorer('' ' fileparts(files{i}) '  '')">' files{i}  '</a>']);% show h<perlink
            
            %==============================================================================
            %%===============================================
            %%   EXTRACT DTA
            %%===============================================
            [ni bh  da]=getbruker(brukerfile);
            
            % BUG -first 2Dims are mixed
            if ndims(ni.d)==3
                dimdiff=size(ni.d)-ni.hd.dim ;
                if dimdiff(1)~=0 && dimdiff(2)~=0  && dimdiff(3)==0 %first 2Dims are mixed
                    ni.hd.dim=ni.hd.dim([2 1 3]);
                end
            end
            
            %     %nachtrag
            %     if 1
            %       vecm=  spm_imatrix(ni.hd.mat)
            %         ni.hd.mat=[[diag(vecm(7:9)); 0 0 0] [  vecm(1:3) 1]']
            %     end
            %
            
            
            if strcmp(z.origin,'volumeCenter')
                ni.hd.mat(1:3,4) =-diag(ni.hd.mat(1:3,1:3)).*round(ni.hd.dim(1:3)/2)' ;
            end
            
            
            %     visu          = readBrukerParamFile(fullfile(pa,'visu_pars'));
            %       dtest   = readBruker2dseq(brukerfile,visu);
            
            %%===============================================
            %%   PREPARE NIFTI
            %  hh   = struct('fname',outfile ,...
            %         'dim',   {dim(1:3)},...
            %         'dt',    {[64 spm_platform('bigend')]},...
            %         'pinfo', {[1 0 0]'},...
            %         'mat',   {mat},...
            %         'descrip', {['x']});
            %%===============================================
            hh         = ni.hd;
            hh.fname   = fpname;
            
            ifilesep=strfind(brukerfile,filesep);
            brukerfile_short=brukerfile(ifilesep(end-4)+1:end);
            hh.descrip = [ brukerfile_short];
            
            % PRECISION
            %hh.dt         = [16 0]  ;%'float32'
            hh.dt         = [64 0]  ;%'float64'
            
            %===============================================
            %%  SAVE NIFTI (3d/4d)
            %%===============================================
            fclose('all');
            
            
            if 0 %% TEST
                continue
                disp( hh.fname );
            end
            
            
            if ndims(ni.d)==3
                hh=spm_create_vol(hh);
                hh=spm_write_vol(hh,  ni.d);
            elseif ndims(ni.d)==4
                clear hh2
                for j=1:size(ni.d,4)
                    dum=hh;
                    dum.n=[j 1];
                    hh2(j,1)=dum;
                    %if j==1
                    %mkdir(fileparts(hh2.fname));
                    spm_create_vol(hh2(j,1));
                    %end
                    spm_write_vol(hh2(j),ni.d(:,:,:,j));
                end
            elseif ndims(ni.d)==2
                if hh.dim(1)==size(ni.d,1) && hh.dim(2)==size(ni.d,2)
                    hh=spm_create_vol(hh);
                    hh=spm_write_vol(hh,  ni.d);
                else
                    hh.dim=[size(ni.d) 1];
                    hh=spm_create_vol(hh);
                    hh=spm_write_vol(hh,  ni.d);
                end
            end
        end
        
        try
            delete(strrep(fpname,'.nii','.mat')) ; %% delete helper.mat
        end
        fclose('all');
        
        out.success(i,1)=1; %succesfull;
        out.nifti{i,1}=fpname; %write filename to output-struct;
        
        %% SUCCESS
        
            prefixexist=' creating';
            if filealreadyExist==1; prefixexist=' re-creating'; end
            if writeFile==0;        prefixexist=' already exist'; end 
            disp([pnum(i,4) ']' prefixexist ' <a href="matlab: explorer('' ' outdir '  '')">' fpname '</a>' '; SOURCE: ' '<a href="matlab: explorer('' ' fileparts(files{i}) '  '')">' files{i}  '</a>']);% show h<perlink
       
        
    catch
        
        out.errmsg{i,1}=regexprep(lasterr,char(10),'; ');
        %% ERROR
        try ;      protoc=bh.v.VisuAcquisitionProtocol; catch; protoc='??'; end
        er=[  [' [' dh{1} '] ' dx{i,1}  ]  [' [protocol] ' protoc  ] ];
        for jj=2:length(dh)
            er=[er [' [' dh{jj} '] ' dx{i,jj}  ] ];
        end
        
        try
            cprintf([1 0 1],[pnum(i,4) '] ERROR: ' ]);
            cprintf([.8 .5 0],[ strrep(er,filesep,[filesep filesep])  '\n']);
        catch
            disp([pnum(i,4) '] ERROR: '  er]) ;
        end
        disp('       ...could not import this data');
        
        
        try
            delete(strrep(fpname,'.nii','.mat')) ; %% delete helper.mat
        end
        fclose('all');
        out.nifti{i,1}='error'; %write filename to output-struct;
    end
    
    
    
    
end%i
if showgui==1
    close(h);
end

% ==============================================
%%   save local log-file
% ===============================================
try
    hlogfile=['NIFTI'  'RAW'       'SUCCESS'      out.hd    'ErrorMessage'     ];
    logfile =[out.nifti out.raw num2cell(out.success) out.d out.errmsg];
    logfileBK=logfile;
    logfile(find(out.forceoverwrite==0),:)=[]; %baustelle
    
    
    if ~isempty(logfile)
        logfile_fmt=(plog([],[  hlogfile;logfile],0,'','plotlines=0;al=1' ));
        
        logfileName=fullfile(paout,   ['logImport_' regexprep(datestr(now),{'\s+',':'},{'__','-'}) '.log']);
        pwrite2file(logfileName,logfile_fmt);
    end
end
% ==============================================
%%   save logfile within each animal folder
% ===============================================
try
    px_out=fileparts2(out.nifti);
    px_out_uni=unique(px_out);
    
    for i=1:length(px_out_uni)
        ix=find(strcmp(px_out,px_out_uni{i}));
        logfileAnimal=logfileBK(ix,:);
        logfile_write=out.forceoverwrite(ix);
        logfileAnimal2write=logfileAnimal(logfile_write==1,:    );
        
        logfile_fmt=(plog([],[  hlogfile;logfileAnimal2write],0,'','plotlines=0;al=1' ));
        if ~isempty(logfileAnimal2write)
            logfileName=fullfile(px_out_uni{i},   ['logImport_' regexprep(datestr(now),{'\s+',':'},{'__','-'}) '.log']);
            pwrite2file(logfileName,logfile_fmt);
            showinfo2('saved: ',logfileName);
        end
    end
end



%% ==========output-variable =====================================

if nargout==1
    varargout{1}=out;
end

if isstruct(pain)==0
    makebatch(z,pain,trmb,sequence);
    pause(.5);
end
drawnow;
try; antcb('update');end
fprintf('[BrukerImport Done!]\n');

%==============================================================================
%%  SUBS
%==============================================================================


function makebatch(z,pain,trmb,sequence)




if isempty(num2str(sequence));  sequence=0;    end
if isempty(num2str(trmb));      trmb=0;       end
if size(cellstr(pain),1)==1
    call=[mfilename '(' ['{' '''guidir'''  ' '  ''''  fileparts(pain) ''''  '}' ]  ' , ' num2str(sequence) ',' num2str(trmb), ',z' ')' ];
else
    pain2=cellstr(pain) ;
    call=[mfilename '(' ['{' '''guidir'''  ' '  ''''  (fileparts(pain2{1})) ''''  '}' ]  ' , ' num2str(sequence) ',' num2str(trmb), ',z' ')' ];
    
end

try
    hlp=help(mfilename);
    hlp=hlp(1:min(strfind(hlp,char(10)))-1);
catch
    hlp='';
end

hh={};
hh{end+1,1}=('%===================================================');
hh{end+1,1}=[ '% BATCH:        [' [mfilename '.m' ] ']' ];
hh{end+1,1}=[ '% descr:' hlp];
hh{end+1,1}=('%===================================================');
hh=[hh; struct2list(z)];
hh(end+1,1)={call} ;%{[mfilename '(' { 'guidir'    fileparts(pain)} , sequence,trmb, ',z' ')' ]};
% disp(char(hh));
% uhelp(hh,1);


try
    v = evalin('base', 'anth');
catch
    v={};
    assignin('base','anth',v);
    v = evalin('base', 'anth');
end
v=[v; hh; {'                '}];
assignin('base','anth',v);



















function he=renamefiles(protocol,titlex)
% keyboard




tbrename=[unique(protocol(:)) repmat({''}, [length(unique(protocol(:))) 1])];

f = fg; set(gcf,'menubar','none');
t = uitable('Parent', f,'units','norm', 'Position', [0 0.1 1 .85], 'Data', tbrename,'tag','table');
t.ColumnName = {'Protocol name                                            ', '(optional) rename coresponding file to..                         '};
t.ColumnEditable = [false true ];
t.BackgroundColor = [1 1 1; 0.9451    0.9686    0.9490];

tx=uicontrol('style','text','units','norm','position',[0 .96 1 .03 ],'string','OPTIONAL: RENAME FILES (..otherwise protocol name is used)','fontweight','bold','backgroundcolor','w');
pb=uicontrol('style','pushbutton','units','norm','position',[.05 0.02 .15 .05 ],'string','OK','fontweight','bold','backgroundcolor','w',...
    'callback',   'set(gcf,''userdata'',get(findobj(gcf,''tag'',''table''),''Data''));'          );%@renameFile


h={' #yg  ***RENAME FILES USING PROTOCOL AS IDENTIFIER ***'} ;
h{end+1,1}=[' #### **NOTE*** THIS STEP IS OPTIONAL' ];
h{end+1,1}=['The 1st column represents the Protocol-name from MRI aquisition (readout from Bruker data ) '];
h{end+1,1}=['The 2nd column can ( ### optional! ##### ) be used to rename the protocol-related volumes '];
h{end+1,1}=[' which will be imported '];
h{end+1,1}=[' -renameing string without file-format (do not add ".nii")'];
h{end+1,1}=[' if cells in the 2nd column are empty, the import function uses the protocol name '];
h{end+1,1}=[' from the 1st column'];
%    uhelp(h,1);
%    set(gcf,'position',[ 0.55    0.7272    0.45   0.1661 ]);

setappdata(gcf,'phelp',h);

pb=uicontrol('style','pushbutton','units','norm','position',[.85 0.02 .15 .05 ],'string','Help','fontweight','bold','backgroundcolor','w',...
    'callback',   'uhelp(getappdata(gcf,''phelp''),1); set(gcf,''position'',[ 0.55    0.7272    0.45   0.1661 ]);'          );%@renameFile
% set(gcf,''position'',[ 0.55    0.7272    0.45   0.1661 ]);
drawnow;
waitfor(f, 'userdata');
% disp('geht weiter');
tbrename=get(f,'userdata');
he=tbrename(~cellfun('isempty' ,tbrename(:,2)),:);
%     disp(tbrename);
close(f);

% ==============================================
%%   contextmenu_fileselector
% ===============================================

function cm=contextmenu_fileselector();
cc1=['us=get(gcf,''userdata'');'...
    'lb1=findobj(gcf,''tag'',''lb1'');'...
    'va=min(get(lb1,''value''));'...
    'fname=us.raw{va,11};'...
    'explorer(fileparts(fname));'  ];
cc2=['us=get(gcf,''userdata'');'       'lb1=findobj(gcf,''tag'',''lb1'');'...
    'va=min(get(lb1,''value''));'...
    'fname=us.raw{va,11};'...
    'tx=preadfile(strrep(fname,''2dseq'',''visu_pars''));'...
    'if  us.showinbrowser==0; uhelp([{'' #yg VISU_PARS ''}; tx.all  ], 1);   set(findobj(gcf,''tag'',''txt''),''backgroundcolor'',''w'');'...
    'else   ;r=tx.all; e=[''<html><pre>'' ;r ;''</pre></html>'']; hfile=''____deleteMeSoon.html'' ;pwrite2file2(hfile,e,[]); eval([''! start  '' hfile]);'...
    'end;'];
cc3=['us=get(gcf,''userdata'');'       'lb1=findobj(gcf,''tag'',''lb1'');'...
    'va=min(get(lb1,''value''));'...
    'fname=us.raw{va,11};'...
    'tx=preadfile(fullfile(fileparts(fileparts(fileparts(fname))),''method''));'...
    'if  us.showinbrowser==0; uhelp([{'' #yg METHOD ''}; tx.all  ], 1);  set(findobj(gcf,''tag'',''txt''),''backgroundcolor'',''w'');'...
    'else   ;r=tx.all; e=[''<html><pre>'' ;r ;''</pre></html>'']; hfile=''____deleteMeSoon.html'' ;pwrite2file2(hfile,e,[]); eval([''! start  '' hfile]);'...
    'end;'];
cc4=['us=get(gcf,''userdata'');'       'lb1=findobj(gcf,''tag'',''lb1'');'...
    'va=min(get(lb1,''value''));' ...
    'fname=us.raw{va,11};'...
    'tx=preadfile(fullfile(fileparts(fileparts(fileparts(fname))),''acqp''));'...
    'if  us.showinbrowser==0; uhelp([{'' #yg ACQP ''}; tx.all  ], 1);   set(findobj(gcf,''tag'',''txt''),''backgroundcolor'',''w'');'...
    'else   ;r=tx.all; e=[''<html><pre>'' ;r ;''</pre></html>'']; hfile=''____deleteMeSoon.html'' ;pwrite2file2(hfile,e,[]); eval([''! start  '' hfile]);'...
    'end;'];
cc5=['us=get(gcf,''userdata'');'...
    'lb1=findobj(gcf,''tag'',''lb1'');'...
    'va=min(get(lb1,''value''));'...
    'fname=us.raw{va,11};'...
    'montage2(fname);'  ];


cm={'open folder  [1].[].shortcut', cc1
    'show VISU_PARS [2] '         , cc2
    'show METHOD [3]'             , cc3
    'show ACQP  [4]'              , cc4
    'show VOLUME  [5]'            , cc5};



function id=filterfiles(d,dh,p0);
%% ===============================================
id=[];
% p0.flt={'pro'    'RARE'}
% p0.flt={'pro'    'T2'}
% p0.flt={'pro'    'T2|DTI_EPI'}
% p0.flt={'pro'    '^T2|^DTI_EPI'}
% p0.flt={'date'    '2020'}
% p0.flt={'date'    'Jun-2021'}
%
% p0.flt={'date'    '2020|2021'}
% p0.flt={'MR'    'Fisp|Rare'}
%
% p0.flt={'si'    '>20'}
% p0.flt={'si'    '<20'}
% p0.flt={'si'    '>20 & <30'}
% p0.flt={'si'    '>1.7 & <1.8'}

%% ===============================================
if numel(p0.flt)==1
    id=[1:size(d,1)];
else
    if length(p0.flt)==2
        flt=p0.flt;
    else
        %flt=reshape(p0.flt(:)',  [length(p0.flt(:))/2  2 ])';
        flt=reshape(p0.flt(:),  [2 length(p0.flt(:))/2  ])';
    end
    % select specific sets based on as numeric array
    iset=find(strcmp(flt(:,1),'set'));
    if ~isempty(iset)
        if isnumeric(flt{iset,2})
            flt{iset,2}=  strjoin(cellfun(@(a){[ '^' num2str(a) '$' ]} ,num2cell(flt{iset,2})),'|');
        end
    end
    
    
    uw=zeros(size(d,1),size(flt,1) );
    id=[];
    for j=1:size(flt,1)
        dfl=flt(j,:);
        ic=regexpi2(dh,dfl{1}); %GET COLUMN(S)
        id0=[];
        for i=1:length(ic)
            if length(regexpi(dfl{2},'>|<'))>0
                siMB=str2num(char(d(:,ic(i))));
                if length(regexpi(dfl{2},'>|<'))==1
                    nid=find(eval(['siMB' dfl{2}]));
                else
                    nid=find(eval(['siMB' regexprep(dfl{2},'&', '&siMB') ]));
                end
                
            else
                nid=regexpi2(d(:,ic(i)),dfl{2});
            end
            id0=[id0; nid(:)];
        end
        uw(id0,j)=1;
    end
    id=find(sum(uw,2)==size(uw,2));
end


%% ===============================================

%========[old]===========================================================================================
if 0
    ic=regexpi2(dh,p0.flt{1}); %GET COLUMN(S)
    
    for i=1:length(ic)
        if length(regexpi(p0.flt{2},'>|<'))>0
            siMB=str2num(char(d(:,ic(i))));
            if length(regexpi(p0.flt{2},'>|<'))==1
                nid=find(eval(['siMB' p0.flt{2}]));
            else
                nid=find(eval(['siMB' regexprep(p0.flt{2},'&', '&siMB') ]));
            end
            
        else
            nid=regexpi2(d(:,ic(i)),p0.flt{2});
        end
        id=[id; nid(:)];
    end
end

% d(id,:)
%% ===============================================



