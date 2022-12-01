% create group-assignment file (excel-file)
% group-column has to be specified manually afterwards
% this groupassigment file can be used for voxel-wise statistic or dtistatistic
% 
% 
%% EXAMPLE: with GUI
% creatGroupassignmentFile(1)
% or 
% f1=creatGroupassignmentFile(1,z);  % where f1 is the createx excel-file
% 
%% EXAMPLE: with GUI and predefinitions
% z=[];                                                                                                         
% z.groupfile    = 'groupassignment.xlsx';       % % name of the groupassignment-file (excelfile)               
% z.outdir       = 'F:\data6\voxwise\group';     % % output-directory: default "group"-dir in current study-dir 
% z.addTimeStamp = [0];                          % % add timestamp as suffix to the groupfile-name              
% creatGroupassignmentFile(1,z);  
%                                 
%% EXAMPLE: EXTERNAL mdirs, NO GUI and predefinitions 
% padat='F:\data6\voxwise\dat';
% mdirs=antcb('getsubdirs', padat);
% 
% z=[];                                                                                                         
% z.groupfile    = 'groupassignment3.xlsx';       % % name of the groupassignment-file (excelfile)              
% z.outdir       = 'F:\data6\voxwise\group3';     % % output-directory: default "group"-dir in current study-dir
% z.addTimeStamp = [1];                           % % add timestamp as suffix to the groupfile-name             
% creatGroupassignmentFile(0,z,mdirs);  

function f1=creatGroupassignmentFile(showgui,x,mdirs)

f1=[];






%———————————————————————————————————————————————
%%   PARAMS
%———————————————————————————————————————————————
if exist('showgui')==0 || isempty(showgui) ;    showgui=1                ;end
if exist('x')==0                           ;    x=[]                     ;end

% if ischar(pa);                      pa=cellstr(pa);   end
if isempty(x) || ~isstruct(x)  ;  %if no params spezified open gui anyway
    showgui  =1   ; 
    x=[]          ;
end 

%———————————————————————————————————————————————
%%   ant-animal-dirs 
%———————————————————————————————————————————————
isExtPath=0; % external path
if exist('mdirs')==0      || isempty(mdirs)      ;   
    antcb('update')
    global an;
    pa=antcb('getallsubjects')  ;
    padat=an.datpath; %backup if dat-folde ris empty
else
    pa=cellstr(mdirs);
    isExtPath=1;
    padat=fileparts(mdirs{1});
end


outir=fullfile(fileparts(padat),'group');

%% ________________________________________________________________________________________________
%%  PARAMETER-gui
%% ________________________________________________________________________________________________
if exist('x')~=1;        x=[]; end

p={...    
    'groupfile'      'groupassignment.xlsx'   'name of the groupassignment-file (excelfile)' ''
    'outdir'          outir                   'output-directory: default "group"-dir in current study-dir' 'd' 
    'stat'           'unpaired'               'statistical group-scenario (unpaired|paired)'  {'unpaired' 'paired'}
    'addTimeStamp'    0                       'add timestamp as suffix to the groupfile-name'                             'b'
    };


p=paramadd(p,x);%add/replace parameter
if showgui==1
    %hlp=help(mfilename); hlp=strsplit2(hlp,char(10))';
    [m z ]=paramgui(p,'uiwait',1,'close',1,'editorpos',[.03 0 1 1],...
        'figpos',[0.2687    0.3656    0.4625    0.2233],...
        'title',['create group assignment excel-file [' mfilename '.m]'],'info',{@uhelp, [mfilename '.m']});
    if isempty(m); return; end
    fn=fieldnames(z);
    z=rmfield(z,fn(regexpi2(fn,'^inf\d')));
else
    z=param2struct(p);
end

% ==============================================
%%   BATCH
% ===============================================
try
    isDesktop=usejava('desktop');
    % xmakebatch(z,p, mfilename,isDesktop)
    if isExtPath==0
        xmakebatch(z,p, mfilename,[ mfilename '(' num2str(isDesktop) ',z);' ]);
    else
        xmakebatch(z,p, mfilename,[ mfilename '(' num2str(isDesktop) ',z,mdirs);' ],pa);
    end
end


% ==============================================
%%   proc
% ===============================================
cprintf('*[0 .5 0]',['.. create group-assignment file ...wait' '\n']);
f1=proc(z,pa);
cprintf('*[0 .5 0]',['Done!' '\n']);


% ==============================================
%%   snip_creatGroupassignmentFile
% ===============================================
function f1=proc(z,pa);

%% ===============================================
paout=z.outdir;                     %___make DIR
if exist(paout)~=7
    mkdir(paout);
end
[~,fis,ext]=fileparts(z.groupfile) ;%___add timeStamp
if z.addTimeStamp==1   
   fileshort=[fis '__' regexprep(datestr(now),{'-',' ',':'},{'','_',''}) '.xlsx'];
else
    fileshort=[fis  '.xlsx'];
end

f1=fullfile(paout,fileshort);

%----animal-table
[pax, animals]=fileparts2(pa);
hb={'animal' 'group'};
b=[animals repmat({''},[length(animals) 1])];


try;  delete(f1); end

 %% ============[group-sheet]===================================
pwrite2excel(f1,{1 'group'},hb,{},b);


col=[0.7569    0.8667    0.7765  
     0.9255    0.8392    0.8392];

cm={...
     'group-column: please specify which animal belongs to which group'
     'use strings as group-names'
     'use underscores (avoid spaces) & avoid special characters'
     'example: "control" for "control"-animals; "ABC" for animals from "ABC-group" '};
 xlsinsertComment(f1,cm, 1, 2, 3);
 
 if strcmp(z.stat,'unpaired')
     cm2={...
         'STATISTICAL SCENARIO: unpaired/independent groups'};
     xlsinsertComment(f1,cm2, 1, 8, 3,col(1,:));
 elseif strcmp(z.stat,'paired')
     cm2={...
         'STATISTICAL SCENARIO: paired/dependent groups'
         'IMPORTANT: for pairwise tests it is assumed that:' 
         'the 1st animal of group-1 corresponds to the 1st animal of group-2 (i.e is the same animal)'
         'the 2nd animal of group-1 corresponds to the 2nd animal of group-2 (i.e is the same animal)'
         'the 3rd animal of group-1 corresponds to the 3rd animal of group-2 (i.e is the same animal)'
         'etc...'
         'PLEASE CHECK THE CORRESPONDENCE OF The Animals!!! '
         'group-1 and group-2 must have the same length'};
     xlsinsertComment(f1,cm2, 1, 8, 3,col(2,:));
 end
 
 
%  showinfo2('new group-file ',f1);
 
 %% ============[info-sheet]===================================
 
 t={'info'
     ['study: '  paout ]
     ['date:  '  datestr(now) ]
     ['animals: '  num2str(size(animals,1))]};
 
 pwrite2excel(f1,{2 'info'},{'information'},{},t);
 
 %% ===============================================
 
 showinfo2('new group-file ',f1);
 
 
 
 