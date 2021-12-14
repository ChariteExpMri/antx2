
% SIMPLE CHECKbox-uitable
% out=uitable_checklist(tb,tbh,varargin)
% tb   : table cellarray ..see uitable
% tbh  : header {cell} of 'th'
% varagin: additional pairwise input:
% 'title'       :figure title (string);                    default: ''
% 'tooltip'     :uitable tooltip of the uitable (string);  default: ''
% 'pos'         :figure position; default: [ 0.3049    0.4311    0.1174    0.4544];
% 'postab'      :position of the uitable; default: [0 0.05 .89 .95];
% 'editable'    :vector of indices of editable columns {default: [1]...first column is editable}
% 'autoresize'  :0/1; [1] fit columns to figure
% 'help'        :"msg" (cell) adds a help-icon, when clicked,displays a help window with
%                 the content of the cell-array "msg"
% 'rowcolorcol' :[column-index of the table/scalar]: highlighta rows with identical entries in
%                 the column specified in 'rowcolorcol'
% 'issortable'   [0/1]: If [1]: allows to sort the table by columns. The content of each row
%                 is preserved. The output array is in the order of the original input-array
%% output      : modified array (same order as input array)
%
%% EXAMPLE-1a
%  tbh={'Region-ID'  'anatomical Regions'              'notation'  'cBox1' 'cBox2'};
%     tb ={ 1  'L_Somatosensory_areas_MODIF'                     'fine'   false false
%         2  'L_Anterior_cingulate_area_ventral_part_6b_MODIF' ''       false true
%         3  'L_Prelimbic_area_layer_6b_MODIF'                 'ok'     false false
%         4  'L_Infralimbic_area_layer_6b_MODIF'               ''       true  false
%         5  'L_Orbital_area_lateral_part_layer_6b_MODIF'      'ok'     false false
%         6  'L_Orbital_area_medial_part_layer_6b_MODIF'       'fine'   true false};
%
%     out=uitable_checklist(tb,tbh,'editable',[ 3 4 5],'title','XXX','tooltip' ,['modify me' char(10) '..'],...
%         'pos', [.2 .2 .5 .3],'iswait',0,'help',{'put some help here'},'autoresize',1,...
%         'rowcolorcol',3,'issortable',1);%,'postab', [0 0  1 1]);
%
%% EXAMPLE-1b
%     tbh={'show' 'ColumnName'};
%     tb={[1]    'x'
%         [0]    'label1'
%         [1]    'x'
%         [0]    'label2'
%         [1]    'c'};
%     tb(:,1)=cellfun(@(a){[logical(a)]} ,tb(:,1));%make logical (checkbox)
%    out=uitable_checklist(tb,tbh);
%% EXAMPLE-2a: both columns editable, set title and tooltip
%    out=uitable_checklist(tb,tbh,'editable',[1 2],'title','XXX','tooltipstr' ,['xx' char(10) 'yy']);
%% EXAMPLE-2b:
% out=uitable_checklist(repmat(tb,[1 10]),[],'pos', [.2 .2 .3 .3],'postab', [0 .5  1 .3]);
function out=uitable_checklist(tb,tbh,varargin)

if 0
    
    % ==============================================
    %%
    % ===============================================
    clc;
    tbh={'show' 'ColumnName'};
    tb={[1]    'x'
        [0]    'label1'
        [1]    'x'
        [0]    'label2'
        [1]    'c'
        [0]    'col1'
        [1]    'c'
        [0]    'col2'
        [1]    'R1'
        [0]    'R2'
        [1]    'T1'
        [0]    'T2'
        [1]    'co1'
        [0]    'co2'
        [1]    'x'
        [0]    'cs'
        [1]    'c'
        [0]    'Lcol'
        [1]    'LR'
        [0]    'LT' } ;
    tb(:,1)=cellfun(@(a){[logical(a)]} ,tb(:,1));
    out=uitable_checklist(tb,tbh);
    
    % ==============================================
    %%
    % ===============================================
    
end

warning off;
% ==============================================
%%  defaults
% ===============================================
out=[];
p=struct();
% -----------------
p.title    =''  ;%fig-title
p.tooltip  =''  ;%tooltipstring
p.pos      =[ 0.3049    0.4311    0.1174    0.4544]; %figure position
p.postab   =[0 0.05 .89 .95];  %table position
p.editable =[1] ;% indices of editable columns
p.autoresize=0  ; %auto resize table to figure[0,1]
p.iswait    =  1; %wait window to close
p.help      =  0; %no help-icon
p.isbtnSelectall =1;
p.issortable     =1;
p.list4addString={''};

% ==============================================
%%  defaults
% ===============================================
if nargin>2
    pin=cell2struct(varargin(2:2:end),varargin(1:2:end),2);
    p=catstruct(p,pin);
end




