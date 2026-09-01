function snips_input2

snips
return

%% #################################################
% REGIONBASED-STATISTIC
% BETWEEN-DESIGN
% [1] RUN Welch two-sample t-test (unequal variance) on all atlas-regions
% The data-file (Excelfile, generated via get GUI-"get anatomical labels" or xgetlabels4.m) contains the averaged
% values from each anat. region for each animal ('mean'-sheet)
% The group assignment file (Excelfile) contains a column with animal-IDs (here: 'MRI-ID') and a colum specifying
% the group (here: 'group')

v = [];
v.data         =  fullfile(pwd,'anatomical_labels_native_bothHem.xlsx'); % % excel data file
v.dataSheet    =  'mean';                                                % % sheetname of excel data file
v.aux          =  fullfile(pwd,'animal_groups_all.xlsx');                % % excel group assignment file
v.auxSheet     =  'Tabelle1';                                            % % sheetname of excel group assignment file
v.id           =  'MRI-ID';                                              % % name of the column containing the animal-id in the auxSheet
v.f1           =  'group';                                               % % name of the column containing the group-assignment in the auxSheet
v.typeoftest1  =  'ttest2welch';                                         % % applied  statistical test (such as "ranksum" or "ttest2")
v.tail         =  'both';                                                % % type of alternative hypothesis: both|left|right
v.qFDR         =  [0.05];                                                % % q-threshold of FDR-correction (default: 0.05)
v.isfdr        =  [1];                                                   % % use FDR correction: [0]no, [1]yes
v.showsigsonly =  [0];                                                   % % show significant results only:  [0]no, show all, [1]yes, show signif. results only
v.issort       =  [1];                                                   % % sort results according the p-value: [0]no, [1]yes,sort
xstatlabels(v);      % % SET all Parameter
xstatlabels('run');  % % RUN statistic
xstatlabels('export','file', fullfile(pwd,'_res_anatom_ttest2.xlsx')); %save as Excelfile

%% ===============================================
% [2] RUN Permutation-based Welch two-sample t-test
% same data as in [1]
v = [];
v.data         =  fullfile(pwd,'anatomical_labels_native_bothHem.xlsx'); % % excel data file
v.dataSheet    =  'mean';                                                % % sheetname of excel data file
v.aux          =  fullfile(pwd,'animal_groups_all.xlsx');                % % excel group assignment file
v.auxSheet     =  'Tabelle1';                                            % % sheetname of excel group assignment file
v.id           =  'MRI-ID';                                              % % name of the column containing the animal-id in the auxSheet
v.f1           =  'group';                                               % % name of the column containing the group-assignment in the auxSheet
v.typeoftest1  =  'permwelch';                                           % % applied  statistical test (such as "ranksum" or "ttest2")
v.nperms       =  [5000];                                                % % number of permutations
v.tail         =  'both';                                                % % type of alternative hypothesis: both|left|right
v.qFDR         =  [0.05];                                                % % q-threshold of FDR-correction (default: 0.05)
v.isfdr        =  [1];                                                   % % use FDR correction: [0]no, [1]yes
v.showsigsonly =  [0];                                                   % % show significant results only:  [0]no, show all, [1]yes, show signif. results only
v.issort       =  [1];                                                   % % sort results according the p-value: [0]no, [1]yes,sort
xstatlabels(v);      % % SET all Parameter
xstatlabels('run');  % % RUN statistic
xstatlabels('export','file', fullfile(pwd,'_res_anatom_permwelch.xlsx')); %save as Excelfile

