
% addNote: add note(s) to figure
% several notes in one figure possible 
%
% han=addNote(figh, varargin)
%
%% output
% han:handles (struct)
% ===============================================
%% ___INPUT PARAMETER___
% p0.text  ='Note';                         %<mandatory input> text to display (cell-string or char); (default: 'Note')
% p0.col   =[  0.8706    0.9216    0.9804]; % background color ; (default: [  0.8706    0.9216    0.9804])
% p0.fs    =25;                             % fontsize          ; (default: 25)
% p0.state =0;                              % state: [0]normal,[1]warning,[2]error  (default: 0)
% p0.head  ='';                             % additional headline, only if state is [0]; (default: empty)
% p0.headcol=[0.4667    0.6745    0.1882];  % headline-color: applies only if headline is not empty; (default: [0.4667    0.6745    0.1882])
% p0.pos   =[.2 .2 .3 .3];                  % note position (normalized position rel. to figure); (default: [.2 .2 .3 .3])
% p0.IS=10; % Iconsize                      % icon-size; (default: 10)
% p0.mode ='single';                        % 'single': one single note; 'multi': multiple notes (default: 'single')
% -additonal inputs for dialogs ---
% p0.dlg       % make dialog: [0]no, [1]yes...depending on p.state, this could be a warning- or eror-doalog
% po.figpos    % adjust figure-Size (normalized, 4 values); if empty a default size is used
% p0.wait      % modality of the figure: [0]no [1]yes.. wait to close figure
% ===============================================
% 
% 
% ===============================================
%% ___EXAMPLES_____
% cf; w1=figure;w2=figure;imagesc,imagesc; addNote(w1)
% 
%% simple note
% w2=figure;imagesc; addNote(w2,'text','This is a <b>Note</b><br>123')
% 
%% note: with headline, set BGcolor
% w2=figure;addNote(w2,'text','This is a <b>Note</b><br>123','head','Remember!','col',[ 0.8392 0.9098 0.8510])
%% note: with headline, set BGcolor, set headline-color
% w2=figure;addNote(w2,'text','This is a <b>Note</b><br>123','head','Remember!','col',[ 0.8392 0.9098 0.8510],'headcol',[1 0 1])
% 
% w2=figure;addNote(w2,'text',char(1:1000))
% 
%% normal note
% w2=figure;addNote(w2,'text','this is a simple note...  you can make a long string here','state',1)
%% warning note
% w2=figure;addNote(w2,'text',{'Improve this' 'better now not tomorrow' 'this is a cell-array'},'state',2)
%% Error note
% w2=figure;addNote(w2,'text','do this...','state',3)
%% warning note
% w2=figure;addNote(w2,'text','Something might be <b>improved','state',2,'pos',[0 0 1 .15])
%% ERROR note
% w2=figure;addNote(w2,'text','There was an <b><font color=white>Error!</b>','state',3,'pos',[0 0 1 .15],'IS',12);
% 
% msg= ['<b><div style="font-family:impact;color:green">' 'Important</div></b>' ... '
%     'Remember this: <i>' ...
%     '<font color="blue">tahoma</font></i> courier'];
% w2=figure;addNote(w2,'text',msg);
% 
%% four notes in one figure, click onto note to set n top
% cf
% fg; set(gcf,'menubar','none');
% addNote(gcf,'text','This is <b>Note-1</b><br>123','pos',[0.02 .5  .3 .3],'mode','multi');
% addNote(gcf,'text','This is <b>Note-2</b><br>123','head','Remember!','col',[ 0.8392 0.9098 0.8510],'headcol',[1 0 1],'mode','multi');
% addNote(gcf,'text','This is <b>Note-3</b><br>123','head','Lost','col',[ 0.9608    0.9216    0.9216],'headcol',[0 0 1],'pos',[0.05 0 .4 .15 ],'mode','multi');
% addNote(gcf,'text',{'Improve this' 'better now not tomorrow' 'this is a cell-array'},'state',2, 'pos',[.45 .6 .5 .3],'fs',50,'mode','multi');
%
%% close note:
% addNote(gcf,'note','close') ;
% ==============================================
%%   use as dialogs
% ===============================================
%% =====[DIALOG info]=================================
% addNote([],'text','here is more  <b><font color=green>to do!!</b>',...
%     'state',0,'IS',12,'dlg',1);
%% =====[DIALOG info]=================================
% a=strsplit(help('mean.m'),char(10));
% addNote([],'text',a, 'state',1,'IS',12,'dlg',1);
%% =========[DIALOG WARNING]======================================
% addNote([],'text','this might be  <b><font color=white>stupid!!</b>',...
%     'state',2,'pos',[0 .08 1 .92],'IS',1,'dlg',1);
%% =========[DIALOG ERROR WITH WAIT-OPTION]=========================
% addNote([],'text','this is an  <b><font color=white>ERROR!!</b>',...
%     'state',3,'dlg', 1,'wait',1);
%% ===============================================
%
%
% ==============================================
%% --- UPDATE NOTE ---
% ==============================================
% a note can be updated without destroing the note
% properties than can be updated:
%  "text":text to display;
%  "fs": fontsize; 
%  "col": bg-color
% _EXAMPLE_:
% hf=figure;
% hs=addNote(hf,'text','this is a simple note...  you can make a long string here','state',1)
% pause(1);
% hs=addNote(hs,'text','<u>a new Text')
% pause(1);
% hs=addNote(hs,'text','<u>another Text','fs',30,'col',[1 1 0])
% 
% 
% 
% ===============================================



