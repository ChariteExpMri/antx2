% 
% #wb plot node and links (connections)
% #bo INPUT: excel-table with 
% excel-table input column-names (column names must match witht he below strings)
% 'Label1'    : region/label name of node1  , this is OPTIONAL
% 'Label2'    : region/label name of node2  , this is OPTIONAL
% 'co1'       : 3d (x,y,z)-coordinates [mm] of node1  (->saved in single excel column)
% 'co2'       : 3d (x,y,z)-coordinates [mm] of node2  (->saved in single excel column)
% 'cs'        : connection strength or any other parameter to display, this is OPTIONAL
% 
% This is an example of an excel-file: 
%  COLUMN-A   COLUMN-B         COLUMN-C                    COLUMN-D              COLUMN-E
%  'Label1'  'Label2'            'co1'                      'co2'                 'cs' 
%  region1	  region2	 -0.80014 1.6151 -0.90994	 0.75024 1.6782 -0.90562	   -4
%  region3	  region4	 -1.768 -1.1643 -1.39	     1.7447 -0.99306 -1.3838	   -0.148148148
%  region5	  region6	 0.011078 -3.1784 -0.32861	 -0.047126 -0.63101 -1.2141 	2.518518519
%  region7	  region8	 -1.8972 -0.2773 -1.0836	 1.8806 -0.22126 -1.0607     	4
%
% #bo BUTTONS etc
% [load data]: load excel file
% [plot]:      plot nodes and links 
% [clear]:     clear nodes and links 
% [help]:      get some help 
% #g ============ NODES ========================
% [all nodes]: show/hide all nodes
% [nodes COL]: set color of all nodes  [RGB-triplet]
% [nodes RAD]: set radious of all nodes [value>0]
% [nodes TRA]: set transparency of all nodes [0-1]
%
% [label]: show/hide label
% [label prop]: set specific label properties
% #g ============ LINKS ========================
% [all links]: show/hide all links
% [link COL]: set color of all links  [RGB-triplet]
% [link RAD]: set radious/width of all links [value>0]
% [link TRA]: set transparency of all links [0-1]
% [CS2col]  : colorize links using connection strength parameter [0,1]
% [colormaps]: set colormap; only if [CS2col] is true 
% [CS2RAD]  : connection strength is expressed as link thickness (larger absolute values obtain a 
%             larger radius)
%  [EDIT field] right to [CS2RAD]: math. expression used to connection strength to radius (i.e. thickness of links) 
%             see tooltip for more information 
% 
% ==============================================
% #bo Table editing
% -table cells (colors), labels can be edited separately
% use [c]-cell to select color from colorpicker
% click onto a region/label cell to examine the location of the node in the image
% 
% #bo   comandline options
% sub_plotconnections('new'); % reopen gui + delete previous nodes/links
% sub_plotconnections('load', 'F:\data1\patch3d_v3\sample_shrew\_testNodes2.xlsx'); % load data
% sub_plotconnections('plot'); % plot/update data
% 
% sub_plotconnections('set','allnodes',1); % show all nodes
% %% set node/link paremeter (use 'set', followed by pairwise inputs)
% sub_plotconnections('set','allnodes',1,'nodecol',[1 1 0],'noderad',3,'alllink',1,'linktra',.2,'linkrad',2 ); % set node and link parameter
% sub_plotconnections('plot');% plot/update data
% 
% 
% sub_plotconnections('set','cs2col',1); % colorize connection strength
% sub_plotconnections('plot'); % plot/update data
% 
% sub_plotconnections('set','nodelabel',1); % show labels
% sub_plotconnections('plot'); % plot/update data
% %% set label paremeter (use 'set', followed by pairwise inputs)
% sub_plotconnections('set','fs',5,'fcol',[0 0 1],'fhorzal',1,'needlevisible',1,'needlelength',15,'needlecol',[0 .5 0] ); % LABEL parameter
% sub_plotconnections('plot'); % plot/update data

 







function sub_plotconnections(varargin)

if 0
    cf
    pw='C:\Users\skoch\Desktop\shrew_3dvol';
    mask=fullfile(pw,'AVGT.nii');
    
    xvol3d('loadbrainmask',mask)
    % xvol3d('statimage','ROI4_sm.nii');
    roi=fullfile(pw,'ROI4_sm.nii');
    xvol3d('statimage',roi);
    xvol3d('plottr',7,'alpha',.3);%plot-TR at threshold .3
    figure(findobj(0,'tag','xvol3d'));
    view(-90,90)
    xvol3d('arrows','off')
    xvol3d('light','off');
    xvol3d('light','on');
    
    
end




% ==============================================
%%   inputs
% ===============================================
if nargin==0; 
   % MAKE NEW FIGURE
   newfig();
    return ;
else
    if mod(length(varargin),2)==0
        par=cell2struct(varargin(2:2:end),varargin(1:2:end),2);
    else % odd
        if length(varargin)==1
            par=struct();
            par=setfield(par,varargin{1}, varargin{1});
        else
            par=cell2struct(varargin(3:2:end),varargin(2:2:end),2);
            par.set='set';
        end
    end
   if isfield(par,'new');         newfig();    end
   if isfield(par,'load');        conload([],[],par.load);    end
   if isfield(par,'plot');        conplot([],[]         );    end
   
   if isfield(par,'set');   setvalue(par); end   
   
end

% ==============================================
%%   comandline options
% ===============================================


