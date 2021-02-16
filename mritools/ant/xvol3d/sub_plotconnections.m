% 
% #wb plot node and links (connections)
% #bo INPUT: excel-table with 
% excel-table input column-names (column names must match with those below)
% 'Label1'    : region/label name of node1   
% 'Label2'    : region/label name of node2  
% 'co1'       : 3d (x,y,z)-coordinates [mm] of node1  (->saved in single excel column)
% 'co2'       : 3d (x,y,z)-coordinates [mm] of node2  (->saved in single excel column)
% 'cs'        : connection strength or any other parameter to display
%  #b --> go to [specific Task]--> select "save example node/connection Excel-file [exampleXLSX]"
%  #b     to create an example Node/link excelfile which can be used as input
% -------------------
% #b Excel-file example: 
%  COLUMN-A   COLUMN-B         COLUMN-C                    COLUMN-D              COLUMN-E
%  'Label1'  'Label2'            'co1'                      'co2'                 'cs' 
%  region1	  region2	 -0.80014 1.6151 -0.90994	 0.75024 1.6782 -0.90562	   -4
%  region3	  region4	 -1.768 -1.1643 -1.39	     1.7447 -0.99306 -1.3838	   -0.148148148
%  region5	  region6	 0.011078 -3.1784 -0.32861	 -0.047126 -0.63101 -1.2141 	2.518518519
%  region7	  region8	 -1.8972 -0.2773 -1.0836	 1.8806 -0.22126 -1.0607     	4
%
% #bo BUTTONS etc
% #g ======load data, plot, help etc ========================
% [load data]:    load node/link excel-file (see above)
% [plot]:         plot nodes and links 
% [clear]:        clear nodes and links 
% [columns vis]:  show/hide specific table columns
% [help]:          get some help 
% 
% #g ======COLOR,RADIUS, TRANSPARENCY of NODES AND LINKS ========================
% [nodes COL]: set color of all nodes  [RGB-triplet]
% [nodes RAD]: set radious of all nodes [value>0]
% [nodes TRA]: set transparency of all nodes [0-1]
% [link COL]:  set color of all links  [RGB-triplet]
% [link RAD]:  set radious/width of all links [value>0]
% [link TRA]:  set transparency of all links [0-1]
% 
% #g    SELECTION
% [select all]:     show/hide all nodes and lnks
% [all nodes]:      show/hide all nodes
% [all links]:      show/hide all links
% [instant update]: [0|1]; instant update plot when select/deselect a node/link
% [select row]:     select/deselect entire row (two nodes and the link between nodes)
% [specific task]:  allows to:
%     - select links with positive [CS] (connection scores)
%     - select links with negative [CS]
%     - select rows (nodes and the link) with positive [CS]
%     - select rows (nodes and the link) with negative [CS]
%     * sort table after CS-values
%     * sort table after absolute CS-values
%     * sort table after absolute Node1-labels (Label1)
%     + save example ode/link Excelfile
% 
% #g ============ LABELS ========================
% [label]: show/hide label
% [label prop]: set specific label properties
% 
% #g ============ LINK COLOR/THICKNESS ========================
% [CS2col]     colorize links using connection strength parameter [0,1]
% [colormaps]  specify the colormap; applied only if [CS2col] is true 
% [CS2RAD]     connection strength is expressed as link thickness (larger absolute values obtain a 
%              larger radius)
% [EDIT field] right to [CS2RAD]: math. expression used to connection strength to radius
%              (i.e. thickness of links) ..see tooltip for more information 
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
mask=getappdata(hf,'mask');
if isempty(mask)
    [hb b xi ind]=rgetnii(us.mask);
    mask.hb=hb;
    mask.b =b;
    mask.xi=xi;
    mask.ind=ind;
    setappdata(hf,'mask',mask);
else
    hb =mask.hb;
    b  =mask.b;
    xi =mask.xi;
    ind=mask.ind;
end

b=b(:); xi=xi'; ind=ind';
co1=a(:,regexpi2(ha,'co1'));
co2=a(:,regexpi2(ha,'co2'));
cc={co1 co2};
% ==============================================
%%  ISSUE: multiple search of the same coordinate
% ===============================================
C1=single(str2num(char(([co1]))));
C2=single(str2num(char(([co2]))));
cx=[C1; C2];
cs=unique(cx,'rows');
% tic
xi2 =single(xi);
ind2=single(ind);

minc=min(cs)-1;
maxc=max(cs)+1;
xi2(xi2(:,1)<minc(1),:)=nan;
xi2(xi2(:,2)<minc(2),:)=nan;
xi2(xi2(:,3)<minc(3),:)=nan;
xi2(xi2(:,1)>maxc(1),:)=nan;
xi2(xi2(:,2)>maxc(2),:)=nan;
xi2(xi2(:,3)>maxc(3),:)=nan;

[b1 b2]=deal(zeros(size(C1)));
msg='..mm2index-conversion';
disp('..');
% cprintf([0 .5 0],'..__..');
for i=1:size(cs,1)
    str=[msg ': ' num2str(i)  '..'];
    back=sprintf([repmat('\b', [1 length(str)]) '%s']);
    cprintf([0 .5 0],back);
    cprintf([0 .5 0],str);
    co=single(cs(i,1:3));
    
%     iv=find( xi2(:,1)>co(1)-1 ); %& xi(:,2)>co(2)-1 & xi(:,2)<co(2)+1;
%     xi2 =xi2(iv,:);
%     ind2=ind2(iv,:);
%     dis= (sum( abs(bsxfun(@minus, xi2, co))  ,2));
%     imin2=(find(dis==min(dis)));
%     c1=ind2(imin2,:);
    %-----------
    iv=find( xi2(:,1)>co(1)-.5  & xi2(:,1)<co(1)+.5); %& xi(:,2)>co(2)-1 & xi(:,2)<co(2)+1;
    dis= (sum( abs(bsxfun(@minus, xi2(iv,:), co))  ,2));
    imin2=iv(find(dis==min(dis)));
    c1=ind2(imin2,:);
    c1=c1([2 1 3 ]);
    
%     disp(c1);
    idx1=find(C1(:,1)==co(1) & C1(:,2)==co(2) & C1(:,3)==co(3));
    idx2=find(C2(:,1)==co(1) & C2(:,2)==co(2) & C2(:,3)==co(3));
    
    b1(idx1,:)=repmat(c1,[length(idx1) 1]);
    b2(idx2,:)=repmat(c1,[length(idx2) 1]);
end
% toc
cind={b1 b2};
  cprintf([0 .5 0],'done\n');

% ==============================================
%%   older ,slower version
% ===============================================
if 0
    tic
    xi=single(xi);
    cind={};
    for i=1:length(cc)
        ds=single(str2num(char(cc{i})));
        ci=[];
        for j=1:size(ds,1)
            co=ds(j,:);
            if 1
                %dis=sum((xi-repmat(co,[size(xi,1) 1])).^2,2);
                dis= (sum(bsxfun(@minus, xi, co).^2,2));
                imin=find(dis==min(dis));
                c1=ind(imin,:);
            end
            if 0
                iv=find( xi(:,1)>co(1)-1 & xi(:,1)<co(1)+1 ); %& xi(:,2)>co(2)-1 & xi(:,2)<co(2)+1
                %dis= (sum(bsxfun(@minus, xi(iv,:), co).^2,2));
                dis= (sum( abs(bsxfun(@minus, xi(iv,:), co))  ,2));
                imin2=iv(find(dis==min(dis)));
                c1=ind(imin2,:);
            end
            
            c1=c1([2 1 3 ]);
            ci(j,:)=c1;
        end
        cind{i}=ci;
    end
    toc
