
% #ok set processing status tag for selected animal(s)
% This function allows to set an animal-specific processing status tag (OK, BAD; ISSUE,
% USERDEFIND).
% The status is saved in the 'msg.mat' in the animals folder. This mat-file exists only
% if the animal is tagged.
% #ka *** [1]  HOW TO TAG AN ANIMAL  ***
% - Select one/several animals from the left listbox (ANT main GUI)
%   select ---> right context menu --> [set status].
%  --> This opens the set-anmal-GUI 
% 
% #ka  *** [2] SET-ANIMAL-STATUS-GUI ***
% -Select a  status from the table: 
%  #b "OK" , "BAD" , "ISSUE", "USEERDEFINED"
% - you can specify a short message and the long message:
%   - The short message appears in the left animal listbox in the main gui. 
%   - The long message appears in the tooltip when hovering over the specific 
%  animal (left listbox).
% #m <u>  USERDEFINED STATUS  
% The USEDEFINED STATUS is defined in the LAST ROW of the table ! 
% here you can also define a specific icon and an eye-catching color 
% #n &#8658;  via [icon] & [color]-button
% [History]: use history-table to select a status from already defined states
% (across animals) and apply (copy) this state to the currently selected animals.
% This works only, if the status of at least one animal is set.
% 
% #b <u> SET/REMOVE/CANCEL
% [set]: hit [set] to set the selected status of selected animals (GUI will be close)
% [remove]: hit [remove] to remove the status of selected animals (GUI will be close)
% [cancel]: abort  (GUI will be close)
%
% 
% ----------------------------------------------------------------------
% function: [setanimalstatus.m] 



function list=setanimalstatus(pax)


% ==============================================
%%   animal paths-inpus--> get status
% % not umplemented
 t0={};
% if exist('pax')
%     t0={};
%     if iscell(pax)%paths
%         for i=1:length(pax)
%             f1=fullfile(pax{i},'msg.mat');
%             if exist(f1)==2
%                 v=load(f1);
%                 [a1 a2]=strsplit(v.msg.m1,'</b>') ;
%                 ts={'' '' ''};
%                 ts(1)=a1(1);
%                 ts(2)=a1(2);
%                 ts(3)={v.msg.m2};
%                 t0=[t0; ts];   
%             end
%             
%             
%         end 
%     end 
% end




% ==============================================
%%   
% ===============================================

delete(findobj(0,'tag','animalstatus'))
hs=figure('units','norm','menubar','none','color','w','tag','animalstatus',...
    'name','setAnimalstatus','numbertitle','off');
set(hs,'position',[0.3937    0.4011    0.3542    0.1544])


% Column names and column format
columnname    = {'SELECT'  'ICON'  'shortMessage' 'longMessage                                       '};
columnformat  = {'logical' 'char'  'char'          'char'};

% Define the data

d =    {...
    false  ['<html><b>' '<font color=rgb(11,131,31)>'  '&#9816;'  '</b></html>']  'OK'   'OK';...
    false  ['<html><b>' '<font color=rgb(255,0,0)>'  '&#9760;'  '</b></html>']    'BAD' 'BAD';...
    false  ['<html><b>' '<font color=rgb(234,182,19)>'  '&#9754;'  '</b></html>'] 'issue' 'issue';...
    true  ['<html><b>' '<font color=rgb(0,0,255)>'  '&#9728;'  '</b></html>'] 'userdefind' 'usedefined';...
    };

if ~isempty(t0)
    d(end,2)= {['<html><b>'  t0{1,1}  '</b></html>'] };
    d(end,3)= {       t0{1,2}     };
    d(end,4)= {       t0{1,3}     };
end


% Create the uitable
t = uitable('Data', d,... 
            'ColumnName', columnname,...
            'ColumnFormat', columnformat,...
            'ColumnEditable', [true false true true],...
            'RowName',[],...
            'tag','table');


% Set width and height
t.Position(3) = t.Extent(3);
t.Position(4) = t.Extent(4);

jScroll = findjobj(t);
jTable = jScroll.getViewport.getView;
jTable.setAutoResizeMode(jTable.AUTO_RESIZE_SUBSEQUENT_COLUMNS);
% 
% jscrollpane = javaObjectEDT(findjobj(ht));
% viewport    = javaObjectEDT(jscrollpane.getViewport);
% jtable      = javaObjectEDT( viewport.getView );
% set(jtable,'MouseClickedCallback',@selID)
set(jTable,'MousemovedCallback',@mousemovedTable);

