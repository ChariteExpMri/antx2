%   =========================================================================
%  
%   Displays borders of mask on individual coronal slices. up to 3 borders
%   can be drawn and viewed using image-processing toolbox's 'implay'
%  
%  
%   usage: Out = border_comp_implay(OrigVol,bwvol,col,bwvol2,col2,...)
%   
%     in     : original image volume (must be 3D input image)
%     binmask: binary mask volume
%     col    : color in RGB e.g. [1 0 0] for red
%  
%   e.g. I_dispborder = border_comp_implay(I,I_PCNNmasks{1,54},[1 0 0]);
%  
%   Nigel Chou. 15 June 2010
%  ==========================================================================
% 
%
