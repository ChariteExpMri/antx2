
%% replace path of file(string/cell) or files(cell) with 'path'
% example
% replacefilepath(parafiles2,pwd);
function in2=replacefilepath(in,path)


if ischar(in)
    in=cellstr(in);
    charis=1;
else
    charis=0;
end

for i=1: size(in,1)
    
    % change filesep
%     if ispc
%        in{i,1}= strrep(in{i,1},'/','\');
%        path   = strrep(path,'/','\');
%     else
%        in{i,1}= strrep(in{i,1},'\','/');
%        path   = strrep(path,'\','/');
%     end
    
    
    [pa fi ext]=fileparts(in{i,1});
    in2{i,1}=fullfile(path,[fi ext]);
end

if charis==1
    in2=char(in2);
end