% set(t,'units','norm','position',[0 .2 1 .6])
set(t,'units','norm','position',[0 .2 1 .8]);
% ==============================================
%%   set/remove/cancle/help
% ===============================================
hb=uicontrol('style','pushbutton','units','norm','tag','setstatus','string','set');
set(hb,'position',[.1 0 .15 .13],'callback',{@proc,1});
set(hb,'tooltipstring',['set current status for selected animals ']);


hb=uicontrol('style','pushbutton','units','norm','tag','remove','string','remove');
set(hb,'position',[.25 0 .15 .13],'callback',{@proc,2});
set(hb,'tooltipstring',['remove status from selected animals']);


hb=uicontrol('style','pushbutton','units','norm','tag','cancel','string','cancel');
set(hb,'position',[.38 0 .15 .13],'callback',{@proc,3});
set(hb,'tooltipstring',['cancel process']);

hb=uicontrol('style','pushbutton','units','norm','tag','help','string','help');
set(hb,'position',[.7 0 .15 .13],'callback',{@helps});
set(hb,'tooltipstring',['get some help']);

% ==============================================
%%   USERDATA
% ===============================================

icons={'&#9728;','&#9729;','&#9730;','&#9731;','&#9732;','&#9733;','&#9734;','&#9735;','&#9736;','&#9737;'...
    ,'&#9738;','&#9739;','&#9740;','&#9741;','&#9742;','&#9743;','&#9744;','&#9745;','&#9746;','&#9747;'...
    ,'&#9750;','&#9751;','&#9754;','&#9755;','&#9756;','&#9757;'...
    '&#9758;','&#9759;','&#9760;','&#9761;','&#9762;','&#9763;','&#9764;','&#9765;',...
    '&#9768;','&#9769;','&#9770;','&#9771;','&#9772;','&#9773;','&#9774;','&#9775;','&#9776;','&#9777;'...
    ,'&#9784;','&#9785;','&#9786;','&#9787;'...
    '&#9788;','&#9789;','&#9790;','&#9791;','&#9792;','&#9793;','&#9794;','&#9795;','&#9796;','&#9797;'...
    '&#9798;','&#9799;','&#9800;','&#9801;','&#9802;','&#9803;','&#9804;','&#9805;','&#9806;','&#9807;'...
    '&#9808;','&#9809;','&#9810;','&#9811;','&#9812;','&#9813;','&#9814;','&#9815;','&#9816;','&#9817;'...
    '&#9818;','&#9819;','&#9820;','&#9821;','&#9822;','&#9823;','&#9824;','&#9825;','&#9826;','&#9827;'...
    '&#9828;','&#9829;','&#9830;','&#9831;','&#9832;'
    };
u.icons=icons;
u.icon='<html>&#9728;';
u.iconcol=[0 0 0];
u.t=t;
set(gcf,'userdata',u);

%------dropdown
% tb={'&#9728;','&#9729;','&#9730;','&#9731;','&#9732;','&#9733;','&#9734;','&#9735;','&#9736;','&#9737;'...
%     ,'&#9738;','&#9739;','&#9740;','&#9741;','&#9742;','&#9743;','&#9744;','&#9745;','&#9746;','&#9747;'...
%     ,'&#9750;','&#9751;','&#9754;','&#9755;','&#9756;','&#9757;'...
%     '&#9758;','&#9759;','&#9760;','&#9761;','&#9762;','&#9763;','&#9764;','&#9765;',...
%     '&#9768;','&#9769;','&#9770;','&#9771;','&#9772;','&#9773;','&#9774;','&#9775;','&#9776;','&#9777;'...
%     ,'&#9784;','&#9785;','&#9786;','&#9787;'...
%     '&#9788;','&#9789;','&#9790;','&#9791;','&#9792;','&#9793;','&#9794;','&#9795;','&#9796;','&#9797;'...
%     '&#9798;','&#9799;','&#9800;','&#9801;','&#9802;','&#9803;','&#9804;','&#9805;','&#9806;','&#9807;'...
%     '&#9808;','&#9809;','&#9810;','&#9811;','&#9812;','&#9813;','&#9814;','&#9815;','&#9816;','&#9817;'...
%     '&#9818;','&#9819;','&#9820;','&#9821;','&#9822;','&#9823;','&#9824;','&#9825;','&#9826;','&#9827;'...
%     '&#9828;','&#9829;','&#9830;','&#9831;','&#9832;'
%     };

