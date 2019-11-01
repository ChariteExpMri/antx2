%% mass-copying files  
%% function copyfilem(f1,f2)
% input:
% f1: cell of files =sources (this are copied)
% f2: cell of filenames to create  
% f1 and f2 match in size

function copyfilem(f1,f2)

% f1=s.a
% f2=stradd(s.a,'c')

if ischar(f1)
    f1=cellstr(f1);
end
if ischar(f2)
    f2=cellstr(f2);
end

for i=1:length(f1)
    
% change filesep
%     if ispc
%        f1{i}= strrep(f1{i},'/','\');
%        f2{i}= strrep(f2{i},'/','\');
%     else
%        f1{i}= strrep(f1{i},'\','/');
%        f2{i}= strrep(f2{i},'\','/');
%     end
    
    copyfile(f1{i}, f2{i} ,'f');
end