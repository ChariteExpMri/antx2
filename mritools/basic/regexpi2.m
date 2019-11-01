


function id=regexpi2(cells, str,varargin)
%same as regexpi but jelds indizes of mathing cells , instead of empty cells ('I'm tired to code this again and again)
id=regexpi(cells,str,varargin{:});
id=find(cellfun('isempty',id)==0);