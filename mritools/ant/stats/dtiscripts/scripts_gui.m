


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
set(hb,'position',[0 0.7 1.2 0.3]);

set(hb,'callback',{@scripts_process, 'scriptname'} );
set(hb,'tooltipstring',['script/function name']);


c = uicontextmenu;
hb.UIContextMenu = c;
m1 = uimenu(c,'Label','show script','Callback',{@scripts_process, 'open'});
m1 = uimenu(c,'Label','<html><font style="color: rgb(255,0,0)">edit file (not prefered)','Callback',{@scripts_process, 'editOrigFile'});

% addResizebutton(hf,hb,'mode','D','moo',1);

h2=uipanel(h,'units','norm');
% xpos=0.4;
% p.pos
set(h2,'position',[0 0 1 .1],'title','','tag','scripts_panel2');
set(h2,'units','pixels');
posp=get(h2,'position');
set(h2,'position',[posp(1:3) 24]);

set(h2,'units','norm');
posn=get(h2,'position');

%% ====[addNote]===========================================
% hb=uicontrol(h,'style','text','units','norm','tag','scripts_TXTscriptHelp');
% set(hb,'string',{'eeee'},'backgroundcolor','w');
% set(hb,'position',[[0 0.1 1.01 0.45]]);
% % set(hb,'callback',{@scripts_process, 'close'} );
% set(hb,'tooltipstring',['script/function help']);
% NotePos=[xpos .085  1-xpos .58];
% NotePos=[ 0 .058  1 .68];
NotePos=[ 0 posn(4)  1 .68];
msg='select <b>script/function</b> from <u>above</u> to obtain <font color="blue">help.<br>';
han=addNote(h,'text',msg,'pos',NotePos,'head','scripts/functions','mode','single','fs',20,'IS',1);
% addResizebutton(hf,han.pan,'mode','U','moo',1);


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
%% =========[close script panel]======================================
%%
hb=uicontrol(h2,'style','pushbutton','units','norm','tag','scripts_close');
set(hb,'string','close scripts');
% set(hb,'position',[[0.73 0 0.25 0.06]]); %fig-pos
set(hb,'units','pixels','position',[200 0 100 24]); %pan-pos
set(hb,'callback',{@scripts_process, 'close'} );
set(hb,'tooltipstring',['close']);
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


addResizebutton(gcf,h,'mode','L','moo',0,'restore',0);

set(gcf,'ResizeFcn',{@resizefig});

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
    if pp(4)>40
        set(u.han.pan,'position',[ pp(1) posp(4)  pp(3) pp(4)+(pp(2)-posp(4))  ]);
    end
    set(u.han.pan,'units',unibef);
end

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
elseif strcmp(task,'scriptname')
    
    file=hn.String{hn.Value};
    if exist(file)==0
        hlp=['script "'  file '"<font color="red">: File not found!</font>'];
        
    else
        hlp=help(file);
        hlp=strsplit(hlp,char(10));
    end
    hlp=[hlp repmat('<br>',[1 2])];
    
    NotePos=u.NotePos;
    %NotePos=[0.5 .085  .5 .58];
    
    
    
    hs=addNote(u.han,'text',hlp);
    if isempty(hs)
        addNote(hh,'text',hlp,'pos',NotePos,'mode','single','fs',20,'IS',1);
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