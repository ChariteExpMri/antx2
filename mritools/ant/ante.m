%% internal function

function fh=ante
fh.msub=@msub;
fh.madd=@madd;
fh.bbb     =@bbb;
fh.getsubjects     =@getsubjects;
fh.filematrix     =@filematrix;

fh.brukerimport     =@brukerimport;
fh.info='type strucname.function(inf) for help';
% disp('type strucname.function(inf) for help');

%����������������������������������������������������������������������������������������������������
function r=msub(a,b)
r=a-b;
%����������������������������������������������������������������������������������������������������
function r=madd(a,b)
r=a+b;
%����������������������������������������������������������������������������������������������������
function [e f g]=bbb(a,b)
e=11;
f=12;
g=13;
%����������������������������������������������������������������������������������������������������
function [subjects]=brukerimport(in)
try;
    antcb('status',1,'import Bruker data');
    
    
    if exist('in') && isinf(in)
        disp('*** import brukerData ***');
        disp('-->see [xbruker2nifti.m]')
        return
    end
    
    global an;
    % xbruker2nifti( 'O:\harms1\harmsTest_ANT\pvraw', 'Rare' )  %METAFOLDER is explicitly defined, read Rare, trmb is 1Mb
    % xbruker2nifti({'guidir' 'O:\harms1\harmsTest_ANT\'}, 'Rare' ) %startfolder for GUI is defined,  read Rare, trmb is 1Mb
    if isfield(an,'brukerpath') ;
        xbruker2nifti( an.brukerpath, 'Rare' ) ;
        %fun={@xbruker2nifti , an.brukerpath, 'Rare'   };
        %  feval(fun{1},fun{2:end})
    else
        xbruker2nifti({'guidir' [fileparts(an.datpath) filesep]} ,0)
        %xbruker2nifti( {'guidir' fileparts(an.datpath)}  , 'Rare' ) ;
        %   fun={@xbruker2nifti ,{'guidir' fileparts(an.datpath)}, 'Rare'   };
    end
    antcb('update'); %update subjects
catch
    antcb('status',0);
end
antcb('status',0);
%����������������������������������������������������������������������������������������������������

function [subjects]=getsubjects(in)
try;
    if isinf(in)
        disp('get selected subjects');
        return
    end
end
global an
lb3=findobj(findobj(0,'tag','ant'),'tag','lb3');
%li=get(lb3,'string');
va=get(lb3,'value');
subjects=an.mdirs(va);

%����������������������������������������������������������������������������������������������������
function [out]=filematrix(in)
warning off;
try
    if isinf(in)
        disp('plot the cases-file matrix, no inputs');
        disp('example:  r=ante;      r.filematrix();')
        return
    end
end
%% do
global an
out=[];

allsubjects=0;

if allsubjects==1
    pas=an.mdirs;
    files     =spm_select('FPListRec',an.datpath,'.*.nii'); files=cellstr(files);
else
    pas=antcb('getsubjects') ;
    files={};
    for i=1:length(pas)
        fdum     =spm_select('FPListRec',pas{i},'.*.nii'); fdum=cellstr(fdum);
        files=[files;fdum];
    end
end


filesuni=unique(regexprep(files,['.*' '\' filesep],''));
%sort oddEven
nf1=1:ceil(length(filesuni)/2);
nf2=ceil(length(filesuni)/2)+1:length(filesuni);
filedum=repmat({''}, [length(filesuni) 1]);
filedum(1:2:length(nf1)*2)=filesuni(nf1);
filedum(2:2:length(nf2)*2)=filesuni(nf2);
filesuni=filedum;
% tic
%  ma=[];
% for i=1: length(pas)
%       for j=1:length(filesuni)
%           b=regexpi2(files  ,  strrep(fullfile(pas{i},filesuni{j}) ,[filesep],[filesep filesep])  );
%           if ~isempty(b)
%            ma(j,i)=1;
%           end
%       end
% end
% toc
%
% tic
ma=[];
for i=1: length(pas)
    for j=1:length(filesuni)
        if exist(fullfile(pas{i},filesuni{j}))==2
            ma(j,i)=1;
        end
    end
end
% toc


%plot
col=[    1.0000         0         0
    0         0    1.0000
    0.2314    0.4431    0.3373
    0.6000    0.2000         0
    %          0    1.0000         0
    1.0000         0    1.0000
    1.0000    0.6941    0.3922
    %     0.7020    0.7804    1.0000
    0    0.7490    0.7490
    0.7490         0    0.7490];


%% alphabetsort
[dum iw]=sort(lower(filesuni));
filesuni=filesuni(iw);
ma      =ma(iw,:);


remn=mod(size(ma,1),size(col,1));
colmat=[repmat(col, (size(ma,1)-remn)/size(col,1) ,1);  col(1:remn,:) ];
colmat2=permute(repmat(colmat,[1 1 size(ma,2)]),  [1 3 2]);
ma2=repmat(ma,[1 1 3]).*colmat2;
bg=repmat(ma==0,[1 1 3]);


fg;
set(gcf,'tag','casefilematrix');
image(ma2+bg);
for i=1:size(ma,2)-1;     vline(i+.5,'color','k');      end
for i=1:size(ma,1)-1;    hline(i+.5,'color','k');       end

ht=[];
for i=1:  1: size(ma2,1)
    ht(end+1) =text(0.5,i, [ filesuni{i} '  '] ,'color',  colmat2(i,1,:)  ,  'tag','files');
end
set(ht,'HorizontalAlignment','right');
set(ht,'fontsize',7,'interpreter','none');

% ht2=[];
% for i=2:  2: size(ma2,1)
%     ht2(end+1) =text(size(ma,2)+.5 ,i,['  ' filesuni{i}],'color',  colmat2(i,1,:)  ,  'tag','files');
% end
% set(ht2,'HorizontalAlignment','left');
%
% set([ht  ht2],'interpreter','none');
set(gca,'ytick',[]);
cases=regexprep(pas,['.*'  '\' filesep ''],'');
set(gca,'xtick',[1: size(ma,2)], 'xticklabels',strrep(cases,'_',''),'fontweight','bold');

try; xticklabel_rotate([],55,strrep(cases,'_',''),'HorizontalAlignment','right','fontsize',6);
catch
    try
        set(gca,'xTickLabelRotation',55);
    end
end
set(findobj(gca,'type','text'),'interpreter','none');

% set(gca,'position',[0.15 .19 .845 .77])
set(gca,'position',[0.25 .19 .745 .77]);

drawnow;


% %set sideDOTdirection to read FILE
% hold on;
% for j=1: size(ma2,2)%right
%     for i=1: size(ma2,1)
%         if mod(i,2)==1
%             plot(j-0.5+.03,i,'<g','markerfacecolor','w','markeredgecolor','k','markersize',3);
%         else
%             plot(j+.5-.03,i,'>g','markerfacecolor','w','markeredgecolor','k', 'markersize',3);
%         end
%     end
% end

set(gcf,'units','norm','menubar','none','position',[0.0017    0.0689    0.5424    0.8989]);

set(gca,'units','norm');%,'position',[0.1 .13 .7 .83]);
set(gcf,'WindowButtonMotionFcn',{@matrixmotion, ma, filesuni,cases});
% set(gcf,'position',[0 0 1 1]);
set(gcf,'WindowButtonDownFcn',{@matrixbuttondown, ma, filesuni,cases});

%ELEMENTS
hp=uicontrol('Style', 'pushbutton',     'String', 'resize' , ...
    'units','normalized',   'tag','pbresize');
set(findobj(gcf,'tag','pbresize'),'position',[.0 .98 .05 .02],'fontsize',10,...
    'callback',@resize);

hp=uicontrol('Style', 'radiobutton',     'String', 'BG-flip' ,...
    'units','normalized' ,    'tag','rbflipBG');
set(findobj(gcf,'tag','rbflipBG'),'position',[.05 .98 .05 .02],'fontsize',10,'userdata',0,'value',0);

hp=uicontrol('Style', 'popup',     'String', 't2.nii|AVGT.nii|ANOpcol.nii|w_t2.nii|x_t2.nii|none','units','normalized' ,   'Position', [.1 .9 .1 .05],...
    'tag','popbackground');
set(hp,'position',[.1 .9 .2 .1],'fontsize',12,'tooltipstring','select background image')   ;

%% shwoImageHeader
hp=uicontrol('Style', 'radiobutton',     'String', 'show ImageHeader','units','normalized' ,   'Position', [.3 .98 .15 .02],...
    'tag','showimageheader');
set(hp,'fontsize',6,'tooltipstring','shows the imageheader')   ;

%% HELP
hp=uicontrol('Style', 'pushbutton',     'String', 'help','units','normalized' ,   'Position', [.45 .98 .06 .02],...
    'tag','help_filematrix','callback' , @help_filematrix);
set(hp,'fontsize',12,'tooltipstring','help')   ;

%% SELECT FOLDERS/FILES
hp=uicontrol('Style', 'radiobutton',     'String', 'select File/Folders','units','normalized' ,   'Position', [.6 .98 .15 .02],...
    'tag','selectobject','callback' , @getfolder);
set(hp,'fontsize',6,'tooltipstring','select files/folders for subsequent jobs')   ;

taskselection={
    'select these folders in ANT-mouse-folder-listbox'
    'copy <unique>          folders to clipboard'
    'copy <unique> fullpath folders to clipboard'
    'copy <unique>          files   to clipboard'
    'copy          fullpath files   to clipboard'
    'copy <unique>          folders to clipboard #MATLAB-CELLSTYLE'
    'copy <unique> fullpath folders to clipboard #MATLAB-CELLSTYLE'
    'copy <unique>          files   to clipboard #MATLAB-CELLSTYLE'
    'copy          fullpath files   to clipboard #MATLAB-CELLSTYLE'
    } ;
hp=uicontrol('Style', 'popupmenu',    'units','normalized' , 'Position', [.75 .98 .1 .02],...
    'tag','select','callback' , @foldertask,...
    'String', taskselection );
set(hp,'fontsize',7,'tooltipstring','perform this jobs for selected files or folders')   ;


% set(findobj(gcf,'tag','pbresize'),'units','points');
%=============================================================
%% fontsize
if get(0,'ScreenPixelsPerInch')<100
    try
        iniparas=antini;
        fs=iniparas.fontsize;
    catch
        fs=8;
    end
    %     set(findobj(gcf,'type','text'),           'fontsize',fs-2);
    set(findobj(gcf,'style','pushbutton'),    'fontsize',fs-2);
    set(findobj(gcf,'tag','popbackground'),   'fontsize',fs-1);
    set(findobj(gcf,'style','radiobutton'),    'fontsize',fs-2);
end

set(findobj(gcf,'tag','pbresize'),'units','norm');
set(findobj(gcf,'tag','popbackground'),'units','norm','fontunits','norm');
set(findobj(gcf,'style','radiobutton'),'units','norm','fontunits','norm');
% set(gcf,'position',[0.0653    0.1311    0.4576    0.6544]);

% set(gcf,'menubar','none','position',[0.0017    0.0689    0.5424    0.8989]);
% set(gcf,'position',[0.0021    0.0689    0.5365    0.8989]);
% drawnow;
% set(gcf,'position',[0.0017    0.0689    0.5424    0.8989]);
drawnow;

% label=repmat({'ee'},[100 1])
% set(datacursormode(gcf), 'DisplayStyle','datatip', 'SnapToDataVertex','off','Enable','on', 'UpdateFcn',{@showlabel,label});

function foldertask(h,e)
hsel=findobj(gcf,'tag','selected');
if isempty(hsel); return; end
us=get(hsel,'userdata');
if isstruct(us); us={us};   end
global an

s.folder   = unique(cellfun(@(a) {[a.folder]},us));
s.fpimages = unique(cellfun(@(a) {[a.fpimage]},us));
s.images   = unique(cellfun(@(a) {[a.image]},us));

%          delete(findobj(gcf,'tag','selected'));

%     'select these folders in ANT-mouse-folder-listbox'
%     'copy <unique>          folders to clipboard'
%     'copy <unique> fullpath folders to clipboard'
%     'copy <unique>          files   to clipboard'
%     'copy          fullpath files   to clipboard'
%     'copy <unique>          folders to clipboard #MATLAB-CELLSTYLE'
%     'copy <unique> fullpath folders to clipboard #MATLAB-CELLSTYLE'
%     'copy <unique>          files   to clipboard #MATLAB-CELLSTYLE'
%     'copy          fullpath files   to clipboard #MATLAB-CELLSTYLE'

if get(h,'value')      ==1                              %select [ANT]-folder
    xselect(0,struct('dirs',{s.folder}));
elseif get(h,'value')  ==2                              %FOLDER
    mat2clip(s.folder);
elseif get(h,'value')  ==3                              %FPfolder
    mat2clip(stradd(s.folder,[an.datpath filesep],1));
elseif get(h,'value')  ==4                              %IMAGES
    mat2clip(s.images);
elseif get(h,'value')  ==5                              %FP-IMAGES
    mat2clip(s.fpimages);
    
elseif get(h,'value')  ==6                              %FOLDER
    mat2clip(s.folder);
    clip2clipcell;
elseif get(h,'value')  ==7                              %FPfolder
    mat2clip(stradd(s.folder,[an.datpath filesep],1));
    clip2clipcell;
elseif get(h,'value')  ==8                              %IMAGES
    mat2clip(s.images);
    clip2clipcell;
elseif get(h,'value')  ==9                              %FP-IMAGES
    mat2clip(s.fpimages);
    clip2clipcell;
end





function txt = showlabel(varargin)
label = varargin{3};
txt   = label{get(varargin{2}, 'DataIndex')};

function help_filematrix(h,e)

h={' ##m CASE-FILEM-MATRIX'};
h{end+1,1}=[ ' shows all nifti-files (y-axes) of all folders (x-axes) '                      ];
h{end+1,1}=[' #by  OVERLAY  '      ];
h{end+1,1}=[' to overlay image onto another image >>select background-IMAGE from [image]-pulldown'      ];
h{end+1,1}=[' to swap foreground and background image usE [BG]-radiobutton'      ];
h{end+1,1}=[' #by  DISPLAY - MOUSE'      ];
h{end+1,1}=[' #g [left  click] #k  on cell to show this volume/overlayed volumes'      ];
h{end+1,1}=[' #g [right click] #k  on cell to show this volume/overlayed volume in MRICRON'      ];
h{end+1,1}=[' #g [left double-click] #k  to open the directory and mark selected file'      ];
h{end+1,1}=[' #by  UICONTROLS  '      ];
h{end+1,1}=[' #b [RESIZE]-BUTTON  #k : toggle window in hakf screen or full screen view'      ];
h{end+1,1}=[' #b [BG]-radiobutton  #k : swap foreground and background images'      ];
h{end+1,1}=[' #b [image]-pulldown  #k : select a background image here'      ];
h{end+1,1}=[' #b [SHOW IMAGEHEADER]-radiobutton  #k : shows the header of the image under the hovered mousePointer'      ];
h{end+1,1}='';
h{end+1,1}=[' #b [selectFiles/Folders]-radiobutton  #k: [x] select multiple images/folder for further jobs '      ];
h{end+1,1}=[' #b                                    #k: [ ] default: select one image and display image/overlay'      ];
h{end+1,1}=[' #b [select jobs]-pulldown  #k : perform one of these jobs on selected files/folders'      ];
h{end+1,1}=[' #k       -to apply a job [selectFiles/Folders] has to be set to [x] and several files/folders has to be picked before'      ];
h{end+1,1}='';

h{end+1,1}=[''      ];
h{end+1,1}=[''      ];
h{end+1,1}=[''      ];
h{end+1,1}=[''      ];
h{end+1,1}=[''      ];
h{end+1,1}=[''      ];

uhelp(h,0,'position',[ 0.6330    0.5178    0.3535    0.40]);


function getfolder(h,e)
%     hfig=get(h,'parent');
%     if isempty(get(hfig,'userdata'))
%         us=[] ;
%         set(hfig,'userdata',us);
%     end
%     us=get(hfig,'userdata');

if get(h,'value')==1
    delete(findobj(gcf,'tag','selected')); %DELETE PREV. MARKS
    
    %         us.WindowButtonDownFcn=  get(hfig,'WindowButtonDownFcn');
    %         set(hfig,'WindowButtonDownFcn',[]);
    %         set(hfig,'userdata',us);
else
    %         DO SOMETHING
    hsel=findobj(gcf,'tag','selected');
    if isempty(hsel); return; end
    %          us=get(hsel,'userdata');
    %          folder = unique(cellfun(@(a) {[a.folder]},us))
    %          '--------'
    %          fpimages = unique(cellfun(@(a) {[a.fpimage]},us))
    %          '--------'
    %          images = unique(cellfun(@(a) {[a.image]},us))
    
    delete(findobj(gcf,'tag','selected'));
    %         set(hfig,'WindowButtonDownFcn',us.WindowButtonDownFcn);
end


function resize(he,er)
po=get(gcf,'position');
if po(3)<=.5; po(3)=1;
    set(gcf,'position',po);
elseif po(3)>=.5; po(3)=.5;
    set(gcf,'position',po);
end

function matrixmotion(he,er, ma, filesuni,cases)

hfig=he;
ax=findobj(hfig,'type','axes');
cp=get(ax,'CurrentPoint');

try
    
    cp=round(cp(1,1:2));
    
    % h=title(  ['                 ' filesuni{cp(2)}    '       -   '    cases{cp(1)} ],'interpreter','none',...
    %     'tag','title','HorizontalAlignment','left');%,'verticalalignment','cap');
    set(hfig,'name',['                 ' filesuni{cp(2)}    '       -   '    cases{cp(1)} ]);
    
    %% display header Info
    if get(findobj(gcf,'tag','showimageheader'),'value')==1
        global an
        fi=fullfile(an.datpath,cases{cp(1)},filesuni{cp(2)});
        ha=spm_vol(fi);
        hb=ha(1);
        hdr=[struct2list(hb) ;  ['4th dim= ' num2str(size(ha,1))]   ];
        hdr=cellfun(@(a) {[' ' a]},hdr);
        
        %
        %     ieq=regexpi(hdr,'=')
        %     iempt=cellfun('isempty',ieq)
        %     ieq(iempt)={0}
        %     mxeq=max(cell2mat(ieq));
        %
        
        hf2=findobj(0,'tag','msgx');
        if isempty(hf2)
            %uhelp(hdr,0,'fontsize',8,'position',[ 0.6309    0.7456    0.3590    0.1972]);
            
            hf2=figure('color','w','units','normalized','position',[    0.4875    0.6778    0.2063    0.2078],...
                'tag','msgx','menubar','none','NumberTitle','off');
            
            
            p=uicontrol('style','edit','units','norm','position',[0 0 1 .98],'max',1000,'backgroundcolor','w');
            set(p,'string',hdr,'HorizontalAlignment','left','tag','txtm');
            % set(gcf,'menubar','none')
            set(hf2,'position',[    0.6483    0.7744    0.3073    0.1933]);
            
        else
            hlb=findobj(hf2,'tag','txtm') ;
            set(hlb,'string',hdr);
        end
        
        %[  filesuni{cp(2)}    '   -   '    cases{cp(1)} ]
        set(findobj(0,'tag','msgx'),'name', [  filesuni{cp(2)}    '   -   '    cases{cp(1)} ]  );
        drawnow;
        
        figure(he);
        
        
    end
    
    
end


function matrixbuttondown(he,er, ma, filesuni,cases)


[button sca] = mousebutton;
if button==0; return; end




hgetfolder    = findobj(gcf,'tag','selectobject');
isfoldersel   = get(hgetfolder, 'value');

% return

cp=get(gca,'CurrentPoint');
cp=round(cp(1,1:2));
si=size(ma);
if ~(cp(2)>=1 & cp(2)<=si(1) & cp(1)>=1 & cp(1)<=si(2))  ; return ; end  %outsid boundarys (files x cases)



% show selection
if isfoldersel == 0
    delete(findobj(gcf,'tag','selected'));
    hold on;
    plot(cp(1),cp(2),'wx','markersize',12,'tag','selected');
else
    hselected=findobj(gcf,'tag','selected');
    try
        cox=cell2mat([get(hselected,'xdata') get(hselected,'ydata')]);
    catch
        cox=([get(hselected,'xdata') get(hselected,'ydata')]);
    end
    if isempty(cox)
        iexist=[];
    else
        iexist=find(cox(:,1)==cp(1) & cox(:,2)==cp(2));
    end
    if ~isempty(iexist)  %delete  SELECTION agaon
        delete(hselected(iexist));
        return
    else  %SELECTION OF FOLDERS
        hold on;
        plx= plot(cp(1),cp(2),'k*','markersize',12,'tag','selected');
        
        global an
        
        us.image   = filesuni{cp(2)};
        us.folder  = cases{cp(1)};
        us.fpimage =fullfile(an.datpath, cases{cp(1)},filesuni{cp(2)});
        set(plx,'userdata',us);
        
        return
    end
end


if ma(cp(2),cp(1))==0 %NONexist File
    return
end







% ma(cp(2),cp(1))
%  return

global an
hp=findobj(gcf,'tag','popbackground');
list=get(hp,'string'); if  ischar(list); list=cellstr(list); end
bgimg=list{get(hp,'value')};
orient=2; %orientation
if strcmp(bgimg,'t2.nii')
    orient=3;
end


f1=fullfile(an.datpath, cases{cp(1)},bgimg);
f2=fullfile(an.datpath, cases{cp(1)},filesuni{cp(2)});

templatepath=fullfile(fileparts(an.datpath),'templates');

if exist(f1)~=2
    f1=fullfile(   templatepath ,bgimg);
end
if exist(f2)~=2
    f2=fullfile(   templatepath ,filesuni{cp(2)});
end

[pax fix extx]=fileparts(f1);
flipbg=get(findobj(gcf,'tag','rbflipBG'),'value'); %FLIP BG
if flipbg==1
    if strcmp(fix,'none')==0
        f1a=f1;
        f1=f2;
        f2=f1a;
    else
        f1=f2;
    end
    
end




[pa1 fi ext]=fileparts(f2);
if     ~strcmp(ext,'.nii'); return ; end  %no NIFTIfile
fis={f1 f2};
% return
strings=[f1 '  - ' f2];
oneImage=0;
if strcmp(bgimg,'none');
    fis={f2};
    oneImage=1;
    if regexpi(filesuni{cp(2)},'i\w_') ==1  %inverse warped
        orient=3;
    end
end  % no background chosen
% ovlcontour(fis,orient,['2'],[.08 0 0.05 0.05],[1 1 0],{[] .3 [ ] }, strings);
cmap=jet;
if oneImage==1;
    cmap=gray;
end

%����������������������������������������������������������������������������������������������������
%% DEPENDENT MOUSE_CLICK

if button==1
    try
        ovlcontour(fis,orient,['2'],[.08 0 0.05 0.05],[1 1 0],{[cmap] .3 [ ] }, strings,...
            struct('position', [0.601    0.1783    0.3889    0.4667] ));
    catch
        lasterrrorx=lasterror ;
        
        cprintf([1 0 1],[ repmat('_',[1 100])  '\n']);
        disp(lasterrrorx.message);
        cprintf([1 0 1],['possible reason: set background image in the upper pulldown menu to "none" '  '\n']);
        cprintf([1 0 1],[ repmat('_',[1 100])  '\n']);
        
    end
    
    %     set(gcf,'position',[0.5701    0.1783    0.3889    0.4667]);
    % elseif strcmp(mouse_seltype,'alt')
    %     if flipbg==1
    %         explorerpreselect(f1);
    %     else
    %         explorerpreselect(f2);
    %     end
    %    disp(['renamed: <a href="matlab: explorerpreselect(''' f2 ''')">' f2 '</a>'  ]);
elseif  button==2
    if ispc
        p=[fullfile(fileparts(fileparts(fileparts(which('ant.m')))),'mricron','mricron.exe') ];
        if exist(p)~=2;  disp('mricron-path not found'); return; end
    elseif ismac
        p=[fullfile(fileparts(fileparts(fileparts(which('ant.m')))),'mricron','MRIcroGL.app') ];
        if exist(p)~=7;  disp('MRIcroGL.app-path not found'); return; end
    else
        disp(['mricron/MRIcroGL.app not provided for other OS-ante.m' ])
    end
    
    
    %----------------------------------------------
    %% SINGLE IMAGE
    %----------------------------------------------
    if strcmp(bgimg,'none')==1
       if ispc
        m1=[' ' f2 ' -c -0'];
        system(['start ' [p m1 ] ]);
        try
            system(which('rmricronmove.exe'));%rightPositioning
            pause(1);
            system(which('rmricronmove.exe'));%rightPositioning
        end
       elseif ismac
           pa_mricrongl=fullfile((fileparts(fileparts(fileparts(which('ant.m'))))),'mricron','MRIcroGL.app/Contents/MacOS/MRIcroGL');
           vm=[pa_mricrongl ' -S "begin LOADIMAGE(''' f2 ''');ORTHOVIEW(0.5,0.5,0.5);COLORNAME(''Grayscale'');end."'];
           system([vm ' &']);
       end
%----------------------------------------------
    else
        %----------------------------------------------
        %% OVERLAY
        %----------------------------------------------

        %         if flipbg==1
        %             g2=f2;
        %             g1=f1;
        %         else
        g1=f1;
        g2=f2;
        %         end
        if ispc
            % start mricron .\templates\ch2.nii.gz -c -0 -l 20 -h 140 -o .\templates\ch2bet.nii.gz -c -1 10 -h 130
            m1=[' ' g1 ' -c -0'];
            m2=[' -o ' g2 ' -c -13'];
            system(['start ' [p m1 m2] ]);
            try
                system(which('rmricronmove.exe'));%rightPositioning
                pause(1);
                system(which('rmricronmove.exe'));%rightPositioning
            end
        elseif ismac
            pa_mricrongl=fullfile((fileparts(fileparts(fileparts(which('ant.m'))))),'mricron','MRIcroGL.app/Contents/MacOS/MRIcroGL');
            % pa='/Volumes/O/antx/mricron/MRIcroGL.app/Contents/MacOS/MRIcroGL'
            % f1='/Users/skoch/Desktop/test/x_t2.nii'
            % f2='/Users/skoch/Desktop/test/ANOpcol.nii'
            vm=[pa_mricrongl ' -S "begin LOADIMAGE(''' f1 ''');OVERLAYLOAD(''' f2 ''');ORTHOVIEW(0.5,0.5,0.5); OVERLAYCOLORNAME(1,''ACTC'');end."'];
            system([vm ' &']);
        end
    end
elseif  button==3
    if flipbg==1
        explorerpreselect(f1);
    else
        explorerpreselect(f2);
    end
end