if 0
    sub_plotconnections('new'); % reopen gui
    sub_plotconnections('load', 'F:\data1\patch3d_v3\sample_shrew\_testNodes2.xlsx'); %load data
    sub_plotconnections('plot'); %plot/update data
    
    sub_plotconnections('set','allnodes',1);% shiw all nodes
    
    sub_plotconnections('set','allnodes',1,'nodecol',[1 1 0],'noderad',3,'alllink',1,'linktra',.2,'linkrad',2 );
    sub_plotconnections('plot');%plot/update data
    
    
    sub_plotconnections('set','cs2col',1);% colorize connection strength
    sub_plotconnections('plot');%plot/update data
    
     sub_plotconnections('set','nodelabel',1);%  show labels
     sub_plotconnections('plot');%plot/update data
    % set label paremeter (use 'set', followed by pairwise inputs)
    sub_plotconnections('set','fs',5,'fcol',[0 0 1],'fhorzal',1,'needlevisible',1,'needlelength',15,'needlecol',[0 .5 0] );
    sub_plotconnections('plot');%plot/update data

    
end

% ==============================================
%%   data
% ===============================================

function setvalue(par)
try; par=rmfield(par,'set'); end
ht=findobj(0,'tag','plotconnections');
u=get(ht,'userdata');
dx=u.t.Data;
cname=u.t.ColumnName;

% if isfield(par,'allnodes')==1
%     d(:,[1 3])={logical(par.allnodes)};

if isfield(par,'allnodes')
    dx(:,[1 3])={logical(par.allnodes)};
end
if isfield(par,'nodecol')
    dx(:,[6 8])={regexprep(num2str(par.nodecol),'\s+',' ')};
end
if isfield(par,'noderad')
    dx(:,[9 10])={ num2str(par.noderad)};
end
if isfield(par,'nodetra')
    dx(:,[11 12])={ num2str(par.nodetra)};
    %##########  ##########  ##########  ##########  ##########  ##########
end
if isfield(par,'alllinks')
    dx(:,[15])={logical(par.alllinks)};
end
if isfield(par,'linkcol')
    dx(:,[18])={regexprep(num2str(par.linkcol),'\s+',' ')};
end
if isfield(par,'linkrad')
    dx(:,[19])={ num2str(par.linkrad)};
end
if isfield(par,'linktra')
    dx(:,[20])={ num2str(par.linktra)};
end
if isfield(par,'cs2col')
    hb=findobj(ht,'tag','linkintensity');
    set(hb,'value',par.cs2col);
end
if isfield(par,'nodelabel')
    hb=findobj(ht,'tag','nodelabel');
    set(hb,'value',par.nodelabel);
end
%% ===============================================
if isfield(par,'fs');              u.lab.fs            =  par.fs;              end
if isfield(par,'fcol');            u.lab.fcol          =  par.fcol;            end
if isfield(par,'fhorzal');         u.lab.fhorzal       =  par.fhorzal;         end
if isfield(par,'needlevisible');   u.lab.needlevisible =  par.needlevisible;   end
if isfield(par,'needlelength');    u.lab.needlelength  =  par.needlelength;    end
if isfield(par,'needlecol');       u.lab.needlecol     =  par.needlecol;       end

set(u.t,'data',dx);
 set(ht,'userdata',u);
%             dummi: 1
%                fs: 7
%              fcol: [0 0 0]
%           fhorzal: 2
%     needlevisible: 0
%      needlelength: 10
%         needlecol: [0 0 0]


function newfig()
% MAKE NEW FIGURE
delete(findobj(0,'tag','plotconnections'));
hs=findobj(0,'tag','xvol3d'); u=get(hs,'userdata');
makefigure();
conclear([],[]);

function cind=convertmm2ind(ha,a)
% convert mm to indices
hf=findobj(0,'tag','xvol3d');
us=get(hf,'userdata');
[hb b xi ind]=rgetnii(us.mask);
b=b(:); xi=xi'; ind=ind';
co1=a(:,regexpi2(ha,'co1'));
co2=a(:,regexpi2(ha,'co2'));
cc={co1 co2};

cind={};
for i=1:length(cc)
    ds=str2num(char(cc{i}));
    ci=[];
    for j=1:size(ds,1)
        co=ds(j,:);
        dis=sum((xi-repmat(co,[size(xi,1) 1])).^2,2);
        imin=find(dis==min(dis));
        c1=ind(imin,:);
        c1=c1([2 1 3 ]);
        ci(j,:)=c1;
    end
    cind{i}=ci;
end


function conload(e,e2,filenode)

fprintf('..busy loading nodes&links-excelfile ..');

% % ps='C:\Users\skoch\Desktop\shrew_3dvol'
% % finode=fullfile(ps,'_testNodes.xlsx')

if exist('filenode')==0
    [fi pa]=uigetfile(fullfile(pwd,'.xls|.xlsx'),'select excelfile');
    if isnumeric(fi);
        
        fprintf('..cancelled\n');
        return;
    end
    filenode=fullfile(pa,fi);
end
if 0
    filenode='C:\Users\skoch\Desktop\shrew_3dvol\_testNodes2.xlsx';
end

[~,aa,a]=xlsread(filenode);
a=a(1:size(aa,1),:);

