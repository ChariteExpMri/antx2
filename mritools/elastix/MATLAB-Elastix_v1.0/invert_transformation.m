function inv_txt = invert_transformation(tfile,im,pfile)

% invert_transformation inverts a transformation
% 
% Usage:
% inv_tfile = invert_transformation(tfile,im,pfile)
%
% -----------------------------Inputs--------------------------------------
% tfile: transformation file to be inverted, namely 
%        y = T(x) defined from the fix (x) to the moving space (y)
% im: image in the moving space, defining the properties (voxel size, 
%     direction cosines and dimensions) of the image that will result from 
%     applying the inverse transformation to an image in the fix space
% pfile: parameter file (recomendation: use the same parameter file for the
%        estimation the transformation in "tfile", perhaps without the 
%        finest resolution steps)
% ------------------------------Outputs----------------------------------
% inv_tfile: inverse transformation file, x = T^(-1)(y)
%
% 5/3/2011
% version 1.0b
% 
% Pedro Antonio Valdés Hernández
% Neuroimaging Department
% Cuban Neuroscience Center

metric = get_ix(pfile,'Metric');
set_ix(pfile,'Metric','DisplacementMagnitudePenalty');
type = get_ix(pfile,'Transform');
set_ix(pfile,'Transform',get_ix(tfile,'Transform'));
format = get_ix(tfile,'ResultImageFormat');
set_ix(tfile,'ResultImageFormat','nii');
%---
elx_im = run_transformix(im,'',tfile,'','');
[pp,nn,ee] = fileparts(im);
tmp_im = fullfile(pp,['tmp-' nn ee]);
copyfile(im,tmp_im);
[junk,tmp] = run_elastix(elx_im,tmp_im,'',pfile,'','',tfile,2,'');
delete(tmp_im);
% delete(tmp_elx_im);
[pp,nn,ee] = fileparts(tfile);
inv_txt = fullfile(pp,['inv-' nn ee]);
movefile(tmp,inv_txt);
set_ix(inv_txt,'InitialTransformParametersFileName','NoInitialTransform');
%---
set_ix(pfile,'Metric',metric);
set_ix(pfile,'Transform',type);
set_ix(tfile,'ResultImageFormat',format);