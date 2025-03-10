% [snips.m] : code snippets/matlab code
% use context-menu to copy/evaluate code
%

function snips
warning off;


%% ===============================================

% tic
% Get the full MATLAB path and split it into individual paths
paths = strsplit(path, pathsep);
paths(end+1)={pwd};
% Initialize a cell array to store the full paths of the files
fileList = {};
% Loop over each path in the MATLAB path
for i = 1:length(paths)
    currentPath = paths{i};
    % Check if the path exists
    if exist(currentPath, 'dir')
        % Get all files that start with 'test_' in the current path
        files = dir(fullfile(currentPath, 'snips_input*.m'));
        % Append full path to the files found
        for j = 1:length(files)
            fileList{end+1} = fullfile(currentPath, files(j).name); % Store full path
        end
    end
end
fileList';
% toc
%% ===============================================
c={};
for j=1:length(fileList)
    %f1=which('snips_input1.m');
    f1=fileList{j};
    a=preadfile(f1);
    a=a.all;
    ix=regexpi2(a,['^%% ' repmat('#',[1 20]) ]);
    s=[ix+1 [ix(2:end)-1; length(a) ]];
    
    
    
    for i=1:size(s,1)
        l=s(i,1):s(i,2);
        t=a(l);
        h =t{1};
        h2=t{2};
        h  =regexprep(h,'^%+\s+|^%+','');
        h2 =regexprep(h2,'^%+\s+|^%+','');
        %     if 0
        %         cprintf('*[1 0 1]',[regexprep(h,'%','%%')  '\n']);
        %         cprintf('*[0 0 1]',[regexprep(h2,'%','%%')  '\n']);
        %         disp(t);
        %     end
        c(end+1,:)={h h2 t   j};
    end
end



% ==============================================
%%
% ===============================================
s0=0.3;
v.editorpos=[s0 0.001 1-s0 1];
v.hfig    =[];
v.pb1string ='RUN';
v.uiwait   =1;
v.out      ='pass' ; %pass vs eval;
v.title    ='';
v.figpos   = [0.3049 0.4189 0.3889 0.4667];%[.1 .3 .5 .1];
v.figpos   =[0.0444    0.4189    0.9313    0.4667];
v.pb1callback=@pb1callback;
v.info  ='';
v.close =0;
v.title='snips';

delete(findobj('tag','snips'));
if isempty(v.hfig)
    figure('visible','on','color','w','menubar','none','toolbar','none',...
        'tag','snips', 'name',(v.title),...
        'NumberTitle','off','CloseRequestFcn',[]);
else
    figure(v.hfig)
    set(v.hfig,'tag','snips');
end


ax=axes('position',v.editorpos,'visible','off','tag','axe1');
uistack(ax,'bottom');

set(gcf, 'WindowKeyPressFcn', @key_press);
set(gcf, 'WindowKeyReleaseFcn', @key_release);

%% ===============================================


hf=findobj(0,'tag','snips');
set(hf,'units','pixels')
figposp=get(hf,'position');
sizepixel=figposp(3:4);

set(hf,'units','norm')
pos0=get(hf,'position');
set(hf,'position',[0.01 pos0(2) 1  pos0(4)   ]);
set(hf,'units','pixels');

pos=v.editorpos;%[0.001 0.001 1 1];
% posfig   =get(gcf,'position');
pos2=[ pos(1:2).*sizepixel  pos(3:4).*sizepixel];

if ~isempty(v.figpos)
    set(hf,'units','norm');
    set(hf,'position',v.figpos);
    set(hf,'units','pixels');
end

% set(gcf,'units','normalized');

%% ===============================================




jCodePane = com.mathworks.widgets.SyntaxTextPane;
codeType = com.mathworks.widgets.text.mcode.MLanguage.M_MIME_TYPE;
jCodePane.setContentType(codeType);

