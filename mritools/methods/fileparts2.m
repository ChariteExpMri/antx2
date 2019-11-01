
% fileparts2: for multiple paths (cell) 
% function [pathstr, name, ext] = fileparts2(file)


function [pathstr, name, ext] = fileparts2(fi)

if ~iscell(fi); fi=cellstr(fi); end

[pathstr name ext]=deal({});
for i=1:length(fi)
    [pathstr{i,1} name{i,1} ext{i,1}]=fileparts(fi{i});
end
    