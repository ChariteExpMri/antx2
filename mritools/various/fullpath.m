
function fp=fullpath( pa,a)

%add path(pa) to cellarray of files (a)
% function fp=fullpath( a, pa)
% a={'wc1T2.nii' 'wc2T2.nii' 'wc3T2.nii'}
% pa=pwd
% fp=fullpath( pa,a)

if isempty(a)
    fp=[];
    return
end


if iscell(a)
    fp=cellfun(@(a) [ fullfile(pa,a)] ,a, 'UniformOutput',0);
    fp=fp(:);
else
    fp=fullfile(pa,a);
end
