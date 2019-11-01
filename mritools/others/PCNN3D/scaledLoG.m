%  =====================================================================
%   creates a scaled laplacian of gaussian weighting matrix for 3D PCNN
%   (not used in paper)
%  
%   usage : h = scaledLoG( r,voxdim,sigma)
%  
%           h     : scaled weighting matrix of size
%                   [2r+1 2r+2 2r+1]
%           r     : radius
%           voxdim: voxel dimensions
%           sigma : spread of function
%  
%   e.g.  h = scaledLoG( 2,[.1 .1 .3],3);
%   
%   Nigel Chou, Feb 2009
%  =====================================================================
% 
%
