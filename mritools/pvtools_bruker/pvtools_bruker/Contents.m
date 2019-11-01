% Useful commands and files
%
%
% Set paths:
%   To access help for pvmatlab functions, please first execute addBrukerPaths.m 
%   to add the subfolders to your matlab path and restart doc Contents.m
%
% Accessing help:
%   doc                     - opens the Matlab help-browser, 
%                             e.g. doc RawDataObject or doc convertFrameToCKData
%   help                    - M-file help, displayed at the command line, 
%                             e.g. help RawDataObject
%   lookfor                 - Search all M-files for keyword.
%   methods                 - shows methods of an object, 
%                             e.g. methods RawDataObject
%   methodsview             - shows methods and additional information of an object in a seperate window, 
%                             e.g. methodsview RawDataObject
%   properties              - shows variables of an object,
%                             e.g. properties RawDataObject
%
% Objects / Classes:
%   RawDataObject           - reads and stores MRI raw data (fid files and job files) and parameters (e.g., ACQP files, method files)
%   FrameDataObject         - creates and stores framedata and parameter structs
%   CKDataObject            - creates and stores k-space data, parameter structs and adds the viewer function to view images
%   ImageDataObject         - reads and stores image data, writes image data to ParaVision, stores parameter structs, starts the viewer
%
%
% Examples:
%   BrukerExample           - An example script with the most common use cases, see also chapter "Quick Start" in the manual
%
%
%
% Expert usage
%
% Base-functions:
%   readBrukerParamFile     - reads Bruker JCAMP parameter files
%   readBrukerRaw           - reads Bruker raw-data files (fid file and job files)
%   convertRawToFrame       - sorts the scans from readBrukerRaw to frames
%   convertFrameToCKData    - sorts the frames form convertFrameToCKData to a k-space matrix,
%                             currently only supports RARE, FLASH, MSME, FISP
%   readBruker2dseq         - reads 2dseq file (image data) from disk
%   brViewer                - starts a viewer application that supports k-space data and images
%
% More useful files in this package
%   bruker_addParamValue    - a small function to parse optional input-arguments
%   bruker_combineStructs   - combines two structs to one
%   bruker_findDataname     - a small function to search for file names in a directory and its subdirectories
%   bruker_freqimage        - converts ONE 4D k-space frame into an image (freq->image), uses only fft and fftshifts
%   bruker_imagefreq        - converts ONE 4D image-frame into k-space (image->freq), uses only ifft and fftshifts
%   bruker_reco             - Performs an image reconstruction based on the most important ParaVision reco steps
%   bruker_requires         - fast check if structs contain certain variables
%   bruker_genVisu          - generates a visu parameter set to export your dataset to ParaVision
%   bruker_write2dseq       - writes a 2dseq (image data) file onto disk
%   bruker_writeVisu        - writes a visu_pars file (exportVisu) onto disk
%   bruker_version          - shows version information for pvmatlab
%   bruker_getSelectedReceivers  - returns the number of receivers used from an Acqp struct
%   bruker_genSlopeOffsMinMax    - calculates the offset, data slope, mins and maxs for writing images to disk 
%   bruker_getFrameGroupParams   - converts dependent Frame-Group variables into a matrix struct with FrameGroupDimensions
%   bruker_getTranspositionFrame - generates one frame of the data set with transposition 
%   bruker_setTranspositionFrame - adds one frame to a data set, considering the transposition


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Copyright (c) 2013
% Bruker BioSpin MRI GmbH
% D-76275 Ettlingen, Germany
%
% All Rights Reserved
%
% $Id: Contents.m,v 1.2 2013/05/24 13:29:26 haas Exp $
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