% CONN-STRENGTH
ha=a(1,:);
a=a(2:end,:);
ics=find(~cellfun(@isempty, regexpi(ha,'cs')));
if isempty(ics)  % ADD DUMMY CONNECTIONSTRENGTH
    ha(end+1)={'cs'};
    a=[a num2cell([1:size(a,1)]')];
    ics=find(~cellfun(@isempty, regexpi(ha,'cs')));
end
a(:,ics)=cellfun(@(a){[ num2str(a)]}, a(:,ics));%convert cs to string
% LABEL missing
if isempty(regexpi2(ha,'Label2'))
    a=[ cellfun(@(a){['R' num2str(a)]}, num2cell([1:size(a,1)]')) a];
    ha=['Label2' ha ];
end
if isempty(regexpi2(ha,'Label1'))
    a=[ cellfun(@(a){['R' num2str(a)]}, num2cell([1:size(a,1)]')) a];
    ha=['Label1' ha ];
end


% % convert mm to indices
% hf=findobj(0,'tag','xvol3d');
% us=get(hf,'userdata');
% [hb b xi ind]=rgetnii(us.mask);
% b=b(:); xi=xi'; ind=ind';
% co1=a(:,regexpi2(ha,'co1'));
% co2=a(:,regexpi2(ha,'co2'));
% cc={co1 co2};
% 
% cind={};
% for i=1:length(cc)
%     ds=str2num(char(cc{i}));
%     ci=[];
%     for j=1:size(ds,1)
%         co=ds(j,:);
%         dis=sum((xi-repmat(co,[size(xi,1) 1])).^2,2);
%         imin=find(dis==min(dis));
%         c1=ind(imin,:);
%         c1=c1([2 1 3 ]);
%         ci(j,:)=c1;
%     end
%     cind{i}=ci;
% end
cind=convertmm2ind(ha,a);


he ={'x'       'label1' 'x'       'label2' 'c'    'col1' 'c'    'col2' 'R1'   'R2'   'T1'   'T2'   'co1'  'co2'  'x'       'cs'   'c'    'Lcol'  'LR'    'LT'};
fmt={'logical' 'char'   'logical' 'char'   'char' 'char' 'char' 'char' 'char' 'char' 'char' 'char' 'char' 'char' 'logical' 'char' 'char' 'char'  'char' 'char'};
e=[...
    num2cell(logical(ones(size(a,1),1))) ...]
    a(:,find(~cellfun(@isempty, regexpi(ha,'Label1')))) ...
    num2cell(logical(ones(size(a,1),1))) ...]
    a(:,find(~cellfun(@isempty, regexpi(ha,'Label2')))) ...
    ...
    repmat({'c'},[size(a,1) 1])       ... colorBTN
    repmat({'0 0.5 0'},[size(a,1) 1])   ... color
    repmat({'c'},[size(a,1) 1])       ... colorBTN
    repmat({'0 0.5 0'},[size(a,1) 1])   ... color
    repmat({'2'},[size(a,1) 1])   ... [LR]radius
    repmat({'2'},[size(a,1) 1])   ... [LR]radius
    repmat({'1'},[size(a,1) 1])   ... [TL]transparency node
    repmat({'1'},[size(a,1) 1])   ... [TL]transparency node
    ...
    a(:,find(~cellfun(@isempty, regexpi(ha,'co1')))) ...
    a(:,find(~cellfun(@isempty, regexpi(ha,'co2')))) ...
    num2cell(logical(ones(size(a,1),1))) ...
    a(:,find(~cellfun(@isempty, regexpi(ha,'cs')))) ...
    repmat({'c'},[size(a,1) 1])       ... colorBTN
    repmat({'0 0 1'},[size(a,1) 1])   ... [Lcol]color
    repmat({'1'},[size(a,1) 1])   ... [LR]radius
    repmat({'1'},[size(a,1) 1])   ... [TL]transparency links
    
    ...]
    ...]
    ...]
    ...]
    ];
columnname   =he;%{'select'  'name'  'ID'   'c'   'color'};
columnformat =fmt;%{'logical' 'char'  'char' 'char' 'char'};
editable=logical(ones(1,length(he)));%logical([1 0 0 1 1]);

% ==============================================
%  uitable
% ===============================================
hs=findobj(0,'tag','xvol3d');
tv=e;

hk=findobj(0,'tag','plotconnections');
figure(hk);
delete(findobj(hk,'tag','table1')); %delete previous table
u=get(hk,'userdata');

hv=uicontrol('Style', 'text','string','');
mxlen=[];
tw=[he;tv];
for i=1:size(tw,2)
    i2len=cell2mat(cellfun(@(a){ [length(a)]},tw(:,i)));
    str=tw{max(find(i2len==max(i2len))),i};
    if isnumeric(str); str=num2str(str);
    elseif islogical(str); str=num2str(str); end
    set(hv,'string',str);
    ext=get(hv,'Extent');
    mxlen(1,i)=ext(3);
    % disp(mxlen);
end
ColumnWidth=[num2cell(mxlen(1:end)+6)];
delete(hv);

% Create the uitable
t = uitable;
set(t,'Data', tv,...
    'ColumnName', columnname,...
    'ColumnFormat', columnformat,...
    'ColumnEditable', editable,...
    'ColumnWidth',    ColumnWidth,...
    'RowName',[],...
    'tag','table1');
drawnow;

set(t,'units','normalized','position',[0 0 1 .9])
set(t,'CellSelectionCallback',@CellSelectionCallback)
set(t,'CellEditCallback'     ,@CellEditCallback)
u.t=t;

set(t,'fontsize',7);

u.cind=cind; %coordinates integer
set(gcf,'userdata',u);
 fprintf('..done\n');

% ==============================================
%%
% ===============================================
function makefigure();

fg;
hk=gcf;
set(hk,'units','normalized','menubar','none');
set(hk,'position',[0.2986    0.4000    0.5611    0.4667]);
set(hk,'tag','plotconnections','NumberTitle','off','name',['regions' ' [' mfilename '.m]' ] );


% hp=uipanel('units','norm','title','v');
% set(hp,'position',[0 .9 1 .1]);

% -------------LABEL&co----------------------------------------------------------------------------------
%node label
hb=uicontrol('style','radio','units','norm','string','label','value',0);
set(hb,'position',[.25 .935 .09 .032],'tag','nodelabel','callback',{@select,'nodelabel'},'backgroundcolor','w');
set(hb,'tooltipstring','show node label','fontsize',8,'fontweight','bold');
% label props
hb=uicontrol('style','pushbutton','units','norm','string','label prop');
set(hb,'position',[.25 .9 .09 .032],'tag','labelprop','callback',@labelprop,'backgroundcolor','w');
set(hb,'tooltipstring','set label properties','fontsize',8,'fontweight','bold');

% frame
hb=uicontrol('style','frame','units','norm','string','label prop');
set(hb,'position',[.24 .89 .11 .1],'backgroundcolor','w');
uistack(hb,'bottom');

% -----------------------------------------------------------------------------------------------

%select all nodes
hb=uicontrol('style','radio','units','norm','string','all nodes','value',1);
set(hb,'position',[.0 .9 .1 .032],'tag','allnodes','callback',{@select,'allnodes'},'backgroundcolor','w');
set(hb,'tooltipstring','select/deselect all nodes','fontsize',8,'fontweight','bold');


% %select nodes color
% hb=uicontrol('style','pushbutton','units','norm','string','node COL');
% set(hb,'position',[.1 .9 .06 .032],'tag','nodecol','callback',{@select,'nodecol'},'backgroundcolor','w');
% set(hb,'tooltipstring','set node color','fontsize',8,'fontweight','bold');
% %select nodes Radius
% hb=uicontrol('style','pushbutton','units','norm','string','node RAD');
% set(hb,'position',[.16 .9 .06 .032],'tag','noderad','callback',{@select,'noderad'},'backgroundcolor','w');
% set(hb,'tooltipstring','set node radius','fontsize',8,'fontweight','bold');
% %select nodes Transparency
% hb=uicontrol('style','pushbutton','units','norm','string','node TRA');
% set(hb,'position',[.22 .9 .06 .032],'tag','nodetra','callback',{@select,'nodetra'},'backgroundcolor','w');
% set(hb,'tooltipstring','set node transparency','fontsize',8,'fontweight','bold');
% 

%select nodes color
hb=uicontrol('style','pushbutton','units','norm','string','node COL');
set(hb,'position',[.1 .964 .08 .032],'tag','nodecol','callback',{@select,'nodecol'},'backgroundcolor','w');
set(hb,'tooltipstring','set node color','fontsize',8,'fontweight','bold');
%select nodes Radius
hb=uicontrol('style','pushbutton','units','norm','string','node RAD');
set(hb,'position',[.1 .932 .08 .032],'tag','noderad','callback',{@select,'noderad'},'backgroundcolor','w');
set(hb,'tooltipstring','set node radius','fontsize',8,'fontweight','bold');
%select nodes Transparency
hb=uicontrol('style','pushbutton','units','norm','string','node TRA');
set(hb,'position',[.1 .90 .08 .032],'tag','nodetra','callback',{@select,'nodetra'},'backgroundcolor','w');
set(hb,'tooltipstring','set node transparency','fontsize',8,'fontweight','bold');





%select all links
hb=uicontrol('style','radio','units','norm','string','all links','value',1);
set(hb,'position',[.65 .9 .09 .032],'tag','alllinks','callback',{@select,'alllinks'},'backgroundcolor','w');
set(hb,'tooltipstring','select/deselect all links','fontsize',8,'fontweight','bold');

%select link color
hb=uicontrol('style','pushbutton','units','norm','string','link COL');
set(hb,'position',[.74 .964 .08 .032],'tag','linkcol','callback',{@select,'linkcol'},'backgroundcolor','w');
set(hb,'tooltipstring','set link color','fontsize',8,'fontweight','bold');
%select link Radius
hb=uicontrol('style','pushbutton','units','norm','string','link RAD');
set(hb,'position',[.74 .932 .08 .032],'tag','linkrad','callback',{@select,'linkrad'},'backgroundcolor','w');
set(hb,'tooltipstring','set link radius','fontsize',8,'fontweight','bold');
%select link Transparency
hb=uicontrol('style','pushbutton','units','norm','string','link TRA');
set(hb,'position',[.74 .90 .08 .032],'tag','linktra','callback',{@select,'linktra'},'backgroundcolor','w');
set(hb,'tooltipstring','set link transparency','fontsize',8,'fontweight','bold');

% ==============================================
%%   intensity to color
% ===============================================

%con intensity color
hb=uicontrol('style','radio','units','norm','string','CS2COL','value',0);
set(hb,'position',[.84 .932 .09 .032],'tag','linkintensity','callback',{@select,'linkintensity'},'backgroundcolor','w');
set(hb,'tooltipstring','show colorized connection strength/linkintensity','fontsize',7,'fontweight','bold');


% colormapeditorString = fileread(which('colormapeditor.m'));
% % colormapeditorString = fileread(strcat(matlabroot,'\toolbox\matlab\graph3d\colormapeditor.m'));
% posStart = strfind(colormapeditorString,'stdcmap(maptype');
% posEnd = strfind(colormapeditorString(posStart:end),'end') + posStart;
% stdcmapString = colormapeditorString(posStart:posEnd);
% split = strsplit(stdcmapString, '(mapsize)');
% list = cellfun(@(x)x(find(x==' ', 1,'last'):end), split,'uni',0);
% list(end) = [];
% list=regexprep(list,' ','');

hg=findobj(0,'tag','winselection');
list=get(findobj(hg,'tag','scmap'),'string');
%con intensity color
hb=uicontrol('style','popupmenu','units','norm','string',list,'value',1);
set(hb,'position',[.93 .932 .07 .04],'tag','linkcolormap','backgroundcolor','w');
set(hb,'tooltipstring','set colormap of connection strength','fontsize',7,'fontweight','bold',...
    'callback',{@select,'linkcolormap'});%

% ==============================================
%%   intensity to connectionThickness
% ===============================================
hb=uicontrol('style','radio','units','norm','string','CS2RAD','value',0);
set(hb,'position',[.84 .964 .09 .032],'tag','CS2RAD','callback',{@select,'CS2RAD'},...
    'backgroundcolor','w','fontsize',7);
set(hb,'tooltipstring','connection thickness defined by connection strength/linkintensity','fontsize',8,'fontweight','bold');

hb=uicontrol('style','edit','units','norm','string','*1.5+.3');
set(hb,'position',[.93 .967 .07 .032],'tag','CS2RADexpression','callback',{@select,'CS2RADexpression'},'backgroundcolor','w');
set(hb,'fontsize',7,'fontweight','normal','tooltipstring',...
    ['math expression to adjust connection thickness defined by' char(10) ...
    'connection strength/linkintensity' char(10) ...
    'NOTE: First, the absulute conection strength is used and normalized by it''s maximum  ' char(10) ...
    '           NCS=abs(CS)/max(abs(CS))' char(10)...
    'Than, the math expression is applied to NCS' char(10)...
    'Example: "*3+.5"  --> "Radius=NCS*3+.5"  to obtain suitable radius-values for the conections']);


% ==============================================
%%
% ===============================================

%load excelfile
hb=uicontrol('style','pushbutton','units','norm','string','load data');
set(hb,'position',[.4 .9 .075 .03],'tag','conload','callback',@conload);
set(hb,'tooltipstring','load excel data','fontsize',8,'fontweight','bold');


%PLOT
hb=uicontrol('style','pushbutton','units','norm','string','plot');
set(hb,'position',[.5 .9 .05 .03],'tag','conplot','callback',@conplot);
set(hb,'tooltipstring','plot nodes and links','fontsize',8,'fontweight','bold');

%clear
hb=uicontrol('style','pushbutton','units','norm','string','clear');
set(hb,'position',[.5 .95 .05 .03],'tag','conclear','callback',@conclear);
set(hb,'tooltipstring','clear node and links','fontsize',8,'fontweight','bold');

%help
hb=uicontrol('style','pushbutton','units','norm','string','help');
set(hb,'position',[.55 .95 .05 .03],'tag','conhelp','callback',@conhelp);
set(hb,'tooltipstring','get some help','fontsize',8,'fontweight','bold');


% frame
hb=uicontrol('style','frame','units','norm','string','label prop');
set(hb,'position',[.39 .89 .25 .1],'backgroundcolor','w');
uistack(hb,'bottom');

%USERDATA
u.dummi=1;
set(hk,'userdata',u);
labeldefaults();


% ==============================================
%%   OS-dependency
% ===============================================
if isunix==1 && ismac==0
    set(findobj(gcf,'type','uicontrol'),'fontsize',7);
end


% set(get(gcf,'children'),'units','pixels');
% ==============================================
%%   label properties
% ===============================================

function labeldefaults()
hf=findobj(0,'tag','plotconnections');
u=get(hf,'userdata');

if isfield(u,'lab')==0; u.lab.dummi=1; end
if isfield(u.lab,'fs')           ==0;  u.lab.fs=7        ; end
if isfield(u.lab,'fcol')         ==0;  u.lab.fcol=[0 0 0]  ; end
if isfield(u.lab,'fhorzal')      ==0;  u.lab.fhorzal=2  ; end

if isfield(u.lab,'needlevisible')==0;  u.lab.needlevisible=0; end
if isfield(u.lab,'needlelength')==0;   u.lab.needlelength=10; end
if isfield(u.lab,'needlecol')   ==0;   u.lab.needlecol=[0 0 0]  ; end
set(hf,'userdata',u);

function labelprop(e,e2)
hf=findobj(0,'tag','plotconnections');
u=get(hf,'userdata');


% ==============================================
%%   GUI
% ===============================================

prompt = {'fontsize (numeric)',        'font color [R,G,B]'...
    'Horizontal Alignment (1)left,(2)center,(3)right' ...
    'needle visible [0]no,[1]yes' 'needle length' ,'needle color  [R,G,B]'};
dlg_title = 'label properties';
num_lines = 1;
defaultans = {...
    num2str(u.lab.fs), ...
    num2str(u.lab.fcol), ....
    num2str(u.lab.fhorzal), ...
    num2str(u.lab.needlevisible), ...
    num2str(u.lab.needlelength),...
    num2str(u.lab.needlecol),...
    };
answer = inputdlg(prompt,dlg_title,num_lines,defaultans);
if isempty(answer); return; end
u.lab.fs            =str2num(answer{1});
u.lab.fcol          =str2num(answer{2});
u.lab.fhorzal       =str2num(answer{3});
u.lab.needlevisible =str2num(answer{4});
u.lab.needlelength  =str2num(answer{5});
u.lab.needlecol     =str2num(answer{6});

set(hf,'userdata',u);

select([],[],'nodelabel');


% ==============================================
%%
% ===============================================
function select(e,e2,par)

hf=findobj(0,'tag','plotconnections');
u=get(hf,'userdata');
dx=u.t.Data;

if strcmp(par,'allnodes')
    val=get(findobj(hf,'tag','allnodes'),'value');
    dx(:,[1 3])={logical(val)};
elseif strcmp(par,'nodecol')
    newcol=uisetcolor;
    dx(:,[6 8])={regexprep(num2str(newcol),'\s+',' ')};
elseif strcmp(par,'noderad')
    answer = inputdlg({'Enter node radius'});
    val= (char(answer));
    dx(:,[9 10])={ (val)};
elseif strcmp(par,'nodetra')
    answer = inputdlg({'Enter node transparency'});
    val= (char(answer));
    dx(:,[11 12])={ (val)};
    %##########  ##########  ##########  ##########  ##########  ##########
elseif strcmp(par,'alllinks')
    val=get(findobj(hf,'tag','alllinks'),'value');
    dx(:,[15])={logical(val)};
elseif strcmp(par,'linkcol')
    newcol=uisetcolor;
    dx(:,[18])={regexprep(num2str(newcol),'\s+',' ')};
elseif strcmp(par,'linkrad')
    answer = inputdlg({'Enter link radius'});
    val= (char(answer));
    dx(:,[19])={ (val)};
elseif strcmp(par,'linktra')
    answer = inputdlg({'Enter link transparency'});
    val= (char(answer));
    dx(:,[20])={ (val)};
end

set(u.t,'data',dx);
conplot([],[]);

% alllinks
% par =
% linkcol
% par =
% linkrad
% par =
% linktra

function conplot(e,e2,index)



ht=findobj(0,'tag','plotconnections');
u=get(ht,'userdata');
cind=u.cind;
d=u.t.Data;
hf=findobj(0,'tag','xvol3d');
figure(hf);

% delete(findobj(hf,'tag','link'));
% delete(findobj(hf,'tag','node'));

% us=get(hf,'userdata');
% [ha a xi ind]=rgetnii(us.mask);
% a=a(:); xi=xi'; ind=ind';


if exist('index')==0
    indices=1:size(d,1);
else
    indices=index;
end

cname=get(u.t,'ColumnName');

if get(findobj(ht,'tag','linkintensity'),'value')==1 % LINK inteinsity
    intens=str2num(char(d(:,regexpi2(cname,'cs'))));
    hc=findobj(ht,'tag','linkcolormap');
    va=get(hc,'value');  li=get(hc,'string');
    cmap=(li{va});
    cmap=sub_intensimg('getcolor',cmap);
    intens2=intens;
    intens2=intens2-min(intens2);
    intens2=round((intens2./max(intens2))*(size(cmap,1)-1)+1);
    intens3=cmap(intens2,:);
end

if get(findobj(ht,'tag','CS2RAD'),'value')==1 % CONECTION-THICKNESS
    intens=abs(str2num(char(d(:,regexpi2(cname,'cs')))));
    %widfac=str2num(get(findobj(ht,'tag','CS2RADexpression'),'string'));
    
    conThickness=(intens./max(intens));
    express=get(findobj(ht,'tag','CS2RADexpression'),'string');
    eval(['conThickness=conThickness' express ';']);
end

cindall=[cind{1}; cind{2}];

plotlabel=get(findobj(ht,'tag','nodelabel'),'value');


% dis=sum((xi-repmat([0 0 0],[size(xi,1) 1])).^2,2);%center
% imin=find(dis==min(dis));
% ce=ind(imin,:);
% ce=ce([2 1 3 ]);
ce=round(mean(cindall)); %CENTER COORDINATES
labelhorzal={'left','center','right'};

%plot center of coordinates
% hs=scatter3sph2(ce(:,1),ce(:,2),ce(:,3),'size',3,'color',[0 0 1],'trans',1);
%         set(hs,'FaceLighting','gouraud','tag','node');

for i=indices;%1:size(d,1)
    %disp(['this......' num2str(i) ]);
    
    co= str2num(d{i,regexpi2(cname,'co1')});
    %     dis=sum((xi-repmat(co,[size(xi,1) 1])).^2,2);
    %     imin=find(dis==min(dis));
    %     c1=ind(imin,:);
    %     c1=c1([2 1 3 ]);
    %     co= str2num(d{i,regexpi2(cname,'co2')});
    %     dis=sum((xi-repmat(co,[size(xi,1) 1])).^2,2);
    %     imin=find(dis==min(dis));
    %     c2=ind(imin,:);
    %     c2=c2([2 1 3 ]);
    
    c1=cind{1}(i,:);
    c2=cind{2}(i,:);
    
    
    delete(findobj(hf,'userdata',['node' num2str(i) 'a']));
    delete(findobj(hf,'userdata',['nodetxt' num2str(i) 'a']));
    delete(findobj(hf,'userdata',['needletxt' num2str(i) 'a']));
    if d{i,1}==1
        col   =str2num(d{i,regexpi2(cname,'col1')});
        rad   =str2num(d{i,regexpi2(cname,'R1'  )});
        trans =str2num(d{i,regexpi2(cname,'T1'  )});
        hs=scatter3sph2(c1(:,1),c1(:,2),c1(:,3),'size',rad,'color',col,'trans',trans);
        set(hs,'FaceLighting','gouraud','tag','node');
        set(hs,'userdata',['node' num2str(i) 'a']);
        % LABEL
        if plotlabel==1
            
            df=c1-ce;
            dfn=df./(sqrt(sum(df.^2)));
            ct=c1+dfn*(u.lab.needlelength)    ;%
            cn=c1+dfn*(u.lab.needlelength+2)  ;%
            
            %             ct=c1-(sign(ce-c1)*u.lab.needlelength)    ;%
            %             cn=c1-(sign(ce-c1)*(u.lab.needlelength+2));%
            te=text(cn(:,1),cn(:,2),cn(:,3), d{i,regexpi2(cname,'label1')},'fontsize',u.lab.fs,'Color',u.lab.fcol);
            set(te,'userdata',['nodetxt' num2str(i) 'a'],'HorizontalAlignment',labelhorzal{u.lab.fhorzal});
            if u.lab.needlevisible==1
                hp=plot3([c1(1) ct(1)],[c1(2) ct(2)],[c1(3) ct(3)],'k','color',u.lab.needlecol);
                set(hp,'userdata',['needletxt' num2str(i) 'a']);
            end
        end
    end
    delete(findobj(hf,'userdata',['node' num2str(i) 'b']));
    delete(findobj(hf,'userdata',['nodetxt' num2str(i) 'b']));
    delete(findobj(hf,'userdata',['needletxt' num2str(i) 'b']));
    if d{i,3}==1
        
        col   =str2num(d{i,regexpi2(cname,'col2')});
        rad   =str2num(d{i,regexpi2(cname,'R2'  )});
        trans =str2num(d{i,regexpi2(cname,'T2'  )});
        hs=scatter3sph2(c2(:,1),c2(:,2),c2(:,3),'size',rad,'color',col,'trans',trans);
        set(hs,'FaceLighting','gouraud','tag','node');
        set(hs,'userdata',['node' num2str(i) 'b']);
        % LABEL
        if plotlabel==1
            df=c2-ce;
            dfn=df./(sqrt(sum(df.^2)));
            ct=c2+dfn*(u.lab.needlelength)    ;%
            cn=c2+dfn*(u.lab.needlelength+2)  ;%
            
            %             ct=c2-(sign(ce-c2)*u.lab.needlelength)    ;%
            %             cn=c2-(sign(ce-c2)*(u.lab.needlelength+2));%
            te=text(cn(:,1),cn(:,2),cn(:,3), d{i,regexpi2(cname,'label2')},'fontsize',u.lab.fs,'Color',u.lab.fcol);
            set(te,'userdata',['nodetxt' num2str(i) 'b'],'HorizontalAlignment',labelhorzal{u.lab.fhorzal});
            if u.lab.needlevisible==1
                hp=plot3([c2(1) ct(1)],[c2(2) ct(2)],[c2(3) ct(3)],'k','color',u.lab.needlecol);
                set(hp,'userdata',['needletxt' num2str(i) 'b']);
                
                %hp=plot3([ce(1) ct(1)],[ce(2) ct(2)],[ce(3) ct(3)],'k','color',[1 0 0]);
                %set(hp,'userdata',['needletxt' num2str(i) 'b']);
                
            end
        end
        
    end
    delete(findobj(hf,'userdata',['link' num2str(i)  ]));
    if d{i,15}==1
        if get(findobj(ht,'tag','linkintensity'),'value')==1 % LINK inteinsity
            col=intens3(i,:);
        else
            col   =str2num(d{i,regexpi2(cname,'Lcol')});
        end
        rad   =str2num(d{i,regexpi2(cname,'LR'  )});
        trans =str2num(d{i,regexpi2(cname,'LT'  )});
       
        if get(findobj(ht,'tag','CS2RAD'),'value')==1 % CONECTION-THICKNESS
             %disp('------------------');
             %disp(conThickness);
             [X, Y, Z] = cylinder2P( conThickness(i) , 50,c1,c2);
        else
            [X, Y, Z] = cylinder2P(           rad , 50,c1,c2);
        end
        %         [X, Y, Z] = cylinder2P( Trad(i)*str2num(p.connectionthickness)  , 50,li(:,1)',li(:,2)');
        hl=surf(X, Y, Z);
        set(hl,'FaceColor',col,'edgecolor','none','FaceAlpha',trans,'tag','link');
        set(hl,'userdata',['link' num2str(i) ]);
    end
    
end

%colorbar
delete(findobj(hf,'tag','cbarintens'));
delete(findobj(hf,'tag','axintens'));
if get(findobj(ht,'tag','linkintensity'),'value')==1 % LINK inteinsity
    ha=axes('position',[.9 .85 .01 .1]);
    %set(hs,'position',[.9 .85 .01 .1]);
    imagesc(intens);
    colormap(cmap);
    hc=colorbar;
    set(hc,'position',[.9 .85 .01 .1],'YAxisLocation','right','fontsize',7,'tag','cbarintens');
    set(ha,'position',[1 1 .0001 .0001],'tag','axintens');
    axes(findobj(hf,'tag','ax0'));
end


function conclear(e,e2)


ht=findobj(0,'tag','plotconnections');
u=get(ht,'userdata');
% d=u.t.Data;
hf=findobj(0,'tag','xvol3d');

delete(findobj(hf,'tag','cbarintens'));
delete(findobj(hf,'tag','axintens'));
% delete(findobj(hf,'tag','link'));
% delete(findobj(hf,'tag','node'));
indices=1:100 ;%size(d,1);

for i=1:length(indices)
    delete(findobj(hf,'userdata',['node' num2str(i) 'a']));
    delete(findobj(hf,'userdata',['node' num2str(i) 'b']));
    delete(findobj(hf,'userdata',['link' num2str(i)  ]));
    
    delete(findobj(hf,'userdata',['nodetxt' num2str(i) 'a']));
    delete(findobj(hf,'userdata',['needletxt' num2str(i) 'a']));
    
    delete(findobj(hf,'userdata',['nodetxt' num2str(i) 'b']));
    delete(findobj(hf,'userdata',['needletxt' num2str(i) 'b']));
end


% function plotthis
%
% % ==============================================
% %%
% % ===============================================
%
% figure(findobj(0,'tag','xvol3d'))
% hold on
% [ha a xi ind]=rgetnii('AVGT.nii');
% a=a(:); xi=xi'; ind=ind';
%
% hf=findobj(0,'tag','plotconnections');
% u=get(hf,'userdata');
% d=u.t.Data;
% cname=get(u.t,'ColumnName');
%
% for i=1:size(d,1)
%     if d{i,1}==1
%        co= str2num(d{i,regexpi2(cname,'co1')})
%         dis=sum((xi-repmat(co,[size(xi,1) 1])).^2,2);
%         imin=find(dis==min(dis));
%         co2=ind(imin,:);
%         co2=co2([2 1 3 ]);
%         co2
%         hs=scatter3sph2(co2(:,1),co2(:,2),co2(:,3),'size',5,'color',[1 0 0],'trans',0.7);
%         set(hs,'FaceLighting','gouraud')
%     end
% end

% ==============================================
%%
% ===============================================

function CellEditCallback(e,e2)
ic=e2.Indices;

if ic(2)==13 ||  ic(2)==14
    ht=findobj(0,'tag','plotconnections');
    u=get(ht,'userdata');
    d=u.t.Data;
    head=u.t.ColumnName;
    cind=convertmm2ind(head,d);
    u.cind=cind;
    set(ht,'userdata',u);
    
end

conplot(e,e2,ic(1));



function CellSelectionCallback(e,e2)

ic=e2.Indices;
ht=findobj(0,'tag','plotconnections');
hf=findobj(0,'tag','xvol3d');
u=get(ht,'userdata');
dx=u.t.Data;

cnames=get(u.t,'ColumnName');
% if ~ischar(cnames(ic(2))); return; end
try
    if strcmp(cnames(ic(2)),'c')
        setcolor(ic);
    elseif strcmp(cnames(ic(2)),'label1')% | strcmp(cnames(ic(2)),'label2')
        hd=findobj(hf,'userdata', ['node' num2str(ic(1)) 'a']);
        if ~isempty(hd)
            set(hd,'visible','off'); pause(.1);set(hd,'visible','on');
        end
    elseif strcmp(cnames(ic(2)),'label2')% | strcmp(cnames(ic(2)),'label2')
        hd=findobj(hf,'userdata', ['node' num2str(ic(1)) 'b']);
        if ~isempty(hd)
            set(hd,'visible','off'); pause(.1);set(hd,'visible','on');
        end
    end
end


% stat=e2.Source.Data{ic(1),ic(2)};
% dat=e2.Source.Data;

function setcolor(ic);
hf=findobj(0,'tag','plotconnections');
u=get(hf,'userdata');
dx=u.t.Data;
newcol=uisetcolor;
dx{ic(1),ic(2)+1}=regexprep(num2str(newcol),'\s+',' ');
if 1
    newcolStr=regexprep(num2str(newcol),'\s+',' ');
    jscroll = findjobj(u.t);
    jtable = jscroll.getViewport.getComponent(0);
    %jtable.setValueAt(java.lang.String('This value will be inserted'),0,0); % to insert this value in cell (1,1)
    jtable.setValueAt(java.lang.String(newcolStr),ic(1)-1,ic(2)); % to insert this value in cell (1,1)
end



function conhelp(e,e2)
uhelp([mfilename]);

return
cf
pw='C:\Users\skoch\Desktop\shrew_3dvol';
mask=fullfile(pw,'AVGT.nii');

xvol3d('loadbrainmask',mask)
% xvol3d('statimage','ROI4_sm.nii');
roi=fullfile(pw,'ROI4_sm.nii');
xvol3d('statimage',roi);
xvol3d('plottr',7,'alpha',.3);%plot-TR at threshold .3
figure(findobj(0,'tag','xvol3d'));
view(-90,90)
xvol3d('arrows','off')
xvol3d('light','off');
xvol3d('light','on');








