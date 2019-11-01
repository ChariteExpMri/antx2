%   =========================================================================
%  
%   Displays borders of PCNN mask on individual coronal slices as a line (color
%   can be specified). Multiple borders can be drawn on the same image. Displays
%   each coronal slice as seperate figure.
%  
%   usage: Out = drawbordervol_comp(OrigVol,lw,bwvol,col,iterno,bwvol2,col2,iterno2,...)
%   
%     OrigVol: original image volume
%     lw     : linewidth of border
%     bwvol  : series of binary mask volumes (as matlab cell format)
%     col    : color in RGB e.g. [1 0 0] for red
%     iterno : iteration no. for PCNN (if only one mask, then set iterno=0)
%  
%   e.g.  drawbordervol_comp(I,2,I_border,[1 0 0],54);
%  
%   Nigel Chou, Oct 2009
%  ==========================================================================
% 
%
