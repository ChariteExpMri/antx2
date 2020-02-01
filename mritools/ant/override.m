

%% override parameter
% locate a copy of this file into the study's folder to use it...
% if ["override.m"] it found in the study folder (directly there, not in a subdir..), parmater will
% be applied,
% PARAMETR CAN BE MODIFIED 
% commented PARAMERE will not be executed..override the respective parameter


function [parm]=override()
parm=struct();

% ==============================================
%%   SEGMENTATION PARAMETER (default)
% ===============================================
parm.segm.opts.ngaus   = [3 2 2 4]';
parm.segm.opts.regtype = 'animal';
parm.segm.opts.warpreg = 1;
parm.segm.opts.warpco  = 1.7500;
parm.segm.opts.biasreg = 1.0000e-04;
parm.segm.opts.biasfwhm= 5;
parm.segm.opts.samp    = 0.1000;
parm.segm.opts.msk     = {''};


