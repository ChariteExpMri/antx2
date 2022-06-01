
% #ko *** scripts-collection ***
% #k THIS GUI CONTAINS SCRIPTS...YOU CAN MODIFY AND APPLY THE SCRIPTS...
% - The upper listbox contains the list of scripts
% - select on of the scripts from the above list to obtain the content of the script
%   in the lower box
% 
% select #b [show script] #n to see the the content of the script in a new window
% select #b [edit script] #n to open script in the editor
%    - this is the way to costumize and run the script 
% select #b [scripts summary] #n see summary (help) of all scripts
% select #b [close script] #n to close the scripts-collection
%
% clicke and drag #b [&#8615]-BTN #n to change the upper and lower listbox size ratios
%
% #m SHORTCUTS
% [CTRL +/-] change the fontsize of the selected listbox
% [1/2/3] change GUI-layout: [1]default [2] extended high, [3] extended high+width
% [e] edit script (open copy of the script in editor)   

% show scripts-gui
function scripts_gui(hf,varargin)

if 0
    %% ===============================================
    
    fg;
    set(gcf,'units','norm','position',[0.4160    0.3211    0.3903    0.3489]);
    set(gcf,'menubar','none')
    hf=gcf
    scripts_gui(hf)
    %% ===============================================
    
end


if (nargin==0 && exist('hf')==0) || (exist('hf')==1 && ischar(hf) && strcmp(hf,'test'))
    %% ===============================================
    scripts={ 'STscript_DTIstatistic_diffDTImatrices_diffGroups.m'
        'STscript_export4vol3d_simple.m'
        'STscript_export4vol3d_manycalcs.m'};
    scripts=[scripts ; repmat({'ddd'},[20,1]) ;{'last'}];
%     scripts={'ddf.m' 'mean.m' 'mm.m' 'snip_testNote.m'};
%     scripts='';
    
%     ant
%     scripts_gui([gcf],'pos',[0 0.5 1 .5],'closefig',1,'scripts',scripts)

%     
   scripts_gui([],'figpos',[.3 .2 .4 .4], 'pos',[0 0 1 1],'name','AMD','closefig',1,'scripts',scripts)

    return
    %% ===============================================
    
    
end

%% ===============================================
warning off

% ==============================================
%%
% ===============================================
if exist('hf') && ~isempty(hf)
    figure(hf);
else
    hf=figure;
    set(hf,'units','norm','menubar','none');
end
% ===============================================
% ----INPUT PARAM
% p0.text  ='Note';                         %text to display (cell-string or char)
% p0.col   =[  0.8706    0.9216    0.9804]; %background color
p0.fs    =25;                             %fontsize
p0.pos       =[.4 0  1-.4 1 ]             ; % note-position
p0.figpos   =''                           ; % figure-position
p0.name  ='';                               % figure name
p0.closefig=0                             ; %close figure when closebutton is pressed
p0.scripts  ='empty';                   ; %list of scripts

% p0.state =0;                              %state: [0]normal,[1]warning,[2]error
% p0.head  ='';                             %additional headline, only if state is [0]
% p0.headcol=[0.4667    0.6745    0.1882];  %headline-color: applies only if headline is not empty
% p0.pos   =[.2 .2 .3 .3];                  % note position (normalized position rel. to figure)
% p0.IS=10; % Iconsize                      % icon-size
% p0.mode ='single';                        %'single': single note; 'multi': multiple notes
% p0.dlg  =0       ;                        % make dialog: [0]no, [1]yes...depending on p.state, this could be a warning- or eror-doalog
% po.figpos=[]     ;                        % adjust figure-Size (normalized, 4 values)
% p0.wait  =0      ;                        % modality of the figure: [0]no [1]yes.. wait to close figure
% p0.name  =''     ;    % name of the figure (string; default: '')
% ===============================================


% p0.head=['<b><div style="font-family:impact;color:green">' 'Matlab</div></b>']


if nargin>1
    v=varargin;
    p=cell2struct(v(2:2:end),v(1:2:end),2);
    pinput=p; %backup input
    p=catstruct(p0,p);
else
    p=p0;
end


