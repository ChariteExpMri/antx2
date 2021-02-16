% #wg PURPOSE
% #k DISPLAY THRESHOLDED/SIGNIFICANT CONNECTIONS
% #m Hover over image to see the connection (statist. score, p-value) below mouse pointer
% #m Hover over colorcoded region to obtain the region name
%
% #wg CONTROLS 
% [contrast]: select contrast...in most cases there is only one available
% [threshold type]: select the threshold
%   'all'   : plot all connections
%   'thresh': plot connections with p-values below threshold
%   'FDR'   : plot significant FDR-coorected connections only
% [threshold]: set the threshold value, p-value below threshold will be displayed
%       -[threshold type] must be set to 'thresh'
% [sorting] - defines how to sort the connections
%      -y-axis remain fix, x-axis is the resorted axis
%     'origin'      : no sorting...use original sorting
%     'p-values'    : sort connections after p-value 
%     'statValue'   : sort connections after statistical-value (such as T-values..sign-sensitive)
%     'statValue<0' : display only negative statistical-values (negative T-values)
%     'statValue>0' : display only positive statistical-values (positive T-values)
% #b [update]  #n  -Update button to update changes/replot
% [?]              -get some help
% #b [label]   #n  -display region labels
%               -use +/-key to change fontsize
%               -use left/right arrow key to rotate of x-axis labels 
%               -use drag-icon (hand) to move axis such that region label fit onto figure
% #b [show table] #n -display statistical table of 'survived' connections
% [colorlimits] : lower and upper colorlimits --> same value but different signs [-x +x]
% [colormap]    : set colormap
% [drag icon]   : move/resize axis  
%                  -use context menu of [drag icon] to change drag-icon-to-axis-distance
%
% #wg Shortcuts 
%  [m]    toggle menubar on/off
%  [+/-]         change region x/y-label fontsize
%  [control +/-] change connection label fontsize
%  [left/right arrow] rotate x-axis labels 
 


function dti_plotmatrix(us)
warning off;
% --------------------
% load('work1.mat');
% sx.atlas='F:\data3\jeehye_DTI\DTI_20201013\DTI_atlas_31mar20\DTI_harms31mar20.xlsx';
sx.atlas=us.atlas;

%------------------
sx.inv1='INPUT1----------------';
sx.pwnumber   =1     ;  % pw-number
sx.threshtype =1     ;  %threshold 1,2,3
sx.thresh     =0.05  ;  %p-value threshold   

cmap=getcolormap('list');
sx.cmap=cmap{1};

sx.label_fs     =8;  %FONTSIZE x/ylabel
sx.hoverlabel_fs=8; %FONTSIZE hover-label
sx.dragicongap=1;  %gap-sice between dragicon and axes (in fraction of icondragButtonsize)
sx.labelmode  =1 ;  % [1]show all labels [2] show survived lables
sx.xTickLabelRotation=30 ;%rotation of xlabels

sx.fs_statscore=6; % Fontsize statistical score
sx.us=us;
% --------------------
sx.sortopt={...
    'origin'
    'p-values'
    'statValue'
    'statValue<0'
    'statValue>0'
    };
sx.sorttype=1;

sx.ax1pos=[0.2200    0.0750    0.7750    0.8150];
sx.wid=.025;
sx.gap=0.005;
% sx.ax2pos=get(ax2,'position');
% sx.ax3pos=get(ax3,'position');
%-------------------
prepimage(sx);
prepdata();




function prepdata()
sx=get(gcf,'userdata');
sx.inv2='INPUT2----variableINPUT------------';
% ==============================================
%%   get atlas
% ===============================================
[~,~,at]=xlsread(sx.atlas);
at(strcmp(cellfun(@(a){[ num2str(a)]} , at(:,1) ),'NaN'),:)=[];
hat=at(1,:);
at=at(2:end,:);

% ==============================================
%%   
% ===============================================
us=sx.us;
threshtype =sx.threshtype; %threshold (1)all (2)p<0.05 (3)FDR
r          =us.pw(sx.pwnumber);
val        =r.tb(:,3);
sorttype   =sx.sorttype;

si=us.con.size;
s=zeros(prod(si),1);
cblabel=[r.tbhead{3} 'value'];

if sx.sorttype==4   %value xx<0  
    val(find(val>0))=0;
end
if sx.sorttype==5   %value xx>0  
    val(find(val<0))=0;
end


if threshtype==1
    ms=[r.stattype '(' r.tbhead{3} ') uncorrectd (matrix-size: ' num2str(si(1)) 'x' num2str(si(1))  ')'];
elseif threshtype==2
    %val=val.*(r.tb(:,2)<.05);
    %length(find(r.tb(:,2)<0.001))
    val=val.*(r.tb(:,2)<sx.thresh);
    ms=[r.stattype '(' r.tbhead{3} ') using p<0.05   (n=' num2str(sum(val~=0)) '/' num2str(numel(val)) ')'];
elseif threshtype==3
    val=val.*r.fdr;
    ms=[r.stattype '(' r.tbhead{3} ') FDRcorrected   (n=' num2str(sum(val~=0)) '/' num2str(numel(val))  ')'];
end
if length(us.con.index)==length(val)
    s(us.con.index)=val;