end
% ==============================================
%%   
% ===============================================


function conload(e,e2,filenode)
% -------------
ht=findobj(0,'tag','plotconnections');
if isempty(ht)
    sub_plotconnections();
end
% -------------
fprintf('..busy loading nodes&links-excelfile ..');
hk=findobj(0,'tag','plotconnections');
delete(findobj(hk,'tag','table1')); %delete previous table


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
if numel((a{1}))==1
    %% ------ get sheetNumber
    prompt = {['First sheet seems to be empty!' char(10)  ...
        'Enter the corect Excel sheet-number: ' char(10) ... 
        ]};
    dlgtitle = 'Sheet Number';
    dims = [1 35];
    definput = {'2'};
    answer = inputdlg(prompt,dlgtitle,dims,definput);
    sheetno=str2num(answer{1});
    if sheetno==0
        return
    end
    [~,aa,a]=xlsread(filenode,sheetno);
    %% ------
end
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
u.ColumnWidth_bk=u.t.ColumnWidth;
% HIDE COLUMNS
hidecols={'co1' 'co2'};
hidecolSearch=strjoin(cellfun(@(a){['^' (a) '$']} ,hidecols),'|');
icol_hide=regexpi2(u.t.ColumnName,hidecolSearch);
u.t.ColumnWidth(icol_hide)={0};


set(t,'fontsize',7);

u.cind=cind; %coordinates integer
set(gcf,'userdata',u);
 fprintf('..done\n');
 
 
 cmenu = uicontextmenu;
 item1= uimenu(cmenu, 'Label','[ ] short-list type','Callback', {@listMenu, 'changeList'},'tag','changeList');
 item1= uimenu(cmenu, 'Label','show list in extra window','Callback', {@listMenu, 'exportList'},'tag','exportList');
 
 item1= uimenu(cmenu, 'Label',['<html><h1>INFO<pre><h2><font color="green"> **** SHORTCUTS ***'...
     ' <br> [-/+]  ... change font size  '...
     ' <br> [c]    ... change font color  '...
     ' <br> [shift]+[arrowKey]    ... shift axes position'...
     ],'separator','on');
 set(t,'UIContextMenu',cmenu);
 
 %----shift axes
 hf=findobj(0,'tag','xvol3d');
 ax0=findobj(hf,'tag','ax0');
 pos=get(ax0,'position');
 set(ax0,'position',[.02 pos(2:end)]);
 figure(findobj(0,'tag','plotconnections'));

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
hb=uicontrol('style','radio','units','norm','string','label','value',1);
set(hb,'position',[0.26611 0.93684 0.06 0.032],'tag','nodelabel','callback',{@select,'nodelabel'},'backgroundcolor','w');
set(hb,'tooltipstring','show node label','fontsize',8,'fontweight','bold');
% label props
hb=uicontrol('style','pushbutton','units','norm','string','label prop');
set(hb,'position',[.265 .9 .09 .032],'tag','labelprop','callback',@labelprop,'backgroundcolor','w');
set(hb,'tooltipstring','set label properties','fontsize',8,'fontweight','bold');

% frame
hb=uicontrol('style','frame','units','norm','string','label prop');
set(hb,'position',[[0.263 0.90071 0.11 0.1]],'backgroundcolor','w');
uistack(hb,'bottom');




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
 
% ----------------------------------------------------------------------
%select nodes color
hb=uicontrol('style','pushbutton','units','norm','string','node COL');
set(hb,'position',[.1 .964 .08 .032],'tag','nodecol','callback',{@select,'nodecol'},'backgroundcolor','w');
set(hb,'tooltipstring','set node color','fontsize',7);
%select nodes Radius
hb=uicontrol('style','pushbutton','units','norm','string','node RAD');
set(hb,'position',[.1 .932 .08 .032],'tag','noderad','callback',{@select,'noderad'},'backgroundcolor','w');
set(hb,'tooltipstring','set node radius','fontsize',7);
%select nodes Transparency
hb=uicontrol('style','pushbutton','units','norm','string','node TRA');
set(hb,'position',[.1 .90 .08 .032],'tag','nodetra','callback',{@select,'nodetra'},'backgroundcolor','w');
set(hb,'tooltipstring','set node transparency','fontsize',7);
% ----------------------------------------------------------------------

% ----------------------------------------------------------------------
%select link color
hb=uicontrol('style','pushbutton','units','norm','string','link COL');
set(hb,'position',[.17946 .964 .08 .032],'tag','linkcol','callback',{@select,'linkcol'},'backgroundcolor','w');
set(hb,'tooltipstring','set link color','fontsize',7);
%select link Radius
hb=uicontrol('style','pushbutton','units','norm','string','link RAD');
set(hb,'position',[.17946 .932 .08 .032],'tag','linkrad','callback',{@select,'linkrad'},'backgroundcolor','w');
set(hb,'tooltipstring','set link radius','fontsize',7);
%select link Transparency
hb=uicontrol('style','pushbutton','units','norm','string','link TRA');
set(hb,'position',[.17946 .90 .08 .032],'tag','linktra','callback',{@select,'linktra'},'backgroundcolor','w');
set(hb,'tooltipstring','set link transparency','fontsize',7);
% ----------------------------------------------------------------------

% ---------SELECTION--------------------------------------------------------------------------------------
%deselect all
hb=uicontrol('style','radio','units','norm','string','select all','value',1);
set(hb,'position',[0.59285 0.96303 0.07 0.03],'tag','selectAll','callback',@selectAll,...
    'fontsize',7,'fontweight','normal','backgroundcolor','w');
set(hb,'tooltipstring',['select/deselect all nodes and links ' char(10)...
    '    [0]deselect all nodes andlinks ' char(10)...
    '    [1]  select all nodes and links ' char(10)...  
]);
%% select all nodes
hb=uicontrol('style','radio','units','norm','string','all nodes','value',1);
set(hb,'position',[0.59285 0.9297 0.1 0.032],'tag','allnodes','callback',{@select,'allnodes'},'backgroundcolor','w');
set(hb,'tooltipstring','select/deselect all nodes','fontsize',7,'fontweight','normal');
%% select all links
hb=uicontrol('style','radio','units','norm','string','all links','value',1);
set(hb,'position',[0.59285 0.89636 0.09 0.032],'tag','alllinks','callback',{@select,'alllinks'},'backgroundcolor','w');
set(hb,'tooltipstring','select/deselect all links','fontsize',7,'fontweight','normal');
% ----------------------------------------------------------------------
%% instantUpdate
hb=uicontrol('style','radio','units','norm','string','instant update','value',1);
set(hb,'position', [0.67454 0.97017 0.1 0.032],'tag','instantUpdate','backgroundcolor','w');
set(hb,'tooltipstring','instant plot update when single node/link is check/unchecked',...
    'fontsize',6,'fontweight','normal');
%% select row
hb=uicontrol('style','radio','units','norm','string','select Row','value',0);
set(hb,'position',[[0.67454 0.93684 0.1 0.032]],'tag','selectRow','backgroundcolor','w');
set(hb,'tooltipstring',['select/unselect entire row' char(10) ...
    ' 0) : The SINGLE node OR link is selected/selected' char(10)...
   '  1) : The entire ROW is selected: two nodes and the link'],...
    'fontsize',6,'fontweight','normal');
