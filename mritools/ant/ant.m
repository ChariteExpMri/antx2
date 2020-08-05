

% #b [ANT]-TOOLBOX MAIN GUI
% #wg                                                                   #k
% #wg              *         *      *   * * * * * *                     #k
% #wg            *   *       * *    *        *                          #k
% #wg           *     *      *  *   *        *                          #k
% #wg          * * * * *     *   *  *        *                          #k
% #wg         *         *    *    * *        *                          #k
% #wg        *           *   *      *        *     2017, v1.0           #k
% #wg                                                                   #k


% #k
% #r &#10102 &#10026; &#10022 &#10061;&#10070; <big><big><big><big><big>ANT
%
%
%
%
%
%
%% #b this is the ANT-MAIN GUI
% #g INPUT: -e
% #g OUTPUT: -
% -----------------------------


% % uhelp({' #r &#10102 &#10026; &#10022 &#10061;&#10070; <big><big><big><big><big>ANT'})
% #k
% #k
% #k

function ant

% %tags:
% lb1: functions
% lb2: parameter-file
% lb3: mice cases

warning off; close all
%%
% in spm.m
% comment line-345-  :% spm_figure('close',allchild(0));                           fprintf('.');

funtb=antfun('funlist');
funs=funtb(:,1);



try;delete(findobj(0,'tag','ant'));end
clear global an;
%==================================================
%%                  UICONTROLS
%==================================================
%% FIG
h=figure('color','w','units','normalized','menubar','none', 'tag','ant','name','ANT',...
    'NumberTitle','off',...
    'position',[  0.5396    0.42    0.3677    0.4994]);
% set(gcf,'closereq','spm(''Quit'')','HandleVisibility','off')
set(h,'closereq','');
set(h,'KeyPressFcn',@keys);
set(h,'WindowButtonMotionFcn', @windbuttonmotion);

% fg
try
    % drawnow
    % pause(.1);
    warning('off','MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');
    jframe=get(gcf,'javaframe');
    icon=fullfile(fileparts(which('antver.m')),'mouse.png');
    %icon='O:\data\karina\brain.gif'
    jIcon=javax.swing.ImageIcon(icon);
    jframe.setFigureIcon(jIcon);
end




%% statusMsg
h = uicontrol('style','text','units','normalized','tag','status',...
    'string','status: idle','fontsize',6,'backgroundcolor',[1 1 1],'foregroundcolor', [0.2000    0.6000    1.0000],...
    'HorizontalAlignment','left','position',[[0	.56 .9  .025]],'foregroundcolor',[ 0 0 1]);



%% FUNCTIONS LISTBOX
funtb(:,3)=cellfun(@(x,y) ['<html> <b> ' x '</b><br>' y '</html>'],funtb(:,1),funtb(:,3),'un',0);
hfun = uicontrol('style','list','units','normalized','position',[.6 0 .4 .5],'tag','lb1',...
    'string',funs,'fontsize',15,'max',10,'min',1,'backgroundcolor',[1 1 1], 'userdat', funtb);

%% configs-LB
h = uicontrol('style','list','units','normalized','position',[0 .7 1  .3],'tag','lb2',...
    'string','','fontsize',15,'max',10,'min',1,'backgroundcolor',[1 1 1],'fontsize',4,'fontweight','normal');

%% SUBJECTS-LB
h = uicontrol('style','list','units','normalized','position',[.0 0 .46  .5],'tag','lb3',...
    'string','','fontsize',7,'max',10,'min',1,'backgroundcolor',[1 1 1],'callback',@lb3_callback);

%% load & clearCASES & check
h = uicontrol('style','pushbutton','units','normalized','position',[.0 .5 .1 .05],'tag','pbloadsubjects',...
    'string','update','fontsize',10,'fontweight','bold','callback',{@antcb,'update'});

h = uicontrol('style','radiobutton','units','normalized','position',[.1 .5 .2 .05],'tag','rbsortprogress',...
    'string','sort-Progress','value',0,'fontsize',6,'backgroundcolor','w','callback',{@antcb,'update'},...
    'tooltip','sort folders relative to progress (performed processing steps)');

%DIRS-number selected
h = uicontrol('style','text','units','normalized','position',[.3 .5 .2 .025],'tag','tx_dirsselected',...
    'string',['1 dir(s) selected' ],'fontsize',6,'backgroundcolor','w',...
    'tooltip','number of currently selected directories','foregroundcolor',[ 0 .5 0],'fontweight','normal');


% h = uicontrol('style','pushbutton','units','normalized','position',[.1 .5 .1 .05],'tag','pbclear',...
% 	'string','clearsubjects','fontsize',10,'fontweight','bold','callback',{@antcb,'clearsubjects'});

% h = uicontrol('style','checkbox','units','normalized','position',[.2 .5 .1 .05],'tag','rb1',...
%     'string','takeCases','fontsize',10,'value',0);


%% PBload
h = uicontrol('style','pushbutton','units','normalized','position',[.0 .6 .1 .08],'tag','pbload',...
    'string','loadproj','fontsize',13,                                        'callback',{@antcb,'load'},'tooltip','load the studies''s configfile');

% h = uicontrol('style','pushbutton','units','normalized','position',[.0 .6 .1 .08],'tag','pbload',...
%     'string','loadproj','fontsize',13,                                        'callback',{@testcrash},'tooltip','load the studies''s configfile');



h = uicontrol('style','pushbutton','units','normalized','position',[.1 .6 .05 .08],'tag','pbconfig',...
    'string','','fontsize',13,                                        'callback',{@antcb,'settings'},'tooltip','settings',...
    'backgroundcolor','w');
% icon=which('profiler.gif');
icon=strrep(which('ant.m'),'ant.m','settings.png');
[e map]=imread(icon)  ;
e=ind2rgb(e,map);
% e(e<=0.01)=nan;
set(h,'cdata',e);



%% RUN
h = uicontrol('style','pushbutton','units','normalized','position',[.47 .3 .12 .1],'tag','pb1',...
    'string',sprintf('<html>   <b>%s<br></b><h3><font color="blue"> %s </html>', 'RUN FUN','MOUSE first'  ),...
    'tooltipstring',sprintf(['<html>   <b><font color="green">%s<br></b><font color="blue"> %s </html>'], ...
    'MOUSE first (mouse-wise)',  ['<u>For all mice from (i) to (n): </u> <br>First apply all function to Mouse<sub>(i)</sub><br> ...than apply all functions to Mouse<sub>(i+1)</sub>'  ...
    ' <br>...finally apply all functions to Mouse<sub>(n)</sub>'...
    '  <br><font color="green">..in most cases the standard option ' ] ),...
    'fontsize',15,'callback',  {@antcb,'run'});%'antfun(''run'')'
%% RUN
h = uicontrol('style','pushbutton','units','normalized','position',[.47 .2 .12 .1],'tag','pb2',...
    'string',sprintf('<html>   <b>%s<br></b><h3><font color="blue"> %s </html>', 'RUN FUN','FUN first'  ),...
    'tooltipstring',sprintf(['<html>   <b><font color="green">%s<br></b><font color="blue"> %s </html>'], ...
    'FUNCTION first (function-wise)',  ['<u>For all functions from (j) to (m): </u> <br>First apply function<sub>(j)</sub> to all mice <br>...than apply function<sub>(j+1)</sub> to all mice'  ...
    '<br>...finally apply function<sub>(m)</sub> to all mice'...
    '  <br><font color="green">....useful to bunch manual taks' ] ),...
    'fontsize',15,'callback',  {@antcb,'run2'});%'antfun(''run'')'

%% CLOSE FIG
h = uicontrol('style','pushbutton','units','normalized','position',[.9 .5 .05 .05],'tag','closefigs',...
    'string','cF','fontsize',8,'fontweight','bold','callback',@closeallfigs,'tooltip','close all figures except [ANT]&[HELP]');
h = uicontrol('style','pushbutton','units','normalized','position',[.95 .5 .05 .05],'tag','closefigs',...
    'string','cM','fontsize',8,'fontweight','bold','callback','try;rclosemricron ; end','tooltip','close mricron imagesc');

h = uicontrol('style','pushbutton','units','normalized','position',[.95 .55 .05 .05],'tag','closefolders',...
    'string','cDir','fontsize',8,'fontweight','bold','tooltip','close all open folders',...
    'callback',@closefolders);

h = uicontrol('style','pushbutton','units','normalized','position',[.9 .55 .05 .05],'tag','showCommandHistory',...
    'string', ['anth']   ,'fontsize',8,'fontweight','bold','tooltip','show command history',...
    'callback',@showCommandHistory);


%% RADIOS
h = uicontrol('style','radiobutton','units','normalized','position',[.94 .61 .08 .05],'tag','radioshowhelp',...
    'string','hlp','fontsize',5,'fontweight','normal',...
    'callback',@radioshowhelp,'backgroundcolor',[1 1 1],...
    'tooltip',['show/hide help window when hovering over menu functions' char(10) ...
    '..press [esc]-button to close main menu when hovering over specif function ' char(10) ....
    '  this will preserve the information/help of the last mouse-over function in the help window ']);


h = uicontrol('style','radiobutton','units','normalized','position',[.94 .65 .08 .05],'tag','radioshowHTMLprogress',...
    'string','PR','fontsize',5,'fontweight','normal','tooltip','show/hide HTML progress report for initialization,coregistration, segmentation & warping',...
    'callback',@radioshowHTMLprogress,'backgroundcolor',[1 1 1],'value',1);

c = uicontextmenu;
plotline.UIContextMenu = c;
m1 = uimenu(c,'Label','show HTML summary now','Callback',@showHTMLsummary);
m1 = uimenu(c,'Label','export HTML summary','Callback',@fun_summary_export);
set(h,'UIContextMenu',c);

%====INDICATE LAST UPDATE-DATE ========================
% vstring=strsplit(help('antver'),char(10))';
% idate=max(regexpi2(vstring,' \w\w\w 20\d\d (\d\d'));
% dateLU=['ANTx2  vers.' char(regexprep(vstring(idate), {' (.*'  '  #\w\w ' },{''}))];
dateLU=antcb('version');
h = uicontrol('style','pushbutton','units','normalized','position',[.94 .65 .08 .05],'tag','txtversion',...
    'string',dateLU,'fontsize',5,'fontweight','normal',...
    'tooltip',['date of last update' char(10) '..click to see last updates "antver"']);
% set(h,'position',[.2 .65 .08 .02],'fontsize',6,'backgroundcolor','w','foregroundcolor',[.7 .7 .7])  
set(h,'position',[.5 .67 .25 .027],'fontsize',7,'backgroundcolor','w','foregroundcolor',[0.9294    0.6941    0.1255],...
    'horizontalalignment','left','callback',{@callantver});
%============================================


% disp('try; evalc(''system(''TASKKILL /F /IM explorer.exe & explorer'')''); end;')

% M<sub>i</sub>(f1,f2...fn)

% set(gcf, 'HandleVisibility', 'off');