else
    si=us.con.size;
    s=zeros(prod(si),1);
    %----------------------
    %si=size(ac);
    tria=triu(ones(si));
    tria(tria==1)=nan;
    tria(tria==0)=1;
    ind       =find(tria(:)==1); %index in 2d-Data
    
    vz=zeros(size(ind));
    vz(r.ikeep)=val;
    s(ind)=vz;    
end
s=reshape(s,[si]);
s(isnan(s))=0;

pval=zeros(prod(si),1);

if length(us.con.index)==length(r.tb(:,2))
    pval(us.con.index)=r.tb(:,2);
else
    zv=zeros(size(us.con.index));
    zv(r.ikeep)=r.tb(:,2);
    pval(us.con.index)=zv;
    
end
pval       =reshape(pval,[si]);
labelmatrix=us.con.labelmatrix;

% ===========================================================================
if 1 %REDUCE MATRIX
    if 1%k==1  %reduce matrix
        % [ix iy]=find(pval~=0)
        ix=find(sum(abs(s),1)==0);
        iy=find(sum(abs(s),2)==0);
        
        ix=intersect(ix,iy);
        iy=ix;
    end
    
    pdum=pval;
    pdum(iy,:)=[];
    pdum(: ,ix)=[];
    pval=pdum;
    
    sdum=s;
    sdum(iy,:)=[];
    sdum(: ,ix)=[];
    s=sdum;
    
    dum=labelmatrix;
    dum(iy,:) =[];
    dum(: ,ix)=[];
    labelmatrix=dum;
    
end


% ==============================================
%%   
% ===============================================
if isempty(s)
    msgbox({'no conections left!' 'change threshold/threshold-Type'});
    return
end

% ==============================================
%%   
% ===============================================
isort1=1:size(s,1);
isort2=1:size(s,1);
tria=~triu(ones(size(s)));
wd=double(tria); wd(wd==0)=nan;

if sx.sorttype==2
    wd=pval;
    wd(wd==0)=nan;
    [tes,isort1]=sort(nanmax(wd,[],1)); %sort(nansum(~isnan(wd),1));
    wd           =wd(         :,isort1);
elseif sx.sorttype==3
    wd=s;
    wd(wd==0)=nan;
    [tes,isort1]=sort(nanmax(wd,[],1));
    wd           =wd(         :,isort1);
 elseif sx.sorttype==4   
    'a'
  
end

s            =s(          :,isort1);
pval         =pval(       :,isort1);
labelmatrix  =labelmatrix(:,isort1);
% tria=~isnan(wd);
tria=(~isnan(wd)).*(s~=0);
% ==============================================
%%   
% ===============================================
sx.s          =s;
sx.pval       =pval;
sx.labelmatrix=labelmatrix;
sx.tria=tria;


la1=regexprep(labelmatrix(:,1),'--.*','');
la2=regexprep(labelmatrix(1,:),'.*--','');
atl=at(:,1);

iv1=zeros(size(la1,1),1);
iv2=iv1;
for i=1:length(la1)
   iv1(i,1)= find(strcmp(atl,la1(i)));
   iv2(i,1)= find(strcmp(atl,la2(i)));
end
atcolor2  =str2num(char(at(iv1,3)))./255; %atlascolor
atcolor1  =str2num(char(at(iv2,3)))./255; %atlascolor
atcol1    =(permute(atcolor1,[3 1 2] )); %into 3d
atcol2    =(permute(atcolor2,[1 3 2] )); %into 3d

sx.atcol1 =atcolor1;
sx.atcol2 =atcolor2;
sx.la1    =la1; 
sx.la2    =la2; 

is     =find(val~=0);
sx.tb  = [r.lab(is)  num2cell(r.tb(is,:))];
sx.htb = ['connection' r.tbhead ];

disp(['Number of connections: ' num2str(length(is))]);

% ==============================================
%%   update figure
% ===============================================
hf=findobj(0,'tag','dtifig1');
ax1=findobj(hf,'tag','ax1');
axes(ax1);
him=imagesc(s);
% eval(['cmap=' sx.cmap ';']);
cmap=getcolormap(sx.cmap);
iwhite=round(size(cmap,1)/2)+1;
cmap(iwhite,:)=[1 1 1];
colormap(cmap);
cb=colorbar;
set(cb,'position',[.82 .1 .03 .1]);
% set(cb,'position',[.01 .3 .01 .3]);
set(cb,'position',[.07 .05 .01 .3]);
set(cb,'fontsize',8,'fontweight','bold');

ylabel(cb, cblabel);
clim=[-max(abs(s(:))) max(abs(s(:)))];
caxis(clim);
set(ax1,'xticklabels','','yticklabels',''   ,'tag','ax1' );

set(findobj(gcf,'tag','clim'),'string',[ num2str(clim(1)) ' '  num2str(clim(2))]);





% ===========HORIZ========================================================================================
ax1_pos=get(ax1,'position');
ax2=findobj(gcf,'tag','ax2'); axes(ax2);
wid=.025;
gap=0.005;
set(ax2,'position',  [ ax1_pos(1)   ax1_pos(2)-wid-gap     ax1_pos(3)   wid ]);
him2=image(ax2,atcol1);
set(get(him2,'parent'),'tag','ax2');

set(ax2,'units','pixels');
pos2n=get(ax2,'position');
set(ax2,'units','norm');
% ===========VERT ========================================================================================
ax1_pos=get(ax1,'position');
ax3=findobj(gcf,'tag','ax3'); axes(ax3);
wid=.025;
gap=0.005;
set(ax3,'position',  [ ax1_pos(1)-wid-gap   ax1_pos(2)   wid  ax1_pos(4)    ]);
him3=image(ax3,atcol2);
set(get(him3,'parent'),'tag','ax3');

