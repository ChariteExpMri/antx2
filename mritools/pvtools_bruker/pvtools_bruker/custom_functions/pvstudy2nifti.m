%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% This script reads in Raw Data from Bruker Paravision study
% and converts all scans into NIFTI data format
%  
% Usage: call pv2nifti.m from the MATLAB command window 
%
%

%% ==== Initialize ========================================================
% Add paths to needed functions to MATLAB search path

addpath('~/Documents/MATLAB/nii');
addpath('~/Documents/MATLAB/pvtools_bruker/custom_functions/');
addpath('~/Documents/MATLAB/pvtools_bruker');
addpath(genpath('~/Documents/MATLAB/pvtools_bruker'));

% cell array to store files for which conversion did not work
failedFiles={};

% Ask for pv Study directory
PathName_pvstudy = uigetdir('','Select the Bruker study directory');

% Ask for directory to store the data

PathName_save = uigetdir(PathName_pvstudy,'Select the directory to store NIFTI data');

% get cell array of scan subdirectories
d = dir(PathName_pvstudy);
isub = [d(:).isdir];
nameFolds = {d(isub).name}';
nameFolds(ismember(nameFolds,{'.','..','AdjResult'})) = [];

%Loop through scan folders

for i=1:length(nameFolds)
    % get cell array of reco subdirectories
    sd=dir(fullfile(PathName_pvstudy,nameFolds{i},'pdata'));
    idsub = [sd(:).isdir];
    nameSubfolds = {sd(idsub).name}';
    nameSubfolds(ismember(nameSubfolds,{'.','..'})) = [];
    
    %Loop through reco folders
    for j=1:length(nameSubfolds)

        % Try to open 2dseq File
        
        try
            PathName_2dseq=fullfile(PathName_pvstudy,nameFolds{i},'pdata',nameSubfolds{j});
            path_to_2dseq=fullfile(PathName_2dseq,'2dseq');
            
            % open 2dseq
            Visu=readBrukerParamFile(fullfile(PathName_2dseq,'visu_pars'));
            image_2dseq=readBruker2dseq(path_to_2dseq,Visu);
            
            % remove unnecessary dimensions
            image_2dseq=squeeze(image_2dseq);
            
            %====Generate NIFTI files and store them in directory==========

            % Extract header info for NIFTI storage
            voxelsize_2dseq=[Visu.VisuCoreExtent./Visu.VisuCoreSize Visu.VisuCoreFrameThickness];
            voxelsize_2dseq=voxelsize_2dseq(1:3);
            
            % Convert the extracted image to Nifti and store
            image_2dseq_nii=make_nii(image_2dseq, voxelsize_2dseq);
            
            % Filenames
            FileName_2dseq_base=[Visu.VisuSubjectId '_' num2str(Visu.VisuStudyNumber)...
                '_' num2str(Visu.VisuExperimentNumber) '_' num2str(Visu.VisuProcessingNumber)];
            FileName_2dseq=fullfile(PathName_save,[FileName_2dseq_base '.nii']);
            
            % Store
            display(['saving ' FileName_2dseq]);
            save_nii(image_2dseq_nii,FileName_2dseq);   
 
        catch exception
            msgString = getReport(exception);
            warning(msgString);
            warning(['Could not open/find 2dseq file in directory: ' PathName_2dseq]);
            continue
        end % end try/catch
    end % end loop through reco subfolders
end % end loop through scan subfolders

   

clear;
