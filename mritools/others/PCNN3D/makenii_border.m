%  ======================================================================
%   Creates analyze files for (1) binary mask (2) brain-extracted image
%   (3) binary mask border 
%   given image volume and binary mask as inputs.
%   Uses Jimmy Shen's 'make_nii' m-file.
%  
%   usage: out = makenii_border(vol,binmask,filename,pixdim,slicedim)
%  
%     vol     : image volume
%     binmask : binary mask
%     filename: name of ouput files (suffixes will be added: '_pcnnmask' for
%               binary mask, '_pcnnextr' for extracted image and '_border'
%               for image border.)
%     voxdim  : voxel dimensions
%     slicedim: which axis to draw border along
%  
%   e.g. out = jaccard_PCNN(I_PCNNborders,I_manmask,I,4,0);
%  
%   Nigel Chou, Feb 2009
%  =======================================================================
% 
%