set(ax3,'units','pixels'); % bug with different widths
pos3n=get(ax3,'position');
pos3nup=[pos3n(1)+pos3n(3)-pos2n(4) pos3n(2)  pos2n(4)  pos3n(4)  ];
set(ax3,'position',pos3nup);
set(ax3,'units','norm');

% =========== glob ========================================================================================
set([ax2,ax3],'fontsize',8);
set(ax2,'yticklabels','');set(ax3,'xticklabels','');
linkaxes([ax1 ax2 ],'x');
linkaxes([ax1 ax3 ],'y');
axes(ax1);
set(gcf,'userdata',sx);
set(gcf,'WindowButtonMotionFcn',{@motion,'1'});

dragbtn_ini();
show_statvalue();


function show_statvalue(e,e2)
try; waitspin(1,'..wait...'); end
sx=get(gcf,'userdata');
hf=findobj(0,'tag','dtifig1');
ax1=findobj(hf,'tag','ax1');
axes(ax1);
% txt-Test-statistic
if get(findobj(hf,'tag','show_statvalue'),'value') ==1
    ht=[];
    for i=1:size(sx.s,1)
        for j=1:size(sx.s,2)
            if sx.s(i,j)~=0
                ht(end+1,1)=text(j,i, sprintf('%2.2f',sx.s(i,j)));
            end
        end
    end
    set(ht,'fontsize',sx.fs_statscore,'fontweight','bold','tag','statvalue','HorizontalAlignment','center',...
        'color','w');
else
   delete(findobj(hf,'tag','statvalue')); 
end
drawnow; try; waitspin(0,'..wait...'); end







function motion_atlascolor(para)

po=get(gca,'CurrentPoint');
po=(po(1,[1 2]));
hf=findobj(0,'tag','dtifig1');
sx=get(hf,'userdata');

te=findobj(gcf,'tag','txt1');
if isempty(te)
    te=uicontrol('style','pushbutton','units','norm');
    set(te,'position',[.25 .9 .75 .1],'backgroundcolor','w','tag','txt1',...
        'fontsize',sx.hoverlabel_fs,'foregroundcolor','w',...
        'tooltipstring',['use [ctrl]&[+/-]keys to change fontsize' ]);
    c = uicontextmenu;
    m1 = uimenu(c,'Label','change fontsize','Callback',{@context_hoverlabel,'fontsize'});
    te.UIContextMenu = c;
    
end
try
    if para==1
        ind=round(po(1));
        lab=sx.la2{ind};
        col=sx.atcol1(ind,:);
        direct='COLUMN (vertical)';
    elseif para==2
        ind=round(po(2));
        lab=sx.la1{ind};
        col=sx.atcol2(ind,:);
        direct='ROW (horizontal)';
    end
    msg2=['<html>' ...% '<b>' lab  '</b>' ...  %'<span style="bgcolor:red"> text</span>' ... % ['<h6 style="background-color: brown; color: bisque;">bla' '</h6>'] ...
        ['<br>' ' <FONT color=blue>'  direct] ...
        '<br>' ...
        '<BODY bgcolor=' sprintf('%02X',round(col*255)) '>' '<FONT color=black' '>' lab ...
        ];  
     set(te,'string',msg2);
catch
    set(te,'string',''); 
end


function motion(e,e2,para)
hunderpointer=hittest(gcf);
% get(hunderpointer,'tag');
hands={get(hunderpointer,'tag') get(get(hunderpointer,'parent'),'tag') };
% hands
% return

if ~isempty(regexpi2(hands,'ax2')) ;%strcmp(get(gca,'tag'),'ax2')
    axes(findobj(gcf,'tag','ax2'));
    motion_atlascolor(1);
    return
elseif ~isempty(regexpi2(hands,'ax3')) ;%strcmp(get(gca,'tag'),'ax3')
    axes(findobj(gcf,'tag','ax3'));
    motion_atlascolor(2);
    return
elseif ~isempty(regexpi2(hands,'ax1')) ;%strcmp(get(gca,'tag'),'ax1')
    axes(findobj(gcf,'tag','ax1'));
else
   return
end


ax1=findobj(gcf,'tag','ax1');
axes(ax1);
po=get(gca,'CurrentPoint');
po=round(po(1,[1 2]));
hf=findobj(0,'tag','dtifig1');
sx=get(hf,'userdata');
if min(po)<1 || max(po)>size(sx.s,1)
    title(' ');
    return
end

val  =num2str( sx.s(           po(2),po(1)));
pval =num2str( sx.pval(        po(2),po(1)));
labx =         sx.labelmatrix( po(2),po(1));

lab1=sx.la1{po(2)} ;
lab2=sx.la2{po(1)} ;
col2=sx.atcol1(po(1),:);
col1=sx.atcol2(po(2),:);


% ==============================================
%%   
% ===============================================
te=findobj(gcf,'tag','txt1');
if sx.tria(po(2),po(1))==0
    try;        set(te,'string',''); end
    return
end


tresh=0.85;
if col1(2)<tresh;     fgcol1='white';    else ;    fgcol1='black'; end
if col2(2)<tresh;     fgcol2='white';    else ;    fgcol2='black'; end


