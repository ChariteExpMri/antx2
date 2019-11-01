%  ==========================================================================
%   PCNN3D 
%  
%   Performs skull-stripping  of MRI volumes using 3D PCNN on the entire 
%   volume
%  
%   usage: [Out , G]= PCNN3D(In,p,voxdim,BrSize);
%  
%     Out    : series of binary mask volumes (MATLAB cell format)
%     G      : plot of volume of mask (in mm^3) vs. iterations
%     In     : 3D input image
%     p      : radius of structural element
%     voxdim : vector containing the x, y, and z voxel dimensions
%     BrSize : (optional) vector of min and max of brain size (in mm^3). Default=[100 550] for mouse brain. This will be used to estimate optimal iteration.
%     maxiter: (optional) max iteration. Default=200.
%  
%   e.g. [I_border, G_I]= PCNN3D(I,4,[.1 .1 .25],[100 550]);
%  
%   Nigel Chou, last updated 1 July 2010
%   Kai-Hsiang Chuang, 20 Apr 2012, Ver 1.1
%  ==========================================================================
% 
%