%% #################################################
% REGIONBASED-STATISTIC
% WITHIN-DESIGN: create toy-dATA
% 
% 
%% ===============================================
% make data- & groupFile for repeated measures
% idea:-20 animals were measuread at two timepoints (T1,T2)
%      -create data-excelfile (1st sheet-name 'table') with data: regions x animalIDs 
%      -create group-excelfile (1st sheet-name 'table') with columns: animalIDs grouplabel subject-number
%       the subjectnumber later necessary identify the same animal
% the output excel-sheets should than look as follows:
% ---[data-file]-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%   region  animT1_1  animT1_2  animT1_3  animT1_4  animT1_5  animT1_6  animT1_7  animT1_8  animT1_9  animT1_10  animT1_11  animT1_12  animT1_13  animT1_14  animT1_15  animT1_16  animT1_17  animT1_18  animT1_19  animT1_20  animT2_1  animT2_2  animT2_3  animT2_4  animT2_5  animT2_6  animT2_7  animT2_8  animT2_9  animT2_10  animT2_11  animT2_12  animT2_13  animT2_14  animT2_15  animT2_16  animT2_17  animT2_18  animT2_19  animT2_20
%   reg_A1   -1.2111   -2.8656    0.3854    0.1726    0.5300   -1.0078   -1.0401   -1.1313   -0.2156     0.4050     0.3374     1.1191     1.4580     1.2198     1.5471     1.6490    -0.2910    -1.7453    -0.1401     0.8539   -2.5729   -1.3290   -1.7050   -3.6626   -1.6078   -3.8297   -3.3823   -3.5630   -3.0469    -1.5560    -2.4975    -3.0856    -5.0781    -2.3476    -2.9228    -4.2999    -4.6684    -1.5403    -2.5802    -4.5234
%   reg_B2    1.3751   -1.1091    0.0255   -0.8082    0.6136    1.3467   -0.3846    0.2946   -0.7285    -0.2196     0.7528     0.0369     1.6218     0.9881    -0.6515    -1.0115     0.0076    -1.2380     0.5955    -1.0117   -1.1938   -2.4136   -2.5685    0.8579   -2.6806   -0.7223    1.4441    0.7692   -2.6166    -2.6000    -1.6229     0.0076    -0.2342    -1.4304    -3.2199    -2.4931    -2.8624     0.1595    -1.3176    -2.9600
%   reg_C3    0.1225    0.9939   -2.3802    0.8368   -0.2343   -0.4484   -1.6838    0.9775    0.3701     1.2871    -0.8231    -0.7338     1.4168    -1.1374    -0.3503     0.9779     0.1827    -0.3423     0.7760     0.4205   -1.3277    0.2471   -3.0188    0.2589   -0.0548    0.2900   -0.8672   -0.4660   -0.7894    -0.7160    -2.1207    -2.1382    -1.1274     0.6263    -2.8148    -1.3770    -2.0459    -1.3126    -0.9159     1.0515
%   reg_D4   -0.6778    0.1616    1.1714    0.3662   -0.4211   -0.3507   -0.5832   -0.5844   -0.5943    -0.1233    -0.2455     2.0083     0.7332    -0.7232     1.2987     0.0455     0.2193    -1.5511    -0.0248     1.0952   -0.5981   -1.8663    0.0584   -0.4547    0.4383   -0.7857    1.2289   -0.6175   -0.7858    -1.2970    -1.0929    -1.2208     0.0491     1.8451    -0.0875     1.9543    -0.1303     0.6204    -0.0924    -0.1893
%   reg_E5   -0.4214   -2.1522   -2.2114   -1.7939   -0.3304   -0.9258   -0.8188   -0.5281    1.8096    -0.1035     1.6449    -0.4097     0.3902     0.5617     2.9476    -0.0254    -0.2163    -0.2780    -0.9070    -2.0179    0.7714    2.1742    0.1534   -0.3393    1.0413    0.3581   -0.5593   -0.7342    0.8536     1.4759    -0.5148     0.1029     0.7878     0.9277     0.7544     2.2135    -0.2994    -0.0808     0.6815     0.0638
%   reg_F6    0.1829   -0.5587   -0.6871   -1.6912   -0.6525    0.5335    1.8909   -0.5406    0.6026     2.0681     0.5579    -2.3917    -1.6257    -0.7793    -0.5401    -0.5289     1.2075    -0.1351     0.3569     1.2847    0.1171    1.0530    1.3692    0.3154    2.8202    0.5469    0.5887    0.5185   -0.0606     0.2982     1.2229     1.0659     1.6374     0.6284     0.2081     0.7364     1.4765     1.1983     1.9249     0.2738
%   reg_G7   -0.9507    0.0595    0.3971    1.2524   -1.8114    1.6458   -0.4256    0.8064    1.0481    -0.9216    -0.8348     0.4701     0.9922    -0.0770    -0.4455    -0.7606     0.8368     1.0141     1.3953    -0.7322    4.0210    4.4337    2.2852    3.1944    2.8658    3.0311    3.2320    4.7613    2.3552     3.4776     2.2813     4.9066     2.8668     5.1389     2.8515     3.2708     3.2847     2.6995     4.4040     3.5837
% ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
% ---[group-file]--------------
%      animal  group  subject
%    animT1_1     t1        1
%    animT1_2     t1        2
%    animT1_3     t1        3
%    animT1_4     t1        4
%    animT1_5     t1        5
%    animT1_6     t1        6
%    animT1_7     t1        7
%    animT1_8     t1        8
%    animT1_9     t1        9
%   animT1_10     t1       10
%   animT1_11     t1       11
%   animT1_12     t1       12
%   animT1_13     t1       13
%   animT1_14     t1       14
%   animT1_15     t1       15
%   animT1_16     t1       16
%   animT1_17     t1       17
%   animT1_18     t1       18
%   animT1_19     t1       19
%   animT1_20     t1       20
%    animT2_1     t2        1
%    animT2_2     t2        2
%    animT2_3     t2        3
%    animT2_4     t2        4
%    animT2_5     t2        5
%    animT2_6     t2        6
%    animT2_7     t2        7
%    animT2_8     t2        8
%    animT2_9     t2        9
%   animT2_10     t2       10
%   animT2_11     t2       11
%   animT2_12     t2       12
%   animT2_13     t2       13
%   animT2_14     t2       14
%   animT2_15     t2       15
%   animT2_16     t2       16
%   animT2_17     t2       17
%   animT2_18     t2       18
%   animT2_19     t2       19
%   animT2_20     t2       20
% ---------------------------