hp= uicontrol(gcf, 'Style','text', 'Units','norm', 'String','userdefined');
set(hp,'position',[.0 0.25 .15 .13]);
set(hp,'tooltipstring',['<html><b>define a specic status</b><br>' ....
    'The last table-row allows to define a specic staus (icon,color)']);


%%  ICONS
% hp= uicontrol(gcf, 'Style','popupmenu', 'Units','norm', 'Pos',[0 0 1 1], 'String',cellfun(@(a){[ '<html>' a ]},   tb));
% set(hp,'userdata',tb);
% set(hp,'position',[.15 0.33 .1 .05],'tag','iconsel', 'callback',{@userdef});
% set(hp,'tooltipstring',['define icon of users-pecific status']);
hp= uicontrol(gcf, 'Style','pushbutton', 'Units','norm','string','icon');
set(hp,'position',[.15 0.25 .1 .13],'tag','iconcol', 'callback',{@select_icons});
set(hp,'tooltipstring',['select icon of users-pecific status']);

%%  COLO
hp= uicontrol(gcf, 'Style','pushbutton', 'Units','norm','string','color');
set(hp,'position',[.25 0.25 .1 .13],'tag','iconcol', 'callback',{@userdef});
set(hp,'tooltipstring',['define font-color of users-pecific status']);

%%  History
hp= uicontrol(gcf, 'Style','pushbutton', 'Units','norm','string','history');
set(hp,'position',[.35 0.25 .1 .13],'tag','iconcol', 'callback',{@history});
set(hp,'tooltipstring',['get status from history (copy status from other animal']);

set(t, 'CellSelectionCallback',@cellclicked);

% ==============================================
%%   
% ===============================================
dowait=1;  % ####### ISWAIT
list=-1;
% if isempty(findobj(0,'tag','animalstatus'))==0
%     
% else
    
    if dowait==1
        
        
        uiwait(gcf)
        u=get(gcf,'userdata');
        
        try
            if u.proc==1
                d=u.t.Data;
                is=find(cell2mat(d(:,1))==1);
                list=[];
                if ~isempty(is)
                    list=d(is,:) ;
                    list(:,2)=strrep(list(:,2), '<html>','');
                    
                end
            elseif u.proc==2
                list=[];
            elseif u.proc==3
                list=-1;
            end
            
            close(gcf)
        end
        
    end
% end


function mousemovedTable(e,e2)
e2.getPoint;
jtable=e;
% index = jtable.convertColumnIndexToModel(e2.columnAtPoint(e2.getPoint())) + 1
row=e.rowAtPoint(e2.getPoint())+1;
col=e.columnAtPoint(e2.getPoint())+1;

% [col row]
if     col==1; ms=[ 'select a proper status here  ']; 
elseif col==2; ms=[ '<html> the associated status-icon <br>'...
        'The <b>user-defind status (last column) </b> allows to set a specific icon ']; 
elseif col==3; ms=[ '<html><b> a short message </b><br>'...
        '-appears in the animal-listbox of the selected animals' ...
        '<br>'...
       ]; 
elseif col==4; ms=[ '<html><b> a long message </b><br>'...
        '-appears in the tooltip of the selected animal in the left animal listbox' ...
        '<br>'...
       ]; 
end
    
    
jtable.setToolTipText(ms);



function proc(e,e2,arg)
u=get(gcf,'userdata');

if arg==1 %check if something is selected for "set"-BTN
    if isempty(find(cell2mat(u.t.Data(:,1))))
        msgbox(' no status selected');
        return
    end
end
u.proc=arg;
set(gcf,'userdata',u);
uiresume(gcf);

function helps(e,e2)

uhelp(mfilename);

function cellclicked(e,e2)
% drawnow;
ix=e2.Indices;
try
if ix(2)~=1
   return 
