

%% <b> % -run DTI-statistic,create matrix-plots and ball-n-stick-plots, save plots as PPT, save tables as Excelfiles </b>
% This script does the following:
% - STATISTICAL TESTS:  'ttest2' and 'WST'  in combination with/without proportional threshold
% - plot DTI-results as matrix-layout, save as Powerpoint-file
% - EXPORT SINGNIF(FDR)-results as Excelfile FOR XVOL3D
% - MAKE BALL-N-STICK-IMAGES
% - MAKE POWERPOINT FROM ALL BALL-N-STICK-IMAGES (all views as montage)
% 
% <b>  MANDATORY INPUTS:  </b>  see "(1) USER-DEFINED INPUTS"
% 
% ==============================================


cf;  clear; warning off
% ==============================================
%%  1) USER-DEFINED INPUTS (PLEASE MODIFY)
% ===============================================
x=struct();
x.pastudy       ='f:\data6\DTI_thomas_reduceMatrix'       ;% STUDY-folder 
x.resultDir     ='result_DTI_reducedCON2_Rev3'                 ;% NAME of OUTPUT-FOLDER (SHORTNAME) ..this folder will be created
x.groupingfile  =fullfile(x.pastudy,'group','groupassignment.xlsx') ; %group-assignment File (Excel-file)
x.outdirPrefix  ='resDTI_'                                ;% prefix of the new output-subdir-folders (located within "x.resultDir")

%--------using reduced data-matric via COI-file --------
x.confiles      ='connectome_di_sy__RED1.csv'             ;% DTI-weight-matrix (csv-file)... created by MRtrix 
x.lutfile       ='LUT_connectome_di_sy__RED1.txt'         ;% DTI-label file (txt-file)... created by MRtrix
%--------using the orignal data --------
% x.confiles   ='connectome_di_sy.csv'                    ;% DTI-weight-matrix (csv-file)... created by MRtrix
% x.lutfile    ='atlas_lut.txt'                           ;% DTI-label file (txt-file)... created by MRtrix

x.atlas    =fullfile(x.pastudy,'schmitzAtlas301022\SchmitzAtlas_301022.xlsx'); %DTI-atlas (use Excel-file)
x.hemiMask =fullfile(x.pastudy,'templates','AVGThemi.nii');                    %hemispheric mask (used for xvol3d)
x.mask     =fullfile(x.pastudy,'templates','AVGTmask.nii');                    %brain mask (used for xvol3d)


% ==============================================
%%  2)  STATISTICAL TESTS
% ===============================================
conpath    =fullfile(x.pastudy, 'dat');            % main path to data (dat-folder)
stattest   ={'ttest2' 'WST'};                       % staistical tests
propthresh =[0 1];                                  % without & with proportional threshold
combs=allcomb(stattest,num2cell(propthresh));

 
for i=1:size(combs,1)
    stattest    =combs{i,1};
    thresh  =combs{i,2};  
    
    OUTfileName    =[stattest  '_proptr' num2str(thresh)  ];
    OUTDIR         =[x.outdirPrefix OUTfileName]; 
    resultDirFP    =fullfile(x.pastudy,x.resultDir, OUTDIR)  ;% create folder for results (xls-files/mat-file)
    
  
    % ==============================================
    %%   2.1) SET PARAMETER
    % ===============================================
    dtistat
    dtistat('set','inputsource','MRtrix' );
    dtistat('group', x.groupingfile);                        % % LOAD groupAssignment (ExcelFile)
    dtistat('conpath', conpath ,'confiles', x.confiles  ,'labelfile',x.lutfile); % % LOAD connectivity-Files & LUTfile
    dtistat('set','within',0,'test',stattest,'tail','both' );
    dtistat('set','FDR',1,'qFDR',0.05,'showsigsonly',1,'sort',1,'rc',0 );
    dtistat('set','nseeds',1000000,'propthresh',thresh,'thresh','max','log',1 );
    
    % ==============================================
    %% 2.2) CALCULATE AND SHOW RESULTS
    %  [1] calc, [2] showresult,
    % ==============================================
    dtistat('calcconnectivity'); % % CALCULATION (uncomment line to execute)
    dtistat('showresult');       % % SHOW RESULT (uncomment line to execute)
    
    % ===============================================
    %% 2.3) SAVE CALCULATION AND EXPORT SIGNIFICANT RESULTS
    % ===============================================
    [~,xlsname]=fileparts(x.groupingfile); % get group-assignment-file
    
    dtistat('savecalc',fullfile(resultDirFP,['calc_'    OUTfileName '.mat']));  % %save calculation
    dtistat('export'  ,fullfile(resultDirFP,['resSIG_' OUTfileName '.xlsx']),'exportType',1);  % %save Result as ExelFile
    
    % ==============================================
    %%  2.4) EXPORT ALL RESULTS (ALSO NOT SIGNIFICANT RESULTS)
    % ===============================================
    dtistat('set','showsigsonly',0); % show all results
    dtistat('showresult','ResultWindow',0);% update result. but do not show the result
    dtistat('export'  ,fullfile(resultDirFP,['resALL_' OUTfileName '.xlsx']),'exportType',1);  % %save Result as ExelFile