if ~isempty(p.figpos)
    f_units=get(hf,'units');
    if max(p.figpos)>1
        set(hf,'units','pixels');
    else
        set(hf,'units','normalized');
    end
    set(hf,'position',p.figpos);
    
    set(hf,'units',f_units);
end


% disp(p);return
% ==============================================
%%
% ===============================================

if ~isempty(p.name) && strcmp(hf.Type,'figure')
    set(hf,'name',p.name,'numbertitle','off');
end


scripts_process([],[],'close');

h=uipanel('units','norm');
% xpos=0.4;
% p.pos
set(h,'position',[p.pos],'title','scripts','tag','scripts_panel');
% set(h,'position',[xpos 0  1-xpos 1 ],'title','scripts','tag','scripts_panel');
%set(h,'position',[xpos 0.1  1-xpos-.1 .5 ],'title','scripts','tag','scripts_panel');

set(h,'ForegroundColor','b','fontweight','bold');

xpos=p.pos(1);
% ###########################################################################################
% ==============================================
%%   script-names
% ===============================================

% scripts={
%     'STscript_subdivideGroups_pairwiseComparisons.m'
%     'STscript_subdivideGroups_specific.m'
%     'STscript_DTIstatistic_simple.m'
%     'STscript_DTIstatistic_diffDTImatrices.m'
%     'STscript_DTIstatistic_diffDTImatrices_diffGroups.m'
%     'STscript_export4vol3d_simple.m'
%     'STscript_export4vol3d_manycalcs.m'
%     % 'DTIscript_HPC_exportData_makeBatch.m'
%     % 'DTIscript_posthoc_makeHTML_QA.m'
%     % 'DTIscript_posthoc_exportData4Statistic.m'
%     };

p.scripts=cellstr(p.scripts);
scripts=p.scripts;
% ###########################################################################################

%% ========[controls]=======================================

hb=uicontrol(h,'style','listbox','units','norm','tag','scripts_lbscriptName');
set(hb,'string',scripts);
% set(hb,'position',[0 0.7 1 0.3]);
set(hb,'position',[0 0.67 1 0.33]);

set(hb,'callback',{@scripts_process, 'scriptname'} );
set(hb,'tooltipstring',['script/function name']);


c = uicontextmenu;
hb.UIContextMenu = c;
m1 = uimenu(c,'Label','show script','Callback',{@scripts_process, 'open'});
m1 = uimenu(c,'Label','<html><font style="color: rgb(255,0,0)">edit file (not prefered)','Callback',{@scripts_process, 'editOrigFile'});

%  addResizebutton(hf,h,'mode','D','moo',1);

h2=uipanel(h,'units','norm');
% xpos=0.4;
% p.pos
set(h2,'position',[0 0 1 .1],'title','','tag','scripts_panel2');
set(h2,'units','pixels');
posp=get(h2,'position');
set(h2,'position',[posp(1:3) 24]);

set(h2,'units','norm');
posn=get(h2,'position');
% addResizebutton(hf,h2,'mode','U','moo',1);

%% ====[addNote]===========================================
% hb=uicontrol(h,'style','text','units','norm','tag','scripts_TXTscriptHelp');
% set(hb,'string',{'eeee'},'backgroundcolor','w');
% set(hb,'position',[[0 0.1 1.01 0.45]]);
% % set(hb,'callback',{@scripts_process, 'close'} );
% set(hb,'tooltipstring',['script/function help']);
% NotePos=[xpos .085  1-xpos .58];
% NotePos=[ 0 .058  1 .68];
NotePos=[ 0 posn(4)  1 .6];
msg='select <b>script/function</b> from <u>above</u> to obtain <font color="blue">help.<br>';
han=addNote(h,'text',msg,'pos',NotePos,'head','scripts/functions','mode','single','fs',20,'IS',1);
% hr=addResizebutton(hf,han.pan,'mode','U','moo',0);
% set(hr,'callback',@resizeUPDOWN);

%% =======[open script]========================================
hb=uicontrol(h2,'style','pushbutton','units','norm','tag','scripts_open');
set(hb,'string','show script');
% set(hb,'position',[-1.21e-16 0 0.25 0.06]); %fig-pos
set(hb,'units','pixels','position',[0 0 100 24]); %pan-pos
set(hb,'callback',{@scripts_process, 'open'} );
set(hb,'tooltipstring',['<html><b>open scripts/function in HELP window</b><br> '...
    'the script can be copied and modified']);
