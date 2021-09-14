
% #ok save history/ and select ans load a project from history

% This function allows to set an animal-specific processing status tag (OK, BAD; ISSUE,
% USERDEFIND).

function anthistory(task)

%===================================================================================================

p.upa=fullfile(userpath,'antx2_userdef');
p.fhist=fullfile(p.upa, 'userdef.mat' );



%===================================================================================================

if strcmp(task,'update')
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
mkdir(upa);


global an

pa        =fileparts(an.datpath); 
timx      =datestr(now);

[pac namec extc]=fileparts(an.configfile);
if isempty(extc); extc='.m'; end
configfile=fullfile(pac,[namec extc]);

user=char(java.lang.System.getProperty('user.name'));


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

% ==============================================
%%   
% ===============================================

figpos=[ 0.1139    0.2044    0.8014    0.5711];

delete(findobj(0,'tag','anthistory'));
hf=figure('units','norm','menubar','none','color','w','tag','anthistory',...
    'name','anthistory','numbertitle','off');
% set(hf,'position',[0.3937    0.4011    0.3542    0.1544])
set(hf,'position',figpos);

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
    %d(:,2)=dpa;
end

% uitable('Data',{'<html><table border=0 width=400 bgcolor=#FF0000><TR><TD>Hello</TD></TR> </table>' })


% Create the uitable
t = uitable('Data', d,... 
            'ColumnName', columnname,...
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
% set(jTable,'MousemovedCallback',@mousemovedTable);
% end
if 1
    set(t, 'CellSelectionCallback',@cellclicked);
end
% set(t,'units','norm','position',[0 .2 1 .6])
set(t,'units','norm','position',[0 .2 1 .8]);


% ----------------PARAMS
u.p=p;
u.hd=h.hhistory;
u.d=d0;
u.t=t;
u.coltab=coltab;
u.figpos=figpos;
set(gcf,'userdata',u)

% ----------------


% ==============================================
%%   edit: selection
% ===============================================
hb=uicontrol('style','text','units','norm','tag','ed_sel','string','<empty>');
set(hb,'position',[0.001 .1 .5 .1]);%,'callback',{@proc,1});
set(hb,'tooltipstring',['the currently selected study']);
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
%%   openDIR
% ===============================================
hb=uicontrol('style','pushbutton','units','norm','tag','setstatus','string','openDir');
set(hb,'position',[0.0017192 0.0672 0.05 0.035],'callback',{@proc,2});
set(hb,'tooltipstring',['open Study-project folder']);
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


hb=uicontrol('style','pushbutton','units','norm','tag','cancel','string','cancel');
set(hb,'position',[0.1031 0.0010506 0.1 0.05],'callback',{@proc,3});
set(hb,'tooltipstring',['cancel process']);
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
hb=uicontrol('style','pushbutton','units','norm','tag','help','string','delete History');
set(hb,'position',[0.4 0.065 0.07 0.035],'callback',{@cb_deleteHistory});
set(hb,'tooltipstring',['This will delete the history! (there is no way back)']);
if setpixunits==1
    set(hb,'units','pixel');
end

% 
% % ----------------PARAMS
% u.hd=h.hhistory;
% u.d=d0;
% u.t=t;
% u.coltab=coltab;
% u.figpos=figpos;
% set(gcf,'userdata',u)

% ----------------
if doshrinkGui==1
    set(findobj(hf,'tag','shrinkGUI'),'value',1);
    shrinkGUI();
end

% set(gcf,'CloseRequestFcn',[]); %forced to be closed ..>> "closereq"


% ==============================================
%%   
% ===============================================
function cellclicked(e,e2)
ix=e2.Indices;
hf=findobj(0,'tag','anthistory');

% ix(1)
try
    u=get(hf,'userdata');
    if isempty(u.t.Data{ix(1),1})
        set(findobj(hf,'tag','ed_sel'),'string','<empty>','backgroundcolor',[.9 .9 .9]);
        return
    end
    
    ms=u.d(ix(1),:)';
    msiz=size(char(u.hd),2);
    ms2=cellfun(@(a,b){['[' a ']'  repmat(' ' ,[1 msiz+5-length(a) ])  b ]}, u.hd' ,ms );
    
    he=findobj(gcf,'tag','ed_sel');
    
    
    
    set(he,'string',ms2);
    set(he,'fontname','Courier','fontsize',8);
    set(he,'backgroundcolor',[u.coltab(ix(1),:)],'enable','on');
    
    u.clicked=ms;
    set(hf,'userdata',u);
catch
    set(findobj(hf,'tag','ed_sel'),'string','<empty>','backgroundcolor',[.9 .9 .9]);
    
end


function proc(e,e2,arg)

if arg==3; 
    delete(findobj(0,'tag','anthistory')); 
    return
elseif arg==2; 
    hf=findobj(0,'tag','anthistory');
    u=get(hf,'userdata');
    try
        s=u.clicked;
        explorer(s{2});
        
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
        cd(s{2});
        antcb('close');
        eval('base',['antcb(''load'', ''' s{3} ''' );']);
%         w=['antcb(''load'', ''' s{3} ''' );'];
%         disp(w)
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
istest=1;
if istest==0
   try; delete(u.p.fhist); end
    
else
  try;  movefile(u.p.fhist,fullfile(u.p.upa,'_antx2_userdef.mat'),'f') ; end
end
u.t.Data=repmat({''},[1 size(u.t.Data,2)]);
msgbox('history removed!');
 set(findobj(hf,'tag','ed_sel'),'string','<empty>','backgroundcolor',[.9 .9 .9]);