%% specific TASK-BTN
hb=uicontrol('style','pushbutton','units','norm','string','specific Task','value',1,'backgroundcolor','w');
set(hb,'position',[[0.67578 0.90827 0.07 0.03]],'tag','selectSpecific','callback',{@selectSpecific},'fontsize',6);
set(hb,'tooltipstring',...
   [ '<html><b>SPECIFIC TASKS</b>  <br>'...
    '   * specific selection of nodes/links  <br>'...
    '   * sorting after CS-score/label  <br>' ...
    '   * copy region-IDs to clipboard ...can be used for displaying the atlas-regions  <br>' ...
    '   * save example Excel-file  <br>' ...
    '   ']);
% ----------------------------------------------------------------------




% ==============================================
%%  Colorize connections
% ===============================================
hb=uicontrol('style','radio','units','norm','string','CS2COL','value',0);
set(hb,'position',[.81 .93684 .09 .032],'tag','linkintensity','callback',{@select,'linkintensity'},...
    'backgroundcolor','w','fontsize',7);
set(hb,'tooltipstring',['<html><b>colorize connections</b><br>' ...,'fontsize',7);
     '  if [x]: CS-parameter specifies the color of connections']);
% ==============================================
%%   colormap
% ===============================================
list=sub_intensimg('getcmap');
maplist=makeColorList(list);

hb=uicontrol('style','popupmenu','units','norm','string',maplist,'value',1);
set(hb,'position',[.91 .87 .09 .13],'tag','linkcolormap','backgroundcolor','w');
set(hb,'tooltipstring','colormap of connections','fontsize',6,'fontweight','bold',...
    'callback',{@select,'linkcolormap'},'fontname','Courier');%
set(hb,'position',[0.8100    0.8360    0.15    0.100]);
% ==============================================
%%   intensity to connectionThickness
% ===============================================
hb=uicontrol('style','radio','units','norm','string','CS2RAD','value',0);
set(hb,'position',[.81 .97017 .09 .032],'tag','CS2RAD','callback',{@select,'CS2RAD'},...
    'backgroundcolor','w','fontsize',7);
set(hb,'tooltipstring',['<html><b>connection radius</b> <br>' ...
    ' thickness (radus) of conecting links is defined by connection strength(CS)  <br>' ...
    '  if [x]: CS-parameter determines the radius of connections (tube-radius)']);

hb=uicontrol('style','edit','units','norm','string','*1.5+.3');
set(hb,'position',[.93 .967 .07 .032],'tag','CS2RADexpression','callback',{@select,'CS2RADexpression'},...
    'backgroundcolor','w');
set(hb,'fontsize',7,'fontweight','normal','tooltipstring',...
    ['<html><b>math expression to translate CS-paramter to connection-radius </b><br>' ...
    'NOTE: First, the absulute conection strength is used and normalized by it''s maximum  <br>'  ...
    '           NCS=abs(CS)/max(abs(CS))  <br>'  ...
    'Than, the math expression is applied to NCS  <br>'  ...
    'Example: "*3+.5"  --> "Radius=NCS*3+.5"  to obtain suitable radius-values for the conections']);

% ==============================================
%%   colorlimis
% ===============================================

hb=uicontrol('style','edit','units','norm','string',' ');
set(hb,'position',[0.92949 0.93446 0.07 0.032],'tag','colorlimits','callback',{@select,'colorlimits'},'backgroundcolor','w');
set(hb,'fontsize',7,'fontweight','normal','tooltipstring',...
    ['<html><b>Color-limits (2 values) </b>  <br>'  ...
    '  - if <b>EMPTY </b>: use internal color limits  <br>'  ...
    '  - otherwise set two values (min and max color value) ']);


% ==============================================
%%
% ===============================================

%load excelfile
hb=uicontrol('style','pushbutton','units','norm','string','load data');
set(hb,'position',[0.39112 0.96779 0.075 0.03],'tag','conload','callback',@conload);
set(hb,'fontsize',8,'fontweight','bold');
set(hb,'tooltipstring',['<html><b>load nodes+links-file (EXCEL-FILE)</b><br>' ...
    '<font color=red> &#8599; see help'])

%PLOT
hb=uicontrol('style','pushbutton','units','norm','string','plot');
set(hb,'position',[0.39112 0.90113 0.05 0.03],'tag','conplot','callback',@conplot);
set(hb,'tooltipstring','plot/replot nodes & links','fontsize',8,'fontweight','bold');
set(hb,'backgroundcolor',[1 1 0]);

%clearPlot
hb=uicontrol('style','pushbutton','units','norm','string','clear plot');
set(hb,'position',[0.51859 0.89875 0.07 0.03],'tag','conclear','callback',@conclear);
set(hb,'tooltipstring','clear node and links from plot','fontsize',7,'fontweight','bold');



%visible columns
hb=uicontrol('style','pushbutton','units','norm','string','columns vis.');
set(hb,'position',[0.46785 0.96779 0.07 0.03],'tag','hidecolumns','callback',@hidecolumns);
set(hb,'tooltipstring','show/hide specify table columns','fontsize',6,'fontweight','bold');

%help
hb=uicontrol('style','pushbutton','units','norm','string','help');
set(hb,'position',[0.53963 0.96779 0.05 0.03],'tag','conhelp','callback',@conhelp);
set(hb,'tooltipstring','get some help','fontsize',8,'fontweight','bold');
set(hb,'backgroundcolor',[1 1 0]);


% frame
hb=uicontrol('style','frame','units','norm','string','label prop');
set(hb,'position',[.39 .89875 .2 .102],'backgroundcolor','w','foregroundcolor','b');
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
%%   SUBS
% ===============================================
function selectSpecific(e,e2)
ht=findobj(0,'tag','plotconnections');
hp=uipanel('parent',ht,'units','norm','backgroundcolor','w','fontweight','bold');
set(hp,'position',[.5 .2 .4 .5],'title','specific selection','tag','specselect_frame');
% Listbox


list={...
    '<html><font color=gray><b>_____SELECTION__________________________ '
    '<html>select <b>LINKS</b> with <b>postive</b>  CS-values only [posVal]'
    '<html>select <b>LINKS</b> with <b>negative</b> CS-values only [negVal]'
    '<html><font color=green> select <b>ROWS</b> with <b>postive</b>  CS-values only [posValrow]'
    '<html><font color=green> select <b>ROWS</b> with <b>negative</b> CS-values only [negValrow]'    
    ...
    '<html><font color=gray><b>_____SORTING__________________________ '
    'sort CS-values [sortCS]'
    'sort absolute CS-values [sortCSabs]'
    'sort sortLabel1 [sortLabel1]'
    '<html><font color=gray><b>_____MISCELLANEOUS__________________________ '
    '<html><font color=#E93ECF>copy <b>atlas-IDs to clipboard</b> &#8594; use this to colorize node-related atlas regions via [byIDs]-Button [getAtlasID]'
    '<html><font color=#E93ECF>save <b>example</b> node/connection Excel-file &#8594;use this as example to examine this GUI [exampleXLSX]'
    };
hb=uicontrol(hp, 'style','listbox','units','norm','string',list,'value',1,'backgroundcolor','w');
set(hb,'position',[0  .25 1 .75],'tag','specselect_list','fontsize',7,'foregroundcolor','b');
set(hb,'tooltipstring','specific selection of nodes/links','fontsize',7,'fontname','courier');

%OK
hb=uicontrol(hp,'style','pushbutton','units','norm','string','OK');
set(hb,'position',[0.8 0 0.2 0.1],'tag','specselect_OK','callback',{@selectSpecific_task,'OK'});
set(hb,'tooltipstring','OK...select this nodes/links','fontsize',7,'fontweight','bold');
%Cancel
hb=uicontrol(hp,'style','pushbutton','units','norm','string','Cancel');
set(hb,'position',[0 0 0.2 0.1],'tag','specselect_Cancel','callback',{@selectSpecific_task,'Cancel'});
set(hb,'tooltipstring','Cancel...do nothing','fontsize',7,'fontweight','bold');

