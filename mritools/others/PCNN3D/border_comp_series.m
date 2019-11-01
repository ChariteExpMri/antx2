%   =========================================================================
%  
%   Displays borders of masks from various automatic methods
%   on selected coronal slices. Shows all slices in one figure.
%  
%   usage: Out = border_comp_series(in,slices,crop,varargin);
%   
%     in     : original image volume (must be 3D input image)
%     slices : list slice numbers to be compared
%     crop   : no. of pixels on each side to be cropped ( [left right top
%              bottom]) e.g. [10 10 20 20]
%     col    : color in RGB e.g. [1 0 0] for red
%  
%   e.g.
%   I_comparison = border_comp_series(I,[2 30 48],[10 10 20 20],I_PCNNmasks{1,54},[1 0 0]);
%  
%   Nigel Chou. 20 June 2010
%  ==========================================================================
% 
%