% t2=strjoin(t,char(10))
jCodePane.setText('% SELECT SNIPS');
jScrollPane = com.mathworks.mwswing.MJScrollPane(jCodePane);
[jhPanel,hContainer] = javacomponent(jScrollPane,round(pos2),hf); %[10,10,500,200]
% jhPanel.setFont(java.awt.Font('Comic Sans MS',java.awt.Font.PLAIN,28))
jhPanel.setHorizontalScrollBarPolicy(32);
set(hf,'position',figposp);

set(hf,'visible','on');  % #rp1
set(hContainer,'units','norm');

%% ===============================================

% jPopup = jCodePane.getComponentPopupMenu
% newMenuItem = javax.swing.JMenuItem('Custom Action');
% % Set callback action
% set(handle(newMenuItem, 'CallbackProperties'), 'ActionPerformedCallback', @(src, evt) disp('Custom Action Selected!'));
%
% % Add new item to the menu
% jPopup.add(newMenuItem);

% Create a new right-click context menu
jPopup = javax.swing.JPopupMenu;

% ==============================================
%%   contextmenu
% ===============================================


htmlLabel = '<html><b><font color="green">copy</b></font></html>';
hc = javax.swing.JMenuItem(htmlLabel);
set(handle(hc, 'CallbackProperties'), 'ActionPerformedCallback', {@context,'copy'});
jPopup.add(hc);% Add the new item to the menu

htmlLabel = '<html><b><font color="green">copy and add to Matlab-editor</b></font></html>';
hc = javax.swing.JMenuItem(htmlLabel);
set(handle(hc, 'CallbackProperties'), 'ActionPerformedCallback', {@context,'copy2editor'});
jPopup.add(hc);% Add the new item to the menu
jPopup.add(javax.swing.JSeparator());


htmlLabel = 'help on selected command -editor';
hc = javax.swing.JMenuItem(htmlLabel);
set(handle(hc, 'CallbackProperties'), 'ActionPerformedCallback', {@context,'helpfun_editor'});
jPopup.add(hc);% Add the new item to the menu

htmlLabel = 'help on selected command -doc';
hc = javax.swing.JMenuItem(htmlLabel);
set(handle(hc, 'CallbackProperties'), 'ActionPerformedCallback', {@context,'helpfun_doc'});
jPopup.add(hc);% Add the new item to the menu

htmlLabel = 'help on selected command -uhelp';
hc = javax.swing.JMenuItem(htmlLabel);
set(handle(hc, 'CallbackProperties'), 'ActionPerformedCallback', {@context,'helpfun_uhelp'});
jPopup.add(hc);% Add the new item to the menu
jPopup.add(javax.swing.JSeparator());

htmlLabel = 'show/hide line numbers';
hc = javax.swing.JMenuItem(htmlLabel);
set(handle(hc, 'CallbackProperties'), 'ActionPerformedCallback', {@context,'show_linenumbers'});
jPopup.add(hc);% Add the new item to the menu
jPopup.add(javax.swing.JSeparator());

htmlLabel = '<html><b><font color="red">evaluate Selected Text</font></b></html>';
hc = javax.swing.JMenuItem(htmlLabel);
set(handle(hc, 'CallbackProperties'), 'ActionPerformedCallback', {@context,'run'});
jPopup.add(hc);% Add the new item to the menu

% Attach the context menu to the syntax pane
jCodePane.setComponentPopupMenu(jPopup);

%% ===============================================



us.jCodePane=jCodePane;
us.jhPanel=jhPanel;
us.hContainer=hContainer;
% us.ispulldownON=0;

% ==============================================
%%  UITREE
% ===============================================
root = uitreenode('v0', 'SNIPS', 'SNIPS', [], false);
uni=unique(c(:,1),'stable');
iconPath1 = '';fullfile(matlabroot,'/toolbox/matlab/icons/book_mat.gif');
iconPath2 = '';fullfile(matlabroot,'/toolbox/matlab/icons/unknownicon.gif');
hc={};
%% ===============================================
n=1;
s2=zeros(size(c,1),1);
s2(1)=1;
tmp=regexprep( c{1,1},'\s+$','');
for i=2:size(c,1)
    if ~strcmp(regexprep( c{i,1},'\s+$',''),tmp);
        n=n+1;
        tmp=regexprep( c{i,1},'\s+$','');
    end
    s2(i,1)=n ;
