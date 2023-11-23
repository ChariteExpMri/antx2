
% #ok load a project from history, i.a. from a list of previous studies
% each time a project-file is loaded a history-table is updated and saved in:
%      "userpath/antx2_userdef/userdef.mat" which is
% or: #r <u> fullfile(userpath,'antx2_userdef','userdef.mat');
%
%
% ==============================================
% #ko   *** [1]  LOAD A STUDY FROM HISTORY  ***
% ==============================================
% -click #b [GREEN BOOK] #n -button (open STUDY-HISTORY) of the ANT GUI to open the
%  "anthistory"-GUI.
%   (1) select one of the chronologically ordered entrances of the table
%    -each entrance denotes:
%            * the time when a project was loaded
%            * the study path
%            * the loaded project file (aka config-file)
%            * the user
%    -once selected, the lower text field contains the information of the
%     selected study
%    -background colors denote the same studies i.e. identical projects
%   (2) hit #b [load] #n to change the directory to the selected project and load
%       the project
% ____________________________________________________________
%%   [ other GUI controls]
% #b [openDir]        #n : open directory of selected study in explorer
% #b [shring GUI]     #n : shrinks the window's horizontal size by 50%
% #b [stay open]      #n : forces the GUI to stay open when [load]-button is pressed
% #m [unique Studies] #n : [x] show single studies only, [ ] show entire history
% #b [find]           #n : find study via string-search (cell will be highlighted)
% 
% #b [load]       #n : load a selected project
%                -The project must be selected from the table and must appear
%                 in the lower gray text box
% #b [close]      #n : close the GUI
% #b [help]       #n : get this help
% #r [delete]     #n : Delete entiry history.
%                #r Important: This will delete the history without any "undo"-option
%                -in this step "fullfile(userpath,'antx2_userdef', 'userdef.mat')" is deleted
%
%  #g USE TABLE's CONTEXT MENU to:
%   -delete current session from history
%   -delete study (all entrances of the study) from history
%   -keep chronologically last 3 entrances from a study and delete the rest from history
%   -open study directory
%   -show config file of the stury in editor
%
%
% ==============================================
% #ko *** [2] COMMANDLINE OPTIONS  ***
% ===============================================
% anthistory('select'); % % opens this GUI
% anthistory('update'); % % update the current project to history
% anthistory('delete'); % % delete the entiry history
% anthistory('path');   % % shows filename&path of the history
%
%
%
% ==============================================
% #ko *** [3] SHORTCUTS  ***
% ===============================================
% #b [space]  #n :  enlarge/shrink window (toggle)
%
%




function anthistory(task)

%===================================================================================================
warning off;
p.upa=fullfile(userpath,'antx2_userdef');
p.fhist=fullfile(p.upa, 'userdef.mat' );

if exist('task')==0
    task='select';
end