function selectSpecific_task(e,e2,task)
ht=findobj(0,'tag','plotconnections');
hl=findobj(ht,'tag','specselect_list');
hframe=findobj(ht,'tag','specselect_frame');
u=get(ht,'userdata');
if isfield(u,'t')
    i_cs = find(strcmp(u.t.ColumnName,'cs'));
    csdata=str2num(char(u.t.Data(:,i_cs)));
end
 
if strcmp(task,'OK')==1
    str    =   hl.String{hl.Value};
    if     ~isempty(strfind(str,'[posVal]'  ))        %LINK ONLY
        ichk=sign(csdata)==+1;
        u.t.Data(:,i_cs-1)=num2cell(logical(ichk));
    elseif ~isempty(strfind(str,'[negVal]'  ))
        ichk=sign(csdata)==-1;
        u.t.Data(:,i_cs-1)=num2cell(logical(ichk));
    elseif     ~isempty(strfind(str,'[posValrow]'  ))    %entire ROW
        ichk=sign(csdata)==+1;
        u.t.Data(:,i_cs-1)=num2cell(logical(ichk));
        u.t.Data(:,find(strcmp(u.t.ColumnName,'label1'))-1)=num2cell(logical(ichk));
        u.t.Data(:,find(strcmp(u.t.ColumnName,'label2'))-1)=num2cell(logical(ichk));
    elseif     ~isempty(strfind(str,'[negValrow]'  ))    %entire ROW
        ichk=sign(csdata)==-1;
        u.t.Data(:,i_cs-1)=num2cell(logical(ichk));
        u.t.Data(:,find(strcmp(u.t.ColumnName,'label1'))-1)=num2cell(logical(ichk));
        u.t.Data(:,find(strcmp(u.t.ColumnName,'label2'))-1)=num2cell(logical(ichk));
    elseif ~isempty(strfind(str,'[sortCS]'  ))
        [val isort]=sort(u.t.Data(:,i_cs));
        u.t.Data=u.t.Data(isort,:);
        u.cind{1}=u.cind{1}(isort,:);
        u.cind{2}=u.cind{2}(isort,:);
        set(ht,'userdata',u);
    elseif ~isempty(strfind(str,'[sortCSabs]'  ))
        [val isort]=sort(abs(csdata));
        u.t.Data=u.t.Data(isort,:);
        u.cind{1}=u.cind{1}(isort,:);
        u.cind{2}=u.cind{2}(isort,:);
        set(ht,'userdata',u);
    elseif ~isempty(strfind(str,'[sortLabel1]'  ))
        [val isort]=sort(u.t.Data(:,find(strcmp(u.t.ColumnName,'label1'))));
        u.t.Data=u.t.Data(isort,:);
        u.cind{1}=u.cind{1}(isort,:);
        u.cind{2}=u.cind{2}(isort,:);
        set(ht,'userdata',u);
    elseif ~isempty(strfind(str,'[exampleXLSX]'  ))
        ht={'Label1'	'Label2'	'co1'	'co2'	'cs'};
        t={...
            'L Superior colliculus sensory related'	'L Retrosplenial area lateral agranular part'	'-0.67373 -4.5614 -1.2474'	'-1.2764 -3.6993 -0.26086'     7.61142568
            'L Piriform area'                      	'L Main olfactory bulb'                     	'-3.3434 0.029347 -4.7135'	'-0.85396 3.7316 -2.0548'	   3.479209242
            'L Superior colliculus sensory related'	'L Field CA1'                                   '-0.67373 -4.5614 -1.2474'	'-2.7097 -3.0323 -2.489'	   4.444886086
            'L Reticular nucleus of the thalamus'	    'L Pallidum medial region'                      '-1.8505 -1.2061 -3.2093'	'-0.37025 0.48596 -3.9109'     5.320443035
            };
        msg='save example node/link-Excelfile...specify filename';
        disp([msg '...']);
        [fi pa]=uiputfile(fullfile(pwd,'*.xlsx'),msg);
        if isnumeric(fi); return; end
        fiout=fullfile(pa,fi);
        [pa fi]=fileparts(fiout);
        fiout=fullfile(pa,[fi '.xlsx']);
        pwrite2excel(fiout,{1 'connections' },[ht],[],[t]);
        showinfo2('saved Exsample node/link-Excelfile',fiout);
    elseif ~isempty(strfind(str,'[getAtlasID]'  ))
        % ==============================================
        %%   get Atlas region ID
        % ===============================================
        
        hf=findobj(0,'tag','xvol3d');
        ht=findobj(0,'tag','plotconnections');
        u2=get(hf,'userdata');
        u =get(ht,'userdata');
        
        icol=regexpi2(u.t.ColumnName,'label1|label2|cs');
        d=u.t.Data(:,sort([icol(:)-1 ;icol(:)]));
        % ==============================================
        %
        % ===============================================
        cprintf([ 0.9294    0.6941    0.1255],['---------------------------------' '\n' ]);
        cprintf(-[ 0.9294    0.6941    0.1255],['GET ATLAS-IDs ... chose number ...' '\n' ]);
        msg={...
            '[1] get atlas-IDS  of all nodes'...
            '[2] get atlas-IDS  of selected nodes'...
            '[3] get atlas-IDS  of selected links'...
            '[4] get left-hemispheric atlas-IDS'...
            '[5] get right-hemispheric atlas-IDS'...
            };
        disp(char(msg));
        drawnow;
        out=input('ENTER VALUE (example: [1]): ','s');
        out=str2num(out);
        if out==0;
            disp('..canceled..');
            return;
        elseif out==1;
            lab=unique([d(:,2); d(:,4)]);
        elseif out==2;
            lab=([d(:,1:2); d(:,3:4)]);
            lab=lab(find(cell2mat(lab(:,1))),2);
        elseif out==3;
            lab=d(find(cell2mat(d(:,5))),[2 4]);
            lab=unique(lab(:));
        elseif out==4;
            lab=([d(:,2); d(:,4)]);
            lab=lab(regexpi2(lab,'^L |^L_'));
        elseif out==5;
            lab=([d(:,2); d(:,4)]);
            lab=lab(regexpi2(lab,'^R |^R_'));
        end
        if ~isfield(u2,'lu')
           msgbox('No atlas loaded. Use [load atlas]-Button and select an atlas-file.','atlas-ID to clipboard') ;
           return
        end
        lablist=u2.lu(:,1);
        lablist=regexprep(lablist,{'_' },{' '}  );
        lab    =regexprep(lab    ,{'_' },{' '}  );
        ir=find(ismember(lablist,lab));
        ID=cell2mat(u2.lu(ir,4));
        if isempty(ID); msgbox('no IDs found');return; end
        clipboard('copy',ID);
        disp(['IDs (n=' num2str(length(ID)) ') copied to clipboard...hit [by IDs]-Btn and past IDs']);
        
        
         
    end
    
end
delete(hframe);







function specific_selection(e,e2)
% ==============================================
%%   
% ===============================================
baustell=...
{...
   '[cs-pos]   "cs"-column: select positive values only '
   '[cs-neg]   "cs"-column: select negative values only '
   '[invert]   "cs"-column: invert selection' 
    }

% ==============================================
%%   
% ===============================================



function hidecolumns(e,e2)
ht=findobj(0,'tag','plotconnections');
u=get(ht,'userdata');
if isfield(u,'ColumnWidth_bk')==0
    u.ColumnWidth_bk=u.t.ColumnWidth;
    set(ht,'userdata',u)