function han=addNote(figh, varargin)
warning off;
han=[];
% ==============================================
%%   tests
% ===============================================

if 0
    cf; w1=figure;w2=figure;imagesc,imagesc; addNote(w1)
    
    % simple note
    w2=figure;imagesc; addNote(w2,'text','This is a <b>Note</b><br>123')
    
    % note: with headline, set BGcolor
    w2=figure;addNote(w2,'text','This is a <b>Note</b><br>123','head','Remember!','col',[ 0.8392 0.9098 0.8510])
    % note: with headline, set BGcolor, set headline-color
    w2=figure;addNote(w2,'text','This is a <b>Note</b><br>123','head','Remember!','col',[ 0.8392 0.9098 0.8510],'headcol',[1 0 1])

    w2=figure;addNote(w2,'text',char(1:1000))
    
    %normal note
    w2=figure;addNote(w2,'text','this is a simple note...  you can make a long string here','state',1)
    %warning note
    w2=figure;addNote(w2,'text',{'Improve this' 'better now not tomorrow' 'this is a cell-array'},'state',2)
    %Error note
    w2=figure;addNote(w2,'text','do this...','state',3)
    %warning note
    w2=figure;addNote(w2,'text','Something might be <b>improved','state',2,'pos',[0 0 1 .15])
    % ERROR note
    w2=figure;addNote(w2,'text','There was an <b><font color=white>Error!</b>','state',3,'pos',[0 0 1 .15],'IS',12);
    
    msg= ['<b><div style="font-family:impact;color:green">' 'Important</div></b>' ... '
        'Remember this: <i>' ...
    '<font color="blue">tahoma</font></i> courier'];
    w2=figure;addNote(w2,'text',msg);
    
    % four notes in one figure, click onto note to set n top
    cf
    fg; set(gcf,'menubar','none');
    addNote(gcf,'text','This is <b>Note-1</b><br>123','pos',[0.02 .5  .3 .3],'mode','multi');
    addNote(gcf,'text','This is <b>Note-2</b><br>123','head','Remember!','col',[ 0.8392 0.9098 0.8510],'headcol',[1 0 1],'mode','multi');
    addNote(gcf,'text','This is <b>Note-3</b><br>123','head','Lost','col',[ 0.9608    0.9216    0.9216],'headcol',[0 0 1],'pos',[0.05 0 .4 .15 ],'mode','multi');
    addNote(gcf,'text',{'Improve this' 'better now not tomorrow' 'this is a cell-array'},'state',2, 'pos',[.45 .6 .5 .3],'fs',50,'mode','multi');
    
end


% varargin{1}={'text','bla bla'};

% ===============================================
% ----INPUT PARAM
p0.text  ='Note';                         %text to display (cell-string or char)
p0.col   =[  0.8706    0.9216    0.9804]; %background color 
p0.fs    =25;                             %fontsize
p0.state =0;                              %state: [0]normal,[1]warning,[2]error
p0.head  ='';                             %additional headline, only if state is [0]
p0.headcol=[0.4667    0.6745    0.1882];  %headline-color: applies only if headline is not empty
p0.pos   =[.2 .2 .3 .3];                  % note position (normalized position rel. to figure)
p0.IS=10; % Iconsize                      % icon-size
p0.mode ='single';                        %'single': single note; 'multi': multiple notes
p0.dlg  =0       ;                        % make dialog: [0]no, [1]yes...depending on p.state, this could be a warning- or eror-doalog
po.figpos=[]     ;                        % adjust figure-Size (normalized, 4 values)
p0.wait  =0      ;                        % modality of the figure: [0]no [1]yes.. wait to close figure
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

% ==============================================
%%   update without destroing the Note
% ===============================================
 if isstruct(figh)
     han=figh;
     updateNote(han,pinput);
    return 
 end


% ==============================================
%%   inputs
% ===============================================

if exist('figh')==1 && ~isempty(figh)
    hf=figh;
else
    hf=gcf;
end


% ==============================================
%%   specific inputs
% ===============================================
if 0
   addNote([],'note','close') ;
end

if isfield(p,'note') && strcmp(p.note,'close')
    pans=findobj(hf,'tag','notepanel');
    for i=1:length(pans)
        fnote_close([],[],pans(i));
    end
    return;
end

% ==============================================
%%   get fig-pos
% ===============================================
if strcmp(hf.Type,'figure')==0 %is a panel or something else
    %figure(hf);
    hx=hf;
    hf=hf.Parent;
else
    hx=hf  ; 
end






% uniF=get(hf,'units');
% set(hf,'units','norm');
% posf=get(hf,'position');
% set(hf,'units',uniF);