%===================================================================================================
if strcmp(task,'path')
    
    showinfo2('History-DIR :' ,p.upa  ,[],[], [ '>> ' p.upa '' ]);
    %     showinfo2('History-FILE:' ,p.fhist,[],[], [ '>> ' p.fhist '' ]);
    %cprintf([0 .5 1], ['History-FILE: ' strrep(p.fhist,[filesep],[filesep filesep])  '\n']);
    if exist(p.fhist)==2
        disp(['History-FILE: ' '<a href="matlab: explorerpreselect(''' p.fhist ''')">' p.fhist '</a>']);
    else
        disp(['History-FILE: -"userdef.mat" not created --   (load a project to create "userdef.mat"  )']);
    end
    
    return
elseif strcmp(task,'update')
    hupdate(p);
    return;
elseif strcmp(task,'delete')
    hdelete(p);
    return;
elseif strcmp(task,'select')
    hselect(p);
    return;
end


% ==============================================
%%   tests-2
% ===============================================

if 0
    anthistory('delete')
end


% ==============================================
%%    Delete
% ==============================================
function hdelete(p)

delete(p.fhist);
% ==============================================
%%    UPDATE
% ==============================================
function hupdate(p)

upa  =p.upa;
fhist=p.fhist;

% --------------
warning off;
mkdir(upa);


global an

pa        =fileparts(an.datpath);
timx      =datestr(now);

[pac namec extc]=fileparts(an.configfile);
if isempty(extc); extc='.m'; end
configfile=fullfile(pac,[namec extc]);

uname  =char(java.lang.System.getProperty('user.name'));
client=getenv('CLIENTNAME');
if ~isempty(client)
    client=[client '/'];
end
user=[client  uname ];
% [a1 a2]=system('echo %CLIENTNAME%')


% delete(fhist)
hcl={'time' 'studyPath' 'configFile' 'user'};
if exist(fhist)~=2
    h.i1___info='USER-SPECIFIC PARAMETER' ;
    h.hhistory=hcl;
    h.history={};
    save(fhist,'h');
    
end
% ==============================================
%   add history ( newest in 1st cell-row)
% ===============================================
load(fhist)
cl={timx pa  configfile user };
if isempty(h.history)
    h.history=cl;
else
    if size(h.history,2)==size(cl,2)
        h.history=[cl; h.history ];
    else
        h.hhistory=hcl;
        h.history= [h.history repmat({''} , [ size(h.history,1)   size(cl,2)-size(h.history,2)])];
        h.history=[cl; h.history ];
    end
end

save(fhist,'h');



% uhelp(plog([],[h.hhistory;h.history ],0))



% ==============================================
%%   select
% ===============================================
function hselect(p)

if exist(p.fhist)==0
    msgbox(['*** NO HISTORY *** ' char(10) ...
        'History will be written when a projectfile is loaded']);
    return
end
load(p.fhist);
% ==============================================
%%   defaults
% ===============================================
setpixunits=1;
doshrinkGui=1;
showuniquestudies=1;
% ==============================================
%%
% ===============================================

figpos=[ 0.1139    0.2044    0.8014    0.5711];

delete(findobj(0,'tag','anthistory'));
hf=figure('visible','off','units','norm','menubar','none','color','w','tag','anthistory',...
    'name','anthistory','numbertitle','off');
% set(hf,'position',[0.3937    0.4011    0.3542    0.1544])
set(hf,'position',figpos);
set(gcf,'WindowKeyPressFcn',@keys);
% set(gcf,'WindowButtonDownFcn',@windowclick);

% Column names and column format
% Define the data
% d =    {...
%     false  ['<html><b>' '<font color=rgb(11,131,31)>'  '&#9816;'  '</b></html>']  'OK'   'OK';...
%     false  ['<html><b>' '<font color=rgb(255,0,0)>'  '&#9760;'  '</b></html>']    'BAD' 'BAD';...
%     false  ['<html><b>' '<font color=rgb(234,182,19)>'  '&#9754;'  '</b></html>'] 'issue' 'issue';...
%     true  ['<html><b>' '<font color=rgb(0,0,255)>'  '&#9728;'  '</b></html>'] 'userdefind' 'usedefined';...
%     };
% if ~isempty(t0)
%     d(end,2)= {['<html><b>'  t0{1,1}  '</b></html>'] };
%     d(end,3)= {       t0{1,2}     };
%     d(end,4)= {       t0{1,3}     };
% end




columnname    = h.hhistory ;%{'SELECT'  'ICON'  'shortMessage' 'longMessage                                       '};
columnformat  = repmat({'char'},[1 length(h.hhistory)]); %{'logical' 'char'  'char'
ColumnEditable= repmat(false,[1 length(h.hhistory)]);



%% ===============================================
[d d0  coltab]=table2html(h);

% % [d d0  coltab]=table2html(p)
% d0=h.history;
% d=h.history;
% coltab=zeros(size(d,1),3);
% if 1
%     unipath=unique(d(:,2));
%     if length(unipath)<3
%         col=cbrewer('qual', 'Pastel1', 3);
%     else
%         col=cbrewer('qual', 'Pastel1', length(unipath));;% fg,imagesc(permute(CT,[3 1 2 ]))
%     end
%     dpa=d(:,2);
%     for i=1:length(unipath)
%         is=find(strcmp(d(:,2),unipath{i} ));
%         % --M1----
%         %         dum=[  '<html><pre> <b><font color="black"> <b><font bgcolor=rgb(' sprintf('%d,%d,%d',(col(i,:)*255)) ')>'  unipath{i} '</pre>'];
%         % --M2-----
%         %dum=['<html><table border=0 width=1400 bgcolor=rgb(' sprintf('%d,%d,%d',(col(i,:)*255)) ')><TR><TD>' unipath{i}  '</TD></TR> </table>'  ]
%         %dpa(is)={dum};
%         % --M3-----
%         dum=cellfun(@(a){[...
%             '<html><table border=0 width=1400 bgcolor=rgb(' sprintf('%d,%d,%d',(col(i,:)*255)) ')><TR><TD>'   ...
%             a ...
%             '</TD></TR> </table>'...
%             ]},   d(is,:));
%         d(is,:)=dum;
%         coltab(is,:) =  repmat(col(i,:),[ length(is)  1]); %colortable
%     end
% end
%% ===============================================







% uitable('Data',{'<html><table border=0 width=400 bgcolor=#FF0000><TR><TD>Hello</TD></TR> </table>' })

columnname2=columnname;
try
%     lentime=size(char(h.history(:,1)),2);
%     columnname2{1}=['time' repmat('_', [1 lentime-length('time')]-18 )];
    
    lenpath=size(char(h.history(:,2)),2);
    columnname2{2}=['studyPath' repmat(' ', [1 lenpath-length('studyPath')] )];
end

% Create the uitable
t = uitable('Data', d,...
    'ColumnName', columnname2,...
    'ColumnFormat', columnformat,...
    'ColumnEditable', ColumnEditable,...
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
% if 0
set(jTable,'MousemovedCallback',@mousemovedTable);

% selCol=[1 0 0];
selCol=[0 0 1];
set(jTable, 'SelectionForeground',java.awt.Color(selCol(1),selCol(2),selCol(3)));
% end
if 1
    set(t, 'CellSelectionCallback',@cellclicked);
end
% set(t,'units','norm','position',[0 .2 1 .6])
set(t,'units','norm','position',[0 .2 1 .8]);


% jscroll = findjobj(hTable);
% jTable = jscroll.getViewport.getView;
% jTable.setAutoResizeMode(jTable.AUTO_RESIZE_SUBSEQUENT_COLUMNS)

% ==============================================
%%   PARAMS
% ===============================================

u.p=p;
u.hd=h.hhistory;
u.d=d0;
u.t=t;
u.coltab=coltab;
u.figpos=figpos;

u.istablesort=0; %sort table...this does not work currently
u.jTable=jTable;
u.txtmsgDefault='<empty> no study selected from table';
set(gcf,'userdata',u)

% ----------------


% ==============================================
%%   edit: selection
% ===============================================
hb=uicontrol('style','text','units','norm','tag','ed_sel','string',u.txtmsgDefault);
set(hb,'position',[0.001 .1 .5 .1]);%,'callback',{@proc,1});
set(hb,'tooltipstring',['selected study from above table']);
set(hb,'HorizontalAlignment','left','Max',100) ;%,'enable','off');
if setpixunits==1
    set(hb,'units','pixel');
end
% ==============================================
%%   CHECK:  force to stay open
% ===============================================
hb=uicontrol('style','checkbox','units','norm','tag','ck_stayopen','string','stay open');
set(hb,'position',[0.12997 0.069145 0.07 0.03]);%,'callback',{@proc,1});
set(hb,'tooltipstring',[...
    %     'GUI remains open after a project-file is loaded' char(10) ...
    '[x] GUI remains open when [OK]-button is clicked' char(10)...
    '[ ] GUI closes when [OK]-button is clicked' char(10)...
    ]);
set(hb,'value',0,'backgroundcolor','w') ;%,'enable','off');
if setpixunits==1
    set(hb,'units','pixel');
end

% ==============================================
%%   CHECK: shrink GUI
% ===============================================
hb=uicontrol('style','checkbox','units','norm','tag','shrinkGUI','string','shrink GUI');
set(hb,'callback',@shrinkGUI);
set(hb,'position',[0.058044 0.069145 0.07 0.03]);%,'callback',{@proc,1});
set(hb,'tooltipstring',[...
    %     'GUI remains open after a project-file is loaded' char(10) ...
    '[x] shrink GUI window to half horizontal size' char(10)...
    '[ ] restore orig. GUI window size' char(10)...
    ]);
set(hb,'value',0,'backgroundcolor','w') ;%,'enable','off');
if setpixunits==1
    set(hb,'units','pixel');
end
% ==============================================
%%   CHECK: unique studies
% ===============================================
hb=uicontrol('style','checkbox','units','norm','tag','uniqueStudies','string','unique Studies');
set(hb,'callback',@shrinkGUI);
set(hb,'position',[0.2 0.069145 0.08 0.03]);%,'callback',{@proc,1});
set(hb,'tooltipstring',[...
    %     'GUI remains open after a project-file is loaded' char(10) ...
    '[x] show unique studies only' char(10)...
    '[ ] show entire history' char(10)...
    ]);
set(hb,'value',0,'backgroundcolor',[ 1.0000    0.9451    0.651]) ;
set(hb,'callback',{@uniquestudies});
if setpixunits==1
    set(hb,'units','pixel');
end

% ==============================================
%%   find string: unique studies
% ===============================================
hb=uicontrol('Style','pushbutton','units','norm', 'Position',[.65 .03 .1 .02],'tag','finderwindow');
set(hb,'string','find','callback',{@sub_findstring,2},'fontsize',8);
set(hb,'position',[0.28 0.069145 0.04 0.03]);
set(hb,'tooltipstring',[...
    'search string' char(10) ...
    ]);
if setpixunits==1
    set(hb,'units','pixel');
end

% ==============================================
%%   openDIR
% ===============================================
hb=uicontrol('style','pushbutton','units','norm','tag','setstatus','string','openDir');
set(hb,'position',[0.0017192 0.0672 0.05 0.035],'callback',{@proc,2});
set(hb,'tooltipstring',['open study-project folder']);
if setpixunits==1
    set(hb,'units','pixel');
end

% ==============================================
%%   set/remove/cancle/help
% ===============================================
hb=uicontrol('style','pushbutton','units','norm','tag','setstatus','string','load');
set(hb,'position',[0.0017192 0.0010506 0.1 0.05],'callback',{@proc,1});
set(hb,'tooltipstring',['load selected current project']);
if setpixunits==1
    set(hb,'units','pixel');
end


hb=uicontrol('style','pushbutton','units','norm','tag','cancel','string','Close');
set(hb,'position',[0.1031 0.0010506 0.1 0.05],'callback',{@proc,3});
set(hb,'tooltipstring',['close GUI']);
if setpixunits==1
    set(hb,'units','pixel');
end

% HELP
hb=uicontrol('style','pushbutton','units','norm','tag','help','string','help');
set(hb,'position',[0.20362 0.0010506 0.05 0.035],'callback',{@helps});
set(hb,'tooltipstring',['get some help']);
if setpixunits==1
    set(hb,'units','pixel');
end
% HELP
hb=uicontrol('style','pushbutton','units','norm','tag','deleteHistory','string','delete History');
set(hb,'position',[0.4 0.065 0.07 0.035],'callback',{@cb_deleteHistory});
set(hb,'tooltipstring',['This will delete the history!' char(10) ...
    ' # There is no way to restore the history!']);
if setpixunits==1
    set(hb,'units','pixel');
end


%
% % ----------------PARAMS
contextmenu_create(); %  contextMenu


% ----------------
if doshrinkGui==1
    set(findobj(hf,'tag','shrinkGUI'),'value',1);
    shrinkGUI();
end
if showuniquestudies==1
    set(findobj(hf,'tag','uniqueStudies'),'value',1);
    uniquestudies();
end
% set(gcf,'CloseRequestFcn',[]); %forced to be closed ..>> "closereq"

%% adjust figure-size
hb=findobj(gcf,'tag','table');
if size(hb.Data,1)<10
    posf=get(hf,'position');
    set(hf,'position',[posf(1:3) .33]);
end
%     0.1139    0.2044    0.4007    0.2600


%% ===============================================
%% ADJUST TABLE-COLUMN-width
%https://de.mathworks.com/matlabcentral/answers/98616-is-there-an-option-for-the-uitable-object-which-allows-the-width-of-the-columns-to-adjust-according
if u.istablesort==1
    unit_t=get(t,'units');
    set(t,'units','pixel');
    tablew = t.Position(3); %get with of the uitable
    maxLen = max(cellfun(@length,d0),[],1); % Calculate the with of the data in cell C.
    
    f =1.2+( tablew/sum(maxLen)); % Normalize it to the with of the table
    cellMaxLen = num2cell(maxLen*f);
    set(t, 'ColumnWidth', cellMaxLen);
    set(t,'units',unit_t);
    
    %----adjust table size
    if 1
        unit_f=get(gcf,'units');
        set(gcf,'units','pixels');
        pos=round(get(gcf,'position'));
        set(gcf,'position',[pos(1:2) sum(maxLen)*6  pos(4) ]);
        set(gcf,'units',unit_f);
        
    end
    
end
%% ==============TABLE VISIBLE=================================

set(hf,'visible','on');
%% ===============================================


% ==============================================
%%   sort option for table
% ===============================================
if u.istablesort==1
    ht=findobj(gcf,'tag','table');
    jscrollpane = findjobj(ht);
    jtable = jscrollpane.getViewport.getView;
    % Now turn the JIDE sorting on
    jtable.setSortable(true);		% or: set(jtable,'Sortable','on');
    jtable.setAutoResort(true);
    jtable.setMultiColumnSortable(true);
    jtable.setPreserveSelectionsAfterSorting(true);
end

function [ms bgcol]=getselection
hf=findobj(0,'tag','anthistory');
u=get(hf,'userdata');
if u.istablesort==1
    row=e.rowAtPoint(e2.getPoint());
    col=e.columnAtPoint(e2.getPoint());
    
    ms0={};
    for j=1:length(u.hd)
        ms0{j,1}=  u.jTable.getValueAt(row , j-1);
    end
    ms0 = regexprep(ms0, {'<.*?>','&nbsp;','\s+$'}, '' );
    ms=ms0;
    sn=u.jTable.getValueAt(row , j-1); %get color
    i1=min(strfind(sn,'=rgb('));
    i2=strfind(sn,')');  i2=i2(i2>i1);
    bgcol=str2num(regexprep(sn(i1:i2),{'=rgb','(' ')'},''))./255;
    ms=ms0;
else
    row=e.rowAtPoint(e2.getPoint())+1;
    col=e.columnAtPoint(e2.getPoint())+1;
    ms=u.d(row,:)';
    bgcol=u.coltab(row,:);
end
% ==============================================
%%
% ===============================================
function cellclicked(e,e2)
ix=e2.Indices;
hf=findobj(0,'tag','anthistory');
u=get(hf,'userdata');
% ix(1)
try
    
    if isempty(u.t.Data{ix(1),1})
        set(findobj(hf,'tag','ed_sel'),'string',u.txtmsgDefault,'backgroundcolor',[.9 .9 .9]);
        return
    end
    
    if u.istablesort==1
        ms0={};
        for j=1:length(u.hd)
            ms0{j,1}=  u.jTable.getValueAt(ix(1)-1 , j-1);
        end
        ms0 = regexprep(ms0, {'<.*?>','&nbsp;','\s+$'}, '' );
        ms=ms0;
        sn=u.jTable.getValueAt(ix(1)-1 , j-1); %get color
        i1=min(strfind(sn,'=rgb('));
        i2=strfind(sn,')');  i2=i2(i2>i1);
        bgcol=str2num(regexprep(sn(i1:i2),{'=rgb','(' ')'},''))./255;
    else
        ms=u.d(ix(1),:)';
        bgcol=[u.coltab(ix(1),:)];
    end
    
    
    msiz=size(char(u.hd),2);
    ms2=cellfun(@(a,b){['[' a ']'  repmat(' ' ,[1 msiz+5-length(a) ])  b ]}, u.hd' ,ms );
    
    he=findobj(gcf,'tag','ed_sel');
    set(he,'string',ms2);
    set(he,'fontname','Courier','fontsize',8);
    set(he,'backgroundcolor',bgcol,'enable','on');
    
    u.clicked=ms;
    set(hf,'userdata',u);
catch
    set(findobj(hf,'tag','ed_sel'),'string',u.txtmsgDefault,'backgroundcolor',[.9 .9 .9]);
    
end


function proc(e,e2,arg)

if arg==3;
    delete(findobj(0,'tag','anthistory'));
    return
elseif arg==2; %PATH
    hf=findobj(0,'tag','anthistory');
    u=get(hf,'userdata');
    try
        s=u.clicked;
        
        if exist(s{2})==7
            explorer(s{2});
        else
            msg_missingPath(s{2});
        end
        
        
        
    end
    
elseif arg==1;
    hf=findobj(0,'tag','anthistory');
    u=get(hf,'userdata');
    hs=findobj(hf,'tag','ck_stayopen');
    if get(hs,'value')==1
        set(hf,'CloseRequestFcn',[]); %forced to be closed ..>> "closereq"
    else
        set(hf,'CloseRequestFcn','closereq');
    end
    try
        s=u.clicked;
        pfile=fullfile(s{2}, s{3});
        if exist(pfile)==2
            
            cd(s{2});
            antcb('close');
            eval('base',['antcb(''load'', ''' pfile ''' );']);
            %         w=['antcb(''load'', ''' s{3} ''' );'];
            %         disp(w)
        else
            msg_missingCHECK(s{2}, pfile) ;
            
            return
            
        end
    end
end


function helps(e,e2)

uhelp([mfilename '.m']);

function shrinkGUI(e,e2)
hf=findobj(0,'tag','anthistory');
u=get(hf,'userdata');
hb=findobj(hf,'tag','shrinkGUI');
pos=get(hf,'position');
if get(hb,'value')==1
    set(hf,'position',[pos(1:2) pos(3)/2  pos(4)   ]);
else
    set(hf,'position',[pos(1:2) pos(3)*2  pos(4)   ]);
end



function cb_deleteHistory(e,e2)
hf=findobj(0,'tag','anthistory');
u=get(hf,'userdata');

button = questdlg('DO you really want to remove the history! ','');
if ~strcmp(button,'Yes'); return; end
istest=0;
if istest==0
    try; delete(u.p.fhist); end
    
else
    try;  movefile(u.p.fhist,fullfile(u.p.upa,'_antx2_userdef.mat'),'f') ; end
end
u.t.Data=repmat({''},[1 size(u.t.Data,2)]);
msgbox('history removed!');
set(findobj(hf,'tag','ed_sel'),'string',u.txtmsgDefault,'backgroundcolor',[.9 .9 .9]);




function mousemovedTable(e,e2)
hf=findobj(0,'tag','anthistory');
u=get(hf,'userdata');
if 1
    e2.getPoint;
    % jtable=e;
    % index = jtable.convertColumnIndexToModel(e2.columnAtPoint(e2.getPoint())) + 1
    if u.istablesort==1
        row=e.rowAtPoint(e2.getPoint());
        col=e.columnAtPoint(e2.getPoint());
        
        ms0={};
        for j=1:length(u.hd)
            ms0{j,1}=  u.jTable.getValueAt(row , j-1);
        end
        ms0 = regexprep(ms0, {'<.*?>','&nbsp;','\s+$'}, '' );
        ms=ms0;
        %         sn=u.jTable.getValueAt(row , j-1); %get color
        %         i1=min(strfind(sn,'=rgb('));
        %         i2=strfind(sn,')');  i2=i2(i2>i1);
        %         bgcol=str2num(regexprep(sn(i1:i2),{'=rgb','(' ')'},''))./255;
        ms=ms0;
    else
        row=e.rowAtPoint(e2.getPoint())+1;
        col=e.columnAtPoint(e2.getPoint())+1;
        ms=u.d(row,:)';
    end
    
    
    msiz=size(char(u.hd),2);
    ms2=cellfun(@(a,b){['[' a ']'  repmat(' ' ,[1 msiz+2-length(a) ])  b '<br>' ]}, u.hd' ,ms );
    ms2=strrep(ms2, ' ', '&nbsp;' );
    ms2{2}=[ '<font color=blue><b>' ms2{2} '</b></font> ' ];
    
    ms3=['<html><p style="font-family:''Monospace''">' strjoin(ms2,char(10))];
    e.setToolTipText(ms3);
end

function removefromhistory(e,e2)
% ==============================================
%%
% ===============================================

hf=findobj(0,'tag','anthistory');
u=get(hf,'userdata');

isel=u.jTable.getSelectedRows+1;

u.d(isel,:)=[];
u.coltab(isel,:)=[];
set(hf,'userdata',u);
u.t.Data(isel,:)=[];

% remove history from mat-file
load(u.p.fhist);
h.history(isel,:)=[];
if isempty(h.history)
    try; delete(u.p.fhist);end;
else
    save(u.p.fhist,'h');
end


function contextmenu_create()
% ==============================================
%%   contextMenu
% ===============================================
hf=findobj(0,'tag','anthistory');
u=get(hf,'userdata');
c = uicontextmenu;
m= uimenu(c,'Label','open study directory','Callback',{@context,'openStudyDir'},'separator','on');
m= uimenu(c,'Label',' show configfile','Callback',{@context,'showConfigfile'});

m= uimenu(c,'Label','export study or data of study..','Callback',{@context,'doublicateStudy'},'separator','on');

m= uimenu(c,'Label','delete current selection from history','Callback',@removefromhistory,'separator','on');
m= uimenu(c,'Label','delete history of THIS STUDY (all entries of this study is deleted)','Callback',{@context,'deleteStudy'});
m= uimenu(c,'Label','keep newest 3 entries  of THIS STUDY in history (remove the older entries)','Callback',{@context,'keepNewest3'});




set(u.t,'UIContextMenu',c);



function uniquestudies(e,e2)
%% ==============================================
%%
% ===============================================
hf=findobj(0,'tag','anthistory');
u=get(hf,'userdata');

hb=findobj(hf,'tag','uniqueStudies');
isunique=get(hb,'value');

if isunique==1 %SHOW UNIQUE FILES ONLY
    dl=cellfun(@(b,c,d){[ b c d]}, u.d(:,2),u.d(:,3),u.d(:,4) );
    unistud=unique(dl);
    iuni=[];
    for i=1:length(unistud)
        iuni(end+1,1)=min(find(strcmp(dl,unistud{i})));
    end
    iuni          =sort(iuni);
    uni.d2      =u.d(iuni,:);
    uni.coltab2 =u.coltab(iuni,:);
    
    u.d=uni.d2;
    u.coltab=uni.coltab2;
    set(hf,'userdata',u);
    u.t.Data=u.t.Data(iuni,:);
    set(findobj(hf,'tag','deleteHistory'),'enable','off');
    %set(u.t ,'UIContextMenu',[]);
else
    set(findobj(hf,'tag','deleteHistory'),'enable','on');
    contextmenu_create(); %  contextMenu
    
    load(u.p.fhist);
    [d d0  coltab]=table2html(h);
    %u.hd    =hd;
    u.d      =d0; %!!!this is without HTML!
    u.coltab=coltab;
    set(hf,'userdata',u);
    u.t.Data=d;
end


%% ===============================================

function context(e,e2,task)
hf=findobj(0,'tag','anthistory');
u=get(hf,'userdata');
hb=findobj(hf,'tag','uniqueStudies');
isunique=get(hb,'value');

isel=u.jTable.getSelectedRows+1;
if isempty(isel); msgbox('select something'); return; end


if strcmp(task,'deleteStudy') ||  strcmp(task,'keepNewest3')
    
    
    
    selx=u.d(isel,:);
    
    for i=1:size(selx)
        sel=selx(i,:);
        
        selstr=cellfun(@(b,c,d){[ b c d]}, sel(:,2),sel(:,3),sel(:,4) );
        load(u.p.fhist);
        [d d0  coltab]=table2html(h);
        dstr=cellfun(@(b,c,d){[ b c d]}, d0(:,2),d0(:,3),d0(:,4) );
        
        ixremove=find(strcmp(dstr,selstr));
        if strcmp(task,'keepNewest3')
            %if length(ixremove)>3
            ixremove= ixremove(4:end);
            %             else
            %
            %             end
        end
        
        
        d(ixremove,:)     =[];
        d0(ixremove,:)    =[];
        coltab(ixremove,:)=[];
        u.t.Data=d;
        u.d      =d0; %!!!this is without HTML!
        u.coltab=coltab;
        set(hf,'userdata',u);
        %--------delete from history
        h.history(ixremove,:)=[];
        if isempty(h.history)
            try; delete(u.p.fhist);end;
        else
            save(u.p.fhist,'h');
        end
    end
    if isunique==1
        uniquestudies([],[]);
        
    end
    
elseif strcmp(task,'openStudyDir')
    for i=1:length(isel)
        if exist(u.d{isel(i),2})==7
            explorer(u.d{isel(i),2});
        else
            msg_missingPath(u.d{isel(i),2});
        end
    end
elseif strcmp(task,'showConfigfile')
    for i=1:length(isel)
        pfile=fullfile(u.d{isel(i),2}, u.d{isel(i),3});
        if exist(pfile)~=2
            msg_missingConfigfile(pfile);
            return
        end
        edit(pfile);
    end
elseif strcmp(task,'doublicateStudy')
    
    for i=1:length(isel)
        pfile=fullfile(u.d{isel(i),2}, u.d{isel(i),3});
        if exist(pfile)==2
            doublicateStudy(pfile);
            return
        end
    end
end



function doublicateStudy(pfile)

% pfile
%% ===============================================
paWD=pwd;
[paIN fun ext]=fileparts(pfile);
cd(paIN);
run([fun ext]);
cd(paWD);

study=fileparts(x.datpath);
k=dir(study);
sub={k(:).name}';
iupp=regexpi2(sub,'^\.$|^\..$');
sub(iupp)=[];
isdir=[k(:).isdir]';
isdir(iupp)=[];
type=repmat({'file'},[length(isdir) 1]);
type(isdir)={'dir'};



% =========[select subFiles/dirs]======================================
t=[sub type];
t=sortrows([t],[2 1]);
ht={'Name' 'Type'};
% hpresel =[1:size(t,1)];
htit    ='STEP1/3: select files/dirs to copy';
hpos    =[ 0.0826    0.3128    0.5062    0.4144];
% hnote   ={'select files & folders to copy...'};
drawnow;
id=selector2(t,ht,'iswait',1,'finder',1,'title',htit,...
    'position',[hpos]);%,'note',hnote);
drawnow;
if id==-1; return; end
t=t(id,:);
if isempty(t); return; end
%% =========[select dat-folder]======================================
animals=[];
if ~isempty(find(strcmp(t(:,1),'dat')))
    k=dir(x.datpath);
    sub={k(:).name}';
    iupp=regexpi2(sub,'^\.$|^\..$');
    sub(iupp)=[];
    isdir=[k(:).isdir]';
    isdir(iupp)=[];
    type=repmat({'file'},[length(isdir) 1]);
    type(isdir)={'dir'};
    
    t2=[sub type];
    ht2={'Files' 'Type'};
    hpresel =[1:size(t2,1)];
    htit    ='select animals to copy';
    hpos    =[ 0.0826    0.3128    0.5062    0.4144];
    hnote   ={'STEP2/3: select Animals to export...'};
    id2=selector2(t2,ht2,'iswait',1,'finder',1,'title',htit,...
        'position',[hpos]);%,'note',hnote); ,'preselect',hpresel,
    drawnow;
    animals=t2(id2,:);
end
%% ==========[select files]=====================================
if ~isempty(animals)
    %  generate list of nifit-files within pa-path
    pa=stradd(animals(:,1),[ x.datpath filesep ],1);
    fi2={};
    for i=1:length(pa)
        [files,~] = spm_select('FPListRec',pa{i}) ;%,['.*.nii$']);
        if ischar(files); files=cellstr(files);   end;
        fis=strrep(files,[pa{i} filesep],'');
        fi2=[fi2; fis];
    end
    li=unique(fi2);
    
    t3=[li  ];
    ht3={'Files' };
    hpresel =[1:size(t3,1)];
    htit    ='select files to copy';
%     hpos    =[ 0.0826    0.3128    0.5062    0.4144];
    hnote   ={'STEP3/3: select files from "dat"-folder to copy...'};
    id3=selector2(t3,ht3,'iswait',1,'finder',1,'title',htit);%,...
%         'note',hnote); 
    drawnow;
    datfiles=t3(id3,:);
end

%% ============[make outputfolder]===================================
[pax studyname ]=fileparts(study);
newstudy=fullfile(pax, [studyname '__exportTEMP']);
if exist(newstudy)~=7
    mkdir(newstudy);
end
%% ============[copy everything besides of dat-folder]===================================
isdatfolderSelected=~isempty(find(strcmp(t(:,1),'dat')));
if isdatfolderSelected==1
    padatNew=fullfile(newstudy,'dat');
    if exist(padatNew)~=7
        mkdir(padatNew);
    end
end
t(strcmp(t(:,1),'dat'),:  )=[];
if ~isempty(t)
    fprintf(' copy subdir files/folders..');
    for i=1:size(t,1)
        f1=fullfile(study,t{i,1});
        f2=fullfile(newstudy,t{i,1});
        copyfile(f1,f2,'f');
    end
end

%% ============[copy  dat-folder]===================================
padatNew=fullfile(newstudy,'dat');
if isdatfolderSelected==1
    if exist(padatNew)~=7
        mkdir(padatNew);
    end
    if ~isempty(animals)
        fprintf(' copy animal-files/folders..');
        for j=1:size(animals,1)
            pa_newanimal=fullfile(padatNew, animals{j,1});
            pa_oldanimal=fullfile(x.datpath, animals{j,1});
            
            
            for i=1:size(datfiles,1)
                f1=fullfile(pa_oldanimal,datfiles{i} );
                % exist(f1)
                if exist(f1)==2 %if exist in source...
                    f2=fullfile(pa_newanimal,  datfiles{i})   ;
                    [pam ]=fileparts(f2);
                    if exist(pam)~=7 ;
                        mkdir(pam);
                    end
                    copyfile(f1,f2,'f');
                end
            end
            
        end
    end
end
%% ========[change proj.file]=======================================
f1=fullfile( newstudy, [ fun ext]);
if exist(f1)==2
    fprintf(' change projectfile..');
    a=preadfile(f1); a=a.all;
    
    is=regexpi2(a,'x.datpath');
    r=a{is};
    q1=r(1: min(strfind(r,'=')));
    q2=['''' padatNew ''''];
    q3=r(min(strfind(r,'%')):end);
    r2=[q1 '  ' q2 '   '  q3];
    a2=a;
    a2(is)={r2};
    pwrite2file(f1,a2);
end

% ==============================================
%%   
% ===============================================
fprintf('\n');
showinfo2(['exported folder:'],newstudy);
cprintf('*[0 .5 0]',[ '..exporting study Done! ' '\n'] );



% ==============================================
%%   messages
%% ===============================================
%% MISSING PATH
%% ===============================================
function msg_missingPath(path)
%% ===============================================
opts.WindowStyle='replace';
opts.Interpreter='tex';
msg={['Study-path not found:' ...
    '\color{magenta} "' ...
    strrep(strrep(path,filesep,[filesep filesep ]),'_', '\_')   '"' '\color{black}'  ' missing.' ...
    char(10) ' - presumably renamed or deleted over time'  ...
    char(10) ' - process terminated! '] ...
    };
titl='Warning';
warndlg(msg,titl,opts);
%% ===============================================
%% MISSING Configfile
%% ===============================================
function msg_missingConfigfile(configfile)
%% ===============================================
opts.WindowStyle='replace';
opts.Interpreter='tex';
msg={['Configfile not found:' ...
    '\color{blue} "' ...
    strrep(strrep(configfile,filesep,[filesep filesep ]),'_', '\_')   '"' '\color{black}'  ' missing.' ...
    char(10) ' - presumably renamed or deleted over time'  ...
    char(10) ' - process terminated! '] ...
    };
titl='Warning';
warndlg(msg,titl,opts);

%% ===============================================
%% MISSING Configfile
%% ===============================================
function msg_missingCHECK(path, configfile)
%% ===============================================
def={'exists' 'exists'};
if exist(path      )~=7 ;    def{1}= 'missing'  ; end
if exist(configfile)~=2 ;    def{2}= 'missing'  ; end


opts.WindowStyle='replace';
opts.Interpreter='tex';
msg={[...
    '\color{black} \bf Study-path: \rm\color{magenta} "'  strrep(strrep(path,filesep,[filesep filesep ]),'_', '\_')   '"' '\color{black} '  def{1} '.' ...
    char(10) '\color{black} \bf Configfile: \rm\color{blue}    "'  strrep(strrep(configfile,filesep,[filesep filesep ]),'_', '\_')   '"' '\color{black} ' def{2} '.' ...
    char(10) ' - presumably renamed or deleted over time'  ...
    char(10) ' - process terminated! '] ...
    };
titl='Warning: MIssing input';
warndlg(msg,titl,opts);

%% ===============================================
%% ===============================================

function [d d0  coltab]=table2html(h)

[~, pfiles ext ]=fileparts2(h.history(:,3));
h.history(:,3)=[cellfun(@(a,b){[ a b ]}, pfiles, ext) ];

d0=h.history;
d=h.history;
coltab=zeros(size(d,1),3);
if 1
    unipath=unique(d(:,2));
    if length(unipath)<3
        col=cbrewer('qual', 'Pastel1', 3);
    else
        col=cbrewer('qual', 'Pastel1', length(unipath));;% fg,imagesc(permute(CT,[3 1 2 ]))
    end
    dpa=d(:,2);
    for i=1:length(unipath)
        is=find(strcmp(d(:,2),unipath{i} ));
        % --M1----
        %         dum=[  '<html><pre> <b><font color="black"> <b><font bgcolor=rgb(' sprintf('%d,%d,%d',(col(i,:)*255)) ')>'  unipath{i} '</pre>'];
        % --M2-----
        %dum=['<html><table border=0 width=1400 bgcolor=rgb(' sprintf('%d,%d,%d',(col(i,:)*255)) ')><TR><TD>' unipath{i}  '</TD></TR> </table>'  ]
        %dpa(is)={dum};
        % --M3-----
        dum=cellfun(@(a){[...
            '<html><table border=0 width=1400 bgcolor=rgb(' sprintf('%d,%d,%d',(col(i,:)*255)) ')><TR><TD>'   ...
            a ...
            '</TD></TR> </table>'...
            ]},   d(is,:));
        d(is,:)=dum;
        coltab(is,:) =  repmat(col(i,:),[ length(is)  1]); %colortable
    end
end




% ==============================================
%% main fig key
% ===============================================
function keys(e,e2)
hf=findobj(0,'tag','anthistory');


if strcmp(e2.Key,'space')
    hb=findobj(gcf,'tag','shrinkGUI');
    val= get(hb,'value');
    set(hb,'value',~val);
    hgfeval(get( hb ,'callback'),[]);
end

% function windowclick(e,e2)
% 'a'

% % ==============================================
% %%   fig-shortcuts: shift
% % ===============================================
%
% if strcmp(e2.Modifier,'shift')
%     hp3 =findobj(gcf,'tag','panel3'); %panel3
%     %disp('shift-not defined');
%     if  strcmp(e2.Key,'leftarrow')                        %slider contour -L
%
%         hvis=findobj(hp3,'tag','thresh_visible'); %visible
%         if get(hvis,'value')==1
%             slid_thresh_set(-.01);
%         end
%     elseif strcmp(e2.Key,'rightarrow')                     %slider contour -R
%
%         hvis=findobj(hp3,'tag','thresh_visible');
%         if get(hvis,'value')==1
%             slid_thresh_set(+.01);
%         end
%     elseif strcmp(e2.Key,'c')                                 % visible contour
%         hc=findobj(hp3,'tag','thresh_visible');
%         set(hc,'value', ~get(hc,'value'));
%        slid_thresh();
%     end
%
%
%     return
% end

