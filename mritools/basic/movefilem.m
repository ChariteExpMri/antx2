%% mass-renaming files 
%% function movefilem(f1,f2)
% input:
% f1: cell of files =sources
% f2: cell of new names
% f1 and f2 match in size

function movefilem(f1,f2)

% f1=s.a
% f2=stradd(s.a,'c')

if ischar(f1)
    f1=cellstr(f1);
end
if ischar(f2)
    f2=cellstr(f2);
end

for i=1:length(f1)
    movefile(f1{i}, f2{i} ,'f');
end