msg2=['<html>' '<b>' labx{1}  '</b>' ...  %'<span style="bgcolor:red"> text</span>' ... % ['<h6 style="background-color: brown; color: bisque;">bla' '</h6>'] ...
    ['<br>' 'STAT-score: '  '<FONT color=red>'  val '<FONT color=black>'  ' p-value: '  '  <FONT color=blue>'  pval] ...
     '<br>' ...
     '<BODY bgcolor=' sprintf('%02X',round(col1*255)) '>' '<FONT color=' fgcol1 '' '>	&nbsp;' lab1 '	&nbsp;' ...
     '<BODY bgcolor=' sprintf('%02X',round([1 1 1]*255)) '>' '<FONT color=black' '>' '--' ...
     '<BODY bgcolor=' sprintf('%02X',round(col2*255)) '>' '<FONT color=' fgcol2 '' '>   &nbsp;' lab2 '	&nbsp;' ...
     ];
% set(te,'string',msg2)
% ==============================================
%%   
% ===============================================
if isempty(te)
    axes(ax1);
%     te=text(0,.5,msg,'fontsize',6,'tag','txt1','interpreter','tex');
%     set(te,'position',[0 -(size(sx.s,1).*.05)]);
    te=uicontrol('style','pushbutton','units','norm');
    set(te,'position',[.25 .9 .75 .1],'backgroundcolor','w','foregroundcolor','k','tag','txt1');
else
    %set(te,'string',msg);
end
set(te,'string',msg2,'foregroundcolor','k');
% title([[sx.la{po(1)} ' ## '  sx.la{po(2)}]]  ,'fontsize',8);




% [sx.la{po(1)} ' ## '  sx.la{po(2)}]

function prepimage(sx)
% ==============================================
%%   
% ===============================================

delete(findobj(0,'tag','dtifig1'));
fg
set(gcf,'units','norm','NumberTitle','off','name',['dtifig (' mfilename '.m)']);
set(gcf,'WindowKeyPressFcn',@keys);
him=imagesc(1);
ax1=get(him,'parent');
set(gca,'position',sx.ax1pos );%[0.22    0.075    0.7750    0.8150]);
set(ax1,'xticklabels','','yticklabels',''   ,'tag','ax1' );
% ===========HORIZ ========================================================================================
ax1_pos=get(ax1,'position');
ax2=axes('position', [0 0 .5 .1 ]);
% sx.wid=.025;
% sx.gap=0.005
set(ax2,'position',  [ ax1_pos(1)   ax1_pos(2)-sx.wid-sx.gap     ax1_pos(3)   sx.wid ]);
set(ax2,'tag','ax2');

% ===========VERT ========================================================================================
ax1_pos=get(ax1,'position');
ax3=axes('position', [0 0 .5 .1 ]);
% wid=.025;
% gap=0.005
set(ax3,'position',  [ ax1_pos(1)-sx.wid-sx.gap   ax1_pos(2)   sx.wid  ax1_pos(4)    ]);
set(ax3,'tag','ax3');
set([ax2,ax3],'fontsize',8);
set(ax2,'yticklabels','');set(ax3,'xticklabels','');


% sx.ax1pos=get(ax1,'position');
% sx.ax2pos=get(ax2,'position');
% sx.ax3pos=get(ax3,'position');

set(gcf,'userdata',sx);
set(gcf,'tag','dtifig1','userdata',sx);

% ==============================================
%%   CONTROLS
% ===============================================
%% contrast
pws=cellfun(@(a){[ num2str(a)]} ,num2cell(1:length(sx.us.pw)) );
hb=uicontrol('style','popupmenu','units','norm', 'string', pws);
set(hb,'position',[0.0125 0.95357 0.10714 0.047619],'tag','contrast');
set(hb,'tooltipstring',['set contrast' char(10) 'if there are several contrasts...select contrast here']...
    ,'callback',@set_contrast);
%% contrastname
hb=uicontrol('style','text','units','norm', 'string', sx.us.pw(1).str);
set(hb,'position',[0.11964 0.94405 0.10714 0.047619],'tag','contrast_str');
set(hb,'tooltipstring',['contrast name'],'backgroundcolor',[1.0000  0.8431 0],'fontweight','bold');


%% THRESHTYPE
hb=uicontrol('style','popupmenu','units','norm', 'string', {'all' , 'thresh', 'FDR'});
set(hb,'position',[0.0125 0.91071 0.10714 0.047619],'tag','threshtype');
set(hb,'tooltipstring',['threshold Type' char(10) ' all: show all connections ' char(10) ... 
    ' thresh: show connections with p-values below defined threshold' char(10) ...
    ' FDR: show only FDR-corrected connections']...
    ,'callback',@set_threshtype);

%% THRESHOLD
hb=uicontrol('style','edit','units','norm', 'string', num2str(sx.thresh));
set(hb,'position',[0.11786 0.92024 0.10714 0.035],'tag','thresh');
set(hb,'tooltipstring',['enter the p-value threshold' 'only values below threshold will be displayed'],...
    'callback',@set_thresh,'enable','off');


%% UPDATE
hb=uicontrol('style','push','units','norm', 'string', 'update');
set(hb,'position',[0.0053571 0.66548 0.10714 0.035],'tag','update');
set(hb,'tooltipstring',['update plot' char(10) 'This will update the plot'],...
    'callback',@update,'backgroundcolor',[0 .7 0]);