%
% %% TOOLTIP functions
% lb3=findobj(findobj(0,'tag','ant'),'tag','lb1');
% hfun_jScrollPane = java(findjobj(hfun));
% hfun_jListbox     = hfun_jScrollPane.getViewport.getView;
% tooltipscell=funtb(:,3);
% set(hfun_jListbox, 'MouseMovedCallback', {@tooltip_lb1,hfun, tooltipscell });
%
% cmenuCases ;%CONTEXTMENU CASES
%
%
% %% FUNCTIONS-listbox: Mouse-movement callback-->tooltip
% function tooltip_lb1(jListbox, jEventData, hListbox,tooltipscell)
% mousePos = java.awt.Point(jEventData.getX, jEventData.getY);
% % hoverIndex = jListbox.locationToIndex(mousePos) + 1;
% hoverIndex=get(mousePos,'Y');
% fs=get(hListbox,'fontsize');
% [hoverIndex   hoverIndex/fs];
% est=fs*2;
% re=rem(hoverIndex,est);
% va=((hoverIndex-re)/est)+1;
% %    t=[hoverIndex    va+1   ]
% if     va>0 && va<=length(tooltipscell)
%     listValues = get(hListbox,'string');
%     hoverValue = listValues{va};
%     msgStr = sprintf('<html>   <b>%s</b> %s </html>', hoverValue, tooltipscell{va} );
%
%     set(hListbox, 'Tooltip',msgStr);
% end
drawnow;
cmenuCases ;%CONTEXTMENU CASES
us.LastActivatedListbox=[]; us.testvar='###';
set(findobj(gcf,'tag','ant'),'userdata',us);

% set(gcf,'WindowButtonMotionFcn', @figmotion)
drawnow;
setMenubar;


%% TOOLTIP-2
hListbox = findobj(gcf,'tag','lb3'); %uicontrol(hFig, 'style','listbox','units','normalized', 'pos',[.2 .2 .4 .4], 'string',listItems);
jScrollPane = findjobj(hListbox);% Get the listbox's underlying Java control
jListbox = jScrollPane.getViewport.getComponent(0);% We got the scrollpane container - get its actual contained listbox control
jListbox = handle(jListbox, 'CallbackProperties');% Convert to a callback-able reference handle
set(jListbox, 'MouseMovedCallback', {@mouseMovedCallback,hListbox});% Set the mouse-movement event callback

hListbox2 = findobj(gcf,'tag','lb1'); %uicontrol(hFig, 'style','listbox','units','normalized', 'pos',[.2 .2 .4 .4], 'string',listItems);
jScrollPane2 = findjobj(hListbox2);% Get the listbox's underlying Java control
jListbox2 = jScrollPane2.getViewport.getComponent(0);% We got the scrollpane container - get its actual contained listbox control
jListbox2 =  handle(jListbox2, 'CallbackProperties');% Convert to a callback-able reference handle
set(jListbox2, 'MouseMovedCallback', {@mouseMovedCallback,hListbox2});% Set the mouse-movement event callback

%% FONTSIZE
screen=get(0,'screensize');
if screen(3)==2880
    antcb('fontsize','default');
else
    try
        iniparas=antsettings;
        us.fontsize=iniparas.fontsize;
        antcb('fontsize',iniparas.fontsize);
    catch
        us.fontsize=8;
        antcb('fontsize',us.fontsize);
    end
end

set(findobj(gcf,'tag','ant'),'userdata',us);

%============================================
addcontextmenuLB1;  %contextmenu of LB1 (function-listbox)


if ismac
    set(findobj(gcf,'tag','tx_dirsselected'),'fontsize',9);
    set(findobj(gcf,'tag','status'         ),'fontsize',9);
else
    set(findobj(gcf,'tag','tx_dirsselected'),'fontsize',7);
    set(findobj(gcf,'tag','status'         ),'fontsize',7);
end



% % % % %% wating ICON
% % % % h1=uicontrol('style','radio','units','norm');
% % % % set(h1,'string',['<html><img src ="file:/' fullfile( fileparts(which('ant.m')), 'anim3.gif') '">'],'backgroundcolor','w');
% % % % % set(h1,'style','togglebutton','position',[.4 .2 .4 .2],'fontsize',10,'enable','on')
% % % % set(h1,'style','radio','position',[0 0 .3 .15],'hittest','off');
% % % %
% % % %
% jLabel = javaObjectEDT('javax.swing.JLabel',javaObjectEDT('javax.swing.ImageIcon',fullfile(pwd, 'anim3.gif') ));
% [hJ,hC] = javacomponent(jLabel,getpixelposition(gcf).*[0 0 1 1],gcf);
% set(hC,'units','normalized','position',[0 0 .05 .05])
%


set(findobj(gcf,'tag','lb3') ,'KeyPressFcn',@antkeys)

% ==============================================
%%   settings from antsettings
% ===============================================

settings=antsettings;

 hradio    =findobj(findobj(0,'tag','ant'),'style','radio');
 set(hradio,'fontsize',settings.fontsize-2);
 
 hradiohelp=findobj(findobj(0,'tag','ant'),'tag','radioshowhelp');
 set(hradiohelp,'value', settings.show_instant_help);
 if get(hradiohelp,'value')==1
     drawnow;
     showfunctionhelp
 end

hprogress=findobj(gcf,'tag','radioshowHTMLprogress'); %HTML progress
if ~isempty(hprogress)
    try; set(hprogress,'value',settings.show_HTMLprogressReport); end
end

if settings.show_intro==1
    try
        antintro
    end
end

%=====================================
%% CHECK ELASTIX INSTALLATION
if isunix
    
    if ismac
        mac_checkfilepermission
    else
        
        [~,msg]=evalc('system(''elastix'')');
        if msg~=0
            setup_elastixlinux;
%             warning on;
%             warning('..ELASTIX is not installed') ;
%             padinfo=fullfile(fileparts(which('ant.m')),'docs');
%             info  ='readme_LINUX.txt';
%             showinfo2('..for help please inspect ', fullfile(padinfo,info));
%             disp('..use "setup_elastixlinux" to install ELASTIX and MRICRON');
        end
    end
    

end
    
%%============================================
%============================================
%============================================
function callantver(e,e2)
antver;

function radioshowhelp(h,e)
hradiohelp=findobj(findobj(0,'tag','ant'),'tag','radioshowhelp');
if get(hradiohelp,'value')==1
    
else
    delete(findobj(findobj(0,'tag','uhelp')));
end

function lb3_callback(h,e) %update number of selections
% h
% e
le=length(get(h,'value'));
tx=findobj(gcf,'tag','tx_dirsselected');

try
    set(tx,'string',[ num2str(le) '/' num2str(size(get(h,'string'),1)) ' dirs. selected' ]);
catch
    set(tx,'string',[ num2str(le) ' dir(s) selected' ]);
end

% Mouse-movement callback
function mouseMovedCallback(jListbox, jEventData, hListbox)
try
    msg=get(hListbox,'userdata');
    mousePos = java.awt.Point(jEventData.getX, jEventData.getY);
    hoverIndex = jListbox.locationToIndex(mousePos) + 1;
    set(hListbox, 'Tooltip',  msg{hoverIndex,3}  );
end
return

function radioshowHTMLprogress(h,e)
settings=antsettings;


if isfield(settings,'show_HTMLprogressReport')
    settingsfile=which('antsettings.m');
    pp=preadfile(settingsfile); pp=pp.all;
    ix=regexpi2(pp,'settings.show_HTMLprogressReport');
    if isempty(ix); return; end
    pl=pp{ix};
    ixtag=[min(strfind(pl,'=')) min(strfind(pl,';'))];
    if get(h,'value')==0
        %'v0'
        pl2=   [ pl(1:ixtag(1)-1)   regexprep(pl(ixtag(1):ixtag(2)),'1','0')    pl(ixtag(2)+1:end) ];
    else
        %'v1'
        pl2=   [ pl(1:ixtag(1)-1)   regexprep(pl(ixtag(1):ixtag(2)),'0','1')    pl(ixtag(2)+1:end) ];
    end
    pp(ix)={pl2};
    pwrite2file(settingsfile,pp) ;
    %disp('write');
end


function cmenuCases

lb3=findobj(findobj(0,'tag','ant'),'tag','lb3');

ContextMenu=uicontextmenu;
uimenu('Parent',ContextMenu, 'Label','open folder in explorer',   'callback', {@cmenuCasesCB,'opdendir' } ,'ForegroundColor',[0 .5 0]);

uimenu('Parent',ContextMenu, 'Label','rename folder',   'callback', {@cmenuCasesCB,'renamedir' } ,'ForegroundColor',[ 1 0 1], 'Separator','on');

uimenu('Parent',ContextMenu, 'Label','select all folders',          'callback', {@cmenuCasesCB,'selectallfolders' } ,     'ForegroundColor',[ 0.9294    0.6941    0.1255], 'Separator','on');
uimenu('Parent',ContextMenu, 'Label','select folders via clipboard','callback', {@cmenuCasesCB,'selectfoldersclipboard' } ,'ForegroundColor',[ 0.9294    0.6941    0.1255]);

uimenu('Parent',ContextMenu, 'Label','check registration quality of w_t2.nii (middle slice) (SPM)', 'callback', {@cmenuCasesCB,'warpquality_spm' } ,'ForegroundColor',[0 0 1],'Separator','on');
uimenu('Parent',ContextMenu, 'Label','check registration quality of x_t2.nii (middle slice) (ELASTIX)', 'callback', {@cmenuCasesCB,'warpquality_elastix' } ,'ForegroundColor',[0 0 1]);
uimenu('Parent',ContextMenu, 'Label','check coreg- panel(ELASTIX)', 'callback', {@cmenuCasesCB,'check_coreg' } ,'ForegroundColor',[0 0 1]);

uimenu('Parent',ContextMenu, 'Label','check registration via GUI', 'callback', {@cmenuCasesCB,'checkRegist' } ,'ForegroundColor',[0 0 1]);


uimenu('Parent',ContextMenu, 'Label','  SPMDISP: overlay t2.nii & ALLen(GM)', 'callback', {@cmenuCasesCB,'Rdisplaykey3inv' });

% uimenu('Parent',ContextMenu, 'Label','    overlay [w_t2.nii] & [GWC.nii] ', 'callback', {@cmenuCasesCB,'ovl' }, 'Separator','on');
% uimenu('Parent',ContextMenu, 'Label','    overlay [w_t2.nii] & [ANO.nii] ', 'callback', {@cmenuCasesCB,'ovl' });
% uimenu('Parent',ContextMenu, 'Label','    overlay [w_t2.nii] & [_b1grey.nii] ', 'callback', {@cmenuCasesCB,'ovl' });

% uimenu('Parent',ContextMenu, 'Label','    overlay [x_t2.nii] & [GWC.nii] ', 'callback', {@cmenuCasesCB,'ovl' }, 'Separator','on');
% uimenu('Parent',ContextMenu, 'Label','    overlay [x_t2.nii] & [ANO.nii] ', 'callback', {@cmenuCasesCB,'ovl' });
% uimenu('Parent',ContextMenu, 'Label','    overlay [x_t2.nii] & [_b1grey.nii] ', 'callback', {@cmenuCasesCB,'ovl' });

uimenu('Parent',ContextMenu, 'Label','examine orientation',                   'callback', {@cmenuCasesCB,'examineOrientation' },       'ForegroundColor',[  1   0.3882    0.3882],    'Separator','on');
uimenu('Parent',ContextMenu, 'Label','get orientation via 3point selection',  'callback', {@cmenuCasesCB,'getOrientationVia3points' }, 'ForegroundColor',[ 1    0.3882    0.3882],    'Separator','off');

