%  ==========================================================================
%  
%   finds 'best' iteration as well as range with best iterations for PCNN
%  
%   usage: its=findit(G,range);
%  
%     its    : vector of 3 values: itmin: beginning of plateau region
%                                  itmid: middle of plateau
%                                         (most likely the optimal iteration)
%                                  itmax: end of plateau
%     G      : plot of volume of mask (in mm^3) vs. iterations
%     range  : range of brain sizes expected e.g. [100 550] for C57BL6 mouse
%              for lower bound preferable choose a smaller number
%  
%   e.g. its = findit(I_PCNN_G,[100 550])
%  
%   Nigel Chou, last updated 1 July 2010
%  ==========================================================================
% 
%