%% showLabel
hb=uicontrol('style','radio','units','norm', 'string', 'Label');
set(hb,'position',[0.0053571 0.61071 0.10714 0.035],'tag','set_showlabel');
set(hb,'tooltipstring',['show RegionLabels' char(10) 'use +/- keys to change fontsize'],...
    'callback',@set_showlabel,'backgroundcolor',[1 1 1]);
c = uicontextmenu;
hb.UIContextMenu = c;
m1 = uimenu(c,'Label','change label mode','Callback',{@showLabel_context,'labelmode'});
hb.UIContextMenu = c;

%% show statistical Value
hb=uicontrol('style','radio','units','norm', 'string', 'stat.Value');
set(hb,'position',[0.0053574 0.575 0.12714 0.035],'tag','show_statvalue');
set(hb,'tooltipstring',['show statistical value' char(10) ... 
    'use [alt] & [+/-] keys to change fontsize of statistical Value'
    ],...
    'callback',@show_statvalue,...
    'backgroundcolor',[1 1 1]);




%% showTable
hb=uicontrol('style','push','units','norm', 'string', 'show Table');
set(hb,'position',[0.0071429 0.43929 0.10714 0.035],'tag','showtable');
set(hb,'tooltipstring','show Table','callback',@showtable,'backgroundcolor',[1 1 1]);


%% colormap
cmaps=getcolormap('list');
hb=uicontrol('style','popupmenu','units','norm', 'string', cmaps);
set(hb,'position',[0.0017857 -0.0035714 0.13 0.047619],'tag','cmap');
set(hb,'tooltipstring','define the colormap','callback',@set_cmap);

%% colorLimuts
hb=uicontrol('style','edit','units','norm', 'string', '-nan nan');
set(hb,'position',[[0.0035714 0.37024 0.13714 0.035]],'tag','clim');
set(hb,'callback',@set_clim);
set(hb,'tooltipstring',['manual colorlimits' char(10) ' enter a negative and positive value']);

%% sortoption
hb=uicontrol('style','popupmenu','units','norm', 'string', sx.sortopt);
set(hb,'position',[0.010714 0.85357 0.10714 0.047619],'tag','sorttype');
set(hb,'tooltipstring',['sorting Type:' char(10) 'how to sort the data' char(10) ' (y-axis stays fixed)'],...
    'callback',@set_sorttype);


%% HELP
hb=uicontrol('style','push','units','norm', 'string', '?');
set(hb,'position',[0.11786 0.66548 0.035 0.035],'tag','help');
set(hb,'tooltipstring',[ 'get some help'],...
    'callback',@get_help,'backgroundcolor',[1 1 .6]);

function get_help(e,e2)
uhelp([mfilename '.m']);

function set_sorttype(e,e2)
sorttype=get(findobj(gcf,'tag','sorttype'),'value');
sx=get(gcf,'userdata');
sx.sorttype=sorttype;
set(gcf,'userdata',sx);


function set_contrast(e,e2)
num=get(findobj(gcf,'tag','contrast'),'value');
sx=get(gcf,'userdata');
contrastname=sx.us.pw(num).str;
set(findobj(gcf,'tag','contrast_str'),'string',contrastname,'fontweight','bold','fontsize',8);
sx.pwnumber=num;
set(gcf,'userdata',sx);

function set_clim(e,e2)
sx=get(gcf,'userdata');
axes(findobj(gcf,'tag','ax1'));
clim =str2num(get(findobj(gcf,'tag','clim'),'string'));
caxis([clim]);


function set_cmap(e,e2)
sx=get(gcf,'userdata');
hb=findobj(gcf,'tag','cmap');
li = get(hb,'string');  va = get(hb,'value');
sx.cmap=li{va};
set(gcf,'userdata',sx);
prepdata();


function set_threshtype(e,e2)
sx=get(gcf,'userdata');
sx.threshtype = get(findobj(gcf,'tag','threshtype'),'value');
set(gcf,'userdata',sx);
if sx.threshtype==2
    set(findobj(0,'tag','thresh'),'enable','on');
else
    set(findobj(0,'tag','thresh'),'enable','off');
end

function set_thresh(e,e2)
sx=get(gcf,'userdata');
sx.thresh = str2num(get(findobj(gcf,'tag','thresh'),'string'));
set(gcf,'userdata',sx);

function showtable(e,e2)
sx=get(gcf,'userdata');
try;
    uhelp( plog([],[  sx.htb;sx.tb] ),1);
end


function update(e,e2)
prepdata();

function set_showlabel(e,e2)
e=findobj(gcf,'tag','set_showlabel');
sx=get(gcf,'userdata');
ax1=findobj(gcf,'tag','ax1');
ax2=findobj(gcf,'tag','ax2');
ax3=findobj(gcf,'tag','ax3');

if get(e,'value')==0
    ax1_pos=sx.ax1pos;
    set(ax1,'position',sx.ax1pos);
    set(ax2,'position',  [ ax1_pos(1)   ax1_pos(2)-sx.wid-sx.gap     ax1_pos(3)   sx.wid ]);
    set(ax3,'position',  [ ax1_pos(1)-sx.wid-sx.gap   ax1_pos(2)   sx.wid  ax1_pos(4)    ]);
    set(ax2,'xtick',[]); set(ax3,'ytick',[]);
    set([ax2 ax3],'fontsize',sx.label_fs);