%===================================================================================================
% ==============================================
%%
% ===============================================
warning off;
% clc

if strcmp(p.mode,'single')
    delete(findobj(hf,'tag','notepanel'));
    delete(findobj(hf,'tag','note_drag'));
    delete(findobj(hf,'tag','note_resize'));
    delete(findobj(hf,'tag','note_close'));
    
end

% ==============================================
%%   make errorDialog
% ===============================================
if p.dlg==1
    hp=uicontrol('style','pushbutton','units','norm','tag','pb_ok','string','OK');
    set(hp,'TooltipString','close window');
    
    set(hp,'position',[ .42 0 .2 .08],'callback', {@buttoncallback,hp});
    
    
    set(hf ,'numbertitle','off','menubar','none');
    
%  Resize   

    if isfield(pinput,'pos')==0
        p.pos=[0 .08 1 .92];
    end
    if isfield(pinput,'figpos')==0
        set(hf,'position',[[548   347   334   225]]);
    end
    
    if p.state==0 || p.state==1
        set(hf,'name',['info (t:' datestr(now,'HH:MM:SS') ')' ]);
    elseif p.state==2
        set(hf,'name',['warning (t:' datestr(now,'HH:MM:SS') ')' ]);
    elseif p.state==3
        set(hf,'name',['error (t:' datestr(now,'HH:MM:SS') ')' ]);
    end
    %set(hp,'units','pixels');
    
    if ~isempty(p.figpos)
        set(hf,'position',p.figpos);
    end
    
    if 0
        %% =====[DIALOG info]=================================
         addNote([],'text','here is more  <b><font color=green>to do!!</b>',...
            'state',0,'IS',12,'dlg',1);
        %% =====[DIALOG info]=================================
        a=strsplit(help('mean.m'),char(10));
         addNote([],'text',a, 'state',1,'IS',12,'dlg',1);
        %% =========[DIALOG WARNING]======================================
        addNote([],'text','this might be  <b><font color=white>stupid!!</b>',...
            'state',2,'pos',[0 .08 1 .92],'IS',1,'dlg',1);
        %% =========[DIALOG ERROR WITH WAIT-OPTION]=========================
         addNote([],'text','this is an  <b><font color=white>ERROR!!</b>',...
            'state',3,'dlg', 1,'wait',1);
        %% ===============================================
        
        
    end
end

%———————————————————————————————————————————————
%%   PANEL-2
%———————————————————————————————————————————————
% pos=[.2 .2 .3 .3];
pos=p.pos;


% delete(findobj(gcf,'tag','notepanel'));
pan2 = uipanel(hx,'Title','','FontSize',7,'units','norm', 'BackgroundColor','white',  'Position',[0 0 .5 .3]);
set(pan2,'Position',pos,'tag','notepanel','visible','on','backgroundcolor','w');
% set(pan2,'Position',[0.8 0-.01 .205 .9]);
set(pan2,'visible','on');







% if p.state==1
%     p0.col=[ 1.0000    0.8000    0.2000]
if p.state==1
    p.col=[ 0.8392    0.9098    0.8510];
    p.head='Info!';
    if isfield(pinput, 'headcol')~=1;
        p.headcol=[0.8706    0.4902         0];
    end
elseif p.state==2
    p.col=[ 1.0000    0.8000    0.2000];
    p.head='Warning!';
    if isfield(pinput, 'headcol')~=1;
        p.headcol=[0.8706    0.4902         0];
    end
elseif p.state==3
    p.col=[1.0000    0.6000    0.6000];
    p.head='Error!';
    if isfield(pinput, 'headcol')~=1;
        p.headcol=[1 1 1];
    end
end


%----make editorPane
% try; delete(findobj(hf,'tag','note_ed')); end
figure(hf);




jEditPane = javax.swing.JEditorPane('text/html', 'ssss');
% font = java.awt.Font('Tahoma',java.awt.Font.PLAIN, 50)
% jEditPane.setFont(font)

jScrollPane = javax.swing.JScrollPane(jEditPane);
[hcomponent, hb] = javacomponent( jScrollPane, [], hf);
set(hb,'parent',pan2);
set(hb,'tag','note_ed');
set(hb, 'units', 'normalized', 'position', [0 0 1 1]);
% set(hb,'position',[.2 .3 .3 .3]);

htmlStr = ['<b><div style="font-family:impact;color:green">'...
    'Matlab</div></b> GUI is <i>' ...
    '<font color="blue">highly</font></i> customizable'];
%        htmlStr='123'

jEditPane.setText(htmlStr);
% jEditPane.setEditable(false);

%% ===============================================

