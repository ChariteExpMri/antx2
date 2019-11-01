
%% selectionGUI using multiple cells
% function ids=selector(tb)
% function ids=selector2(tb,colinfo,varargin)

% pairwise varargins
% 'iswait'      :  0/1      : [0] for debugging modus
% 'out'         : 'list'    : first outputargument is the selected list (tb) not the selected indices
% 'out'         : 'col-id'   : first outputargument is the specified column, example 'col-2'-->get column 2

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
% tb={   '20150908_101706_20150908_FK_C1M02_1_1\…'    '4.1943'    '08-Sep-2015 10:45:06'    'RARE'
%        '20150908_102727_20150908_FK_C1M04_1_1\…'    '4.1943'    '08-Sep-2015 10:45:12'    'RARE'
% '20150908_102727_20150908_FK_C1M064_1_1\…'    '4.1943'    '08-Sep-2015 10:45:12'    'RARE'
% '20150908_102727_20150908_FK_C1M043_1_1\…'    '4.1943'    '08-Sep-2010 10:45:12'    'RARE'
% '20150908_102727_20150908_FK_C1M04_1_1\…'    '3.1943'    '08-Sep-2015 10:45:00'    'fl'
% '20150908_102727_20150908_FK_C1M082_1_1\…'    '2.1943'    '08-Sep-2014 10:45:01'    'RARE'
% '20150908_102727_20150908_FK_C1M01_1_1\…'    '77.1943'    '08-Sep-2015 10:45:11'    'fl'}
% id=selector(tb,'Columns:  file, sizeMB, date, MRsequence');

% id=selector2(strrep(strrep(b,'\\','-'),' ','-'),{'file' 'sizeMB' 'date' 'MRsequence' 'protocol'});


function [ids varargout]=selector2(tb,header,varargin)


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
 %space=repmat('·|·' ,size(tb,1),1 );
 space=repmat('  ' ,size(tb,1),1 );
  space1=repmat('] ' ,size(tb,1),1 );
  
%  space2=repmat(' [ ]' ,size(tb,1),1 );
%  space=repmat(']  [' ,size(tb,1),1 );
space2=repmat('' ,size(tb,1),1 );

%space=repmat('|·' ,size(tb,1),1 );
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
%  tb2=strrep(tb2,'[','');
% tb2=strrep(tb2,']','');
% tb2=strrep(tb2,'.','');

tb2=strrep(tb2,' ','&nbsp;');

% tb2=strrep(tb2,' ','&emsp;');
% tb2=strrep(tb2,' ','_');
% tb2=strrep(tb2,' ', '&#8230;');
% tb2=strrep(tb2,' ', '&#8230;');

% tb2=strrep(tb2,'_','&#95');
% &#160



mode=2;

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
    
%     %orig
%     colergen = @(color,text) ['<html><table border=0 width=1000 bgcolor=',color,'><TR><TD>',text,'</TD></TR> </table></html>'];
%     % % colergen = @(color,text) ['<html><table border=0 width=1400 bgcolor=',color,'><TR><TD>',text,'</TD></TR> </table></html>'];
%     for i=1:size(tb2,1)
%         for j=1:size(tb2,2)
%             tb2{i,j}=colergen('#ffffff',tb2{i,j});
%         end
%     end
    
end

% data = {  2.7183        , colergen('#FF0000','Red')
%          'dummy text'   , colergen('#00FF00','Green')
%          3.1416         , colergen('#0000FF','Blue')
%          }
% uitable('data',data)

%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

% tbunsel=strrep(tbunsel,'[','')
% tbunsel=strrep(tbunsel',']','')


head=tbunsel{1};
tbunsel=tbunsel(2:end);
tbsel=tbsel(2:end);
tb=tb(2:end);
tb2=tb2(2:end);

%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••


us.row=1;
% us.tb2=tb2;
% us.tb0=tb2;
us.tbsel=tbsel;

us.tbunsel  =tbunsel;
us.tb2      =tbunsel;
us.tb0      =tbunsel;
us.sel=zeros(size(tb2,1),1);

%  tb2=us.tbsel;


try; delete( findobj(0,'TAG','selector'));end

fg; set(gcf,'units','norm','position', [0.0778    0.0772    0.5062    0.8644]);
set(gcf,'name','SELECTOR: use contextmenus for selectrionMode','KeyPressFcn',@keypress);
set(gcf,'userdata',us,'menubar','none','TAG','selector');

