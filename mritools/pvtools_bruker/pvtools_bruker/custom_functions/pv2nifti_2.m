%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% This script reads in Raw Data from Bruker Paravision
% and converts it into NIFTI data format
%  
% Usage: call pv2nifti.m from the MATLAB command window 
%
%
% P. Boehm-Sturm, 2015
%% ==== Initialize ========================================================
% Add paths to needed functions to MATLAB search path

% addpath('~/Documents/MATLAB/nii');
% addpath('~/Documents/MATLAB/pvtools_bruker/custom_functions/');
% addpath('~/Documents/MATLAB/pvtools_bruker');
% addpath(genpath('~/Documents/MATLAB/pvtools_bruker'));


addpath('e:\DTI\nii')
addpath(genpath('e:\DTI\pvtools_bruker\pvtools_bruker'))

% Ask for 2dseq file
[FileName_2dseq,PathName_2dseq] = uigetfile('2dseq','Select the Bruker 2dseq file');
if ~exist([PathName_2dseq '2dseq'])
    error('2dseq Bruker file not found in selected directory')
end
if ~exist([PathName_2dseq 'visu_pars'])
    error('visu_pars Bruker file not found in selected directory')
end
    
path_to_2dseq=fullfile(PathName_2dseq,'2dseq');    


PathName_2dseq = fileparts(path_to_2dseq);
Visu=readBrukerParamFile(fullfile(PathName_2dseq,'visu_pars'));
image_2dseq=readBruker2dseq(path_to_2dseq,Visu); 


% Ask for directory to store the data

PathName_save = uigetdir(PathName_2dseq,'Select the directory to store NIFTI data');



%====Generate NIFTI files and store them in directory==========

% Extract header info for NIFTI storage
voxelsize_2dseq=[Visu.VisuCoreExtent./Visu.VisuCoreSize Visu.VisuCoreFrameThickness];
voxelsize_2dseq=voxelsize_2dseq(1:3);


image_2dseq=squeeze(image_2dseq);

% Convert the extracted image to Nifti and store
image_2dseq_nii=make_nii(image_2dseq, voxelsize_2dseq);

% Filenames
FileName_2dseq_base=[Visu.VisuSubjectId '_' num2str(Visu.VisuStudyNumber)...
    '_' num2str(Visu.VisuExperimentNumber) '_' num2str(Visu.VisuProcessingNumber)];
FileName_2dseq=fullfile(PathName_save,[FileName_2dseq_base '.nii']);

% Store
display(['saving ' FileName_2dseq]);
save_nii(image_2dseq_nii,FileName_2dseq);

clear;
