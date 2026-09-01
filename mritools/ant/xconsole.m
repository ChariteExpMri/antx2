% function xconsole(varargin)
% XCONSOLE MATLAB CONSOLE WINDOW
% Lightweight alternative MATLAB console that can be used even while the main Command Window is busy.
% Enables execution of commands, workspace interaction, plotting, and logging during blocked MATLAB sessions.
%
% FEATURES
% - Execute commands during busy MATLAB state
% - Access and modify base workspace variables or use isolated evaluation
% - Upper panel: formatted output (HTML, hyperlinks supported)
% - Lower panel: command input (single-line or multi-line mode)
% - Command history navigation using up/down arrow keys
%   (initial history imported from Command Window)
% - Splitter bar to resize input/output panels
%
% CONTEXT MENU
% - 'clear screen'              Clear console output
% - 'import CMD-window'         Import Command Window text (no hyperlink support)
% - 'diary (recording) on'      Start diary logging (select file via GUI, keeps hyperlinks)
% - 'diary (recording) off'     Stop diary recording
% - 'load diary to console'     Load diary file into console (manual selection)
% - 'reload diary to console'   Reload last diary automatically (shortcut: Alt+D)
%
% SPECIAL COMMAND SYNTAX
% xconsole;                     Open console window
% xconsole('t','text')         Display text (same as xconsole('','text'))
% xconsole('c','command')      Execute MATLAB command (e.g., 'ver', 'dir')
% xconsole('cls')              Clear console output
% xconsole('web')              Open default web page in console
% xconsole('web',url)          Open specific URL in console
% show_cmap()                  Display colormap in console
%
% SHORTCUTS
% Alt + / Alt -               Increase / decrease font size
% Up / Down arrows            Navigate command history
% Alt + D                     Reload diary automatically
%
% %EXAMPLE: DISPLAY IMAGES
% pax = fileparts(which('ngc6543a.jpg'));
% imgs = spm_select('FPList',pax,'.*.jpg|.*.tif'); imgs = cellstr(imgs);
% xconsole('','<b>Images</b>');
% for i = 1:numel(imgs)
%     xconsole('img',imgs{i});
% end
%
% %EXAMPLE: DISPLAY FILE HYPERLINKS (NIFTI / DIRECTORY)
% pax = 'H:\Data\Example';
% fis = spm_select('FPList',pax,'.*.nii'); fis = cellstr(fis);
% fis = fis(1:min(numel(fis),10));
% xconsole('','<b>FILES</b>');
% for i = 1:numel(fis)
%     xconsole('c',['showinfo2(''file:'',''' fis{i} ''')']);
% end






function xconsole(varargin)
warning off;


if nargin>0
    
    if isempty(findobj(0,'tag','xconsole'))
        xconsole();
    end
    
    if isstr(varargin{1}) && strcmp(varargin{1},'cmap')
        show_cmap();
        return
    end
    
    if isstr(varargin{1}) && strcmp(varargin{1},'blank')
        blankscreen();
        return
    end
    if isstr(varargin{1}) && strcmp(varargin{1},'cls')
        defaultoutput_refresh();
        return
    end
     
     if isstr(varargin{1}) && strcmp(varargin{1},'help')
         append(help('xconsole.m')); scrollBottom();
        return
     end
    
    if isstr(varargin{1}) && strcmp(varargin{1},'web')
       webside=[] ;
        if nargin>1
            webside=varargin{2};
        end
        show_web(webside);
        return
    end
    if isstr(varargin{1}) && strcmp(varargin{1},'img')
       img=[] ;
        if nargin>1
            img=varargin{2};
        end
        show_img(img);
        return
    end
    %% update string
    if isstr(varargin{1}) && (isempty(varargin{1}) || strcmp(varargin{1},'t') )  && isstr(varargin{2})
        append(varargin{2});
        scrollBottom();
        return
    end
    % run comand
    if isstr(varargin{1}) && strcmp(varargin{1},'c') && isstr(varargin{2})
        runCmd([],[],varargin{2});
        scrollBottom();
        return
    end

    
    
    %% ===============================================
    
  return  
end

% cf;clc
warning off;


u.fs=20;
u.mi=0; %multiinstances


if  u.mi==0
    delete(findobj(0,'tag','xconsole'));
end

% ================= FIGURE =================
f = figure('Name','Xconsole',...
    'NumberTitle','off',...
    'Position',[300 300 820 520],'color','k',...
    'Tag','xconsole','menubar','none');
set(f,'KeyPressFcn',@key_fig)
set(f,'CloseRequestFcn',[]);
% ================= OUTPUT =================
% out = uicontrol('Style','listbox',...
%     'Units','pixels',...
%     'Position',[0 35 820 485],...
%     'BackgroundColor','k',...
%     'ForegroundColor',[0.7 1 0.7],...
%     'FontName','Consolas',...
%     'FontSize',11,...
%     'Max',2,...
%     'Tag','ho');
% set(out,'KeyPressFcn',@key_fig)

% ================= OUTPUT =================
out = uicontrol('Style','edit',...
    'Units','pixels',...
    'Position',[0 35 820 485],...
    'BackgroundColor','k',...
    'ForegroundColor',[0.7 1 0.7],...
    'FontName','Consolas',...
    'FontSize',11,...
    'HorizontalAlignment','left',...
    'Max',2,...
    'Tag','ho');
set(out,'KeyPressFcn',@key_fig)


jScrollPane = findjobj(out);
jViewPort = jScrollPane.getViewport;
jEditbox = jViewPort.getComponent(0);
jEditbox.setEditorKit(javax.swing.text.html.HTMLEditorKit);

import javax.swing.*
jEditbox.setContentType('text/html');
kit = javax.swing.text.html.HTMLEditorKit;

 sheet = kit.getStyleSheet();
sheet.addRule("a { color: #4DA6FF; }");

doc = kit.createDefaultDocument;
jEditbox.setEditorKit(kit);
jEditbox.setDocument(doc);
jEditbox.setText('');
%     '<html>' ...
%     'link: <a href="http://undocumentedmatlab.com">UndocumentedMatlab.com</a>' ...
%     '</html>']);
jEditbox.setEditable(false);
jEditbox.setOpaque(false);

 set(jEditbox,'HyperlinkUpdateCallback',@linkCallbackFcn);
 
%  z0=['<html><body style="font-size:30pt; font-family:consolas;">' ...
%    '<pre>' 'link: <a href="http://undocumentedmatlab.com">click</a>' ...
%     ]
%  jEditbox.setText('start_console999');

u.appendnum=0;

% % ================= INPUbefore prompt =================
bp = uicontrol('Style','pushbutton',...
    'Units','pixels',...
    'Position',[0 0 20 35],...
    'HorizontalAlignment','left',...
    'BackgroundColor',[0.1 0.1 0.1],...
    'ForegroundColor','w',...
    'FontName','Consolas',...
    'FontSize',11,...
    'string','>>','enable','on','tag','prompt');
set(bp,'units','norm')
% set(hj, 'FocusGainedCallback',@per)

% ================= INPUT =================
inp = uicontrol('Style','edit',...
    'Units','pixels',...
    'Position',[19 0 820 35],...
    'HorizontalAlignment','left',...
    'BackgroundColor',[0.1 0.1 0.1],...
    'ForegroundColor','w',...
    'FontName','Consolas',...
    'FontSize',11,...
    'Callback',@runCmd_base,...
    'KeyPressFcn',@keyHandler,...
     'Max',1,...
    'Tag','hi');
% set(inp,'ButtonDownFcn',@clear_console)
% jScroll = findjobj(inp);
% jEdit = jScroll.getViewport.getView;   
% hj = handle(jScroll,'CallbackProperties');

% hf=addResizebutton(f,inp,'mode','U','listboxResize',0,'moo',0);
%% ===============================================

hb=uicontrol('style','radio','units','norm','string','workspace','tag','space');
set(hb,'position',[0.90427 0.033 0.09 0.02],'value',1,...
        'BackgroundColor',[0.1 0.1 0.1],...
    'ForegroundColor','w');

hm=uicontrol('style','radio','units','norm','string','multiLine','tag','multiline');
set(hm,'position',[0.90427 0.009808 0.09 0.02],'value',0,...
        'BackgroundColor',[0.1 0.1 0.1],...
    'ForegroundColor','w', 'Callback',@rb_multiline);

%% ===============================================
% set(hj,...
%     'FocusGainedCallback',@per,...
%     'FocusLostCallback',@per,...
%     'MousePressedCallback',@per);

u.placeholder = 1;
u.consoleStr='consoleInput<enter>';
u.consoleStr='';
set(inp,'String',u.consoleStr);
set(inp,'ForegroundColor',[0.6 0.6 0.6]);   % gray

% ================= CONTEXT MENU (COPY ONLY) =================
cm = uicontextmenu;
uimenu(cm,'Label','clear screen','Callback',{@contextmenu1,'cls'});
uimenu(cm,'Label','import CMD-window','Callback',{@contextmenu1,'importCMD'},'separator','on');
uimenu(cm,'Label','diary (recoding) on ', 'Callback',{@contextmenu1,'diary_on'},'separator','on');
uimenu(cm,'Label','diary (recoding) off', 'Callback',{@contextmenu1,'diary_off'},'separator','off');
uimenu(cm,'Label','load diary to console', 'Callback',{@contextmenu1,'readDiary'},'separator','on')
uimenu(cm,'Label','reload diary to console', 'Callback',{@contextmenu1,'readDiary','reload'});
uimenu(cm,'Label','','separator','on')
uimenu(cm,'Label','<html><b><font color="red">close this GUI', 'Callback',{@contextmenu1,'closefig'},'separator','on')

set(out,'UIContextMenu',cm);


% ================= STATE =================
history = {''};
histIdx = 0;

set(gcf,'userdata',u);




u.history=history;
u.histIdx=histIdx;
set(gcf,'userdata',u);

% jEditbox.setText('start_console999');
% append('Matlab Console');
% importCmdHistory();


% append( '  <a href="https://github.com/ChariteExpMri/antx2 ">ANTx-GitHub</a>');




set(inp,'units','normalized');
set(out,'units','normalized');
drawnow;
set(gcf,'units','normalized');


defaultoutput();

% addResizebutton(f,inp,'mode','U','listboxResize',1);
% addVerticalSplitter(inp,out)
% addVerticalSplitter
addVerticalSplitter(gcf, out  , {inp  bp } )
% addResizebutton(f,inp,'mode','U','listboxResize',0,'moo',0);
% hf=addResizebutton(f,out,'mode','D','listboxResize',0,'moo',0);
%  hf=addResizebutton(f,inp,'mode','U','listboxResize',0,'moo',0);

hr=findobj(gcf,'tag','addVerticalSplitter_resizebut');
set(hr,'units','norm');


set(gcf,'SizeChangedFcn',@resizefig);
 uicontrol(findobj(0, 'tag', 'hi'))
% ==========================================================
% EXECUTION
% ==========================================================

function show_img(img)

if ~exist('img')==1 || isempty(img)
    img = which('ngc6543a.jpg');
end
txt = sprintf([  '<img src="file:///%s">' ],  strrep(img,'\','/'));
 append(txt,['file: ' img ]);

function show_web(webside)
%% ===============================================

p = uipanel(gcf, 'Title','-','FontSize',12,...
             'BackgroundColor','white','units','norm',...
             'Position',[0 0 1 1], 'tag','web_panel');

         if exist('webside')==1 && ~isempty(webside)
             displayWebPage(s, p);
         else
             displayWebPage('http://google.com', p);
         end


c = uicontrol('Parent',gcf,'String','','units','norm',...
              'Position',[0.0004902 0.0048193 0.073529 0.040161],...
                  'tag','web_back','backgroundcolor','W');
set(c,'position',[0.15 .97  1 0.03]);

c = uicontrol('Parent',gcf,'String','<html><b>CLOSE','units','norm',...
              'Position',[0.0004902 0.0048193 0.073529 0.040161],...
                  'tag','web_exit','backgroundcolor','W',...
                  'callback',  ['delete(findobj(gcf,''tag'',''web_panel''));delete(findobj(gcf,''tag'',''web_exit''));' ...
                 'delete(findobj(gcf,''tag'',''web_back''));' ]    );
   set(c,'position',[0 .97  0.15 0.03]);
%% ===============================================
          


function resizefig(e,e2)
% rand(1)
% 
hr=findobj(gcf,'tag','addVerticalSplitter_resizebut');
unit=get(hr,'units');
po=get(hr,'position');
set(hr,'units','pixels');
po2=get(hr,'position');
posfig_pix=po2;
%n:  0.3553    0.0654    0.3333    0.0100
%p:   292.3333   35.0000  273.3333    5.2000
set(hr,'position',[ po2(1:3) 5.2  ]);
set(hr,'units',unit);

%% ===============================================
% if 1
hr=findobj(gcf,'tag','prompt');
unit=get(hr,'units');
po=get(hr,'position');
set(hr,'units','pixels');
po2=get(hr,'position');
%n:  -0.0012   -0.0019    0.0244    0.0673
%p:    0     0    20    35
sep=20;
set(hr,'position',[ po2(1:2) sep po2(4) ]);
set(hr,'units',unit);

hr=findobj(gcf,'tag','hi');
unit=get(hr,'units');
po=get(hr,'position');
set(hr,'units','pixels');
po2=get(hr,'position');
%n:  0.0220   -0.0019    1.0000    0.0673
%p:   19     0   820    35
sep=20;
set(hr,'position',[ sep po2(2) po2(3:4) ]);
set(hr,'units',unit);
% end
% ==============================================
unit=get(gcf,'units');
% posfig_pix=getpixelposition(gcf);
set(gcf,'units','pixels');
posfig_pix=get(gcf,'position');

set(gcf,'units',unit);


hr=findobj(0, 'tag', 'multiline');
unit=get(hr,'units');   
set(hr,'units','pixels');
po2=get(hr,'position');
set(hr,'position',[ posfig_pix(3)-74  po2(2:4) ]);
set(hr,'units',unit);


hr=findobj(0, 'tag', 'space');
unit=get(hr,'units');   
set(hr,'units','pixels');
po2=get(hr,'position');
set(hr,'position',[ posfig_pix(3)-74  po2(2:4) ]);
set(hr,'units',unit);

%% ===============================================
function blankscreen

out=findobj(gcf,'tag','ho');
jScroll = findjobj(out);
jScrollPane = findjobj(out);
jViewPort = jScrollPane.getViewport;
jEditbox = jViewPort.getComponent(0);

u=get(gcf,'userdata');
jEditbox.setText('');
append('.."blank"')

function defaultoutput_refresh

out=findobj(gcf,'tag','ho');
jScroll = findjobj(out);
jScrollPane = findjobj(out);
jViewPort = jScrollPane.getViewport;
jEditbox = jViewPort.getComponent(0);

u=get(gcf,'userdata');
jEditbox.setText( u.iniTxt);
append('.."redraw"')




function defaultoutput

out=findobj(gcf,'tag','ho');
jScroll = findjobj(out);
jScrollPane = findjobj(out);
jViewPort = jScrollPane.getViewport;
jEditbox = jViewPort.getComponent(0);





jEditbox.setText('start_console999');
append('Matlab Console');
importCmdHistory();
hpath='H:\Daten-2\Imaging';
hpasthtml='';
if exist(hpath)==7
    hpasthtml=['<a href="matlab: explorer(''' hpath  ''') ">H:imaging</a>'];
end
hx='x:\';
hxhtml='';
if exist(hx)==7
    hxhtml=['<a href="matlab: explorer(''' hx  ''') ">x:\</a>'];
end
    
    
%     '<h2 style="margin:0; display:inline;"><font color=yellow>close GUI via contextmenu</font></h2><br>'...

l={'<font color=yellow> .. to close this GUI use <b>contextmenu</b></font>'  
    [
    '<a href="matlab: xconsole(''help'') ">help</a>'  ... 
    ' <a href="https://github.com/ChariteExpMri/antx2 ">ANTx-GitHub</a>' ...
    ' <a href="matlab: snips ">snips-GUI</a>'  '  <a href="matlab: xconsole(''cmap'') ">colormaps</a>'  ...
    ' <a href="matlab: xconsole(''web'') ">web</a>'  ] 
   [ 'paths: ' '<a href="matlab: explorer ">pwd</a>' ' '  hpasthtml ' ' hxhtml] 
   };
append(strjoin(l,char(10)));

u=get(gcf,'userdata');
if isfield(u,'iniTxt')==0
    u.iniTxt=jEditbox.getText;
    set(gcf,'userdata',u);
end




function contextmenu1(e,e2,task,s)
hf=findobj(gcf,'tag','xconsole');
u=get(hf,'userdata');
if strcmp(task,'importCMD')
    cmdWinDoc = com.mathworks.mde.cmdwin.CmdWinDocument.getInstance;
    txt = char(cmdWinDoc.getText(0, cmdWinDoc.getLength));
    append(txt);
    scrollBottom();
elseif strcmp(task,'closefig') 
    set(hf,'CloseRequestFcn','closereq');
    close(hf);
    
    
elseif strcmp(task,'diary_on')    
    
    [fi pa]= uiputfile('*.*','save diary-file as ','diary');
    if isnumeric(fi);
        return;
    end
    f1=fullfile(pa,fi);
    
    diary off;
    try; delete(f1); end
    diary(f1);
    
    
     u.diaryfile=f1;
     set(gcf,'userdata',u);
     
     append(['diary-recoding: ' get(0,'diary') ]);
     scrollBottom();
    
elseif strcmp(task,'diary_off')   
%      if isfield(u,'diaryfile') &&  exist(u.diaryfile)==2
%            f1=u.diaryfile;   
%         else
%             append('..no diary file found/loaded');
%            return 
%      end
        diary off;
        append(['diary-recoding: ' get(0,'diary') ]);
        scrollBottom();
    
elseif strcmp(task,'readDiary')
    if exist('s')~=1
        [fi, pa] = uigetfile('*.*', 'get diary file');
        if isnumeric(fi);
            return;
        end
        f1=fullfile(pa,fi);
    elseif strcmp(s,'reload')
        if isfield(u,'diaryfile') &&  exist(u.diaryfile)==2
           f1=u.diaryfile;   
        else
            append('..no diary file found/loaded');
            scrollBottom();
           return 
        end
    end
        
        txt = fileread(f1);
        defaultoutput_refresh();
        append(txt);
        scrollBottom();
        
        u.diaryfile=f1;
        set(gcf,'userdata',u);
    
elseif strcmp(task,'cls')
%         defaultoutput()
        defaultoutput_refresh();
    
end

function rb_multiline(e,e2)

hi=findobj(gcf,'tag','hi');
% ho=findobj(gcf,'tag','ho')
mb=findobj(gcf,'tag','multiline');
if mb.Value==1
    hi.Max=200;
     set(hi,'callback',[]);
     
else
    hi.Max=1;
   set(hi,'callback',@runCmd_base)
end
   
get(findobj(gcf,'tag','hi'),'callback')
    
function show_cmap

hf=findobj(0,'tag','xconsole');
if isempty(hf); xconsole;end
try; figure(hf); end

append('..load cmaps..please wait..');drawnow;

 html=(getCMAP('html'));
m=regexprep(html,{'<html>','</html>','color=black'},{'','','color=#FFFFFF;'});
append(strjoin(m,char(10)));
scrollBottom()



function per(e,e2)

clear_console


function key_fig(e,e2)
% 
u=get(gcf,'userdata');
% e
ho=findobj(gcf,'tag','ho');

%  e2

% return
if strcmp(e2.Character,'c') %&& strcmp(e2.Modifier,'alt')
    
    
%     html=(getCMAP('html'));
% %     for i=1:length(html);
%         %
%         %
%         append('..load cmaps..please wait..');drawnow;
%         m=regexprep(html,{'<html>','</html>','color=black'},{'','','color=#FFFFFF;'});
%         append(strjoin(m,char(10)));
%         scrollBottom()
% %     end
    
show_cmap()
    
    
elseif strcmp(e2.Character,'+') %&& strcmp(e2.Modifier,'alt')
    u.fs=u.fs+1;
    set(gcf,'userdata',u);
    fs=u.fs+2;
     set(gcf,'userdata',u);
  append('intern_fsChange');
elseif strcmp(e2.Character,'-') %&& strcmp(e2.Modifier,'alt')
    %      fs=ho.FontSize-1;
    %      if fs>0
    %     set(ho,'FontSize',fs);
    %      end
    fs=u.fs-2;
    if fs>0
        u.fs=fs;
        set(gcf,'userdata',u);
      append('intern_fsChange')
    end
 elseif strcmp(e2.Character,'d') %&& strcmp(e2.Modifier,'alt')   
    contextmenu1([],[],'readDiary','reload');
end


function importCmdHistory()
% return
u=get(gcf,'userdata');

    try
        jhist = com.mathworks.mlservices.MLCommandHistoryServices.getSessionHistory;

        if isempty(jhist)
%             append('[History import empty]');
            return;
        end

        h = {};

        % ---- robust conversion (MATLAB 2016 safe) ----
        for i = 1:length(jhist)
            try
                item = jhist(i);

                % Java String → MATLAB char
                h{end+1,1} = char(item);

            catch
                % skip broken entries
            end
        end

        u.history = [u.history; (h)];
        u.histIdx=length(u.history);
        set(gcf,'userdata',u);

%         append(['[History imported: ' num2str(numel(h)) ']']);

    catch ME
%         append(['[History import failed: ' ME.message ']']);
    end


function  xcopy(e,e2)

ho=findobj(gcf,'tag','ho');
mat2clip(ho.String(ho.Value));

function runCmd_base(~,~)

runCmd;

function txt999999=eval_other_space_up(cmd)

txt999999=eval_other_space(cmd);

function  txt_999999=eval_other_space(cmd)

u_999999=get(gcf,'userdata');
if ~isfield(u_999999, 'd')
   u_999999.d=struct(); 
   set(gcf,'userdata',u_999999);
end

fn_9999999=fieldnames(u_999999.d);
for i_99999=1:length(fn_9999999)
    eval([ fn_9999999{i_99999} '= getfield(u_999999.d,''' fn_9999999{i_99999} ''');' ]);
end
clear i_99999;
clear fn_9999999;
clear u_999999
try
  %    txt999999 = evalc('evalin(''caller'',cmd)');
   txt_999999=evalc(cmd);
    %evalin('caller','who')
catch ME
    txt_999999 = getReport(ME,'basic');
end

clear cmd;
clear   i_99999 u_999999
fn_9999999=who;
u_999999=get(gcf,'userdata');
fn_9999999_old=fieldnames(u_999999.d);
fn_9999999( regexpi2(fn_9999999,{strjoin({'txt_999999','u', ...
    'cmd' 'fn_9999999','fn_9999999' },'|')})  )=[];
for i_99999 = 1:length(fn_9999999)
    u_999999.d.(fn_9999999{i_99999}) = eval(fn_9999999{i_99999});   % or direct variable access
end
%to delete
fn_diff=setdiff(fn_9999999_old,fn_9999999);
for i_99999 = 1:length(fn_diff)
    try;
        u_999999.d=rmfield(u_999999.d,fn_diff{i_99999});
    end
end

set(gcf,'userdata',u_999999);




return




function runCmd(~,~, cmd )
inp=findobj(gcf,'tag','hi');
if exist('cmd')~=1
    drawnow;
   cmd = strtrim(get(inp,'String')); 
else
    
end


set(inp,'String','');
u=get(gcf,'userdata');


if size(cmd,1)>1
    cmd=strjoin(cellstr(cmd), ';')  ;         
end

if isempty(cmd)
    return;
end

if ~isempty(strfind(u.consoleStr,cmd))
   return 
end

%  HARD SAFETY: never allow raw "tab" execution
if strcmpi(cmd,'tab')
    return;
end

u=get(gcf,'userdata');
u.history{end+1} = cmd;
u.histIdx = numel(u.history) + 1;
set(gcf,'userdata',u);

% append(['>> ' cmd]);

hb=findobj(gcf,'tag','space');
if hb.Value==1
    try
        txt = evalc('evalin(''base'',cmd)');
    catch ME
        txt = getReport(ME,'basic');
    end
else
    txt=eval_other_space_up(cmd);
%     try
%         txt = evalc('evalin(''caller'',cmd)');
%         %evalin('caller','who')
%     catch ME
%         txt = getReport(ME,'basic');
%     end
end

append(txt,cmd);
% append('>> ');
% append(' ');
scrollBottom();

function clear_console
inp=findobj(gcf,'tag','hi');
set(inp,'String','');
set(inp,'ForegroundColor','w');


%input
function keyHandler(src,event)
u=get(gcf,'userdata');
inp=findobj(gcf,'tag','hi');
is_multiline=get(findobj(0, 'tag', 'multiline'),'value');



try
    kc = get(f,'CurrentCharacter');
catch
    kc = '';
end
u=get(gcf,'userdata');

 if u.placeholder
        set(inp,'String','');
        set(inp,'ForegroundColor','w');
        u.placeholder = false;
 end
% ==============================================
%%   multiline
% ===============================================
if is_multiline
    if   ~isempty(event.Modifier) &&   strcmp(event.Modifier,'control')
        switch event.Key
            case 'return'
                
                
                runCmd();
                
%                 cmd=get(inp,'string');
%                 runCmd([],[], cmd );
                
                return
            case 'uparrow'
                if isempty(u.history), return; end
                u.histIdx = max(1, u.histIdx-1);
                v=u.history{u.histIdx};
%                 v=regexprep(v, ';+', [';' newline]);
                 v = regexprep(v,'(?<=.);+',[';' newline]);
                    v = regexprep(v,'^;+','');
                    
                set(inp,'String',v);
            case 'downarrow'
                if isempty(u.history), return; end
                u.histIdx = min(numel(u.history)+1, u.histIdx+1);
                if u.histIdx > numel(u.history)
                    set(inp,'String','');
                else
                    v=u.history{u.histIdx};
                    %v=regexprep(v, ';+', [';' newline]);
                    v = regexprep(v,'(?<=.);+',[';' newline]);
                    v = regexprep(v,'^;+',newline);
                    
                    set(inp,'String',v);
                end
        end
    end
    set(gcf,'userdata',u);
    return
end
% ==============================================
%%   single line
% ===============================================
switch event.Key
    case 'uparrow'
        if isempty(u.history), return; end
        u.histIdx = max(1, u.histIdx-1);
        set(inp,'String',u.history{u.histIdx});      
    case 'downarrow'
        if isempty(u.history), return; end
        u.histIdx = min(numel(u.history)+1, u.histIdx+1);
        if u.histIdx > numel(u.history)
            set(inp,'String','');
        else
            set(inp,'String',u.history{u.histIdx});
        end
    case 'tab'  % block MATLAB default TAB behavior
        set(inp,'String',get(inp,'String')); % forces refresh
        handleAutocomplete();
        s = get(inp,'String');% remove any accidental TAB character
        s = strrep(s,char(9),'');
        set(inp,'String',s);
        return;
end
set(gcf,'userdata',u);

% ==========================================================
% AUTOCOMPLETE (SAFE)
% ==========================================================
function handled = handleAutocomplete()
inp=findobj(gcf,'tag','hi');
txt = strtrim(get(inp,'String'));

if isempty(txt)
    handled = false;
    return;
end

vars = evalin('base','who');

funcs = {};
try
    w = what;
    funcs = w.m;
catch
end

candidates = [vars; funcs(:)];

matches = candidates(strncmp(candidates,txt,length(txt)));

if isempty(matches)
    handled = false;
    return;
end

if numel(matches) == 1
    set(inp,'String',matches{1});
else
    append(strjoin(matches','   '));
end

handled = true;

function linkCallbackFcn(src,eventData)
   url = eventData.getURL;      % a java.net.URL object
   description = eventData.getDescription; % URL string
   jEditbox = eventData.getSource;
   switch char(eventData.getEventType)
      case char(eventData.getEventType.ENTERED)
%                disp('link hover enter');
      case char(eventData.getEventType.EXITED)
%                disp('link hover exit');
      case char(eventData.getEventType.ACTIVATED)
              % jEditbox.setPage(url);
               s=char(eventData.getDescription);
               
               if strfind(s,'matlab:')==1
                   eval(strrep(s,'matlab:',''));
               else
                   web(s, '-browser');
               end
   end

% ==========================================================
% OUTPUT
% ==========================================================
function append(text,cmd)
hf=findobj(0,'tag','xconsole');
figure(hf)

u=get(gcf,'userdata');

out=findobj(hf,'tag','ho');



if strcmp(out.Style,'edit')
    jScroll = findjobj(out);
    jEdit   = jScroll.getViewport.getView; 
    doc = jEdit.getDocument();
% doc.insertString(doc.getLength, sprintf('%s\n',text), []);

jScrollPane = findjobj(out);
jViewPort = jScrollPane.getViewport;
jEditbox = jViewPort.getComponent(0);


if strcmp(text, '.."blank"')
    
    tx=regexprep(char(u.iniTxt),{'Matlab Console.*</pre>'},{'</pre>'});
    jEditbox.setText(tx);
    
%     'a'
    return
    
    
    
end




%% ===============================================

t=char([jEditbox.getText]);
z1=strsplit( (t),char(10))';


if isempty(z1{end}); 
    z1(end)=[];

end

t2=char(text);
if isempty(regexprep(t2,'\s+',''))  && exist('cmd')~=1
   return 
end
z2=strsplit(t2,char(10))';
% z2=regexprep(z2, '>>','&gt;&gt;');
z2=regexprep(z2, '>>\s+','');
if isempty(z2{end}); z2(end)=[]; end
if ~isempty(z2) && isempty(z2{1})
        z2(1)=[];
end
firstTime=0;
if ~isempty(strfind(t,'start_console999'))
    firstTime=1;
    z1='';
    
else
    t=char([jEditbox.getText]);
    t(max(strfind(t, '</pre>')-1):end)=[];
%     t(max(strfind(t, '</body>')-1):end)=[];
%     t=regexprep(t,{'.*<body>', '</body>.*', ['^' char(10)]},'');
%     t=regexprep(t,[char(10) '\s+$' ],'');
 
    z1=strsplit( (t),char(10))';
    im=min(regexpi2(z1, 'Matlab Console' ));
    if ~isempty(im)
    z1=z1(im:end);
    else
      z1(1:regexpi2(z1,'<pre style=')-1)=[];  
    end
    

    
end

if ~isempty(z1)
%     z1(regexpi2(z1, '<body style="background-color:+' ))=[];
    z1(regexpi2(z1, '<body style="background-color:+' ))=[];
    z1=regexprep(z1,{' .*margin-bottom: 0; margin-left: 0">' ,'</pre>'},'');
    if isempty(z1{end})
        z1(end)=[];
    end
end
try; z1(max(regexpi2(z1,'^ $')))=[];end

%% refresh only
% if strcmp(z2,'intern_fsChange')%, .."redraw")
if any(strcmp(t2,{'intern_fsChange', '.."redraw"'}))
    z3=[z1];
else
    cc='';
    if exist('cmd')==1
        %    '<html> <FONT color=#000000 >&#9632;<FONT color=#202020 >&#9632;<FONT color=#404040 >&#9632;<FONT color=#606060 >&#9632;<FONT color=#808080 >&#9632;<FONT color=#9F9F9F >&#9632;<FONT color=#BFBFBF >&#9632;<FONT color=#DFDFDF >&#9632;<FONT color=#FFFFFF >&#9632;<FONT color=black>&nbsp;gray[1]'

        cc=['<FONT color=#DFDFDF <b>' cmd '</b></FONT>'];
    end
    
    z3=[z1;cc; z2];
end

z3(regexpi2(z3,'<html>'))=[];
z3(regexpi2(z3,'<body>'))=[];
z3(regexpi2(z3,'<head>'))=[];
z3(regexpi2(z3,'</head>'))=[];

z3(regexpi2(z3,'</body>'))=[];
z3(regexpi2(z3,'</html>'))=[];
z3(regexpi2(z3,['^' char(13) '$']))=[];
% z3(regexpi2(z3,'</pre>') )=[];
% z3(regexpi2(z3,'<pre>') )=[];
z3=regexprep(z3,{'^\s+<pre>' '</pre>$'},'');

%% ===============================================
if ~isempty(z3)
 z4=strjoin(z3,char(10));
else
    z4='';
end
% z4=strjoin(z3,'<br>');

m = regexp(z4,'(\\b)+','match');
for k = 1:numel(m)
    z4 = strrep(z4, m{k}, [m{k} '\b']);
end

out = '';
i = 1;
in=z4;
while i <= length(in)
    if i < length(in) && in(i)=='\' && in(i+1)=='b'
        if ~isempty(out)
            out(end) = [];
        end
        i = i + 2;     % skip "\b"
    else
        out(end+1) = in(i);
        i = i + 1;
    end
end


%% ===============================================
z4=out;


% z4=sprintf(z4);
z4=regexprep(z4,';;','<br>');




   
z0 = ['<html><body style="background-color:black; color:black; ' ...
        'color:lime;' ...
       ['font-family:Consolas,monospace; font-size:' num2str(u.fs) 'px; ' ]   ...  %12px /pt
       'line-height:1.05; margin:0;">' ...
       '<pre style="margin:0;">' ]; 


   
ze=['</body></html>'     ];

if firstTime==1
    ms=[z0 z4 [char(10) ' '] ze];
else
    ms=[z0 z4 [char(10) ' ']  ze];
    
end
% jEditbox.setText(z4)
% ms
jEditbox.setText(ms);


% if firstTime==1
%  doc.insertString(doc.getLength, ms)
%  end
 
%  jEditbox.setText(['<html><body style="font-size:40pt; font-family:Arial;">' ...
%    '<pre>' 'link: <a href="http://undocumentedmatlab.com">click</a>' ...
%     ]);

%% ===============================================

else
    old = get(out,'String');
    if ischar(old)
        old = {old};
    end
    lines = strsplit(text,newline);
    newText = [old; lines(:)];
    set(out,'String',newText);
    
end
% 'a'
% scrollBottom();

% ==========================================================
% SCROLL
% ==========================================================
function scrollBottom()
% return
out=findobj(gcf,'tag','ho');
drawnow;
if strcmp(out.Style,'edit')
    jScroll = findjobj(out);          % out = handle to edit uicontrol
    jText   = jScroll.getViewport.getView;
    jText.setCaretPosition(jText.getDocument.getLength);% Move caret to the end
else
    set(out,'Value',numel(get(out,'String')));
end



function addVerticalSplitter(fig, top, bottom)

warning off;
if 0
    fig = figure('Name','Splitter','Units','pixels',...
        'Position',[300 200 500 600]);
    
    top = uicontrol('Style','edit','Units','pixels',...
        'Position',[50 320 400 240],...
        'Max',2,'String','TOP');
    
    bottom = uicontrol('Style','edit','Units','pixels',...
        'Position',[50 50 400 250],...
        'Max',2,'String','BOTTOM');
end

if ~iscell(bottom)
    bottom={bottom};
end
if ~iscell(top)
    top={top};
end

bo=bottom{1};
posR=get(bo,'position');

si=[posR(3)/3 .01];
posB=[posR(1)+si(1) posR(2)+posR(4) si];

hb=uicontrol(...
    'parent',fig,...
    'style','push',...
    'units','norm',...
    'string','');

set(hb,...
    'position',posB,...
    'fontsize',5,...
    'tag','addVerticalSplitter_resizebut');
hj=findjobj(hb);
hj = handle(hj,'CallbackProperties');
set(hj, 'MouseReleasedCallback', {@splitter_mouse_released,top});

set(hb,'units','pixels');

hmove=findjobj(hb);

set(hmove,'MouseDraggedCallback',{@splitter_resize,hb,bottom,top});

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function splitter_mouse_released(e,e2,top)
for i=1:length(top)
    if strcmp(top{i}.Style,'edit')
        jScroll = findjobj(top{i});          % out = handle to edit uicontrol
        jText   = jScroll.getViewport.getView;
        jText.setCaretPosition(jText.getDocument.getLength);% Move caret to the end
    elseif strcmp(top{i}.Style,'listbox')
        set(top{i},'Value',numel(get(top{i},'String')));
    end  
end
set(findobj(gcf,'tag','addVerticalSplitter_resizebut'),'units','normalized' )



function splitter_resize(~,~,hb,bx,tx)
MINHEIGHT=20;
fig=gcf;
mp=get(0,'PointerLocation');
figpos=getpixelposition(fig);
btnpos=getpixelposition(hb);
% mouse in figure coordinates
y=mp(2)-figpos(2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% determine limits from controls
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
bottomLimit=-inf;
topLimit=inf;
if ~isempty(bx)
    p=getpixelposition(bx{1});
    % bottom edit may not become smaller than MINHEIGHT
    bottomLimit=p(2)+MINHEIGHT;
end

if ~isempty(tx)
    p=getpixelposition(tx{1});
    % top edit may not become smaller than MINHEIGHT
    topLimit=p(2)+p(4)-MINHEIGHT-btnpos(4);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% clamp button
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
newY=max(bottomLimit,min(topLimit,y));
ys=newY-btnpos(2);
if ys==0
    return
end
setpixelposition(hb,...
    [btnpos(1) newY btnpos(3) btnpos(4)]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% resize TOP controls
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for k=1:length(tx)
    p=getpixelposition(tx{k});
    p(2)=p(2)+ys;
    p(4)=p(4)-ys;
    setpixelposition(tx{k},p);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% resize BOTTOM controls
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for k=1:length(bx)
    
    p=getpixelposition(bx{k});
    
    p(4)=p(4)+ys;
    
    setpixelposition(bx{k},p);
    
end

function hContainer = displayWebPage(url, parent)
% displayWebPage - display a web-page URL in a Matlab figure or UI container
%
% Syntax: hContainer = displayWebPage(url, parent)
%
% displayWebPage() with no input parameters displays the UndocumentedMatlab.com
% homepage in a figure window.
%
% displayWebPage(url) displays the specified webpage in a figure window.
%
% displayWebPage(url, title) displays the specified webpage in a figure window
% that has the specified title, creating a new figure if no such figure is found.
% If the figure is found and already contains an embedded browser, its contents
% are updated with the new web-page. Otherwise, a new browser is added to the
% figure, and then loads the specified webpage.
%
% displayWebPage(url, hParent) displays the specified webpage in the specified
% container handle (figure, uipanel, uitab, etc.). If the specified handle is
% not valid, the webpage is displayed in the system browser.
%
% hContainer = displayWebPage(...) returns the browser's container handle
%
% Usage examples:
%    displayWebPage  % display UndocumentedMatlab.com homepage in a figure window
%    displayWebPage('google.com')  % display google.com in a figure window
%    displayWebPage('http://google.com', 'Browser')  % display in 'Browser' figure
%    displayWebPage('http://google.com', uipanel)    % display in specified panel
%    hContainer = displayWebPage('http://google.com');  % return the figure handle
%
% Notes:
%    In some cases when the specified webpage URL is invalid, the browser might
%    hang, causing excessive CPU load. Closing/deleting the browser container
%    (e.g. its figure window) will dispose the browser and restore CPU to normal.
%
% Additional information:
%    https://UndocumentedMatlab.com
%
% See also:
%    web

% Release history:
%    1.0  2022-10-01: initial version

% License to use and modify this code is granted freely to all interested,
% as long as the original author is referenced and attributed as such.
% The original author maintains the right to be solely associated with this work.

% Programmed and Copyright by Yair M. Altman: altmany(at)gmail.com, UndocumentedMatlab.com

try
    % Process missing optional input args
    if nargin < 1 || isempty(url)
        url = 'https://UndocumentedMatlab.com';
    end
    if nargin < 2 || isempty(parent)
        parent = 'Embedded browser figure window';
    end
    
    % Prepend 'http:' if no protocol was specified
    url = strtrim(char(url));
    if ~any(url==':'), url = ['http://' url]; end
    
    % If a container handle was specified, use it
    newFig = false;
    if ~ischar(parent) && ~isstring(parent)
        % Raise exception if the container handle is invalid
        if ~isvalid(parent), error('invalid container handle'); end
        
        % Get the browser's reference handle (if it exists) in the specified container handle
        try jBrowser = getappdata(parent,'jBrowser'); catch, jBrowser=[]; end
        
        % If container does not already contain embedded browser, create it
        if isempty(jBrowser), jBrowser = createBrowserIn(parent); end
        
        % Return the container's handle, if requested
        if nargout, hContainer = parent; end
    else
        % Check for existence of the figure with specified title
        hFig = findall(0, 'Name',parent, 'Tag','Browser figure', '-depth',1);
        try jBrowser = getappdata(hFig,'jBrowser'); catch, jBrowser=[]; end
        if isempty(hFig) || ~isvalid(hFig)
            % Create a new figure
            hFig = figure('Color','w', ... 'Units','norm', 'Pos',[0.3 0.2 0.4 0.5], ...
                'Menubar','none', 'Toolbar','none', 'NumberTitle','off', ...
                'Tag','Browser figure', 'Name',parent);
            newFig = true;
            
            % Add browser panel in the figure's main content pane
            jBrowser = createBrowserIn(hFig);
            
            % Add custom browser toolbar
            jAddressField = createBrowserToolbar(hFig, url);
        elseif isempty(jBrowser)  % figure exists but has no browser
            % Add browser panel in the figure's main content pane
            jBrowser = createBrowserIn(hFig);
            
            % Add custom browser toolbar
            jAddressField = createBrowserToolbar(hFig, url);
        else
            hFig = hFig(1);  % in case there are multiple matching figures
            %set(hFig,'Visible','on'); figure(hFig); %display & bring to focus
            
            % Get the browser's address field reference handle
            jAddressField = getappdata(hFig,'jAddressField');
        end
        
        % Return the figure's handle, if requested
        if nargout, hContainer = hFig; end
        
        % Update the URL address field (only in standalone figure, not panel)
        try jAddressField.setText(url); catch, end
    end
    
    % Load the specified URL in the embedded browser
    jBrowser.load(url);
catch
    % Close any newly-created figure
    if newFig, delete(hFig), end
    
    % Open the URL in system browser
    web(url, '-browser');
    if nargout, hContainer = []; end
end


% Create a new browser instance and place it in the specified container handle
function jBrowser = createBrowserIn(hParent)
% Add maximized browser panel within hParent
jBrowserPanel = javaObjectEDT(com.mathworks.mlwidgets.help.LightweightHelpPanel); %#ok<JAPIMATHWORKS>
[jhBrowserPanel, hContainer] = javacomponent(jBrowserPanel, [], hParent); %#ok<JAVCM>
set(hContainer, 'Units','norm', 'Position',[0,0,1,1]);

% Store the browser reference handle for later use
% Note: jBrowserPanel.setCurrentLocation(url) only displays URLs under
% https://mathworks.com/help/, so we use jBrowser.load(url) instead
jBrowser = jhBrowserPanel.getLightweightBrowser;
setappdata(hParent,'jBrowser',jBrowser);

% Set-up cleaner callback
addlistener(hParent,'ObjectBeingDestroyed',@(h,e)cleanup(jBrowserPanel));


% Create a browser toolbar with an address-bar and an <open in browser> button
% Note: This toolbar is only created/displayed in standalone figure mode, not
% when the browser is embedded in an internal figure container (e.g. uipanel).
function jAddressField = createBrowserToolbar(hFig, url)
% Add custom browser toolbar
hToolbar = uitoolbar(hFig);
drawnow  % required for jToolbar to be non-empty

% Create the address box
jAddressField = javaObjectEDT(javax.swing.JTextField(url));
jAddressField.setEditable(false);
%{
    jSize = java.awt.Dimension(400,25);
    jAddressField.setMaximumSize(jSize);
    jAddressField.setMinimumSize(jSize);
    jAddressField.setPreferredSize(jSize);
    jAddressField.setSize(jSize);
%}
setappdata(hFig,'jAddressField',jAddressField);

% Add a narrow padding
jPaddingPanel = javaObjectEDT(javax.swing.JPanel);
jSize = java.awt.Dimension(3,25);
jPaddingPanel.setMaximumSize(jSize);
jPaddingPanel.setMinimumSize(jSize);
jPaddingPanel.setPreferredSize(jSize);
jPaddingPanel.setSize(jSize);

% Create the simple push-button
jOpenBrowser = javaObjectEDT(javax.swing.JButton('Open in browser'));
jOpenBrowser.setToolTipText('Open this webpage in system browser');
jhOpen = handle(jOpenBrowser, 'CallbackProperties');
set(jhOpen, 'ActionPerformedCallback', @(h,e)web(char(jAddressField.getText)));

% Append the filler and search-box to the toolbar
jFiller = javax.swing.Box.createHorizontalGlue;  % javax.swing.Box$Filler
jToolbar = hToolbar.JavaContainer.getComponentPeer; %#ok<JAVCT>
jToolbar.add(jAddressField, jToolbar.getComponentCount);
jToolbar.add(jFiller,       jToolbar.getComponentCount);
jToolbar.add(jOpenBrowser,  jToolbar.getComponentCount);
jToolbar.add(jPaddingPanel, jToolbar.getComponentCount);
jToolbar.revalidate;
jToolbar.repaint

% Set-up cleaner callback to dispose browser resources upon container deletion
addlistener(hFig,'ObjectBeingDestroyed',@(h,e)cleanup(jToolbar));


% Dispose the browser and its memory resources when Matlab container is deleted
function cleanup(jObject)
try jObject.dispose; catch, end

