function [o o2 tnew] = nearest(array, vals)

%=============================================
% vals can be vectors
%=============================================
% NEAREST return the index of an array nearest to a scalar
% 
% [indx] = nearest(array, val)

% Copyright (C) 2002, Robert Oostenveld
%
% $Log: nearest.m,v $
% Revision 1.3  2004/12/06 12:55:57  roboos
% added support for -inf and inf, respectively returning the first and last occurence of the nearest element
%
% Revision 1.2  2003/03/17 10:37:28  roberto
% improved general help comments and added copyrights
%

% mbrealvector(array)
% mbrealscalar(val)

% ensure that it is a column vector
array = array(:);

if isnan(vals)
  error('incorrect value')
end

for j=1:length(vals)
    val=vals(j);
    if val>max(array)
        % return the last occurence of the nearest number
        [dum, i] = max(flipud(array));
        i = length(array) + 1 - i;
    else
        % return the first occurence of the nearest number
        [mindist, i] = min(abs(array(:) - val));
    end
    o(j,1)=i;
end

try
o2=o(1):o(2);
catch
 o2=o(1) ;   
end
tnew=array(o2);