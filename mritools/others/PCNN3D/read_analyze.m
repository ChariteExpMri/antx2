%  ======================================================================
%   Read analyse files into MATLAB using 'analyze75read' from 
%   image-processing toolbox. 
%   Window will open allowing choosing of analyze file to convert
%  
%   usage : varname = read_analyze(format);
%             
%           format : image data format to convert to 
%                    'original' - keeps original data format
%                    'double'   - converts to double and rescale to [0 1]
%                                 (default)
%           varname: MATLAB variable name
%   
%   e.g. I = read_analyze('original');
%   
%   Nigel Chou, Jan 2010
%  ======================================================================
% 
%