set(hb,'foregroundcolor',[0 .5 0],'fontweight','bold');
%% =======[edit script]========================================
hb=uicontrol(h2,'style','pushbutton','units','norm','tag','scripts_edit');
set(hb,'string','edit script');
% set(hb,'position',[[0.3     0 0.25 0.06]]); %fig-pos
set(hb,'units','pixels','position',[100 0 100 24]); %pan-pos
set(hb,'callback',{@scripts_process, 'edit'} );
set(hb,'tooltipstring',['<html><b>open scripts/function in EDITOR</b><br> '...
    'the script can be copied and modified']);
set(hb,'foregroundcolor',[0 0 1],'fontweight','bold');

%% =========[show scripts summary panel]======================================
%%
hb=uicontrol(h2,'style','pushbutton','units','norm','tag','scripts_summary');
set(hb,'string','scripts summary');
% set(hb,'position',[[0.73 0 0.25 0.06]]); %fig-pos
set(hb,'units','pixels','position',[200 0 100 24]); %pan-pos
set(hb,'callback',{@scripts_process, 'scripts_summary'} );
set(hb,'tooltipstring',['show summary of all scripts']);
set(hb,'foregroundcolor',[1 0 .5],'fontweight','bold');
%% =========[close script panel]======================================
%%
hb=uicontrol(h2,'style','pushbutton','units','norm','tag','scripts_close');
set(hb,'string','close scripts');
% set(hb,'position',[[0.73 0 0.25 0.06]]); %fig-pos
set(hb,'units','pixels','position',[470 0 100 24]); %pan-pos
set(hb,'callback',{@scripts_process, 'close'} );
set(hb,'tooltipstring',['close']);
% set(hb,'units','pixels')
%% =========[help btn]======================================
hb=uicontrol(h2,'style','pushbutton','units','norm','tag','help');
set(hb,'string','<html><b>?');
% set(hb,'position',[[0.73 0 0.25 0.06]]); %fig-pos
set(hb,'units','pixels','position',[350 0 24 24]); %pan-pos
set(hb,'callback',{@scripts_process, 'help'},'foregroundcolor',[0.8706    0.4902         0] );
set(hb,'tooltipstring',['get some help']);
% set(hb,'units','pixels')
%% ===============================================

set(h2,'units','pixels');
% set(han.pan,'units','pixels');
%% ==============[userdata]=================================
u.NotePos=NotePos;
u.han    =han;
u.p      =p;
u.h2     =h2;

set(h,'userdata',u);

set(gcf,'WindowKeyPressFcn', @keys);


%% =========[shift listboxes]======================================
%%
hb=uicontrol(hf,'style','pushbutton','units','norm','tag','shiftlistboxes');
set(hb,'string',['<html>' '&#8615' ],'fontsize',7,'backgroundcolor','w');
set(hb,'tooltipstring',['<html><b>drag button to resize layout of listboxes']);
%% ===============================================

hf=gcf;
hp =findobj(hf,'tag','notepanel');
uni_hp=get(hp,'units');
uni_hb=get(hp,'units');
% ---
set(hp,'units','pixels');
set(hb,'units','pixels');
% ---

rpos=get(hp,'position');
% spos=get(hb,'position');
% butwid=rpos(3)/10;
butwid=16;
pp=[rpos(3)-butwid-16 rpos(2)+rpos(4)-7  butwid   8 ];
% set(hb,'position',[rpos(3)-115 rpos(2)-2 100 8]);
set(hb,'position',[pp]);

set(hb,'units',uni_hb);
set(hp,'units',uni_hp);
%% ===============================================



% rpos=get(hp,'position');
% spos=get(hb,'position');
% pp=[rpos(3)-spos(3)-16 rpos(2)+rpos(4)-7  spos(3)   8 ];
% 
% % hb1=findobj(hf,'tag','scripts_lbscriptName');
% hb1 =findobj(hf,'tag','notepanel');
% runi=get(hb1,'units');
% set(hb1,'units','pixels');
% rpos=get(hb1,'position');
% set(hb1,'units',runi);
% 
% set(hb,'units','pixels');
% set(hb,'position',[rpos(3)-115 rpos(2)-7 100 8]);
% set(hb,'units','norm');