try
    % ---TEXT----
    %p.text=htmlStr;
    %p.text='<a href="https://www.w3schools.com/">Visit W3Schools.com!</a>'
    %p.text=repmat({'eee'},[100,1])
    %p.text={'eee' 'dddd<b>ddd'}
    %p.text='ssss'
    if iscell(p.text); text=strjoin(p.text,'<br>');
    else;              text=p.text;
    end
    
    
    if ~isempty(p.head)
        % %         color="rgb(128, 128, 0)">
        %         hcol=round(p.headcol.*255)
        %         color="rgb(hcol(1), hcol(2), hcol(3))"
        
        %        <p style="color:rgb(255,0,0);">
        %p.headcol =[1 0 0]
        hcol=sprintf('color:rgb(%d,%d,%d)',round(p.headcol.*255));
        %hcol='green'
        %hcol='red'
        
        %         text2=[ ['<b><div style="font-family:impact;color:' hcol '">'  p.head  '</div></b>']   ];
        % text2= ['<b><div style="font-family:impact;color:rgb(255,0,255)">'  p.head  '</div></b>']
        text2= ['<b><div style="font-family:impact;' hcol '">'  p.head  '</div></b>' text];
    else
        text2=text;
    end
    % add additional lines
    if ischar(text2); 
        text2=[text2 repmat('<br>',[ 1 2])];
    else
       text2=[text2(:); repmat([{'<br>'}],[2 1])]  ;
    end
    jEditPane.setText(text2);
end
%% ===============================================

try
    % ---fontsize----
    % see: https://undocumentedmatlab.com/articles/gui-integrated-html-panel
    java.lang.System.setProperty('awt.useSystemAAFontSettings', 'on');
    jEditPane.setFont(java.awt.Font('Arial', java.awt.Font.PLAIN, p.fs));
    jEditPane.putClientProperty(javax.swing.JEditorPane.HONOR_DISPLAY_PROPERTIES, true);
end
try
    % -----bgcolor---
    % see: https://undocumentedmatlab.com/articles/javacomponent-background-color
    bgcolor = p.col;% [1 0 0];%get(gcf, 'Color');
    jEditPane.setBackground(java.awt.Color(bgcolor(1),bgcolor(2),bgcolor(3)));
end

% ==============================================
%%   icon
% ===============================================
%% dragg
handicon=[...
    129	129	129	129	129	129	129	0	0	129	129	129	129	129	129	129
    129	129	129	0	0	129	0	215	215	0	0	0	129	129	129	129
    129	129	0	215	215	0	0	215	215	0	215	215	0	129	129	129
    129	129	0	215	215	0	0	215	215	0	215	215	0	129	0	129
    129	129	129	0	215	215	0	215	215	0	215	215	0	0	215	0
    129	129	129	0	215	215	0	215	215	0	215	215	0	215	215	0
    129	0	0	129	0	215	215	215	215	215	215	215	0	215	215	0
    0	215	215	0	0	215	215	215	215	215	215	215	215	215	215	0
    0	215	215	215	0	215	215	215	215	215	215	215	215	215	0	129
    129	0	215	215	215	215	215	215	215	215	215	215	215	215	0	129
    129	129	0	215	215	215	215	215	215	215	215	215	215	215	0	129
    129	129	0	215	215	215	215	215	215	215	215	215	215	0	129	129
    129	129	129	0	215	215	215	215	215	215	215	215	215	0	129	129
    129	129	129	129	0	215	215	215	215	215	215	215	0	129	129	129
    129	129	129	129	129	0	215	215	215	215	215	215	0	129	129	129
    129	129	129	129	129	0	215	215	215	215	215	215	0	129	129	129];
handicon(handicon==handicon(1,1))=255;
if size(handicon,3)==1; handicon=repmat(handicon,[1 1 3]); end
handicon=double(handicon)/255;


% poslb=[pos(1:2)+pos(3:4) .1 .1];% [.3 .3 .1 .1]
poslb=[pos(1:2) .1 .1];% [.3 .3 .1 .1]
IS=p.IS;
%MOVE LIST
%% ____________________[move]____________________________________________________________________________
hm=uicontrol('parent',hx,'style','push','units','norm','string','<html>&#9769;');
set(hm,'position',poslb,'fontsize',6,'tag','note_drag',...
    'TooltipString','move panel');
set(hm,'units','pixels');
posN=get(hm,'position');
set(hm,'position',[posN(1:2) IS IS]);
set(hm,'units','norm');
hdrag = findjobj(hm);
%% ___________________[resize]_____________________________________________________________________________
hr=uicontrol('parent',hx, 'style','push','units','norm','string','<>');
set(hr,'position',poslb,'fontsize',6,'tag','note_resize',...
    'TooltipString','resize panel');
set(hr,'units','pixels');
posN=get(hr,'position');
set(hr,'position',[posN(1)+IS posN(2) IS IS]);
set(hr,'units','norm');
hmove = findjobj(hr);
%% ____________________[close]____________________________________________________________________________
hc=uicontrol('parent',hx, 'style','push','units','norm','string','x');
set(hc,'position',poslb,'fontsize',6,'tag','note_close',...
    'TooltipString','close panel');
set(hc,'units','pixels');
posN=get(hc,'position');
set(hc,'position',[posN(1)+2*IS posN(2) IS IS]);
set(hc,'units','norm');
set(hc,'callback',{@fnote_close,pan2});
%% ________________________________________________________________________________________________

% set(hdrag,'MouseDraggedCallback',{@fnote_drag,'note_drag',{'notepanel', 'note_resize' 'note_close' } }); %'listFontsizeIncrease'