end
c1=repmat({false},[size(e.Data,1) 1]);
c1(ix(1))= {true};  e.Data(ix(1),1);
e.Data(:,1)=c1;
end


function userdef(e,e2)

if isempty(e); e=''; end
u=get(gcf,'userdata');
% hi=findobj(gcf,'tag','iconsel');
% tb=get(hi,'userdata');
% % icon=hi.String{hi.Value};
% icon=tb{hi.Value};
icon=u.icon;


% hc=findobj(gcf,'tag','colsel');
try
    u=get(gcf,'userdata');
    % u.col
    if strcmp(e.Tag,'iconcol')
        col=uisetcolor(u.iconcol,'select color');
        u.iconcol=col;
        set(gcf,'userdata',u);
        set(e,'backgroundcolor',col);
        if any(col==0)==1
            set(e,'foregroundcolor',[.5 .5 .5]);
        else
            set(e,'foregroundcolor',[0 0 0]);
        end
    end
end
% ==============================================
%%   
% ===============================================
rgb=round(u.iconcol*255);
d=u.t.Data;
 d{end,2}=['<html><font color=rgb(' sprintf('%d,%d,%d',rgb) ')>'  icon ];
%d{end,2}=['<html>' icon  ];

u.t.Data=d;
% disp([d{end,2}]);


% ==============================================
%%   
% ===============================================



% jScrollPane = findjobj(hp);
% jListbox = jScrollPane.getViewport.getView;
% jListbox.setLayoutOrientation(jListbox.HORIZONTAL_WRAP)
% % jListbox.setVisibleRowCount(4)
% % jListbox.setFixedCellWidth(18)   % icon width=16  + 2px margin
% % jListbox.setFixedCellHeight(18)  % icon height=16 + 2px margin
% jListbox.repaint  % refresh the display




return

function iconselect(e,e2,arg)
if arg==2; return; end
hl=findobj(findobj(0,'tag','icons'),'tag','lb_icons');
hf=findobj(0,'tag','animalstatus');
u=get(hf,'userdata');
u.icon =hl.String{hl.Value};
set(hf,'userdata',u);
delete(findobj(0,'tag','icons'));
f.dummy=1; %just dummy to mimic struct
userdef(f,[]);
% ==============================================
%%   
% ===============================================
function select_icons(e,e2)
u=get(gcf,'userdata');
tb=u.icons;



u2.tb=tb;
delete(findobj(0,'tag','icons'));
hi=figure('units','norm','menubar','none','color','w','tag','icons',...
    'name','icons','numbertitle','off');
set(hi,'position',[0.3937    0.3433    0.1583    0.2122]);
set(hi,'userdata',u2);


hl= uicontrol(gcf, 'Style','listbox', 'Units','norm', 'Pos',[0 0 1 1], 'String',cellfun(@(a){[ '<html>' a ]},   tb));
set(hl,'fontsize',12,'tag','lb_icons')

jScrollPane = findjobj(hl);
jListbox = jScrollPane.getViewport.getView;
jListbox.setLayoutOrientation(jListbox.HORIZONTAL_WRAP)
% jListbox.setVisibleRowCount(4)
% jListbox.setFixedCellWidth(18)   % icon width=16  + 2px margin
% jListbox.setFixedCellHeight(18)  % icon height=16 + 2px margin
jListbox.repaint  % refresh the display

%     0.3937    0.3433    0.1722    0.2122
hb=uicontrol('style','pushbutton','units','norm','tag','','string','OK');
set(hb,'position',[.3 0 .2 .1],'callback',{@iconselect,1});
hb=uicontrol('style','pushbutton','units','norm','tag','','string','cancel');
set(hb,'position',[.5 0 .2 .1],'callback',{@iconselect,1});




% ==============================================
%%   history
% ===============================================

function history(e,e2)
    



% ==============================================
%%   
% ===============================================
px=antcb('getallsubjects'); 
t0={};
if ~isempty(px)%paths
    for i=1:length(px)
        f1=fullfile(px{i},'msg.mat');
        if exist(f1)==2
            v=load(f1);
            [a1 a2]=strsplit(v.msg.m1,'</b>') ;
            q=v.msg.m1;
            icon=q(min(strfind(q,')>'))+2: min((strfind(q,';')))   );
            col= q(min(strfind(q,'=rgb('))+5: min(strfind(q,')>'))-1 ) ;
            %col=[str2num(col)./255];
            m1  =q(strfind(q,';')+1:end );
            m1  =regexprep(m1,'</b>','');
            
            m2  =v.msg.m2;
            ts={'' '' '' ''};
            ts{1}=icon;
            ts{2}=col;
            ts{3}=m1;
            ts{4}=m2;
            t0=[t0; ts];
        end
        
    end