end



%% ===============================================
% for i=1:length(uni)
%     c2=c(strcmp(c(:,1),uni{i}),:);
val=1;
for i=1:max(s2)
    c2=c(find(s2==i),:);
    
  if mod(c2{1,end},2)==1;   col='blue'   ;
    else                  ;   col='green'  ;
  end
    nn = ['<html><b><u><i>'  '<b><font color="' col '">' c2{1,1} '</html>'];
    
%     nn = ['<html><b><u><i>'  '<b><font color="blue">' c2{1,1} '</html>'];
    dx = uitreenode('v0',  c2{1,1},nn, iconPath1, false);
    for j=1:size(c2,1)
        dum=uitreenode('v0', c2{j,2},  c2{j,2},  iconPath2, true);
        dum.setValue(val);
        val=val+1; %use value as medium to obtain from table
        %         if j==2;
        %             set(dum,'name', ['<html><font color="gray">' char( dum.getName) '</html>']);
        %         end
        dx.add(dum);
        if i==1 && j==1
            dxFirst=get(dx,'FirstChild');
        end
        hc(end+1,1)={dum};
    end
    
    root.add(dx);
end

set(gcf,'units','normalized');
ht = uitree('v0', 'Root', root);
set(ht,'units','normalized')
up=0.05;
set(ht,'position',[0 up v.editorpos(1)-0.002 1-up  ]);
expandAllNodes(ht);

set(ht, 'NodeSelectedCallback', @nodeSelectedCallback);

us.linenumbers=1;
us.ht=ht;
us.c=c;
us.hc=hc;
set(gcf,'userdata', us);
set(hf,'position',v.figpos);


% hf=findobj(0,'tag','ant');
% hres=findobj(hf,'tag','lb3');
addResizebutton(hf,ht,'mode','UR','hd',hContainer);


ht.setSelectedNode([dxFirst]);  %
% nodeSelectedCallback();



set(gcf,'SizeChangedFcn',@SizeChangedFcn)
% set(ht,'units','pixels');

% ==============================================
%%   controls
% ===============================================
hp = uipanel('Title','','FontSize',6, 'BackgroundColor','white',...
    'units','pixels','Position',[0 0 400 21]);


% =====finder ==========================================
hb=uicontrol(gcf,'style','edit','units','pixels','tag','find');
set(hb,'position',[0 0 134 21]);
set(hb,'callback',@finder,'string','<search>');
set(hb,'backgroundcolor',[0.9608    0.9765    0.9922],'tooltipstring','search');

% =====clear finder ==========================================
hb=uicontrol(gcf,'style','pushbutton','units','pixels','tag','find_clear');
set(hb,'position',[134 0 21 21]);
set(hb,'callback',@find_clear,'string','x');
set(hb,'tooltipstring','clear search field');

% =====close ==========================================
hb=uicontrol(gcf,'style','pushbutton','units','pixels','tag','close_fig');
set(hb,'position',[300 0 40 21]);
set(hb,'callback',@close_fig,'string','close');
set(hb,'tooltipstring','close GUI');

% =====line numbers==========================================
hb=uicontrol(gcf,'style','togglebutton','units','pixels','tag','bt_linenumbers');
set(hb,'position',[350 0 21 21]);
set(hb,'callback',@bt_linenumbers,'string','ln','fontsize',7,'foregroundcolor',[0 0 1]);
set(hb,'tooltipstring','show/hide line numbers','value', us.linenumbers);

% =====line numbers==========================================
hb=uicontrol(gcf,'style','pushbutton','units','pixels','tag','showhelp');
set(hb,'position',[350+21 0 21 21]);
set(hb,'callback',@showhelp,'string','','fontsize',7,'backgroundcolor',[1 1 1]);
set(hb,'tooltipstring','help','value', us.linenumbers);
icon = fullfile(matlabroot,'/toolbox/matlab/icons/demoicon.gif');
if ~isempty(regexpi(icon,'.gif$'))
    [e map]=imread(icon)  ;     e=ind2rgb(e,map);    e(e<=0.01)=nan;