% downTags={'notepanel' };%'listFontsizeIncrease'
% movetags={'note_drag' 'note_close'};
% upTags={}; downTags={};
% set(hmove,'MouseDraggedCallback',{@fnote_resize,'note_resize',{'notepanel'},movetags,downTags,upTags } );

set(hmove,'MouseDraggedCallback',{@fnote_resize,hr,{pan2},{hm hc},{},{} } );
set(hdrag,'MouseDraggedCallback',{@fnote_drag,hm  ,{pan2 hr hc } }); %'listFontsizeIncrease'

% ==============================================
%%   context menu
% ===============================================

cmenu = uicontextmenu('Parent',hf,...
    'Interruptible','off','Visible','on','Tag','ContextMenu');
% Define the context menu items
item1 = uimenu(cmenu, 'Label', 'copy selection to clipboard','callback',{@contextmenu,'copy',pan2});
item2 = uimenu(cmenu, 'Label', 'change fontsize ..or use [ctrl -/+]','callback',{@contextmenu,'fontsize',pan2});
% item3 = uimenu(cmenu, 'Label', 'Test3','callback',{@contextmenu,3});

% Set up CallBack
tableHandle=handle(jEditPane,'callbackproperties');
set(tableHandle,'MousePressedCallback',{@mousePressedCallback,cmenu,pan2});

jbh = handle(jEditPane,'CallbackProperties');
set(jbh, 'KeyPressedCallback',{@keys_scripts,pan2});

% if 0
%     jEditPane.setBackground(java.awt.Color(0,0,0,0))
%     jScrollPane.setBackground(java.awt.Color(0,0,0,1))
%     
%     hp=findjobj(pan2)
%     hp.setBackground(java.awt.Color(0,0,0,.1))
%     
%     set(hb,'visible','off');
%     
%     jPanel = pan2.JavaFrame.getPrintableComponent;  % hPanel is the Matlab handle to the uipanel
%     jPanel.setOpaque(true)
%     jPanel.getParent.setOpaque(false)
%     jPanel.getComponent(0).setOpaque(false)
%     jPanel.repaint
% end

% ==============================================
%%   uutput
% ===============================================

han.pan  =pan2;
han.close=hc;
han.resize=hr;
han.move  =hm;
% ==============================================
%%   userdata
% ===============================================

u.hj=jEditPane;
u.hb=hb;
u.pan2=pan2;
u.hm=hm;
u.hr=hr;
u.hc=hc;

u.hmove=hmove;
u.hdrag=hdrag;



%===================================================================================================

set(pan2,'userdata',u);

if p.wait==1
    figure(hf);
    uiwait(hf);
end



function buttoncallback(e,e2,hp)
uiresume(gcf);
close(gcf);

