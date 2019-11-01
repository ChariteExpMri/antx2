function s=fn_structdisp(Xname)
% function fn_structdisp Xname
% function fn_structdisp(X)
%---
% Recursively display the content of a structure and its sub-structures
%
% Input:
% - Xname/X     one can give as argument either the structure to display or
%               or a string (the name in the current workspace of the
%               structure to display)
%
% A few parameters can be adjusted inside the m file to determine when
% arrays and cell should be displayed completely or not

% Thomas Deneux
% Copyright 2005-2012

s=[];
% diary muell9999123.txt;
diary(fullfile(pwd,'muell9999123.txt'));
if ischar(Xname)
    X = evalin('caller',Xname);
else
    X = Xname;
    Xname = inputname(1);
end

if ~isstruct(X), error('argument should be a structure or the name of a structure'), end
rec_structdisp(Xname,X);
diary off;
s=tovar;

function s=tovar

fid=fopen('muell9999123.txt','r');
s = {};
tline = fgetl(fid);
while ischar(tline)
    disp(tline)
    tline = fgetl(fid);
    s{end+1,1}=tline;
end
fclose(fid);
s(end)=[];
delete('muell9999123.txt');

%---------------------------------
function rec_structdisp(Xname,X)
%---

%-- PARAMETERS (Edit this) --%

ARRAYMAXROWS = 20;
ARRAYMAXCOLS = 20;
ARRAYMAXELEMS = 300;
CELLMAXROWS = 20;
CELLMAXCOLS = 20;
CELLMAXELEMS = 300;
CELLRECURSIVE = true;

%----- PARAMETERS END -------%

disp([Xname ':'])
disp(X)
%fprintf('\b')

if isstruct(X) || isobject(X)
    F = fieldnames(X);
    nsub = length(F);
    Y = cell(1,nsub);
    subnames = cell(1,nsub);
    for i=1:nsub
        f = F{i};
        Y{i} = X.(f);
        subnames{i} = [Xname '.' f];
    end
elseif CELLRECURSIVE && iscell(X)
    nsub = numel(X);
    s = size(X);
    Y = X(:);
    subnames = cell(1,nsub);
    for i=1:nsub
        inds = s;
        globind = i-1;
        for k=1:length(s)
            inds(k) = 1+mod(globind,s(k));
            globind = floor(globind/s(k));
        end
        subnames{i} = [Xname '{' num2str(inds,'%i,')];
        subnames{i}(end) = '}';
    end
else
    return
end

for i=1:nsub
    a = Y{i};
    if isstruct(a) || isobject(a)
        if length(a)==1
            rec_structdisp(subnames{i},a)
        else
            for k=1:length(a)
                rec_structdisp([subnames{i} '(' num2str(k) ')'],a(k))
            end
        end
    elseif iscell(a)
        if size(a,1)<=CELLMAXROWS && size(a,2)<=CELLMAXCOLS && numel(a)<=CELLMAXELEMS
            rec_structdisp(subnames{i},a)
        end
    elseif size(a,1)<=ARRAYMAXROWS && size(a,2)<=ARRAYMAXCOLS && numel(a)<=ARRAYMAXELEMS
       try
           try
           disp([subnames{i} ':  '  a]);
           catch
           disp([subnames{i} ':  '  num2str(a)]);     
           end
           
       catch
        disp([subnames{i} ':  ']);
        disp(a);
       end
    end
end
