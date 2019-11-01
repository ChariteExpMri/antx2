%  =====================================================================
%   Plots reciever-operator charactersitic (ROC) curve
%  
%   usage : out = roc(in,series, manmask,type,plotstr,ss,es);
%  
%           out     : ROC plot
%           in      : 3D input image
%           series  : series of binary masks
%           manmask : manual/reference mask
%           type    : use 'abs' or 'corr' FPR (default = 'corr')
%           plotstr : string to define line e.g. ('k-' for black line)
%           ss      : starting slice
%           es      : ending slice (subtracting from end), (default = 0)
%  
%   e.g. ROC = roc(I,I_PCNNborders, I_manmask,'corr','kx',3);
%   
%   Nigel Chou, March 2010
%  =====================================================================
% 
%