hmove = findjobj(hb);
set(hmove,'MouseDraggedCallback', @shiftlistboxes_cb);
%% ===============================================


addResizebutton(gcf,h,'mode','L','moo',0,'restore',0);
set(gcf,'ResizeFcn',{@resizefig});
% set(gcf,'WindowButtonDownFcn',@bb)


function shiftlistboxes_cb(e,e2)
% 'a'
% w=get(e.MouseDraggedCallbackData);
% set(gcf,'units','pixels');
% get(gcf,'CurrentPoint')

hv=findobj(gcf,'tag','shiftlistboxes');hv=hv(1);
units_hv =get(hv ,'units');
units_fig=get(gcf,'units');
% ----
set(hv  ,'units','pixels');
set(gcf ,'units','pixels');
set(0   ,'units','pixels');
% ----
posF=get(gcf,'position')   ;
posS=get(0  ,'ScreenSize') ;
pos =get(hv,'position');
mp=get(0,'PointerLocation');

xx=mp(1)-posF(1);
yy=mp(2)-posF(2);
% add=pos(2)-yy;

xs=pos(1)-xx;
ys=pos(2)-yy;
% posn=[ xx yy pos(3)+xs pos(4)+ys]; % resize -down-left
% % posn=[ pos(1:2) pos(3)+xs pos(4)+ys]
% if posn(3)<0; posn(3)=3; end
% if posn(4)<0; posn(4)=3; end
%
% set(hv,'position',posn);
set(hv ,'units'  ,units_hv);
set(gcf,'units'  ,units_fig);
% df=[pos(1)-xx pos(2)-yy];
% ----------------------------
% ==============================================
%%   BUTTON: moving-icon
% ===============================================
units_hv =get(hv ,'units');
set(hv  ,'units','pixels');
pos2=get(hv,'position');
% pp= [  pos2(1)-xs  pos2(2)-(pos2(4)/2)-ys   pos2(3:4)];
pp= [  pos2(1)  pos2(2)-(pos2(4)/2)-ys   pos2(3:4)];
if pp(2)<0 || (pp(2)+pp(4)) > posF(4) % do not allow to drag button outside figure
   set(hv  ,'units',units_hv);
   return
end

set(hv,'position',pp);
set(hv  ,'units',units_hv);

% ==============================================
%%   script-lb (above shifting pushbutton)
% ===============================================
hx=findobj(gcf,'tag','scripts_lbscriptName');
units_hx=get(hx,'units');
set(hx,'units','pixels');
posr=get(hx,'position');
dfy=posr(2)-yy  ;
yh=posr(4)+dfy  ;
if yh>0
    pp=[ posr(1) yy   posr(3) yh];
    set(hx,'position',pp);%
end
set(hx,'units',units_hx);
% ==============================================
%%   notepanel-lb (below shifting pushbutton)
% ===============================================
hx=findobj(gcf,'tag','notepanel');
units_hx=get(hx,'units');
set(hx,'units','pixels');
posr=get(hx,'position');
dfy=yy-posr(2)+5 ;% go [5] to be below, to end lower box beneath shifting-button
% yh=posr(4)+dfy  ;
if dfy>0
    pp=[ posr(1) posr(2)   posr(3) dfy];
    set(hx,'position',pp);%
end
set(hx,'units',units_hx);



%% ===============================================



function resizeUPDOWN(e,e2)
% 'w'

function resizefig(e,e2)
%% ===============================================
if 1
    hh=findobj(gcf,'tag','scripts_panel');
    u=get(hh,'userdata');
    posp=get(u.h2,'position');
    unibef=get(u.han.pan,'units');
    notepos=get(u.han.pan,'position');
    set(u.han.pan,'units','pixels');
    pp=get(u.han.pan,'position');
    
