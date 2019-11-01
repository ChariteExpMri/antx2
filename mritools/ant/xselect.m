

%% pre-select mouse folders by either a file/id/foldername or textfile
% RATIONALE: preselect/select mouse folders from the the left ANT-panel based on different critera:
% - x.files preselect mouse folders that contain/not contain specific files defined in x.files
% - using example:  select all folders that do not conitain c1.nii and c2.nii and c3.nii -files
%                   select all folders that contain 'x_t2.nii'
%
% xselect(showgui,x)
%% #by PARAMETERS
% showgui: opens the gui [0,1]
% x      : struct with following parameters
%  #g   x.files       : this parameter contain the files, if searching for one or more files within mouse folders
%  #g   x.logop       : to define whether a folder contains all files, one of the files or none of the files, (files defined in x.files)
%                     -x.logop is only necessary if x.files is used          
%    ---alternative---
%  #g   x.ids         : array of ids  , example [1 ,30,31] -->select mouse folders with indices 1,30 and 31 
%                     -use ids with care (new mouse cases/folders will change the order in the listbox!)
%    ---alternative---
%  #g    x.dirs       : explicit names of the mouse-folders    
%    ---alternative---  
%  #g    x.textfile   : textfile with mousefolder-names (shortnames or fullpath-names), each row contains one folder         
%     
%% #by DESCR:
% -%based on the above criteria these mouse folders will be pre-selected in the ant-gui-listbox (left panel)
% -->BATCH: possible
%% #by OPTIONAL INPUT:
%  showgui: 0/1 : silent mode /GUI    ...default: GUI
%  x      : parameters OF THIS ROUTINE
%  pa     : PRESELECTED PATHS
%% #by EXAMPLES without predefinitions
% xselect  ;%this will open the parameter-gui
%
%% #by EXAMPLES with predefinitions
% xselect(1,struct('files',{{'AVGT.nii';'hemi.nii',}},'logop','&'))  % #g select folders with existing files AVGT.nii AND hemi.nii  
% xselect(1,struct('files',{{'AVGT.nii';'hemi.nii',}},'logop','|'))  % #g select folders with existing files AVGT.nii OR hemi.nii  
% xselect(1,struct('files',{{'hemi.nii'}},'logop','|'))              % #g select folder, with existing files hemi.nii , log. operator [logop] is ignored
% xselect(1,struct('files',{{'hemi.nii'}})                           % #g ..same as beefore
% xselect(1,struct('ids',[1 4 7 9]))                                 % #g select folders by ID [ 1 4 7 9]
% xselect(0,struct('ids',[10:15]))                                   % #g select folders by ID [ 10,11,12,13,14,15]
% xselect(1,struct('dirs',{{'s20150506SM14_1_x_x';'s20150506SM15_1_x_x',}}))  % #g select this mouse-folders
% xselect(0,struct('textfile','O:\harms1\harms3_lesionfill\#selection-groupA-fullpath.txt')); % #g select folders based on text-file containing FULLPATH-mouse-folder-names
% xselect(1,struct('textfile','O:\harms1\harms3_lesionfill\#selection-groupB.txt'))           % #g select folders based on text-file containing only the mouse-folder-filenames




function xselect(showgui,x,pa)



%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
%% INPUTS
if exist('showgui')~=1;    showgui=1; end
if exist('x')      ~=1;    x=[];      end
if isempty(x);             showgui=1; end
if exist('pa')~=1;  
    global an;
    pa=antcb('getallsubjects'); %path
    
  
    
end
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

%———————————————————————————————————————————————
%%   GUI
%———————————————————————————————————————————————

p={...
    'inf0'      '*** PRE-SELECT FILES (THIS SELECTS SPECIFIC MOUSE-PATHS )               '         '' ''
    'inf1'      ['routine: [' mfilename '.m]']                         '' ''
    'inf2'      'SELECT ONE (- AND ONLY ONE !!! -) OF THE FOLLOWING ALTERNATIVE OPTIONS' '' ''
    
    'inf22'     '[OPTION-1] ••• FILE-FILTER •••' '' ''
    'inf3'      '   -folders must contain a specified file' '' ''
    'inf4'      '   -if multiple files selected, one has to define whether..' '' '' 
    'inf5'      '     a folder contains (a) ALL files (logical operator: "&") '  '' ''
    'inf6'      '                    or (b) ONE of the files (logical oeprator: "|") '  '' ''   
    'inf7'      '                    or (c) none of the files (logical oeprator: "none") '  '' ''   
    
    'inf70'     '[OPTION-2] ••• ID •••'                 'select IDs (numeric array)' ''
    'inf80'     '[OPTION-3] ••• MOUSEFOLDERS  •••'   'select mouse-folders explicitely' ''
    'inf81'     '[OPTION-4] •••TEXTFILE  •••'       'select mouse-folders FROM TEXTFILE' ''
    'inf82'      '   -textfile must contain a list of mousefolders (fullpath or foldernames only)' '' ''

    'inf99'     '====================================================================================================='        '' ''
    'files'     {''}           'OPTION-1: SELECT FILTER-FILE(S) WHICH EXISTS IN THE MOUSEFOLDERS TO SELECT TO'  {@getuniquefiles,[],[]}
    'logop'     '&'           'OPTION-1: LOGICAL OPERATOR (FOR MULTIPLE-FILTER-FILES ONLY) TO define selected folders ("&" ...and "|"...or ) for FOLDERS to find'  {'& ..all files has to be found in folder'; '|..one of the files has to be found in folder'; 'none..none of the files has to be find in the folder' }
    'ids'        ''            'OPTION-2: ENTER IDS TO SELECT (numeric arry), e.g [2 3 17 5]'  ''
    'dirs'      {''}            'OPTION-3: EXPLICIT SELECTION OF MOUSEFOLDERS'  {@getdirs}
    'textfile'  ''            'OPTION-4: GET MOUSEFOLDERS FROM TEXTFILE'  'f'


    };
p=paramadd(p,x);%add/replace parameter
%% show GUI
if showgui==1
    [m z]=paramgui(p,'uiwait',1,'close',1,'editorpos',[.03 0 1 1],...
        'figpos',[0.20    0.4189    0.7024    0.3511 ],...
        'title','FOLDR-SELECTION');
    if isempty(m); return; end
else
    z=param2struct(p);
end
 
%———————————————————————————————————————————————
%%   now process
%———————————————————————————————————————————————
global an;

if ~isempty(char(z.textfile))
    li=preadfile(z.textfile); li=li.all;
    for i=1:size(li,1)
        [pas fis ext]=fileparts(li{i,1});
        if isempty(pas);
          li{i,1}  =fullfile(an.datpath,fis);
        end
    end
    findfolders=1; %should we find the folders from list?
elseif ~isempty(char(z.dirs))
    li=z.dirs;
    for i=1:size(li,1)
        [pas fis ext]=fileparts(li{i,1});
        if isempty(pas);
          li{i,1}  =fullfile(an.datpath,fis);
        end
    end
    findfolders=1; %should we find the folders from list?
elseif ~isempty(char(z.files))
    id=getfolderfromfilters(z);
     findfolders=0;
elseif ~isempty(z.ids)
    id=z.ids;
     findfolders=0;     
end


if  findfolders == 1;
    %% find in subjectslist
    pa=antcb('getallsubjects'); %path
    id=[];
    for i=1:size(li,1)
        idi=find(strcmp(pa,li{i,1}));
        if ~isempty(idi)
            id(end+1) =idi;
        end
    end
end


lb3=findobj(findobj(0,'tag','ant'),'tag','lb3');
set(lb3,'value',id);

% hgfeval({get(lb3,'callback'),lb3,[]}');

%% update counter
hfig=findobj(0,'tag','ant');
lb=findobj(hfig,'tag','lb3');
cb=get(lb,'callback');
hgfeval({cb, lb,[]});


%% Batch
makebatch(z);

%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
%•••••••••••••••••••••••••••••••	subs        •••••••••••••••••••••••••••••••••••••••••••••••••••••
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
function makebatch(z)
try
    hlp=help(mfilename);
    hlp=hlp(1:min(strfind(hlp,char(10)))-1);
catch
    hlp='';
end
hh={};
hh{end+1,1}=('% ••••••••••••••••••••••••••••••••••••••••••••••••••••••');
hh{end+1,1}=[ '% BATCH:        [' [mfilename '.m' ] ']' ];
hh{end+1,1}=[ '% descr:' hlp];
hh{end+1,1}=('% ••••••••••••••••••••••••••••••••••••••••••••••••••••••');
hh=[hh; struct2list(z)];
hh(end+1,1)={[mfilename '(' '1',  ',z' ')' ]};
% uhelp(hh,1);
try
    v = evalin('base', 'anth');
catch
    v={};
    assignin('base','anth',v);
    v = evalin('base', 'anth');
end
v=[v; hh; {'                '}];
assignin('base','anth',v);
disp(['batch <a href="matlab:' 'uhelp(anth)' '">' 'show batch code' '</a>'  ]);



function  id=getfolderfromfilters(z)
pa=antcb('getallsubjects'); %path


bools=zeros(size(pa,1),size(z.files,1));
for j=1:size(pa,1)
    for i=1:size(z.files,1)
        if exist(fullfile(pa{j},z.files{i}))==2
           bools(j,i)=1; 
        end 
    end 
end

%% LOGICAL OPERATION
%% OR
if ~isempty(strfind(z.logop,'|'))
    id =  find(sum(bools,2)>0);
elseif ~isempty(strfind(z.logop,'none'))
    id =  find(sum(bools,2)==0)
else
    %% AND
    id = find(sum(bools,2)==size(bools,2));
end





function he=getdirs()
global an;

[t,sts] = cfg_getfile2(inf,'dir',{'SELECT MOUSE-FOLDER(S)',''},'',an.datpath);
if isempty(isempty(char(t)))
   he='';
   return;
end
he=strrep(strrep(t,[an.datpath filesep],''),filesep,'')


function he=getuniquefiles(li,lih)
% keyboard
global an
pa=antcb('getallsubjects'); %path
%________________________________________________
%%  generate list of nifit-files within pa-path
%________________________________________________
%% fileList
li={};
if 1
    fi2={};
    for i=1:length(pa)
        [files,~] = spm_select('FPList',pa{i},['.*..*$']);
        if ischar(files); files=cellstr(files);   end;
        fis=strrep(files,[pa{i} filesep],'');
        fi2=[fi2; fis];
    end
    li=unique(fi2);
    [li dum ncountid]=unique(fi2);
    %% count files
    ncount=zeros(size(li,1),1);
    for i=1:size(li,1)
       ncount(i,1) =length(find(ncountid==i));
    end
end
tb=[li cellstr(num2str(ncount))];
he=selector2(tb,{'Unique-Files-In-Study', 'Ntimes-In-Study'},'out','col-1','selection','multi');




