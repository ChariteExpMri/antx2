
%% selectionGUI using multiple cells
% function ids=selector(tb)
% function ids=selector2(tb,colinfo,varargin)
% 
% pairwise varargins
% 'iswait'      :  0/1      : [0] for debugging modus
% 'out'         : 'list'    : first outputargument is the selected list (tb) not the selected indices
% 'out'         : 'col-id'  : first outputargument is the specified column, example 'col-2'-->get column 2
%'help'         : strcell   : adds a helpbutton,    ...'help',{'HELP';'dothisNthat'},...
% 'position'    :[x y w h]   :position of fig
% 'finder'      :0/1  : shows an additonal finder WINDOW, default 0
% title         : title string in window-header
%% IN
% tb is a multiCell of strings
 % colinfo <optional>:char with infos, e.g. columnames 
 %% OUT
% ids: indices of selected objects
% use +/- to change fontsize
% use contextmenu ro de/select all
%% example
% id=selector(tb)
% id=selector(tb,'Columns:  file, sizeMB, date, MRsequence');%with columnInfo
%% EXAMPLE
% tb={   '20150908_101706_20150908_FK_C1M02_1_1\�'    '4.1943'    '08-Sep-2015 10:45:06'    'RARE'
%        '20150908_102727_20150908_FK_C1M04_1_1\�'    '4.1943'    '08-Sep-2015 10:45:12'    'RARE'
% '20150908_102727_20150908_FK_C1M064_1_1\�'    '4.1943'    '08-Sep-2015 10:45:12'    'RARE'
% '20150908_102727_20150908_FK_C1M043_1_1\�'    '4.1943'    '08-Sep-2010 10:45:12'    'RARE'
% '20150908_102727_20150908_FK_C1M04_1_1\�'    '3.1943'    '08-Sep-2015 10:45:00'    'fl'
% '20150908_102727_20150908_FK_C1M082_1_1\�'    '2.1943'    '08-Sep-2014 10:45:01'    'RARE'
% '20150908_102727_20150908_FK_C1M01_1_1\�'    '77.1943'    '08-Sep-2015 10:45:11'    'fl'}
% id=selector(tb,'Columns:  file, sizeMB, date, MRsequence');
%
% id=selector2(strrep(strrep(b,'\\','-'),' ','-'),{'file' 'sizeMB' 'date' 'MRsequence' 'protocol'});
%
% EXAMPLE-2
% tb={  'cx'     ' 6'    'g33'
%     'b1'     '10'    'g3' 
%     'c1'     ' 9'    'f3' 
%     'd1'     ' 8'    'd3' 
%     'f1'     ' 5'    'c3' 
%     'g1'     ' 0'    'b3' 
%     'g11'    ' 7'    'a3' }
% id=selector2(tb,{'Nvox' 'Color'  'Label'},'iswait',1,'position',[0.0778  0.0772  0.3510  0.8644]);
%% UPDATES:
% sort after [selected ID] now possible
% find & select with shortcut [f]


function [ids varargout]=selector2(tb,header,varargin)

if ischar(tb)
    ids=[];varargout={};
    if strcmp(tb,'getid')
        [ids ]=getid;
    end
    return
end

[ids]=deal([]);
varargout={};

params.dummy=nan;
if ~isempty(varargin)
    vara=reshape(varargin,[2 length(varargin)/2])';
    params=cell2struct(vara(:,2)',vara(:,1)',2);
end

if ~isfield(params,'selection')
    params.selection='multi';
end

if ~isfield(params,'finder')
    params.finder=0;
end

% 0.0778    0.0772    0.6698    0.8644

warning off;

