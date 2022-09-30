

% #b [ANTx2]-TOOLBOX MAIN GUI
% type "ant" to open the ANT-GUI
% FOR INFORMATION/HELP SEE TUTORIALS: https://chariteexpmri.github.io/antxdoc/
% ANIMAL-TEMPLATES CAN BE FOUND HERE: https://drive.google.com/drive/folders/1q5XOOVLvUYLqYsQJLqNRF7OK8fNwYhI9
% see also GITHUB-PROJECT: https://github.com/ChariteExpMri/antx2
%
% ==============================================
%%   create project-file
% ===============================================
% create project-file (m-file) via: ANT-menu: Main/new project
%  -in the "settings"-window add the path of the target template (path of your animal template) in field "x.wa.refpath"
%     example: on my system the ANIMAL-TEMPLATE "mouse_Allen2017HikishimaLR" (mouse template) is stored here:
%     "f:\anttemplates\mouse_Allen2017HikishimaLR"
% ==============================================
%%   load a project
% ===============================================
%
%  -via [loadproj]-button, or
%  -via cmd: antcb('load', 'yourprojectfile.m'); where 'yourprojectfile.m' is the created project-file (m-file)
%
% ==============================================
%%  close GUI
% ===============================================
% antcb('close');
%
%
% ==============================================
%%   NO GUI OPTION
% not finished project, mosts functions needs to be adapted
% ...not done yet..
% ===============================================
% -CREATE A PROJECT-FILE WITHOUT GUI: HERE THE PROJECTFILE "proj2.m" IS CREATED USING A VOXELSIZE
%  OF [.07 .07 .07] mm, and the ANIMAL-TEMPLATE "mouse_Allen2017HikishimaLR" is used, with species 'mouse'
%  makeproject('projectname',fullfile(pwd,'proj2.m'), 'voxsize',[.07 .07 .07],'wa_refpath','F:\anttemplates\mouse_Allen2017HikishimaLR','wa_species','mouse')
% -LOAD A PROJECT-FILE "proj.m" WITHOUT GUI:
%  loadconfig(fullfile(pwd,'proj.m'));
% -CHECK GLOBAL VARAIBLE "an"
%  global an
%
%
%
%
% other help: see antcb
% 
% 



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

function ant(varargin)

warning off;
% ==============================================
%%   inputs
% ===============================================

if nargin>0
    if mod(nargin,2)==1
        p0=cell2struct(varargin(3:2:end),varargin(2:2:end),2);
        p0.cmd=varargin{1};
    else
        p0=cell2struct(varargin(2:2:end),varargin(1:2:end),2);
        p0.cmd=varargin{1};
    end
    
    if strcmp(p0.cmd,'menubar_setTooltips')  % set tooltips (call: antcb('load_guiparameter'))
        menubar_setTooltips(p0.value);
    elseif strcmp(p0.cmd,'showfunctionhelp') % set functionHelp (call: antcb('load_guiparameter'))
        showfunctionhelp();
    end
%     if strcmp(p0.cmd,'showcmd') 
%         showcmd(arg)
%     end
    
    
    return
end



% ==============================================
%%   
% ===============================================


% %tags:
% lb1: functions
% lb2: parameter-file
% lb3: mice cases

warning off; close all
persistent showfiglet
if isempty(showfiglet)
    antcb('figlet');
    showfiglet=1;
end
disp(antcb('version'));
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
h=figure('color','w','units','normalized','menubar','none', 'tag','ant','name','ANTx2',...
    'NumberTitle','off',...
    'position',[  0.5396    0.42    0.3677    0.4994]);
% set(gcf,'closereq','spm(''Quit'')','HandleVisibility','off')
set(h,'closereq','');
set(h,'KeyPressFcn',@keys);
if 0 % changed 'off': date: 22.mar.2022 ...> don't know what reason was
    set(h,'WindowButtonMotionFcn', @windbuttonmotion);
end

% fg
try
    % drawnow
    % pause(.1);
    warning('off','MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');
    jframe=get(gcf,'javaframe');
    icon=fullfile(fileparts(which('ant.m')),'mouse.png');
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
set(h,'visible','off');

list_sortprogress=...
    {...
    'sort:default'
    'sort:progress_down'
    'sort:progress_up'
    'sort:lengthName_up'
    'sort:lengthName_down'
    'sort:statusMsg_up'
    'sort:statusMsg_down'};

h = uicontrol('style','popupmenu','units','normalized','position',[.1 .5 .2 .05],'tag','pop_sortprogress',...
    'string',list_sortprogress,'value',1,'fontsize',6,'backgroundcolor','w','callback',{@antcb,'update'},...
    'tooltip','<html>sort animals according to...<br><font color="red">WARNING! <br> the animal sorting is currently a testing mode<br>use at own risk!');
set(h,'visible','on');

%DIRS-number selected
h = uicontrol('style','text','units','normalized','position',[.3 .5 .2 .025],'tag','tx_dirsselected',...
    'string',['1 dir(s) selected' ],'fontsize',6,'backgroundcolor','w',...
    'tooltip','number of currently selected directories','foregroundcolor',[ 0 .5 0],'fontweight','normal');


% h = uicontrol('style','pushbutton','units','normalized','position',[.1 .5 .1 .05],'tag','pbclear',...
% 	'string','clearsubjects','fontsize',10,'fontweight','bold','callback',{@antcb,'clearsubjects'});

% h = uicontrol('style','checkbox','units','normalized','position',[.2 .5 .1 .05],'tag','rb1',...
%     'string','takeCases','fontsize',10,'value',0);

% ==============================================
%%
% ===============================================

%% PBload
h = uicontrol('style','pushbutton','units','normalized','position',[.0 .6 .1 .08],'tag','pbload',...
    'string','loadproj','fontsize',13,   'callback',{@antcb,'load'},...
    'tooltip',['<html><b><font color="green">load the studies''s configfile' '</b><br>'...
    '</font>' '..see also context menu']);

c = uicontextmenu;
m1 = uimenu(c,'Label','reload project'     ,'Callback',{@loadproj_context,'reload'});
m1 = uimenu(c,'Label','edit project-file'  ,'Callback',{@loadproj_context,'edit'});
m1 = uimenu(c,'Label','show command to load project-file'  ,'Callback',{@loadproj_context,'loadcommand'});


% m1 = uimenu(c,'Label','export HTML summary','Callback',@fun_summary_export);
set(h,'UIContextMenu',c);


% h = uicontrol('style','pushbutton','units','normalized','position',[.0 .6 .1 .08],'tag','pbload',...
%     'string','loadproj','fontsize',13,                                        'callback',{@testcrash},'tooltip','load the studies''s configfile');





% ==============================================
%%   history
% ===============================================
%% SETTINGS
h = uicontrol('style','pushbutton','units','normalized','position',[.15 .6 .05 .08],...
    'tag','ant_study_history',...
    'string','','fontsize',13,   'callback',@openStudyHistory,'tooltip', 'open STUDY-HISTORY',...
    'backgroundcolor','w');
% icon=which('profiler.gif');
icon=fullfile(matlabroot,'toolbox','matlab', 'icons','book_link.gif');
[e map]=imread(icon)  ;
e=ind2rgb(e,map);
% e(e<=0.01)=nan;
set(h,'cdata',e);
% ==============================================
%%   CFM -all
% ===============================================
%% SETTINGS
h = uicontrol('style','pushbutton','units','normalized','position',[.25 .6 .04 .05],...
    'tag','ant_cfm',...
    'string','','fontsize',13,   'callback',{@openCFM,'all'},...
    'tooltip', ['<html><b>open Case-FileMatrix for <font color="fuchsia"> all </font>animals</b><br>',...
    '<font color="green">see context menu for more options'],...
    'backgroundcolor','w');
% icon=which('profiler.gif');
icon=fullfile(matlabroot,'toolbox','matlab', 'icons','HDF_grid.gif');
[e map]=imread(icon)  ;
inoLila=find(map(:,1)==1 & map(:,2)==0 & map(:,3)==1 );
map(inoLila,:)=repmat([0 .5 0],[length(inoLila) 1]);
e=ind2rgb(e,map);
% e(e<=0.01)=nan;
set(h,'cdata',e);

cmm=uicontextmenu;
uimenu('Parent',cmm, 'Label','show CFM of all animals in TXT-window',             'callback', {@ant_cfm_ontext,'win','all' 1});
uimenu('Parent',cmm, 'Label','show CFM of all animals in TXT-window TRANSPOSED',  'callback', {@ant_cfm_ontext,'win','all' 2});
uimenu('Parent',cmm, 'Label','show CFM of all animals in CMD-window',             'callback', {@ant_cfm_ontext,'cmd','all' 1});
uimenu('Parent',cmm, 'Label','show CFM of all animals in CMD-window TRANSPOSED',  'callback', {@ant_cfm_ontext,'cmd','all' 2});
set(h,'UIContextMenu',cmm);



% ==============================================
%%   CFM -selected
% ===============================================
%% SETTINGS
h = uicontrol('style','pushbutton','units','normalized','position',[.29 .6 .04 .05],...
    'tag','ant_cfm',...
    'string','','fontsize',13,   'callback',{@openCFM,'sel'},...
    'tooltip', ['<html><b>open Case-FileMatrix for <font color="red"> selected </font>animals</b><br>',...
    '<font color="green">see context menu for more options'],...
    'backgroundcolor','w');
% icon=which('profiler.gif');
% icon=fullfile(matlabroot,'toolbox','matlab', 'icons','HDF_grid.gif');
% [e map]=imread(icon)  ;
e2=e(:,[3:8 end-1:end],:);
% e(:,[ end-7:end])=1;

% e=ind2rgb(e,map);
% e(e<=0.01)=nan;
set(h,'cdata',e2);

cmm=uicontextmenu;
uimenu('Parent',cmm, 'Label','show CFM of selected animals in TXT-window',             'callback', {@ant_cfm_ontext,'win','sel' 1 });
uimenu('Parent',cmm, 'Label','show CFM of selected animals in TXT-window TRANSPOSED',  'callback', {@ant_cfm_ontext,'win','sel' 2 });
uimenu('Parent',cmm, 'Label','show CFM of selected animals in CMD-window',             'callback', {@ant_cfm_ontext,'cmd','sel' 1 });
uimenu('Parent',cmm, 'Label','show CFM of selected animals in CMD-window TRANSPOSED',  'callback', {@ant_cfm_ontext,'cmd','sel' 2 });

set(h,'UIContextMenu',cmm);

% ==============================================
%%   %% SETTINGS
% ===============================================

h = uicontrol('style','pushbutton','units','normalized','position',[.1 .6 .05 .08],'tag','pbconfig',...
    'string','','fontsize',13,     'callback',{@antcb,'settings'},...
    'tooltip','open settings of the currently loaded project-file',...
    'backgroundcolor','w');
% icon=which('profiler.gif');
icon=strrep(which('ant.m'),'ant.m','settings.png');
[e map]=imread(icon)  ;
e=ind2rgb(e,map);
% e(e<=0.01)=nan;
set(h,'cdata',e);

% ==============================================
%%
% ===============================================



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


%% RADIO-Help
h = uicontrol('style','radiobutton','units','normalized','position',[.94 .61 .08 .05],'tag','radioshowhelp',...
    'string','hlp','fontsize',5,'fontweight','normal',...
    'callback',@radioshowhelp,'backgroundcolor',[1 1 1],...
    'tooltip',['show/hide help window when hovering over menu functions' char(10) ...
    '..press [esc]-button to close main menu when hovering over specif function ' char(10) ....
    '  this will preserve the information/help of the last mouse-over function in the help window ']);
% ---contexmenu
c = uicontextmenu;
plotline.UIContextMenu = c;
m1 = uimenu(c,'Label','enable menu tooltips','Callback',{@radioshowhelp_context,'enableTooltips'});%,...
%     'tooltip',['enable tooltips when hovering over menu items' ]
set(h,'UIContextMenu',c);


%% RADIO-HTML progress-report
h = uicontrol('style','radiobutton','units','normalized','position',[.94 .65 .08 .05],'tag','radioshowHTMLprogress',...
    'string','PR','fontsize',5,'fontweight','normal','tooltip','show/hide HTML progress report for initialization,coregistration, segmentation & warping',...
    'callback',@radioshowHTMLprogress,'backgroundcolor',[1 1 1],'value',1);
% ---contexmenu
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
gitpath=fileparts(which('antlink.m'));
w=git([' -C ' gitpath ' log -1 --pretty="format:%ci"']);
if isempty(strfind(w,'fatal'))
    [w1 w2]=strtok(w,'+');
    dateLU=['ANTx2 v: ' w1 ];
end