uimenu('Parent',ContextMenu, 'Label','   *clipboard selected fullpaths-folders',                 'callback', {@cmenuCasesCB,'copyfullpath' },      'Separator','on');
uimenu('Parent',ContextMenu, 'Label','   *clipboard selected folders ',                          'callback', {@cmenuCasesCB,'copypath' },          'Separator','off');
uimenu('Parent',ContextMenu, 'Label','   clipboard selected fullpaths-folders as MATLAB-CELL',   'callback', {@cmenuCasesCB,'copyfullpathascell' },'Separator','off');
uimenu('Parent',ContextMenu, 'Label','   clipboard selected folders as MATLAB-CELL',             'callback', {@cmenuCasesCB,'copypathascell' },    'Separator','off');




% uimenu('Parent',ContextMenu, 'Label','exclude case (include prev. excluded case)', 'callback', {@cmenuCasesCB,'dropout' } ,'ForegroundColor',[1 0 0], 'Separator','on');
uimenu('Parent',ContextMenu, 'Label','general info',  'callback', {@cmenuCasesCB,'generalinfo' } ,'ForegroundColor',[0 .5 0], 'Separator','on');
uimenu('Parent',ContextMenu, 'Label','export folder', 'callback', {@cmenuCasesCB,'copyfolders' } ,'ForegroundColor',[1 .0 0], 'Separator','on');
uimenu('Parent',ContextMenu, 'Label','watch files', 'callback', {@cmenuCasesCB,'watchfile' } ,'ForegroundColor',[0 .0 0], 'Separator','on');


% Menu1=uimenu('Parent',ContextMenu,...
%     'Label','Menu Option 1');
% Menu2=uimenu('Parent',ContextMenu,...
%     'Label','Menu Option 2');
% Menu3=uimenu('Parent',ContextMenu,...
%     'Label','Menu Option 3');
set(lb3,'UIContextMenu',ContextMenu);

%% other screenSize
% if ispc==1
screen=get(0,'ScreenSize');
if screen(3)<1500
    if ispc
        set(findobj(gcf,'tag','lb3'),'fontsize',8);
        set(findobj(gcf,'tag','lb1'),'fontsize',9);
        set(findobj(gcf,'tag','lb2'),'fontsize',9);
        set(findobj(gcf,'style','pushbutton'),'fontsize',5);
        
    elseif isunix
        set(findobj(gcf,'tag','lb3'),'fontsize',11);
        set(findobj(gcf,'tag','lb1'),'fontsize',11);
        set(findobj(gcf,'tag','lb2'),'fontsize',11);
        set(findobj(gcf,'style','pushbutton'),'fontsize',7);
        set(findobj(gcf,'style','text'),'fontsize',9);
        set(findobj(gcf,'style','radio'),'fontsize',9);
    end
end
% end













%% callback
function cmenuCasesCB(h, e, cmenutask)
global an
lb3=findobj(findobj(0,'tag','ant'),'tag','lb3');

