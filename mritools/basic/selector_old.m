
%% selectionGUI using multiple cells
% function ids=selector(tb)
% function ids=selector(tb,colinfo)  
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
%     '20150908_102727_20150908_FK_C1M04_1_1\…'    '4.1943'    '08-Sep-2015 10:45:12'    'RARE'}
% id=selector(tb,'Columns:  file, sizeMB, date, MRsequence');




function ids=selector(tb,colinfo)

warning off;

iswait=1;
ids=[];
d=[];
tb=[ cellstr(num2str([1:size(tb,1)]')) tb ];

% tb=[tb repmat({'_'},size(tb,1),1) ];
 %space=repmat('·|·' ,size(tb,1),1 );
 space=repmat('  ' ,size(tb,1),1 );
  space1=repmat('] ' ,size(tb,1),1 );
 space2=repmat(' [ ]' ,size(tb,1),1 );
%  space=repmat(']  [' ,size(tb,1),1 );

%space=repmat('|·' ,size(tb,1),1 );
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

tb2=cellstr(d);
% tb2=strrep(tb2,' ','·');
% tb2=strrep(tb2,' ','_');




mode=2;

if mode==1
    % colortag='<html><div style="background:yellow;">Panel 1'
    colortag='<html><div style="color:red;"> '
    % % colortag='<html><TD BGCOLOR=#40FF68>'
    tbsel=cellfun(@(tb2) [ colortag tb2],tb2,'UniformOutput',0)
elseif mode==2
    colergen = @(color,text) ['<html><table border=0 width=1000 bgcolor=',color,'><TR><TD><pre>',text,'</pre></TD></TR> </table></html>'];
    % % colergen = @(color,text) ['<html><table border=0 width=1400 bgcolor=',color,'><TR><TD>',text,'</TD></TR> </table></html>'];
    for i=1:size(tb2,1)
        for j=1:size(tb2,2)
%             tbsel{i,j}=colergen('#ffcccc',[tb2{i,j}(1:end-2) 'x]' ] );
           tbsel{i,j}=colergen('#FFD700',[tb2{i,j}(1:end-2) 'x]' ] );
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




us.row=1;
us.tb2=tb2;
us.tb0=tb2;
us.tbsel=tbsel;
us.sel=zeros(size(tb2,1),1);

%  tb2=us.tbsel;


try; delete( findobj(0,'TAG','selector'));end

fg; set(gcf,'units','norm','position', [0.0778    0.0772    0.5062    0.8644]);
set(gcf,'name','SELECTOR: use contextmenus for selectrionMode','KeyPressFcn',@keypress);
set(gcf,'userdata',us,'menubar','none','TAG','selector');

t=uicontrol('Style','listbox','units','normalized',         'Position',[0 .1 1 .9]);
set(t,'string',tb2,'fontname','courier new','fontsize',14);
set(t,'max',100,'tag','lb1');
% set(t,'Callback',@tablecellselection,'backgroundcolor','w','KeyPressFcn',@keypress);
set(t,'backgroundcolor','w','KeyPressFcn',@keypress);

set(t,'Callback',@buttonDown);
% set(gcf,'ButtonDownFcn',@buttonDown);


% jScrollPane = findjobj(t); % get the scroll-pane object
% jListbox = jScrollPane.getViewport.getComponent(0);
% set(jListbox, 'SelectionBackground',java.awt.Color.yellow); % option #1
% set(jListbox, 'SelectionBackground',java.awt.Color(0.2,0.3,0.7)); % option #2


ContextMenu=uicontextmenu;
Menu1=uimenu('Parent',ContextMenu,...
    'Label','select all','callback',@selectall);
Menu2=uimenu('Parent',ContextMenu,...
      'Label','deselect all','callback',@deselectall);
% Menu3=uimenu('Parent',ContextMenu,...
%     'Label','Menu Option 3');
set(t,'UIContextMenu',ContextMenu);
% get(MyListbox,'UIContextMenu') 

fontsize=8;

p=uicontrol('Style','pushbutton','units','normalized',         'Position',[.85 .05 .1 .02],'tag','pb1');
set(p,'string','OK','callback',@ok,'fontsize',fontsize);

p=uicontrol('Style','pushbutton','units','normalized',         'Position',[.55 .05 .1 .02],'tag','pb2');
set(p,'string','select all','callback',{@selectallButton},'fontsize',fontsize);
p=uicontrol('Style','pushbutton','units','normalized',         'Position',[.55 .03 .1 .02],'tag','pb3');
set(p,'string','deselect all','callback',{@deselectallButton},'fontsize',fontsize);
% p=uicontrol('Style','pushbutton','units','normalized',         'Position',[.55 .01 .1 .02],'tag','pb4');
% set(p,'string','help','callback',{@help},'fontsize',fontsize);

p=uicontrol('Style','edit','units','normalized',         'Position',[.1 .03 .4 .05],'tag','tx1','max',2);
txtinfo={ [  num2str(sum(us.sel,1))  '/' num2str(size(us.sel,1))   ' objects selected']    ; '....'};
set(p,'position',[0 0 .5 .1]);

if exist('colinfo'); if ischar(colinfo)    txtinfo{2}=colinfo   ;end;end
addi={};
addi{end+1,1}=['–––––––––––––––––––––––––––––––'];
addi{end+1,1}=['       -use [+/-] key to change fontsize'];
addi{end+1,1}=['       -use [space] key to un/select'];
addi{end+1,1}=['       -use [ctrl&click] for multiselection'];


txtinfo=[txtinfo; addi];

set(p,'userdata',txtinfo, 'string',    txtinfo   ,'fontsize',fontsize,'backgroundcolor','w');

set(findobj(gcf,'tag','lb1'),'fontsize',8);
set(findobj(gcf,'tag','lb1'),'fontsize',8);



jListbox = findjobj(findobj(gcf,'tag','lb1'));
jListbox=jListbox.getViewport.getComponent(0);
jListbox.setSelectionAppearanceReflectsFocus(0);

drawnow;
jScrollPane = findjobj(findobj(gcf,'tag','lb1')); % get the scroll-pane object
jListbox = jScrollPane.getViewport.getComponent(0);
set(jListbox, 'SelectionForeground',java.awt.Color.black); % option #1
set(jListbox, 'SelectionBackground',java.awt.Color(0.8,0.9,0.85)); % option #2


%% MODALITY
if iswait==0
   uiwait(gcf);
%    return
  hfig= findobj(0,'TAG','selector');
  if isempty(hfig); return; end
    us=get(gcf,'userdata');
    ids=find(us.sel==1);
    close(gcf);
end




return


function buttonDown(h,ev)
us=get(gcf,'userdata');
us.row=get(findobj(gcf,'tag','lb1'),'value');



function keypress(h,ev)
    % Callback to parse keypress event data to print a figure
    if ev.Character == '+'
        lb=findobj(gcf,'tag','lb1');
        fs= get(lb,'fontsize')+1;
        if fs>1; set(lb,'fontsize',fs); end
    elseif ev.Character == '-'
            lb=findobj(gcf,'tag','lb1');
        fs= get(lb,'fontsize')-1;
        if fs>1; set(lb,'fontsize',fs); end
    end
    if strcmp(ev.Key,'space')
%         get(findobj(gcf,'tag','lb1'),'value');
        tablecellselection(nan,nan);
    end

%% BUTTONS
function selectallButton(dum,dum2)
selectthis([],1);
function deselectallButton(dum,dum2)
selectthis([],0);
function ok(t,b)
uiresume(gcf);
%% internal funs


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

mode

if mode==2
    idx=value;%get(t,'value');
elseif mode==1
    idx=1:size(get(t,'string'),1);
    elseif mode==0
    idx=1:size(get(t,'string'),1);
end

if mode==2
    for i=1:length(idx)
        this=idx(i);
        if us.sel(this)==0  %selected for process NOW
            us.sel(this)=1;
            us.tb2(this,:)=us.tbsel(this,:);
        else%deSelect
            us.sel(this)=0;
            us.tb2(this,:)=us.tb0(this,:);
        end
    end
elseif mode==1
    us.sel=us.sel.*0+1;
    us.tb2=us.tbsel;
elseif mode==0
     us.sel=us.sel.*0;
    us.tb2=us.tb0;
end

  set(gcf,'userdata',us);
  disp(['ready' datestr(now)]);
    set(t,'string',us.tb2); 
    
    %% infobox
    tx=findobj(gcf,'tag','tx1') ;
    txinfo=get(tx,'userdata');
    txinfo(1)={ [  num2str(sum(us.sel,1))  '/' num2str(size(us.sel,1))   ' objects selected']   };
    set(tx,'string',txinfo,'value',[]);

    
%     drawnow;
pause(.1);
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

    

