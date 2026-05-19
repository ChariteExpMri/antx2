function snips_input2

snips
return


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






















