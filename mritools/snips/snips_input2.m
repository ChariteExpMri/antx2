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
paout      =fullfile(pamain,'voxstat',['voxstat_smooth ' num2str(smoothvalue)  ]);  %outputMain-Dir                    %PLEASE MODIFY: THE MAIN-OUTPUT-FOLDER
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