end
% ==============================================
%%   
% ===============================================

colnames=u.t.ColumnName;
icolumns_mandatory=[1:4  15:16 ];
colnames(icolumns_mandatory)=cellfun(@(a){['<html><b><font color=red>' (a)]} ,colnames(icolumns_mandatory));

tb=[num2cell(logical(cell2mat(u.t.ColumnWidth')~=0)) colnames]; %show is "1"
tbh={'show' 'Column-Name'};
out=uitable_checklist(tb,tbh,'title','show/hide Columns',...
    'tooltip',['<html><b>   show/hide table-columns:  </b><br>' ...
    '   [_] hide column <br> '... 
    '   [x] show column <br>' ...' char(10) ...
    '<b><font color=red>red: mandatory columns</html>']);
if isempty(out); return; end
% ==============================================
%%   
% ===============================================
c=cell2mat(out(:,1));
ihide=find(c==0);
ishow=find(c==1);
c0=cell2mat(tb(:,1));
u.t.ColumnWidth(ihide)={0};
ishow=find(c0==0 & c==1);
if ~isempty(ishow)
%     keyboard
%     w1=cell2mat(u.t.ColumnWidth(:));
    w0=cell2mat(u.ColumnWidth_bk(:));
%     [c c0 w0 w1]
    u.t.ColumnWidth(ishow)=num2cell(w0(ishow));
end



function list=makeColorList(maps)
maps(strcmp(maps,'user'))=[];
% maps={'jet' ,'hot' 'summer' 'gray' 'parula' 'cool' 'winter'}
list=repmat({''},[length(maps) 1]);
Nspaces=2;%size(char(maps),1)+3;
for j=1:length(maps)
    cmapname=maps{j};
    map=sub_intensimg('getcolor',cmapname);
    %eval(['map=' cmapname ';']);
    ilin=round(linspace(1,size(map,1),7));
    map=map(ilin,:);
    map=round(map*255);
    maphex=repmat({''},[size(map,1) 1]);
    for i=1:size(map,1)
        maphex{i,1}=reshape(dec2hex(map(i,:), 2)',1, 6);
    end
    
    v1=cellfun(@(a){[ '<span style="font-size: 30%;color:' '#' a ';font-weight:bold">&#9632;</span>']} ,maphex);
%     ts=['<span style="font-size: 100%;color:black;font-weight:bold">' cmapname '</span>'];
    v1=cellfun(@(a){['<FONT color=#' a ' >&#9632;' ]} ,maphex);
     ts=[ '<FONT color=black>'  repmat('&nbsp;', [1 1]) cmapname];
   % ts=[ '<FONT color=black>'  repmat('&nbsp;', [1 Nspaces-length(cmapname)]) cmapname];
    v2=['<html> '   strjoin(v1,'') ts];
    list{j,1}=v2;
end














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
if isfield(u.lab,'abbreviate')          ==0;   u.lab.abbreviate=0             ; end
if isfield(u.lab,'abbreviationLength')  ==0;   u.lab.abbreviationLength=3     ; end

if isfield(u.lab,'useNumbers')  ==0;            u.lab.useNumbers=1     ; end


set(hf,'userdata',u);

function labelprop(e,e2)
hf=findobj(0,'tag','plotconnections');
u=get(hf,'userdata');


% ==============================================
%%   GUI
% ===============================================

prompt = {'fontsize (numeric)',        'font color [R,G,B]'...
    'Horizontal Alignment: (1)left,(2)center,(3)right' ...
    'needle visible: [0]no,[1]yes' 'needle length' ,'needle color  [R,G,B]',...
    'abbreviate labels: [0]no,[1]yes' 'abbreviation lenght (number of letters per word)',...
    'use Numbers & List: [0]labels; [1] Numbers&List'};

dlg_title = 'label properties';
num_lines = 1;
defaultans = {...
    num2str(u.lab.fs), ...
    num2str(u.lab.fcol), ....
    num2str(u.lab.fhorzal), ...
    num2str(u.lab.needlevisible), ...
    num2str(u.lab.needlelength),...
    num2str(u.lab.needlecol),...
    num2str(u.lab.abbreviate),...
    num2str(u.lab.abbreviationLength),...
    num2str(u.lab.useNumbers),...
    };
answer = inputdlg(prompt,dlg_title,num_lines,defaultans);
if isempty(answer); return; end
u.lab.fs            =str2num(answer{1});
u.lab.fcol          =str2num(answer{2});
u.lab.fhorzal       =str2num(answer{3});
u.lab.needlevisible =str2num(answer{4});
u.lab.needlelength  =str2num(answer{5});
u.lab.needlecol     =str2num(answer{6});
u.lab.abbreviate    =str2num(answer{7});
u.lab.abbreviationLength    =str2num(answer{8});
u.lab.useNumbers    =str2num(answer{9});

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

hc=findobj(ht,'tag','colorlimits');
colorlimits=str2num(get(hc,'string'));

if length(colorlimits)~=2
    colorlimits=[];
else
 colorlimits=sort(colorlimits);   
end
hc=findobj(ht,'tag','linkcolormap');
va=get(hc,'value');  li=get(hc,'string');
cmapStr=(li{va});
% cmap=regexprep(cmapStr,{'&nbsp;&nbsp;.*' '<html>' '<FONT.*' '\s*'},'')
cmap=regexprep(cmapStr,{'.*&nbsp;' '\s*'},'');
cmap=sub_intensimg('getcolor',cmap);
if get(findobj(ht,'tag','linkintensity'),'value')==1 % LINK inteinsity
    intens=str2num(char(d(:,regexpi2(cname,'cs'))));
 
    
    intens2=intens;
    if ~isempty(colorlimits)
        intens2=[intens; sort(colorlimits(:))];
        intens2(intens2<colorlimits(1))=colorlimits(1);
        intens2(intens2>colorlimits(2))=colorlimits(2);
    end
    %set not-checkd links to lower value
    icolCheck=find(strcmp(cname,'cs'))-1;
    minval=min(intens2(find(cell2mat(d(:,icolCheck))==1)));
    if isempty(minval); minval=0;end
    intens2(find(cell2mat(d(:,icolCheck))==0))=minval;
   
    
    
    intens4colorbar=intens2;
    intens2=intens2-min(intens2);
    intens2=round((intens2./max(intens2))*(size(cmap,1)-1)+1);
    
    if sum(isnan(intens2))==length(intens2) % dummy in case of no selection
        intens2(:)=double(5); %dummy
    end
    
    intens3=cmap(intens2,:);
    
    
    
    
    
    if ~isempty(colorlimits)
        intens3(end-1:end,:)=[];
    end
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
useLabelNumbers=u.lab.useNumbers;

if useLabelNumbers==1
   labelcount=1; 
   labellist={};
end

% ==============================================
%%   list
% ===============================================

labelall  =unique([d(:,2); d(:,4)]);


selected=[d(:,1:2); d(:,3:4)];

if 0
    labellist0=labelall;
    if u.lab.abbreviate==1
        for i=1:size(labellist0,1);
            v=labelall{i};
            v=cellfun(@(a){[ a repmat(' ',[1 30])]} ,strsplit(regexprep(v,{'_'},{' '}),' '));
            v= regexprep(cellfun(@(a){[ a(1:u.lab.abbreviationLength) ]} ,v),' ','');
            v=strjoin(v,' ');
            labellist0{i,1}=v;
        end
    end
    labelall=labellist0;
    
    labellist3=cellfun(@(a,b){[ sprintf('%2d',a) ') ' b ]} ,...
        num2cell([1:length(labelall)]'),labellist0);
    
    
    
    selected=[d(:,1:2); d(:,3:4)];
    selected=selected(find(cell2mat(selected(:,1))),:);
    iselect=find(ismember(labelall,selected(:,2)));
    noselect=setdiff(1:length(labelall), iselect);
    %find selection
    
    % labellist3(noselect)=cellfun(@(a){['  '  a ]} ,labellist3(noselect));
    % labellist3(iselect )=cellfun(@(a){['* '  a ]} ,labellist3(iselect));
    
    labellist4=labellist3;
    labellist4(iselect )=cellfun(@(a){['<html><b>'  a ]} ,labellist4(iselect)); %long
    labellist3=labellist3(iselect );%short
end
% ==============================================
%%   
% ===============================================


labeluniqueList={};
labellist      ={};
labellisthandle=[];
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
        if plotlabel==1% LABEL
            df=c1-ce;
            dfn=df./(sqrt(sum(df.^2)));
            ct=c1+dfn*(u.lab.needlelength)    ;%
            cn=c1+dfn*(u.lab.needlelength+2)  ;%
            %-------abbreviat label-------------
            v=d{i,regexpi2(cname,'label1')};
            %ID=find(strcmp(labelall,v));
            if u.lab.abbreviate==1
                v=cellfun(@(a){[ a repmat(' ',[1 30])]} ,strsplit(regexprep(v,{'_'},{' '}),' '));
                v= regexprep(cellfun(@(a){[ a(1:u.lab.abbreviationLength) ]} ,v),' ','');
                v=strjoin(v,' ');
            end
            thisLabel=v;
            %-----use LABELNUMBERS------------------------------
%             if useLabelNumbers==1
%                 labellist(labelcount,:)={labelcount  v};
%                 v =num2str(labelcount);
%                 labelcount=labelcount+1;
%                 %disp(labellist);
%             end
            if isempty(find(strcmp(labeluniqueList,thisLabel)))
                %disp(thisLabel);
                te=text(cn(:,1),cn(:,2),cn(:,3), v,'fontsize',u.lab.fs,'Color',u.lab.fcol);
                set(te,'userdata',['nodetxt' num2str(i) 'a'],'HorizontalAlignment',labelhorzal{u.lab.fhorzal});
                set(te,'tag','connectionlabel');
                labeluniqueList{end+1,1} =thisLabel;
                labellist{end+1,1}       =v;
                labellisthandle(end+1,1) =te;
            end
            %--------nEEDLE
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
        if plotlabel==1% LABEL
            df=c2-ce;
            dfn=df./(sqrt(sum(df.^2)));
            ct=c2+dfn*(u.lab.needlelength)    ;%
            cn=c2+dfn*(u.lab.needlelength+2)  ;%
            %-------abbreviat label-------------
             v=d{i,regexpi2(cname,'label2')};
             %ID=find(strcmp(labelall,v));
            if u.lab.abbreviate==1
                v=cellfun(@(a){[ a repmat(' ',[1 30])]} ,strsplit(regexprep(v,{'_'},{' '}),' '));
                v= regexprep(cellfun(@(a){[ a(1:u.lab.abbreviationLength) ]} ,v),' ','');
                v=strjoin(v,' ');
            end
            thisLabel=v;
            %-----use LABELNUMBERS------------------------------
%             if useLabelNumbers==1
%                 labellist(labelcount,:)={labelcount  v};
%                 v =num2str(labelcount);
%                 labelcount=labelcount+1;
%                 %disp(labellist);
%             end
            %-----------------------------------
            if isempty(find(strcmp(labeluniqueList,thisLabel)))
                %disp(thisLabel);
                te=text(cn(:,1),cn(:,2),cn(:,3), v,'fontsize',u.lab.fs,'Color',u.lab.fcol);
                set(te,'userdata',['nodetxt' num2str(i) 'b'],'HorizontalAlignment',labelhorzal{u.lab.fhorzal});
                set(te,'tag','connectionlabel');
                labeluniqueList{end+1,1} =thisLabel;
                labellist{end+1,1}       =v;
                labellisthandle(end+1,1) =te;
            end
            %-------------NEEDLE
            if u.lab.needlevisible==1
                hp=plot3([c2(1) ct(1)],[c2(2) ct(2)],[c2(3) ct(3)],'k','color',u.lab.needlecol);
                set(hp,'userdata',['needletxt' num2str(i) 'b']); 
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
%-----use LABELNUMBERS------------------------------
if 0
    delete(findobj(hf,'tag','labellistbox'));
    delete(findobj(hf,'tag','listmove'));
    delete(findobj(hf,'tag','listresize'));
    delete(findobj(hf,'tag','listclose'));
end

% ==============================================
%%   % reassign labels
% ===============================================
labelall  =unique([d(:,2); d(:,4)]);
labellist0=labelall;
if u.lab.abbreviate==1
    for i=1:size(labellist0,1);
        v=labelall{i};
        v=cellfun(@(a){[ a repmat(' ',[1 30])]} ,strsplit(regexprep(v,{'_'},{' '}),' '));
        v= regexprep(cellfun(@(a){[ a(1:u.lab.abbreviationLength) ]} ,v),' ','');
        v=strjoin(v,' ');
        labellist0{i,1}=v;
    end
end
labelall=labellist0;

 
for i=1:length(labellisthandle)
    if useLabelNumbers==1
        ID=find(strcmp(labelall,labeluniqueList{i}));
        set(labellisthandle(i),'string', num2str(ID)  );
        %labellist3{ID,1}= ['*' labellist3{ID,1}];
    else
        set(labellisthandle(i),'string',labellist{i});
    end
end

% ==============================================
%%   ID AND LIST
% ===============================================
labelall2  =unique([d(:,2); d(:,4)]);
origlist=[d(:,1:2); d(:,3:4)];
selectstatus=zeros(size(labelall2));
for i=1:size(labelall2,1)
   selectstatus(i)= max(cell2mat(origlist(find(strcmp(origlist(:,2),labelall2{i})),1)));
end
iselect=find(selectstatus);


lblist0=cellfun(@(a,b){[ sprintf('%2d',a) ') ' b ]} ,...
    num2cell([1:length(labelall)]'),labelall);

listlong=lblist0;
listlong(iselect )=cellfun(@(a){['<html><b>'  a ]} ,listlong(iselect)); %long
listshort=lblist0(iselect );%short



if plotlabel==0
    delete(findobj(hf,'tag','labellistbox'));
    delete(findobj(hf,'tag','listmove'));
    delete(findobj(hf,'tag','listresize'));
    delete(findobj(hf,'tag','listclose'));
    
end

if useLabelNumbers==1 && ~isempty(listlong) && plotlabel==1
    poslb=[.76 .03 .25 .8];
    hb=findobj(hf,'tag','labellistbox');
    recreate=0;
    if isempty(hb)
        recreate=1;
        hb=uicontrol('style','listbox','units','norm','string',listlong);
        set(hb,'position',poslb,'fontsize',6,'tag','labellistbox');
        set(hb,'KeyPressFcn',@key_labellist);
        
        delete(findobj(gcf,'tag','changeList'));
        % ==============================================
        %% contextMenue
        % ===============================================
        
        cmenu = uicontextmenu;
        item1= uimenu(cmenu, 'Label','[ ] short-list type','Callback', {@listMenu, 'changeList'},'tag','changeList');
        item1= uimenu(cmenu, 'Label','show list in extra window','Callback', {@listMenu, 'exportList'},'tag','exportList');
        
        item1= uimenu(cmenu, 'Label',['<html><h1>INFO<pre><h2><font color="green"> **** SHORTCUTS ***'...
            ' <br> [-/+]  ... change font size  '...
            ' <br> [c]    ... change font color  '...
            ' <br> [shift]+[arrowKey]    ... shift axes position'...
            ],'separator','on');
        set(hb,'UIContextMenu',cmenu);
        % ==============================================
        %%
        % ===============================================

        set(hb,'callback',@listcallback);
    end
  
    u.listlong =listlong;
    u.listshort=listshort;
    set(hb,'userdata',u,'backgroundcolor',[get(hf,'color')]);%,'string',labellist4);
    curList=get(findobj(gcf,'tag','changeList'),'Label');
    if strcmp(curList(2),' ')
       set(hb,'value',1,'string',u.listlong); 
    else
       set(hb,'value',1,'string',u.listshort ); 
    end
    
    if recreate==1;
        figure(hf);
    % RESIZE LIST
     hv=uicontrol('parent',hf, 'style','push','units','norm','string','<>');
     set(hv,'position',poslb,'fontsize',6,'tag','listresize',...
         'TooltipString','resize list');
     set(hv,'units','pixels');
     posx=get(hv,'position');
     set(hv,'position',[posx(1) posx(2)-12 12 12]);
     set(hv,'units','norm');
     hmove = findjobj(hv);
     
     %MOVE LIST
     hv=uicontrol('parent',hf,'style','push','units','norm','string','<html>&#9769;');
     set(hv,'position',poslb,'fontsize',6,'tag','listmove',...
         'TooltipString','move list');
     set(hv,'units','pixels');
     pos=get(hv,'position');
     %set(hv,'position',[pos(1:2) 12 12]);
     posx=get(hv,'position');
     set(hv,'position',[posx(1)+12 posx(2)-12 12 12]);
     set(hv,'units','norm');
     hdrag = findjobj(hv);
     
     
     
     %CLOSE LIST
    hv=uicontrol('parent',hf,'style','push','units','norm','string','x');
     set(hv,'position',[poslb(1) poslb(2)+poslb(4) poslb(3:4)],'fontsize',6,'tag','listclose',...
         'TooltipString','close list');
     set(hv,'units','pixels');
     %posx=get(hv,'position');
     %set(hv,'position',[posx(1) posx(2) 12 12]);
     set(hv,'position',[posx(1)+12*4 posx(2)-12 12 12]);
     set(hv,'units','norm','callback',@listClose);
     
%      hv=uicontrol('style','push','units','norm','string','F+');
%      set(hv,'position',[.75 .1 .05 .05],'fontsize',6,'tag','listFontsizeIncrease',...
%          'TooltipString','decrease list fonssize');
%      set(hv,'units','pixels');
%      posx=get(hv,'position');
%      set(hv,'position',[posx(1)+36 posx(2)-12 12 12]);
%      set(hv,'units','norm');
     
     
     downTags={'listresize' 'listmove' 'listclose' };%'listFontsizeIncrease'
     %upTags={'listmove'};
     %upTags={'listclose'};
     upTags={};
     set(hmove,'MouseDraggedCallback',{@resize_object,'listresize',{'labellistbox'},downTags,upTags }   );
     
     set(hdrag,'MouseDraggedCallback',{@drag_object,'listmove',{'labellistbox','listresize',...
          'listclose' } }); %'listFontsizeIncrease'
    end

end
% ----------------------------------------

%% colorbar
hcbar=findobj(hf,'tag','cbarintens');
cbarpos=[];
if isempty(hcbar)==0
  cbarpos=get(hcbar,'position') ; 
end
delete(hcbar);
delete(findobj(hf,'tag','axintens'));
% delete(findobj(hf,'tag','cbarmoveBtn'));
if get(findobj(ht,'tag','linkintensity'),'value')==1 % LINK inteinsity
    ha=axes('position',[.9 .85 .01 .1]);
    %set(hs,'position',[.9 .85 .01 .1]);
    imagesc(intens4colorbar);
    colormap(cmap);
    hc=colorbar;
    if exist('colorlimits')==1 && length(colorlimits)==2
        caxis(colorlimits);
        set(hc,'ticks',colorlimits,'TickLabels',cellstr(num2str(colorlimits')))
    end
    
   % hg=uicontrol('style','pushbutton','units','norm','backgroundcolor','r');
%     set(hg,'position',[.9-.01 .85-.01 .01+.02 .1+.02],'tag','cbarmoveBtn');
    
    set(hc,'position',[.9 .85 .01 .1],'YAxisLocation','right','fontsize',7,'tag','cbarintens');
    if ~isempty(cbarpos)
       set(hc,'position',[cbarpos]) ;
    end
    set(ha,'position',[1 1 .0001 .0001],'tag','axintens');
    %set(ha,'position',[.9 .85 .01 .1],'tag','axintens');
    
% ----------callback
     hcbar=findobj(hf,'tag','cbarintens');
     set(hcbar,'ButtonDownFcn',@cbarintens_cb);

    
    axes(findobj(hf,'tag','ax0'));
    
    
end


function cbarintens_cb(e,e2)


% ==============================================
%%   
% ===============================================
hf=findobj(0,'tag','xvol3d');
% get(hf,'SelectionType')
% return

delete(findobj(hf,'tag','btnmove'));
delete(findobj(hf,'tag','btndelete'));



hc=findobj(hf,'tag','cbarintens');
pos=get(hc,'position');
Bsize=12;
%-----move
hv=uicontrol('parent',hf,'style','push','units','norm','string','<html>&#9769;');
set(hv,'position',pos,'fontsize',6,'tag','btnmove',...
    'TooltipString','drag me');
set(hv,'units','pixels');
posx=get(hv,'position');
pos2=[posx(1)+posx(3)/2-Bsize posx(2)+posx(4)/2 Bsize Bsize];
set(hv,'position',pos2,'backgroundcolor',[1 1         0]);
set(hv,'units','norm');
hdrag = findjobj(hv);
set(hv,'units','norm');
set(hdrag,'MouseDraggedCallback',{@drag_object,'btnmove',{'btndelete' 'cbarintens' } }); %'listFontsizeIncrease'

% --------close------
hv=uicontrol('parent',hf,'style','push','units','norm','string','<html>&#9746;');
set(hv,'position',pos,'fontsize',6,'tag','btndelete',...
    'TooltipString','close dragging option');
set(hv,'units','pixels');
set(hv,'position',[pos2(1)+Bsize pos2(2:end)],'backgroundcolor',[1 1         0]);
set(hv,'units','norm','callback',{@cbarintens_task,'delete'});
set(hv,'units','norm');
function cbarintens_task(e,e2,task)
hf=findobj(0,'tag','xvol3d');
if strcmp(task, 'delete')
    delete(findobj(hf,'tag','btnmove'));
    delete(findobj(hf,'tag','btndelete'));
end



% ==============================================
%%   
% ===============================================


function listcallback(e,e2)

li=get(e,'string');
va=get(e,'value');
s=li{va};
idstr=num2str(str2num(regexprep(strtok(s,')'),'\D','')));

hf=findobj(0,'tag','xvol3d');
hc=findobj(hf,'tag','connectionlabel');
hc=hc(find(strcmp(get(hc,'string'),idstr)));
% ==============================================
%%   
% ===============================================

set(hc,'backgroundcolor',[1 1 0]);
pause(.1)
set(hc,'backgroundcolor','none');
% ==============================================
%%   
% ===============================================


function listMenu(e,e2,task)
if strcmp(task,'changeList')
    hc=findobj(gcf,'tag','changeList');
    hb=findobj(gcf,'tag','labellistbox');
    u=get(hb,'userdata');
    hc=hc(1);
    if strcmp(hc.Label(2),' ')
        hc.Label(2)='x';
        set(hb,'value',1,'string',u.listshort);
    else
        hc.Label(2)=' ';
        set(hb,'value',1,'string',u.listlong);
    end
elseif strcmp(task,'exportList')
     hb=findobj(gcf,'tag','labellistbox');
     uhelp(regexprep(get(hb,'string'),'<html>','<html><pre>'),1,'name','labels');
end

function key_labellist(e,e2)
%  e2
 
if isempty(e2.Modifier)
     if strcmp(e2.Character, '+')
         set(e,'fontsize',  get(e,'fontsize')+1);
     elseif strcmp(e2.Character, '-')
         try; set(e,'fontsize',  get(e,'fontsize')-1); end
     elseif strcmp(e2.Character, 'c')
         col=uisetcolor(get(e,'foregroundcolor'),'select LIST font color');
         try; set(e,'foregroundcolor',col); end
     end
 elseif  strcmp(e2.Modifier, 'shift')
     if strcmp(e2.Key, 'leftarrow')
         ax=findobj(gcf,'tag','ax0');
         pos=get(ax,'position');
         set(ax,'position',[pos(1)-0.05 pos(2:4)]);
     elseif strcmp(e2.Key, 'rightarrow')
         ax=findobj(gcf,'tag','ax0');
         pos=get(ax,'position');
         set(ax,'position',[pos(1)+0.05 pos(2:4)]);
         
     elseif strcmp(e2.Key, 'uparrow')
         ax=findobj(gcf,'tag','ax0');
         pos=get(ax,'position');
         set(ax,'position',[pos(1) pos(2)+0.05 pos(3:4)]);
     elseif strcmp(e2.Key, 'downarrow')
         ax=findobj(gcf,'tag','ax0');
         pos=get(ax,'position');
         set(ax,'position',[pos(1) pos(2)-0.05 pos(3:4)]);
     end
   elseif  strcmp(e2.Modifier, 'control') 
       hf=findobj(0,'tag','xvol3d');
       ht=findobj(0,'tag','plotconnections');
       hc=findobj(hf,'tag','connectionlabel');
       u=get(ht,'userdata');
       if strcmp(e2.Character, '+')
         
           u.lab.fs=u.lab.fs+1;
           set(hc,'fontsize',  u.lab.fs);
           set(ht,'userdata',u);
       elseif strcmp(e2.Character, '-')
           u.lab.fs=u.lab.fs-1;
           try
               set(hc,'fontsize',  u.lab.fs);
               set(ht,'userdata',u);
           end

      end
 end

function listClose(e,e2)
hf=findobj(0,'tag','xvol3d');
delete(findobj(hf,'tag','labellistbox'));
delete(findobj(hf,'tag','listmove'));
delete(findobj(hf,'tag','listresize'));
delete(findobj(hf,'tag','listclose'));

function resize_object(e,e2,tag,dotag,downTags,upTags)
dotag=cellstr(dotag);
hv=findobj(gcf,'tag',dotag{1});
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
% if xx<0; xx=0; end
% if xx>(posF(3)-pos(3)); xx=posF(3)-pos(3); end
% yy=mp(2)-posF(2);
% if yy<0; yy=0; end
% if yy>(posF(4)-pos(4)); yy=(posF(4)-pos(4)); end
% disp('-....');

xs=pos(1)-xx;
ys=pos(2)-yy;
posn=[ xx yy pos(3)+xs pos(4)+ys];
if posn(3)<0; posn(3)=3; end
if posn(4)<0; posn(4)=3; end
set(hv,'position',posn);
set(hv ,'units'  ,units_hv);
set(gcf,'units'  ,units_fig);
set(0  ,'units'  ,units_0);
% df=[pos(1)-xx pos(2)-yy];

% --------------downTags----------------
downTags=cellstr(downTags);
for i=1:length(downTags)
    hv=findobj(gcf,'tag',downTags{i});
    hv=hv(1);
    units_hv =get(hv ,'units');      set(hv  ,'units','pixels');
    pos2=get(hv,'position');
    set(hv,'position',[  pos2(1)-xs  pos2(2)-ys   pos2(3:4)]);
    set(hv  ,'units',units_hv);
end
% --------------upTags----------------
upTags=cellstr(upTags);
for i=1:length(upTags)
    hv=findobj(gcf,'tag',upTags{i});
    hv=hv(1);
    units_hv =get(hv ,'units');      set(hv  ,'units','pixels');
    pos2=get(hv,'position');
    set(hv,'position',[  pos2(1)-xs  pos2(2)   pos2(3:4)]);
    set(hv  ,'units',units_hv);
end

function drag_object(e,e2,tag,othertags)
% tag='cbarmoveBtn'
hv=findobj(gcf,'tag',tag);
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
if xx<0; xx=0; end
if xx>(posF(3)-pos(3)); xx=posF(3)-pos(3); end
yy=mp(2)-posF(2);
if yy<0; yy=0; end
if yy>(posF(4)-pos(4)); yy=(posF(4)-pos(4)); end
set(hv,'position',[ xx yy pos(3:4)]);

set(hv ,'units'  ,units_hv);
set(gcf,'units'  ,units_fig);
set(0  ,'units'  ,units_0);
df=[pos(1)-xx pos(2)-yy];
% -----------------------------
if exist('othertags')==1
    othertags=cellstr(othertags);
    for i=1:length(othertags)
        hv=findobj(gcf,'tag',othertags{i});
%         try; hv=hv(1); end
        units_hv =get(hv ,'units');
        set(hv  ,'units','pixels');
        
        pos =get(hv,'position');
        pos2=[ pos(1)-df(1) pos(2)-df(2) pos(3:4)];
      set(hv,'position',pos2);
        set(hv ,'units'  ,units_hv);
    end 
end



% set(hf,'WindowButtonMotionFcn',@motion)
% 
% function motion(e,e2)
% % 'ri'
% hd=hittest();
% tag=get(hd,'tag');
% if strcmp(tag,'cbarintens')
%     'w'
%     get(gcf,'SelectionType')
% %     cmd=get(gcf,'windowbuttondownfcn');
% %     set(gcf,'windowbuttondownfcn', 'disp(get(gcf,''selectiontype''));')
% %     set(gcf,'windowbuttondownfcn',cmd);
% end

function selectAll(e,e2)
ht=findobj(0,'tag','plotconnections');
is_selectAll=get(findobj(ht,'tag','selectAll'),'value');
u=get(ht,'userdata');
d    =u.t.Data; 
head=u.t.ColumnName;
icolCheck=find(strcmp(head,'x'));
d(:,icolCheck)={logical(is_selectAll)};
u.t.Data=d;
set(ht,'userdata',u);

set(findobj(ht,'tag','alllinks'),'value', is_selectAll);
set(findobj(ht,'tag','allnodes'),'value', is_selectAll);


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

ht=findobj(0,'tag','plotconnections');
is_instantUpdate=get(findobj(gcf,'tag','instantUpdate'),'value');
is_selectRow=get(findobj(gcf,'tag','selectRow'),'value');
if is_selectRow==1 %select row
    ic=e2.Indices;
    u=get(ht,'userdata');
    d=u.t.Data;
    head=u.t.ColumnName;
    useval=d(ic(1),ic(2));
    irow=find(strcmp(head,'x'));
    d(ic(1),irow)=useval;%{logical(useval)}
    set(u.t,'data',d);
    % set(u.t,'data',dx);
    % conplot([],[]);
end

if is_instantUpdate==0
    return
end

ic=e2.Indices;
if ic(2)==13 ||  ic(2)==14 % convert mm to index if selected
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