end


% ==============================================
%%   3) plot DTI-results as matrix-layout, save as Powerpoint-file
% ===============================================
% This script does the following:
% <b><u><font color="fuchsia"> (1) calculation using "dtistat.m" has to be done and saved (as mat-file) before  </font></b></u>
% -results are stored in a powerpoint-file, which is stored in the same folder
%  as the calculation (mat-file) is located
% The PPT-file contains the plots in matrix-layout for different p-values and FDR-correciton
%
% <b>  MANDATORY INPUTS:  </b>
%  matfile: matfile containing the saved calculation generated via "dtistat.m"
%  atlas  : the atlas (excelfile) used for DTI-prepreprocessing
% ==============================================

pax=fullfile(x.pastudy,x.resultDir)  ;%main Folder with calculations
[files] = spm_select('FPListRec',pax,'^calc.*.mat');
files=cellstr(files);

for i=1:length(files)
    matfile=files{i};
    dtistat('loadcalc',matfile);
    [pam fi ext]=fileparts(matfile);
    pptfile=fullfile(pam,['resPlot_'  regexprep(fi,{'^calc_'},{''})  '.pptx']);
    dtistat('summaryplot','atlas',x.atlas,'pptfile',pptfile);
end




% ========================================================================
%%  4) EXPORT SINGNIF(FDR)-results as Excelfile FOR XVOL3D
% =========================================================================

pax=fullfile(x.pastudy,x.resultDir)  ;%main Folder with calculations
[files] = spm_select('FPListRec',pax,'^calc.*.mat');
files=cellstr(files);

for i=1:length(files)
    matfile=files{i};
    dtistat('loadcalc',matfile);
    
    %--------------------
    [outdir fi ext]=fileparts(matfile);
    z=[];
    z.ano           = x.atlas;%'F:\data6\DTI_thomas_reduceMatrix\schmitzAtlas301022\SchmitzAtlas_301022.nii';     % % select corresponding DTI-Atlas (NIFTI-file); such as "ANO_DTI.nii"
    z.hemi          = x.hemiMask;                         % % select corresponding Hemisphere Mask (Nifti-file); such as "AVGThemi.nii"
    z.cs            = 'diff';                                                                            % % connection strength (cs) or other parameter to export/display via xvol3d
    z.sort          = [1];                                                                               % % sort connection list: (0)no sorting ; (1)sort after CS-value; (2)sort after p-value;
    z.outDir        = outdir;                                         % % output folder
    z.filePrefix    = 'export_';                                                                             % % output filename prefix (string)
    % z.fileNameConst = '$filePrefix_$contrast_$keep';                                                     % % resulting fileName is constructed by...
    z.fileNameConst = '$filePrefix_$contrast_$keep';                                                     % % resulting fileName is constructed by...
    z.contrast      = 'control vs hyperoxia';                                                            % % constrast to save (see list (string) or numeric index/indices)
    z.keep          = 'FDR';                                                                          % % connections to keep in file {'all' 'FDR' 'uncor' 'manual selection' 'p<0.001' 'p<0.0001'}
    z.underscore    = [0];                                                                               % % {0,1} underscores in atlas labels:  {0} remove or {1} keep
    z.LRtag         = [1];                                                                               % % {0,1} left/right hemispheric tag in atlas labels:  {0} remove or {1} keep
    dtistat('export4xvol3d',z,'gui',0);
end






% ==============================================
%%   5)  MAKE BALL-N-STICK-IMAGES
% ===============================================
pax=fullfile(x.pastudy,x.resultDir)  ;%main Folder with calculations
[files] = spm_select('FPListRec',pax,'^export_.*FDR.*.xlsx');
files=cellstr(files);

