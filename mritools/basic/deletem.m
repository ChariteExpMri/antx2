%% mass-deleting files 
%% function deletem(f1)
% input:
% f1: cell of files to delete


function deletem(f1)

% f1=s.a
% f2=stradd(s.a,'c')

if ischar(f1)
    f1=cellstr(f1);
end


for i=1:length(f1)
    delete(f1{i});
end