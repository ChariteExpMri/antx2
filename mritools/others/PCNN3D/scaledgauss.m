%  =====================================================================
%   creates a scaled gaussian weighting matrix for 3D PCNN
%   intended to correct for anisotropy in voxel dimensions
%  
%   usage : h = scaledgauss( r,voxdim,sigma)
%  
%           h     : scaled gaussina weighting matrix of size
%                   [2r+1 2r+2 2r+1]
%           r     : radius
%           voxdim: voxel dimensions
%           sigma : spread of gaussian function
%  
%   e.g. h = scaledgauss( 3,[.1 .1 .3],.65);
%   
%   Nigel Chou, July 2009
%  =====================================================================
% 
%