else
    ax1_pos=get(ax1,'position');
    ax1_pos=[.5 .5 .5 .4];
     set(ax1,'position',ax1_pos)
    set(ax2,'position',  [ ax1_pos(1)   ax1_pos(2)-sx.wid-sx.gap     ax1_pos(3)   sx.wid ]);
    set(ax3,'position',  [ ax1_pos(1)-sx.wid-sx.gap   ax1_pos(2)   sx.wid  ax1_pos(4)    ]);

    if sx.labelmode==1
        set(ax2,'xtick',[1:length(sx.la2)],'xticklabels',strrep(sx.la2,'_',' '));
        set(ax3,'ytick',[1:length(sx.la1)],'yticklabels',strrep(sx.la1,'_',' '));
        %set(ax3,'yTickLabelRotation',30);
    elseif sx.labelmode==2
        iver=find(sum(sx.s,2));
        ihor=find(sum(sx.s,1));
        set(ax2,'xtick',[ihor],'xticklabels',strrep(sx.la2(ihor),'_',' '));
        set(ax3,'ytick',[iver],'yticklabels',strrep(sx.la1(iver),'_',' '));
    end
   
   set(ax2,'xTickLabelRotation',sx.xTickLabelRotation);
   set([ax2 ax3],'fontsize',sx.label_fs);
end
dragbtn_ini();


function cmap=getcolormap(cmapname)

if strcmp(cmapname,'list')==1
    cmap={'bluewhitered' 'parula','jet'  'hot'};
    return
end

if strcmp(cmapname,'bluewhitered')==1
    cmap=[0 0 0.5;0 0.032258064516129 0.532258064516129;0 0.0645161290322581 0.564516129032258;0 0.0967741935483871 0.596774193548387;0 0.129032258064516 0.629032258064516;0 0.161290322580645 0.661290322580645;0 0.193548387096774 0.693548387096774;0 0.225806451612903 0.725806451612903;0 0.258064516129032 0.758064516129032;0 0.290322580645161 0.790322580645161;0 0.32258064516129 0.82258064516129;0 0.354838709677419 0.854838709677419;0 0.387096774193548 0.887096774193548;0 0.419354838709677 0.919354838709677;0 0.451612903225806 0.951612903225806;0 0.483870967741936 0.983870967741936;0.032258064516129 0.516129032258065 1;0.096774193548387 0.548387096774194 1;0.161290322580645 0.580645161290323 1;0.225806451612903 0.612903225806452 1;0.290322580645161 0.645161290322581 1;0.354838709677419 0.67741935483871 1;0.419354838709677 0.709677419354839 1;0.483870967741936 0.741935483870968 1;0.548387096774194 0.774193548387097 1;0.612903225806452 0.806451612903226 1;0.67741935483871 0.838709677419355 1;0.741935483870968 0.870967741935484 1;0.806451612903226 0.903225806451613 1;0.870967741935484 0.935483870967742 1;0.935483870967742 0.967741935483871 1;1 1 1;1 1 1;1 0.935483870967742 0.935483870967742;1 0.870967741935484 0.870967741935484;1 0.806451612903226 0.806451612903226;1 0.741935483870968 0.741935483870968;1 0.67741935483871 0.67741935483871;1 0.612903225806452 0.612903225806452;1 0.548387096774194 0.548387096774194;1 0.483870967741936 0.483870967741936;1 0.419354838709677 0.419354838709677;1 0.354838709677419 0.354838709677419;1 0.290322580645161 0.290322580645161;1 0.225806451612903 0.225806451612903;1 0.161290322580645 0.161290322580645;1 0.0967741935483871 0.0967741935483871;1 0.032258064516129 0.032258064516129;0.983870967741936 0 0;0.951612903225806 0 0;0.919354838709677 0 0;0.887096774193548 0 0;0.854838709677419 0 0;0.82258064516129 0 0;0.790322580645161 0 0;0.758064516129032 0 0;0.725806451612903 0 0;0.693548387096774 0 0;0.661290322580645 0 0;0.629032258064516 0 0;0.596774193548387 0 0;0.564516129032258 0 0;0.532258064516129 0 0;0.5 0 0];
else
    eval(['cmap=' cmapname ';']);
end

function keys(e,e2)
% e2
ua=hittest(gcf);
tagunderMouse=get(ua,'tag');

 sx=get(gcf,'userdata');
ax2=findobj(gcf,'tag','ax2');
ax3=findobj(gcf,'tag','ax3');
% e2

if ~isempty(e2.Modifier)
    if ~isempty(regexpi2(e2.Modifier,'control')) % control ---------------------
        if strcmp(e2.Character,'+')                % TITLE
            sx.hoverlabel_fs=sx.hoverlabel_fs+1;
            set(gcf,'userdata',sx);
            set(findobj(gcf,'tag','txt1'), 'fontsize',sx.hoverlabel_fs);
            return
        elseif strcmp(e2.Character,'-')
            sx.hoverlabel_fs=sx.hoverlabel_fs-1;
            if sx.hoverlabel_fs<=1; return; end
            set(gcf,'userdata',sx);
            set(findobj(gcf,'tag','txt1'), 'fontsize',sx.hoverlabel_fs);
            return
        end
    end
    if ~isempty(regexpi2(e2.Modifier,'alt')) % alt ---------------------
        if strcmp(e2.Character,'+')                   %STATISTICAL VALUE
            h=findobj(gcf,'tag','statvalue');
            if isempty(h); return; end
            sx.fs_statscore=sx.fs_statscore+1;
            set(gcf,'userdata',sx);
            set(h, 'fontsize',sx.fs_statscore);
            return
        elseif strcmp(e2.Character,'-')
            h=findobj(gcf,'tag','statvalue');
            if isempty(h); return; end
            sx.fs_statscore=sx.fs_statscore-1;
            if sx.fs_statscore<1; return; end
            set(gcf,'userdata',sx);
            set(h, 'fontsize',sx.fs_statscore);
            return
        end
    end