else
    e=double(imread(icon));    e=e/max(e(:));    e(e<=0.01)=nan;
end
set(hb,'cdata',e);




SizeChangedFcn()

% Add line numbers
lineNumbers = addLineNumbers(jCodePane, jScrollPane);


function lineNumPanel = addLineNumbers(textPane, jScrollPane)
lineNumPanel = javax.swing.JPanel();
lineNumPanel.setLayout(javax.swing.BoxLayout(lineNumPanel, javax.swing.BoxLayout.Y_AXIS));
lineNumPanel.setBorder(javax.swing.BorderFactory.createEmptyBorder(0, 5, 0, 5));  % Adjust padding as needed
jScrollPane.setRowHeaderView(lineNumPanel);
updateLineNumbers(lineNumPanel, textPane);
doc = textPane.getDocument();

% Attach document listener to update line numbers
listener = handle(doc, 'CallbackProperties');
set(listener, 'InsertUpdateCallback', @(src, evt) updateLineNumbers(lineNumPanel, textPane));
set(listener, 'RemoveUpdateCallback', @(src, evt) updateLineNumbers(lineNumPanel, textPane));
set(listener, 'ChangedUpdateCallback', @(src, evt) updateLineNumbers(lineNumPanel, textPane));

function updateLineNumbers(panel, textPane)
doc = textPane.getDocument();
rootElement = doc.getDefaultRootElement();
numLines = rootElement.getElementCount();
u=get(gcf,'userdata');
if u.linenumbers==1
    % Calculate necessary width
    if isunix;
        maxDigits = length(num2str(numLines))+0;
    else
        maxDigits = length(num2str(numLines))+2;
    end
else
    maxDigits = 0;
end
newWidth = maxDigits * 10 + 10;  % Approximation of width needed per digit plus some padding
% Adjust panel width
panel.setPreferredSize(java.awt.Dimension(newWidth, textPane.getHeight()));

% Clear previous content and add new labels
panel.removeAll();
for i = 1:numLines
    lineNumberLabel = javax.swing.JLabel(sprintf('%d', i));
    lineNumberLabel.setHorizontalAlignment(javax.swing.SwingConstants.RIGHT);
    lineNumberLabel.setFont(textPane.getFont());  % Match font size with text pane
    panel.add(lineNumberLabel);
end

panel.revalidate();
panel.repaint();



function bt_linenumbers(e,e2)
u=get(gcf,'userdata');
hb=findobj(gcf,'tag','bt_linenumbers');
u.linenumbers=hb.Value;
set(gcf,'userdata',u);
nodeSelectedCallback()

function SizeChangedFcn(e,e2)
u=get(gcf,'userdata');
uni_ht =get(u.ht,'units');
set(u.ht,'units','pixels');
px    =get(u.ht,'position');


hf=findobj(0,'tag','snips');
uni_hf=get(hf,'units');
set(hf,'units','pixels');
poshf=get(hf,'position');
set(hf,'units',uni_hf);

hb=findobj(gcf,'tag','find');
poshb=get(hb,'position');
% px(4)=poshf(4)-poshb(4)-1
set(u.ht,'position',[ px(1)  21 px(3)  poshf(4)-poshb(4)-1]);
set(u.ht,'units',uni_ht);

% shifter
hb=findobj(gcf,'tag','BUT_resizeControl');
hb=hb(1);
uni_hb =get(hb,'units');
set(hb,'units','pixels');
px2    =get(hb,'position');
set(hb,'position',[px(3)-7 px2(2)  8 px2(4)  ]);
set(hb,'units',uni_hb);
drawnow


function close_fig(e,e2)
hf=findobj(0,'tag','snips');
set(hf,'CloseRequestFcn','closereq')
close(hf);


function find_clear(e,e2)
hb=findobj(gcf,'tag','find');
hb.String='';
finder();