%     % shift above figure/panel
%     hh=findobj(gcf,'tag','scripts_panel');
%     unit_hh=get(hh,'units');
%     set(hh,'units','pixels');
%     poshh=get(hh,'position');
%     set(hh,'units',unit_hh);
%     
%     hl=findobj(hh,'tag','scripts_lbscriptName');
%     unit_hl=get(hl,'units');
%     set(hl,'units','pixels');
%     poshl=get(hl,'position');
%     
%     
%    [poshh; poshl;   ];
%    [poshh(4) poshl(4)+poshl(2)];
%    high=poshh(4)-poshl(4);
%    ybas=poshh(4)-high;
%    set(hl,'position', [poshl(1)  ybas poshl(3) high] );
%    set(hl,'units',unit_hl);
%     drawnow
    
    %pp(4)
    if pp(4)>40
        set(u.han.pan,'position',[ pp(1) posp(4)  pp(3) pp(4)+(pp(2)-posp(4))  ]);
    end
    set(u.han.pan,'units',unibef);
    
    
    
end

%% ======addjust shift pushbutton =========================================

uni_f=get(gcf,'units');
uni_0=get(0,'units');

set(gcf,'units','pixels');
set(0,'units','pixels');

pos_sc=get(0,'ScreenSize');
pos_fg=round(get(gcf,'position'));

df=pos_sc(3)-(pos_fg(3)); %check if max-resize via fullscreenBTN

set(gcf,'units',uni_f);
set(0,'units',uni_0);

nloop=1;
if df==0
   nloop=2; 
end

for i=1:nloop
    drawnow
    hf=gcf;
    hb  =findobj(hf,'tag','shiftlistboxes');
    hp =findobj(hf,'tag','notepanel');
    uni_hp=get(hp,'units');
    uni_hb=get(hp,'units');
    % ---
    set(hp,'units','pixels');
    set(hb,'units','pixels');
    % ---
    
    rpos=get(hp,'position');
    spos=get(hb,'position');
    % pp=[rpos(3)-spos(3)-16 rpos(2)+rpos(4)-7  spos(3)   8 ];
    pp=[rpos(3)-spos(3)-16 rpos(2)+rpos(4)-7  16  8 ];
    % set(hb,'position',[rpos(3)-115 rpos(2)-2 100 8]);
    set(hb,'position',[pp]);
    
    set(hb,'units',uni_hb);
    set(hp,'units',uni_hp);
end

% if 1
% set(findobj(gcf,'tag','notepanel'),'visible','off')
%     % shift above figure/panel
%     hh=findobj(gcf,'tag','scripts_panel');
%     unit_hh=get(hh,'units');
%     set(hh,'units','pixels');
%     poshh=get(hh,'position');
%     set(hh,'units',unit_hh);
%     
%     hl=findobj(hh,'tag','scripts_lbscriptName');
%     unit_hl=get(hl,'units');
%     set(hl,'units','pixels');
%     poshl=get(hl,'position');
%     
%     
%    [poshh; poshl;   ];
%    [poshh(4) poshl(4)+poshl(2)]
%    high=poshh(4)-poshl(4);
%    ybas=poshh(4)-high
%    set(hl,'position', [poshl(1)  ybas poshl(3) high] );
%    set(hl,'units',unit_hl);
% end

%% ===============================================
function scripts_summary()
%% ===============================================
%  waitspin(1,'BUSY summary','..obtaining scripts summary');
 waitspin(1,'BUSY','analsysis-1','position',[6 30  55 55],'color',[1 .5 0]);
%  pause(1);
%  waitspin(2,'BUSY stuff2',{'analsysis-2' '...another messagge!'}); pause(1);


hb=findobj(0,'tag','scripts_lbscriptName');
hb=hb(1);
hf=(get(hb,'parent'));
if strcmp(get(hf,'type'),'figure')~=1;
   hf=(get(hf,'parent')); 
end
scriptscolName='';
try; 
    scriptscolName=get(hf,'Name'); 
end
li=get(hb,'string');