%==[create data] ===================================
l=[ -3 -1.2: .5 :1.2 3]; %difference in effect pre vs post
nt=length(l);
n=20; %number of animals
d=[];
t=[];
for i=1:length(l) %create data [d]: regions x animal  [T1_a1,T1_a2,...,T1_a20,  T2_a1,T2_a2,...,T2_a20   ]
    a1=randn(n,1);a2=randn(n,1)+l(i);
    [h p ci st]= ttest(a1,a2);
    v=[a1' a2'];
    d(i,:)=v;
    t(i,:)=[h p  st.tstat st.df ]; %table for posthoc checks
end
%==[make data and group tables] ===================================

ids_t1=cellfun(@(a) {[ 'animT1_' num2str(a)   ]}, num2cell( [1:n])); %animal-IDS for T1
ids_t2=cellfun(@(a) {[ 'animT2_' num2str(a)  ]}, num2cell( [1:n]));  %animal-IDS for T2
reg=cellfun(@(a,b) {[  'reg_' num2str(a) num2str(b) ]}, cellstr(char(65:65+nt-1)'), num2cell([1:nt])'); %regionNames

% DATA-table
ha=[{'region'} [ids_t1 ids_t2]];
a= [reg  num2cell([d])] ;
%GROUP-table
hg={'animal' 'group' 'subject'  };
g =[[ids_t1' ;ids_t2'] [repmat({'t1'},[n 1]); repmat({'t2'},[n 1])]  num2cell([1:n 1:n]')  ];

%==[save excelfiles]=============================================
f1=fullfile(pwd,'repeatedMeasures_sampledata.xlsx'); %save data-file
pwrite2excel(f1,{1 'table'},ha,[],a);
showinfo2('file:',f1);

f2=fullfile(pwd,'repeatedMeasures_group.xlsx');     %save group-file
pwrite2excel(f2,{1 'table'},hg,[],g);
showinfo2('file:',f2);



%% #################################################
% REGIONBASED-STATISTIC
% WITHIN-DESIGN

% [1] WITHIN: RUN paired t-test
v = [];
v.data         =  fullfile(pwd, 'repeatedMeasures_sampledata.xlsx'); % % excel data file
v.dataSheet    =  'table';                                           % % sheetname of excel data file
v.aux          =  fullfile(pwd, 'repeatedMeasures_group.xlsx');      % % excel group assignment file
v.auxSheet     =  'table';                                           % % sheetname of excel group assignment file
v.id           =  'animal';                                          % % name of the column containing the animal-id in the auxSheet
v.f1           =  'group';                                           % % name of the column containing the group-assignment in the auxSheet
v.subject      =  'subject';                                         % % within-test only: name of the column containing the subject-factor (same animal get the same number...for repeated measures)
v.f1design     =  [1];                                               % % type of test: [0]between, [1]within
v.typeoftest1  =  'ttest';                                           % % applied  statistical test (such as "ranksum" or "ttest2")
v.tail         =  'both';                                            % % Type of alternative hypothesis: both|left|right 
v.regionsfile  =  '';                                                % % <optional> excelfile containing regions, only this regions will be tested
v.qFDR         =  [0.05];                                            % % q-threshold of FDR-correction (default: 0.05)
v.isfdr        =  [1];                                               % % use FDR correction: [0]no, [1]yes
v.showsigsonly =  [0];                                               % % show significant results only:  [0]no, show all, [1]yes, show signif. results only
v.issort       =  [1];                                               % % sort results according the p-value: [0]no, [1]yes,sort 
xstatlabels(v);      % % SET all Parameter   
xstatlabels('run');  % % RUN statistic
xstatlabels('export','file',fullfile(pwd, '_res_repeatedMeasures_ttest.xlsx')); % % Export excelfile (enter proper filename for "myFILENAME" such as fullfile(pwd,'result_123.xlsx')) 


% [2] WITHIN: RUN Permutation-based paired t-test
v = [];
v.data         =  fullfile(pwd, 'repeatedMeasures_sampledata.xlsx'); % % excel data file
v.dataSheet    =  'table';                                           % % sheetname of excel data file
v.aux          =  fullfile(pwd, 'repeatedMeasures_group.xlsx');      % % excel group assignment file
v.auxSheet     =  'table';                                           % % sheetname of excel group assignment file
v.id           =  'animal';                                          % % name of the column containing the animal-id in the auxSheet
v.f1           =  'group';                                           % % name of the column containing the group-assignment in the auxSheet
v.subject      =  'subject';                                         % % within-test only: name of the column containing the subject-factor (same animal get the same number...for repeated measures)
v.f1design     =  [1];                                               % % type of test: [0]between, [1]within
v.typeoftest1  =  'permwithin';                                      % % applied  statistical test (such as "ranksum" or "ttest2")
v.tail         =  'both';                                            % % Type of alternative hypothesis: both|left|right 
v.regionsfile  =  '';                                                % % <optional> excelfile containing regions, only this regions will be tested
v.qFDR         =  [0.05];                                            % % q-threshold of FDR-correction (default: 0.05)
v.isfdr        =  [1];                                               % % use FDR correction: [0]no, [1]yes
v.showsigsonly =  [0];                                               % % show significant results only:  [0]no, show all, [1]yes, show signif. results only
v.issort       =  [1];                                               % % sort results according the p-value: [0]no, [1]yes,sort 
xstatlabels(v);      % % SET all Parameter   
xstatlabels('run');  % % RUN statistic
xstatlabels('export','file',fullfile(pwd, '_res_repeatedMeasures_perm.xlsx')); % % Export excelfile (enter proper filename for "myFILENAME" such as fullfile(pwd,'result_123.xlsx')) 





%% #################################################
% VOXELWISE-STATISTIC
% PART-1: PREPARATION, transform images to standard-space-->THOSE IMAGES WILL BE COMPARED LATER

cf;clear;
antcb('selectdirs','all'); %select all animals
%% ==============================================
%%  [1] trafo images to standard space
%% ==============================================
fi2trafo={...
    'c1t2.nii'
    'c2t2.nii'
    'fa.nii'
    'rd.nii'
    'ad.nii'
    'adc.nii'};
 
fis=doelastix(1, [],fi2trafo,1,'local');
img_ss=stradd(fi2trafo,['x_'],1); %images in standardSpace
 
%% ==============================================
%%   [2] multiplay/divide JD with GM
%% ===============================================
z.files={ ...
    'JD.nii'    'JD_gmMult.nii'  'mo: o=i1.*i;'
    'x_c1t2.nii'    ''           'i1' };
xrename(0,z.files(:,1),z.files(:,2),z.files(:,3) );
 
z.files={ ...
    'JD.nii'    'JD_gmDiv.nii'  'mo: o=i1./i;'
    'x_c1t2.nii'    ''           'i1' };
xrename(0,z.files(:,1),z.files(:,2),z.files(:,3) );



%% #################################################
% VOXELWISE-STATISTIC
% PART-2: RUN voxelwise statistic

cf;clear;clc

%% ========================================================
%% [1] set paramters
%% =========================================================
smoothvalue=0.28    ;% SMOOTHING:: if [0]: no smoothing; [0.28]: smooth with kernel 0.28mm

pamain     =antcb('getstudypath');       %get path of study
paout      =fullfile(pamain,'voxstat',['voxstat_smooth' num2str(smoothvalue)  ]);  %outputMain-Dir                    %PLEASE MODIFY: THE MAIN-OUTPUT-FOLDER
pagroup    =fullfile(pamain,'groups'); %path containing the groupfiles (Excelfilesfiles)
groupfiles =spm_select('FPList',pagroup,'^gr_.*.xlsx'); groupfiles=cellstr(groupfiles); %get all groupfiles

% ===[these images  will be tested]============================================
img={   %PLEASE MODIFY: THE IMAGES TO RUN THE VOXWISE ANALYSIS (MUST BE IN STANDARD-SPACE)
    'x_c1t2.nii'  'x_c2t2.nii' ...
    'x_fa.nii'    'x_rd.nii'     'x_ad.nii'    'x_adc.nii' ...
    'JD.nii'    'JD_gmMult.nii'    'JD_gmDiv.nii'
    };

%% ========================================================
%% [2] run voxwise-tests over groupfiles and images
%% =========================================================
if exist(paout)~=7; mkdir(paout); end
for j=1:length(groupfiles)
    groupfile=groupfiles{j};
    [~,comparison]=fileparts(groupfile);
    for i=1:length(img)
        [~,imgNameShort]=fileparts(img{i}); 
        z=[];
        z.stattype       = 'twosamplettest';           % % STATISTICAL TEST
        z.excelfile      = groupfile;                  % % [Excel-file]: file containing columns with animal-IDs and group/regressionValue and optional covariates
        z.sheetnumber    = [1];                                           % % sheet-index containing the data (default: 1)
        z.mouseID_col    = [1];% [1];                                           % % column-index containing the animal-IDs (default: 1)
        z.group_col      = [2];%[2];                                           % % column-index containing  the group assignment (default: 2)
        z.regress_col    = [];                                            % % <optional>  column-index/indices containing covariates (otherwise: empty)
        z.data_dir       = fullfile(pamain,'dat');                        % % main data directory (upper directory) containing the animal-dirs (default: the "dat"-dir of the study)
        z.inputimage     = img{i}   ;                                     % % name of the NIFTI-image to analyze ("data_dir" has to bee defined before using the icon)
        z.AVGT           = fullfile(pamain, 'templates', 'AVGT.nii');     % % [TEMPLATE-file]: select the TEMPLATE (default: fullpath-name of "AVGT.nii" from the templates-dir)
        z.ANO            = fullfile(pamain, 'templates', 'ANO.nii');      % % [ATLAS-file]: select the ATLAS (default: fullpath-name of "ANO.nii" from the templates-dir)
        z.mask           = fullfile(pamain, 'templates', 'AVGTmask.nii'); % % [MASK-file]: select the brain-maskfile (default: fullpath-name of "AVGTmask.nii" from the templates-dir)
        z.output_dir     = fullfile(paout, ['vx_' comparison '__' imgNameShort])  ;      % % path of the output-directory (SPM-statistic with SPM.mat and images)
        
        z.smoothing      = [0];                                           % % <optional>smooth data, [0|1]; if [1] the NIFTI is smoothed & stored with prefix "s" in the animal-dir, the smoothed image is than used for analysis
        z.smoothing_fwhm = repmat(0.28,[1 3]);                            % % smoothing width (FWHM); example: tripple of the voxsize of the inputimage
        if smoothvalue~=0
            z.smoothing      = [1];                                       % % <optional>smooth data, [0|1]; if [1] the NIFTI is smoothed & stored with prefix "s" in the animal-dir, the smoothed image is than used for analysis
            z.smoothing_fwhm = repmat(smoothvalue,[1 3]);                 % % smoothing width (FWHM); example: tripple of the voxsize of the inputimage
        end
        z.showSPMwindows = [1];                                           % % hide|show SPM-WINDOWS, [0|1]; if [0] SPM-windows are hidden
        z.showSPMbatch   = [1];                                           % % hide|show SPM-batch, [0|1]; usefull for evaluation and postprocessing
        z.runSPMbatch    = [1];                                           % % run SPM-batch, [0|1]; if [0] you have to start the SPM-batch by yourself,i.e hit the green triangle, [1] batch runs automatically
        z.showResults    = [1];                                           % % show results; [0|1]; if [1] voxelwise results will be shown afterwards
        xstat(0,z);                                                       % % Do not show GUI!
        xstat('fullreport');    % % MAKE FULL-REPORT, WRITE TABLES(XLS-FILES) & SUMMARIES (PPT-FILES), FOR [1]FWE,[2]CLUSTERBASED-APPROACH AND [3]UNCORRECTED, FOR ALL CONTRASTS
    end
end

%% ==============================================
%% [3]  merge PPTfiles with results
%% ===============================================
fclose('all');
fiprefix={'sum_CLUST' 'sum_FWE' 'sum_UNCOR'};
for i=1:length(fiprefix)
    fclose('all');
    [pptfiles] = spm_select('FPListRec',paout,['^' fiprefix{i} '.*.pptx']); pptfiles=cellstr(pptfiles);
    Fout=fullfile(paout,  [ regexprep(fiprefix{i}, 'sum_', 'summary_') '.pptx'] );
    [~,pptfileNames]=fileparts2(pptfiles);
    mergePPTfiles(Fout, pptfiles);
    showinfo2(['pptmain'],Fout);
end

%% #################################################
% VOXELWISE-STATISTIC
% posthoc: plots & tables

% [1] PLOTS: make othoplots & PPT for all peaks of sign. clusters of all sign maps (clusterbased approach)
v=[];
v.meth      ='clust';
v.copyexcel =1;
v.copyppt   =1;
v.indir     ='H:\Daten-2\Imaging\AG_Boehm_Sturm\Ratbrains_Iowa_2025_ana2\voxstat\voxstat_smooth 0';
makefig4spm(v);


% [2] TABLES: make single worddoc with tables of all sign. clusters of all sign maps (clusterbased approach)
paexcel='H:\Daten-2\Imaging\AG_Boehm_Sturm\Ratbrains_Iowa_2025_ana2\voxstatPlots\method_clust\xls';
docfile=export_spmtable(paexcel, struct('mergename',fullfile(fileparts(paexcel), 'resSig_clust_tables.docx')  ));


%% #################################################
% VOXELWISE-STATISTIC
% posthoc: extract [MEAN CLUSTER-VALUES] & make barplots & powerpoint

 
%% extract singlevalues and make barplots
cf;clear;
v.study     =antcb('getstudypath');
 
indir      =fullfile(v.study, 'voxstat','voxstat_unequalVar_smooth0');
outdir_main=fullfile(v.study, 'voxstat','voxstat_unequalVar_smooth0_plotsntabbles');

% ==================================================================================
%%  [part-1]: posthoc: extract [MEAN CLUSTER-VALUES] & make barplots & powerpoint
% ===================================================================================
% EXTRACT: MEAN CLUSTER-VALUES
extracttype  = 'cluster';
flt          = '.*CLUST.*.xlsx';
[fis]        = spm_select('FPListRec',indir,flt); fis=cellstr(fis);
v=struct();
v.indir  = fis;
v.type   = extracttype;
v.outdir = fullfile(outdir_main,['singlevalues_' extracttype '.xlsx']);
fo1      = rspm_extractvalues(v);
 
% MAKE PLOTS & PPT
v=struct();
v.infile  = fo1;%fullfile(pwd,'singlevalues_cluster.xlsx');
% v.plots = [1:2];
v.hide    = 1;
v.verbose = 0;
v.outdir  = fullfile(outdir_main,['barplots_'  extracttype 'png']);
fp1=rspm_barplots(v);
 
% ==================================================================================
%%  [part-2]: posthoc:  extract [Peak-VALUES] & make barplots & powerpoint
% ===================================================================================
% EXTRACT: PEAK-VALUES
extracttype  = 'peak';
flt          = '.*CLUST.*.xlsx';
[fis]        = spm_select('FPListRec',indir,flt); fis=cellstr(fis);
v=struct();
v.indir  =  fis;
v.type   = extracttype;
v.outdir = fullfile(outdir_main,['singlevalues_' extracttype '.xlsx']);
fo2      = rspm_extractvalues(v);
 
% MAKE PLOTS & PPT
v=struct();
v.infile  = fo2;%fullfile(pwd,'singlevalues_cluster.xlsx');
% v.plots = [1:2];
v.hide    = 1;
v.verbose = 0;
v.outdir  = fullfile(outdir_main,['barplots_'  extracttype 'png']);
fp2=rspm_barplots(v);
 
 
%% #################################################
% TFCE-VOXELWISE-STATISTIC
% PART-1: DATA-PREPARATION to run TFCE on maps in standard space(SS) 
% PART-2:  RUN TFCE ON HPC--> see below

%% ==============================================
%% [PART-1]: DATA-PREPARATION FOR TFCA on SS_maps
%% ==============================================
cf;clear;clc
addpath('D:\MATLAB\TFCEonHPC');      %path to TFCE-functions   
v.study      = antcb('getstudypath');%current ANTx-study ;example 'H:\Daten-2\Imaging\AG_Ambrozkiewicz'; %ANTx-study
v.pa_HPCmain = 'X:\mri\TFCE';        %main folder on HPC to work on
v.subdir     = 'TFCE_a2';            %subfolder in TFCE-study on HPC ('TFCE_a1','TFCE_a2' ...)
 
v.files      = {'x_c1t2.nii','x_c2t2.nii','JD.nii'...  % make voxstat for these maps
                'x_fa.nii'    'x_rd.nii'    'x_ad.nii'   'x_adc.nii'   };
v.groupfile  = fullfile(v.study,'group','Gruppenzuteilung_LGI1_NMDAR_mGo.xlsx'); %groupAssingment-file
v.animal_col = [1];  %animal-column
v.group_cols = [2];  %condition/factor-column(s)
 
v.pa_atl     = fullfile(v.study,'templates');  %path of templates with 'ANO.nii' & 'AVGT.nii'
v.minDist_mm = 1.0;  %min distance of peaks in cluster [in mm] (can be modified in part-2)
v.nPeaks     = 3;    %max peaks per cluster to resport (can be modified in part-2) 
v.HPC_hostname='s-sc-frontend2.charite.de'; %HPC-hostname
 
% ==============================================
%%   run this functions
% ===============================================
v=sub_makecontrasts(v); %create TFCE-contrasts
v=sub_writecontrast(v); %write contrasts and info to HPC
v=sub_write4Dnifti(v);  %write 4D-niftis (maps) to HPC
v=sub_exportscripts2HPC(v); %export HPC-scripts
v=sub_saveproject(v);  %save projects in <v.study>/<v.subdir>
 
%% ==============================================
%% [PART-2]:  RUN TFCE ON HPC
%% ==============================================
% The slurm batch will be displayed in the comand-window; example: "batch_TFCE_2025_NMDR_LGI1_a1.sh"
% NOW, RUN SHELL-SCRIPT ON HPC manually:
% HPC-execution run the following comand: 
% [cmd to show batchfile on HPC]: cat batch_TFCE_2025_NMDR_LGI1_a1.sh
% [cmd to run on HPC           ]: sbatch batch_TFCE_2025_NMDR_LGI1_a1.sh

%% #################################################
% TFCE-VOXELWISE-STATISTIC
% PART-3: make XLSX-file, PLOTS and PPT
% run this after runnng HPC-TFCE-calulation

%% ==============================================
%% [PART-3]: make XLSX-file, PLOTS and PPT
%% ==============================================
clear
addpath('D:\MATLAB\TFCEonHPC');
v.study      = antcb('getstudypath');
v.subdir     = 'TFCE_a2'; 
matfile=fullfile(v.study,v.subdir,'tfce.mat');
sub_loadconfig(matfile);
%% ===[make excel, PNGs and PPTs: default]====
t1_make_TFCEplots();
 
if 0  % specifc modificationd of the plots
    return
    %% ===[make excel, PNGs and PPTs: use specific plotParameter]===
    r=[];
    r.cursorwidth =  [0.3];
    r.clim        =  [nan 200 ; [3 8 ] ];      % [0.95 1 ]
    r.cmap        =  { 'gray' 'actc.lut'};
    t1_make_TFCEplots('plotparams',r)
    
    %% =[PLOTs: once excelfile is created, change plots only]===
    % use another output-DIR
    r.cursorwidth =  [0.3];
    r.clim        =  [nan nan ; [3 8 ] ];      % [0.95 1 ]
    r.cmap        =  { 'gray' 'NIH_ice.lut'};
    outdir='H:\Daten-2\Imaging\AG_Ambrozkiewicz\TFCE_a2\_modifplots';
    t1_make_TFCEplots('replot',r,'outdir', outdir );
    
    % displax availbale colormaps
    showinfo2(['colormaps'],which('colormaps.html'));
end
%% ====[make groupAverages]==================
t2_averagegroups();
%% ====[clusterPeaks: make excel and barplots]==========
if 0 %optional
    t3_barplots_peaks();
end
%% ====[clusterMean: make excel and barplots]==========
t4_barplots_cluster();



%% #################################################
% END
% end
                          oooo$$$$$$$$$$$$oooo
                      oo$$$$$$$$$$$$$$$$$$$$$$$$o
                   oo$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$o         o$   $$ o$
   o $ oo        o$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$o       $$ $$ $$o$
oo $ $ "$      o$$$$$$$$$    $$$$$$$$$$$$$    $$$$$$$$$o       $$$o$$o$
"$$$$$$o$     o$$$$$$$$$      $$$$$$$$$$$      $$$$$$$$$$o    $$$$$$$$
  $$$$$$$    $$$$$$$$$$$      $$$$$$$$$$$      $$$$$$$$$$$$$$$$$$$$$$$
  $$$$$$$$$$$$$$$$$$$$$$$    $$$$$$$$$$$$$    $$$$$$$$$$$$$$  """$$$
   "$$$""""$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$     "$$$
    $$$   o$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$     "$$$o
   o$$"   $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$       $$$o
   $$$    $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$" "$$$$$$ooooo$$$$o
  o$$$oooo$$$$$  $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$   o$$$$$$$$$$$$$$$$$
  $$$$$$$$"$$$$   $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$     $$$$""""""""
 """"       $$$$    "$$$$$$$$$$$$$$$$$$$$$$$$$$$$"      o$$$
            "$$$o     """$$$$$$$$$$$$$$$$$$"$$"         $$$
              $$$o          "$$""$$$$$$""""           o$$$
               $$$$o                 oo             o$$$"
                "$$$$o      o$$$$$$o"$$$$o        o$$$$
                  "$$$$$oo     ""$$$$o$$$$$o   o$$$$""
                     ""$$$$$oooo  "$$$o$$$$$$$$$"""
                        ""$$$$$$$oo $$$$$$$$$$
                                """"$$$$$$$$$$$
                                    $$$$$$$$$$$$
                                     $$$$$$$$$$"
                                       "$$$""""






















