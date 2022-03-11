% <b> script to perform two-sample voxel-wise statistic for several images and several groups   </b>
% in this example the following images will be compared in a voxel-wise way:
%     'x_adc.nii'
%     'x_ad.nii'
%     'x_fa.nii'
%     'x_rd.nii'
%     'x_c1t2.nii'
%     'JD.nii'
% for the following pairwise groups comparisons:
%    'CTRL' vs 'HR'     as defined in the excelfile: 'gc_CTRL_VS_HR.xlsx'           
%    'CTRL' vs 'LR'     as defined in the excelfile: 'gc_CTRL_VS_LR.xlsx'                
%      'HR' vs 'LR'     as defined in the excelfile: 'gc_HR_VS_LR.xlsx'
% 
% <font color=fuchsia><u>DESCRIPTION:</u></font>
% performs a voxelwise two-sample t-t-test for several images and several pairwise group-comparisons
% [1] variable "pastudy" defines the path of the study (this folder contains the "dat"-folder wiht the animal-data)
% [2] variable "images" contans the images   'x_adc.nii', 'x_ad.nii', 'x_fa.nii', 'x_rd.nii', 'x_c1t2.nii' and 'JD.nii'
%     which are tested in a vox-wise analysis (variable: "images")
%    (..thus the loop over the images)
% - the data is stored in the "z.data_dir"-folder
%       -each animal has it's own directory (this is the ANT-dat-structure),
%       -animal-IDs in the group-assignment file (excelfile) must match with the data-folder names
%
% - group-assignment is defined in the excelfile ('gc_CTRL_VS_HR.xlsx') located in the 'group'-folder
% - this excelfile (sheet-number:1) contains the animal-IDs ("z.mouseID_col") in the 1st column and the
%   belonging subgroup in column-2 ("z.group_col")
% [3] variable "outdirMain" is the main-output-directory (shortName)
%     This folder will contain image-based subfolders with the statistic.
%    -The output directory for each image and group-comparison is dynamically created within the "outdirMain"-folder
%    -The folder-name is constructed by a counter+imageName+groupcomparison(fileName) a
%    -For each image the respective output-folder contains the voxwise statistic (SPM.mat)
% [4] variable "groupfiles" is a list of excelfiles containing the subgroups that will be compared in a 
%     pairwise ways
%   In this example the excelfiles are:
%         'gc_CTRL_VS_HR.xlsx' with subgroup-definitions for the groups: CTRL & HR                
%         'gc_CTRL_VS_LR.xlsx' with subgroup-definitions for the groups: CTRL & LR                     
%         'gc_HR_VS_LR.xlsx'   with subgroup-definitions for the groups: HR & LR 
%  (..thus the loop over the groupfiles)
% 
% -here we use another Atlas as defined in "z.ANO": 'PTSDatlas.nii'
% -data will be not smoothed! (z.smoothing is "0")
% -SPM-batch is not shown (z.showSPMbatch is "0")
% -execution via xstat(0,z)  ...this is the silent mode (1st arg is "0", otherwise set to "1")
%
%% ________________________________________________________________________________________________

clc;
cf;clear;
warning off;

% ==============================================
%%   VARIABLE PARAMETER
% ===============================================
% [1] studyPATH: define studypath here
pastudy ='F:\data5\eranet_round2_statistic\voxstat'  ;% % study-path

% [2] images: define images for voxwise statistic
images={              % % perform voxel-wise statistic for the following images
    'x_adc.nii'
    'x_ad.nii'
    'x_fa.nii'
    'x_rd.nii'
    'x_c1t2.nii'
    'JD.nii'
    };
% [3] define output-directory (shortname)...will be located within the studyFolder
outdirMain='voxstat1'  ;%% main-output-directory (this folder will contain image-based subfolders with the respective statistic )

% [4] groupfiles: list of fullpath Excelfiles that define the pairwise) sub-groups
% obtained via prefix 'gc_'
pagroup='F:\data5\eranet_round2_statistic\voxstat\groups' ;% folder containing the groupfiles
[groupfiles] = spm_select('FPList',pagroup,'^gc_.*.xlsx'); groupfiles=cellstr(groupfiles);



% ==============================================
%%   LOOP over images and group-comparisons
% ===============================================

N=1; %counter for outputDir-prefix
%==========LOOP OVER IMAGES ====================
for i=1:length(images) % loop over each image
    %==========LOOP OVER group-comparisons ====================
    for g=1:length(groupfiles)
        cd(pastudy); % go back to studyPath
        imageNameExt=images{i}; % work on this image (filename+extension)
        [~, imageName ]=fileparts(imageNameExt); %get imageName without extentsion
        
        
        thisgroupfile=groupfiles{g};             % this excelfile defines the groups to compare
        [~,contrastName]=fileparts(thisgroupfile); %get contrastName
        contrastName=regexprep(contrastName,'^gc_',''); %remove prefix 'gc_'
        
        outdir=fullfile(pastudy,outdirMain,[ 'v' pnum(N,2) '_#' imageName '#_' contrastName ]); %final outputdirectory
        mkdir(outdir); %create directory
        
        
        cprintf([0 .5 1],[ '..RUNNING VOXWISE STATISTIC for "' imageNameExt '" [' contrastName '] \n']);
        z=[];
        z.stattype       = 'twosamplettest';                                      % % STATISTICAL TEST
        z.excelfile      = thisgroupfile;                                         % % [Excelfile]: this file contains a column with mouseIDs (names) and a column assigning the group
        z.sheetnumber    = [1];                                                   % % this sheet contains columns with mouseIDs and group assignment
        z.mouseID_col    = [1];                                                   % % column number with the MouseIDs
        z.group_col      = [2];                                                   % % column number with group assignment  (used when comparing groups, "regress_col" must be empty)
        z.data_dir       = fullfile(pastudy,'dat');                               % % data directory (upper directory) contains dirs with mice data
        z.inputimage     = imageNameExt;                                             % % image name (nifti) to run the statistic (datapath has to bee defined before using the icon)
        z.AVGT           = fullfile(pastudy,'templates',        'AVGT.nii');      % % select the TEMPLATE-file (path of "AVGT.nii")
        z.ANO            = fullfile(pastudy,'PTSDatlas_01dec20','PTSDatlas.nii'); % % select the ATLAS-file (path of "ANO.nii")
        z.grp_comparison = '1vs2';                                                % % groups to compare, use EXCELgroupnames(example: "GroupNameString1vsGroupNameString2") or alphabet. order (example: "1vs2"), or
        z.mask           = fullfile(pastudy,'templates','AVGTmask.nii');          % % <optional> use brainmask [select a mask or type "local" to use the AVGTmask.nii from the templates folder]
        z.smoothing      = [0];                                                   % % <optional>smooth data
        z.smoothing_fwhm = [0.28  0.28  0.28];                                    % % smoothing width (FWHM)
        z.output_dir     = outdir;                                                % % path for output/statistic
        z.showSPMbatch   = [0];                                                   % % [0|1] hide|show pipeline in SPM batch window, if [1] you have to run the code by yourself ( hit the green driangle), [0] piples runs automatically
        xstat(0,z); % % run voxel-wise statistic (1st arg, [0/1] no GUI/GUI)
        
        N=N+1 ;%UPDATE N-COUNTER
    end %groupfiles
end %images

cd(pastudy); %go back to study-folder