end

% NO MODIFIER------------------------------------------
if strcmp(e2.Character,'+')
    %     if strcmp(tagunderMouse,'txt1')
    %         sx.hoverlabel_fs=sx.hoverlabel_fs+1;
    %         set(gcf,'userdata',sx);
    %         set(findobj(gcf,'tag','txt1'), 'fontsize',sx.hoverlabel_fs);
    %
    %     else
    sx.label_fs=get(ax2,'fontsize')+1;
    set([ax2,ax3],'fontsize',sx.label_fs );
    set(gcf,'userdata',sx);
    %     end
elseif strcmp(e2.Character,'-')
    %     if strcmp(tagunderMouse,'txt1')
    %         sx.hoverlabel_fs=sx.hoverlabel_fs-1;
    %         if sx.hoverlabel_fs<=1; return; end
    %         set(gcf,'userdata',sx);
    %         set(findobj(gcf,'tag','txt1'), 'fontsize',sx.hoverlabel_fs);
    %     else
    sx.label_fs=get(ax2,'fontsize')-1;
    if sx.label_fs<1; return; end
    set([ax2,ax3],'fontsize',sx.label_fs );
    set(gcf,'userdata',sx);
    %     end
elseif strcmp(e2.Key,'leftarrow')
    sx.xTickLabelRotation=sx.xTickLabelRotation-2;
    set(gcf,'userdata',sx);
    ax2=findobj(gcf,'tag','ax2');
    set(ax2,'xTickLabelRotation',sx.xTickLabelRotation);
elseif strcmp(e2.Key,'rightarrow')
    sx.xTickLabelRotation=sx.xTickLabelRotation+2;
    set(gcf,'userdata',sx);
    ax2=findobj(gcf,'tag','ax2');
    set(ax2,'xTickLabelRotation',sx.xTickLabelRotation);
elseif strcmp(e2.Key,'m')
    if strcmp(get(gcf,'menubar'),'figure')
        set(gcf,'menubar','none');
    else
        set(gcf,'menubar','figure');
    end
end




function dragbtn_ini(e,e2)
sx=get(gcf,'userdata');

%% dragg
handicon=[...
    129	129	129	129	129	129	129	0	0	129	129	129	129	129	129	129
    129	129	129	0	0	129	0	215	215	0	0	0	129	129	129	129
    129	129	0	215	215	0	0	215	215	0	215	215	0	129	129	129
    129	129	0	215	215	0	0	215	215	0	215	215	0	129	0	129
    129	129	129	0	215	215	0	215	215	0	215	215	0	0	215	0
    129	129	129	0	215	215	0	215	215	0	215	215	0	215	215	0
    129	0	0	129	0	215	215	215	215	215	215	215	0	215	215	0
    0	215	215	0	0	215	215	215	215	215	215	215	215	215	215	0
    0	215	215	215	0	215	215	215	215	215	215	215	215	215	0	129
    129	0	215	215	215	215	215	215	215	215	215	215	215	215	0	129
    129	129	0	215	215	215	215	215	215	215	215	215	215	215	0	129
    129	129	0	215	215	215	215	215	215	215	215	215	215	0	129	129
    129	129	129	0	215	215	215	215	215	215	215	215	215	0	129	129
    129	129	129	129	0	215	215	215	215	215	215	215	0	129	129	129
    129	129	129	129	129	0	215	215	215	215	215	215	0	129	129	129
    129	129	129	129	129	0	215	215	215	215	215	215	0	129	129	129];

% handicon=[[255 255 255 255 255 255 255 182 182 255 255 255 255 255 255 255;255 255 255 255 255 255 197 34 34 197 255 255 255 255 255 255;255 255 255 255 255 213 78 161 161 78 213 255 255 255 255 255;255 255 255 255 255 152 238 171 171 238 153 255 255 255 255 255;255 255 255 255 255 255 255 171 171 255 255 255 255 255 255 255;255 255 213 152 255 255 255 171 171 255 255 255 152 213 255 255;255 197 78 238 255 255 255 171 171 255 255 255 238 78 197 255;182 34 161 170 170 170 170 114 114 170 170 170 170 161 34 182;183 34 162 171 171 171 171 114 114 171 171 171 171 162 34 183;255 198 78 238 255 255 255 171 171 255 255 255 238 77 198 255;255 255 214 153 255 255 255 171 171 255 255 255 153 214 255 255;255 255 255 255 255 255 255 171 171 255 255 255 255 255 255 255;255 255 255 255 255 152 238 171 171 238 152 255 255 255 255 255;255 255 255 255 255 214 78 161 161 78 214 255 255 255 255 255;255 255 255 255 255 255 198 34 34 198 255 255 255 255 255 255;255 255 255 255 255 255 255 183 183 255 255 255 255 255 255 255]];