figname='scripts_summary';
delete(findobj(0,'name',figname));
drawnow;
% v2={'';[' <html><H1> *** LIST OF AVAILABLE SCRIPTS ***' ]; ' ee  ';' cc ';' dd '};
v2={''; ['<html><h1 style="color:red;font-size:30px;">  *** LIST OF AVAILABLE SCRIPTS ***  </h1> '];...
    ['<html><h1 style="color:red;font-size:20px;">         ' repmat('&nbsp;',[1 10]) scriptscolName '  </h1> '];...
    ['<html><h1 style="color:red;font-size:20px;">         ' repmat('_',[1 70])  '  </h1> '];...
    ''};
for i=1:length(li)
   v=help(li{i}) ;
   v=strsplit(v,[char(10) ] )';
   v=cellfun(@(a){['<html>' a]} ,v );
   vh={[' #lk  [' num2str(i) ']   ' li{i}   '                    ' ]};
   v2=[v2;      vh;  v ; {'   '}];
end

hf_help=uhelp(v2,1,'name',figname);
% figure(hf);
waitspin(0,'Done');
% figure(hf_help);


%% ===============================================

function scripts_process(e,e2,task)
hn=findobj(gcf,'tag','scripts_lbscriptName');
hh=findobj(gcf,'tag','scripts_panel');
u=get(hh,'userdata');


if strcmp(task,'close')
    if ~isempty(u)
        delete(findobj(gcf,'tag','scripts_panel'));
        addNote(gcf,'note','close') ;
        addResizebutton('remove');
        if u.p.closefig==1
            close(gcf);
        end
    end
elseif strcmp(task,'help') % show help
    uhelp([mfilename '.m']);
elseif strcmp(task,'scripts_summary')
    scripts_summary();
elseif strcmp(task,'scriptname') % show content
    if isempty(hn.Value); return; end
    file=hn.String{hn.Value};
    if exist(file)==0
        hlp={['script "'  file '"<font color="red">: File not found!</font>']};
        
    else
        hlp=help(file);
        
        hlp=strsplit(hlp,char(10));
        hlp=regexprep(hlp,'\s','&nbsp;');
        hlp=hlp(:);
        
        if 1 % add rest
            try
                w=preadfile(file); w=w.all;
                code=w(size(hlp,1)+3:end);
                code=['<div style="background-color:white;"><h1>CODE</h1><pre>' ; code; '</pre></div>'];
                hlp=[hlp; code];
            end
        end
    end
    hlp=[hlp; repmat({'<br>'},[2 1])];
    
    NotePos=u.NotePos;
    %NotePos=[0.5 .085  .5 .58];
    
    
    
    hs=addNote(u.han,'text',hlp);
    if isempty(hs)
      hs=addNote(hh,'text',hlp,'pos',NotePos,'mode','single','fs',20,'IS',1);
    end
    
    if 1 % disable EDITABLE TO 0
       hg=get(hs.pan,'userdata'); 
       hg.hj.setEditable(0);
       jbh = handle(hg.hj,'CallbackProperties');
       set(jbh, 'KeyPressedCallback',{@keys_pan,hs.pan});

    end
    
    
elseif strcmp(task,'open')
    %% OPEN SCRIPT IN MATLAB-EDITOR
    file=hn.String{hn.Value};
    if exist(file)==0
       cont={'--no scripts ---'} ;
       return
    else
      cont=preadfile(file);
    cont=cont.all;  
    end
    
    uhelp(cont,1,'name',['script: "' file '"']);
    h=findobj(gcf,'tag','scripts_lbscriptName');
    
    msg={'-copy script to Matlab editor'
        '-change parameter accordingly'
        '-save script somewhere on your path'
        '-run script'};
   addNote(gcf,'text',msg,'pos',[0.5 .1  .44 .3],'head','Note','mode','single');
elseif strcmp(task,'editOrigFile')
    pw=logindlg('Password','only');
    pw=num2str(pw);
    if strcmp(pw,'1')
        file=hn.String{hn.Value};
        if exist(file)==0
            cont={'--no scripts ---'} ;
            return
        end
        edit(file);
    end
elseif strcmp(task,'edit')
    file=hn.String{hn.Value};
    
    %% ===============================================
    if exist(file)==0
       cont={'--no scripts ---'} ;
       return
    end
    cont=preadfile(file);
    cont=cont.all;
    
    str = strjoin(cont,char(10));
    editorService = com.mathworks.mlservices.MLEditorServices;
    editorApplication = editorService.getEditorApplication();
    editorApplication.newEditor(str);
    %% ===============================================
    