% Turn on context menu at right mouse click (doesn't work!)
function mousePressedCallback(hObj, eventData, cmenu, pan2)
if eventData.isMetaDown  % right-click is like a Meta-button
    clickX = eventData.getX;
    clickY = eventData.getY;
    % [clickX clickY]%in pixel
    
    %   set(gcf,'units','pixels')
    %   cp=get(gcf,'currentpoint')
    %   set(gcf,'units','norm')
    %   set(cmenu,'Position',cp,'Visible','on');
    %   return
    hn=pan2;
    %hn=findobj(gcf,'tag','notepanel');
    set(hn,'units','pixels');
    posp=get(hn,'position');
    set(gcf,'units','norm');
    posn=get(hn,'position');
    set(cmenu,'Position',[(posp(1)+posp(3))/2 (posp(2)+posp(4))/2],'Visible','on');
    %[(posp(1)+posp(3))/2 (posp(2)+posp(4))/2]
    return
    
  %cmenu-pos is in pixel from figur-left-bottom
  mp=[0 0]
  set(cmenu,'Position',mp,'Visible','on');

    hn=findobj(gcf,'tag','notepanel');
    set(hn,'units','pixels');
    posp=get(hn,'position');
    set(gcf,'units','norm');
    posn=get(hn,'position');
    
    %posXn=clickX./posp(3)*posn(3);
    %posYn=(posp(4)-posp(2))+(clickY./posp(4)*posn(4));
   %mp = [posXn posYn]
   mp=[clickX clickY]
    %mp = [(posp(1)+posp(3))/2 (posp(3))]
    set(gcf,'units','pixels')
     mp=get(gcf,'currentpoint')
     set(gcf,'units','norm')
    set(cmenu,'Position',mp,'Visible','on');
else
    %'dd'
    if length(findobj(gcf,'tag','notepanel'))>1
        u=get(pan2,'userdata');
        uistack(u.pan2,'top');
        uistack(u.hm,'top');
        uistack(u.hr,'top');
        uistack(u.hc,'top');
        
        u.hdrag = findjobj(u.hm);
        u.hmove = findjobj(u.hr);
        
        set(pan2,'userdata',u);
        drawnow;
        
        
        set(u.hmove,'MouseDraggedCallback',{@fnote_resize,u.hr   ,{u.pan2},{u.hm u.hc},{},{} } );
        set(u.hdrag,'MouseDraggedCallback',{@fnote_drag   ,u.hm  ,{u.pan2 u.hr u.hc } }); %'listFontsizeIncrease'
    end
end


function contextmenu(e,e2,s,pan2)
hp=pan2;
% hp=findobj(gcf,'tag','notepanel');
u=get(hp,'userdata');
if strcmp(s,'copy')
    tx=char(u.hj.getSelectedText);
    clipboard('copy',tx);
elseif strcmp(s,'fontsize')
    u=get(pan2,'userdata');
    ui=uisetfont;
    if isnumeric(ui);return; end
    %u.hj.setFont(java.awt.Font('Arial', java.awt.Font.PLAIN, 50));
    u.hj.setFont(java.awt.Font(ui.FontName, java.awt.Font.PLAIN, ui.FontSize));
end

function keys_scripts(e,e2,pan2)

% e
% e2
% % 'hi'

if e2.getModifiers ==2   %[1]shift ,[2]ctrl, [8]alt
    %e2.getKeyCode
    %methods(e2)
    %e2.getKeyChar
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
    end
end

return


c = uicontextmenu;
% Set c to be the plot line's UIContextMenu
ha.UIContextMenu = c;

% Create menu items for the uicontextmenu
m1 = uimenu(c,'Label','dashed','Callback',@setlinestyle);
m2 = uimenu(c,'Label','dotted','Callback',@setlinestyle);
m3 = uimenu(c,'Label','solid','Callback',@setlinestyle);


return
% Prepare the context menu (note the use of HTML labels)
menuItem1 = javax.swing.JMenuItem('action #1');
menuItem2 = javax.swing.JMenuItem('<html><b>action #2');
menuItem3 = javax.swing.JMenuItem('<html><i>action #3');
% Set the menu items' callbacks
set(menuItem1,'ActionPerformedCallback',@myFunc1);
set(menuItem2,'ActionPerformedCallback',{@myFunc2});
set(menuItem3,'ActionPerformedCallback','disp ''action #3...'' ');
% Add all menu items to the context menu (with internal separator)
jmenu = javax.swing.JPopupMenu;
jmenu.add(menuItem1);
jmenu.add(menuItem2);
jmenu.addSeparator;
jmenu.add(menuItem3);
% Set the mouse-click event callback
% Note: MousePressedCallback is better than MouseClickedCallback
%       since it fires immediately when mouse button is pressed,
%       without waiting for its release, as MouseClickedCallback does
set(jEditPane, 'MousePressedCallback', {@mousePressedCallback,hb,jmenu});
% Mouse-click callback



function pp__mousePressedCallback(jListbox, jEventData, hListbox, jmenu)
if jEventData.isMetaDown  % right-click is like a Meta-button
    % Get the clicked list-item
    %jListbox = jEventData.getSource;
    mousePos = java.awt.Point(jEventData.getX, jEventData.getY);
    clickedIndex = jListbox.locationToIndex(mousePos) + 1;
    listValues = get(hListbox,'string');
    clickedValue = listValues{clickedIndex};
    % Modify the context menu or some other element
    % based on the clicked item. Here is an example:
    item = jmenu.add(['<html><b><font color="red">' clickedValue]);
    % Remember to call jmenu.remove(item) in item callback
    % or use the timer hack shown here to remove the item:
    timerFcn = {@removeItem,jmenu,item};
    start(timer('TimerFcn',timerFcn,'StartDelay',0.2));
    % Display the (possibly-modified) context menu
    jmenu.show(jListbox, jEventData.getX, jEventData.getY);
    jmenu.repaint;
else
    % Left-click - do nothing (do NOT display context-menu)
    'left'
end
% mousePressedCallback
% Remove the extra context menu item after display
function removeItem(hObj,eventData,jmenu,item)
jmenu.remove(item);

% Menu items callbacks must receive at least 2 args:
% hObject and eventData – user-defined args follow after these two
function myFunc1(hObject, eventData)
% ...
function myFunc2(hObject, eventData, myData1, myData2)
% ...
% </font></b></html></i></html></b></html>



function fnote_close(e,e2,pan2)

u=get(pan2,'userdata');
delete(u.pan2);
delete(u.hm);
delete(u.hr);
delete(u.hc);

% return
% 
% delete(findobj(gcf,'tag','notepanel'));
% delete(findobj(gcf,'tag','note_drag'));
% delete(findobj(gcf,'tag','note_resize'));
% delete(findobj(gcf,'tag','note_close'));

function fnote_drag(e,e2,tag,othertags)
% tag='cbarmoveBtn'
% hv=findobj(gcf,'tag',tag);
hv=tag;
hv=hv(1);
units_hv =get(hv ,'units');
units_fig=get(gcf,'units');
units_0  =get(0  ,'units');

set(hv  ,'units','pixels');
set(gcf ,'units','pixels');
set(0   ,'units','pixels');

posF=get(gcf,'position')   ;
posS=get(0  ,'ScreenSize') ;
pos =get(hv,'position');
mp=get(0,'PointerLocation');

xx=mp(1)-posF(1);
if xx<0; xx=0; end
if xx>(posF(3)-pos(3)); xx=posF(3)-pos(3); end
yy=mp(2)-posF(2);
if yy<0; yy=0; end
if yy>(posF(4)-pos(4)); yy=(posF(4)-pos(4)); end
set(hv,'position',[ xx yy pos(3:4)]);

set(hv ,'units'  ,units_hv);
set(gcf,'units'  ,units_fig);
set(0  ,'units'  ,units_0);
df=[pos(1)-xx pos(2)-yy];
% -----------------------------
if exist('othertags')==1
    %othertags=cellstr(othertags);
    for i=1:length(othertags)
        %hv=findobj(gcf,'tag',othertags{i});
        hv=othertags{i};
        hv=hv(1);
        %         try; hv=hv(1); end
        units_hv =get(hv ,'units');
        set(hv  ,'units','pixels');
        
        pos =get(hv,'position');
        pos2=[ pos(1)-df(1) pos(2)-df(2) pos(3:4)];
        set(hv,'position',pos2);
        set(hv ,'units'  ,units_hv);
    end
end


% function fnote_drag(e,e2,tag,othertags)
% % tag='cbarmoveBtn'
% hv=findobj(gcf,'tag',tag);
% hv=hv(1);
% units_hv =get(hv ,'units');
% units_fig=get(gcf,'units');
% units_0  =get(0  ,'units');
% 
% set(hv  ,'units','pixels');
% set(gcf ,'units','pixels');
% set(0   ,'units','pixels');
% 
% posF=get(gcf,'position')   ;
% posS=get(0  ,'ScreenSize') ;
% pos =get(hv,'position');
% mp=get(0,'PointerLocation');
% 
% xx=mp(1)-posF(1);
% if xx<0; xx=0; end
% if xx>(posF(3)-pos(3)); xx=posF(3)-pos(3); end
% yy=mp(2)-posF(2);
% if yy<0; yy=0; end
% if yy>(posF(4)-pos(4)); yy=(posF(4)-pos(4)); end
% set(hv,'position',[ xx yy pos(3:4)]);
% 
% set(hv ,'units'  ,units_hv);
% set(gcf,'units'  ,units_fig);
% set(0  ,'units'  ,units_0);
% df=[pos(1)-xx pos(2)-yy];
% % -----------------------------
% if exist('othertags')==1
%     othertags=cellstr(othertags);
%     for i=1:length(othertags)
%         hv=findobj(gcf,'tag',othertags{i});
%         hv=hv(1);
%         %         try; hv=hv(1); end
%         units_hv =get(hv ,'units');
%         set(hv  ,'units','pixels');
%         
%         pos =get(hv,'position');
%         pos2=[ pos(1)-df(1) pos(2)-df(2) pos(3:4)];
%         set(hv,'position',pos2);
%         set(hv ,'units'  ,units_hv);
%     end
% end




function fnote_resize(e,e2,tag,dotag,movetags, downTags,upTags)
% dotag=cellstr(dotag);

% hv=findobj(gcf,'tag',dotag{1});
hv=dotag{1};
hv=hv(1);
units_hv =get(hv ,'units');
units_fig=get(gcf,'units');
units_0  =get(0  ,'units');

set(hv  ,'units','pixels');
set(gcf ,'units','pixels');
set(0   ,'units','pixels');

posF=get(gcf,'position')   ;
posS=get(0  ,'ScreenSize') ;
pos =get(hv,'position');
mp=get(0,'PointerLocation');

xx=mp(1)-posF(1);
yy=mp(2)-posF(2);
% if xx<0; xx=0; end
% if xx>(posF(3)-pos(3)); xx=posF(3)-pos(3); end
% yy=mp(2)-posF(2);
% if yy<0; yy=0; end
% if yy>(posF(4)-pos(4)); yy=(posF(4)-pos(4)); end
% disp('-....');

xs=pos(1)-xx;
ys=pos(2)-yy;
posn=[ xx yy pos(3)+xs pos(4)+ys];
if posn(3)<0; posn(3)=3; end
if posn(4)<0; posn(4)=3; end
set(hv,'position',posn);
set(hv ,'units'  ,units_hv);
set(gcf,'units'  ,units_fig);
set(0  ,'units'  ,units_0);
% df=[pos(1)-xx pos(2)-yy];
% ----------------------------
%% ===============================================
% move moving-icon
% [xs xs]
% hv=findobj(gcf,'tag',tag);
% hv=tag{1};
hv=tag(1);
units_hv =get(hv ,'units');      set(hv  ,'units','pixels');
pos2=get(hv,'position');
set(hv,'position',[  pos2(1)-xs  pos2(2)-ys   pos2(3:4)]);
set(hv  ,'units',units_hv);
%% ===============================================
% move other-icons
% movetags=cellstr(movetags);
for i=1:length(movetags)
    %hv=findobj(gcf,'tag',movetags{i});
    hv=movetags{i};
    hv=hv(1);
    units_hv =get(hv ,'units');      set(hv  ,'units','pixels');
    pos2=get(hv,'position');
    set(hv,'position',[  pos2(1)-xs  pos2(2)-ys   pos2(3:4)]);
    set(hv  ,'units',units_hv);
end
%% ===============================================

% --------------downTags----------------
downTags=cellstr(downTags);
for i=1:length(downTags)
    %hv=findobj(gcf,'tag',downTags{i});
    hv=downTags{i}
    hv=hv(1);
    units_hv =get(hv ,'units');      set(hv  ,'units','pixels');
    pos2=get(hv,'position');
    set(hv,'position',[  pos2(1)-xs  pos2(2)-ys   pos2(3:4)]);
    set(hv  ,'units',units_hv);
end
%% ===============================================

% --------------upTags----------------
upTags=cellstr(upTags);
for i=1:length(upTags)
    %hv=findobj(gcf,'tag',upTags{i});
    hv=upTags{i};
    hv=hv(1);
    units_hv =get(hv ,'units');      set(hv  ,'units','pixels');
    pos2=get(hv,'position');
    set(hv,'position',[  pos2(1)-xs  pos2(2)   pos2(3:4)]);
    set(hv  ,'units',units_hv);
end

% ==============================================
%%   old
% ===============================================


% 
% function fnote_resize(e,e2,tag,dotag,movetags, downTags,upTags)
% dotag=cellstr(dotag);
% hv=findobj(gcf,'tag',dotag{1});
% hv=hv(1);
% units_hv =get(hv ,'units');
% units_fig=get(gcf,'units');
% units_0  =get(0  ,'units');
% 
% set(hv  ,'units','pixels');
% set(gcf ,'units','pixels');
% set(0   ,'units','pixels');
% 
% posF=get(gcf,'position')   ;
% posS=get(0  ,'ScreenSize') ;
% pos =get(hv,'position');
% mp=get(0,'PointerLocation');
% 
% xx=mp(1)-posF(1);
% yy=mp(2)-posF(2);
% % if xx<0; xx=0; end
% % if xx>(posF(3)-pos(3)); xx=posF(3)-pos(3); end
% % yy=mp(2)-posF(2);
% % if yy<0; yy=0; end
% % if yy>(posF(4)-pos(4)); yy=(posF(4)-pos(4)); end
% % disp('-....');
% 
% xs=pos(1)-xx;
% ys=pos(2)-yy;
% posn=[ xx yy pos(3)+xs pos(4)+ys];
% if posn(3)<0; posn(3)=3; end
% if posn(4)<0; posn(4)=3; end
% set(hv,'position',posn);
% set(hv ,'units'  ,units_hv);
% set(gcf,'units'  ,units_fig);
% set(0  ,'units'  ,units_0);
% % df=[pos(1)-xx pos(2)-yy];
% % ----------------------------
% %% ===============================================
% % move moving-icon
% % [xs xs]
% hv=findobj(gcf,'tag',tag);
% hv=hv(1);
% units_hv =get(hv ,'units');      set(hv  ,'units','pixels');
% pos2=get(hv,'position');
% set(hv,'position',[  pos2(1)-xs  pos2(2)-ys   pos2(3:4)]);
% set(hv  ,'units',units_hv);
% %% ===============================================
% % move other-icons
% movetags=cellstr(movetags);
% for i=1:length(movetags)
%     hv=findobj(gcf,'tag',movetags{i});
%     hv=hv(1);
%     units_hv =get(hv ,'units');      set(hv  ,'units','pixels');
%     pos2=get(hv,'position');
%     set(hv,'position',[  pos2(1)-xs  pos2(2)-ys   pos2(3:4)]);
%     set(hv  ,'units',units_hv);
% end
% %% ===============================================
% 
% % --------------downTags----------------
% downTags=cellstr(downTags);
% for i=1:length(downTags)
%     hv=findobj(gcf,'tag',downTags{i});
%     hv=hv(1);
%     units_hv =get(hv ,'units');      set(hv  ,'units','pixels');
%     pos2=get(hv,'position');
%     set(hv,'position',[  pos2(1)-xs  pos2(2)-ys   pos2(3:4)]);
%     set(hv  ,'units',units_hv);
% end
% %% ===============================================
% 
% % --------------upTags----------------
% upTags=cellstr(upTags);
% for i=1:length(upTags)
%     hv=findobj(gcf,'tag',upTags{i});
%     hv=hv(1);
%     units_hv =get(hv ,'units');      set(hv  ,'units','pixels');
%     pos2=get(hv,'position');
%     set(hv,'position',[  pos2(1)-xs  pos2(2)   pos2(3:4)]);
%     set(hv  ,'units',units_hv);
% end

function updateNote(h,p);
%% =======update========================================

u=get(h.pan,'userdata');
if isfield(p,'text')         %change TEXT
    u.hj.setText(p.text);
end

if isfield(p,'fs')          %change fontsize
    hfont=u.hj.getFont;
    u.hj.setFont(java.awt.Font(get(hfont,'FontName'), java.awt.Font.PLAIN, p.fs));
end

if isfield(p,'col') && length(p.col)==3
    u.hj.setBackground(java.awt.Color(p.col(1),p.col(2),p.col(3)));
end







