% <b> script to perform two-sample voxel-wise statistic for several images    </b>
% in this example the following images will be compared betweeen two groups:
%     'JD.nii'
%     'x_c1t2.nii'
% 
% <font color=fuchsia><u>DESCRIPTION:</u></font>
% performs a voxelwise two-sample t-t-test for several images.
% - variable "pastudy" defines the path of the study (this folder contains the "dat"-folder wiht the animal-data)
% - Here the images "JD.nii" and "x_c1t2.nii" are tested in a vox-wise analysis (variable: "images")
%    (..thus the loop over the images)
% - the data is stored in the "z.data_dir"-folder
%       -each animal has it's own directory (this is the ANT-dat-structure),
%       -animal-IDs in the group-assignment file (excelfile) must match with the data-folder names
% 
% - group-assignment is defined in the excelfile ('gc_CTRL_VS_HR.xlsx') located in the 'group'-folder
% - this excelfile (sheet-number:1) contains the animal-IDs ("z.mouseID_col") in the 1st column and the
%   belonging subgroup in column-2 ("z.group_col")
% 
% -here we use another Atlas as defined in "z.ANO": 'PTSDatlas.nii'
% -data will be not smoothed! (z.smoothing is "0")
% -output directory is defined in "z.output_dir": here stored in the folder "voxstat_test2" within the
%  study-folder. This folder contains a subfolder for each image (folder name is defined by the image-name)
%  -for each image the respective output-folder contain the voxwise statistic (SPM.mat)
% -SPM-batch is not shown (z.showSPMbatch is "0")
% -execution via xstat(0,z)  ...this is the silent mode (1st arg is "0", otherwise set to "1")
%
%% ________________________________________________________________________________________________


cf;clear;cf


pastudy='F:\data5\eranet_round2_statistic\voxstat'  ;% % study-path
images={              % % perform voxel-wise statistic for the following images
    'JD.nii'
    'x_c1t2.nii'
    };
outdir='voxstat_test2'  ;%% main-output-directory (this folder will contain image-based subfolders with the respective statistic )


for i=1:length(images) % loop over each image
    cd(pastudy); %
    imageName=images{i};
    [~, outdirSub ]=fileparts(imageName);
    cprintf([0 .5 1],[ '..RUNNING VOXWISE STATISTIC for "' imageName '" \n']);
    
    z=[];
    z.stattype       = 'twosamplettest';                                      % % STATISTICAL TEST
    z.excelfile      = fullfile(pastudy, 'groups','gc_CTRL_VS_HR.xlsx');      % % [Excelfile]: this file contains a column with mouseIDs (names) and a column assigning the group
    z.sheetnumber    = [1];                                                   % % this sheet contains columns with mouseIDs and group assignment
    z.mouseID_col    = [1];                                                   % % column number with the MouseIDs
    z.group_col      = [2];                                                   % % column number with group assignment  (used when comparing groups, "regress_col" must be empty)
    z.data_dir       = fullfile(pastudy,'dat');                               % % data directory (upper directory) contains dirs with mice data
    z.inputimage     = imageName;                                             % % image name (nifti) to run the statistic (datapath has to bee defined before using the icon)
    z.AVGT           = fullfile(pastudy,'templates',        'AVGT.nii');      % % select the TEMPLATE-file (path of "AVGT.nii")
    z.ANO            = fullfile(pastudy,'PTSDatlas_01dec20','PTSDatlas.nii'); % % select the ATLAS-file (path of "ANO.nii")
    z.grp_comparison = '1vs2';                                                % % groups to compare, use EXCELgroupnames(example: "GroupNameString1vsGroupNameString2") or alphabet. order (example: "1vs2"), or
    z.mask           = fullfile(pastudy,'templates','AVGTmask.nii');          % % <optional> use brainmask [select a mask or type "local" to use the AVGTmask.nii from the templates folder]
    z.smoothing      = [0];                                                   % % <optional>smooth data
    z.smoothing_fwhm = [0.28  0.28  0.28];                                    % % smoothing width (FWHM)
    z.output_dir     = fullfile(pastudy,outdir,outdirSub) ;                    % % path for output/statistic
    z.showSPMbatch   = [0];                                                   % % [0|1] hide|show pipeline in SPM batch window, if [1] you have to run the code by yourself ( hit the green driangle), [0] piples runs automatically
    xstat(0,z); % % run voxel-wise statistic (1st arg, [0/1] no GUI/GUI)
end

cd(pastudy); %go back to study-folder