end

function figresizekeys(arg)
if arg==1
    uni_f=get(gcf,'units');
    uni_0=get(0  ,'units');
    set(gcf  ,'units','pixels');
    set(0    ,'units','pixels');
    
    w=get(0,'default');
    set(gcf,'position',w.defaultFigurePosition);
    
    set(gcf,'units',uni_f);
    set(0  ,'units',uni_0);
elseif arg==2 %resize
    uni_f=get(gcf,'units');
    uni_0=get(0  ,'units');
    set(gcf  ,'units','normalized');
    set(0    ,'units','normalized');
    
    w=get(0,'default');
    pos0=w.defaultFigurePosition;
    pos=get(gcf,'position'); 
    set(gcf,'units',uni_f);
    set(0  ,'units',uni_0);
    
    set(gcf,'position',[ .3  0.07 .4  .9]);
    uni_f=get(gcf,'units');
    uni_0=get(0  ,'units');   
elseif arg==3
    
    uni_f=get(gcf,'units');
    set(gcf,'units','normalized');
    pos=get(gcf,'position');
    set(gcf,'position',[ 0.3  0.07 0.7  .9]);
    set(gcf,'units',uni_f);
end


function keys(e,e2)

if strcmp(e2.Modifier,'control')==1
    if strcmp(e2.Key,'l')
        figresizekeys(2);
    elseif strcmp(e2.Key,'n')
        figresizekeys(1);
    elseif strcmp(e2.Key,'e')
        disp('editint original file!');
        scripts_process([],[],'editOrigFile');
    elseif strcmp(e2.Character,'+')==1 || strcmp(e2.Character,'-')==1
        hl=findobj(gcf,'tag','scripts_lbscriptName');
        fs=get(hl,'fontsize');
        if strcmp(e2.Character,'+')==1;
            set(hl,'fontsize',fs+1);
        elseif strcmp(e2.Character,'-')==1;
            if fs>1
                set(hl,'fontsize',fs-1);
            end
        end
        
    end
else
     if strcmp(e2.Key,'2')
       figresizekeys(2);
    elseif strcmp(e2.Key,'1') 
       figresizekeys(1);
     elseif strcmp(e2.Key,'3')
       figresizekeys(3);
    elseif strcmp(e2.Key,'e')
        disp('edit original file!');
        scripts_process([],[],'edit');
    end
end





function keys_pan(e,e2,pan2)

if e2.getModifiers ==2   %[1]shift ,[2]ctrl, [8]alt
    %% using modifiers
    if 0
        e2.getKeyCode
        e2.getKeyChar
        e2.getKeyText(e2.getKeyCode())
    end
    
    
    if strcmp(e2.getKeyChar,'+')
        %'++'
        u=get(pan2,'userdata');
        font= u.hj.getFont;
        fs=font.getSize+1;
        u.hj.setFont(java.awt.Font(font.getFontName, java.awt.Font.PLAIN,fs));
    elseif strcmp(e2.getKeyChar,'-')
        %'--'
        u=get(pan2,'userdata');
        font= u.hj.getFont;
        fs=font.getSize-1;
        if fs==0; return; end
        u.hj.setFont(java.awt.Font(font.getFontName, java.awt.Font.PLAIN,fs));
    elseif strcmp(e2.getKeyText(e2.getKeyCode()),'C') ; %overriding the copy function
        contextmenu([],[],'copy',pan2);
     elseif strcmp(e2.getKeyText(e2.getKeyCode()),'E')
        scripts_process([],[],'editOrigFile');
    end
else
    %% no modifiers
    if strcmp(e2.getKeyChar,'2') || strcmp(e2.getKeyChar,'l')
       figresizekeys(2);
    elseif strcmp(e2.getKeyChar,'1') || strcmp(e2.getKeyChar,'n')
       figresizekeys(1);
     elseif strcmp(e2.getKeyChar,'3')
       figresizekeys(3);
      elseif strcmp(e2.getKeyText(e2.getKeyCode()),'E')
        scripts_process([],[],'edit');
    end 
end

