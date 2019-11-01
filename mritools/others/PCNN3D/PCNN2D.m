%  ==========================================================================
%   PCNN (2D) 
%  
%   Performs skull-stripping of MRI volumes using PCNN in 2D on a 
%   single slice. 
%   Should be similar to Murugavel et. al.'s method but with variations 
%   in morphological operations used.
%   Assumes isotropic slice resolution.
%  
%   usage: [Out , G]= PCNN2D(In,p,niter,showfig);
%  
%     Out    : series of binary masks
%     G      : plot of area of mask (in fraction of total area) vs. iterations
%     In     : 2D input image
%     p      : radius of structural element
%     niter  : number of iterations (must specify: unlike 3D PCNN, no way  
%              to predict when to stop)
%     showfig: 0 - don't show anything
%              1 - show masks of all iterations
%              2 - show masks of all iterations and iteration plot (default)
%  
%   e.g. [Out , G]= PCNN2D(I,4,60);
%  
%   Nigel Chou, July 2009
%  ==========================================================================
% 
%
