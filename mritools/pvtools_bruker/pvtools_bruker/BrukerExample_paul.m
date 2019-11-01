%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Copyright (c) 2013
% Bruker BioSpin MRI GmbH
% D-76275 Ettlingen, Germany
%
% All Rights Reserved
%
% $Id: BrukerExample.m,v 1.2.4.1 2014/05/23 08:43:51 haas Exp $
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% This script demonstrates the basic functions of the pvmatlab package and
% how to use them:
%  
%  - Importing raw data into MATLAB workspace 
%  - Reconstructing the imported raw data 
%  - Importing images reconstructed by ParaVision into MATLAB workspace
%
% Usage: Change to pvmatlab base directory and call BrukerExample.m from 
%        the MATLAB command window 
%
%        You can also open BrukerExample.m in the MATLAB Editor and run the 
%        use cases separately, executing the respective cell with Ctrl+Enter 
%

%% ==== Initialize ========================================================
% Add paths to pvmatlab functions to MATLAB search path
% addBrukerPaths;
% 
% % Determine base directory (location of this script)
  baseDir = fileparts(mfilename('fullpath'));

% Specify location of test data (5 slices of a kiwi).
% pathTestData = fullfile(baseDir,['TestData', filesep, '2', filesep ,'pdata', filesep, '1']);
pathTestData ='E:\DTI\DTI_example\20141117_111005_20141117_TF_002_m14_1_1\6\pdata\1'

%% ==== Importing rawData =================================================

display(['- Importing raw data from ' pathTestData]);

% Create a RawDataObject, importing the test data
rawObj = RawDataObject(pathTestData);
    
% rawObj now contains the raw data and parameters associated with it, for 
% example the number of images and phase encodes:
numSlices = rawObj.Acqp.NI;
numPhases = rawObj.Acqp.ACQ_size(2);
display(['  Number of images        = ' num2str(numSlices)]);
display(['  Number of phase encodes = ' num2str(numPhases)]);

% Plot one line of raw data from third slice. Note that all lines of 
% all slices are concatenated in the second dimension of the data field
h = figure;
plot(real(rawObj.data{1}(1,:,2*numPhases+numPhases/2-1)),'-b'); hold on;
plot(imag(rawObj.data{1}(1,:,2*numPhases+numPhases/2-1)),'-r');
title('One line of raw data');
legend('real','imag');

%% 
input('Press Enter to continue'); 
if ishandle(h), close(h); end
display(' ');

%% ==== Creating a FrameDataObject and a Cartesian k-Space-Data object ====

display('- Creating frame data from the imported raw data');

% Create a FrameDataObject from the imported RawDataObject
frameObj = FrameDataObject(rawObj);
    
% The sizes of the data field in the resulting frameObj are now
% (ScanSize, numScansPerFrame, numReceiveChannels, numObjects, numRepetitions)
display(['  Frame dimensions: ', num2str(size(frameObj.data))]);

display('- Creating and displaying Cartesian k-space from frame data');

% Create a Cartesian k-space data object from the imported FrameDataObject
% (Currently this works only with FLASH, MSME, RARE and FISP)
kdataObj = CKDataObject(frameObj);
    
% The k-space data is now contained in kdataObj.data. The kdataObj viewer 
% method can be used to display it
kdataObj.viewer;
h = gcf;

clear rawObj frameObj kdataObj;
    
%% 
input('Press Enter to continue'); 
if ishandle(h), close(h); end
display(' ');
    
%% ==== Create frame data or k-space data directly ========================

display('- Importing frame data directly');

% It is also possible to create a FrameDataObject directly from the files, 
% without first using a RawDataObject
direct_frameObj = FrameDataObject(pathTestData);

display(['  Direct frame dimensions: ', num2str(size(direct_frameObj.data))]);
    
display('- Importing Cartesian k-space directly and displaying');

% It is also possible to create a CKDataObject directly from the files,
% without first creating a RawDataObject or FrameDataObject
% (Currently this works only with FLASH, MSME, RARE and FISP)
direct_kdataObj = CKDataObject(pathTestData);
    
% The k-space data is now contained in direct_kdataObj.data. The viewer 
% method can be used to display it
direct_kdataObj.viewer;
h = gcf;

clear direct_frameObj;
clear direct_kdataObj;

%% 
input('Press Enter to continue'); 
if ishandle(h), close(h); end
display(' ');

%% ==== Reconstructing imported k-space data ==============================

display('- Cartesian k-space import, reconstruction and image display');

% Import k-space data
kdataObj = CKDataObject(pathTestData);

% Read reco parameter file
kdataObj = kdataObj.readReco;
    
% Start reconstruction with 'all' recosteps and generate an 'image' object
% 'all' = {'quadrature', 'phase_rotate', 'zero_filling', 'FT',
%          'sumOfSquares', 'transposition'}
% For documentation on the reco run: doc CKDataObject.reco
imageObj=kdataObj.reco('all', 'image');

% open viewer
imageObj.viewer;
h = gcf;

clear imageObj;

%% 
input('Press Enter to continue'); 
if ishandle(h), close(h); end
display(' ');

%% ==== Read an image reconstructed by ParaVision =========================

display('- Importing and displaying images reconstructed by ParaVision');

% Import reconstructed images
imageObj = ImageDataObject(pathTestData);

% The image is now contained in imageObj.data. Open viewer to display it
imageObj.viewer;
h = gcf;

% Image objects can also export their data into an 2dseq file. Set a path
% to write the image to
imageObj=imageObj.setDataPath('imagewrite', ...
  fullfile(baseDir, ['export', filesep, '2', filesep, 'pdata', filesep, '1']));

% Generate a visu parameter set for the export with all optional parameters
imageObj=imageObj.genExportVisu('genmode','auto');

% These are the visu parameters about to  be exported
display('  Visu parameters about to be exported:');
display(imageObj.exportVisu);

% Write image data and visu parameters
imageObj.writeImage;

clear imageObj;

%%
input('Press Enter to finish'); 
if ishandle(h), close(h); end
