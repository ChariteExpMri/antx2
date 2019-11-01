

% #b select dirs/folders in [ANT]listbox via cell-input or 'paths in clipboard'
% this function can be used to for simple selection of [ANT]-folders 
% based on copied folders from txt-document or excel-sheet
%% see EXAMPLES: 
%% #BY [1] USING CELL-INPUT
% +++++++++++++++++++++++++++++++++++++[FP-files]+++++++++
% a={'c:\s20150909_FK_C2M09_1_3_1\t2.nii'
%    'c:\s20150910_FK_C3M11_1_3_1\t2.nii'};
% xseldirs(a);
% +++++++++++++++++++++++++++++++++++++[FP-folders]+++++++
% a={'c:\s20150909_FK_C2M09_1_3_1'
%    'c:\s20150910_FK_C3M11_1_3_1'};
% xseldirs(a);
% +++++++++++++++++++++++++++++++++++++[folders]++++++++++
% a={'s20150909_FK_C2M09_1_3_1'
%    's20150910_FK_C3M11_1_3_1'};
% xseldirs(a);
% _______________________________________________________
%% #BY [2] USING CLIPBOARD
% +++++++++++++++++++++++++++++++++++++[FP-files]+++++++++
%  ...clipboard this the next two lines
%     c:\s20150909_FK_C2M09_1_3_1\t2.nii           
%     c:\s20150910_FK_C3M11_1_3_1\t2.nii
% xseldirs
% +++++++++++++++++++++++++++++++++++++[FP-folders]+++++++
%  ...clipboard this the next two lines
%    c:\s20150909_FK_C2M09_1_3_1
%    c:\s20150910_FK_C3M11_1_3_1
% xseldirs
% +++++++++++++++++++++++++++++++++++++[folders]++++++++++
%  ...clipboard this the next two lines
%    s20150909_FK_C2M09_1_3_1
%    s20150910_FK_C3M11_1_3_1
% xseldirs
% _______________________________________________________

function xseldirs(pa)

 


if exist('pa')~=1  ;%  ###########   CLIPBOARD
%     clip2clipcell; %make matlabCell
%     pas=clipboard('paste');
%     eval([ 'pa=' pas ';']);
    
    a=clipboard('paste');
    pa=strsplit2(a,char(10))';
    %pa =['{' ; cellfun(@(a) {[ ' ''' a '''']},a2); '};'];
    
else                 % ###########   INPUT:
    if ischar(pa);
        pa=cellstr(pa);
    end
end

%% remove spaces
pa=regexprep(pa,'\s','');


%% check folder/file//FP..
[pax fis ext]=fileparts2(pa);
if isempty(ext{1})  % FOLDERS AS INPUT
    pa=fis;
else  % FILES AS INPUT
    [pax2 fis ext]=fileparts2(pax) ;
    pa=fis;
end

% disp(pa);

% return

global an
fppa=cellfun(@(a) {[an.datpath  filesep a  ]},pa);

%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
%% find folders in  mouse-listbox
    
pax=antcb('getallsubjects'); %path
id=[];
for i=1:size(fppa,1)
    idi=find(strcmp(pax,fppa{i,1}));
    if ~isempty(idi)
        id(end+1) =idi;
    end
end
if isempty(id); return; end
%% select folders

lb3=findobj(findobj(0,'tag','ant'),'tag','lb3');
set(lb3,'value',id);

%% update counter
hfig=findobj(0,'tag','ant');
lb=findobj(hfig,'tag','lb3');
cb=get(lb,'callback');
hgfeval({cb, lb,[]});


%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
function Tokens = strsplit2(String, Delim)

Tokens = [];

while (size(String,2) > 0)
    if isempty(Delim)
         [Tok, String] = strtok(String);    
    else
        [Tok, String] = strtok(String, Delim);    
    end
    Tokens{end+1} = Tok;
end