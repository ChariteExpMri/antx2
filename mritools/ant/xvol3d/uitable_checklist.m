
% SIMPLE CHECKbox-uitable
% out=uitable_checklist(tb,tbh,varargin)
% tb   : table cellarray ..see uitable
% tbh  : header {cell} of 'th'
% varagin: additional pairwise input: 
%     title      figure title (string);                    default: ''
%     tooltip    uitable tooltip of the uitable (string);  default: ''
%     pos        figure position; default: [ 0.3049    0.4311    0.1174    0.4544];
%     postab     position of the uitable; default: [0 0.05 .89 .95]; 
%     editable   vector of indices of editable columns {default: [1]...first column is editable}
%    autoresize  0/1; [1] fit columns to figure
%% EXAMPLE-1
%     tbh={'show' 'ColumnName'};
%     tb={[1]    'x'
%         [0]    'label1'
%         [1]    'x'
%         [0]    'label2'
%         [1]    'c'};
%     tb(:,1)=cellfun(@(a){[logical(a)]} ,tb(:,1));%make logical (checkbox)
%    out=uitable_checklist(tb,tbh);
%% EXAMPLE-2: both columns editable, set title and tooltip
%    out=uitable_checklist(tb,tbh,'editable',[1 2],'title','XXX','tooltipstr' ,['xx' char(10) 'yy']);
%% EXAMPLE-2:
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
set(gcf,'numbertitle','off','tag','prefTable','name',[p.title '(' mfilename '.m)'],...
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

%autoresize table
if p.autoresize==1
    jscroll = findjobj(t);
    jTable = jscroll.getViewport.getView;
    jTable.setAutoResizeMode(jTable.AUTO_RESIZE_SUBSEQUENT_COLUMNS);
end

% select all
hb=uicontrol('parent',gcf, 'style','radio','units','pixels','tag','prefTable_select');
set(hb,'position',[ 52.9441    0.5100   84.5280   20.4480],'backgroundcolor','w',...
    'string','select all','foregroundcolor','k',...
    'fontweight','bold','fontsize',6);
set(hb,'tooltipstring','select/deselect all','callback',{@prefTable,'selectall'});
set(hb,'units','pixels')
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
% --------------
u.tb =tb;
u.tbh=tbh;
u.isOK=0;
u.t   =t;
set(gcf,'userdata',u)
% ========================== WAIT ==============================================
if 1
    uiwait(gcf);
end
try %case closing the fig via [x]-btn
    u=get(gcf,'userdata');
    if u.isOK==1
        out= u.t.Data;
    end
    close(gcf);
end

% ==============================================
%%   SUBFUN
% ===============================================
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
    u.t.Data(:,1)={logical(get(e,'value'))};
end