switch cmenutask
    case 'opdendir'
        va=get(lb3,'value');
        for i=1:length(va)
            dirx= an.mdirs{va(i)};
            explorer(dirx);
            %system(['explorer ' dirx]);
        end
    case 'renamedir'
        va=get(lb3,'value')
        dirs=xrenamedir('dirs',an.mdirs(va));
        an.mdirs=dirs(:,2) ;
        antcb('update');
    case 'selectallfolders'
        set(lb3,'value',1:size(get(lb3,'string'),1));
        lb3_callback(findobj(gcf,'tag','lb3'),[]);
    case 'selectfoldersclipboard'
        xseldirs;
    case 'warpquality_spm'
        slice=100;
        warp_summary(struct('file','w_t2.nii','slice',slice)); set(gcf,'name', [ '..w_t2.nii(SPM), slice' num2str(slice)  ]);
    case 'warpquality_elastix'
        slice=100;
        warp_summary(struct('file','x_t2.nii','slice',slice));  set(gcf,'name', [ '..x_t2.nii(ELATIX), slice' num2str(slice)  ]);
    case 'check_coreg'
        statusMsg(1,' check_coreg ..get data ');
        check_coreg;
        statusMsg(0);
    case 'checkRegist'
        statusMsg(1,' check Registration via GUI ');
        checkRegist
        statusMsg(0);
        
        
    case 'Rdisplaykey3inv'
        va=get(lb3,'value');
        for i=1:length(va)
            dirx= an.mdirs{va(i)};
            t2 =fullfile(dirx,'t2.nii')
            gm=fullfile(dirx,'_b1grey.nii')
            displaykey3inv( gm ,t2,1,struct('parafile','','screencapture',''  ) );
            hspm=findobj(gcf,'tag','Graphics');
            try; set(findobj(hspm,'string','END'),'visible','off'); end
            try; set(findobj(hspm,'string','set Zeros'),'visible','off'); end
            try; set(findobj(hspm,'string','AUTOREG'),'visible','off'); end
            try; set(findobj(hspm,'tag','popup1'),'visible','off'); end
            try; set(findobj(hspm,'tag','popup2'),'visible','off'); end
        end
    case 'ovl'
        label=get(h,'Label');
        x = regexp(label,'\[(.*?)\]','tokens');
        va=get(lb3,'value');
        patemplate=fullfile(fileparts(fileparts(an.mdirs{1})),'templates');
        x1=x{1}{1};
        x2=x{2}{1};
        for i=1:length(va)
            dirx= an.mdirs{va(i)};
            f1=fullfile(dirx, x1)  ;
            f2=fullfile(patemplate,x2) ;       if exist(f2)~=2; continue; end
            
            if exist(f1)~=2; disp(['file'  ]) ;
                cprintf([1 .6 .3],(['file not found : '     strrep(f1,'\','\\') '   >> process data first' '\n']  ));
                continue;
            end
            
            
            if  strfind(x2,'GWC')
                ovlcontour({f1;f2},2,['5 50'],[.08 0 0.05 0.05],[1 1 0],{[] .3 [ ] }, dirx);
            elseif  strfind(x2,'ANO')
                ovlcontour({f1;f2},2,['5 50'],[.08 0 0.05 0.05],[1 1 0],{jet .1  [0 1000]}, dirx);
            elseif  strfind(x2,'_b1grey')
                ovlcontour({f1;f2},2,['5 50'],[.08 0 0.05 0.05],[1 1 0],{jet .1  }, dirx);
            else
                ovlcontour({f1;f2},2,['5 50'],[.08 0 0.05 0.05],[1 1 0],{jet .5  [ ]}, dirx);
            end
        end
        
        
    case 'examineOrientation'
        px=antcb('getsubjects');
        refimg=fullfile(fileparts(fileparts(px{1})),'templates','AVGT.nii');
        if exist(refimg)~=2
            warning('refImage in templates-folder not found..please select an appropriate "AVGT.nii" as reference image');
            [t,sts] = spm_select(1,'image','select reference image (example: "AVGT.nii")',[],pwd,'.*.nii',1);
            refimg=strtok(t,',');
        end
        for i=1:size(px,1)
            img=fullfile(px{i},'t2.nii');
            if exist(img)~=2
                warning('"t2.nii" image not found not found..please select another image');
                [t,sts] = spm_select(1,'image','select image (example "t2.nii") ',[],px{i},'.*.nii',1);
                img=strtok(t,',');
            end 
            %[~,name]=fileparts(px{i});
            %[id rotstring]=getorientation('ref',refimg,'img',img,'info', name);
            [~,name   ]=fileparts(px{i});
            [~,nameref]=fileparts(refimg);
            infox=['select orientation with best match between [' name '] and [' nameref ']'];
            % [id rotstring]=getorientation('ref',refimg,'img',img,'info', name);
            [id rotstring]=getorientation('ref',refimg,'img',img,'info', infox,'mode',1,'wait',1,'disp',1);
            disp([ name ' rotTable-ID is [' num2str(id)  '] ..which is  "' rotstring  '"']);
        end
    case 'getOrientationVia3points'
        px=antcb('getsubjects');
        refimg=fullfile(fileparts(fileparts(px{1})),'templates','AVGT.nii');
        if exist(refimg)~=2
            warning('refImage in templates-folder not found..please select an appropriate "AVGT.nii" as reference image');
            [t,sts] = spm_select(1,'image','select reference image (example: "AVGT.nii")',[],pwd,'.*.nii',1);
            refimg=strtok(t,',');
        end
        for i=1:size(px,1)
            img=fullfile(px{i},'t2.nii');
            if exist(img)~=2
                warning('"t2.nii" image not found not found..please select another image');
                [t,sts] = spm_select(1,'image','select image (example "t2.nii") ',[],px{i},'.*.nii',1);
                img=strtok(t,',');
            end
            %[~,name]=fileparts(px{i});
            %[id rotstring]=getorientation('ref',refimg,'img',img,'info', name);
            [~,name   ]=fileparts(px{i});
            [~,nameref]=fileparts(refimg);
            infox=['select orientation with best match between [' name '] and [' nameref ']'];
            
            % REVERSE IMAGE ORDER (t2.nii is reference !!!!)
            p.f1=img     ; % fullfile(ps,'t2.nii');            %REFIMAGE -- which is [t2.nii] here
            p.f2=refimg  ; % fullfile(ps,'AVGT.nii'); %SOURCE  %SOURCEIMGE --which is[AVGT.nii] here
            p.f3=   ''   ; % {fullfile(ps,'applyimg1_firstEPI2.nii'); fullfile(ps,'applyimg1_firstEPI2.nii')}; %APPLYIMG
            p.info=[num2str(i) '/'  num2str(size(px,1))];
            p.wait=1;
            manuorient3points(p);
            
            
            
        end
        
        
        
        
    case 'copyfullpath'
        pathx= antcb('getsubjects') ;
        mat2clip(pathx);
    case 'copypath'
        pathx= antcb('getsubjects') ;
        global an;
        pathx=strrep(strrep(pathx,[an.datpath filesep],''),filesep,'') ;
        mat2clip(pathx);
    case 'copyfullpathascell'
        global an;
        fppathx= antcb('getsubjects') ;
        ro =['{' ; cellfun(@(a) {[ '    ''' a '''']},fppathx); '};'];
        mat2clip(ro);
    case 'copypathascell'
        global an;
        fppathx= antcb('getsubjects') ;
        pathx  =strrep(strrep(fppathx,[an.datpath filesep],''),filesep,'') ;
        ro   =['{' ;stradd(stradd(pathx,'    ''',1),'''',2); '};'];
        mat2clip(ro);
    case 'generalinfo'
        global an
        fis= antcb('getallsubjects');
        ifo={};
        ifo{end+1,1}=['[GENERAL INFO]__________________________________________________________________'];
        ifo{end+1,1}=['N-mouse-dirs: ' num2str(size(fis,1))];
        ifo{end+1,1}=(['print all mouse folders '   ' <a href="matlab: disp(' 'char(antcb(' '''getallsubjects''' '))' ')">' an.datpath '</a>' ';' ['[' ' N=' num2str(size(fis,1))  ']' ]  ]);% show h<perlink
        ifo{end+1,1}=(['  '   ' <a href="matlab: montage_t2image">' 'show "t2.nii" of selected paths (galery/montage) (centerpoint) ' '</a>' ';'  ]);% show h<perlink
        disp(char(ifo));
        
    case('copyfolders')
        global an
        pa=antcb('getsubjects');
        files=xselectfiles(pa);
        if isempty(files); return; end%ABORT
        [pax ]=uigetdir(fileparts(an.datpath),'select/create TARGET-DIRECTORY for mouse-folders export');
        if sum(pax)==0 ; return ; end %ABORT
        
        for i=1:size(pa,1)
            ss =pa{i};
            [dumx mfold]=fileparts(ss);
            des=fullfile(pax,mfold);
            
            for j=1:size(files,1)
                ss2 =fullfile(ss,files{j}) ;%file
                des2=fullfile(des,files{j});
                if exist(ss2)==2
                    mkdir(des);
                    copyfile(ss2,des2,'f');
                end
                
            end
            if exist(des)==7
                disp(['copy files from folder ['  mfold '] to: ' des]);
            end
        end
    case('watchfile')
        antcb('watchfile');
        
        
        
    case 'dropout'
        warning off;
        global an;
        lb=findobj(gcf,'tag','lb3');
        li=get(lb,'string');
        va=get(lb,'value');
        tagpath=an.mdirs(va);
        
        for i=1:size(tagpath,1)
            [pax fix ex]=fileparts(tagpath{i});
            
            statusfile=fullfile(tagpath{i},'status.mat');
            if exist(statusfile)==2
                load(statusfile);
            else
                status.isdropout=0;
            end
            
            %% tag this
            if status.isdropout==0
                status.isdropout=1;
                save(statusfile,'status');
                
                %% untag this
            else
                try; delete(statusfile);end
                %alternative
                %                 status.isdropout=1;
                %                 save(statusfile,'status')
            end
        end
        
        antcb('update'); %update subjects
        
end


%% menubar
function setMenubar
f=findobj(gcf,'tag','ant');
%% FIRST ROW
mh = uimenu(f,'Label','Main');
mh2 = uimenu(mh,'Label',' New Project',                          'Callback',{@menubarCB, 'xnewproject' },      'userdata',sprintf('create a new project for a new study ')       );
mh2 = uimenu(mh,'Label',' Create Study Templates',               'Callback',{@menubarCB, 'copytemplates' },    'userdata',sprintf('...calling function.. ')  );

mh2 = uimenu(mh,'Label',' Import Bruker data',                   'Callback',{@menubarCB, 'brukerImport'},      'userdata',sprintf('from various MR-sequences (2dseq/reco)')       ,'Separator','on');
mh2 = uimenu(mh,'Label',' Import DATA',                          'Callback',{@menubarCB, 'dataimport'  },      'userdata',sprintf('import NIFTI-files from other external folder(s) \n other applications')       );
mh2 = uimenu(mh,'Label',' Import NIFTI via header-replacement',  'Callback',{@menubarCB, 'dataimport2' },      'userdata',sprintf('replace header of NIFTI-files using the header of a reference-file')       );
mh2 = uimenu(mh,'Label',' Import ANALYZE (*.obj) files (masks)', 'Callback',{@menubarCB, 'importAnalyzmask' }, 'userdata',sprintf(' ')       );
mh2 = uimenu(mh,'Label',' Import DATA via "Dir-to-Dir" correspondence',   'Callback',{@menubarCB, 'dataimportdir2dir'},                    'userdata',sprintf('import any data from external "name"-matching directories to internal mouse directories \n prerequisite:  matching directory-name-tag')       );
mh2 = uimenu(mh,'Label',' Distribute files (files from outside to selected mouse-folders)',   'Callback',{@menubarCB, 'distributefilesx'} , 'userdata',sprintf('import Nifit-files external source \n prerequisite:  matching matching file-name-tag or directory-name-tag ')       );



mh2 = uimenu(mh,'Label',' convert dicom to nifti',         'Callback',{@menubarCB, 'xconvertdicom2nifti' },    'userdata',sprintf(' convert dicoms to nifti using MRICRON-tool (windows only) '),'Separator','on');
mh2 = uimenu(mh,'Label',' merge directories',              'Callback',{@menubarCB, 'xmergedirectories' },      'userdata',sprintf(' merge the  contents of pairwise assigned directories  '    ),'Separator','off');


mh2 = uimenu(mh,'Label',' export files',                  'Callback',{@menubarCB, 'export'},'Separator','on',  'userdata',sprintf('EXPORT selected files from selected folders ')       );
mh2 = uimenu(mh,'Label',' quit',                          'Callback',{@menubarCB, 'quit'},'Separator','on');

set(get(mh,'children'),'tag','mb');
hmb=findobj(gcf,'tag','mb');
cb=get(hmb,'callback');
for i=1:length(cb)
    set(hmb(1),'buttondownfcn',cb{i});
end

%% 2nd ROW
mh = uimenu(f,'Label','Tools');
mh2 = uimenu(mh,'Label',' coregister images',                                              'Callback',{@menubarCB, 'coregister'},         'userdata', '');
mh2 = uimenu(mh,'Label',' register exvio to invivo',                                       'Callback',{@menubarCB, 'registerexvivo'},      'userdata', '');
mh2 = uimenu(mh,'Label',' register CT image',                                              'Callback',{@menubarCB, 'registerCT'},          'userdata', '');
mh2 = uimenu(mh,'Label',' register images manually',                                       'Callback',{@menubarCB, 'registermanually'},    'userdata', '');


% mh2 = uimenu(mh,'Label','<html><font color="black"> coregister slices 2D <font color="red"><i> *NEW*',                                           'Callback',{@menubarCB, 'coregister2D'});
mh2 = uimenu(mh,'Label',' manipulate files (rename/copy/delete/extract/expand)',       'Callback',{@menubarCB, 'renamefile_simple'},'userdata','with this function, it is easy to rename/copy/delete/extract or expand NIFTI-FILES(VOLUMES)','Separator','on');
mh2 = uimenu(mh,'Label',' delete files',                                                   'Callback',{@menubarCB, 'deletefiles'},'Separator','off');
% mh2 = uimenu(mh,'Label',' copy and rename files',                                          'Callback',{@menubarCB, 'renamefile'});
% mh2 = uimenu(mh,'Label',' copy/rename/expand files',                                       'Callback',{@menubarCB, 'renamefile2'});
mh2 = uimenu(mh,'Label',' manipulate header',                                              'Callback',{@menubarCB, 'manipulateheader'},'Separator','on'  );
mh2 = uimenu(mh,'Label',' replace header (older version)',                                 'Callback',{@menubarCB, 'replaceheader'},'Separator','off');




mh2 = uimenu(mh,'Label',' image calculator',                                               'Callback',{@menubarCB, 'calc0'},'Separator','on');
mh2 = uimenu(mh,'Label',' Mask-Generator (GUI)',                                           'Callback',{@menubarCB, 'maskgenerate'},'Separator','on');
mh2 = uimenu(mh,'Label',' make mask from Excelfile',                                       'Callback',{@menubarCB, 'maskgenerateFromExcelfile'},'Separator','off');

mh2 = uimenu(mh,'Label',' draw mask',                                            'Callback',{@menubarCB, 'drawmask'},'Separator','on');

mh2 = uimenu(mh,'Label',' [1] segment tube',                                         'Callback',{@menubarCB, 'segmenttube'},'Separator','on');
mh2 = uimenu(mh,'Label',' [2] split tube data',                                   'Callback',{@menubarCB, 'splittubedata'},'Separator','off');



mh = uimenu(f,'Label','2D');
mh2 = uimenu(mh,'Label','<html><font color="black"> extract slice        <font color="red"><i> *',                                           'Callback',{@menubarCB, 'extractslice'});
mh2 = uimenu(mh,'Label','<html><font color="black"> coregister slices 2D <font color="red"><i> *',                                           'Callback',{@menubarCB, 'coregister2D'});
mh2 = uimenu(mh,'Label','<html><font color="black"> apply 2d-registration to other images <font color="red"><i> *',                                           'Callback',{@menubarCB, 'coregister2Dapply'});




mh = uimenu(f,'Label','Graphics');
mh2 = uimenu(mh,'Label',' show cases-file-matrix',                                         'Callback',{@menubarCB, 'casefilematrix'},'Separator','on');
mh2 = uimenu(mh,'Label',' GUI overlay image',                                              'Callback',{@menubarCB, 'overlayimageGui'});
mh2 = uimenu(mh,'Label',' GUI overlay image2',                                             'Callback',{@menubarCB, 'overlayimageGui2'});
mh2 = uimenu(mh,'Label',' fastviewer',                                                     'Callback',{@menubarCB, 'fastviewer'});
mh2 = uimenu(mh,'Label',' 3D-volume',                                                      'Callback',{@menubarCB, 'x3dvolume'});



mh = uimenu(f,'Label','Study');
mh2 = uimenu(mh,'Label',' open studie''s configfile folder',                              'Callback',{@menubarCB, 'folderConfigfile'},'Separator','on');
mh2 = uimenu(mh,'Label',' open studie''s template folder',                                'Callback',{@menubarCB, 'folderTemplate'});
mh2 = uimenu(mh,'Label',' preselect mouse-folder',                                        'Callback',{@menubarCB, 'preselectfolder'},'Separator','on', 'userdata','->preselect mouse/mousefolder by id/name/containing nifti-files (or file combinationa) or textfile');





%% 3nd row
mh = uimenu(f,'Label','Statistic');
mh2 = uimenu(mh,'Label',' volume-based two-sample ttest (independent groups)',                      'Callback',{@menubarCB, 'stat_2sampleTtest'});
mh2 = uimenu(mh,'Label',' label-based two-sample ttest (independent groups)',                      'Callback',{@menubarCB, 'stat_anatomlabels'});
mh2 = uimenu(mh,'Label',' label-based statistic',                                                  'Callback',{@menubarCB, 'xstatlabels0'});

mh2 = uimenu(mh,'Label',' SPM-statistic',                                                          'Callback',{@menubarCB, 'spm_statistic'});
mh2 = uimenu(mh,'Label',' DTI-statistic',                                                          'Callback',{@menubarCB, 'dti_statistic'});


%% 4th row
mh = uimenu(f,'Label','Snips');
% mh2 = uimenu(mh,'Label',' flatten bruker Data path for dataImport',                      'Callback',{@menubarCB, 'flattenBrukerdatapath'});
% mh2 = uimenu(mh,'Label',' generate Jacobian Determinant',                                'Callback',{@menubarCB, 'generateJacobian'});
mh2 = uimenu(mh,'Label',' get corrected lesion volume',                                  'Callback',{@menubarCB, 'getlesionvolume'});
mh2 = uimenu(mh,'Label',' make IncidenceMaps',                                           'Callback',{@menubarCB, 'makeIncidenceMaps'});

% mh2 = uimenu(mh,'Label',' generate ANO.nii in pseudocolors',    'Callback',{@menubarCB, 'makeANOpseudocolors'});


%% last ROW
mh = uimenu(f,'Label','Extras');
mh2 = uimenu(mh,'Label','notes',                                                        'Callback',{@menubarCB, 'notes'});
mh2 = uimenu(mh,'Label','keyboard shortcuts',                                           'Callback',{@menubarCB, 'keyboard'});

mh2 = uimenu(mh,'Label','documentations (docs)',                                        'Callback',{@menubarCB, 'docs'});

mh2 = uimenu(mh,'Label','display main functions',                                       'Callback',{@menubarCB, 'dispmainfun'});
mh2 = uimenu(mh,'Label','ant-settings',                                                 'Callback',{@menubarCB, 'antsettings'},'separator','on');
mh2 = uimenu(mh,'Label','version',                                                 'Callback',{@menubarCB, 'version'},'separator','on');
mh2 = uimenu(mh,'Label','contact',                                                 'Callback',{@menubarCB, 'contact'});
% mh2 = uimenu(mh,'Label','troubleshoot',                                            'Callback',{@menubarCB, 'troubleshoot'});
 
mh2   = uimenu(mh,'Label','troubleshoot' );
msub1 = uimenu(mh2,'Label','check ELASTIX installation',                          'Callback',{@menubarCB, 'check_ELASTIX_installation'});


mh2 = uimenu(mh,'Label','visit ANTx2 repository (Github)',                                  'Callback',{@menubarCB, 'visitGITHUB'},'separator','on');
mh2 = uimenu(mh,'Label','get templates from googledrive',                                  'Callback',{@menubarCB, 'openGdrive'},'separator','off');

mh2 = uimenu(mh,'Label','check for updates (Github)',                                    'Callback',{@menubarCB, 'checkUpdateGithub'},'separator','on');


%========================================================
%% JAVA MENU
%
drawnow;
pause(.1);
jFrame = get(gcf,'JavaFrame');
try     % R2008a and later
    jMenuBar = jFrame.fHG1Client.getMenuBar;
catch
    jMenuBar = jFrame.fHG2Client.getMenuBar;
end
drawnow


% for menuIdx = 1 : jMenuBar.getComponentCount  %%automatically pull down menu
for menuIdx = jMenuBar.getComponentCount:-1:1  %%automatically pull down menu
    % menuIdx
    jMenu = jMenuBar.getComponent(menuIdx-1);
    %pause(.05);
    hjMenu = handle(jMenu,'CallbackProperties');
    %pause(.05);
    set(hjMenu,'MouseEnteredCallback','doClick(gcbo)');
    drawnow;
    
    %pause(.05);
    jMenu.doClick; % open the File menu
%     pause(.01);
    drawnow;
    
    jMenu.doClick; % close the menu
     %pause(.01);
    drawnow;
    
%     if 0%menuIdx==1
%         drawnow
%         %jMenu.doClick; % open the File menu
%         pause(.05);
%         set(hjMenu,'Visible',0)
%     end
     javax.swing.MenuSelectionManager.defaultManager().clearSelectedPath();
end

%    jMenu.doClick; % close the menu
%     pause(.01);

%close again -->see https://undocumentedmatlab.com/blog/customizing-menu-items-part-2
drawnow;
javax.swing.MenuSelectionManager.defaultManager().clearSelectedPath();



%  pause(.05);
%  figure(gcf)

% drawnow
%  jMenu.hide; drawnow; jMenu.show;  %trick to pull-up the last menu-item
% jMenuBar.hide
% drawnow
%  pause(.55);
%  jMenuBar.show
% %
% return
%  disp(['jMenu.isRolloverEnabled:'  num2str(jMenu.isRolloverEnabled)]);
%  pause(.05);
%   jMenu = jMenuBar.getComponent(3);
%   pause(.05);
%     hjMenu = handle(jMenu,'CallbackProperties');
%     pause(.05);
%     set(hjMenu,'MouseEnteredCallback','doClick(gcbo)');
%     pause(.05);
%     jMenu.doClick; % open the File menu
%     pause(.05);

%     jMenu.doClick; % open the File menu


%% MAKE TOOLTIP
if 1
    for menuIdx = 1:jMenuBar.getComponentCount  %%automatically pull down menu
        jMenu = jMenuBar.getComponent(menuIdx-1);
        for j=1:length(jMenu.getMenuComponents   )
            
            hj = jMenu.getMenuComponent(j-1);
            try
                lab=char(hj.getLabel);
                drawnow
                
                hm= findobj( f, 'label',lab);
                %  hj.setToolTipText([get(mj,'userdata') 13 ' ###']);
                %['<html><pre><font face="courier new">' myDataStr2 '</font>']
                
                
                %msg=[get(hm,'userdata') ];
                %msg= ['<html><pre><font face="courier new">' ...
                %    '<font color="blue"><b>' lab '</b></font>' 10 msg 10 ];
                % 'This is a link to <a href="http://www.google.com">Google</a>.'...
                %   ];
                %hj.setToolTipText(msg);
                
                %make help
                if ~isempty(strfind(class(hj),'MenuItem'))  %no separators in
                    try
                        set(hj,'MouseEnteredCallback',{@showfunctionhelp,hm,hj});
                    catch
                        hj2=handle(hj, 'CallbackProperties');
                        set(hj2,'MouseEnteredCallback',{@showfunctionhelp,hm,hj});
                    end
                end
            end
        end%j
    end
end



% function bla
%
% url = 'UndocumentedMatlab.com';
% labelStr = ['<html>More info: <a href="">' url '</a></html>'];
% jLabel = javaObjectEDT('javax.swing.JLabel', labelStr);
% [hjLabel,hContainer] = javacomponent(jLabel, [10,10,250,20], gcf);
%
% % Modify the mouse cursor when hovering on the label
% hjLabel.setCursor(java.awt.Cursor.getPredefinedCursor(java.awt.Cursor.HAND_CURSOR));
%
% % Set the label's tooltip
% hjLabel.setToolTipText(['Visit the ' url ' website']);
%
% % Set the mouse-click callback
% set(hjLabel, 'MouseClickedCallback', @(h,e)web(['http://' url], '-browser'))



%                     'More info: <a href="matlab: '  'help(''mean.m'')' '">' 'UndocumentedMatlab.com' '</a></html>' ...


% disp([pnum(i,4) '] imported file <a href="matlab: explorer('' ' fileparts(f2) '  '')">' f2 '</a>'  ]);
% disp( [ 'file <a href="matlab:'  'help(''mean.m'')' '">' 'bla' '</a>'  ]    );

%
% imb=findobj(gcf,'tag','mb')
% for i=1:length(imb)
%     imbx=imb(i);
%     drawnow
%     pause(.1)
%     posUP  =get(get(imbx,'parent'),'position');
%     posThis=get(imbx,'position');
%
%     jFileMenu = jMenuBar.getComponent(posUP-1);
%     jSave = jFileMenu.getMenuComponent(posThis-1);
%     jSave.setToolTipText(get(imbx,'userdata'));
%
%
%
%     %jSave = jFileMenu.getMenuComponent(1);
%     %jSave.setToolTipText('modified menu item with tooltip');
%     % strfind(class(jSave),'Separator')
% end
%========================================================
function showfunctionhelp(h,e,hm,hj)


% persistent atimer
% persistent atime
% if isempty(atime)
%     atimer=tic+1000;
% end
% 
% thistime=toc(atimer);
% 
% if thistime<atime+.2
%   disp([ '------'  ]);
%   pause(.2);
% else
%   disp(['++++++'  get(hm,'Label')]);
% end
% 
% 
%     atime=toc(atimer);
%   
% 
% % atime
% return

% 
% persistent atime
% if isempty(atime)
%     atime=tic;
% end
% persistent check % Shared with all calls of pushbutton1_Callback.
% delay = 0.5; % Delay in seconds.
% % Count number of clicks. If there are no recent clicks, execute the single
% % click action. If there is a recent click, ignore new clicks.
% if isempty(check)
%     check = 1;
%     currentlabel=get(hm,'Label');
%     disp('Single click action');
% else
%     check = [];
%     pause(delay)
%    disp( ['moved ' num2str(toc(atime))  ' ' get(hm,'Label') ]);
%    atime=tic;
% end
% return


settings=antsettings;
hradiohelp=findobj(findobj(0,'tag','ant'),'tag','radioshowhelp');
if get(hradiohelp,'value')==0; return; end
% if settings.show_instant_help==0 ; return ; end

try
    lab=char(hj.getLabel);
    msg=[get(hm,'userdata') ];
    msg= [ ' ##m ' lab ' ' 10 msg ];
    msg=strsplit2(msg,char(10))';
    
    
    cb=get(hm,'callback');
    task=cb{2};
    showhelp=1;
    
    hlpfun=menubarCB([],[],task,  showhelp );
catch
    hlpfun='ant';
    msg={''};
end

if isempty(hlpfun);
    return;
else
    help_isfun=0;
    
    if ischar(hlpfun)
        if exist([hlpfun '.m'])==2
            a=help([hlpfun '.m']);
            a=strsplit2(a,char(10))';
            mT=[{[' #yk [' upper(hlpfun) '.m] ']}];%        __________________________________________________________________']}];
            msg2=[msg;mT; a];
            help_isfun=1;
        end
    end
    
    if help_isfun==0
        if ischar(hlpfun)
            a=cellstr(hlpfun);
        else
            a=hlpfun;
        end
        msg2=[msg; a];
    end
    
    %%======================== antiflash
    %     global an;
    %     if isempty(an); an=struct();end
    %     if isfield(an,'lasterror')==0
    %         an.lasterror='';
    %     end
    %
    %     if strcmp(char(an.lasterror),char(msg2))==1 && ~isempty(findobj(0,'Number', 335))
    %          disp('info shown-image open');
    %         return
    %     end
    
    %     an.lasterror=msg2;
    
    %%========================
    
    %     return
    
    %helpfig=findobj(0,'Number', 335); does not work on Mac-ML14
    
    %helpfig=findobj(0,'tag','uhelp');
    helpfig=findobj(0,'tag','uhelp','-and','name','HELP');
    %close help figure
    for i=1:length(helpfig)
        if ~isempty(getappdata(helpfig(i),'helphelp'))
            close(helpfig(i));
        end
    end
    helpfig=findobj(0,'tag','uhelp','-and','name','HELP');
    
    if ~isempty(helpfig)
        figID=1;
    else
        figID=[];
    end
    
    %figID=find(helpfig==335) ;
    if isempty(figID)
        %close(helpfig)
        helpfig=[];
    else
        helpfig=helpfig(figID);
        
    end
    
    
    %———————————————————————————————————————————————
    %%   listing to run callback only once
    %———————————————————————————————————————————————
    persistent UHELP_OpenOnce_Flag0002
    if isempty(UHELP_OpenOnce_Flag0002)
        UHELP_OpenOnce_Flag0002 = 1;
    end
    
%     if UHELP_OpenOnce_Flag0002==0
%         'aa'
%         return
%     end
    
%      UHELP_RunOnce_Flag0002=1; %now running

%re-check
% if isempty(helpfig)
%     
%     helpfig=findobj(0,'tag','uhelp');
%     helpfig(helpfig==335);
%     drawnow
%     pause(.1);
% end

    
    if isempty(helpfig);
        
        if UHELP_OpenOnce_Flag0002==0
            return
        end
        UHELP_OpenOnce_Flag0002=0;
        
        posant=get(findobj(0,'tag','ant'),'position');
        height=.3;
        %uhelp(msg2,0,'position',[posant(1) posant(2)-height   posant(3)  height-.001]);
        %             pause(.1);
        %             drawnow;
        
        uhelp(msg2,0,'position',[posant(1) posant(2)-height   posant(3)  height-.001]);
        ch=get(0,'children');
        helpfig=ch(1);
        set(helpfig,'numbertitle','off','name','HELP');
        global uhelp_properties
        if ~isempty(uhelp_properties)
            try; 
                ch=findobj(0,'tag','uhelp','-and','name','HELP');
                %helpfig=ch(1);
%                 figure(ch(1))
                set(helpfig,'position',uhelp_properties.fgpos); 
            end
        end
        drawnow;
      
        %%reopen pulldown again
        if 1%isempty(helpfig)
            hf=findobj(0,'tag','ant');
            figure(hf);
            
            try
                jFrame = get(hf,'JavaFrame');
                try     % R2008a and later
                    jMenuBar = jFrame.fHG1Client.getMenuBar;
                catch
                    jMenuBar = jFrame.fHG2Client.getMenuBar;
                end
                drawnow
                menupos=get(get(hm,'parent'),'position');
                for menuIdx =[ menupos ];% jMenuBar.getComponentCount:-1:4;%:-1:1  %%automatically pull down menu
                    %                 drawnow
                    jMenu = jMenuBar.getComponent(menuIdx-1);
                    %                 drawnow
                    hjMenu = handle(jMenu,'CallbackProperties');
                    %                 drawnow
                    set(hjMenu,'MouseEnteredCallback','doClick(gcbo)');
                    drawnow
                    jMenu.doClick; % open the File menu
                    drawnow
                    jMenu.doClick; % close the menu
                    %                drawnow
                end
            end%try
        end
          clear UHELP_OpenOnce_Flag0002
    else
        %disp(['roll-' num2str(rand(1)*100)]);
%         return%for NOW
        hlptx=findobj(helpfig,'tag','txt')  ;
        if length(hlptx)>1
            try;
                delete(hlptx(2:end));
                hlptx=findobj(helpfig,'tag','txt')  ;
            end  % more than one listbox found...BUGGY
        end
        msg3=uhelp(msg2,[],'export',1); %to HTML
        set(hlptx,'value',1,'string',msg3,'ListboxTop',1);
        us=get(helpfig,'userdata');
        us.e0=msg2;
        us.e2=msg3;
        set(helpfig,'userdata',us);
        drawnow;
          clear UHELP_RunOnce_Flag0002;
    end
    %              figure(335);
    %              figure(findobj(0,'tag','ant'));
    
end
%========================================================
function hlpfun=menubarCB(h,e,task,showhelpOnly)

hlpfun=[];
if exist('showhelpOnly')==0
    showhelpOnly=0;
end


% showhelp
% return

% h
% e
% [r p]=mousebutton
% get(gcf,'SelectionType')
%
% get(gcf,'CurrentCharacter')
% set(gcf,'CurrentCharacter','_');
%
% return
%________________________________________________
if strcmp(task,'brukerImport')
    
    if showhelpOnly==1;   %% HELP-PARSER: we need the TARGET-FUNCTION here
        hlpfun='xbruker2nifti';
        return ;
    end
    
    %r=ante;     r.brukerimport();   % !! OLD
    statusMsg(1,' brukerImport');
    global an;
    xbruker2nifti({'guidir' [fileparts(an.datpath) filesep]} ,0);
    statusMsg(0);
    %________________________________________________
elseif strcmp(task,'coregister')
    if showhelpOnly==1;   %% HELP-PARSER: we need the TARGET-FUNCTION here
        hlpfun='xcoreg';
        return ;
    end
    
    statusMsg(1,' coregistering images');
    xcoreg(1);
    statusMsg(0);
    
    %________________________________________________
elseif strcmp(task,'registerexvivo')
    if showhelpOnly==1;   %% HELP-PARSER: we need the TARGET-FUNCTION here
        hlpfun='xregisterexvivo';
        return ;
    end
    
    statusMsg(1,' register exvivo to invivo images');
    xregisterexvivo(1);
    statusMsg(0);
    
    %________________________________________________
elseif strcmp(task,'registerCT')
    if showhelpOnly==1;   %% HELP-PARSER: we need the TARGET-FUNCTION here
        hlpfun='xregisterCT';
        return ;
    end
    
    statusMsg(1,' register CT image');
    xregisterCT(1);
    statusMsg(0);
    
    %________________________________________________
elseif strcmp(task,'registermanually')
    if showhelpOnly==1;   %% HELP-PARSER: we need the TARGET-FUNCTION here
        hlpfun='xcoregmanu';
        return ;
    end
    
    statusMsg(1,' register images manually');
    xcoregmanu(1);
    statusMsg(0);
        
    %________________________________________________
elseif strcmp(task,'coregister2D')
    if showhelpOnly==1;   %% HELP-PARSER: we need the TARGET-FUNCTION here
        hlpfun='xregister2d';
        return ;
    end
    
    statusMsg(1,' coregistering slices [2d]');
    xregister2d(1);
    statusMsg(0);
    
    %________________________________________________
elseif strcmp(task,'coregister2Dapply')
    if showhelpOnly==1;   %% HELP-PARSER: we need the TARGET-FUNCTION here
        hlpfun='xregister2dapply';
        return ;
    end
    
    statusMsg(1,' apply 2d-registration to other imaged');
    xregister2dapply(1);
    statusMsg(0)
    
    %________________________________________________
elseif strcmp(task,'extractslice')
    if showhelpOnly==1;   %% HELP-PARSER: we need the TARGET-FUNCTION here
        hlpfun='xextractslice';
        return ;
    end
    
    statusMsg(1,' extract slices [2d]');
    xextractslice(1);
    statusMsg(0);
    
    
    
    %________________________________________________
elseif strcmp(task,'xnewproject')
    if showhelpOnly==1;   %% HELP-PARSER: we need the TARGET-FUNCTION here
        hlpfun='xnewproject';
        return ;
    end
    
    xnewproject;
    %________________________________________________
elseif strcmp(task,'copytemplates')
    if showhelpOnly==1;   %% HELP-PARSER: we need the TARGET-FUNCTION here
        hlpfun='xcreatetemplatefiles2';%{'depending'; '111'};
        return ;
    end
     
    statusMsg(1,' copytemplates');
    antcb('copytemplates');
    statusMsg(0);
    
    
    
    %________________________________________________
elseif strcmp(task,'dataimport')
    if showhelpOnly==1;   %% HELP-PARSER: we need the TARGET-FUNCTION here
        hlpfun='ximport';
        return ;
    end
    
    ximport(1);
    %________________________________________________
elseif strcmp(task,'dataimport2')
    if showhelpOnly==1;   %% HELP-PARSER: we need the TARGET-FUNCTION here
        hlpfun='ximportnii_headerrplace';
        return ;
    end
    
    ximportnii_headerrplace(1);
    %________________________________________________
elseif strcmp(task,'importAnalyzmask')
    if showhelpOnly==1;   %% HELP-PARSER: we need the TARGET-FUNCTION here
        hlpfun='ximportAnalyzemask';
        return ;
    end
    
    ximportAnalyzemask(1);
    %________________________________________________
elseif strcmp(task,'dataimportdir2dir')
    if showhelpOnly==1;   %% HELP-PARSER: we need the TARGET-FUNCTION here
        hlpfun='ximportdir2dir';
        return ;
    end
    
    statusMsg(1,' dir-to-dir import');
    ximportdir2dir(1);
    statusMsg(0);
    %________________________________________________
elseif strcmp(task,'distributefilesx')
    if showhelpOnly==1;   %% HELP-PARSER: we need the TARGET-FUNCTION here
        hlpfun='xdistributefiles';
        return ;
    end
    
    statusMsg(1,' distribute files');
    xdistributefiles(1);
    statusMsg(0);
    %________________________________________________
elseif strcmp(task,'renamefile_simple')
    if showhelpOnly==1;   %% HELP-PARSER: we need the TARGET-FUNCTION here
        hlpfun='xrename';
        return ;
    end
    
    xrename(1);
    %________________________________________________
elseif strcmp(task,'renamefile')
    if showhelpOnly==1;   %% HELP-PARSER: we need the TARGET-FUNCTION here
        hlpfun='xrenamefile';
        return ;
    end
    
    xrenamefile(1);
    %________________________________________________
elseif strcmp(task,'renamefile2')
    if showhelpOnly==1;   %% HELP-PARSER: we need the TARGET-FUNCTION here
        hlpfun='xcopyrenameexpand';
        return ;
    end
    
    xcopyrenameexpand(1);
    
    %________________________________________________
elseif strcmp(task,'calc0')
    if showhelpOnly==1;   %% HELP-PARSER: we need the TARGET-FUNCTION here
        hlpfun='xcalc';
        return ;
    end
    
    xcalc(1);
    %________________________________________________
elseif strcmp(task,'manipulateheader')
    if showhelpOnly==1;   %% HELP-PARSER: we need the TARGET-FUNCTION here
        %         hlpfun='xheadman';
        hlpfun='manipulate/copy image header/resize image/set origin';
        %helpfun='bla';%sprintf('manipulate imag header/resize image/copy header/set origin');
        return ;
    end
    
    try
        xheadmanfiles('dirs', antcb('getsubjects'));
    catch
        xheadmanfiles();
    end
    
    %________________________________________________
elseif strcmp(task,'replaceheader')
    if showhelpOnly==1;   %% HELP-PARSER: we need the TARGET-FUNCTION here
        hlpfun='xreplaceheader';
        return ;
    end
    
    xreplaceheader(1);
    
    %________________________________________________
elseif strcmp(task,'deletefiles')
    if showhelpOnly==1;   %% HELP-PARSER: we need the TARGET-FUNCTION here
        hlpfun='xdeletefiles';
        return ;
    end
    
    xdeletefiles(1);
    %________________________________________________
    
elseif strcmp(task,'maskgenerate')
    if showhelpOnly==1;   %% HELP-PARSER: we need the TARGET-FUNCTION here
        hlpfun='xmaskgenerator';
        return ;
    end
    
    statusMsg(1,' Mask-Generator');
    xmaskgenerator(1);
    statusMsg(0);

    %________________________________________________
    
elseif strcmp(task,'maskgenerateFromExcelfile')
    if showhelpOnly==1;   %% HELP-PARSER: we need the TARGET-FUNCTION here
        hlpfun='xexcel2atlas';
        return ;
    end
    
    statusMsg(1,' generate mask from excelfile');
    xexcel2atlas(1);
    statusMsg(0);

elseif strcmp(task,'drawmask')
    if showhelpOnly==1;   %% HELP-PARSER: we need the TARGET-FUNCTION here
        hlpfun='xdraw';
        return ;
    end
    
    xdraw;
%     statusMsg(1,' generate mask from excelfile');
%     xexcel2atlas(1);
%     statusMsg(0);    
elseif strcmp(task,'segmenttube')
    if showhelpOnly==1;   %% HELP-PARSER: we need the TARGET-FUNCTION here
        hlpfun='xsegmenttube';
        return ;
    end
    
  
    statusMsg(1,' segment tube');
    xsegmenttube;
    statusMsg(0);     

elseif strcmp(task,'splittubedata')
    if showhelpOnly==1;   %% HELP-PARSER: we need the TARGET-FUNCTION here
        hlpfun='xsplittubedata';
        return ;
    end
    
  
    statusMsg(1,' split tube data');
    xsplittubedata;
    statusMsg(0);  
    
    
    %________________________________________________
    
elseif strcmp(task,'xconvertdicom2nifti')
    if showhelpOnly==1;   %% HELP-PARSER: we need the TARGET-FUNCTION here
        hlpfun='xdicom2nifti';
        return ;
    end
    
    xdicom2nifti(1);
    
    
    %________________________________________________
    
elseif strcmp(task,'xmergedirectories')
    if showhelpOnly==1;   %% HELP-PARSER: we need the TARGET-FUNCTION here
        hlpfun='xmergedirs';
        return ;
    end
    
    xmergedirs(1);
    
    %________________________________________________
    
elseif strcmp(task,'export')
    if showhelpOnly==1;   %% HELP-PARSER: we need the TARGET-FUNCTION here
        hlpfun='xexport';
        return ;
    end
    
    xexport(1);
    %________________________________________________
    
elseif strcmp(task,'quit')
    if showhelpOnly==1;   %% HELP-PARSER: we need the TARGET-FUNCTION here
        hlpfun='..this will quit the Application';
        return ;
    end
    
    hr=findobj(0,'tag','ant');
    set(hr,'closereq','closereq');
    close(hr);
    cf;
    %________________________________________________
elseif strcmp(task,'folderConfigfile')
    if showhelpOnly==1;   %% HELP-PARSER: we need the TARGET-FUNCTION here
        hlpfun={'this function opens the Studie''s MAIN-Folder  '};
        hlpfun{end+1,1}=['mouse-data stored in [dat]-subfolder'];
        hlpfun{end+1,1}=['templates stored in [templates]-subfolder'];
        return ;
    end
    
    global an; if isempty(an); disp('no configfile loaded');return; end
    
    disp(['Studie''s config-Folder: '  fileparts(an.datpath) ]);
    %system(['explorer ' fileparts(an.datpath)  ]);
    explorer(fileparts(an.datpath) );
    
    %________________________________________________
elseif strcmp(task,'folderTemplate')
    if showhelpOnly==1;   %% HELP-PARSER: we need the TARGET-FUNCTION here
        hlpfun={'this function opens the Studie''s TEMPLATE-Folder  '};
        hlpfun{end+1,1}=['..containing the templates (Gm, WM,CSV, ALLEN-template, ALLEN-label-volume)'];
        hlpfun{end+1,1}=['..this folder with template-files is generated in the "warp"-routine of the 1st mouse '];
        return ;
    end
    
    global an; if isempty(an); disp('first load a configfile ');return; end
    try
        disp(['Studie''s teplate Folder: '  fullfile(fileparts(an.datpath),'templates')  ]);
        %system(['explorer ' fullfile(fileparts(an.datpath),'templates')  ]);
        explorer([fullfile(fileparts(an.datpath),'templates') ]);
    catch
        disp(['could not find folder: ' fullfile(fileparts(an.datpath),'templates') ]);
        disp('load configfile and process a mouse first (the template folder is then generated )');
    end
    %________________________________________________
elseif strcmp(task,'preselectfolder')
    if showhelpOnly==1;   %% HELP-PARSER: we need the TARGET-FUNCTION here
        hlpfun='xselect';
        return ;
    end
    
    statusMsg(1,' pre-select mouse-folder');
    xselect(1);
    statusMsg(0);
    %________________________________________________
elseif strcmp(task,'casefilematrix')
    if showhelpOnly==1;   %% HELP-PARSER: we need the TARGET-FUNCTION here
        hlpfun={' #by this function diplays a matrix of all containing Niftis "against" '};
        hlpfun{end+1,1}=['      pre-selected mousefolders  '];
        hlpfun{end+1,1}=['..from here you can:'];
        hlpfun{end+1,1}=['  - see the progress of the process (which files do not exist in which mouse)'];
        hlpfun{end+1,1}=['  - plot & overlay images'];
        hlpfun{end+1,1}=['  #b [SINGLE LEFT CLICK] #K on cell(file) displays the file '];
        hlpfun{end+1,1}=['      with without background-image usinga  #r a COSTUM OVERLAY '];
        hlpfun{end+1,1}=['  #b [SINGLE RIGHT CLICK] #K on cell(file) displays file the with '];
        hlpfun{end+1,1}=['      without background-image using #r MRICRON '];
        hlpfun{end+1,1}=['  #b [DOUBLE LEFT CLICK] #K on cell(file)opens the mouse-folder and  '];
        hlpfun{end+1,1}=['      selects the file in  #WINDOWS EXPLORER  '];
        hlpfun{end+1,1}=['  ... also: displays headerInformation when hovering over a cell(file) '];
        
        
        return ;
    end
    
    statusMsg(1,' generate case-by-file matrix');
    r=ante;
    r.filematrix();
    statusMsg(0);
    %________________________________________________
elseif strcmp(task,'overlayimageGui')
    if showhelpOnly==1;   %% HELP-PARSER: we need the TARGET-FUNCTION here
        hlpfun='gui_overlay';
        return ;
    end
    gui_overlay;
    %________________________________________________
elseif strcmp(task,'overlayimageGui2')
    if showhelpOnly==1;   %% HELP-PARSER: we need the TARGET-FUNCTION here
        hlpfun='xoverlay';
        return ;
    end
    
    xoverlay;
    %________________________________________________
elseif strcmp(task,'fastviewer')
    if showhelpOnly==1;   %% HELP-PARSER: we need the TARGET-FUNCTION here
        hlpfun='xfastview';
        return ;
    end
    
    xfastview;
    %________________________________________________
elseif strcmp(task,'x3dvolume')
    if showhelpOnly==1;   %% HELP-PARSER: we need the TARGET-FUNCTION here
        hlpfun='xvol3d';
        return ;
    end
    
    xvol3d();    
    
    %________________________________________________
    
elseif strcmp(task,'makeANOpseudocolors')
    if showhelpOnly==1;   %% HELP-PARSER: we need the TARGET-FUNCTION here
        hlpfun={'-for older versions only (in newer versions this step is done automatically )'};
        hlpfun{end+1,1}=['create Anotation-file in pseudocolors for overlay only'];
        hlpfun{end+1,1}=['this file [ANOpcol.nii] is stored in the templates-folder'];
        return ;
    end
    
    global an
    anofile            =fullfile(fileparts(an.datpath),'templates','ANO.nii');
    pseudoanofile=fullfile(fileparts(an.datpath),'templates','ANOpcol.nii');
    if exist(anofile)==2
        statusMsg(1,'generate ANO.nii in pseudocolors ["..templates/ANOpcol.nii" ]');
        [ha a]=rgetnii(anofile);
        % pseudocolor conversion
        reg1=single(a);
        uni=unique(reg1(:));
        uni(find(uni==0))=[];
        reg2=reg1.*0;
        for l=1:length(uni)
            reg2=reg2+(reg1==uni(l)).*l;
        end
        rsavenii(pseudoanofile,ha,reg2,[4 0]);
        statusMsg(0);
    else
        disp('there is no ANO.nii file in the "templates folder" ');
    end
    
    
    %% STATISTIC
elseif strcmp(task,'stat_2sampleTtest')
    if showhelpOnly==1;   %% HELP-PARSER: we need the TARGET-FUNCTION here
        hlpfun='xstat_2sampleTtest';
        return ;
    end
    
    xstat_2sampleTtest(1);
    
elseif strcmp(task,'stat_anatomlabels')
    if showhelpOnly==1;   %% HELP-PARSER: we need the TARGET-FUNCTION here
        hlpfun='xstat_anatomlabels';
        return ;
    end
    
    xstat_anatomlabels(1);
    
elseif strcmp(task,'xstatlabels0')
    if showhelpOnly==1;   %% HELP-PARSER: we need the TARGET-FUNCTION here
        hlpfun='xstatlabels';
        return ;
    end
    
    xstatlabels;
    %________________________________________________
    
elseif strcmp(task,'spm_statistic')
    if showhelpOnly==1;   %% HELP-PARSER: we need the TARGET-FUNCTION here
        hlpfun='xstat';
        return ;
    end
    
    xstat(1);
    
elseif strcmp(task,'dti_statistic')
    if showhelpOnly==1;   %% HELP-PARSER: we need the TARGET-FUNCTION here
        hlpfun='dtistat';
        return ;
    end
    
    dtistat;
    
    
    %________________________________________________
elseif strcmp(task,'flattenBrukerdatapath')
    if showhelpOnly==1;   %% HELP-PARSER: we need the TARGET-FUNCTION here
        hlpfun='xbrukerflattdatastructure';
        return ;
    end
    
    xbrukerflattdatastructure(1);
    %________________________________________________
elseif strcmp(task,'generateJacobian')
    if showhelpOnly==1;   %% HELP-PARSER: we need the TARGET-FUNCTION here
        hlpfun='xgenerateJacobian';
        return ;
    end
    
    statusMsg(1,' generate Jacobian matrizes');
    xgenerateJacobian(1);
    statusMsg(0);
    %________________________________________________
    
    %________________________________________________
elseif strcmp(task,'getlesionvolume')
    if showhelpOnly==1;   %% HELP-PARSER: we need the TARGET-FUNCTION here
        hlpfun='xgetlesionvolume';
        return ;
    end
    
    statusMsg(1,' get corrected lesion volume');
    xgetlesionvolume;
    statusMsg(0);
    %________________________________________________
elseif strcmp(task,'makeIncidenceMaps')
    if showhelpOnly==1;   %% HELP-PARSER: we need the TARGET-FUNCTION here
        hlpfun='xincidencemap';
        return ;
    end
    
    statusMsg(1,' make INcidenceMap');
    xincidencemap;
    statusMsg(0);
    %________________________________________________
    
    
elseif strcmp(task,'notes')
    if showhelpOnly==1;   %% HELP-PARSER: we need the TARGET-FUNCTION here
        hlpfun={' open/create a "note-file" associated with the study'};
        hlpfun{end+1,1}=['you can edit important information here (drop outs, code/batch snips, test-results..)'];
        hlpfun{end+1,1}=['[notes.txt] is stored in the studie''s MAIN-folder and can be edited via MATLAB-editor'];
        
        %check if exist and not empty -file
        global an
        notesfile=fullfile(fileparts(an.datpath),'notes.txt');
        if exist(notesfile)
            adum= preadfile(notesfile);
            try
                hlpfun=[hlpfun; adum.all];
            end
        end
        
        
        
        
        return ;
    end
    
    global an;
    if isempty(an),disp(' can''t make notes: no project loaded'); return;end
    pa=fileparts(an.datpath);
    fi=fullfile(pa,'notes.txt');
    if exist(fi)~=2;
        head={};
        head{end+1,1}=['           NOTES'];
        head{end+1,1}=['  project:     ' an.project ];
        head{end+1,1}=['  projectPATH: ' pa   ];
        head{end+1,1}=['  [important notes can be made here] (dropouts, snipps, test-results..)'  ];
        head{end+1,1}=['  [use matlab editor''s [save] button to save the changes of this notes-file] ) '  ];
        no={};
        no(end+1,1)={repmat('=',[1 size(char(head),2)])};
        no=[no;head];
        no(end+1,1)={repmat('=',[1 size(char(head),2)])};
        no=[no ; repmat({repmat(' ',[1 70])},[50,1])];
        pwrite2file(fi,no);
    end
    try; edit(fi); end
    %________________________________________________
elseif strcmp(task,'docs')
    if showhelpOnly==1;   %% HELP-PARSER: we need the TARGET-FUNCTION here
        hlpfun='opens docs-folders with documentations (directory: ~/antx/mritools/ant/docs/) ';
        return ;
    end
    
    
    explorer(fullfile(fileparts(which('ant.m')),'docs'));
    
    
    %________________________________________________
elseif strcmp(task,'dispmainfun')
    if showhelpOnly==1;   %% HELP-PARSER: we need the TARGET-FUNCTION here
        hlpfun='showfun';
        return ;
    end
    
    antcb('status',1,'show functions')
    showfun;
    antcb('status',0,'')
    %________________________________________________
elseif strcmp(task,'keyboard')
    %     if showhelpOnly==1;   %% HELP-PARSER: we need the TARGET-FUNCTION here
    hlpfun='antkeys';
    %         return ;
    %     end
    %
    uhelp('antkeys');
    %     end
    %________________________________________________
elseif strcmp(task,'version')
    if showhelpOnly==1;   %% HELP-PARSER: we need the TARGET-FUNCTION here
        hlpfun='antver';
        return ;
    end
    
    antver;
    %________________________________________________
elseif strcmp(task,'check_ELASTIX_installation')
    if showhelpOnly==1;   %% HELP-PARSER: we need the TARGET-FUNCTION here
        hlpfun='elastix_checkinstallation';
        return ;
    end
       
    
    elastix_checkinstallation;
    %________________________________________________
elseif strcmp(task,'antsettings')
    if showhelpOnly==1;   %% HELP-PARSER: we need the TARGET-FUNCTION here
        hlpfun='antsettings';
        return ;
    end
    
    edit antsettings
    %________________________________________________
elseif strcmp(task,'contact')
    if showhelpOnly==1;   %% HELP-PARSER: we need the TARGET-FUNCTION here
        hlpfun='antintro';
        return ;
    end
    
    try; antintro(1);
    catch ;
        col='*[0 .5 0]';
        cprintf(col,['**********   CONTACT     ******************\n']);
        cprintf(col,['Dr. Philipp Boehm-Sturm  or\n']);
        cprintf(col,['Dr. Stefan Paul Koch\n']);
        cprintf(col,['Charite - University Medicine Berlin\n']);
        cprintf(col,['Campus Mitte\n']);
        cprintf(col,['Department of Experimental Neurology\n']);
        cprintf(col,['Center for Stroke Research Berlin (CSB)\n']);
        cprintf(col,['Neuroforschungshaus, Hufelandweg 14\n']);
        cprintf(col,['Raum: E1 019\n']);
        cprintf(col,['Chariteplatz 1\n']);
        cprintf(col,['10117 Berlin\n']);
        cprintf(col,['phone:  +49 30 450 -560416/-560129/-560236/-539047\n']);
        cprintf(col,['fax:            +49 30 450 -560915\n']);
        cprintf(col,['philipp.boehm-sturm@charite.de\n']);
        cprintf(col,['**********   CONTACT     ******************\n']);
    end
  elseif strcmp(task,'visitGITHUB')
    if showhelpOnly==1;   %% HELP-PARSER: we need the TARGET-FUNCTION here
        hlpfun={' ..visit ANTx2 Repositiory (GITHUB)'};
        return ;
    end
    statusMsg(1,' visiting GITHUB');
    github='https://github.com/ChariteExpMri/antx2';
    if ismac
        system(['open ' github]);
    elseif isunix
       % system(['xdg-open ' github]);
        
         [r1 r2]= system(['xdg-open ' github]);
        if  ~isempty(strfind(r2,'no method available'))
            
            [r1 r2]= system(['who']);
            ulist=strsplit(r2,char(10))';
            lastuser=strtok(char(ulist(1)),' ');
            [r1 r2]=system(['sudo -u ' lastuser ' xdg-open ' github '&']);
            
        end
        
    elseif ispc
        %system(['start ' github]);
         web(github,'-browser');
    
    end   
    statusMsg(0);
 elseif strcmp(task,'openGdrive')
    if showhelpOnly==1;   %% HELP-PARSER: we need the TARGET-FUNCTION here
        hlpfun={' get templates from googledrive'};
        hlpfun{end+1,1}=[' ..go to #b anttemplates folder: '];
        hlpfun{end+1,1}=['  download one/more templates (zip files) '];
        hlpfun{end+1,1}=['  create folder "anttemplates" located at the same hierarchical level as antx2-folder'];
        hlpfun{end+1,1}=['  copy unzipped template folder to "anttemplates" dir'];
        return ;
    end
    statusMsg(1,' visiting Gdrive');
    %gdrive='https://drive.google.com/drive/folders/0B9o4cT_le3AhSFJRdUx3eXlyUWM';
    gdrive='https://drive.google.com/drive/u/1/folders/1q5XOOVLvUYLqYsQJLqNRF7OK8fNwYhI9';
    if ismac
        system(['open ' gdrive]);
    elseif isunix
        %system(['xdg-open ' gdrive]);
        
        
        [r1 r2]= system(['xdg-open ' gdrive]);
        if  ~isempty(strfind(r2,'no method available'))
            
            [r1 r2]= system(['who']);
            ulist=strsplit(r2,char(10))';
            lastuser=strtok(char(ulist(1)),' ');
            [r1 r2]=system(['sudo -u ' lastuser ' xdg-open ' gdrive '&']);
            
        end
        
    elseif ispc
        %system(['start ' gdrive]);
         web(gdrive,'-browser');
        
    end
    statusMsg(0);
elseif strcmp(task,'checkUpdateGithub')
    if showhelpOnly==1;   %% HELP-PARSER: we need the TARGET-FUNCTION here
        hlpfun={' check for updates/changes in GITHUB repository'};
        hlpfun{end+1,1}=[' #g GITHUB repository link: '];
        hlpfun{end+1,1}=['  https://github.com/pstkoch/antx2'];
        hlpfun{end+1,1}=['   '];
        hlpfun{end+1,1}=['  ..redirected help from #gy "installfromgithub.m" '];
        hlpfun=[hlpfun; strsplit(help(which('installfromgithub.m')),char(10))'];
        return ;
    end
    installfromgithub;
    
end


%========================================================
function addcontextmenuLB1
hcm=findobj(gcf,'tag','lb1');
ContextMenu=uicontextmenu;
uimenu('Parent',ContextMenu, 'Label','help',   'callback', {@cmenulb1,'help' } ,'ForegroundColor',[0 .5 0]);
set(hcm,'UIContextMenu',ContextMenu);

function cmenulb1(e,e2,varargin)
hcm=findobj(gcf,'tag','lb1');
us=get(hcm,'userdata');
va=get(hcm,'value');
if strcmp(varargin{1},'help')
    if strfind(us{va,2},'xwarp')
        hs=uhelp('xwarp3.m');
        set(hs,'numbertitle','off','name','HELP');
    elseif strfind(us{va,2},'getlabels')
        hs=uhelp('xgetlabels4.m');
        set(hs,'numbertitle','off','name','HELP');
    elseif strfind(us{va,2},'deformSPM')
        hs=uhelp('xdeform2.m');
        set(hs,'numbertitle','off','name','HELP');
    elseif strfind(us{va,2},'deformELASTIX')
        hs=uhelp('doelastix.m');
        set(hs,'numbertitle','off','name','HELP');
    end
end



%========================================================
function statusMsg(bool,msg)
if exist('msg')==0; msg='';else; msg=['..' msg]; end
hr=findobj(findobj(0,'tag','ant'),'tag','status');
if bool ==1
    set(hr,'string',['status: BUSY!' msg],'foregroundcolor','r');
elseif bool==0
    set(hr,'string','status: IDLE','foregroundcolor','b');
end
drawnow
pause(.01);

function closeallfigs(h,e)
ikeep=(findobj(0,'tag','uhelp'));
if length(ikeep)>1
    ikeep=findobj(0,'name','HELP');
end
if isempty(ikeep);
    cf;
else
    c=get(0,'children');
    c(find(c==ikeep))=[];
    close(c);
end


function keys(h,e)
try
    antkeys(h,e);
end

function closefolders(h,e)
% try; evalc('system(''TASKKILL /F /IM explorer.exe & explorer'')'); end;
if ispc
    try; evalc('!TASKKILL /F /IM explorer.exe'); end
    try; evalc('!start explorer '); end
elseif ismac
    system('osascript -e ''tell application "Finder" to close windows''');
else %LINUX
    try
        [r1 r2]=system(['xdg-mime query default inode/directory']);
        system([strtok(r2,'.') ' -q']);
        system([strtok(r2,'-') ' -q']);
    end
end


function showHTMLsummary(e,e2)

global an
if isempty(an)
    page=fullfile(pwd,'summary.html');
else
    page=fullfile(fileparts(an.datpath),'summary.html');
end

if exist(page)==2
    xhtmlgr('show','page',page);
end

function fun_summary_export(e,e2)

summary_export();



function showCommandHistory(e,e2)

his={''; '<empty>'};
try
    his=evalin('base','anth');
end

% hf=findobj(0,'tag','uhelp','-and','name','[anth] command history');
% if ~isempty(hf)
%     close(hf); 
% end
% uhelp(his, 1, 'cursor' ,'end','lbpos',[0 0 .5 1] );
uhelp(his, 1, 'cursor' ,'end','lbpos',[0 .05 1 .95] );
% set(gcf,'tag','history');
set(gcf,'NumberTitle','off','name','[anth] command history');

h = uicontrol('style','pushbutton','units','normalized','position',[.95 .55 .05 .05],'tag','refreshhistory',...
    'string','refresh','fontsize',8,'fontweight','bold','tooltip','refreh history',...
    'callback',@refreshhistory);
 set(h,'position',[[0 0 .1 .04]],'units','pixels');
 
ht=findobj(gcf,'tag','txtline'); 
unitsref=get(ht,'units');
set(ht,'units','norm');
posref=get(ht,'position');
set(h,'units','norm','position',[.85  posref(2)  posref(3:4)]);
set(h,'units',unitsref);
set(ht,'units',unitsref);


function refreshhistory(e,e2)
his={''; '<empty>'};
try
    his=evalin('base','anth');
end
html=uhelp(his, 'dummy','export',1 );

% hf=findobj(0,'tag','history');
hf=gcf;
u=get(hf,'userdata');

u.fun=his;
u.e0=his;


hl=findobj(hf,'tag','txt');
val=get(hl,'value');

set(hl,'string',html);
set(hf,'userdata',u);

% set(hl,'value',size(get(hl,'string'),1));

list=get(hl,'string');
if max(val)>size(list,1); val=size(list,1)  ; end
set(hl,'value',val);
lenlist=size(list ,1);
set(hl,'listboxtop',lenlist)


function windbuttonmotion(e,e2)
% close uimenu if pointer is outside the menu
try
    hl=hittest(gcf);
    if ~isempty(hl)
        try
           if strcmp(get(hl,'style'),'listbox') && strcmp(get(hl,'tag'),'lb3')
            return
           end
        end
        robot = java.awt.Robot;
        robot.keyPress    (java.awt.event.KeyEvent.VK_ESCAPE);
        robot.keyRelease  (java.awt.event.KeyEvent.VK_ESCAPE);
    end
end