t=uicontrol('Style','listbox','units','normalized',         'Position',[0 .1 1 .9]);
set(t,'string',tbunsel,'fontname','courier new','fontsize',14);
set(t,'max',100,'tag','lb1');
% set(t,'Callback',@tablecellselection,'backgroundcolor','w','KeyPressFcn',@keypress);
set(t,'backgroundcolor','w','KeyPressFcn',@keypress);

set(t,'Callback',@buttonDown);
% set(gcf,'ButtonDownFcn',@buttonDown);


% jScrollPane = findjobj(t); % get the scroll-pane object
% jListbox = jScrollPane.getViewport.getComponent(0);
% set(jListbox, 'SelectionBackground',java.awt.Color.yellow); % option #1
% set(jListbox, 'SelectionBackground',java.awt.Color(0.2,0.3,0.7)); % option #2

%______________CONTEXTMENU__________________________________
ctx=uicontextmenu;
uimenu('Parent',ctx,'Label','select this',  'callback',@selecthighlighted);
uimenu('Parent',ctx,'Label','select all',   'callback',@selectall,'separator','on');
uimenu('Parent',ctx,'Label','deselect all', 'callback',@deselectall);
uimenu('Parent',ctx,'Label','find & select','callback',@findAndSelect,'separator','on');
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

p=uicontrol('Style','pushbutton','units','normalized',         'Position',[.55 .05 .1 .02],'tag','pb2');
set(p,'string','select all','callback',{@selectallButton},'fontsize',fontsize);
p=uicontrol('Style','pushbutton','units','normalized',         'Position',[.55 .03 .1 .02],'tag','pb3');
set(p,'string','deselect all','callback',{@deselectallButton},'fontsize',fontsize);
p=uicontrol('Style','popupmenu','units','normalized',         'Position' ,[.55 .01 .1 .02],'tag','pb4','tag','pop');
set(p,'string',cellfun(@(a) {['sort after [' a ']' ]}, ['ID' ; header(:)]) ,'callback',{@sorter},'fontsize',fontsize);

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
addi{end+1,1}=['––––––––––––– SHORTCUTS & INFO ––––––––––––––––––'];
addi{end+1,1}=[' [+/-] change fontsize'];
addi{end+1,1}=[' [s]      or [f1]   UN/SELECT highlighted objects '];
addi{end+1,1}=[' [return] or [f2]   OK & FINNISH "Ich habe fertig" '];
addi{end+1,1}=[' [d]      or [f3]  DESELECT ALL objects'];
addi{end+1,1}=[' [a]      or [f4]  SELECT ALL objects'];
addi{end+1,1}=[' [doubleclick ] to un/select; [shift&click] for multiselection '];
addi{end+1,1}=[' see also contextmenu'];


txtinfo=[txtinfo; addi];

set(p,'userdata',txtinfo, 'string',    txtinfo   ,'fontsize',6,'backgroundcolor','w');
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

set(findobj(gcf,'tag','lb1'),'fontname','courier new');
set(findobj(gcf,'tag','lb2'),'fontname','courier new');


if isfield(params,'position')
   set(gcf,'position',params.position); 
end

%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

us.lb1=findobj(gcf,'tag','lb1');
us.lb2=findobj(gcf,'tag','lb2');
us.jlb1 = findjobj(us.lb1);
us.jlb2 = findjobj(us.lb2);

% hh = handle(us.jlb1 ,'CallbackProperties')
% set(hh.AdjustmentValueChangedCallback,@sliderx)
us.jlb1.AdjustmentValueChangedCallback=@sliderSinc;
% r=get(us.jlb1,'HorizontalScrollBar')
% set(r,'Value',21)
% 
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

% set(gcf, 'WindowButtonDownFcn', @(h,e) disp(get(gcf,'CurrentModifier')));

us.params=params;
set(gcf,'userdata',us);
set(gcf,'currentobject',findobj(gcf,'tag','lb1'));
uicontrol(findobj(gcf,'tag','lb1'));%set focus


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
        %[ids isort]=sort(str2num(cell2mat(us.raw(id,1))));
        %varargout{1}=us.raw(isort,2:end);
        
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
    close(gcf);
end
return
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

