%%  SNR map calculation of 2dseq with GUI
%   This script opens Bruker data and calculates SNR maps, output is NIFTI
%
%   - P. Boehm-Sturm July 2015

%%  Add relevant functions
usermatlabpath=userpath;
usermatlabpath=usermatlabpath(1:end-1);

addpath(fullfile(usermatlabpath,'nii'));
addpath(fullfile(usermatlabpath,'imageAnalysis'));
addpath(fullfile(usermatlabpath,'pvtools_bruker'));
addpath(genpath(fullfile(usermatlabpath,'pvtools_bruker')));

%% Input/output directories


% [FileName_2dseq,PathName_2dseq] = uigetfile('2dseq.*','Select the Bruker 2dseq file');
[~,PathName_2dseq] = uigetfile('2dseq.*','Select the Bruker 2dseq file','/Users/philippbohm-sturm/Documents/Postdoc/projects/');
if ~exist(fullfile(PathName_2dseq,'2dseq'))
    error('2dseq Bruker file not found in selected directory')
end
path_to_2dseq=fullfile(PathName_2dseq,'2dseq');    


PathName_2dseq = fileparts(path_to_2dseq);
Visu=readBrukerParamFile(fullfile(PathName_2dseq,'visu_pars'));
image_2dseq=readBruker2dseq(path_to_2dseq,Visu);

% extract parameters for saving NIFTI
voxelsize_2dseq=[Visu.VisuCoreExtent./Visu.VisuCoreSize Visu.VisuCoreFrameThickness];
voxelsize_2dseq=voxelsize_2dseq(1:3);
FileName_2dseq_base=[Visu.VisuSubjectId '_' num2str(Visu.VisuStudyNumber)...
    '_' num2str(Visu.VisuExperimentNumber) '_' num2str(Visu.VisuProcessingNumber)];



% more than 6D is not supported
if length(size(image_2dseq))>6
    error('Can only handle max 6D data');
end

% Select path to store the data

PathName_save = uigetdir(PathName_2dseq,'Select the directory to store NIFTI data');

%% SNR map calculation

[snrMap,estStd,h] = snrAuto(image_2dseq,2,10);


%% Data storage
FileName_2dseq=fullfile(PathName_save,[FileName_2dseq_base '.nii']);
FileName_snrMap=fullfile(PathName_save,[FileName_2dseq_base '_snr.nii']);

image_2dseq_nii=make_nii(image_2dseq, voxelsize_2dseq);
snrMap_nii=make_nii(snrMap, voxelsize_2dseq);

save_nii(image_2dseq_nii,FileName_2dseq);
save_nii(snrMap_nii,FileName_snrMap);