end
if isempty(t0)
   msgbox(['No status-history.' char(10) ... 
       '# History can be used after at the status' char(10) ' of at least one animal is set.']) ;
   return
end
t0m=cellfun(@(a,b,c,d){[ a,b,c,d]}, t0(:,1),t0(:,2),t0(:,3),t0(:,4) );
[~,ix]=unique(t0m,'rows');
t0=t0(ix,:);


% ==============================================
%%   
% ===============================================

delete(findobj(0,'tag','animalstatus_history'));
figure
set(gcf,'units','norm','numbertitle','off','tag','animalstatus_history',...
    'name','animalstatus_history','menubar','none')
set(gcf,'position',[0.3937    0.4011    0.3542    0.1544]);
% Column names and column format
columnname    = {'SELECT'  'ICON'  'shortMessage' 'longMessage                                       '};
columnformat  = {'logical' 'char'  'char'          'char'};

d={};
for i=1:size(t0,1)
    r={false 
        ['<html><b>' '<font color=rgb(' t0{i,2}  ' )>'  t0{i,1}  '</b></html>']
        t0{i,3}
        t0{i,4}
        };
    d(end+1,:)=r;
end

% Create the uitable
t = uitable('Data', d,... 
            'ColumnName', columnname,...
            'ColumnFormat', columnformat,...
            'ColumnEditable', [true false false false],...
            'RowName',[],...
            'tag','table');


% Set width and height
t.Position(3) = t.Extent(3);
t.Position(4) = t.Extent(4);

jScroll = findjobj(t);
jTable = jScroll.getViewport.getView;
jTable.setAutoResizeMode(jTable.AUTO_RESIZE_SUBSEQUENT_COLUMNS);
% 
% jscrollpane = javaObjectEDT(findjobj(ht));
% viewport    = javaObjectEDT(jscrollpane.getViewport);
% jtable      = javaObjectEDT( viewport.getView );
% set(jtable,'MouseClickedCallback',@selID)
% set(jTable,'MousemovedCallback',@mousemovedTable);

% set(t,'units','norm','position',[0 .2 1 .6])
set(t,'units','norm','position',[0 .2 1 .8]);
set(t, 'CellSelectionCallback',@cellclicked);
    

hb=uicontrol('style','pushbutton','units','norm','tag','setstatus','string','OK');
set(hb,'position',[.1 0 .15 .13],'callback',{@proc_history,1});
set(hb,'tooltipstring',['OK: use selected status from history and use for selected animals ']);



hb=uicontrol('style','pushbutton','units','norm','tag','cancel','string','cancel');
set(hb,'position',[.25 0 .15 .13],'callback',{@proc_history,2});
set(hb,'tooltipstring',['cancel process']);

uh.info='history';
uh.t  =t;
uh.t0 =t0;
set(gcf,'userdata',uh);

% ==============================================
%%   
% ===============================================

function proc_history(e,e2,arg)
if arg==2
    delete(findobj(0,'tag','animalstatus_history'));
    return
end

hf=findobj(0,'tag','animalstatus');
uh=get(gcf,'userdata');
ix=find(cell2mat(uh.t.Data(:,1)));
r=uh.t.Data(ix,:);


if isempty(r)
    msgbox('nothing selected');
    return
end
delete(findobj(0,'tag','animalstatus_history'));
% -----set histoy-selection to userdef----------------
u=get(hf,'userdata');
u.t.Data{end,1}=true;
u.t.Data{end,2}=['<html><b><font color=rgb(' uh.t0{ix,2}  ')>' uh.t0{ix,1}  '</b></html>'];
u.t.Data{end,3}=uh.t0{ix,3};
u.t.Data{end,4}=uh.t0{ix,4};


u.iconcol=str2num(uh.t0{ix,2})/255;
u.icon   =['<html>'  uh.t0{ix,1} ];
set(hf,'userdata',u);