% tb={header(:)';tb};

% us.raw=tb;
us.showinbrowser=0;
us.header=[{'ID'} ; header(:)];
us.tb0=tb;
tb=[header(:)'; tb];


iswait=1;
ids=[];

tb=[ cellstr(num2str([1:size(tb,1)]'-1)) tb ];
us.raw=tb(2:end,:);

% tb=strrep(tb,' ',' ');

% %replace '_' with html-code
% for i=1:size(tb,2)
%     tb(:,i)=regexprep( tb(:,i)  ,'_','<u>_</u>');
% end

% tb=[tb repmat({'_'},size(tb,1),1) ];
 %space=repmat('�|�' ,size(tb,1),1 );
 space=repmat('  ' ,size(tb,1),1 );
  space1=repmat('] ' ,size(tb,1),1 );
  
%  space2=repmat(' [ ]' ,size(tb,1),1 );
%  space=repmat(']  [' ,size(tb,1),1 );
space2=repmat('' ,size(tb,1),1 );

%space=repmat('|�' ,size(tb,1),1 );
d=[];
for i=1:size(tb,2);
    d=[d char(tb(:,i)) ];
    if i<size(tb,2)
        if i==1
           d=[d repmat(space1,1,1 ) ];   
        else
            
         d=[d repmat(space,1,1 ) ];
        end
    else
       d=[d repmat(space2,1,1 ) ];   
    end
end
% d2=d(:,1:end-1);
% d2=[d2 char(repmat({'@'},size(d2,1),1)) ];

% if 0
%     k=cellstr(d)
%     cellfun(@(k) {[ k]},k)
% k2=(regexprep(k,'\s+','</b></TD><TD><b>'))  
% d=char(d);
% end


tb2=cellstr(d);
 tb2=cellfun(@(tb2) {['[_] ' tb2]},tb2);
% tb2=cellfun(@(tb2) {['(_) ' tb2]},tb2);
 tb2=cellfun(@(tb2) {[ tb2 repmat(' ',[1 10])]},tb2);

% tb2=regexprep(tb2,'\t',' ');
% tb2=regexprep(tb2,' ','.');
% tb2=regexprep(tb2,' ','&hellip');
% tb2=regexprep(tb2,char(10),'');

clear d;


mode=2;
%% USE SPEZIFIC HTML-hex-color
if isfield(params,'color') || isfield(params,'bgcolor')
  mode=3;  
end

tb2=strrep(tb2,' ','&nbsp;');


% tb2=strrep(tb2,' ','&emsp;');
% tb2=strrep(tb2,' ','_');
% tb2=strrep(tb2,' ', '&#8230;');
% tb2=strrep(tb2,' ', '&#8230;');

% tb2=strrep(tb2,'_','&#95');
% &#160




if mode==1
    % colortag='<html><div style="background:yellow;">Panel 1'
    colortag='<html><div style="color:red;"> '
    % % colortag='<html><TD BGCOLOR=#40FF68>'
    tbsel=cellfun(@(tb2) [ colortag tb2],tb2,'UniformOutput',0)
elseif mode==2
%        colergen = @(color,text) ['<html><table border=0 width=500 bgcolor=',color,'><TR><TD><pre><b>',text,'</b></pre></TD></TR> </table></html>'];
      colergen = @(color,text) ['<html><bgcolor=',color,'><b>',text,'</b></html>'];
    for i=1:size(tb2,1)
        for j=1:size(tb2,2)
            %             tbsel{i,j}=colergen('#ffcccc',[tb2{i,j}(1:end-2) 'x]' ] );
            %            tbsel{i,j}=colergen('#FFD700',[tb2{i,j}(1:end-2) 'x]' ] );
            %            tbunsel{i,j}=colergen('#FFFFFF',[tb2{i,j}(1:end-2) ' ]' ] );
            
            tbsel{i,j}=colergen('#FFD700',[ '[x' tb2{i,j}(3:end)  ] );
            tbunsel{i,j}=colergen('#FFFFFF',[ '[ ' tb2{i,j}(3:end)  ] );
        end
    end  
elseif mode==3
    if isfield(params,'color')==1
        if size(tb2,1)~=size(params.color,1)+1%repmat
            if iscell(params.color)
            params.color=repmat(params.color(1),[size(tb2,1) 1]);
            else
              params.color=repmat({params.color},[size(tb2,1) 1]);   
            end
            params.color=[params.color(1);params.color];%header
        end
    else
       params.color=repmat({'000000'},[size(tb2,1) 1]) ;
    end
    
    if isfield(params,'bgcolor')==1
        if size(tb2,1)~=size(params.bgcolor,1)+1%repmat
            if iscell(params.bgcolor)
                params.bgcolor=repmat(params.bgcolor(1),[size(tb2,1) 1]);
            else
                params.bgcolor=repmat({params.bgcolor},[size(tb2,1) 1]);
            end
        end
        params.bgcolor=[params.bgcolor(1);params.bgcolor];%header
    else
        params.bgcolor=repmat({'ffffff'},[size(tb2,1) 1]) ;
    end
    
    if isfield(params,'selcolor')==1
        if size(tb2,1)~=size(params.selcolor,1)+1%repmat
            if iscell(params.selcolor)
                params.selcolor=repmat(params.selcolor(1),[size(tb2,1) 1]);
            else
                params.selcolor=repmat({params.selcolor},[size(tb2,1) 1]);
            end
        end
        params.selcolor=[params.selcolor(1);params.selcolor];%header
    else
        params.selcolor=repmat({'00ff00'},[size(tb2,1) 1]) ;
    end

    params.color=cellfun(@(a){['#' regexprep(a,'#','')]} ,params.color);
    params.bgcolor=cellfun(@(a){['#' regexprep(a,'#','')]} ,params.bgcolor);
    params.selcolor=cellfun(@(a){['#' regexprep(a,'#','')]} ,params.selcolor);



  colergen = @(color,bgcolor,text) ['<html><color="',color,'",bgcolor="',bgcolor,'"><b>',text,'</b></html>'];
    for i=1:size(tb2,1)
        for j=1:size(tb2,2)
            %             tbsel{i,j}=colergen('#ffcccc',[tb2{i,j}(1:end-2) 'x]' ] );
            %            tbsel{i,j}=colergen('#FFD700',[tb2{i,j}(1:end-2) 'x]' ] );
            %            tbunsel{i,j}=colergen('#FFFFFF',[tb2{i,j}(1:end-2) ' ]' ] );
            tbsel{i,j}  =colergen(params.selcolor{i},    params.bgcolor{i}  ,[ '[x' tb2{i,j}(3:end)  ] );
            tbunsel{i,j}=colergen(params.color{i}, params.bgcolor{i} ,[ '[ ' tb2{i,j}(3:end)  ] );
        end
    end   
end




% data = {  2.7183        , colergen('#FF0000','Red')
%          'dummy text'   , colergen('#00FF00','Green')
%          3.1416         , colergen('#0000FF','Blue')
%          }
% uitable('data',data)

%% ________________________________________________________________________________________________

% tbunsel=strrep(tbunsel,'[','')
% tbunsel=strrep(tbunsel',']','')


head=tbunsel{1};
tbunsel=tbunsel(2:end);
tbsel=tbsel(2:end);
tb=tb(2:end);
tb2=tb2(2:end);

%% ________________________________________________________________________________________________


us.row=1;
% us.tb2=tb2;
% us.tb0=tb2;
us.tbsel=tbsel;

us.tbunsel  =tbunsel;
us.tb2      =tbunsel;
us.tb0      =tbunsel;
us.sel=zeros(size(tb2,1),1);

%  tb2=us.tbsel;

if ~isempty(find(strcmp(listfonts,'Courier New')))
    font='courier New';
else
    font='Courier';
end

if isfield(params,'title')==0 %TITLE
    params.title='SELECTOR: use contextmenus for selectrionMode';
end

try; delete( findobj(0,'TAG','selector'));end

fg; set(gcf,'units','norm','position', [0.0778    0.0772    0.5062    0.8644]);
set(gcf,'name',params.title,'NumberTitle','off','KeyPressFcn',@keypress);
if isfield(params,'title')
   set(gcf,'name',params.title); 
end
set(gcf,'userdata',us,'menubar','none','TAG','selector');

t=uicontrol('Style','listbox','units','normalized',         'Position',[0 .1 1 .9]);
set(t,'string',tbunsel,'fontsize',14);
set(t,'max',100,'tag','lb1');
% set(t,'Callback',@tablecellselection,'backgroundcolor','w','KeyPressFcn',@keypress);
set(t,'backgroundcolor','w','KeyPressFcn',@keypress);

set(t,'Callback',@buttonDown);
set(t,'fontname',font);


% set(gcf,'ButtonDownFcn',@buttonDown);


% jScrollPane = findjobj(t); % get the scroll-pane object
% jListbox = jScrollPane.getViewport.getComponent(0);
% set(jListbox, 'SelectionBackground',java.awt.Color.yellow); % option #1
% set(jListbox, 'SelectionBackground',java.awt.Color(0.2,0.3,0.7)); % option #2

%______________CONTEXTMENU__________________________________
ctx=uicontextmenu;
uimenu('Parent',ctx,'Label','select/unselect this [s]',  'callback',@selecthighlighted);
uimenu('Parent',ctx,'Label','select all [a]',   'callback',@selectall,'separator','on');
uimenu('Parent',ctx,'Label','deselect all [d]', 'callback',@deselectall);
uimenu('Parent',ctx,'Label','find & select [f]','callback',@findAndSelect,'separator','on');
if isfield(params,'contextmenu')
   for i=1:size(params.contextmenu,1)
      uimenu('Parent',ctx,'Label',params.contextmenu{i,1},'callback',params.contextmenu{i,2},...
          'foregroundcolor',[0.4667    0.6745    0.1882],'tag',['cm' num2str(i)]); 
   end
end

% Menu3=uimenu('Parent',ContextMenu,...
%     'Label','Menu Option 3');
set(t,'UIContextMenu',ctx);
% get(MyListbox,'UIContextMenu') 

fontsize=8;

p=uicontrol('Style','pushbutton','units','normalized',         'Position',[.85 .05 .1 .02],'tag','pb1');
set(p,'string','OK','callback',@ok,'fontsize',fontsize);

p=uicontrol('Style','pushbutton','units','normalized',         'Position',[.85 .03 .1 .02],'tag','pbcancel');
set(p,'string','Cancel','callback',@pbcancel,'fontsize',fontsize);

p=uicontrol('Style','text','units','normalized',              'Position',[.85 .07 .1 .02],'tag','txtbusy');
set(p,'string','busy..wait..','foregroundcolor','r','backgroundcolor','w','fontsize',fontsize-1,'fontweight','bold');



if isfield(params,'help')
    p=uicontrol('Style','pushbutton','units','normalized',         'Position',[.75 .05 .1 .02],'tag','pb5');
    set(p,'string','help','callback',@hlp,'fontsize',fontsize);
end


p=uicontrol('Style','pushbutton','units','normalized',         'Position',[.55 .05 .1 .02],'tag','pb2');
set(p,'string','select all','callback',{@selectallButton},'fontsize',fontsize);
p=uicontrol('Style','pushbutton','units','normalized',         'Position',[.55 .03 .1 .02],'tag','pb3');
set(p,'string','deselect all','callback',{@deselectallButton},'fontsize',fontsize);
p=uicontrol('Style','popupmenu','units','normalized',         'Position' ,[.55 .01 .1 .02],'tag','pb4','tag','pop');

if params.finder==1
    px=uicontrol('Style','pushbutton','units','normalized',         'Position',[.65 .05 .1 .02],'tag','pb10');
    set(px,'string','select specific','callback',{@selectspecificButton},'fontsize',fontsize);
end

sortstr=['selectedID'; 'ID' ; header(:);];
sortstr=cellfun(@(a,b) {['sort after [c' num2str(b) '] [' a ']' ]}, [sortstr ], num2cell([1:length(sortstr) ]'));
sortstr(end+1,1)= {'sort after my specification'};

 
 
 
set(p,'string',sortstr,'callback',{@sorter},'fontsize',fontsize);

% set(p,'string',cellfun(@(a) {['sort after [' a ']' ]}, ['selectedID'; 'ID' ; header(:)]) ,'callback',{@sorter},'fontsize',fontsize);

p=uicontrol('Style','checkbox','units','normalized',         'Position' ,[.52 .01 .02  .02],'tag','pb4','backgroundcolor','w',...
    'tooltipstring', '[check this] to descend sorting','tag','cbox1','callback',{@sorter});

% p=uicontrol('Style','pushbutton','units','normalized',         'Position',[.55 .01 .1 .02],'tag','pb4');
% set(p,'string','help','callback',{@help},'fontsize',fontsize);

p=uicontrol('Style','edit','units','normalized',         'Position',[.1 .03 .4 .05],'tag','tx1','max',2);
txtinfo={        ['selected objects   : '  num2str(sum(us.sel,1))  '/' num2str(size(us.sel,1))   ]   };
txtinfo{end+1,1}=[' '];
txtinfo{end+1,1}=['highlighted objects: 1'];
txtinfo{end+1,1}=['selectionType: '  upper(params.selection) '-selection'];



set(p,'position',[0 0 .5 .1]);

if exist('colinfo'); if ischar(colinfo)    txtinfo{2}=colinfo   ;end;end
addi={};
addi{end+1,1}=['=============== SHORTCUTS & INFO ==============='];
addi{end+1,1}=[' [+/-] change fontsize'];
addi{end+1,1}=[' [s]      or [f1]   UN/SELECT highlighted objects '];
addi{end+1,1}=[' [return] or [f2]   OK & FINNISH                 '];
addi{end+1,1}=[' [d]      or [f3]  DESELECT ALL objects'];
addi{end+1,1}=[' [a]      or [f4]  SELECT ALL objects'];
addi{end+1,1}=[' [f]               FIND & SELECT'];
addi{end+1,1}=[' [doubleclick ] to un/select; [shift&click] for multiselection '];
addi{end+1,1}=[' see also contextmenu'];


txtinfo=[txtinfo; addi];

set(p,'userdata',txtinfo, 'string',    txtinfo   ,'fontsize',6,'backgroundcolor','w',...
    'fontname',font,'horizontalalignment','left');
try;
    set(p,'tooltipstr',sprintf(strjoin('\n',txtinfo)));
end

set(findobj(gcf,'tag','lb1'),'fontsize',8);
set(findobj(gcf,'tag','lb1'),'fontsize',8);



jListbox = findjobj(findobj(gcf,'tag','lb1'));
jListbox=jListbox.getViewport.getComponent(0);
jListbox.setSelectionAppearanceReflectsFocus(0);

drawnow;
jScrollPane = findjobj(findobj(gcf,'tag','lb1')); % get the scroll-pane object
jListbox = jScrollPane.getViewport.getComponent(0);

%%
v=[ 0.4667    0.6745    0.1882];%color
% v=uisetcolor
set(jListbox, 'SelectionForeground',java.awt.Color(v(1),v(2),v(3))); % java.awt.Color.brown)
% set(jListbox, 'SelectionForeground',java.awt.Color(v(1),v(2),v(3))); % java.awt.Color.brown)
set(jListbox, 'SelectionBackground',java.awt.Color(v(1),v(2),v(3))); % option #2


us.jTable=jListbox;
us.Table =findobj(gcf,'tag','lb1');


lb1=findobj(gcf,'style','listbox');
set(lb1,'position',[ 0    0.1000    1.0000    0.88000]);
% 
p2=uicontrol('Style','listbox','units','normalized',  ...
    'Position',[ 0    0.98    1.0000    .02],'tag','lb2');
% la=header
% str=get(lb1,'string');
% str=str{1}
% 
% for i=1:length(header)
%    str=strrep(str,tb{1,i+1},header{i} ) 
% end
% head=strrep(head,'[ ]&nbsp;0]&nbsp;' ,repmat('&nbsp;',[1 7 ]));
head=strrep(head,'[ ]' ,repmat('&nbsp;',[1 3 ]));
head=strrep(head,'0]' ,repmat('&nbsp;',[1 2 ]));

set(p2,'string',head);
set(p2,'enable','off');

set(findobj(gcf,'tag','lb1'),'fontname',font,'fontsize',8);
set(findobj(gcf,'tag','lb2'),'fontname',font,'fontsize',8);



if isfield(params,'position')
   set(gcf,'position',params.position); 
end

%% ________________________________________________________________________________________________

us.lb1=findobj(gcf,'tag','lb1');
us.lb2=findobj(gcf,'tag','lb2');
us.jlb1 = findjobj(us.lb1);
us.jlb2 = findjobj(us.lb2);


us.jlb1.AdjustmentValueChangedCallback=@sliderSinc;

us.ok=1;
set(findobj(gcf,'tag','txtbusy'),'visible','off');
%% ________________________________________________________________________________________________



us.params=params;
set(gcf,'userdata',us);
set(gcf,'currentobject',findobj(gcf,'tag','lb1'));
uicontrol(findobj(gcf,'tag','lb1'));%set focus

if isfield(params,'position')
    set(gcf,'position',params.position);
end


%% SINGLE/MULTISELECTION
if strcmp(us.params.selection,'single')
    t=findobj(gcf,'tag','lb1');
    set(t,'Max',1);
end
%% WAIT-check
if isfield(params,'iswait')
    iswait=params.iswait;
end

%% wait here
if iswait==1
   uiwait(gcf);
%    return
  hfig= findobj(0,'TAG','selector');
  if isempty(hfig); return; end
    us=get(gcf,'userdata');
    id=find(us.sel==1);
    if ~isempty(id)
       
        dm=us.raw(id,:);
        ids=str2num(cell2mat(dm(:,1)));
        dm2=sortrows([ num2cell(ids) dm(:,2:end)],1);
        
        ids                 =cell2mat(dm2(:,1));
        varargout{1}        =dm2(:,2:end);
        
        if isfield(params,'out')
            if strcmp(params.out,'list')
                ids         =dm2(:,2:end);
               varargout{1} =cell2mat(dm2(:,1));
            elseif  strfind(params.out,'col')
                column=str2num(regexprep(params.out,'col-','','ignorecase'));
                 ids         =dm2(:,column+1);
               varargout{1} =cell2mat(dm2(:,1));
            end
        end
        
    else
        ids=[];
        varargout={};
    end
    
    if us.ok==0
        ids=-1;
    end
        
    
    close(gcf);
end
return
%% ________________________________________________________________________________________________

function [ids varargout]=getid
varargout={};
ids=[];
hs=findobj(0,'tag','selector');
us=get(hs,'userdata');
params=us.params;
    id=find(us.sel==1);
    if ~isempty(id)
      
        dm=us.raw(id,:);
        ids=str2num(cell2mat(dm(:,1)));
        dm2=sortrows([ num2cell(ids) dm(:,2:end)],1);
        
        ids                 =cell2mat(dm2(:,1));
        varargout{1}        =dm2(:,2:end);
        
        if isfield(params,'out')
            if strcmp(params.out,'list')
                ids         =dm2(:,2:end);
               varargout{1} =cell2mat(dm2(:,1));
            elseif  strfind(params.out,'col')
                column=str2num(regexprep(params.out,'col-','','ignorecase'));
                 ids         =dm2(:,column+1);
               varargout{1} =cell2mat(dm2(:,1));
            end
        end
        
    else
        ids=[];
        varargout={};
    end

%% ________________________________________________________________________________________________
function sliderSinc(h,e)
hfigselector=findobj(0,'tag','selector');
us=get(hfigselector,'userdata');
r1=get(us.jlb1,'HorizontalScrollBar');
val=get(r1,'Value');
r2=get(us.jlb2,'HorizontalScrollBar');
set(r2,'Value',val);

function buttonDown_old(h,ev,ro)
us=get(gcf,'userdata');
us.row=get(findobj(gcf,'tag','lb1'),'value');
% get(gcf,'selectiontype')
% return
persistent chk
persistent lbval
if isempty(chk)
    chk = 1;
    lbval=get(findobj(gcf,'tag','lb1'),'value');
    %% update HIGHLIGHTED
    htx=findobj(gcf,'tag','tx1');
    tx=get(htx,'string');
    tx{3}=['highlighted objects: '  num2str(length(lbval))];
    set(htx,'string',tx);
    set(htx,'tooltipstr',sprintf(strjoin('\n',tx)));
    
    pause(0.25); %Add a delay to distinguish single click from a double click
    if chk == 1
        %         fprintf(1,'\nI am doing a single-click.\n\n');
        chk = [];
    end
else
    chk = [];
    try
        if get(findobj(gcf,'tag','lb1'),'value')==lbval
            %      fprintf(1,'\nI am doing a DOUBLE-click.\n\n');
            ee=[]; ee.Key='s';  %SELECT
            ee.Character='';
            keypress([],ee);
        end
    end
end

function buttonDown(h,ev,ro)
us=get(gcf,'userdata');
us.row=get(findobj(gcf,'tag','lb1'),'value');

mode=get(gcf,'selectiontype');
% disp(['mouseMode: ' mode]);
if strcmp(mode,'normal')%% update HIGHLIGHTED
    lbval =get(findobj(gcf,'tag','lb1'),'value');
    htx   =findobj(gcf,'tag','tx1');
    tx    =get(htx,'string');
    tx{3} =['highlighted objects: '  num2str(length(lbval))];
    set(htx,'string',tx);
    set(htx,'tooltipstr',sprintf(strjoin('\n',tx)));
    
elseif strcmp(mode,'open')
    try
        lbval=get(findobj(gcf,'tag','lb1'),'value');
        if get(findobj(gcf,'tag','lb1'),'value')==lbval
            %      fprintf(1,'\nI am doing a DOUBLE-click.\n\n');
            keypress([],struct('Key','s','Character',''));
        end
    end
end




function keypress(h,ev)
    % Callback to parse keypress event data to print a figure
    if ev.Character == '+'
        lb=findobj(gcf,'tag','lb1');
        lb2=findobj(gcf,'tag','lb2');
        fs= get(lb,'fontsize')+1;
        if fs>1; 
            set(lb,'fontsize',fs); 
            set(lb2,'fontsize',fs); 
        end
    elseif ev.Character == '-'
            lb=findobj(gcf,'tag','lb1');
                    lb2=findobj(gcf,'tag','lb2');
        fs= get(lb,'fontsize')-1;
        if fs>1; 
            set(lb,'fontsize',fs); 
            set(lb2,'fontsize',fs); 
        end
    end
    if strcmp(ev.Key,'s') || strcmp(ev.Key,'f1') %SELECTION
       get(findobj(gcf,'tag','lb1'),'value');
        tablecellselection(nan,nan);
    elseif strcmp(ev.Key,'d')  || strcmp(ev.Key,'f3')    %DESELECT 
        selectthis([],0);
    elseif strcmp(ev.Key,'a')  || strcmp(ev.Key,'f4')    %SELECT ALL 
           selectthis([],1);
    elseif strcmp(ev.Key,'b') %set BROWSER
        us=get(gcf,'userdata');
        if isfield(us,'showinbrowser')==0
            us.showinbrowser=0;
            set(gcf,'userdata',us);
             us=get(gcf,'userdata');
        end
        if     us.showinbrowser==1; us.showinbrowser=0;
        elseif us.showinbrowser==0; us.showinbrowser=1;
        end
        set(gcf,'userdata',us);
 elseif strcmp(ev.Key,'f') %find
        findAndSelect
    elseif strcmp(ev.Key,'rightarrow')
        us=get(gcf,'userdata');
        r1=get(us.jlb1,'HorizontalScrollBar');
        val=get(r1,'Value');
        set(r1,'Value',val+150);
        sliderSinc
     elseif strcmp(ev.Key,'leftarrow')
        us=get(gcf,'userdata');
        r1=get(us.jlb1,'HorizontalScrollBar');
        val=get(r1,'Value');
        set(r1,'Value',val-150);
        sliderSinc     
       elseif strcmp(ev.Key,'return') || strcmp(ev.Key,'f2')   %RETURN 
        hgfeval(get(findobj(gcf,'tag','pb1'),'callback'));

    end
    
    
    
    
    for i=1:10
       id=findobj(gcf,'tag', ['cm' num2str(i)]);
       if ~isempty(id)
           if strcmp(ev.Key,num2str(i))
               hgfeval(get(id,'callback'));
           end
       end
    end
    
    
    
    set(gcf,'currentch',char(71)) ;

%% BUTTONS
function selectallButton(dum,dum2)
set(findobj(findobj(0,'tag','selector'),'tag','txtbusy'),'visible','on');drawnow;
selectthis([],1);
set(findobj(findobj(0,'tag','selector'),'tag','txtbusy'),'visible','off');drawnow;

function deselectallButton(dum,dum2)
set(findobj(findobj(0,'tag','selector'),'tag','txtbusy'),'visible','on');drawnow;
selectthis([],0);
set(findobj(findobj(0,'tag','selector'),'tag','txtbusy'),'visible','off');drawnow;


function sorter(dum,dum2)
sortlist

function sortlist;

pop=findobj(gcf,'tag','pop');
% sortcol=get(dum,'value');
sortcol=get(pop,'value');
us=get(gcf,'userdata');

cbox=findobj(gcf,'tag','cbox1');

dat=[num2cell(us.sel) us.raw ];

sortlist=get(pop,'string');
if cellfun('isempty',regexpi(sortlist(sortcol), 'my specification' ));
    [~, ix]=sortrows(dat,sortcol);
else
    
    prompt =upper( {'enter one/more column-indizes (numeric values) to sort the data '});
    prompt=[prompt;{'---------------------------------------------------------------'}];
    prompt=[prompt;{'example:  [7 6 14] will sort: first after [c7] [MRseq] than '}];
    prompt=[prompt;{'            after [c6] [PrcNo], than after  [c14] [CoreDim] '}];
    prompt=[prompt;{'---------------------------------------------------------------'}];
    prompt=[prompt;{'USE INDICES (c-number) FROM LIST BELOW'}];
    prompt=[prompt;{'---------------------------------------------------------------'}];
    prompt=[prompt; regexprep(sortlist(cellfun('isempty',regexpi(sortlist, 'my specification' ))),'sort after ','')];
    prompt2 = char(prompt);
    dlg_title = 'SORT: USER SPECIFIED';
    num_lines = 1;
    defaultans = {''};
    answer = inputdlg(prompt2,dlg_title,num_lines,defaultans);
    if isempty(answer{1}); return; end
    sortcol=str2num(answer{1});
    [~, ix]=sortrows(dat,sortcol);
    
    
    
end

us.raw=us.raw(ix,:);
% [us.raw ix]=sortrows(us.raw,sortcol);
info='ascending';
if get(cbox,'value')==1
    us.raw=flipud(us.raw);
    ix=flipud(ix);
  info='descending';  
else

end
us.tbsel   =us.tbsel(ix);
us.tbunsel =us.tbunsel(ix);
us.tb2     =us.tb2(ix);
try
 us.tb     =us.tb(ix);
end
us.sel     =us.sel(ix);

% ---bug#1--
us.tb0=us.tb0(ix);
% ---

lb1=findobj(gcf,'tag','lb1');
list=get(lb1,'string');
set(lb1,'string',list(ix));
set(gcf,'userdata',us);

tx1=findobj(gcf,'tag','tx1');
str2=get(tx1,'string');
sortstrHeader=['selectdID'; us.header];
str2{2,1}=['sorting: ['  sortstrHeader{sortcol} '] >>' info];
set(tx1,'string',str2);
if ~isempty(find(us.sel))
    set(us.Table,'value',find(us.sel));
end


function hlp(t,b)
us=get(gcf,'userdata');
% us.params;
uhelp(us.params.help,1);
drawnow;
try
    set(findobj(gcf,'tag','txt'),'backgroundcolor','w');
end
set(gcf,'position',[0.7278    0.5561    0.2701    0.3372]);

function ok(t,b)
uiresume(gcf);
%% internal funs

function pbcancel(t,b);
us=get(gcf,'userdata');
us.ok=0;
set(gcf,'userdata',us);
uiresume(gcf);

function findAndSelect_preselect(h,e)

us=get(gcf,'userdata');
hp1=findobj(gcf,'tag','hp1');
va=get(hp1,'value');
li=get(hp1,'string');
col=li{va};
icol=regexpi2(us.header,col);

list2=unique(us.raw(:,icol));
list2=[{''};list2];
hp2=findobj(gcf,'tag','hp2');
set(hp2,'value',1);
set(hp2,'string',list2);
% keyboard


function findselect_cb(h,e,task)

if task==4 %close
     delete(findobj(gcf,'tag','hpa'));
elseif task==3%cancel
    delete(findobj(gcf,'tag','hpa'));
elseif task==2 %help
   h={' #yg  ***FIND and SELECT ***'} ;
   h{end+1,1}=[' ## 1. chose the column of interest from upper pulldown menu '];
   h{end+1,1}=[' ## 2a.EXPLICIT SINGLE-SELECTION'];
   h{end+1,1}=[' -select content of this column from lower pulldown menu'];
   h{end+1,1}=['   ... or ...'];
   h{end+1,1}=[' ## 2b. STRING-SEARCH SINGLE OR MULTI-SELECTION'];
   h{end+1,1}=['- type substring or several substrings separated by vertical bar or comma "epi | rare |flash " ...' ];
   h{end+1,1}=['  -EXAMPLE:  search for all Epi , RARE & FLASH sequences:     "  ' ];
   h{end+1,1}=['  - type      :     "epi | rare |flash "      ' ];
   h{end+1,1}=['  -this equals:     " Epi , rare,FLASH     "  ' ];
   h{end+1,1}=[' #### **NOTE***' ];
   h{end+1,1}=['  -case sensitivity and spaces will be IGNORED ! ' ];
   uhelp(h,1);
   %pos=get(gcf,'position');
   set(gcf,'position',[ 0.55    0.7272    0.45   0.1661 ]);
elseif task==1 %ok
    us=get(gcf,'userdata');

   hp1=findobj(gcf,'tag','hp1') ;
   hp2=findobj(gcf,'tag','hp2');
   hp3=findobj(gcf,'tag','hp3');
   %COLUMN
   va=get(hp1,'value');
   li=get(hp1,'string');
   col=li{va};
   icol=regexpi2(us.header,col);
   %VALUE
   va=get(hp2,'value');
   li=get(hp2,'string');
   str=li{va};
   %FREEVALUE
   str2=get(hp3,'string');
   str2=regexprep(regexprep(str2,'\s',''),',','|');
   
   if ~isempty(str2)
       str=str2;
   end
       
   
   
  id2sel= regexpi2(us.raw(:,icol), str);
  lb1=findobj(gcf,'tag','lb1');
  set(lb1,'value',id2sel);
 selectthis([],2);
  
   
   
end
set(findobj(gcf,'tag','lb1'),'enable','on');


function findAndSelect(t,b)
% set(findobj(gcf,'tag','lb1'),'enable','off');
us=get(gcf,'userdata');

         
hpa=uipanel('title','find&select','units','normalized','position',    [.2 .5 .6 .2],'tag','hpa');



ht1=uicontrol('parent',hpa,'style','text',     'units','normalized','position',[.0 .8 .35 .2],'tag','ht1','string','In column ..',...
    'HorizontalAlignment','right');
hp1=uicontrol('parent',hpa,'style','popupmenu','units','normalized','position',[.4 .8 .6 .2],'tag','hp1','string',us.header,...
    'callback',@findAndSelect_preselect);


ht2=uicontrol('parent',hpa,'style','text',     'units','normalized','position',[.0 .5 .35 .2],'tag','ht2','string','..either choose and select ..',...
    'HorizontalAlignment','right');
hp2=uicontrol('parent',hpa,'style','popupmenu','units','normalized','position',[.4 .5 .6 .2],'tag','hp2','string',{'a','s','f'});


ht3=uicontrol('parent',hpa,'style','text',     'units','normalized','position',[.0 .4 .35 .15],'tag','ht3','string','..or type substring(s)->see help.',...
    'HorizontalAlignment','right');
hp3=uicontrol('parent',hpa,'style','edit',     'units','normalized','position',[.4 .4 .6 .15],'tag','hp3','string','');



% jCombo = findjobj(hp2);
% jCombo.setEditable(true);
pb1=uicontrol('parent',hpa,'style','pushbutton','units','norm',      'position',[.0 .15 .2 .15],'tag','hpb1','string','OK & select','callback',{@findselect_cb,1});
pb2=uicontrol('parent',hpa,'style','pushbutton','units','norm',      'position',[.4 .15 .2 .15],'tag','hpb2','string','Help','callback',{@findselect_cb,2});
pb3=uicontrol('parent',hpa,'style','pushbutton','units','norm',      'position',[.8 .15 .2 .15],'tag','hpb3','string','Cancel','callback',{@findselect_cb,3});
pb4=uicontrol('parent',hpa,'style','pushbutton','units','norm',      'position',[.0 .0  .2 .15],'tag','hpb4','string','Close','callback',{@findselect_cb,4});



findAndSelect_preselect;

function selecthighlighted(t,b)
selectthis(t,2);

function deselectall(t,b)
selectthis(t,0);

function selectall(t,b)
selectthis(t,1);

function tablecellselection(t,b)
selectthis(t,2);





function selectspecificButton(t,b)
t=findobj(gcf,'tag','lb1');
us=get(gcf,'userdata');


raw=us.raw;
he =us.header;

for i=1:length(he)
  uni(i)={ unique(raw(:,i))};
end
try;delete(findobj(0,'tag','selectspecific')); end
fg;
set(gcf,'menubar','none','tag','selectspecific','name','FINDER');

ph=uicontrol('Style', 'text','units','norm',...
        'String', 'FIND SPECIFIC ITEMS',...
        'Position', [0.5 .9 .3 .05],'backgroundcolor','w','fontweight','bold',...
        'fontsize',10); 
    
    

uicontrol('Style', 'text','units','norm',...
        'String', 'COLUMN',...
        'Position', [0.01 .8 .3 .05],'backgroundcolor','w','fontweight','bold'); 
uicontrol('Style', 'text','units','norm',...
        'String', 'nested column',...
        'Position', [.25 .8 .1 .05],'backgroundcolor','w','fontweight','bold','fontsize',6);     
    
uicontrol('Style', 'text','units','norm',...
        'String', 'Observed',...
        'Position', [0.4 .8 .4 .05],'backgroundcolor','w','fontweight','bold');    
uicontrol('Style', 'text','units','norm',...
        'String', 'Selected',...
        'Position', [0.7 .8 .4 .05],'backgroundcolor','w','fontweight','bold');        
    
for i=1:length(he)
    pt(i) = uicontrol('Style', 'text','units','norm',...
        'String', he{i},...
        'Position', [0.00 .8-i*0.05 .3 .05]);
     pr(i) = uicontrol('Style', 'radio','units','norm',...
        'String', '',...
        'Position', [0.3 .8-i*0.05 .05 .05],'fontsize',6);
    
  pp(i) = uicontrol('Style', 'popup','units','norm',...
                   'String', uni{i},'tag',['pulldown' num2str(i) ], ...
                   'Position', [0.4 .8-i*0.05 .3 .05],...
                   'callback',@pulldown2editbox);
  pe(i) = uicontrol('Style', 'edit','units','norm',...
                   'String', '','tag',['edit' num2str(i) ], ...
                   'Position', [0.7 .8-i*0.05 .3 .05]);        
end

set(pr(2),'value',1);


px=uicontrol('Style', 'pushbutton','units','norm',...
        'String', 'Find',...
        'Position', [0.01 .01 .1 .05],'fontweight','bold','callback',@selectspecific_find); 
px=uicontrol('Style', 'pushbutton','units','norm',...
        'String', 'Help',...
        'Position', [0.2 .01 .1 .05],'fontweight','bold','callback',@selectspecific_help); 
px=uicontrol('Style', 'pushbutton','units','norm',...
        'String', 'Close',...
        'Position', [0.4 .01 .1 .05],'fontweight','bold','callback',@selectspecific_cancel);
px=uicontrol('Style', 'pushbutton','units','norm',...
        'String', 'clear all fields',...
        'Position', [0.7 .8-i*0.05-0.05 .25 .05],'fontweight','bold','callback',@selectspecific_clear);

px=uicontrol('Style', 'text','units','norm',...
        'String', ['0/' num2str(size(raw,1)) ' items found'],'foregroundcolor',[1 0 0],...
        'Position', [0.7 .01 .25 .05],'fontweight','bold','backgroundcolor','w','tag', 'txtNitemsFound' );
     

uv.pt=pt;
uv.pr=pr;
uv.pp=pp;
uv.pe=pe;
uv.uni=uni;
set(gcf,'userdata',uv);

function selectspecific_clear(e,e2)
uv=get(gcf,'userdata');
set(uv.pe,'string','');

function pulldown2editbox(e,e2)
pe=findobj(gcf,'tag', strrep(get(e,'tag'),'pulldown','edit'));
str=get(e,'string');
set(pe,'string',str{get(e,'value')});

function selectspecific_cancel(e,e2)
close(gcf);
function selectspecific_help(e,e2)
 

function selectspecific_find(e,e2)
uv=get(gcf,'userdata');
us=get(findobj(0,'tag','selector'),'userdata');
lg2=get(uv.pe,'string');
% % % % test
% % % lg2{5}='end';

ispecific=find(cellfun('isempty',regexpi(lg2,'^end|end$'))==0);
lg3=lg2;
if ~isempty(ispecific)
    lg3(ispecific)={''};
end

%search
raw=us.raw;
 for i=1:length(lg3)
     if ~isempty(lg3{i})
         ix=find(cellfun('isempty', regexpi(raw(:,i),lg3{i}))==0);
        raw =raw(ix,:);
        disp([i size(raw) ]);
     end
 end
 
inestedsearch=find(cell2mat(get(uv.pr,'value')));
 %search nested
 if ~isempty(inestedsearch)
     rawnest={};
      unid=unique(raw(:,inestedsearch ));
      for i=1:length(unid)
          bl=raw(regexpi2(raw(:,inestedsearch ),unid(i) ),:);
          
          if ~isempty(ispecific)
              for j=1:length(ispecific)
                  bfield=bl(:,ispecific(j));
                  bsearch=lg2{ispecific(j)};
                  
                  numeric= str2num(char(bfield));
                  if ~isempty(numeric);
                      bfield=numeric;
                     [~,isort] =sort(bfield);
                     bl=bl(isort,:);
                  end
                  vec=1:size(bl);
                  try
                  eval(['itake=vec(' bsearch ');']);
                  catch
                   disp(['### the index/item:["' bsearch '"] was not found in this nested subdata: ']);
                   disp(['subdata:   [..size' num2str(size(bl)) ']']);
                   disp(bl);
                  end
                  bl=bl(itake,:);
                  rawnest=[rawnest; bl];
              end
          else
             rawnest=[rawnest; bl];  
          end
      end
 end
 
 if ~isempty(inestedsearch)
     use=rawnest;
 else
     use=raw;
 end
  
  % find in Listbox
 hfigselector=findobj(0,'tag','selector');
 hlb=findobj(hfigselector,'tag','lb1');
  str=get(hlb,'string');
str=strrep(str, '<html><bgcolor=#FFFFFF><b>[ ]&nbsp;','');
str=strrep(str, '<html><bgcolor=#FFD700><b>[x]&nbsp;','');
str=strrep(str, '&nbsp;',' ');

ids=[];
for i=1:size(use,1)
   ids=[ids; regexpi2(str,[use{i,1} ']'])] ;
end
set(hlb,'value',ids);

hmsg=findobj(findobj(0,'tag','selectspecific'),'tag','txtNitemsFound');
set(hmsg,'string',[ num2str(length(ids)) '/' num2str(size(us.raw,1)) ' items found' ] );

% try;delete(findobj(0,'tag','selectspecific')); end

drawnow;
figure(hfigselector);
drawnow
selectthis([],2);


function selectthis(t,mode)

% set(findobj(gcf,'tag','txtbusy'),'visible','on');
set(findobj(findobj(0,'tag','selector'),'tag','txtbusy'),'visible','on');drawnow;
 
us=get(gcf,'userdata');
t=us.Table; %t=findobj(gcf,'tag','lb1');

% value=get(t,'value');
value=get(t,'value');
if mode==0
    idx=1:size(get(t,'string'),1);
elseif mode==2  %..highlighted in listbox  %%sinlge selection via 's'
    idx=value;%get(t,'value');
elseif mode==1
    idx=1:size(get(t,'string'),1);
end

if strcmp(us.params.selection,'single')
    if mode~=0
        idx=value(1);
    end
end

%% sorting case
% idreal=str2num(char(us.raw([idx],1)))

if mode==2
    set(findobj(findobj(0,'tag','selector'),'tag','txtbusy'),'visible','on');drawnow;
    for i=1:length(idx)
        this=idx(i);
        
        if us.sel(this)==0  %selected for process NOW
            us.sel(this)=1;
            us.tb2(this,:)=us.tbsel(this,:);
        else%deSelect
            us.sel(this)=0;
            %us.tb2(this,:)=us.tb0(this,:);
            us.tb2(this,:)=us.tbunsel(this,:);
        end
    end
elseif mode==1
    us.sel=us.sel.*0+1;
    us.tb2=us.tbsel;
elseif mode==0
    us.sel=us.sel.*0;
    us.tb2=us.tb0;
end

if strcmp(us.params.selection,'single') && mode~=0
     us.sel=us.sel.*0;
    us.tb2=us.tb0;
    
    for i=1:length(idx)
        this=idx(i);
        if us.sel(this)==0  %selected for process NOW
            us.sel(this)=1;
            us.tb2(this,:)=us.tbsel(this,:);
        else%deSelect
            us.sel(this)=0;
            %us.tb2(this,:)=us.tb0(this,:);
            us.tb2(this,:)=us.tbunsel(this,:);
        end
    end
end

set(gcf,'userdata',us);

    
%% infobox
tx=findobj(gcf,'tag','tx1') ;


txinfo=get(tx,'userdata');
txinfo(1) ={ [ 'selected objects   :  ' num2str(sum(us.sel,1))  '/' num2str(size(us.sel,1))   ' objects selected']   };
set(tx,'string',txinfo,'value',[]);

try;
    set(tx,'tooltipstr',sprintf(strjoin('\n',txinfo)));
end
    
   % ---------remember scrolling--------------------
% http://www.mathworks.com/matlabcentral/newsreader/view_thread/307912
% try
%         hTable=t; %hTable=findobj(gcf,'tag','lb1');
%         jTable = findjobj(hTable); % hTable is the handle to the uitable object  
%     jScrollPane = jTable.getComponent(0);
%     javaObjectEDT(jScrollPane); % honestly not sure if this line matters at all
%     currentViewPos = jScrollPane.getViewPosition; % save current position
% end
ltop=get(t,'ListboxTop');
% disp('LTOP used')
set(t,'string',us.tb2);
% ---------remember scrolling-II--------------------
% try
%     drawnow; % without this drawnow the following line appeared to do nothing
%     jScrollPane.setViewPosition(currentViewPos);% reset the scroll bar to original position
% end 
    
set(t,'value',value);
us.row=value;
set(gcf,'userdata',us);
set(t,'ListboxTop',ltop);

if 0
    % ---------remember scrolling-I--------------------
    % http://www.mathworks.com/matlabcentral/newsreader/view_thread/307912
    try
        hTable =us.lb1;
        jTable =us.jTable;
        jScrollPane = jTable.getComponent(0);
        javaObjectEDT(jScrollPane); % honestly not sure if this line matters at all
        currentViewPos = jScrollPane.getViewPosition; % save current position
    end
    % ---------remember scrolling-II--------------------
    try
        drawnow; % without this drawnow the following line appeared to do nothing
        jScrollPane.setViewPosition(currentViewPos);% reset the scroll bar to original position
    end
end

    

if isfield(us.params,'selfun')
   hgfeval(us.params.selfun);
end

set(findobj(findobj(0,'tag','selector'),'tag','txtbusy'),'visible','off');







