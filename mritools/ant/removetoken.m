
function out = removetoken(f,str,removeIdx,postprefix,postsuffix)
%RMSTRING Remove delimiter-separated token (fields) from a string.
%   OUT = removetoken(F, DELIM, IDX)
%   Splits string F at delimiter DELIM, removes selected token,
%   and rejoins the remaining token using the same delimiter.
%   INPUTS
%   ------
%   F         filename/Character array or string.
%            -for filenames ..fileextention is preserved (is not part of the last token/field)
%   DELIM     Delimiter used for splitting, e.g.
%             '_', '-', '.', filesep, etc.
%   IDX       token/Fields to remove.
%             Can be:
%             Numeric indices:  2, [2 3], or 1:4
%             Character expressions evaluated on the token list:
%                 'end',  'end-1:end',  '3:end'   '2:2:end'
%                for specific indices use  brackes in string: '[1 2 end]' ,  '[1 4 6]'  '[end-3 end]'
% 
%  postprefix  : posthoc add prefix, <optional>, <string>
%  postsuffix  : posthoc add suffix, <optional>  <string>
%    -if only postprefix/postsuffix is used without removal of tokesn set  removeIdx to empty ('' or [])
% 
%   -------
%   OUT       Modified string after token removal.
%   EXAMPLES
%   --------
%   % Remove 2nd and 3rd fields
%   removetoken('c_08_6_VFA_T1_map_postInj_50deg.nii','_',[2 3])
%   % -> 'c_VFA_T1_map_postInj_50deg.nii'
%
%   % Remove everything from field 3 onward
%   removetoken('c_08_6_VFA_T1_map_postInj_50deg.nii','_','3:end')
%   % -> 'c_08.nii'
%
%   %remove last token
%   removetoken('c_08_6_VFA_T1_map_postInj_50deg.nii','_','end')
%   % -> 'c_08_6_VFA_T1_map_postInj.nii'
%
%   % Remove last three fields
%   removetoken('c_08_6_VFA_T1_map_postInj_50deg.nii','_','end-2:end')
%   % -> 'c_08_6_VFA_T1.nii'
%   
%  remove 1st token and add prefix 'pre_'
%  removetoken('c_08_6_VFA_T1_map_postInj_50deg.nii','_',1,'pre_')
%  % -> 'pre_08_6_VFA_T1_map_postInj_50deg.nii'
% 
%  remove no token but add prefix 'pre_'
%  removetoken('c_08_6_VFA_T1_map_postInj_50deg.nii','_',[],'pre_')
%  % -> 'pre_c_08_6_VFA_T1_map_postInj_50deg.nii'
% 
%  remove no token but add suffix '_post'
% removetoken('c_08_6_VFA_T1_map_postInj_50deg.nii','_',[],[],'_post')
%  % -> 'c_08_6_VFA_T1_map_postInj_50deg_post.nii'
% 
% 
% remove first three and last token, add prefix 'pre_' and suffix '_post'
% removetoken('c_08_6_VFA_T1_map_postInj_50deg.nii','_','[1:3 end]','pre_','_post')
%  % ->  'pre_VFA_T1_map_postInj_post.nii'

if isstring(f);   str=char(f); end
if isstring(str); str=char(str); end
if isstring(removeIdx); str=char(removeIdx); end


[pa name ext]=fileparts(f);
f=fullfile(pa,name);

if isempty(str); str='_'; end

p = strsplit(f,str);
if ischar(removeIdx)
    eval(['p(' removeIdx ')=[];']);
else
    try
    removeIdx(removeIdx>numel(p)) = [];
    p(removeIdx) = [];
    end
end
out = strjoin(p,str);


if exist('postprefix')==1 && ~isempty(postprefix)
    if isstring(postprefix);   postprefix=char(postprefix); end
    out=[postprefix out];
end
if exist('postsuffix')==1 && ~isempty(postsuffix)
     if isstring(postsuffix);   postsuffix=char(postsuffix); end
        out=[ out postsuffix ];
end

out=[out ext];



% for i=1%
%      rmstring(b{i},[2 3])
% end
% 
% function out = rmstring(f,removeIdx)
% p = strsplit(f,'_');
% removeIdx(removeIdx>numel(p)) = [];
% p(removeIdx) = [];
% out = strjoin(p,'_');
% end