function finder(e,e2)
%% ===============================================
u=get(gcf,'userdata');
hb=findobj(gcf,'tag','find');
s=hb.String;
li=zeros(size(u.c,1),1);
if ~isempty(s)
    for i=1:size(u.c,1)
        if ~isempty(strfind(strjoin(u.c{i,3},' '),s));
            li(i)=1;
        end
    end
end
if sum(li)~=0
    set(hb,'string',' ..found!!!')
    bcol=get(hb,'backgroundcolor') ;
    set(hb,'backgroundcolor',[1 1 0]); drawnow
    
else
    set(hb,'string',' .not.found!!!')
    bcol=get(hb,'backgroundcolor') ;
    set(hb,'backgroundcolor',[1 0 0]); drawnow
end
pause(.2)
for i=1:length(li)
    str = regexprep(char(u.hc{i}.getName), '<.*?>', '');
    if li(i)==1
        str=['<html><b><mark><font color="Purple">' str '</font></html>'];
        %     str=['<html><body style="color: blue;">' str '</body></html>']
    end
    %    str2 = ['<html><b><u><i>'  '<b><font color="red">' 'bla' '</html>'];
    set(u.hc{i},'name',str);
    
end
javaMethodEDT('repaint', u.ht);

set(hb,'backgroundcolor',bcol); drawnow
set(hb,'string',s)



%% ===============================================
function showhelp(e,e2)
uhelp([mfilename '.m']);

function context(e,e2,task)
u=get(gcf,'userdata');
txt=char(u.jCodePane.getSelectedText());
if strcmp(task,'run')
    disp(['Selected Text: ', txt]);
    evalin('base', txt); % Run the selected text in the base workspace
elseif strcmp(task,'helpfun_editor')
    evalin('base', ['help ' txt]);
elseif strcmp(task,'helpfun_doc')
    evalin('base', ['doc ' txt]);
