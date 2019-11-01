%  =============================================================
%  
%   Reads 3D binary image sets saved as slicewise sparse matrices.
%   
%   usage: out = readsparse3d(in);
%     
%         in : input image in cell format with each cell as one
%              (coronal) slice in sparse format
%         out: output as double 3D matrix
%  
%   e.g. bw = readsparse3d(bw_cell);
%   
%   Nigel Chou, March 2010
%  =============================================================
% 
%