function sliderSinc(h,e)
%% 
us=get(gcf,'userdata');
r1=get(us.jlb1,'HorizontalScrollBar');
val=get(r1,'Value');
r2=get(us.jlb2,'HorizontalScrollBar');
set(r2,'Value',val);

function buttonDown(h,ev,ro)
us=get(gcf,'userdata');
us.row=get(findobj(gcf,'tag','lb1'),'value');

% double(get(gcf,'CurrentCharacter'))



% val=get(gcf,'CurrentCharacter')
% get(gcf,'CurrentModifier')


% if isempty(val)
%     'mouse'
% else
%     'key'
% end

 
          
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
 
      pause(0.7); %Add a delay to distinguish single click from a double click
      if chk == 1
         % fprintf(1,'\nI am doing a single-click.\n\n');
       
         
          
          chk = [];
      end
else
    chk = [];
%     disp(lbval);
%     disp(get(findobj(gcf,'tag','lb1'),'value'));
 try
    if get(findobj(gcf,'tag','lb1'),'value')==lbval
%         fprintf(1,'\nI am doing a double-click.\n\n');
        ee=[];
        ee.Key='s';
        ee.Character='';
        keypress([],ee);
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
%         us
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
selectthis([],1);
function deselectallButton(dum,dum2)
selectthis([],0);

function sorter(dum,dum2)
sortlist

function sortlist;

pop=findobj(gcf,'tag','pop');
% sortcol=get(dum,'value');
sortcol=get(pop,'value');
us=get(gcf,'userdata');

cbox=findobj(gcf,'tag','cbox1');
[us.raw ix]=sortrows(us.raw,sortcol);
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
lb1=findobj(gcf,'tag','lb1');
list=get(lb1,'string');
set(lb1,'string',list(ix));
set(gcf,'userdata',us);

tx1=findobj(gcf,'tag','tx1');
str2=get(tx1,'string');
str2{2,1}=['sorting: ['  us.header{sortcol} '] >>' info];
set(tx1,'string',str2);

function ok(t,b)
uiresume(gcf);
%% internal funs

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
  
% set(gcf,'userdata',us);
%     tablecellselection(nan,nan);
   
   
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

function selectthis(t,mode)

t=findobj(gcf,'tag','lb1');
us=get(gcf,'userdata');



% value=get(t,'value');
value=get(t,'value');
if mode==0
    idx=1:size(get(t,'string'),1);
elseif mode==2  %..highlighted in listbox
    idx=value;%get(t,'value');
elseif mode==1
    idx=1:size(get(t,'string'),1);
end

if strcmp(us.params.selection,'single')
    if mode~=0
        idx=value(1);
    end
end




if mode==2
    
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
try
    
     %hTable=findobj(gcf,'tag','lb1');
    %jTable=us.jTable    % = findjobj(hTable); % hTable is the handle to the uitable object
    hTable=findobj(gcf,'tag','lb1');
    jTable = findjobj(hTable); % hTable is the handle to the uitable object
    jScrollPane = jTable.getComponent(0);
    javaObjectEDT(jScrollPane); % honestly not sure if this line matters at all
    currentViewPos = jScrollPane.getViewPosition; % save current position
end
% -----------------------------
set(t,'string',us.tb2);

% ---------remember scrolling-II--------------------
try
    drawnow; % without this drawnow the following line appeared to do nothing
    jScrollPane.setViewPosition(currentViewPos);% reset the scroll bar to original position
end 
    
    
    
    
    
    

   
   
   
   
   
   
   
%     pause(.2);
   set(t,'value',value); 
   us.row=value;
   set(gcf,'userdata',us);
    

if 1
    % ---------remember scrolling-I--------------------
    % http://www.mathworks.com/matlabcentral/newsreader/view_thread/307912
    try
        hTable=t;
        jTable = findjobj(hTable); % hTable is the handle to the uitable object
        jScrollPane = jTable.getComponent(0);
        javaObjectEDT(jScrollPane); % honestly not sure if this line matters at all
        currentViewPos = jScrollPane.getViewPosition; % save current position
    end
    
%     set(gcf,'userdata',us);
%     set(t,'string',us.tb2);
    
    
    % ---------remember scrolling-II--------------------
    try
        drawnow; % without this drawnow the following line appeared to do nothing
        jScrollPane.setViewPosition(currentViewPos);% reset the scroll bar to original position
    end
end

    