% ==============================================
%%   PREFTABLE
% ===============================================
if 0
    tb=[num2cell(logical(cell2mat(u.t.ColumnWidth')~=0)) u.t.ColumnName];
    tbh={'show' 'ColumnName'};
    figtitle='showColumns';
    tooltip=['select columns to show or hide' char(10)...
        '[0] hide ; [1] show column'];
    posfig=[ 0.3049    0.4311    0.1174    0.4544];
    postab=[0 0.05 .89 .95];
end

% --------------------
delete(findobj(0,'tag'  ,'prefTable'));
fg;
set(gcf,'numbertitle','off','tag','prefTable','name',[p.title ],...
    'menubar','none','units','norm');
set(gcf,'position',p.pos);
t = uitable('Parent', gcf,'units','norm', 'Position', p.postab, ...
    'Data', tb,'tag','table',...
    'ColumnWidth','auto','fontsize',7);
set(t,'position',[[0 0.05 1 .95]]);
t.ColumnName =tbh;
set(t,'RowName',{});
set(t,'TooltipString',p.tooltip);

editable=repmat(false,[1 length(tbh)]);
editable(p.editable)=true; %make speicif columns editable
t.ColumnEditable=editable;

%%  -----[contextMenu]---------------
icolLogical=find(cell2mat(cellfun(@(a){[  islogical(a)]} ,t.Data(1,:))));
cmenu = uicontextmenu;
if ~isempty(icolLogical)
    for i=1:length(icolLogical)
        logicLab=tbh{icolLogical(i)};
        logicCol=icolLogical(i);
        hs = uimenu(cmenu,'label',['<html>un/select in <b>[' logicLab ']</b>-column'],     'Callback',{@context, ['selectCol-' num2str(logicCol) ] },'separator','off');
    end
end
icolstrEditable=setdiff(find(t.ColumnEditable), icolLogical);
if ~isempty(icolstrEditable)
    for i=1:length(icolstrEditable)
        editLab=tbh{icolstrEditable(i)};
        leditCol=icolstrEditable(i);
        hs = uimenu(cmenu,'label',['<html><font color=blue>add string in <b>[' editLab ']</b>-column'],     'Callback',{@context, ['addStringCol-' num2str(leditCol) ] },'separator','off');
    end
end
if ~isempty(icolstrEditable)
    for i=1:length(icolstrEditable)
        editLab=tbh{icolstrEditable(i)};
        leditCol=icolstrEditable(i);
        hs = uimenu(cmenu,'label',['<html><font color=red>delete entries in <b>[' editLab ']</b>-column'],     'Callback',{@context, ['deleteStringCol-' num2str(leditCol) ] },'separator','off');
    end
end

set(t,'UIContextMenu',cmenu);

%%  -----[BGcolor]---------------
set(t,'CellSelectionCallback',@table_selectionCB);
set(t,'CellEditCallback',@table_editCB);

if isfield(p,'bgcol')
    p.bgcol0=p.bgcol;
else
    p.bgcol0=get(t,'backgroundcolor');
end
if size(p.bgcol0,1)~=size(tb,1)
    p.bgcol0= repmat(p.bgcol0,[size(tb,1)  1]);
    p.bgcol0=p.bgcol0(1:size(tb,1),:);
end


% p.dfcol=distinguishable_colors(size(tb,1),[1 1 1; 0 0 0]);
p.dfcol=cbrewer('qual', 'Pastel1',size(tb,1) );
drawnow;
% -----[autoresize table]---------------
hjpane = findjobj(t);
hj = hjpane.getViewport.getView;

htb2=tbh;
if p.autoresize==1
    drawnow;
    hj.setAutoResizeMode(hj.AUTO_RESIZE_SUBSEQUENT_COLUMNS);
    drawnow;
    %---resize COLUMNS accord max filed-length
    lend =max(cell2mat(cellfun(@(a){[length(a)]} ,tb)));
    lenh =cell2mat(cellfun(@(a){[length(a)]} ,tbh));
    ic=find(lenh<lend);
    df=lend-lenh;
    %tbh2=tbh;
    tbh2(ic)=cellfun(@(a){[ repmat(['_'],[1, round(df(ic)) ]) (a) repmat(['_'],[1, round(df(ic)) ])]} ,tbh(ic));
    t.ColumnName =tbh2;
end
% ___HIGHLIGHT EDUTABLE COLUMNS BY COLOR of-header-string_
% '<html><font color="blue">'
tbh3=htb2;
tbh3(find(editable))=cellfun(@(a){[  '<html><font color="blue">' a]} ,tbh3(find(editable)));
t.ColumnName=tbh3;


% ----------[SORTING]------------------
% hjpane = findjobj(t);
% hj = hjpane.getViewport.getView;
if p.issortable==1
    
    % Now turn the JIDE sorting on
    hj.setSortable(true);		% or: set(jtable,'Sortable','on');
    hj.setAutoResort(true);
    hj.setMultiColumnSortable(true);
    hj.setPreserveSelectionsAfterSorting(true);
    drawnow
end
% ----------------------------




% select all

hb=uicontrol('parent',gcf, 'style','radio','units','pixels','tag','prefTable_select');
set(hb,'position',[ 52.9441    0.5100   84.5280   20.4480],'backgroundcolor','w',...
    'string','select all','foregroundcolor','k',...
    'fontweight','bold','fontsize',6);
set(hb,'tooltipstring','select/deselect all','callback',{@prefTable,'selectall'});
set(hb,'units','pixels')
if p.isbtnSelectall==0
    set(hb,'visible','off');
end
%OK
hb=uicontrol('parent',gcf, 'style','pushbutton','units','pixels','tag','prefTable_ok');
set(hb,'position',[119.3392    1.0000   50.7168   20.4480], ...
    'backgroundcolor','w','string','OK','foregroundcolor','b',...
    'fontweight','bold');
set(hb,'tooltipstring','OK...done','callback',{@prefTable,'ok'});
set(hb,'units','pixels')
%Cancel
hb=uicontrol('parent',gcf, 'style','pushbutton','units','pixels','tag','prefTable_cancel');
set(hb,'position',[1.0000    1.0000   50.7168   20.4480],...
    'backgroundcolor','w','string','Cancel','foregroundcolor','b',...
    'fontweight','bold');
set(hb,'tooltipstring','cancel...abort','callback',{@prefTable,'cancel'});
set(hb,'units','pixels');

if isfield(p,'help') && ~isnumeric(p.help)
    %% help
    hb=uicontrol('style','pushbutton','string','','units','norm');
    set(hb,'position',[0.2 .96,.03 .04],'callback',@cb_help);
    ic=getIcon('bulb');
    set(hb,'cdata',ic);
    set(hb,'tooltipstring','get some help');
    % set(hb,'position',[0.2 .96,.03 .04]);
    set(hb,'units','pixels','position', [172 2 15 15]);
end

% --------------
% catstruct()
u    =p;
u.tb =tb;
u.tbh=tbh;
u.isOK=0;
u.t   =t;
u.hj  =hj;
set(gcf,'userdata',u)


if isfield(p,'rowcolorcol') && ~isempty(p.rowcolorcol);
    if p.rowcolorcol>size(tb,2)
        error([ '[rowcolorcol] is larger than number of columns in the table! \n REDUCE VALUE OF [rowcolorcol]!' ]) ;
    end
    e2.Indices=[nan p.rowcolorcol];
    color_rows_byColumn([],e2)
end

% ========================== WAIT ==============================================
if p.iswait==1
    uiwait(gcf);
    
else
    return
end
try %case closing the fig via [x]-btn
    u=get(gcf,'userdata');
    
    u.hj.setSortable(false);
    drawnow;
    
    if u.isOK==1
        out= u.t.Data;
    end
    close(gcf);
end



% ==============================================
%%   SUBFUN
% ===============================================
function context(e,e2,task)
u=get(gcf,'userdata');
t=findobj(gcf,'tag','table');
% tj=findjobj(t);
js = findjobj(t);
hj = js.getViewport.getView;

%-----in checkbox-x/y  select highlighted rows
if ~isempty(strfind(task,'selectCol-'))
    col=str2num(regexprep(task,'selectCol-',''));
    irow=hj.getSelectedRows+1;
    curval=cell2mat(u.t.Data(irow,col));
    if length(unique(curval))==1
        u.t.Data(irow,col)=num2cell(~curval);
    else
        u.t.Data(irow,col)=num2cell(logical(ones(length(curval),1)));
    end
    rows=u.hj.getSelectedRows()+1;
    color_rows_byColumn([],rows);
    
elseif ~isempty(strfind(task,'deleteStringCol-'))
    col=str2num(regexprep(task,'deleteStringCol-',''));
    irow=hj.getSelectedRows+1;
    u.t.Data(irow,col)={''};
    
    if isfield(u,'rowcolorcol') && ~isempty(u.rowcolorcol);
        u=rmfield(u, 'rowcolorassign');
        set(gcf,'userdata',u);
        %k2.Indices=[nan u.rowcolorcol];
        color_rows_byColumn([],[]);
    end
elseif ~isempty(strfind(task,'addStringCol-'))
    col=str2num(regexprep(task,'addStringCol-',''));
    irow=hj.getSelectedRows+1;
    
    
    figunits=get(gcf,'units');
    set(gcf,'units','pixels')
    co=get(gcf,'CurrentPoint');
    set(gcf,'units',figunits);
    
    
    %% ---addString [as]
    uni=unique(u.t.Data(:,col));
   
    uni=unique([uni;u.list4addString() ]);
    uni(strcmp(uni,''))=[]; uni(end+1)={''};
    
    delete(findobj(gcf,'tag','as_pan'))
    hpan=uipanel('units' ,'pixel','tag','as_pan','title','adstring');
    set(hpan,'position',[co(1)+40 co(2)-40 220 40],'backgroundcolor',[1 .8 0]);
    
    position = [10,100,90,20];  % pixels
    model = javax.swing.DefaultComboBoxModel(uni);
    [jCombo hb] = javacomponent('javax.swing.JComboBox', position, hpan);
    jCombo.setModel(model);
    jCombo.setEditable(true);
    %jCombo.setBackground(java.awt.Color({num2cell([1 0 0])'}));
    %jCombo.setBackground(java.awt.Color(1,0,1));
    set(hb,'position',[5 5 100 20]);
    
    hp=uicontrol(hpan, 'style', 'pushbutton', 'units' ,'pixel','tag','as_ok','string','ok');
    set(hp,'position',[130 5 40 20],'backgroundcolor',[1 1 1]);
    set(hp,'tooltipstring','ok set this string');
    set(hp,'callback',{@as_cb,'ok'});
    
    hp=uicontrol(hpan, 'style', 'pushbutton', 'units' ,'pixel','tag','as_cancel','string','cancel');
    set(hp,'position',[170 5 40 20],'backgroundcolor',[1 1 1]);
    set(hp,'tooltipstring','cancel...do nothing');
    set(hp,'callback',{@as_cb,'cancel'});
    %% ---
    
    us.info='addString';
    us.jCombo=jCombo;
    us.irow  =irow;
    us.col   =col;
    set(hpan,'userdata',us);
    
    return
    
    u.t.Data(irow,col)={''};
    
    if isfield(u,'rowcolorcol') && ~isempty(u.rowcolorcol);
        u=rmfield(u, 'rowcolorassign');
        set(gcf,'userdata',u);
        %k2.Indices=[nan u.rowcolorcol];
        color_rows_byColumn([],[]);
    end
end

function as_cb(e,e2,job)
hp=findobj(gcf,'tag','as_pan');
us=get(hp,'userdata');
u=get(gcf,'userdata');
if strcmp(job,'ok')
    str=char(us.jCombo.getSelectedItem);
    u.t.Data(us.irow,us.col)={str};
    
    list={};                                    % MEMORY: update available list for next selection
    for i=1:us.jCombo.getItemCount
       list{i,1}= char(us.jCombo.getItemAt(i-1));
    end
    list{end+1}=str;
    list(find(strcmp(list,'')))=[];
    list=unique(list);
    u.list4addString=list;
    
    
    set(gcf,'userdata',u);
    if isfield(u,'rowcolorcol') && ~isempty(u.rowcolorcol);
        %try; u=rmfield(u, 'rowcolorassign'); end
        %set(gcf,'userdata',u);
        %k2.Indices=[nan u.rowcolorcol];
        rows=u.hj.getSelectedRows()+1;
        color_rows_byColumn([],rows);
    end
    
end
delete(hp)



function table_selectionCB(e,e2)

% 's'

function table_editCB(e,e2)

u=get(gcf,'userdata');
t=findobj(gcf,'tag','table');
if isfield(u,'rowcolorcol') && ~isempty(u.rowcolorcol)
    if u.rowcolorcol==e2.Indices(2)% if the column defined in "rowcolorcol" is clicked
        color_rows_byColumn(e,e2);
    end
end

function color_rows_byColumn(e,e2,force)
u=get(gcf,'userdata');
t=findobj(gcf,'tag','table');

if isfield(u,'rowcolorcol')==0 || isempty(u.rowcolorcol)
    return
end


%% ________________________________________________________________________________________________

if isempty(e2)
    e2.Indices  =[nan u.rowcolorcol];
% elseif ischar(e2) % "selected"
%     if strcmp(e2,'selected')
%         'ww'
%         u.hj.getSelectedRows()+1
%     end
    
elseif isnumeric(e2)  %several clicked
    rows=e2(:);
    clear e2
    e2.Indices=[rows repmat(u.rowcolorcol,[ length(rows) 1]) ];
end
cx=e2.Indices;
hcol    =unique(cx(:,2)); %highlighted column
selrow  =cx(:,1);
if u.rowcolorcol~=hcol; return;  end
%% ________________________________________________________________________________________________



d=t.Data(:,hcol);
islog=0;
if islogical(d{1})
    itrue=cell2mat(d)==1;
    d=repmat({''},[length(d) 1]);
    d(itrue)={'1'};
    islog=1;
else
    d=cellfun(@(a){[  num2str(a)]} ,d);
end

if length(unique(d))==1  && islog==0
    set(t,'backgroundcolor',u.bgcol0);
    %'set0'
else
    [uni ia ]=unique(d,'rows');
    iempty=find(strcmp(uni,'')==1);
    uni(iempty)=[];
    ia(iempty)=[];
    col=u.bgcol0;
    if isfield(u,'rowcolorassign')==0 || isempty(u.rowcolorassign)  %  NO field: "rowcolorassign"
        [w w2]= ismember(d,uni);
        idx={};
        ixcol=num2cell([1:length(uni)]');
        
        for i=1:length(uni)
            ix=find(w2==i);
            idx(i,1) = {ix};
            col(ix,:)=repmat( u.dfcol(i,:), [length(ix) 1]  );
        end
        set(t,'backgroundcolor',[col ]);
        u.rowcolorassign=[uni idx ixcol];
        set(gcf,'userdata',u);
    else     % rowcolorassign exists --> UPDATE
        col   = u.bgcol0;
        ca    = u.rowcolorassign;
        dfcol = u.dfcol;

        %ix=find(strcmp(u.rowcolorassign(:,1), d{e2.Indices(1)}));
        try
            ix=find(strcmp(u.rowcolorassign(:,1), d{selrow(1)} )); % EXIST LABEL?
        catch
            return
        end
            
        
         
        uni=[ca(:,1); ];
        if isempty(ix) &&  ~isempty(d{selrow(1)})% new group
            uni(end+1)=d(e2.Indices(1));
        end
        [~, w2]= ismember(d,uni);
        del=[];
        for i=1:length(uni)
            ix=[find(w2==i)];
            %u.rowcolorassign{i,2}=ix;
            if ~isempty(ix)% entire label deleted or renamed
                if i>size(ca,1) % NEW ENTRY
                    idcol=min(setdiff(1:length(d) ,cell2mat(ca(:,3))));
                    ca(i,:)=[uni(i) ix  idcol];
                end
                
                col(ix,:)=repmat( dfcol(ca{i,3},:), [length(ix) 1]  );
            else
                del(end+1,1)=i;
            end
        end
        ca(del,:)=[]; %remove completely empty
        u.dfcol         =dfcol;
        u.rowcolorassign=ca;
        set(t,'backgroundcolor',[col ]);
        set(gcf,'userdata',u);
        
        %% ---
        
        
    end
    
end






function cb_help(e,e2)
u=get(gcf,'userdata');

uhelp(cellstr(u.help));


function prefTable(e,e2,task)
u=get(gcf,'userdata');
if strcmp(task,'ok')
    u.isOK=1;
    set(gcf,'userdata',u);
    uiresume(gcf);
elseif strcmp(task,'cancel')
    u.isOK=0;
    set(gcf,'userdata',u);
    uiresume(gcf);
elseif strcmp(task,'selectall')
   % 's'
    icolLogical=find(cell2mat(cellfun(@(a){[  islogical(a)]} ,u.t.Data(1,:))));
    if length(icolLogical)==1
        u.t.Data(:,icolLogical)={logical(get(e,'value'))};
        rows=[1:size(u.t.Data,1)];
        color_rows_byColumn([],rows);
    elseif length(icolLogical)>1
        %% --
        colnames=cellfun(@(a,b){[ '[' num2str(a) '] '   b]}, num2cell([1:length(icolLogical)]) ,u.tbh(icolLogical));
        prompt = {['several columns with logical found' char(10) 'Select column:' char(10) ...
            strjoin(colnames,char(10)) ]};
        dlg_title = 'select all';
        num_lines = [1 60];
        defaultans = {'1'};
        try
            answer = inputdlg(prompt,dlg_title,num_lines,defaultans);
            ix=str2num(answer{1});
            u.t.Data(:,icolLogical(ix))={logical(get(e,'value'))};
        end
        %% --
    end
end




function ic=getIcon(str)

if strcmp(str, 'search')
    
    
    %     ic(:,:,1)=[[NaN NaN NaN NaN NaN NaN NaN NaN 0 0 0 0 NaN NaN NaN NaN;NaN NaN NaN NaN NaN NaN 0 0 NaN NaN NaN NaN 0 0 NaN NaN;NaN NaN NaN NaN NaN 0 NaN NaN NaN NaN NaN NaN NaN NaN 0 NaN;NaN NaN NaN NaN NaN 0 NaN NaN NaN 0 0 NaN NaN NaN 0 NaN;NaN NaN NaN NaN 0 NaN NaN NaN NaN 0 0 NaN NaN NaN NaN 0;NaN NaN NaN NaN 0 NaN NaN 0 0 0 0 0 0 NaN NaN 0;NaN NaN NaN NaN 0 NaN NaN 0 0 0 0 0 0 NaN NaN 0;NaN NaN NaN NaN 0 NaN NaN NaN NaN 0 0 NaN NaN NaN NaN 0;NaN NaN NaN NaN NaN 0 NaN NaN NaN 0 0 NaN NaN NaN 0 NaN;NaN NaN NaN NaN NaN 0 NaN NaN NaN NaN NaN NaN NaN NaN 0 NaN;NaN NaN NaN NaN 0 0 0 0 NaN NaN NaN NaN 0 0 NaN NaN;NaN NaN NaN 0 0 0 NaN NaN 0 0 0 0 NaN NaN NaN NaN;NaN NaN 0 0 0 NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN;NaN 0 0 0 NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN;NaN NaN 0 NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN]];
    %     ic(:,:,2)=[[NaN NaN NaN NaN NaN NaN NaN NaN 0 0 0 0 NaN NaN NaN NaN;NaN NaN NaN NaN NaN NaN 0 0 NaN NaN NaN NaN 0 0 NaN NaN;NaN NaN NaN NaN NaN 0 NaN NaN NaN NaN NaN NaN NaN NaN 0 NaN;NaN NaN NaN NaN NaN 0 NaN NaN NaN 0 0 NaN NaN NaN 0 NaN;NaN NaN NaN NaN 0 NaN NaN NaN NaN 0 0 NaN NaN NaN NaN 0;NaN NaN NaN NaN 0 NaN NaN 0 0 0 0 0 0 NaN NaN 0;NaN NaN NaN NaN 0 NaN NaN 0 0 0 0 0 0 NaN NaN 0;NaN NaN NaN NaN 0 NaN NaN NaN NaN 0 0 NaN NaN NaN NaN 0;NaN NaN NaN NaN NaN 0 NaN NaN NaN 0 0 NaN NaN NaN 0 NaN;NaN NaN NaN NaN NaN 0 NaN NaN NaN NaN NaN NaN NaN NaN 0 NaN;NaN NaN NaN NaN 0 0 0 0 NaN NaN NaN NaN 0 0 NaN NaN;NaN NaN NaN 0 0 0 NaN NaN 0 0 0 0 NaN NaN NaN NaN;NaN NaN 0 0 0 NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN;NaN 0 0 0 NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN;NaN NaN 0 NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN]];
    %     ic(:,:,3)=[[NaN NaN NaN NaN NaN NaN NaN NaN 0 0 0 0 NaN NaN NaN NaN;NaN NaN NaN NaN NaN NaN 0 0 NaN NaN NaN NaN 0 0 NaN NaN;NaN NaN NaN NaN NaN 0 NaN NaN NaN NaN NaN NaN NaN NaN 0 NaN;NaN NaN NaN NaN NaN 0 NaN NaN NaN 0 0 NaN NaN NaN 0 NaN;NaN NaN NaN NaN 0 NaN NaN NaN NaN 0 0 NaN NaN NaN NaN 0;NaN NaN NaN NaN 0 NaN NaN 0 0 0 0 0 0 NaN NaN 0;NaN NaN NaN NaN 0 NaN NaN 0 0 0 0 0 0 NaN NaN 0;NaN NaN NaN NaN 0 NaN NaN NaN NaN 0 0 NaN NaN NaN NaN 0;NaN NaN NaN NaN NaN 0 NaN NaN NaN 0 0 NaN NaN NaN 0 NaN;NaN NaN NaN NaN NaN 0 NaN NaN NaN NaN NaN NaN NaN NaN 0 NaN;NaN NaN NaN NaN 0 0 0 0 NaN NaN NaN NaN 0 0 NaN NaN;NaN NaN NaN 0 0 0 NaN NaN 0 0 0 0 NaN NaN NaN NaN;NaN NaN 0 0 0 NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN;NaN 0 0 0 NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN;NaN NaN 0 NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN]];
    %
    ic(:,:,1)=[255 255 255 255 240 217 215 241 255 255 255 255 255 255 255 255;255 255 239 179 146 153 172 174 191 217 255 255 255 255 255 255;255 232 149 144 183 197 205 212 203 191 189 252 255 255 255 255;248 146 135 190 211 246 234 222 221 223 195 198 255 255 255 255;191 120 173 210 226 189 180 180 183 189 202 183 249 255 255 255;135 122 196 206 180 180 181 185 190 195 200 199 220 255 255 255;101 149 183 180 180 182 186 191 196 202 207 205 212 255 255 255;91 159 179 180 183 188 193 198 204 209 214 206 221 255 255 255;109 155 181 184 189 194 200 205 210 215 221 189 250 255 255 255;168 134 187 191 196 201 207 212 217 222 224 188 255 255 255 255;246 122 190 198 203 208 213 218 224 229 173 118 232 255 255 255;255 241 165 199 210 215 220 225 228 182 82 113 130 214 255 255;255 255 253 195 181 202 206 189 184 239 201 91 111 128 194 255;255 255 255 255 250 221 220 247 255 255 255 229 108 103 127 175;255 255 255 255 255 255 255 255 255 255 255 255 248 138 95 146;255 255 255 255 255 255 255 255 255 255 255 255 255 255 195 231];
    ic(:,:,2)=[255 255 255 255 240 217 215 241 255 255 255 255 255 255 255 255;255 255 239 179 146 153 174 178 193 217 255 255 255 255 255 255;255 232 149 144 188 212 221 225 219 206 191 252 255 255 255 255;248 146 135 198 225 249 240 232 231 232 211 199 255 255 255 255;191 120 177 224 235 210 204 204 206 211 219 191 249 255 255 255;135 123 211 221 204 204 204 207 211 215 219 212 220 255 255 255;101 151 205 204 204 205 209 212 216 220 224 218 212 255 255 255;91 164 203 204 206 210 213 217 221 225 229 217 221 255 255 255;109 160 204 207 211 215 218 222 226 230 234 196 250 255 255 255;168 136 208 212 216 220 223 227 231 235 236 189 255 255 255 255;246 122 202 217 221 225 228 232 237 240 178 118 232 255 255 255;255 241 166 212 226 230 234 238 239 186 82 113 130 214 255 255;255 255 253 195 187 211 215 195 185 239 201 91 111 128 194 255;255 255 255 255 250 221 220 247 255 255 255 229 108 103 127 175;255 255 255 255 255 255 255 255 255 255 255 255 248 138 95 146;255 255 255 255 255 255 255 255 255 255 255 255 255 255 195 231];
    ic(:,:,3)=[255 255 255 255 240 217 215 241 255 255 255 255 255 255 255 255;255 255 239 179 146 154 177 185 195 217 255 255 255 255 255 255;255 232 149 144 198 246 254 254 253 237 194 252 255 255 255 255;248 146 135 213 253 254 254 253 253 252 243 200 255 255 255 255;191 120 185 253 254 254 255 255 255 254 253 205 249 255 255 255;135 123 241 254 254 255 255 255 255 255 255 235 220 255 255 255;101 153 253 254 255 255 255 255 255 255 255 240 213 255 255 255;91 173 255 255 255 255 255 255 255 255 255 233 221 255 255 255;109 169 255 255 255 255 255 255 255 255 255 204 250 255 255 255;168 137 252 255 255 255 255 255 255 255 250 191 255 255 255 255;246 123 225 255 255 255 255 255 255 254 183 118 232 255 255 255;255 241 167 236 254 255 255 255 251 191 82 113 130 214 255 255;255 255 253 195 195 224 226 202 186 239 201 91 111 128 194 255;255 255 255 255 250 221 220 247 255 255 255 229 108 103 127 175;255 255 255 255 255 255 255 255 255 255 255 255 248 138 95 146;255 255 255 255 255 255 255 255 255 255 255 255 255 255 195 231];
    ic([1 end],:,:)=0;    ic(:,[1 end],:)=0;
    ic=ic./255;
elseif strcmp(str, 'montage')
    ic(:,:,1)=[255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255;255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255;255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255;255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255;255 255 255 255 84 255 84 255 84 255 84 255 255 255 255 255;255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255;255 255 255 255 74 255 74 255 74 255 74 255 255 255 255 255;255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255;255 255 255 255 62 255 62 255 62 255 62 255 255 255 255 255;255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255;255 255 255 238 33 255 33 255 33 255 33 235 255 255 255 255;255 255 255 238 229 229 229 229 229 229 229 235 255 255 255 255;255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255;255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255;255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255;255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255];
    ic(:,:,2)=[255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255;255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255;255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255;255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255;255 255 255 255 84 255 84 255 84 255 84 255 255 255 255 255;255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255;255 255 255 255 74 255 74 255 74 255 74 255 255 255 255 255;255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255;255 255 255 255 62 255 62 255 62 255 62 255 255 255 255 255;255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255;255 255 255 238 33 255 33 255 33 255 33 235 255 255 255 255;255 255 255 238 229 229 229 229 229 229 229 235 255 255 255 255;255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255;255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255;255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255;255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255];
    ic(:,:,3)=[255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255;255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255;255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255;255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255;255 255 255 255 84 255 84 255 84 255 84 255 255 255 255 255;255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255;255 255 255 255 74 255 74 255 74 255 74 255 255 255 255 255;255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255;255 255 255 255 62 255 62 255 62 255 62 255 255 255 255 255;255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255;255 255 255 238 33 255 33 255 33 255 33 235 255 255 255 255;255 255 255 238 229 229 229 229 229 229 229 235 255 255 255 255;255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255;255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255;255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255;255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255];
    ic([1 end],:,:)=0;    ic(:,[1 end],:)=0;
    ic=ic./255;
elseif strcmp(str, 'clear')
    ic(:,:,1)=[0 1 5 5 5 5 5 5 5 5 5 5 5 5 1 0;1 164 220 219 219 218 218 217 217 216 216 215 214 215 161 1;6 203 209 209 209 209 209 209 209 209 209 209 209 209 198 6;7 194 202 190 193 192 202 202 202 202 192 193 190 202 189 8;8 187 194 226 240 216 190 194 194 189 215 240 226 194 184 9;10 181 187 198 235 233 215 190 189 213 231 234 198 187 179 10;11 176 180 180 195 230 226 214 213 222 226 195 180 180 178 11;12 167 170 177 186 203 225 219 217 221 206 188 174 161 146 13;12 154 142 158 175 178 202 216 212 199 175 171 156 142 143 13;12 153 148 165 174 204 221 222 217 207 199 176 165 148 142 13;12 153 153 169 213 230 229 237 236 219 220 215 172 153 143 13;12 152 154 221 239 236 231 244 244 231 233 239 224 154 143 13;12 152 153 193 239 214 221 233 233 221 214 239 194 153 145 13;11 152 148 164 180 196 209 217 217 209 196 180 164 148 146 12;3 124 148 152 157 161 164 166 166 163 159 155 149 144 116 3;0 3 11 12 12 12 12 12 12 12 12 12 12 11 3 0];
    ic(:,:,2)=[0 0 0 1 1 1 1 1 1 1 1 1 1 0 0 0;0 75 112 107 107 107 107 107 107 107 107 107 107 112 75 0;0 88 152 152 152 152 152 152 152 152 152 152 152 152 102 0;0 68 136 145 186 139 136 136 136 136 139 186 145 136 87 0;0 60 121 218 240 211 130 121 121 130 210 240 218 121 82 0;0 52 105 131 229 233 209 122 122 207 231 228 131 105 78 0;0 46 89 89 120 223 226 207 206 222 219 120 89 89 79 0;0 33 66 76 84 118 217 219 217 215 128 87 69 47 14 0;0 10 2 18 35 66 194 216 212 190 52 23 12 2 12 0;0 14 6 19 51 192 221 209 204 207 187 54 19 6 16 0;0 18 10 48 202 230 217 104 103 207 220 203 51 10 20 0;0 22 11 205 239 224 100 79 79 100 221 239 208 11 24 0;0 26 10 94 223 87 62 71 71 62 87 223 94 10 27 0;0 35 6 18 30 42 52 58 58 52 42 30 18 6 32 0;0 31 38 36 40 44 47 49 49 47 44 40 36 35 23 0;0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
    ic(:,:,3)=[0 0 0 1 1 1 1 1 1 1 1 1 1 0 0 0;0 75 112 107 107 107 107 107 107 107 107 107 107 112 75 0;0 88 152 152 152 152 152 152 152 152 152 152 152 152 102 0;0 68 136 145 186 139 136 136 136 136 139 186 145 136 87 0;0 60 121 218 240 211 130 121 121 130 210 240 218 121 82 0;0 52 105 131 229 233 209 120 120 207 231 228 131 105 78 0;0 46 89 89 117 222 226 206 205 222 219 117 89 89 79 0;0 32 66 73 74 105 215 219 217 213 116 77 66 47 13 0;0 9 0 5 13 42 192 216 212 187 26 0 0 0 10 0;0 11 0 0 27 189 221 205 199 207 184 29 0 0 12 0;0 13 0 30 199 230 211 45 44 201 220 201 33 0 14 0;0 15 0 203 239 220 45 0 0 45 216 239 206 0 15 0;0 16 0 79 219 46 0 0 0 0 46 219 79 0 16 0;0 22 0 0 0 0 0 0 0 0 0 0 0 0 20 0;0 26 22 17 17 17 17 17 17 17 17 17 17 19 17 0;0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
    %source: https://iconarchive.com/search?q=delete+16x16&res=16&page=1
elseif strcmp(str, 'bulb')
    a2=[0 1 0.0313725490196078 0.32156862745098 1 1 1 1 1 1 1 1 1 1 0.83921568627451 0.741176470588235 0.968627450980392 0.905882352941176 0.741176470588235 0.968627450980392 0.776470588235294 0.258823529411765 0.776470588235294 0.0627450980392157 0.0313725490196078 1 0 0 0 0 0 0;0 1 0.0470588235294118 0.333333333333333 1 1 1 1 1 1 1 1 1 1 0.811764705882353 0.729411764705882 0.952941176470588 0.890196078431373 0.713725490196078 0.937254901960784 0.745098039215686 0.235294117647059 0.764705882352941 0.0627450980392157 0.0313725490196078 1 0 0 0 0 0 0;0 1 0.0627450980392157 0.290196078431373 0 0.290196078431373 0.32156862745098 0.352941176470588 0.517647058823529 0.611764705882353 0.67843137254902 0.83921568627451 0.870588235294118 0.968627450980392 0 0.0941176470588235 0.223529411764706 0.258823529411765 0.0941176470588235 0.290196078431373 0.290196078431373 0.0627450980392157 0.741176470588235 0.0627450980392157 0.0313725490196078 1 0 0 0 0 0 0]';
    aa2=[25 25 25 25 25 25 25 21 25 25 25 25 25 25 25 25;25 25 25 25 25 25 25 21 25 25 25 25 25 25 25 25;25 25 25 25 25 25 25 25 25 25 21 25 25 25 25 25;25 25 21 25 25 21 21 21 21 25 25 25 25 25 25 25;25 25 25 25 21 20 16 19 17 21 21 25 25 25 25 25;25 25 25 21 15 11 13 8 5 14 14 21 21 24 24 25;25 25 25 21 18 12 1 10 5 5 4 4 21 1 1 2;21 21 25 21 18 12 1 4 7 21 21 4 21 22 22 2;25 25 25 21 18 9 7 5 5 5 4 4 21 3 3 2;25 25 25 21 18 6 4 4 4 18 18 21 21 2 23 25;25 25 25 25 21 18 18 18 18 21 21 25 25 25 25 25;25 25 21 25 25 21 21 21 21 25 25 25 25 25 25 25;25 25 25 25 25 25 25 25 25 25 21 25 25 25 25 25;25 25 25 25 25 25 25 21 25 25 25 25 25 25 25 25;25 25 25 25 25 25 25 21 25 25 25 25 25 25 25 25;25 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25]';
    ic= ind2rgb(uint8(aa2),a2);
    ic([1 end],:,:)=0;    ic(:,[1 end],:)=0;
elseif strcp(str,'hand')
    a2=[129 129 129 129 129 129 129 0 0 129 129 129 129 129 129 129;129 129 129 0 0 129 0 215 215 0 0 0 129 129 129 129;129 129 0 215 215 0 0 215 215 0 215 215 0 129 129 129;129 129 0 215 215 0 0 215 215 0 215 215 0 129 0 129;129 129 129 0 215 215 0 215 215 0 215 215 0 0 215 0;129 129 129 0 215 215 0 215 215 0 215 215 0 215 215 0;129 0 0 129 0 215 215 215 215 215 215 215 0 215 215 0;0 215 215 0 0 215 215 215 215 215 215 215 215 215 215 0;0 215 215 215 0 215 215 215 215 215 215 215 215 215 0 129;129 0 215 215 215 215 215 215 215 215 215 215 215 215 0 129;129 129 0 215 215 215 215 215 215 215 215 215 215 215 0 129;129 129 0 215 215 215 215 215 215 215 215 215 215 0 129 129;129 129 129 0 215 215 215 215 215 215 215 215 215 0 129 129;129 129 129 129 0 215 215 215 215 215 215 215 0 129 129 129;129 129 129 129 129 0 215 215 215 215 215 215 0 129 129 129;129 129 129 129 129 0 215 215 215 215 215 215 0 129 129 129];
    a2=cat(3,a2,a2,a2);
    ic=a2./255;
end

