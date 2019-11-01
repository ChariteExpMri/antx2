
%% #b distribute file(s) : this routine copies any file(s) from outside into the pre-selected mouse-folders
% -any files with any file-formats (text,nifti etc) can be selected
% -renaming option
% -these files will than copied / copied+renamed into prE-selected mousefolders
% -BATCH: possible
% **********************************************
%% #by FUNCTION 
% xdistributefiles(showgui,x,pa)
%% #by INPUT:
%  showgui  % (optional) 0/1 : silent mode /GUI    ...default: GUI
%  x        % (optional) parameters OF THIS ROUTINE
%  pa       % (optional) PRESELECTED PATHS
%% #by RE-USE BATCH: see 'anth' [..anthistory] -variable in workspace


function xdistributefiles(showgui,x,pa)




%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
%% INPUTS
if exist('showgui')~=1;    showgui=1; end
if exist('x')      ~=1;    x=[];      end
if isempty(x);             showgui=1; end
if exist('pa')~=1;  
    global an;
    pa=antcb('getsubjects'); %path
end
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

%———————————————————————————————————————————————
%%   GUI
%———————————————————————————————————————————————

p={...
    'inf1'      '*** DISTRIBUTE FILE(S)               '         '' ''
    'inf2'      ['[' mfilename ']']                         '' ''
    'inf3'     '==================================='        '' ''
    'files'     ''            'SELECT FILES TO DISTRIBUTE HERE (optional:>via GUI)'  {@renamefiles,[],[]}
    };
p=paramadd(p,x);%add/replace parameter
%% show GUI
if showgui==1
    [m z]=paramgui(p,'uiwait',1,'close',1,'editorpos',[.03 0 1 1],'figpos',[.5 .5 .4 .2 ],'title','MASK-GENERATOR');
else
    z=param2struct(p);
end
if isempty(z.files);
    return; 
end

%———————————————————————————————————————————————
%%   no process
%———————————————————————————————————————————————



%% MAKE CHECK-list
li={};
n=1;
for i=1:size(pa,1)
    for j=1:size(z.files,1)
    li{n,1}=z.files{j,1};  %source
    [pa1 fi1 ext1]=fileparts(z.files{j,1});
    [pa2 fi2 ext2]=fileparts(z.files{j,2});
    li{n,2}=fullfile(pa{i}, [ fi2 ext1]); %target
    n=n+1;
    end
end%pa

if 1
    %% no copy stuff
    for i=1:size(li,1)
       copyfile(li{i,1},li{i,2}, 'f');
       disp([pnum(i,4) '] distribute file: <a href="matlab: explorer('' ' fileparts(li{i,2}) '  '')">' li{i,2} '</a>'  ]);
    end
end

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






function he=renamefiles(li,lih)
% keyboard
global an
prepwd=fileparts(an.datpath);
 [filex]=  cfg_getfile2(inf,'any',{'select files to distribute';'..can be 1 or several files'},[],prepwd,'.*');
        if isempty(char(filex)); return; end

% filex=selector2(li,lih,'out','col-1','selection','multi');


tbrename=[unique(filex(:))  ...                             %old name
         repmat({''}, [length(unique(filex(:))) 1])  ...   %new name
%          repmat({'inf'}, [length(unique(filex(:))) 1])  ...  %slice
%          repmat({'c'}, [length(unique(filex(:))) 1])  ...  %suffix
         ];

f = fg; set(gcf,'menubar','none','units','normalized','position',[    0.3049    0.4933    0.6    0.3922]);
t = uitable('Parent', f,'units','norm', 'Position', [0 0.1 1 .8], 'Data', tbrename,'tag','table',...
    'ColumnWidth','auto');
t.ColumnName = {'distributed files                          ',...
                'new name        (without path and without extension)         ',...
%                 'used volumes (inv,1,3:5),etc             ',...
%                 '(c)copy or (e)expand                  ',...
                };
            
%columnsize-auto            
set(t,'units','pixels');
pixpos=get(t,'position')  ;
set(t,'ColumnWidth',{pixpos(3)/2});
set(t,'units','norm');


t.ColumnEditable = [false true  ];
t.BackgroundColor = [1 1 1; 0.9451    0.9686    0.9490];

tx=uicontrol('style','text','units','norm','position',[0 .96 1 .03 ],...
    'string',      'distribute files, you can rename the files here',...
    'fontweight','bold','backgroundcolor','w');
pb=uicontrol('style','pushbutton','units','norm','position',[.05 0.02 .15 .05 ],'string','OK','fontweight','bold','backgroundcolor','w',...
    'callback',   'set(gcf,''userdata'',get(findobj(gcf,''tag'',''table''),''Data''));'          );%@renameFile


h={' #yg  ***COPY FILES or EXPAND 4D-files  ***'} ;
h{end+1,1}=['# 1st column represents the original-name '];
h{end+1,1}=['# 2nd column contains the new filename (without file-path and without file-extension !!)'];
h{end+1,1}=['  -if cells in the 2nd column are empty (no new filename declared), the original filename is used '];
 

%    uhelp(h,1);
%    set(gcf,'position',[ 0.55    0.7272    0.45   0.1661 ]);

setappdata(gcf,'phelp',h);

pb=uicontrol('style','pushbutton','units','norm','position',[.85 0.02 .15 .05 ],'string','Help','fontweight','bold','backgroundcolor','w',...
    'callback',   'uhelp(getappdata(gcf,''phelp''),1); set(gcf,''position'',[    0.2938    0.4094    0.6927    0.4933 ]);'          );%@renameFile
% set(gcf,''position'',[ 0.55    0.7272    0.45   0.1661 ]);
drawnow;
waitfor(f, 'userdata');
% disp('geht weiter');
tbrename=get(f,'userdata');
ikeep=find(cellfun('isempty' ,tbrename(:,2))) ;
ishange=find(~cellfun('isempty' ,tbrename(:,2))) ;

oldnames={};
for i=1:length(ikeep)
    [pas fis ext]=fileparts(tbrename{ikeep(i),1});
    tbrename(ikeep(i),2)={[fis ext]};
end
oldnames={};
for i=1:length(ishange)
    [pas  fis  ext]=fileparts(tbrename{ishange(i),1});
    [pas2 fis2 ext2]=fileparts(tbrename{ishange(i),2});
    tbrename(ishange(i),2)={[fis2 ext]};
end
he=tbrename;
%     disp(tbrename);
close(f);
    