elseif strcmp(task,'helpfun_uhelp')
    evalin('base', ['uhelp(''' txt ''')']);
elseif strcmp(task,'copy')
    clipboard('copy',txt);
elseif strcmp(task,'copy2editor')
    clipboard('copy',txt);
    
    
    % Get clipboard content
    txt = clipboard('paste');
    txt=[repmat(char(10),[1 2]) txt   char(10)];
    clipboard('copy',txt);
    
    editorDoc = matlab.desktop.editor.newDocument('');
    editorDoc.Text = txt;
    % Bring the Editor to the front (optional)
    % editorDoc.Visible = true;
    
elseif strcmp(task,'show_linenumbers')
    hb=findobj(gcf,'tag','bt_linenumbers');
    hb.Value=~hb.Value;
    bt_linenumbers();
end




function nodeSelectedCallback(tree, eventData)
u=get(gcf,'userdata');
tree=u.ht;
% Callback function to handle node selection
u=get(gcf,'userdata');
c=u.c;
if 0
    node = tree.getSelectedNodes;
    nodeName = node(1).getName;
    nodeName=regexprep(char(nodeName), '<.*?>', '');
    % fprintf('Node selected: %s\n', nodeName);
   
    ix=find(strcmp(c(:,2), nodeName));
end

hn=get(eventData,'CurrentNode');
ix=hn.getValue;
if isnumeric(ix)==0;
     % u.jCodePane.setText('');
       return;
else
    %% ===============================================
    if ~isempty(ix)
        t=c{ix,3};
        t2=strjoin(t,char(10));
        %t2=char(strjoin(t,char(10)))
        u.jCodePane.setText(t2);
    end
    %% ===============================================
end







function hh=addResizebutton(figh,hres ,varargin)
warning off;
hh=[];
% ==============================================
%%   close option
% ===============================================
if ischar(figh) && strcmp(figh,'remove')
    delete(findobj(gcf,'tag','BUT_resizeControl'));
    return
end

% ==============================================
%%   inputs
% ===============================================
if exist('figh')==1 ;     hf=figh; else;     hf=gcf; end
if exist('hres')==1 ;            ; else;     return; end
figure(hf);

% ===============================================
% ----INPUT PARAMETER
p0.mode  ='R';                        ;%resize button: see 'mode'
p0.listboxResize =1                   ;%[1]resize other listbox or [0] shift listbox
p0.moo           =1                   ;%move other objects: [1]yes, [0]no
p0.restore       =1                   ;%restore previous position via contextmenu
% ===============================================
if nargin>1
    v=varargin;
    p=cell2struct(v(2:2:end),v(1:2:end),2);
    p=catstruct(p0,p);
else
    p=p0;
end
modes=p.mode;
% p

% IS=15;

% return
% ==============================================
%%
% ===============================================
posR=get(hres,'position');
hh=[];
orient={};
hhunit={};
hhpos=[];
this='';
for i=1:length(modes)
    mode=p.mode(i);
    if strcmp(mode,'R')
        si=[.005 posR(4)/3 ];
        posB=[posR(1)+posR(3)-si(1) posR(2)+si(2)   si  ];
        orient(end+1,1)={'R'};
        %this='R';
    elseif strcmp(mode,'L')
        si=[.01 posR(4)/3 ];
        posB=[posR(1)-si(1)        posR(2)+si(2)   si  ];
        orient(end+1,1)={'L'};
        %this='L';
    elseif strcmp(mode,'U')
        si=[posR(3)/3 .01  ];
        posB=[(posR(1)+(si(1)))    posR(2)+posR(4)   si  ];
        orient(end+1,1)={'U'};
        %this='U';
    elseif strcmp(mode,'D')
        si=[posR(3)/3 .01  ];
        posB=[(posR(1)+(si(1)))    posR(2)  si  ];
        orient(end+1,1)={'D'};
        %this='D';
    end
    
    %% ___________________[resize]_____________________________________________________________________________
    if strcmp(get(get(hres,'parent'),'type'),'figure')
        hpar=hf;
    else % panel or else
        hpar=get(hres,'parent');
    end
    hb=uicontrol('parent',hpar, 'style','push','units','norm','string','<');
    set(hb,'position',posB,'fontsize',5,'tag','BUT_resizeControl',...
        'TooltipString','resize panel','tooltipstring','resize control');
    set(hb,'units','pixels');
    posN=get(hb,'position');
    % set(hb,'position',[posN(1:2) IS IS]);
    set(hb,'units','norm');
    hmove = findjobj(hb);
    
    set(hmove,'MouseDraggedCallback',{@fnote_resize,mode,hb,{hres},{},{},{} } );
    set(hmove,'MouseReleasedCallback',{@fnote_resize,mode,hb,{hres},{},{},{} } );
    hh(i)=hb;
    hhunit{i}=get(hb,'units');
    hhpos{i}=posB;
    
    
    %     c = uicontextmenu;
    %     hb.UIContextMenu = c;
    %     if p.restore==1
    %         m1 = uimenu(c,'Label','restore default control position','Callback',@restoredefault);
    %     end
    
end
u.hh    =hh;
u.orient=orient;
u.hhunit=hhunit;
u.hhpos =hhpos;

set(hh,'userdata',u);

%% ============ other controls ===================================

h=findobj(gcf,'type','uicontrol'); %controls
b=h(regexpi2(get(h,'tag'),'BUT_resizeControl')); %resize button
h(regexpi2(get(h,'tag'),'BUT_resizeControl'))=[];

oc.h=h;
oc.units=get(h,'units');
oc.pos=get(h,'position');
%% ===============================================


for i=1:length(hh)
    u2=get(hh(i),'userdata');
    u2.this=p.mode(i);
    u2.oc=oc;
    
    u2.butunit=get(hh(i),'units');
    u2.butpos =get(hh(i),'position');
    
    u2.figunit=get(gcf,'units');
    u2.figpos =get(gcf,'position');
    u2.p=p;
    set(hh(i),'userdata',u2);
end

function fnote_resize(e,e2,mode,btag,rtag,movetags, downTags,upTags)
% rtag=cellstr(rtag);

% hv=findobj(gcf,'tag',rtag{1});
hv=btag(1);
% hv=rtag{1};
% get(hv,'tag')
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



add=pos(2)-yy;
xs=pos(1)-xx;
ys=pos(2)-yy;
posn=[ xx yy pos(3)+xs pos(4)+ys]; % resize -down-left
% posn=[ pos(1:2) pos(3)+xs pos(4)+ys]
if posn(3)<0; posn(3)=3; end
if posn(4)<0; posn(4)=3; end
%
% set(hv,'position',posn);
set(hv ,'units'  ,units_hv);
set(gcf,'units'  ,units_fig);
set(0  ,'units'  ,units_0);
% df=[pos(1)-xx pos(2)-yy];
% ----------------------------
% ==============================================
%%   BUTTON
% ===============================================
% move moving-icon
% [xs xs]
% hv=findobj(gcf,'tag',tag);
% hv=tag{1};
hv=btag(1); %button
units_hv =get(hv ,'units');
set(hv  ,'units','pixels');
pos2=get(hv,'position');
% ___________
hr=rtag{1}; %resize object
units_hr =get(hr ,'units');
set(hr  ,'units','pixels');
posr=get(hr,'position');
set(hr  ,'units',units_hr);
% ___________
hf=gcf; %figure
units_hf =get(hf ,'units');

set(hf  ,'units','pixels');
posf=get(hf,'position');
set(hf  ,'units',units_hf);
pp=[  pos2(1)-xs  pos2(2)-ys+add   pos2(3:4)];
%     L=(pp(1)+pp(3))  ;%,posf(3);
%     posr
%     xs
% posr
if (posr(3)<18 && xs>0 ) || (pp(1)+pp(3))>posf(3)
    return
end
set(hv,'position',pp);% resize -down-left
set(hv  ,'units',units_hv);
% ==============================================
%%   resize object
% ===============================================
% get(findobj(gcf,'tag','note_drag'),'units'),1
% hv=tag(1);
hv=rtag{1};
pos2=get(hv,'position');
% return
units_hv =get(hv ,'units');      set(hv  ,'units','pixels');
pos2=get(hv,'position');
% get(hv,'tag')
if strcmp(mode,'L')
    pt=[  pos2(1)-xs  pos2(2)   pos2(3)+xs  pos2(4)-ys+add];
    set(hv,'position',pt);% resize -down-left
elseif strcmp(mode,'R')
    pt=[  pos2(1)  pos2(2)   pos2(3)-xs  pos2(4)-ys+add  ];
    set(hv,'position',pt);% resize -down-right
elseif strcmp(mode,'U')
    pt=[  pos2(1)  pos2(2)   pos2(3)  pos2(4)-ys  ];
    set(hv,'position',pt);% resize -down-right
elseif strcmp(mode,'D')
    pt=[  pos2(1)  pos2(2)-ys   pos2(3)  pos2(4)+ys  ];
    set(hv,'position',pt);% resize -down-right
end

set(hv  ,'units',units_hv);

% ==============================================
%%  outside controls
% ===============================================
% posf

v=get(gcf,'userdata');
ax=v.hContainer;%  findobj(gcf,'type','axes')
units_ho =get(ax ,'units');
set(ax  ,'units','pixels');
posh=get(ax,'position');
posh(1)=pos2(1)+pos2(3)+1;
posh(3)=posf(3)-posh(1)+0;
set(ax,'position',posh);% resize -down-right
set(ax  ,'units',units_ho);
% get(ax,'position')
drawnow


function expandAllNodes(tree)
warning off
% Get Java tree handle
jTree = tree.getTree;

% Manually expand all rows
javaMethodEDT('expandRow', jTree, 0); % Expand root row
rowCount = javaMethodEDT('getRowCount', jTree);

% Use a while loop to expand all nodes dynamically
row = 0;
while row < rowCount
    javaMethodEDT('expandRow', jTree, row);
    newRowCount = javaMethodEDT('getRowCount', jTree);
    if newRowCount == rowCount
        row = row + 1; % Only increment if no new rows were expanded
    else
        rowCount = newRowCount; % Update count, keep expanding
    end
end