for i=1:length(files)
    file=files{i};
    if isempty(file); 
        disp(['file for xvol3d not found (reason: either not exported or no surviving connections)']);
        continue; 
    end
    %--------------------
    [paIN fi ext]=fileparts(file);
    paOUT=fullfile(paIN,'images');
    disp(paOUT);
        
    % ===============================================
    %  [xvol3] main-gui properties
    % ===============================================
    close all;  %close all figures
    p=[];
    p.gen.info_______=' *** GENERAL PARAMETER ***';
    p.gen.mask                  =x.mask;  %maksfile
    p.gen.view=[-62.3  45.2];
    p.gen.brainColor=[0.9333  0.9333  0.9333];
    p.main.info_______=' *** MAIN PARAMETER [xvol3d-window]*** ';
    p.main.showarrows=[1];
    p.main.braindot=[0];
    p.main.brainalpha='0.05';
    p.main.material=[2];
    p.main.notused_material='shiny';
    p.main.rblight=[1];
    
    % ===============================================
    %   [xvol3]   connections properties
    % ===============================================
    p.con.filenode             =file ;%'F:\data6\DTI_thomas_reduceMatrix\result_DTI_reducedCON\resDTI_ttest2_proptr0\export__control_vs_hyperoxia_p0.01.xlsx';
    p.con.lab.dummi=[1];
    p.con.lab.fs=[7];
    p.con.lab.fcol=[0  0  0];
    p.con.lab.fhorzal=[2];
    p.con.lab.needlevisible=[0];
    p.con.lab.needlelength=[0];
    p.con.lab.needlecol=[0  0  0];
    p.con.lab.abbreviate=[0];
    p.con.lab.abbreviationLength=[3];
    p.con.lab.useNumbers=[1];
    p.con.sting.dummi=[1];
    p.con.sting.stingview=[1];
    p.con.sting.linestyle=':';
    p.con.sting.linewidth=[0.8];
    p.con.sting.linecol=[0.7  0.7  0.7];
    p.con.sting.fs=[7];
    p.con.sting.fontbold=[1];
    p.con.sting.fontcol=[0  0  0];
    p.con.sting.isdebug=[0];
    p.con.sting.radiusfac=[1.1];
    p.con.sting.sepmax=[10];
    p.con.sting.pointsfac=[250];
    p.con.sting.volcenter=[1];
    p.con.t.col1={ '0 0.5 0' };
    p.con.t.R1={ '2' };
    p.con.t.T1={ '1' };
    p.con.t.Lcol={ '0 0 1' };
    p.con.t.LR={ '1' };
    p.con.t.LT={ '1' };
    p.con.win.nodelabel=[1];
    p.con.win.stingview=[1];
    p.con.win.selectAll=[1];
    p.con.win.allnodes=[1];
    p.con.win.alllinks=[1];
    p.con.win.instantUpdate=[1];
    p.con.win.selectRow=[0];
    p.con.win.CS2RAD=[1];
    p.con.win.CS2RADexpression='*1.5+.3';
    p.con.win.linkintensity=[1];
    p.con.win.colorlimits='-.5 .5 ';
    p.con.win.linkcolormap=[61];
    %-----load xvol3-properties-----------------------
    xvol3d('loadprop',p); % load properties
    
    
    % ==============================================
    %   save images
    % ===============================================
    s.saveimg_edPath      = paOUT;% 'F:\data6\DTI_thomas_reduceMatrix\result_DTI_reducedCON\resDTI_ttest2_proptr0\images';     % outpot path for image(s)
    s.saveimg_rdTimeStamp =  [0];     % add timeStamp to image-filename {0,1}
    s.saveimg_edPrefix    =  'v';     % prefix for image-filename {string}
    s.saveimg_popResol    =  [1];     % image resolution {pulldown-index}
    s.saveimg_popFormat   =  [1];     % image-format {pulldown-index}
    s.saveimg_popViewType =  [2];     % view-type {pulldown-index}; (1)current view; (2) all views
    s.saveimg_edCropTol   =  '20';     % crop-tolerance (in pixel) applies only if [saveimg_rdCrop] is 1
    s.saveimg_rdHideCbar  =  [1];     % hide colorbar {0,1}
    s.saveimg_rdCrop      =  [1];     % crop image {0,1}
    xvol3d('saveimg',s,'closeGUI',0 ); % cmd to save image(s) keep GUI open
    
   
    
end


% ==============================================================================
%%   6) MAKE POWERPOINT FROM ALL BALL-N-STICK-IMAGES (all views as montage)
% ===============================================================================
cf
pax=fullfile(x.pastudy,x.resultDir)  ;%main Folder with calculations
[imgDirs] = spm_select('FPListRec',pax,'dir','^images$');
if isempty(imgDirs);
    disp(['could not make PPT.. (reason: either Excelfile not exported or no surviving connections)']);
    return; 
end
imgDirs=cellstr(imgDirs);

for i=1:length(imgDirs)
    pain   =imgDirs{i};
    FileOut=fullfile(  fileparts(pain)   , 'ballnsticks.pptx');
    ballnstick2ppt(pain,FileOut); 
end