h = uicontrol('style','pushbutton','units','normalized','position',[.94 .65 .08 .05],'tag','txtversion',...
    'string',dateLU,'fontsize',5,'fontweight','normal',...
    'tooltip',['<html><b>ANTx-version</b><br>'...
    'date of last update<br>' ...
    '<font color="green"> Hit button to inspect the latest updates (or type "antver")']);

set(h,'position',[.5 .67 .25 .027],'fontsize',7,'backgroundcolor','w','foregroundcolor',[0.9294    0.6941    0.1255],...
    'horizontalalignment','left','callback',{@callantver});
%% ===============================================
% update-pushbutton :get update ...no questions ask
%% ===============================================
h = uicontrol('style','pushbutton','units','normalized','position',[.94 .65 .04 .05],...
    'tag','update_btn',...
    'string','','fontsize',13,  'callback',{@updateTBXnow},...
    'tooltip', ['<html><b>download latest updates from Github</b><br>forced updated, no user-input<br>'...
    '<font color="green"> see contextmenu for more options'],...
    'backgroundcolor','w');
set(h,'position',[.75 .668 .04 .05]);
set(h,'units','pixels');
posi=get(h,'position');
set(h,'position',[posi(1:2) 14 14]);
set(h,'units','norm');
% icon=fullfile(antpath,'icons','Download_16.png');
icon=fullfile(antpath,'icons','download16x16.png');
[e map]=imread(icon)  ;
set(h,'cdata',e);

cmm=uicontextmenu;
uimenu('Parent',cmm, 'Label','check update-status',             'callback', {@updateTBX_context,'info' });
uimenu('Parent',cmm, 'Label','force update',                    'callback', {@updateTBX_context,'forceUpdate' } ,'ForegroundColor',[1 0 1],'separator','on');
uimenu('Parent',cmm, 'Label','show last local changes (files)', 'callback', {@updateTBX_context,'filechanges_local' } ,'ForegroundColor',[.5 .5 .5],'separator','on');
uimenu('Parent',cmm, 'Label','help: update from GitHUB-repo' ,  'callback', {@updateTBX_context,'help' } ,'ForegroundColor',[0 .5 0],'separator','on');
set(h,'UIContextMenu',cmm);


%% ===============================================
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
antcb('load_guiparameter');

% settings=antsettings;
% hf=findobj(0,'tag','ant');
% hradio    =findobj(hf,'style','radio');
% set(hradio,'fontsize',settings.fontsize-2);
% 
% hradiohelp=findobj(hf,'tag','radioshowhelp');
% set(hradiohelp,'value', settings.show_instant_help);
% if get(hradiohelp,'value')==1
%     drawnow;
%     showfunctionhelp
% end
% 
% hprogress=findobj(hf,'tag','radioshowHTMLprogress'); %HTML progress
% if ~isempty(hprogress)
%     try; set(hprogress,'value',settings.show_HTMLprogressReport); end
% end
% 
% if settings.show_intro==1
%     try
%         antintro
%     end
% end
% % set tooltips
% menubar_setTooltips(settings.enable_menutooltips);

%% ========0add resize button for animal-LB]=======
try
    hf=findobj(0,'tag','ant');
    hres=findobj(hf,'tag','lb3');
    addResizebutton(hf,hres,'mode','UR');
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

uimenu('Parent',ContextMenu, 'Label','check registration via GUI',                 'callback', {@cmenuCasesCB,'checkRegist' } ,'ForegroundColor',[0 0 1]);
%% ===============================================

hc3=uimenu('Parent',ContextMenu, 'Label','<html><b>check registration - make HTML-file' ,'ForegroundColor',[0 0 1]);
uimenu('Parent',hc3, 'Label','<html><b>check forward registration (standard-space)'  , 'callback', {@cmenuCasesCB,'checkRegistHTMLforw' }          ,'ForegroundColor',[0 0 1  ]);
uimenu('Parent',hc3, 'Label','<html>check specific forward registration (open GUI)'  , 'callback', {@cmenuCasesCB,'checkRegistHTML_forwspecific' } ,'ForegroundColor',[0 0 1  ]);

uimenu('Parent',hc3, 'Label','<html><b>check inverse registration (native-space)'    , 'callback', {@cmenuCasesCB,'checkRegistHTML_inv' }          ,'ForegroundColor',[0 .5 0 ]);
uimenu('Parent',hc3, 'Label','<html>check specific inverse registration (open GUI)'  , 'callback', {@cmenuCasesCB,'checkRegistHTML_invspecific' }  ,'ForegroundColor',[0 .5 0 ]);

%% ===============================================

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

%% ===============================================

hc3=uimenu('Parent',ContextMenu, 'Label','<html><b>specific tools' ,'ForegroundColor',[ 0.8706    0.4902         0]);
uimenu('Parent',hc3, 'Label','<html><b>prune mask ("_msk.nii")'  , 'callback', {@cmenuCasesCB,'prune_mask' }          ,'ForegroundColor',[0 0 1  ],'Separator','on');
%% ===============================================


% uimenu('Parent',ContextMenu, 'Label','exclude case (include prev. excluded case)', 'callback', {@cmenuCasesCB,'dropout' } ,'ForegroundColor',[1 0 0], 'Separator','on');
uimenu('Parent',ContextMenu, 'Label','general info',  'callback', {@cmenuCasesCB,'generalinfo' } ,'ForegroundColor',[0 .5 0], 'Separator','on');
uimenu('Parent',ContextMenu, 'Label','export folder', 'callback', {@cmenuCasesCB,'copyfolders' } ,'ForegroundColor',[1 .0 0], 'Separator','on');

uimenu('Parent',ContextMenu, 'Label','watch files', 'callback', {@cmenuCasesCB,'watchfile' } ,'ForegroundColor',[0 .0 0], 'Separator','on');

% USERDEFINED STATUS
hu2=uimenu('Parent',ContextMenu, 'Label','set status (tag animals)','callback', {@cmenuCasesCB,'setAnimalStatus' ,1} ,'ForegroundColor',[0 .0 0], 'Separator','on');
% uimenu('Parent',hu2, 'Label','set status "good"', 'callback',                {@cmenuCasesCB,'setAnimalStatus' ,1 } ,'ForegroundColor',[0 .0 0], 'Separator','on');
% uimenu('Parent',hu2, 'Label','set status "bad"',  'callback',                {@cmenuCasesCB,'setAnimalStatus' ,2 } ,'ForegroundColor',[0 .0 0], 'Separator','on');
% uimenu('Parent',hu2, 'Label','set status <userdefined>',  'callback',        {@cmenuCasesCB,'setAnimalStatus' ,3 } ,'ForegroundColor',[0 .0 0], 'Separator','on');
% uimenu('Parent',hu2, 'Label','remove status', 'callback', {@cmenuCasesCB,'setAnimalStatus' ,4 } ,'ForegroundColor',[0 .0 0], 'Separator','on');



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
function cmenuCasesCB(h, e, cmenutask,par1)
global an
if isempty(an)
    disp('no project loaded');
    return
end
lb3=findobj(findobj(0,'tag','ant'),'tag','lb3');

seldirs=antcb('getsubjects');

