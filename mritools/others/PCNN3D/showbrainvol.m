%  ==========================================================================
%   
%   Displays 3D surface of a brain mask with anisotropic voxel resolution
%   
%   usage: showbrainvol(data,vox_xy,vox_z,viewangle);
%  
%     data      : binary input volume 
%     vox_xy    : pixel dimensions in x and y (assumed to be
%                 the same)
%     vox_z     : pixel dimension in z
%     viewangle : arguments for view command, default [74,16]
%  
%   e.g. showbrainvol(Out{1,47},0.09765625,0.30000925);
%  
%   Nigel Chou; June 23, 2009
%  ==========================================================================
% 
%