handicon(handicon==handicon(1,1))=255;
% handicon=round(imresize(handicon,[10 10],'method','bilinear'));
if size(handicon,3)==1; handicon=repmat(handicon,[1 1 3]); end
handicon=double(handicon)/255;

delete(findobj(gcf,'tag','drag'));
h33=uicontrol('style','pushbutton','cdata',handicon,'backgroundcolor','w');
set(h33,'backgroundcolor','w');%,'callback',@slid_thresh)
set(h33,'units','pixels','position',[100 100 16 16]);
set(h33,'units','norm')

ax2=findobj(gcf,'tag','ax2');
axpos2=get(ax2,'position');

ax3=findobj(gcf,'tag','ax3');
axpos3=get(ax3,'position');

poshand=get(h33,'position');
set(h33,'position',[axpos2(1)-poshand(3)-poshand(3)*sx.dragicongap  ...
    axpos3(2)-poshand(4)-poshand(4)*sx.dragicongap poshand(3:4)]);
set(h33,'string','','tooltipstring','drag hand icon to resize axes','tag','drag');
je = findjobj(h33); % hTable is the handle to the uitable object
set(je,'MouseDraggedCallback',@drag_icon  );

c = uicontextmenu;
h33.UIContextMenu = c;
m1 = uimenu(c,'Label','dragIcon: distance to axes','Callback',{@dragIcon_context,'distance'});
v.hdrag.UIContextMenu = c;

function drag_icon(e,e2)

sx=get(gcf,'userdata');
hf1=findobj(0,'tag','dtifig1');
hp=findobj(hf1,'tag','drag');


hh=findobj(hf1,'tag','ROI_drag');
cp=get(gcf,'CurrentPoint');
% cp
pos=get(hp,'position');
% [ coFig(1) coFig(2)  pos(3:4)  ]
posn=[ cp(1) cp(2)  pos(3:4)  ];
set(hp,'position',posn);

try
    
    ax1=findobj(gcf,'tag','ax1'); %axes1 main
    axpos1=get(ax1,'position');
    axpos11=[  posn(1)+posn(3)+sx.dragicongap*posn(3) ...
        posn(2)+posn(4)+sx.dragicongap*posn(4) ...
        sx.ax1pos(3)+sx.ax1pos(1)-(posn(1)+2*posn(3)) ...
        sx.ax1pos(4)+sx.ax1pos(2)-(posn(2)+2*posn(4))];
    ap1=set(ax1,'position',axpos11 );
    
    ax2=findobj(gcf,'tag','ax2'); %axes2
    axpos2=get(ax2,'position');
    set(ax2,'position', [  ...
        posn(1)+posn(3)+sx.dragicongap*posn(3) ...
        axpos2(2)+axpos11(2)-axpos1(2) ...
        sx.ax1pos(3)+sx.ax1pos(1)-(posn(1)+2*posn(3)) ...
        axpos2(4)]);
    
    ax3=findobj(gcf,'tag','ax3'); %axes3
    axpos3=get(ax3,'position');
    set(ax3,'position', [  ...
        axpos3(1)+axpos11(1)-axpos1(1) ...
        posn(2)+posn(4)+sx.dragicongap*posn(4)...
        axpos3(3)...
        sx.ax1pos(4)+sx.ax1pos(2)-(posn(2)+2*posn(4)) ...
        ]);
end
 

return
v=get(hp,'userdata');
% drag icon
pos=get(hh,'position');
posdrag=[ coFig(1:2)  pos(3:4) ];
set(hh,'position', posdrag);
posdiff=posdrag-pos;
posrot  =get(v.hs,'position');  set(v.hs  ,'position',posrot+posdiff );
posclear=get(v.hcl,'position'); set(v.hcl ,'position',posclear+posdiff );

function dragIcon_context(e,e2,task)
% task
sx=get(gcf,'userdata');
if strcmp(task,'distance')
    x = inputdlg(['Enter distance between "drag"-icon to axes  (examples below):' ...
        char(10) '1: distance is  length of drag-icon' ...
        char(10) '0.5: distance is  1/2 length of drag-icon' ...
        char(10) '2: distance is 2x length of drag-icon' ...
        ],'',1,{num2str(sx.dragicongap)});
    sx.dragicongap=str2num(x{1});
    set(gcf,'userdata',sx);
    dragbtn_ini(e,e2);
end
function showLabel_context(e,e2,task)
% {@showLabel_context,'labelmode'});
sx=get(gcf,'userdata');
if strcmp(task,'labelmode')
    x = inputdlg(['change label mode:' ...
        char(10) '1: show all labels' ...
        char(10) '2: show labels of survived connections only' ...
        ],'',1,{num2str(sx.labelmode)});
    sx.labelmode=str2num(x{1});
    set(gcf,'userdata',sx);
 set_showlabel();
end
function context_hoverlabel(e,e2,task)
sx=get(gcf,'userdata');
if strcmp(task,'fontsize')
    x = inputdlg(['Change fontsize. Enter fontsize' ...
        char(10) '' ...
        ],'',1,{num2str(sx.hoverlabel_fs)});
    sx.hoverlabel_fs=str2num(x{1});
    set(gcf,'userdata',sx);
 set(findobj(gcf,'tag','txt1'), 'fontsize',sx.hoverlabel_fs);
end