switch cmenutask
    case 'opdendir'
        va=get(lb3,'value');
        for i=1:length(va)
            dirx= an.mdirs{va(i)};
            explorer(dirx);
            %system(['explorer ' dirx]);
        end
    case 'renamedir'
        va=get(lb3,'value');
        dirs=xrenamedir('dirs',an.mdirs(va));
        %an.mdirs=dirs(:,2) ;
        sel=[];
        for i=1:size(dirs,1)
            is=find(strcmp( an.mdirs,dirs{i} ));
            sel(end+1,1)=is;
            an.mdirs(is)=dirs(i,2);
        end
        set(lb3,'value',sel);
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
        %% ===============================================
        
    case 'checkRegistHTMLforw'
        statusMsg(1,' check Registration-HTML ');
        checkregistration();
        statusMsg(0);
    case 'checkRegistHTML_forwspecific'
        statusMsg(1,' check Registration-HTML ');
        checkregistration(1,1);
        statusMsg(0);
    case 'checkRegistHTML_inv'
        statusMsg(1,' check Registration-HTML ');
        checkregistration(0,-1);
        statusMsg(0);
    case 'checkRegistHTML_invspecific'
        statusMsg(1,' check Registration-HTML ');
        checkregistration(1,-1);
        statusMsg(0);
        
        %% ===============================================
    case 'prune_mask'
        statusMsg(1,' prune_mask ');
        
        
        
        for i=1:length(seldirs)
            f1=fullfile(seldirs{i},'_msk.nii');
            if exist(f1)==2
                cleanmask(f1,'wait',1);
            else
                disp(['not found: ' f1]);
            end
        end
        
        
        
        statusMsg(0);
        %% ===============================================
        
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
            %             disp([ name ' rotTable-ID is [' num2str(id)  '] ..which is  "' rotstring  '"']);
            
            
            % ==============================================
            %% show info
            % ===============================================
            global info1001
            info1001=...
                {
                ' #wg  *** Orientation Type for Template Registration ***   '
                ''
                ' #wo      Option-2: ROTATION  TABLE ID      (Rec.) '
                'To use the selected orientation type for template registration,'
                'open the settings window by selecting the #b [gearwheel-icon] #n from the ANT'
                'main window. '
                'The last command line output was:'
                [' #m  >>' name ' rotTable-ID is [' num2str(id)  '] ..which is  ``' rotstring  '``']
                [ 'The value in the square-brackets ( here: #r ' num2str(id)  ' #n ) is the rotation-table-ID.'  ]
                'Set the parameter #b [x.wa.orientationType] #n to this value.'
                'Note that the value must be #k numeric. '
                'Internally, this value refers to three rotation angles stored in a table.'
                ''
                ' #wo    Option-2: ROTATIONS defined as string-Arguemnt     '
                [  ' Alternatively, you can also use the three rotations (here #r ''' rotstring ''' #n )']
                ' as #k string-argument #n in #b [x.wa.orientationType].'
                ''
                [' #r ' repmat('=', [1 80])]
                ' #r Don''t forget to save the settings before doing the template registration. '
                [' #r ' repmat('=', [1 80])]
                };
            disp([[ name ' rotTable-ID is [' num2str(id)  '] ..which is  "' rotstring  '."   '] ...
                ['<a href="matlab:global info1001; uhelp(info1001,0,''name'',''info'');clear info1001">' '[HELP]' '</a>' ]  ]);
            
            
            
            %
            
            %
            %            disp([
            %                 ['<a href="matlab: uhelp('' (strjoin(msgdo,char(10)))  ''',1,''name'',''info'');">' '[HELP]' '</a>'] ...
            %               ]);
            %
            %           disp([
            %                 ['<a href="matlab: uhelp(''' 'mean.m'  ''',1,''name'',''info'');">' '[HELP]' '</a>'] ...
            %               ]);
            %
            %
            
            
            % ==============================================
            %%
            % ===============================================
            
            
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
        ifo{end+1,1}=(['print all mouse folders '   ' <a href="matlab: disp(' 'char(antcb(' '''getallsubjects''' '))' ')">' an.datpath '</a>' '' ['[' ' N=' num2str(size(fis,1))  ']' ]  ]);% show h<perlink
        ifo{end+1,1}=(['show montage of "t2.nii"-image'   ' <a href="matlab: montage_t2image">' 'montage' '</a>' '' ' (centerpoint)'  ]);% show h<perlink
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
        
        
    case 'setAnimalStatus'
        
        px=antcb('getsubjects');
        msg0=setanimalstatus(px);
        
        if isempty(msg0)
            for i=1:length(px)
                f1=fullfile(px{i},'msg.mat');
                delete(f1);
            end
            antcb('update');
        elseif iscell(msg0)
            
            msg=struct();
            msg.m1=regexprep([msg0{2} msg0{3}],{' <html>' '</html>'},{''});
            msg.m2=msg0{4};
            for i=1:length(px)
                f1=fullfile(px{i},'msg.mat');
                save(f1,'msg');
            end
            antcb('update');
        else
            %                if isnumeric(msg0)
            return;
            
        end
        
        
        
        
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
% ==============================================
%%   ant-menu
% ===============================================

%    'userdata',[HSTART '#' HEND '#']);

%% ==========[menu:MAIN]=====================================
HSTART='<html><b>';
HEND  ='</b><br>';

mh = uimenu(f,'Label','Main');
mh2 = uimenu(mh,'Label',' New Project',                          'Callback',{@menubarCB, 'xnewproject' },    ...
    'userdata',[HSTART 'create a new project for a new study ' HEND ' define processing parameter ']       );
mh2 = uimenu(mh,'Label',' Create Study Templates',               'Callback',{@menubarCB, 'copytemplates' },  ...
    'userdata',[HSTART 'copying template to study-templates folder ' HEND ' ...using defined voxel-size ']);
mh2 = uimenu(mh,'Label',' Import Bruker data',                   'Callback',{@menubarCB, 'brukerImport'},'separator','on',    ...
     'userdata',[HSTART 'import Bruker raw-date' HEND ' ..from various MR-sequences (2dseq/reco)']);
mh2 = uimenu(mh,'Label',' Import DATA',                          'Callback',{@menubarCB, 'dataimport'  },  ...
    'userdata',[HSTART 'import NIFTI-files from other external folder(s)' HEND '...to animal-folders of the study']);
    mh2 = uimenu(mh,'Label',' Import NIFTI via header-replacement',  'Callback',{@menubarCB, 'dataimport2' },  ...
         'userdata',[HSTART 'replace header of NIFTI-files ' HEND '..using the header of a reference-file']);
mh2 = uimenu(mh,'Label',' Import ANALYZE (*.obj) files (masks)', 'Callback',{@menubarCB, 'importAnalyzmask' }, ...
    'userdata',[HSTART 'import and convert ANALYZE-files' HEND ' (*.obj) files to NIFTI-files']);
mh2 = uimenu(mh,'Label',' Import DATA via "Dir-to-Dir" correspondence',   'Callback',{@menubarCB, 'dataimportdir2dir'},    ...
     'userdata',[HSTART 'import any data from external "name"-matching directories' HEND '..to internal mouse directories' HEND 'animal-names (folders) must match']);
%     'userdata',sprintf('import any data from external "name"-matching directories to internal mouse directories \n prerequisite:  matching directory-name-tag')       );
mh2 = uimenu(mh,'Label',' Distribute files (files from outside to selected mouse-folders)',   'Callback',{@menubarCB, 'distributefilesx'} , ...
    'userdata',[HSTART 'import NIFTI-files from external source' HEND '..prerequisite: matching file-name-tag or directory-name-tag']);
mh2 = uimenu(mh,'Label',' convert dicom to nifti',         'Callback',{@menubarCB, 'xconvertdicom2nifti' },'separator','on',  ...
     'userdata',[HSTART 'convert DICOM-files to NIFTI-files' ]);
mh2 = uimenu(mh,'Label',' merge directories',              'Callback',{@menubarCB, 'xmergedirectories' },  ...
     'userdata',[HSTART 'merge the  contents of pairwise assigned directories' ]);
mh2 = uimenu(mh,'Label',' export files (from ANT-project)',              'Callback',{@menubarCB, 'export'},'Separator','on', ...
    'userdata',[HSTART 'EXPORT selected files from selected ANT-folders' HEND '.. an ANT-project must be loaded)']);
mh2 = uimenu(mh,'Label',' export files (from any folder)',               'Callback',{@menubarCB, 'export_fromanyfolder'},'Separator','off', ...
     'userdata',[HSTART 'EXPORT selected files from any folders' HEND ' .. no need to load an ANT-project ']);
mh2 = uimenu(mh,'Label',' quit',                          'Callback',{@menubarCB, 'quit'},'Separator','on',...
     'userdata',[HSTART ' close ANT-GUI' HEND ' .. same as antcb(''close'');']);


% toolt={};
% toolt{end+1,1}='make a new project for this study ..specify paths';
% toolt{end+1,1}='copy templates from reference path to study''s-template-folder';
% toolt{end+1,1}='--';
% toolt{end+1,1}='import Bruker-raw data';
% toolt{end+1,1}='import external files to study''s animal-folders';
% toolt{end+1,1}='import external NIFTI-files to study''s animal-folders';
% toolt{end+1,1}='import & convert ANALYZE-files (*.obj)  (masks) to study''s animal-folders';
% toolt{end+1,1}='Import external DATA from source with identical directories names (animal names)';
% toolt{end+1,1}='--';
% toolt{end+1,1}='convert DICOM-files to NIFTI-files';
% toolt{end+1,1}='merge content of two folders';
% toolt{end+1,1}='export files to another location..an ANT-project needs to be loaded';
% toolt{end+1,1}='export files to another location..this works without loading an ANT-project';
% toolt{end+1,1}='close ant-GUI';

set(get(mh,'children'),'tag','mb');
hmb=findobj(gcf,'tag','mb');
cb=get(hmb,'callback');
for i=1:length(cb)
    set(hmb(1),'buttondownfcn',cb{i});
end


%% ==========[menu:TOOLS]=====================================
%    'userdata',[HSTART '#' HEND '#']);
mh = uimenu(f,'Label','Tools');
mh2 = uimenu(mh,'Label',' coregister images',                                              'Callback',{@menubarCB, 'coregister'},      ...
    'userdata',[HSTART 'coregister images' HEND '.. a source image is registered to a target image' HEND '..other images can be applied']);
mh2 = uimenu(mh,'Label',' register exvivo to invivo',                                       'Callback',{@menubarCB, 'registerexvivo'},   ...
    'userdata',[HSTART 'an exvivo skull-stripped image is registered to an invivo image']);
mh2 = uimenu(mh,'Label',' register CT image',                                              'Callback',{@menubarCB, 'registerCT'},      ...
    'userdata',[HSTART ' register an CT-image to t2w-image ("t2.nii")']);
mh2 = uimenu(mh,'Label',' register images manually',                                       'Callback',{@menubarCB, 'registermanually'},   ...
    'userdata',[HSTART 'an image is registered to another image manually' HEND '..via GUI']);
mh2 = uimenu(mh,'Label',' realign images (SPM, monomodal)'       , 'Callback',{@menubarCB, 'realignImages'}       ,'Separator','on'   ,...
    'userdata',[HSTART 'use SPM to realign images' HEND  '...monomodal approach']);
mh2 = uimenu(mh,'Label',' realign images (ELASTIX, multimodal)'  , 'Callback',{@menubarCB, 'realignImagesMultimodal'},...
     'userdata',[HSTART 'use ELATSIX to realign images' HEND  '...multimpodal approach']);

mh2 = uimenu(mh,'Label',' manipulate files (rename/copy/delete/extract/expand)',       'Callback',{@menubarCB, 'renamefile_simple'},'Separator','on',...
     'userdata',[HSTART 'to rename/copy/delete/extract or expand NIFTI-FILES' HEND ' ..or make simple file-operations (masking/thresholding/change voxel-size)']);
mh2 = uimenu(mh,'Label',' delete files',                                                   'Callback',{@menubarCB, 'deletefiles'},...
    'userdata',[HSTART 'delete selected files' ]);
mh2 = uimenu(mh,'Label',' manipulate header',                                              'Callback',{@menubarCB, 'manipulateheader'},'Separator','on',...
     'userdata',[HSTART ' change the header of an image' HEND '...for instance by using a ref-image' HEND '..apply to other images']);
mh2 = uimenu(mh,'Label',' replace header (older version)',                                 'Callback',{@menubarCB, 'replaceheader'},...
     'userdata',[HSTART ' older version to replace the header of an image']);

mh2 = uimenu(mh,'Label',' image calculator',                                               'Callback',{@menubarCB, 'calc0'},'Separator','on',...
    'userdata',[HSTART 'make image calculations' HEND '..image-hresholding/masking/addition etc.' HEND '..create new image'  ]);
mh2 = uimenu(mh,'Label',' Mask-Generator (GUI)',                                           'Callback',{@menubarCB, 'maskgenerate'},'Separator','on',...
    'userdata',[HSTART 'generate mask(s)' HEND ' from NIFTI-file ("ANO.nii")']);
mh2 = uimenu(mh,'Label',' make mask from Excelfile',                                       'Callback',{@menubarCB, 'maskgenerateFromExcelfile'},...
    'userdata',[HSTART 'generate mask(s)' HEND ' from modified Excelfile of "ANO.xlsx"'  HEND '...see help of function']);
mh2 = uimenu(mh,'Label',' draw mask',                                            'Callback',{@menubarCB, 'drawmask'},'Separator','on',...
     'userdata',[HSTART 'manually draw a mask' ]);
mh2 = uimenu(mh,'Label',' [1a] segment tube',                                     'Callback',{@menubarCB, 'segmenttube'},'Separator','on',...
    'userdata',[HSTART 'automatic-mode: if an image contains several animals' HEND '..obtain masks for each animal ']);
mh2 = uimenu(mh,'Label',' [1b] segment tube manually',                            'Callback',{@menubarCB, 'segmenttubeManu'},...
    'userdata',[HSTART 'manual-mode: if an image contains several animals' HEND '..obtain masks for each animal ']);
mh2 = uimenu(mh,'Label',' [2] split tube data',                                   'Callback',{@menubarCB, 'splittubedata'},...
     'userdata',[HSTART 'if an image contains several animals' HEND '..split image into animal-specific images based on masks from segment-tube ']);




%% ==========[menu:2D]=====================================
mh = uimenu(f,'Label','2D');
mh2 = uimenu(mh,'Label','<html><font color="black"> extract slice        <font color="red"><i> *',                      'Callback',{@menubarCB, 'extractslice'},...
    'userdata',[HSTART 'extract single slice from 3D/4D-volume' HEND '#']);
mh2 = uimenu(mh,'Label','<html><font color="black"> coregister slices 2D <font color="red"><i> *',                      'Callback',{@menubarCB, 'coregister2D'},...
    'userdata',[HSTART 'slicewise 2d-coregistration']);
mh2 = uimenu(mh,'Label','<html><font color="black"> apply 2d-registration to other images <font color="red"><i> *',     'Callback',{@menubarCB, 'coregister2Dapply'},...
    'userdata',[HSTART 'if other images needs to be registered as well' HEND '..apply this function']);


%    'userdata',[HSTART '#' HEND '#']);
%% ==========[menu:GRAPHICS]=====================================
mh = uimenu(f,'Label','Graphics');
mh2 = uimenu(mh,'Label',' show cases-file-matrix',                                         'Callback',{@menubarCB, 'casefilematrix'},'Separator','on',...
    'userdata',[HSTART 'case(animal)-file-matrix' HEND 'make table of animals x files' HEND '...usefull to check the existence of files'  HEND '..older version']);
mh2 = uimenu(mh,'Label',' GUI overlay image',                                              'Callback',{@menubarCB, 'overlayimageGui'},...
     'userdata',[HSTART 'overlay images' HEND 'old version...needs to be modified']);
mh2 = uimenu(mh,'Label',' GUI overlay image2',                                             'Callback',{@menubarCB, 'overlayimageGui2'},...
         'userdata',[HSTART 'overlay images' HEND 'really-old version...needs to be modified']);
mh2 = uimenu(mh,'Label',' fastviewer',                                                     'Callback',{@menubarCB, 'fastviewer'},...
        'userdata',[HSTART 'overlay images' HEND 'old version...needs to be modified']);
mh2 = uimenu(mh,'Label',' Atlas viewer',                                                   'Callback',{@menubarCB, 'xatlasviewer'},'Separator','on',...
     'userdata',[HSTART 'display an atlas (ANO.nii)' HEND '...inspect regions']);
mh2 = uimenu(mh,'Label',' 3D-volume',                                                      'Callback',{@menubarCB, 'x3dvolume'},....
     'userdata',[HSTART 'display volume in 3D ' HEND '...use to visualize: Regions, masks, incidenceMapsDTI, DTI-connections']);

mh2 = uimenu(mh,'Label','<html>check 4D-volume (realignment)</html>',        'Callback',{@menubarCB,  'call_show4d'},'Separator','on',...
 'userdata',[HSTART 'inspect 4D volume' ]);


mh2 = uimenu(mh,'Label','<html><font color=blue>QA: generate HTML-file with overlays</html>',     'Callback',{@menubarCB,  'call_xcheckreghtml'},'Separator','on',...
 'userdata',[HSTART 'use this function to do QA and sanity-checks', HEND ' HTML-files will be stored in the "checks"-folder' ]);

mh2 = uimenu(mh,'Label','<html><font color=blue>QA: obtain registration metric </html>',     'Callback',{@menubarCB,  'call_xQAregistration'},'Separator','off',...
 'userdata',[HSTART 'use this function to obtain a QA-metric for registration', HEND ' HTML-files will be stored in the "checks"-folder' ]);

%% ==========[menu:STUDY]=====================================
mh = uimenu(f,'Label','Study');
mh2 = uimenu(mh,'Label',' open study folder',                              'Callback',{@menubarCB, 'folderConfigfile'},'Separator','on',...
    'userdata',[HSTART 'open study folder in explorer ' ]);
mh2 = uimenu(mh,'Label',' open study template folder',                                'Callback',{@menubarCB, 'folderTemplate'},...
    'userdata',[HSTART 'open study template folder in explorer ' ]);
mh2 = uimenu(mh,'Label',' preselect animal-folders',                                        'Callback',{@menubarCB, 'preselectfolder'},'Separator','on',...
    'userdata',[HSTART 'preselect animal-folders' HEND '..via animal-index or-name, NIFTI-file or via text-file']);

%% ==========[menu:STATISTIC]=====================================
mh = uimenu(f,'Label','Statistic');
% mh2 = uimenu(mh,'Label','<html><font color=rgb(150,150,150)> voxelwise two-sample t-test (independent groups)',                      'Callback',{@menubarCB, 'stat_2sampleTtest'},...
%     'userdata',[HSTART 'perform voxelwise two-sample t-test' HEND '..this is older.. ' HEND '...please use "label-based statistic"']);
% 
% 
% mh2 = uimenu(mh,'Label',' label-based two-sample ttest (independent groups)',                      'Callback',{@menubarCB, 'stat_anatomlabels'});

mh2 = uimenu(mh,'Label',' new group assignment',                   'Callback',{@menubarCB, 'newgroupassignment'},'separator','on',...
'userdata',[HSTART 'create new group assignments by merging/combining different groups' HEND '..this produces excelfile(s)']);

mh2 = uimenu(mh,'Label',' obtain parameter from masks',                                             'Callback',{@menubarCB, 'getparamterByMask'},'separator','on',...
'userdata',[HSTART 'extract basic parameters of an image using a mask' HEND '..this produces an excelfile']);
mh2 = uimenu(mh,'Label',' label-based statistic',                                                  'Callback',{@menubarCB, 'xstatlabels0'},'separator','off',...
'userdata',[HSTART 'perform regionwise statistic ' HEND '..for an image across animals']);

mh2 = uimenu(mh,'Label',' SPM-statistic',                                                          'Callback',{@menubarCB, 'spm_statistic'},'separator','on',...
'userdata',[HSTART 'perform voxelwise statistic ' HEND '..for an image across animals']);

mh2 = uimenu(mh,'Label',' DTI-prep for mrtrix',                    'Callback',{@menubarCB, 'dti_prep_mrtrix'},'separator','on',...
    'userdata',[HSTART 'prepare data for DTI-processing ' HEND '..using MRtrix-pipeline']);

mh2 = uimenu(mh,'Label',' DTI-statistic',                          'Callback',{@menubarCB, 'dti_statistic'},'separator','off',...
        'userdata',[HSTART 'perform statistic for DTI-fibre-tracts' HEND '..MRtrix-pipeline has to be run before...' ]);


%% ==========[menu:SNIPS]=====================================
mh = uimenu(f,'Label','Snips');
% mh2 = uimenu(mh,'Label',' flatten bruker Data path for dataImport',                      'Callback',{@menubarCB, 'flattenBrukerdatapath'});
% mh2 = uimenu(mh,'Label',' generate Jacobian Determinant',                                'Callback',{@menubarCB, 'generateJacobian'});

mh2 = uimenu(mh,'Label','<html><font color="blue">scripts collection',                                  'Callback',{@menubarCB, 'scripts_call'},...
    'userdata',[HSTART 'show collection of scripts' HEND ' scripts can be modified and applied']);

mh2 = uimenu(mh,'Label','get corrected lesion volume',                                  'Callback',{@menubarCB, 'getlesionvolume'},...
 'userdata',[HSTART 'obtain corrected lesion volume' HEND '..the output is an Excel-file']);
mh2 = uimenu(mh,'Label','create Maps (incidenceMaps/MeanImage etc)',                                           'Callback',{@menubarCB, 'makeMaps'},...
     'userdata',[HSTART 'function to create aggregated maps across animals' HEND '..create: Incidence-maps, mean/median-image']);


mh2 = uimenu(mh,'Label','convert image to SNR-image',                                           'Callback',{@menubarCB, 'convert2SNRimage'},...
    'userdata',[HSTART 'calculate an SNR-image']);

% mh2 = uimenu(mh,'Label',' DEBUG-functions'                                          );
% mh3 = uimenu(mh2,'Label',' check PATHS (project/study/data)',          'Callback',{@menubarCB, 'makeIncidenceMaps'});
% mh2 = uimenu(mh,'Label',' generate ANO.nii in pseudocolors',    'Callback',{@menubarCB, 'makeANOpseudocolors'});
%  'userdata',[HSTART '#' HEND '#']);
%% ==========[menu:EXTRAS]=====================================
mh = uimenu(f,'Label','Extras');
mh2 = uimenu(mh,'Label','notes',                                                        'Callback',{@menubarCB, 'notes'},...
     'userdata',[HSTART 'make a study-node' HEND '...save interesting/important notes in a file stored in the study-directory']);
mh2 = uimenu(mh,'Label','<html><b>documentations (docs)',                                        'Callback',{@menubarCB, 'docs'},...
     'userdata',[HSTART 'show documentation-folder' HEND '...this folder contains tutuorials']);

mh2 = uimenu(mh,'Label','display main functions',                                       'Callback',{@menubarCB, 'dispmainfun'},...
     'userdata',[HSTART 'show main funtions in the CMD-window']);
% mh2 = uimenu(mh,'Label','ant-settings',                                                 'Callback',{@menubarCB, 'antsettings'},'separator','on');


mh2 = uimenu(mh,'Label','<html><font color=rgb(150,150,0)>version',                                                 'Callback',{@menubarCB, 'version'},'separator','on',...
    'userdata',[HSTART 'shows the ANTx2-version and latest changes']);
mh2 = uimenu(mh,'Label','<html><font color=rgb(150,150,0)>contact',                                                 'Callback',{@menubarCB, 'contact'},...
        'userdata',[HSTART '...how to contact us']);


mh2   = uimenu(mh,'Label','troubleshoot' );
msub1 = uimenu(mh2,'Label','check ELASTIX installation',                           'Callback',{@menubarCB, 'check_ELASTIX_installation'},...
    'userdata',[HSTART 'check if Elastix is installed on the machine' ]);
msub1 = uimenu(mh2,'Label','check path-names (project/datasets/ANTX-TBX)',         'Callback',{@menubarCB, 'check_pathnames'},...
    'userdata',[HSTART 'check if name & paths of the study and animal-names is fine for processing']);

mh2   = uimenu(mh,'Label','aux' );
msub1 = uimenu(mh2,'Label','change command-window color',                           'Callback',{@menubarCB, 'call_cwcol'},...
    'userdata',[HSTART 'change color of command window' ]);
msub1 = uimenu(mh2,'Label','change command-window title',                           'Callback',{@menubarCB, 'call_cwtitle'},...
    'userdata',[HSTART 'change command-window title' ]);

msub1 = uimenu(mh2,'Label','what is my Win-ServerSession-ID?',      'Callback',{@menubarCB, 'call_WinServerID'},...
    'userdata',[HSTART 'change Windows-ServerSession via session-ID' ],'separator','on');
msub1 = uimenu(mh2,'Label','change Win-ServerSession',      'Callback',{@menubarCB, 'call_changeWinServer'},...
    'userdata',[HSTART 'change Windows-ServerSession via session-ID' ],'separator','off');


mh2 = uimenu(mh,'Label','<html><font color="blue">visit ANTx2 repository (Github)',              'Callback',{@menubarCB, 'visitGITHUB'},'separator','on',...
    'userdata',[HSTART 'go to the ANTx2-Github repository']);
mh2 = uimenu(mh,'Label','<html><font color="blue">visit ANTx2 Tutorials (Github-Pages)',         'Callback',{@menubarCB, 'visitGITHUBpages'},'separator','off',...
     'userdata',[HSTART 'show the ANTx2 Tutorials (Github-Pages)']);
mh2 = uimenu(mh,'Label','<html><font color="green">get templates from googledrive',               'Callback',{@menubarCB, 'openGdrive'},'separator','off',...
    'userdata',[HSTART 'download an animal-template from googledrive' HEND '..google-drive will be opend in browser' HEND 'you than have to select and download a template manually']);
mh2 = uimenu(mh,'Label','<html><font color="green">download templates',                           'Callback',{@menubarCB, 'donwloadTemplates'},'separator','off',...
    'userdata',[HSTART 'download an animal-template from googledrive' HEND ...
    ' ..more convenient way <font color=red>...but might not work in your department']);
mh2 = uimenu(mh,'Label','<html><b><font color="fuchsia">check for updates (Github)',                    'Callback',{@menubarCB, 'checkUpdateGithub'},'separator','on',...
    'userdata',[HSTART 'check for latest toolbox-updates via GUI' HEND ... 
    'alternatives:' HEND ... 
    '(1) hit "download"*-Button from the ANT-window (*"latest updates from Github)' HEND ... 
    '(2) type: "updateantx(2)"']);

% <html><font color=rgb(150,150,150)>
%% ==========[menu:INFO]=====================================
mh = uimenu(f,'Label','Info');

if ispc==1
    html_a='<font size=5>';
    html_e='</font>';
else
    html_a='<font size=2>';
    html_e='</font>';
end

mh2 = uimenu(mh,'Label',['<html><font color=green><u><b>*** Menu info ***</u></b><br>'...
    [html_a '<b>[mouse click]</b>' html_e '<br>']...
    [html_a '<b>[left]</b>     - execute function' html_e '<br>']...
    [html_a '<b>[shift+left]</b> - show function help' html_e '<br>']...
    [html_a '<b>[right]</b>    - show function name in commandline'  html_e '<br>']...
    ]);
mh2 = uimenu(mh,'Label','keyboard shortcuts',                                           'Callback',{@menubarCB, 'keyboard'},'separator','on',...
     'userdata',[HSTART 'show ANT-GUI shortcuts' ]);
% mh2 = uimenu(mh,'Label','show menu tooltips','Callback',{@radioshowhelp_context,'enableTooltips'},'tag','menu_showMenuTooltips', 'checked','off');
mh2 = uimenu(mh,'Label','show menu tooltips','Callback',{@menubarCB, 'menu_showMenuTooltips_cb'},...
    'tag','menu_showMenuTooltips', 'checked','off',...
   'userdata',[HSTART 'show tooltips when hovering over menu item' html_e 'click again to hide tooltips' ]);



% --------------local settings------
mh2 = uimenu(mh,'Label','<html><b>local ant-settings...',...
         'userdata',[HSTART 'user-defined local settings']);
mh3 = uimenu(mh2,'Label','create/open local ant-settings',    'Callback',{@menubarCB, 'localantsettings'},'separator','on',...
    'userdata',[HSTART 'edit "localantsettings.m"-file' HEND '.. if not exist...create file "localantsettings.m"']);
mh3 = uimenu(mh2,'Label','show path of local ant-settings',    'Callback',{@menubarCB, 'localantsettingsShowPath'},...
    'userdata',[HSTART '.. show path where "localantsettings.m" is stored ']);
mh3 = uimenu(mh2,'Label','delete local ant-settings',    'Callback',{@menubarCB, 'localantsettingsDelete'},...
    'userdata',[HSTART '.. delete file "localantsettings.m"']);
% ---------------------------------------



%% ===============================================

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

% ==============================================
%%   backup
% ===============================================

% %% MAKE Helpwhen  HOVERING
% if 1
%     for menuIdx = 1:jMenuBar.getComponentCount  %%automatically pull down menu
%         jMenu = jMenuBar.getComponent(menuIdx-1);
%         for j=1:length(jMenu.getMenuComponents   )
%             
%             hj = jMenu.getMenuComponent(j-1);
%             try
%                 lab=char(hj.getLabel);
%                 drawnow
%                 
%                 hm= findobj( f, 'label',lab);
% 
%                 if menuIdx==8
%                     if j==4
%                     lab
%                     end
%                 end
%                 
%                 
%                 % ttoltip ---> see menubar_setTooltips
%                 %    try
%                 %        hj.setToolTipText(hm.UserData);
%                 %    end
% 
%                 %make help
%                 if ~isempty(strfind(class(hj),'MenuItem'))  %no separators in
%                     try
%                         set(hj,'MouseEnteredCallback',{@showfunctionhelp,hm,hj});
%                         % LEFT/RIGHT MOUSE_CLICK
%                         %                         hj=handle(hj, 'CallbackProperties');
%                         set(hj,'MousePressedCallback', {@menuclick_cb,hm,hj});
%                     catch
%                         hj2=handle(hj, 'CallbackProperties');
%                         set(hj2,'MouseEnteredCallback',{@showfunctionhelp,hm,hj});
%                     end
%                 end
%             end
%         end%j
%     end
% end


% ==============================================
%%  menu: set mouse click-selection 
% ===============================================
ss=menu_getTable();
for i=1:size(ss,1)
    hm=ss{i,4};
    hj=ss{i,3};
    if ~isempty(strfind(class(hj),'MenuItem'))  %no separators in
        try
            set(hj,'MouseEnteredCallback',{@showfunctionhelp,hm,hj});
            % LEFT/RIGHT MOUSE_CLICK
            %                         hj=handle(hj, 'CallbackProperties');
            set(hj,'MousePressedCallback', {@menuclick_cb,hm,hj});
        catch
            hj2=handle(hj, 'CallbackProperties');
            set(hj2,'MouseEnteredCallback',{@showfunctionhelp,hm,hj});
        end
    end
end

function menubar_setTooltips(enableTT)
%% JAVA MENU
%% ===============================================

hf=findobj(0,'tag','ant');
ss=menu_getTable();
% disp([{i get(hm,'name')}])
for i=1:size(ss,1)
    hm=ss{i,4};
    hj=ss{i,3};
    %disp({i get(hm,'label')});
    if enableTT==1
        try
            hj.setToolTipText(hm.UserData);
        end
    else
        hj.setToolTipText('');
    end
end
%% ===============================================

hm=findobj(hf,'tag','menu_showMenuTooltips');
if enableTT==1
    set(hm,'checked','on');
else
    set(hm,'checked','off');
end


% 
% drawnow;
% pause(.1);
% hf=findobj(0,'tag','ant');
% jFrame = get(gcf,'JavaFrame');
% try     % R2008a and later
%     jMenuBar = jFrame.fHG1Client.getMenuBar;
% catch
%     jMenuBar = jFrame.fHG2Client.getMenuBar;
% end
% drawnow;
% for menuIdx = 1:jMenuBar.getComponentCount  %%automatically pull down menu
%     jMenu = jMenuBar.getComponent(menuIdx-1);
%     for j=1:length(jMenu.getMenuComponents   )
%         
%         hj = jMenu.getMenuComponent(j-1);
%         try
%             lab=char(hj.getLabel);
%             if enableTT==1
%                 hm= findobj( hf, 'label',lab);
%                 try
%                     hj.setToolTipText(hm.UserData);
%                 end
%             else
%                 hj.setToolTipText('')
%             end
%         end
%     end%j
% end

% hm=findobj(hf,'tag','menu_showMenuTooltips');
% if enableTT==1
%     set(hm,'checked','on');
% else
%     set(hm,'checked','off');
% end



function ss=menu_getTable()

% ==============================================
%%   
% ===============================================

% drawnow;
% pause(.1);
hf=findobj(0,'tag','ant');
jFrame = get(hf,'JavaFrame');
try     % R2008a and later
    jMenuBar = jFrame.fHG1Client.getMenuBar;
catch
    jMenuBar = jFrame.fHG2Client.getMenuBar;
end
% drawnow
ss={};
for menuIdx = 1:jMenuBar.getComponentCount
    jMenu = jMenuBar.getComponent(menuIdx-1);
    for j=1:length(jMenu.getMenuComponents   );
        hj = jMenu.getMenuComponent(j-1);
%         drawnow
        try;%strcmp(hj.getUIClassID,'MenuUI')==1
            lab=char(hj.getLabel);
%             drawnow
            hm= findobj( hf, 'label',lab);
            ss(end+1,:)={lab 1 hj hm};
        end
        
%         hj.isTopLevelMenu
%       hj.getUIClassID
      if strcmp(hj.getUIClassID,'MenuUI')==1
          if hj.getMenuComponentCount>0
              for j2=1:double(hj.getMenuComponentCount)
                  drawnow
                  hj2 = hj.getMenuComponent(j2-1);
                  if strcmp(hj2.getUIClassID,'SeparatorUI')==0
                      lab2=char(hj2.getLabel);
                      %                     drawnow
                      hm2= findobj( hf, 'label',lab2);
                      ss(end+1,:)={lab2 2 hj2 hm2 };
                  end
              end
          end
      end
    end
end
% 'end'
% size(ss)
% ==============================================
%%   
% ===============================================




function radioshowhelp_context(e,e2,task)
hf=findobj(0,'tag','ant');
if strcmp(task,'enableTooltips')
  hm=findobj(hf,'tag','menu_showMenuTooltips');
  if strcmp(get(hm,'checked'),'off') %enable TT now
      set(hm,'checked','on');
      menubar_setTooltips(1);
  else                              %disable TT now
      set(hm,'checked','off');
      menubar_setTooltips(0);
  end
end
    

% % % Right.click "menu" for help--> not implemented
function menuclick_cb(e,e2,hm,hj)
hf=findobj(0,'tag','ant');
u=get(hf,'userdata');
% u.ismenuinterupted=1;
% disp('------------------------');
% e2.getButton;
% get(e2)
if double(e2.getButton)==1   %     'left'
    u.mousekey='left';
    if get(e2,'ShiftDown')==1 %'cmd'
        u.mousekey='cmd';
    end
elseif double(e2.getButton)==3%     'rightclick
    %     showfunctionhelp(e,e2,hm,hj);
    u.mousekey='right';
end
set(hf,'userdata',u);


return


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
function showfunctionhelp(h,e,hm,hj,isforce)

if exist('isforce')==0
    isforce=0;
end

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


if ~isempty(strfind(get(hm,'label'),'obj'))
    %    keyboard
end

settings=make_localantsettingsFile('getsettings');
% settings=antsettings;
hradiohelp=findobj(findobj(0,'tag','ant'),'tag','radioshowhelp');
if isforce==0
    if get(hradiohelp,'value')==0; return; end
end
% if settings.show_instant_help==0 ; return ; end

try
    try
        lab=char(hj.getLabel);
    catch
        lab=get(hm,'Label');
    end
    %% ===============================================
    lab2= [ '  ##m ' lab ' ' repmat(' ',[1 100]) ];
    msg=[get(hm,'userdata') ];
    if isempty(msg)
        msg=lab2;
    else
        msg=regexprep(msg,'<br>',char(10));
        msg=strsplit2(msg,char(10))';
        %msg=cellfun(@(a){['<html><p style="font-family:''Courier New''"> ' a]} ,msg );
        msg=cellfun(@(a){[' #ka ' a repmat(' ',[1 70])]} ,msg );
        msg=[lab2; msg ];
    end
   %uhelp(msg,1);
    %% ===============================================
    
    cb=get(hm,'callback');
    task=cb{2};
    showhelp=1;
    
    hlpfun=menubarCB([],[],task,  showhelp );
catch
    hlpfun='none';
%     msg={''};
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
        else
            
            msg2=msg;
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
    
    
%     %———————————————————————————————————————————————
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
        
        helpfig=uhelp(msg2,0,'position',[posant(1) posant(2)-height   posant(3)  height-.001]);
        set(helpfig,'numbertitle','off','name','HELP');
        global uhelp_properties
        if ~isempty(uhelp_properties)
            try;
                %ch=findobj(0,'tag','uhelp','-and','name','HELP');
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
        
        %         tic;
        %       helpfig=uhelp(msg2);
        %       disp(toc);
        
        %       if 1
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
        %       end
        drawnow;
        %         disp(toc);
        
        
        
        clear UHELP_RunOnce_Flag0002;
    end
    %              figure(335);
    %              figure(findobj(0,'tag','ant'));
    
end


% ==============================================
%%   cmd-help for function
% ===============================================

function showcmd(hlpfun,msg,ishyperlink)
% hlpfun='xbruker2nifti.m';
col='*[0 .5 0]';
if ~isempty(strfind(hlpfun,'none'))
  col='*[0.9294    0.6941    0.1255]';  
end
cprintf(col,['function: '  hlpfun   '\n']);
if exist('msg')==1
    disp(char(msg));
end
if exist('ishyperlink')==0
    ishyperlink=1;
end
if ishyperlink==1;
    disp(['#' ' [' hlpfun ']: <a href="matlab: help(''' hlpfun ''');">' 'help' '</a>' ...
        ',<a href="matlab: uhelp(''' hlpfun ''');">' 'uhelp' '</a>'  ...
        ',<a href="matlab: edit(''' hlpfun ''');">' 'edit' '</a>']);
end
%% ===============================================

function hlpfun=menubarCB(h,e,task,showhelpOnly)

hlpfun=[];
if exist('showhelpOnly')==0
    showhelpOnly=0;
end

%-------let mouse hover , otherwise block execution to let mouse-selectionType work
% if showhelpOnly==0
hf=findobj(0,'tag','ant');
u=get(hf,'userdata');
%     if isfield(u,'ismenuinterupted') && u.ismenuinterupted==1
%         disp('do nothing')
%         return
%     end
% end
% u

if isfield(u,'mousekey')==0
    u.mousekey='left';
    set(hf,'userdata',u);
end

if strcmp(u.mousekey,'cmd') && showhelpOnly==0
    isforce=1;
    showfunctionhelp([],[],h,1,isforce);
    return
end


% rand
% return

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
    if strcmp(u.mousekey,'right')
        %% ===============================================
        hlpfun='xbruker2nifti.m';
        showcmd(hlpfun);
        %% ===============================================
        return
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
    %% ==============================[cmd]===========
    if strcmp(u.mousekey,'right')
        hlpfun='xcoreg.m';
        showcmd(hlpfun);
        return
    end
    %% ===============================================
    
    statusMsg(1,' coregistering images');
    xcoreg(1);
    statusMsg(0);
    
    %________________________________________________
elseif strcmp(task,'registerexvivo')
    if showhelpOnly==1;   %% HELP-PARSER: we need the TARGET-FUNCTION here
        hlpfun='xregisterexvivo';
        return ;
    end
    %% ==============================[cmd]===========
    if strcmp(u.mousekey,'right')
        hlpfun='xregisterexvivo.m';
        showcmd(hlpfun);
        return
    end
    %% ===============================================
    statusMsg(1,' register exvivo to invivo images');
    xregisterexvivo(1);
    statusMsg(0);
    
    %________________________________________________
elseif strcmp(task,'registerCT')
    if showhelpOnly==1;   %% HELP-PARSER: we need the TARGET-FUNCTION here
        hlpfun='xregisterCT';
        return ;
    end
    %% ==============================[cmd]===========
    if strcmp(u.mousekey,'right')
        hlpfun='xregisterCT.m';
        showcmd(hlpfun);
        return
    end
    %% ===============================================
    statusMsg(1,' register CT image');
    xregisterCT(1);
    statusMsg(0);
    
    %________________________________________________
elseif strcmp(task,'registermanually')
    if showhelpOnly==1;   %% HELP-PARSER: we need the TARGET-FUNCTION here
        hlpfun='xcoregmanu';
        return ;
    end
    %% ==============================[cmd]===========
    if strcmp(u.mousekey,'right')
        hlpfun='xcoregmanu.m';
        showcmd(hlpfun);
        return
    end
    %% ===============================================
    statusMsg(1,' register images manually');
    xcoregmanu(1);
    statusMsg(0);
    
    %________________________________________________
elseif strcmp(task,'realignImages')
    if showhelpOnly==1;   %% HELP-PARSER: we need the TARGET-FUNCTION here
        hlpfun='xrealign';
        return ;
    end
    %% ==============================[cmd]===========
    if strcmp(u.mousekey,'right')
        hlpfun='xrealign.m';
        showcmd(hlpfun);
        return
    end
    %% ===============================================
    
    statusMsg(1,' realign Images');
    xrealign(1);
    statusMsg(0);
    %________________________________________________
elseif strcmp(task,'realignImagesMultimodal')
    if showhelpOnly==1;   %% HELP-PARSER: we need the TARGET-FUNCTION here
        hlpfun='xrealign_elastix';
        return ;
    end
    %% ==============================[cmd]===========
    if strcmp(u.mousekey,'right')
        hlpfun='xrealign_elastix.m';
        showcmd(hlpfun);
        return
    end
    %% ===============================================
    statusMsg(1,' realign Images');
    xrealign_elastix(1);
    statusMsg(0);
    
    %________________________________________________
elseif strcmp(task,'coregister2D')
    if showhelpOnly==1;   %% HELP-PARSER: we need the TARGET-FUNCTION here
        hlpfun='xregister2d';
        return ;
    end
    %% ==============================[cmd]===========
    if strcmp(u.mousekey,'right')
        hlpfun='xregister2d.m';
        showcmd(hlpfun);
        return
    end
    %% ===============================================
    statusMsg(1,' coregistering slices [2d]');
    xregister2d(1);
    statusMsg(0);
    
    %________________________________________________
elseif strcmp(task,'coregister2Dapply')
    if showhelpOnly==1;   %% HELP-PARSER: we need the TARGET-FUNCTION here
        hlpfun='xregister2dapply';
        return ;
    end
    %% ==============================[cmd]===========
    if strcmp(u.mousekey,'right')
        hlpfun='xregister2dapply.m';
        showcmd(hlpfun);
        return
    end
    %% ===============================================
    
    statusMsg(1,' apply 2d-registration to other imaged');
    xregister2dapply(1);
    statusMsg(0)
    
    %________________________________________________
elseif strcmp(task,'extractslice')
    if showhelpOnly==1;   %% HELP-PARSER: we need the TARGET-FUNCTION here
        hlpfun='xextractslice';
        return ;
    end
    %% ==============================[cmd]===========
    if strcmp(u.mousekey,'right')
        hlpfun='xextractslice.m';
        showcmd(hlpfun);
        return
    end
    %% ===============================================
    statusMsg(1,' extract slices [2d]');
    xextractslice(1);
    statusMsg(0);
    
    
    
    %________________________________________________
elseif strcmp(task,'xnewproject')
    if showhelpOnly==1;   %% HELP-PARSER: we need the TARGET-FUNCTION here
        hlpfun='xnewproject';
        return ;
    end
    %% ==============================[cmd]===========
    if strcmp(u.mousekey,'right')
        hlpfun='xnewproject.m';
        showcmd(hlpfun);
        return
    end
    %% ===============================================
    xnewproject;
    %________________________________________________
elseif strcmp(task,'copytemplates')
    if showhelpOnly==1;   %% HELP-PARSER: we need the TARGET-FUNCTION here
        hlpfun='xcreatetemplatefiles2';%{'depending'; '111'};
        return ;
    end
    %% ==============================[cmd]===========
    if strcmp(u.mousekey,'right')
        hlpfun='antcb(''copytemplates'')';
        showcmd(hlpfun,[ 'for help type: antcb(''copytemplates?'')'  ],0);
        return
    end
    %% ===============================================
    statusMsg(1,' copytemplates');
    antcb('copytemplates');
    statusMsg(0);
    
    
    
    %________________________________________________
elseif strcmp(task,'dataimport')
    if showhelpOnly==1;   %% HELP-PARSER: we need the TARGET-FUNCTION here
        hlpfun='ximport';
        return ;
    end
    %% ==============================[cmd]===========
    if strcmp(u.mousekey,'right')
        hlpfun='ximport.m';
        showcmd(hlpfun);
        return
    end
    %% ===============================================
    ximport(1);
    %________________________________________________
elseif strcmp(task,'dataimport2')
    if showhelpOnly==1;   %% HELP-PARSER: we need the TARGET-FUNCTION here
        hlpfun='ximportnii_headerrplace';
        return ;
    end
    %% ==============================[cmd]===========
    if strcmp(u.mousekey,'right')
        hlpfun='ximportnii_headerrplace.m';
        showcmd(hlpfun);
        return
    end
    %% ===============================================
    ximportnii_headerrplace(1);
    %________________________________________________
elseif strcmp(task,'importAnalyzmask')
    if showhelpOnly==1;   %% HELP-PARSER: we need the TARGET-FUNCTION here
        hlpfun='ximportAnalyzemask';
        return ;
    end
    %% ==============================[cmd]===========
    if strcmp(u.mousekey,'right')
        hlpfun='ximportAnalyzemask.m';
        showcmd(hlpfun);
        return
    end
    %% ===============================================
    ximportAnalyzemask(1);
    %________________________________________________
elseif strcmp(task,'dataimportdir2dir')
    if showhelpOnly==1;   %% HELP-PARSER: we need the TARGET-FUNCTION here
        hlpfun='ximportdir2dir';
        return ;
    end
    %% ==============================[cmd]===========
    if strcmp(u.mousekey,'right')
        hlpfun='ximportdir2dir.m';
        showcmd(hlpfun);
        return
    end
    %% ===============================================
    statusMsg(1,' dir-to-dir import');
    ximportdir2dir(1);
    statusMsg(0);
    %________________________________________________
elseif strcmp(task,'distributefilesx')
    if showhelpOnly==1;   %% HELP-PARSER: we need the TARGET-FUNCTION here
        hlpfun='xdistributefiles';
        return ;
    end
    %% ==============================[cmd]===========
    if strcmp(u.mousekey,'right')
        hlpfun='xdistributefiles.m';
        showcmd(hlpfun);
        return
    end
    %% ===============================================
    statusMsg(1,' distribute files');
    xdistributefiles(1);
    statusMsg(0);
    %________________________________________________
elseif strcmp(task,'renamefile_simple')
    if showhelpOnly==1;   %% HELP-PARSER: we need the TARGET-FUNCTION here
        hlpfun='xrename';
        return ;
    end
    %% ==============================[cmd]===========
    if strcmp(u.mousekey,'right')
        hlpfun='xrename.m';
        showcmd(hlpfun);
        return
    end
    %% ===============================================
    xrename(1);
    %________________________________________________
elseif strcmp(task,'renamefile')
    if showhelpOnly==1;   %% HELP-PARSER: we need the TARGET-FUNCTION here
        hlpfun='xrenamefile';
        return ;
    end
    %% ==============================[cmd]===========
    if strcmp(u.mousekey,'right')
        hlpfun='xrenamefile.m';
        showcmd(hlpfun);
        return
    end
    %% ===============================================
    xrenamefile(1);
    %________________________________________________
elseif strcmp(task,'renamefile2')
    if showhelpOnly==1;   %% HELP-PARSER: we need the TARGET-FUNCTION here
        hlpfun='xcopyrenameexpand';
        return ;
    end
    %% ==============================[cmd]===========
    if strcmp(u.mousekey,'right')
        hlpfun='xcopyrenameexpand.m';
        showcmd(hlpfun);
        return
    end
    %% ===============================================
    xcopyrenameexpand(1);
    
    %________________________________________________
elseif strcmp(task,'calc0')
    if showhelpOnly==1;   %% HELP-PARSER: we need the TARGET-FUNCTION here
        hlpfun='xcalc';
        return ;
    end
    %% ==============================[cmd]===========
    if strcmp(u.mousekey,'right')
        hlpfun='xcalc.m';
        showcmd(hlpfun);
        return
    end
    %% ===============================================
    xcalc(1);
    
    %________________________________________________
elseif strcmp(task,'manipulateheader')
    if showhelpOnly==1;   %% HELP-PARSER: we need the TARGET-FUNCTION here
        %         hlpfun='xheadman';
        hlpfun='manipulate/copy image header/resize image/set origin';
        %helpfun='bla';%sprintf('manipulate imag header/resize image/copy header/set origin');
        return ;
    end
    %% ==============================[cmd]===========
    if strcmp(u.mousekey,'right')
        hlpfun='xheadmanfiles.m';
        showcmd(hlpfun);
        return
    end
    %% ===============================================
    
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
    %% ==============================[cmd]===========
    if strcmp(u.mousekey,'right')
        hlpfun='xreplaceheader.m';
        showcmd(hlpfun);
        return
    end
    %% ===============================================
    xreplaceheader(1);
    
    %________________________________________________
elseif strcmp(task,'deletefiles')
    if showhelpOnly==1;   %% HELP-PARSER: we need the TARGET-FUNCTION here
        hlpfun='xdeletefiles';
        return ;
    end
    %% ==============================[cmd]===========
    if strcmp(u.mousekey,'right')
        hlpfun='xdeletefiles.m';
        showcmd(hlpfun);
        return
    end
    %% ===============================================
    xdeletefiles(1);
    %________________________________________________
    
elseif strcmp(task,'maskgenerate')
    if showhelpOnly==1;   %% HELP-PARSER: we need the TARGET-FUNCTION here
        hlpfun='xmaskgenerator';
        return ;
    end
    %% ==============================[cmd]===========
    if strcmp(u.mousekey,'right')
        hlpfun='xmaskgenerator.m';
        showcmd(hlpfun);
        return
    end
    %% ===============================================
    statusMsg(1,' Mask-Generator');
    xmaskgenerator(1);
    statusMsg(0);
    
    %________________________________________________
    
elseif strcmp(task,'maskgenerateFromExcelfile')
    if showhelpOnly==1;   %% HELP-PARSER: we need the TARGET-FUNCTION here
        hlpfun='xexcel2atlas';
        return ;
    end
    %% ==============================[cmd]===========
    if strcmp(u.mousekey,'right')
        hlpfun='xexcel2atlas.m';
        showcmd(hlpfun);
        return
    end
    %% ===============================================
    statusMsg(1,' generate mask from excelfile');
    xexcel2atlas(1);
    statusMsg(0);
    
elseif strcmp(task,'drawmask')
    if showhelpOnly==1;   %% HELP-PARSER: we need the TARGET-FUNCTION here
        hlpfun='xdraw';
        return ;
    end
    %% ==============================[cmd]===========
    if strcmp(u.mousekey,'right')
        hlpfun='xdraw.m';
        showcmd(hlpfun);
        return
    end
    %% ===============================================
    
    xdraw;
    %     statusMsg(1,' generate mask from excelfile');
    %     xexcel2atlas(1);
    %     statusMsg(0);
elseif strcmp(task,'segmenttube')
    if showhelpOnly==1;   %% HELP-PARSER: we need the TARGET-FUNCTION here
        hlpfun='xsegmenttube';
        return ;
    end
    %% ==============================[cmd]===========
    if strcmp(u.mousekey,'right')
        hlpfun='xsegmenttube.m';
        showcmd(hlpfun);
        return
    end
    %% ===============================================
    statusMsg(1,'segment tube');
    xsegmenttube;
    statusMsg(0);
    
elseif strcmp(task,'segmenttubeManu')
    if showhelpOnly==1;   %% HELP-PARSER: we need the TARGET-FUNCTION here
        hlpfun='xsegmenttubeManu';
        return ;
    end
    %% ==============================[cmd]===========
    if strcmp(u.mousekey,'right')
        hlpfun='xsegmenttubeManu.m';
        showcmd(hlpfun);
        return
    end
    %% ===============================================
    statusMsg(1,'segment tube manu');
    xsegmenttubeManu;
    statusMsg(0);
    
elseif strcmp(task,'splittubedata')
    if showhelpOnly==1;   %% HELP-PARSER: we need the TARGET-FUNCTION here
        hlpfun='xsplittubedata';
        return ;
    end
    %% ==============================[cmd]===========
    if strcmp(u.mousekey,'right')
        hlpfun='xsplittubedata.m';
        showcmd(hlpfun);
        return
    end
    %% ===============================================
    
    statusMsg(1,' split tube data');
    xsplittubedata;
    statusMsg(0);
    
    
    %________________________________________________
    
elseif strcmp(task,'xconvertdicom2nifti')
    if showhelpOnly==1;   %% HELP-PARSER: we need the TARGET-FUNCTION here
        hlpfun='xdicom2nifti';
        return ;
    end
    %% ==============================[cmd]===========
    if strcmp(u.mousekey,'right')
        hlpfun='xdicom2nifti.m';
        showcmd(hlpfun);
        return
    end
    %% ===============================================
    xdicom2nifti(1);
    
    
    %________________________________________________
    
elseif strcmp(task,'xmergedirectories')
    if showhelpOnly==1;   %% HELP-PARSER: we need the TARGET-FUNCTION here
        hlpfun='xmergedirs';
        return ;
    end
    %% ==============================[cmd]===========
    if strcmp(u.mousekey,'right')
        hlpfun='xmergedirs.m';
        showcmd(hlpfun);
        return
    end
    %% ===============================================
    xmergedirs(1);
    
    %________________________________________________
    
elseif strcmp(task,'export')
    if showhelpOnly==1;   %% HELP-PARSER: we need the TARGET-FUNCTION here
        hlpfun='xexport';
        return ;
    end
    %% ==============================[cmd]===========
    if strcmp(u.mousekey,'right')
        hlpfun='xexport.m';
        showcmd(hlpfun);
        return
    end
    %% ===============================================
    xexport(1);
    %________________________________________________
    
elseif strcmp(task,'export_fromanyfolder')
    if showhelpOnly==1;   %% HELP-PARSER: we need the TARGET-FUNCTION here
        hlpfun='exportfiles';
        return ;
    end
    %% ==============================[cmd]===========
    if strcmp(u.mousekey,'right')
        hlpfun='exportfiles.m';
        showcmd(hlpfun);
        return
    end
    %% ===============================================
    exportfiles(1);
    
    %________________________________________________
    
elseif strcmp(task,'quit')
    if showhelpOnly==1;   %% HELP-PARSER: we need the TARGET-FUNCTION here
        hlpfun='..this will quit the Application';
        return ;
    end
    %% ==============================[cmd]===========
    if strcmp(u.mousekey,'right')
        hlpfun='--none--';
        showcmd(hlpfun,['..this will quit the Application'],0);
        return
    end
    %% ===============================================
    
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
    %% ==============================[cmd]===========
    if strcmp(u.mousekey,'right')
        hlpfun='--none--';
        showcmd(hlpfun,['..this will open the study-folder'],0);
        return
    end
    %% ===============================================
    
    global an; if isempty(an); disp('no configfile loaded');return; end
    
    disp(['Studie''s config-Folder: '  fileparts(an.datpath) ]);
    %system(['explorer ' fileparts(an.datpath)  ]);
    explorer(fileparts(an.datpath) );
    
    %________________________________________________
elseif strcmp(task,'folderTemplate')
    if showhelpOnly==1;   %% HELP-PARSER: we need the TARGET-FUNCTION here
        hlpfun={'this function opens the study''s TEMPLATE-Folder  '};
        hlpfun{end+1,1}=['..containing the templates (Gm, WM,CSV, ALLEN-template, ALLEN-label-volume)'];
        hlpfun{end+1,1}=['..this folder with template-files is generated in the "warp"-routine of the 1st mouse '];
        return ;
    end
    %% ==============================[cmd]===========
    if strcmp(u.mousekey,'right')
        hlpfun='--none--';
        showcmd(hlpfun,['..this will open the study''s TEMPLATE-Folder'],0);
        return
    end
    %% ===============================================
    
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
    %% ==============================[cmd]===========
    if strcmp(u.mousekey,'right')
        hlpfun='xselect.m';
        showcmd(hlpfun);
        return
    end
    %% ===============================================
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
    %% ==============================[cmd]===========
    if strcmp(u.mousekey,'right')
        hlpfun='ante.m';
        showcmd(hlpfun);
        return
    end
    %% ===============================================
    
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
    %% ==============================[cmd]===========
    if strcmp(u.mousekey,'right')
        hlpfun='gui_overlay.m';
        showcmd(hlpfun);
        return
    end
    %% ===============================================
    gui_overlay;
    %________________________________________________
elseif strcmp(task,'overlayimageGui2')
    if showhelpOnly==1;   %% HELP-PARSER: we need the TARGET-FUNCTION here
        hlpfun='xoverlay';
        return ;
    end
    %% ==============================[cmd]===========
    if strcmp(u.mousekey,'right')
        hlpfun='xoverlay.m';
        showcmd(hlpfun);
        return
    end
    %% ===============================================
    xoverlay;
    %________________________________________________
elseif strcmp(task,'fastviewer')
    if showhelpOnly==1;   %% HELP-PARSER: we need the TARGET-FUNCTION here
        hlpfun='xfastview';
        return ;
    end
    
    xfastview;
    %________________________________________________
elseif strcmp(task,'xatlasviewer')
    if showhelpOnly==1;   %% HELP-PARSER: we need the TARGET-FUNCTION here
        hlpfun='atlasviewer';
        return ;
    end
    %% ==============================[cmd]===========
    if strcmp(u.mousekey,'right')
        hlpfun='atlasviewer.m';
        showcmd(hlpfun);
        return
    end
    %% ===============================================
    atlasviewer();
    
    %________________________________________________
elseif strcmp(task,'x3dvolume')
    if showhelpOnly==1;   %% HELP-PARSER: we need the TARGET-FUNCTION here
        hlpfun='xvol3d';
        return ;
    end
    %% ==============================[cmd]===========
    if strcmp(u.mousekey,'right')
        hlpfun='xvol3d.m';
        showcmd(hlpfun);
        return
    end
    %% ===============================================
    xvol3d();
    %________________________________________________
elseif strcmp(task,'call_show4d')
    if showhelpOnly==1;   %% HELP-PARSER: we need the TARGET-FUNCTION here
        hlpfun='show4d';
        return ;
    end
    %% ==============================[cmd]===========
    if strcmp(u.mousekey,'right')
        hlpfun='show4d.m';
        showcmd(hlpfun);
        return
    end
    %% ===============================================
    global an
    show4d( an.datpath);
    
    
    %________________________________________________
elseif strcmp(task,'call_xcheckreghtml')
    if showhelpOnly==1;   %% HELP-PARSER: we need the TARGET-FUNCTION here
        hlpfun='xcheckreghtml';
        return ;
    end
    %% ==============================[cmd]===========
    if strcmp(u.mousekey,'right')
        hlpfun='xcheckreghtml.m';
        showcmd(hlpfun);
        return
    end
    %% ===============================================
    statusMsg(1,'check-registration');
    xcheckreghtml();
    statusMsg(0);
    %________________________________________________
elseif strcmp(task,'call_xQAregistration')
    if showhelpOnly==1;   %% HELP-PARSER: we need the TARGET-FUNCTION here
        hlpfun='xQAregistration';
        return ;
    end
    %% ==============================[cmd]===========
    if strcmp(u.mousekey,'right')
        hlpfun='xQAregistration.m';
        showcmd(hlpfun);
        return
    end
    %% ===============================================
    statusMsg(1,'QA-registration');
    xQAregistration();
    statusMsg(0);
    
elseif strcmp(task,'makeANOpseudocolors')
    if showhelpOnly==1;   %% HELP-PARSER: we need the TARGET-FUNCTION here
        hlpfun={'-for older versions only (in newer versions this step is done automatically )'};
        hlpfun{end+1,1}=['create Anotation-file in pseudocolors for overlay only'];
        hlpfun{end+1,1}=['this file [ANOpcol.nii] is stored in the templates-folder'];
        return ;
    end
    
    %% ==============================[cmd]===========
    if strcmp(u.mousekey,'right')
        hlpfun='--none--';
        showcmd(hlpfun,['-[makeANOpseudocolors]...for older versions only (in newer versions this step is done automatically )'],0);
        return
    end
    %% ===============================================
    
    
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
    %% ==============================[cmd]===========
    if strcmp(u.mousekey,'right')
        hlpfun='xstat_2sampleTtest.m';
        showcmd(hlpfun);
        return
    end
    %% ===============================================
    xstat_2sampleTtest(1);
    
elseif strcmp(task,'stat_anatomlabels')
    if showhelpOnly==1;   %% HELP-PARSER: we need the TARGET-FUNCTION here
        hlpfun='xstat_anatomlabels';
        return ;
    end
    %% ==============================[cmd]===========
    if strcmp(u.mousekey,'right')
        hlpfun='xstat_anatomlabels.m';
        showcmd(hlpfun);
        return
    end
    %% ===============================================
    xstat_anatomlabels(1);
    
elseif strcmp(task,'xstatlabels0')
    if showhelpOnly==1;   %% HELP-PARSER: we need the TARGET-FUNCTION here
        hlpfun='xstatlabels';
        return ;
    end
    %% ==============================[cmd]===========
    if strcmp(u.mousekey,'right')
        hlpfun='xstatlabels.m';
        showcmd(hlpfun);
        return
    end
    %% ===============================================
    xstatlabels;
   
    
elseif strcmp(task,'newgroupassignment')
    if showhelpOnly==1;   %% HELP-PARSER: we need the TARGET-FUNCTION here
        hlpfun='xnewgroupassignment';
        return ;
    end
    %% ==============================[cmd]===========
    if strcmp(u.mousekey,'right')
        hlpfun='xnewgroupassignment.m';
        showcmd(hlpfun);
        return
    end
    %% ===============================================
    xnewgroupassignment();
    
    
elseif strcmp(task,'getparamterByMask')
    if showhelpOnly==1;   %% HELP-PARSER: we need the TARGET-FUNCTION here
        hlpfun='xgetparameter';
        return ;
    end
    %% ==============================[cmd]===========
    if strcmp(u.mousekey,'right')
        hlpfun='xgetparameter.m';
        showcmd(hlpfun);
        return
    end
    %% ===============================================
    xgetparameter();
    
    
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
    %% ==============================[cmd]===========
    if strcmp(u.mousekey,'right')
        hlpfun='dtistat.m';
        showcmd(hlpfun);
        return
    end
    %% ===============================================
    dtistat;
    
elseif strcmp(task,'dti_prep_mrtrix')
    if showhelpOnly==1;   %% HELP-PARSER: we need the TARGET-FUNCTION here
        hlpfun='DTIprep';
        return ;
    end
    %% ==============================[cmd]===========
    if strcmp(u.mousekey,'right')
        hlpfun='DTIprep.m';
        showcmd(hlpfun);
        return
    end
    %% ===============================================
    DTIprep;
    %________________________________________________
elseif strcmp(task,'flattenBrukerdatapath')
    if showhelpOnly==1;   %% HELP-PARSER: we need the TARGET-FUNCTION here
        hlpfun='xbrukerflattdatastructure';
        return ;
    end
    %% ==============================[cmd]===========
    if strcmp(u.mousekey,'right')
        hlpfun='xbrukerflattdatastructure.m';
        showcmd(hlpfun);
        return
    end
    %% ===============================================
    
    xbrukerflattdatastructure(1);
    %________________________________________________
elseif strcmp(task,'generateJacobian')
    if showhelpOnly==1;   %% HELP-PARSER: we need the TARGET-FUNCTION here
        hlpfun='xgenerateJacobian';
        return ;
    end
    %% ==============================[cmd]===========
    if strcmp(u.mousekey,'right')
        hlpfun='xgenerateJacobian.m';
        showcmd(hlpfun);
        return
    end
    %% ===============================================
    statusMsg(1,' generate Jacobian matrizes');
    xgenerateJacobian(1);
    statusMsg(0);
    %________________________________________________
    
    %________________________________________________
elseif strcmp(task,'scripts_call')
    if showhelpOnly==1;   %% HELP-PARSER: we need the TARGET-FUNCTION here
        hlpfun='scripts_collection';
        return ;
    end
    %% ==============================[cmd]===========
    if strcmp(u.mousekey,'right')
        hlpfun='scripts_collection.m';
        showcmd(hlpfun);
        return
    end
    %% ===============================================
    statusMsg(1,'scripts colleciton');
    scripts_collection();
    statusMsg(0);
    
elseif strcmp(task,'getlesionvolume')
    if showhelpOnly==1;   %% HELP-PARSER: we need the TARGET-FUNCTION here
        hlpfun='xgetlesionvolume';
        return ;
    end
    %% ==============================[cmd]===========
    if strcmp(u.mousekey,'right')
        hlpfun='xgetlesionvolume.m';
        showcmd(hlpfun);
        return
    end
    %% ===============================================
    
    statusMsg(1,' get corrected lesion volume');
    xgetlesionvolume;
    statusMsg(0);
    %________________________________________________
elseif strcmp(task,'makeMaps')
    if showhelpOnly==1;   %% HELP-PARSER: we need the TARGET-FUNCTION here
        hlpfun='xcreateMaps';
        return ;
    end
    %% ==============================[cmd]===========
    if strcmp(u.mousekey,'right')
        hlpfun='xcreateMaps.m';
        showcmd(hlpfun);
        return
    end
    %% ===============================================
    
    statusMsg(1,' create Maps');
    xcreateMaps;
    statusMsg(0);
    %________________________________________________
elseif strcmp(task,'convert2SNRimage')
    if showhelpOnly==1;   %% HELP-PARSER: we need the TARGET-FUNCTION here
        hlpfun='xcalcSNRimage';
        return ;
    end
    %% ==============================[cmd]===========
    if strcmp(u.mousekey,'right')
        hlpfun='xcalcSNRimage.m';
        showcmd(hlpfun);
        return
    end
    %% ===============================================
    
    statusMsg(1,' convert to SNR image');
    xcalcSNRimage;
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
    
    %% ==============================[cmd]===========
    if strcmp(u.mousekey,'right')
        hlpfun='--none--';
        showcmd(hlpfun,[' open/create a "note-file" associated with the study'],0);
        return
    end
    %% ===============================================
    
    
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
    %% ==============================[cmd]===========
    if strcmp(u.mousekey,'right')
        hlpfun='--none--';
        showcmd(hlpfun,[' opens docs-folders with documentations (directory: ~/antx/mritools/ant/docs/)'],0);
        return
    end
    %% ===============================================
    
    explorer(fullfile(fileparts(which('ant.m')),'docs'));
    
    
    %________________________________________________
elseif strcmp(task,'dispmainfun')
    if showhelpOnly==1;   %% HELP-PARSER: we need the TARGET-FUNCTION here
        hlpfun='showfun';
        return ;
    end
    %% ==============================[cmd]===========
    if strcmp(u.mousekey,'right')
        hlpfun='showfun.m';
        showcmd(hlpfun);
        return
    end
    %% ===============================================
    antcb('status',1,'show functions')
    showfun;
    antcb('status',0,'')
    %________________________________________________
elseif strcmp(task,'keyboard')
    %     if showhelpOnly==1;   %% HELP-PARSER: we need the TARGET-FUNCTION here
    hlpfun='antkeys';
    
    %% ==============================[cmd]===========
    if strcmp(u.mousekey,'right')
        hlpfun='--none--';
        showcmd(hlpfun,' show keyboard-shortcuts for ANTx-GUI',0);
        return
    end
    %% ===============================================
    
    uhelp('antkeys');
    %     end
    %________________________________________________
elseif strcmp(task,'version')
    if showhelpOnly==1;   %% HELP-PARSER: we need the TARGET-FUNCTION here
        hlpfun='antver';
        return ;
    end
    %% ==============================[cmd]===========
    if strcmp(u.mousekey,'right')
        hlpfun='antver.m';
        showcmd(hlpfun);
        return
    end
    %% ===============================================
    antver;
    %________________________________________________
elseif strcmp(task,'check_ELASTIX_installation')
    if showhelpOnly==1;   %% HELP-PARSER: we need the TARGET-FUNCTION here
        hlpfun='elastix_checkinstallation';
        return ;
    end
    %% ==============================[cmd]===========
    if strcmp(u.mousekey,'right')
        hlpfun='elastix_checkinstallation.m';
        showcmd(hlpfun);
        return
    end
    %% ===============================================
    
    elastix_checkinstallation;
    %________________________________________________
elseif strcmp(task,'check_pathnames')
    if showhelpOnly==1;   %% HELP-PARSER: we need the TARGET-FUNCTION here
        hlpfun='checkpath';
        return ;
    end
    %% ==============================[cmd]===========
    if strcmp(u.mousekey,'right')
        hlpfun='checkpath.m';
        showcmd(hlpfun);
        return
    end
    %% ===============================================
    
    checkpath;
    
    %% ==============================[cmd]===========
elseif strcmp(task,'call_cwcol')
    if showhelpOnly==1;   %% HELP-PARSER: we need the TARGET-FUNCTION here
        hlpfun='no info';
        return ;
    end
    if strcmp(u.mousekey,'right')
        hlpfun='no info';
        showcmd(hlpfun);
        return
    end
    antcb('cwcol');
    %% ===============================================
elseif strcmp(task,'call_cwtitle')
    if showhelpOnly==1;   %% HELP-PARSER: we need the TARGET-FUNCTION here
        hlpfun='no info';
        return ;
    end
    if strcmp(u.mousekey,'right')
        hlpfun='no info';
        showcmd(hlpfun);
        return
    end
    antcb('cwname');
     %% ===============================================
elseif strcmp(task,'call_WinServerID')
    if showhelpOnly==1;   %% HELP-PARSER: we need the TARGET-FUNCTION here
        hlpfun='sessid.m';
        return ;
    end
    if strcmp(u.mousekey,'right')
        hlpfun='sessid.m';
        showcmd(hlpfun);
        return
    end
    sessid; 
    
 elseif strcmp(task,'call_changeWinServer')
    if showhelpOnly==1;   %% HELP-PARSER: we need the TARGET-FUNCTION here
        hlpfun='sessid.m';
        return ;
    end
    if strcmp(u.mousekey,'right')
        hlpfun='sessid.m';
        showcmd(hlpfun);
        return
    end
    gotoID= input('Enter Winserver-ID to connect to: ','s');
    sessid(str2num(gotoID));    
    
    %________________________________________________
elseif strcmp(task,'antsettings')
    if showhelpOnly==1;   %% HELP-PARSER: we need the TARGET-FUNCTION here
        hlpfun='antsettings';
        return ;
    end
    %% ==============================[cmd]===========
    if strcmp(u.mousekey,'right')
        hlpfun='--none--';
        showcmd(hlpfun,'- change some settings ',0);
        return
    end
    %% ===============================================
    
    edit antsettings
    
elseif strcmp(task,'localantsettings')
    if showhelpOnly==1;   %% HELP-PARSER: we need the TARGET-FUNCTION here
        hlpfun='make_localantsettingsFile';
        return ;
    end
    %% ==============================[cmd]===========
    if strcmp(u.mousekey,'right')
        hlpfun='make_localantsettingsFile.m';
        showcmd(hlpfun);
        return
    end
    %% ===============================================
    
    make_localantsettingsFile() ;
elseif strcmp(task,'localantsettingsShowPath')
    if showhelpOnly==1;   %% HELP-PARSER: we need the TARGET-FUNCTION here
        hlpfun='make_localantsettingsFile';
        return ;
    end
    %% ==============================[cmd]===========
    if strcmp(u.mousekey,'right')
        hlpfun='make_localantsettingsFile.m';
        showcmd(hlpfun);
        return
    end
    %% ===============================================
    make_localantsettingsFile('showpath')  ;  
    
    
elseif strcmp(task,'localantsettingsDelete')
    if showhelpOnly==1;   %% HELP-PARSER: we need the TARGET-FUNCTION here
        hlpfun='make_localantsettingsFile';
        return ;
    end
    %% ==============================[cmd]===========
    if strcmp(u.mousekey,'right')
        hlpfun='make_localantsettingsFile.m';
        showcmd(hlpfun);
        return
    end
    %% ===============================================
    make_localantsettingsFile('delete')  ;     
    
    
    
    
    elseif strcmp(task,'menu_showMenuTooltips_cb')
    if showhelpOnly==1;   %% HELP-PARSER: we need the TARGET-FUNCTION here
        hlpfun='blbla';
        return ;
    end
    %% ==============================[cmd]===========
    if strcmp(u.mousekey,'right')
        hlpfun='--none--';
        showcmd(hlpfun,'',0);
        return
    end
    %% ===============================================   
    radioshowhelp_context([],[],'enableTooltips');
    
    %________________________________________________
elseif strcmp(task,'contact')
    if showhelpOnly==1;   %% HELP-PARSER: we need the TARGET-FUNCTION here
        hlpfun='antintro';
        return ;
    end
    %% ==============================[cmd]===========
    if strcmp(u.mousekey,'right')
        hlpfun='--none--';
        showcmd(hlpfun,'- show contact information ',0);
        return
    end
    %% ===============================================
    
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
elseif strcmp(task,'visitGITHUB') || strcmp(task,'visitGITHUBpages')
    if showhelpOnly==1;   %% HELP-PARSER: we need the TARGET-FUNCTION here
        if strcmp(task,'visitGITHUB')
            hlpfun={' ..visit ANTx2 Repositiory (GITHUB)'
                'https://github.com/ChariteExpMri/antx2'
                ''};
        else
            hlpfun={' ..visit ANTx2 Tutorials (GITHUB-pages)'
                'https://chariteexpmri.github.io/antxdoc/'
                'This webside contains tutorials (PDF-files).'};
        end
        return ;
    end
    %% ==============================[cmd]===========
    if strcmp(u.mousekey,'right')
        hlpfun='--none--';
        showcmd(hlpfun,' ..visit ANTx2 Repositiory (GITHUB)',0);
        return
    end
    %% ===============================================
    
    if strcmp(task,'visitGITHUB')
        statusMsg(1,' visiting GITHUB');
        github='https://github.com/ChariteExpMri/antx2';
    else
        statusMsg(1,' visiting Tutorials');
        github='https://chariteexpmri.github.io/antxdoc';
    end
    
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
    
    %% ==============================[cmd]===========
    if strcmp(u.mousekey,'right')
        hlpfun='--none--';
        showcmd(hlpfun,' get templates from googledrive',0);
        return
    end
    %% ===============================================
    
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
    
elseif strcmp(task,'donwloadTemplates')
    
    if showhelpOnly==1;   %% HELP-PARSER: we need the TARGET-FUNCTION here
        hlpfun='xdownloadtemplate';
        return ;
    end
    %% ==============================[cmd]===========
    if strcmp(u.mousekey,'right')
        hlpfun='xdownloadtemplate.m';
        showcmd(hlpfun);
        return
    end
    %% ===============================================
    antcb('status',1,'downloading Templates');
    xdownloadtemplate;
    antcb('status',0,'')
    
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
    %% ==============================[cmd]===========
    if strcmp(u.mousekey,'right')
        hlpfun='installfromgithub.m';
        showcmd(hlpfun);
        return
    end
    %% ===============================================
    installfromgithub;
    
end

% hf=findobj(0,'tag','ant');
% u=get(hf,'userdata');     u.ismenuinterupted=0;     set(hf,'userdata',u);
% drawnow;


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


function openStudyHistory(e,e2)
anthistory('select');

function openCFM(e,e2,dirmode)
if strcmp(dirmode,'all')
    cfm(2,'ant','all');
else
    cfm(2,'ant','sel');
end


function loadproj_context(e,e2,task)
if strcmp(task,'reload')
    antcb('reload');
elseif strcmp(task,'edit')
    global an
    if isfield(an,'configfile')==0
        disp('no project file loaded');
        return
    end
    [pa fi ext]=fileparts(an.configfile);
    if isempty(pa); pa=pwd; end
    configfile=fullfile(pa,[fi '.m']);
    if exist(configfile)
        edit(configfile)
    end
elseif strcmp(task,'loadcommand')
    global an
    if isfield(an,'configfile')==0
        disp('no project file loaded');
        return
    end
    [pa fi ext]=fileparts(an.configfile);
    if isempty(pa); pa=pwd; end
    configfile=fullfile(pa,[fi '.m']);
    if exist(configfile)
        disp('% LOAD THIS PROJECT:')
        disp(['antcb(''load'','''  configfile '''  )']);
    end
end

% ==============================================
%%   update tbx via button, no user-questions
% ===============================================
function updateTBX_context(e,e2,task)
cname=getenv('COMPUTERNAME');
msg_myMachine='The source machine can''t be updated from Github';
if strcmp(task,'help')
    help updateantx
elseif strcmp(task,'info')
    if strcmp(cname,'STEFANKOCH06C0')==1
        disp(msg_myMachine);  %my computer---not allowed
    else
        updateantx('info');
    end
elseif strcmp(task,'forceUpdate')
    if strcmp(cname,'STEFANKOCH06C0')==1
        disp(msg_myMachine);  %my computer---not allowed
    else
        updateantx(3);
    end
elseif strcmp(task,'filechanges_local')
    if strcmp(cname,'STEFANKOCH06C0')==1
        disp(msg_myMachine);  %my computer---not allowed
    else
        updateantx('changes');
    end
end


function updateTBXnow(e,e2)
cname=getenv('COMPUTERNAME');
if strcmp(cname,'STEFANKOCH06C0')==1
    disp('The source machine can''t be updated from Github');  %my computer---not allowed
else
    thispa=pwd;
    go2pa =fileparts(which('antlink.m'));
    cd(go2pa);
    try
        w=git('log -p -1');                    % obtain DATE OF local repo
        w=strsplit(w,char(10))';
        date1=w(min(regexpi2(w,'Date: ')));
    catch
        cd(thispa);
    end
    
    updateantx(2);                              % UPDAETE
    
    try
        w=git('log -p -1');                  % obtain DATE OF local repo
        w=strsplit(w,char(10))';
        date2=w(min(regexpi2(w,'Date: ')));
    catch
        cd(thispa);
    end
    
    cd(thispa);
    if strcmp(date1,date2)~=1   %COMPARE date1 & date2 ...if changes--->reload tbx
        q=updateantx('changes');
        if ~isempty(find(strcmp(q,'ant.m')));
            disp(' ant.main gui was modified: reloading GUI');
            antcb('reload');
        end
    end
end


function ant_cfm_ontext(e,e2,dispmode,sel, form)

% check if project is loaded
mdirs=antcb('getsubjects');
if isempty(mdirs)
    return
end

if strcmp(sel,'all')
    mdirs=antcb('getallsubjects');
else
    mdirs=antcb('getsubjects');
end

if strcmp(dispmode,'win')
    [w]=dispfiles('dir',mdirs,'show',0,'form',form);
    uhelp(w.m2,1,'name','CFM');
else
    [w]=dispfiles('dir',mdirs,'show',1,'form',form);
    
end
disp('   <a href="matlab: help dispfiles;">help dispfiles</a>')
%
% keyboard
%
% if strcmp(dispmode,'win')
%     if strcmp(sel,'all')
%         [w]=dispfiles('show',0,'form',form);
%     else
%         mdirs=antcb('getsubjects');
%         [w]=dispfiles('dir',mdirs,'show',0,'form',form);
%     end
%     uhelp(w.m2,1,'name','CFM');
% else
%     if animalmode==1
%         dispfiles('show',1);
%     elseif animalmode==2
%         mdirs=antcb('getsubjects');
%         dispfiles('dir',mdirs);
%
%     end
%     %disp('...for more info: help dispfiles');
%     disp('   <a href="matlab: help dispfiles;">help dispfiles</a>')
% end
%

