
%same as regexpi but jelds indizes of matching cells, instead of empty cells
% function id=regexpi2(cells, str,varargin)
function id=regexpi2(cells, str,varargin)
id=regexpi(cells,str,varargin{:});
id=find(cellfun('isempty',id)==0);