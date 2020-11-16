
% ==============================================
%%  searchfun 
% ===============================================

function fun_search(hfig,hc,c,colidx, position,callback )

if 0
    us=get(gcf,'userdata');
    fun_search(gcf,us.hc([1 4]),us.c(:,[1 4]),1, [0.25 .5 .5 .3],@cb_finder );
    
end

% ==============================================
%%   inputs
% ===============================================

if isempty(hfig); hfig=gcf; end
uv.header      =hc;
uv.data        =c;

if exist('colidx') && ~isempty(colidx); 
    uv.searchcolumn=colidx;
else
   uv.searchcolumn=1; 
end
if exist('position') && length(position)==4
    poslist=position;
else
   poslist=[0.25 .5 .5 .3];
end
if exist('colidx') && ~isempty(colidx); 
uv.callback=callback;
else
   uv.callback=[]; 
end



% ==============================================
%%   
% ===============================================

if 0
    % pbexitsearch;
    hfig=gcf;%findobj(0,'tag','selector');
    us=get(hfig,'userdata');
    
    
    findercolumn=1
    header      =us.hc;
    data        =us.c;
    
    data=cellfun(@(a){[ num2str(a)  ]} , data );
    poslist=[0.25 .5 .5 .3];
    
    
    % uv.header      =us.header(2:end);
    % uv.header  =us.hc;
    % if isfield(us,'findercolumn')==0
    %     us.findercolumn=findercolumn;
    %     set(hfig,'userdata',us);
    % end
    
    
    
    uv.searchcolumn=findercolumn;
    uv.header      =header;
    uv.data        =data;
end


% list = regexprep( us.raw(:,uv.searchcolumn), {'<.*?>','&nbsp;'}, '' );
list={''};


figure(hfig);
hig=.04;
% pos=[0.25 .8 .5 hig];

%  poslist=[0.25 .5 .5 .3];

% poslist=[0.1 .1 .8 .5];



pos=[poslist(1) poslist(2)+poslist(4) poslist(3) hig];

% ==============================================
%%   
% ===============================================

% columnWid=.3;
%% column-selection
hpd=uicontrol('style','popupmenu','units','norm','position',   pos,'tag', 'pdcolumnsearch');
set(hpd,'position',[pos(1) pos(2)+hig pos(4)*5 pos(4)  ],'string',uv.header,'value',uv.searchcolumn);
set(hpd,'tooltipstr','column to search','callback', {@changecolumnpulldown} );
%% prev
hpb=uicontrol('style','pushbutton','units','norm','position',   pos,'tag', 'pbcolumnprevsearch');
set(hpb,'position',[pos(1)+pos(4)*5 pos(2)+hig hig hig  ],'string','<', 'callback', {@changecolumn,-1} );
set(hpb,'tooltipstr','prev. column');
%% next
hpb=uicontrol('style','pushbutton','units','norm','position',   pos,'tag', 'pbcolumnnextsearch');
set(hpb,'position',[pos(1)+pos(4)*5+hig  pos(2)+hig   hig hig ],'string','>', 'callback', {@changecolumn,-1} );
set(hpb,'tooltipstr','next. column');

%% EDIT
hs=uicontrol('style','edit','units','norm','position',   pos,'tag', 'edsearch');
%% LISTBOX
hl=uicontrol('style','listbox','units','norm','position',poslist,'tag', 'lbsearch');
set(hl,'string',list)
set(hl,'callback',@lbselectthis);

%% pb resize
hg=uicontrol('style','pushbutton','units','norm',...
    'position',[pos(1)+pos(3)-hig  pos(2)-.3 hig hig],...
    'tag', 'pbresize','tooltipstr','..','string','..');
set(hg,'fontsize',8,'fontweight','bold');%,'callback', @pbresize);
j2 = findjobj(hg); % hTable is the handle to the uitable object
set(j2,'MouseDraggedCallback',@resize  );
v=uint8(geticon('resize'));
v(v==v(1,1))=255;
if size(v,3)==1; v=repmat(v,[1 1 3]); end
v=double(v)/255;
set(hg,'cdata',v);

%% pb EXACT MATCH
he=uicontrol('style','togglebutton','units','norm',...
    'position',[pos(1)  pos(2)-.3 .04 hig],'string','EM',...%'fontsize',8,...
    'tag', 'toggleexactsearch','tooltipstr','[0] find string [1] find exact match','value',0);
% ida=fullfile(matlabroot, 'toolbox\matlab\icons\zoom.mat');  ida=load(ida);
% set(he, 'CData',ida.zoomCData);
set(he,'position',[pos(1)  pos(2) .04 hig] ,'callback' ,@cb_exaxtmatch);
z.col=[  0.7569    0.8667    0.7765;   0.9294    0.6941    0.1255];
z.str={'f' 'fEx'};
set(he,'userdata', z );
set(he,'backgroundcolor',z.col(1,:), 'string',z.str(1))

%% pb search
he=uicontrol('style','pushbutton','units','norm',...
    'position',[pos(1)+.038  pos(2) .04 hig],...
    'tag', 'pbsearch','tooltipstr','search','callback',@pbsearch);
ida=fullfile(matlabroot, 'toolbox','matlab','icons','zoom.mat');  ida=load(ida);
set(he, 'CData',ida.zoomCData);



%% pb clear
he=uicontrol('style','pushbutton','units','norm',...
    'position',[pos(1)+pos(3)-2*.03  pos(2) .03*2 hig-.0005],...
    'tag', 'pbclearsearch','tooltipstr','clear field','string','clr');
set(he,'fontsize',8,'fontweight','bold','callback', @pbclearsearch);

%% movepanel
v=uint8(geticon('hand'));
v(v==v(1,1))=255;
if size(v,3)==1; v=repmat(v,[1 1 3]); end
v=double(v)/255;
hp=uicontrol('style','pushbutton','units','norm','position',   pos,'tag', 'pbmovepan');
set(hp,'position',[pos(1)+pos(3)-2*hig  pos(2)+hig hig hig],'string','',...
    'CData',v,'tooltipstr',['shift panel position' char(10) 'left mouseclick+move mouse/trackpad pointer position' ]);%, 'callback', {@changecolumn,-1} );
set(hp,'position',[pos(1)+pos(3)-hig  pos(2)+hig hig hig]);

je = findjobj(hp); % hTable is the handle to the uitable object
set(je,'MouseDraggedCallback',{@motio,1}  );


%% exit finder
he=uicontrol('style','pushbutton','units','norm',...
    'position',[pos(1)+pos(3)-hig  pos(2)+hig hig hig],...
    'tag', 'pbexitsearch','tooltipstr','exit find window','string','x','fontsize',7);
set(he,'fontsize',10,'fontweight','bold','callback', @pbexitsearch);
set(he,'position',[pos(1) pos(2)+2*hig hig hig  ]);


uv.controls=[...
    findobj(gcf,'tag','edsearch')
    findobj(gcf,'tag','lbsearch')
    findobj(gcf,'tag','pbsearch')
    findobj(gcf,'tag','pbclearsearch')
    findobj(gcf,'tag','pbexitsearch')
    findobj(gcf,'tag','toggleexactsearch')
    findobj(gcf,'tag','pdcolumnsearch')
    findobj(gcf,'tag','pbcolumnprevsearch')
    findobj(gcf,'tag','pbcolumnnextsearch')
    findobj(gcf,'tag','pbmovepan')
    findobj(gcf,'tag','pbresize')
    ];


% 'pbmovepan'


set(uv.controls,'units','pixels');


hj=findjobj(hs);
uv.hj=hj;
set(hs,'KeyPressFcn',@keyedit);
uv.str=[];
uv.list=list;
uv.fig2=hfig;
set(hs,'userdata',uv);
updatecolumnlist;
uicontrol(findobj(gcf,'tag','edsearch'));

function resize(e,e2)
uv=get(findobj(gcf,'tag', 'edsearch'),'userdata');
units=get(0,'units');
set(0,'units','norm');
mp=get(0,'PointerLocation');
set(0,'units',units);

fp  =get(gcf,'position');
hp  =findobj(gcf,'tag','pbresize');
set(hp,'units','norm');
pos =get(hp,'position');
mid=pos(3:4)/2;
newpos=[(mp(1)-fp(1))./(fp(3))  (mp(2)-fp(2))./(fp(4))];
if newpos(1)-mid(1)<0; newpos(1)=mid(1); end
if newpos(2)-mid(2)<0; newpos(2)=mid(2); end
if newpos(1)-mid(1)+pos(3)>1; newpos(1)=1-pos(3)+mid(1); end
if newpos(2)-mid(2)+pos(4)>1; newpos(2)=1-pos(4)+mid(2); end

df=pos(1:2)-newpos+mid;
% pos4=[ pos(1) pos(2)-df(2)    pos([3 4])]; %DOWNLONLY
pos4=[ pos(1)-df(1) pos(2)-df(2)    pos([3 4])];%DOWN-right

set(hp,'position',pos4);
set(hp,'units','pixels');

% return
% --------------------------
hs=findobj(gcf,'tag','lbsearch');
he=findobj(gcf,'tag','edsearch');
set(hs,'units','norm');
set(he,'units','norm');

pos2=get(hs,'position');

posed=get(he,'position');
pos3=[pos2(1) pos4(2)  pos2(3)     posed(2)-pos4(2)  ]; %DOWNLONLY
pos3=[pos2(1) pos4(2)  (pos4(1)+pos4(3))-pos2(1)    posed(2)-pos4(2)  ]; %DOWN-right
% disp(pos3);
set(hs,'position',pos3);

set(hs,'units','pixels');
set(he,'units','pixels');

    

function motio(e,e2,id)

uv=get(findobj(gcf,'tag', 'edsearch'),'userdata');
try
    set(uv.controls,'units','norm');
    
    units=get(0,'units');
    set(0,'units','norm');
    mp=get(0,'PointerLocation');
    set(0,'units',units);
    
    fp  =get(gcf,'position');
    %hp  =findobj(gcf,'tag','pbmovepan');
    hp  =findobj(gcf,'tag','pbmovepan');
    pos =get(hp,'position');
    % set(hp,'position',[(mp(1)-fp(1))./(fp(3))  (mp(2)-fp(2))./(fp(4)) pos(3:4)])
    % get(gcf,'currentpoint')
    %  0.5571    0.5000
    mid=pos(3:4)/2;
    newpos=[(mp(1)-fp(1))./(fp(3))  (mp(2)-fp(2))./(fp(4))];
    if newpos(1)-mid(1)<0; newpos(1)=mid(1); end
    if newpos(2)-mid(2)<0; newpos(2)=mid(2); end
    if newpos(1)-mid(1)+pos(3)>1; newpos(1)=1-pos(3)+mid(1); end
    if newpos(2)-mid(2)+pos(4)>1; newpos(2)=1-pos(4)+mid(2); end
    
    df=pos(1:2)-newpos+mid;
    
    hx=uv.controls;
    if length(hx)==1
        pos2=get(hx,'position');
    else
        pos2=cell2mat(get(hx,'position'));
    end
    %     df
    for i=1:length(hx)
        pos3=[ pos2(i,1:2)-df   pos2(i,[3 4])];
        if length(hx)==1
            set(hx,'position', pos3);
        else
            set(hx(i),'position', pos3);
            %             pos3
        end
    end
    
    set(uv.controls,'units','pixels');
catch
    
    set(uv.controls,'units','pixels');
end

function cb_exaxtmatch(e,e2)

he=findobj(gcf,'tag','toggleexactsearch');
z=get(he,'userdata');
if get(he,'value')==0
    set(he,'backgroundcolor',z.col(1,:), 'string',z.str(1));
else
    set(he,'backgroundcolor',z.col(2,:), 'string',z.str(2)  );
end

keyedit()

function changecolumnpulldown(e,e2)
changecolumn([],[],0);

function changecolumn(e,e2,arg)
hc=findobj(gcf,'tag','pdcolumnsearch');
li=get(hc,'string');
va=get(hc,'value');
va2=va+arg;
if va2>length(li); va2=1; end
if va2<1; va2=length(li); end
set(hc,'value',va2);
updatecolumnlist;

function updatecolumnlist
hs=findobj(gcf,'tag', 'edsearch');
uv=get(hs,'userdata');
us=get(uv.fig2,'userdata') ;
icol=get(findobj(gcf,'tag', 'pdcolumnsearch'),'value');
% list = regexprep( uv.data(:,icol), {'<.*?>','&nbsp;'}, '' );
list=cellfun(@(a){[ num2str(a)  ]} , uv.data(:,icol) );

hl=findobj(gcf,'tag', 'lbsearch');
set(hl,'string',list);
hs=findobj(gcf,'tag', 'edsearch');
set(hs,'string','');

uv.list=list;
set(hs,'userdata',uv);

% 
% hs=uicontrol('style','edit','units','norm','position',   pos,'tag', 'edsearch');
% hl=uicontrol('style','listbox','units','norm','position',[pos(1) pos(2)-.15 pos(3) .15],'tag', 'lbsearch');
% set(hl,'string',list)
% set(hl,'callback',@lbselectthis);





function pbsearch(e,e2)
hs=findobj(gcf,'tag', 'edsearch');
uv=get(hs,'userdata');
us=get(uv.fig2,'userdata');
icol=get(findobj(gcf,'tag', 'pdcolumnsearch'),'value');
str2search=get(findobj(gcf,'tag','edsearch'),'string');
str2search=strtrim(str2search);
% c = regexprep( us.raw(:,icol+1), {'<.*?>','&nbsp;'}, '' );
c=uv.data(:,icol);
c=cellfun(@(a){[ num2str(a)  ]} , c );

hexact= findobj(gcf,'tag','toggleexactsearch');
if get(hexact,'value')==1
    is=regexpi2(c,['^' str2search '$']);
else
    is=regexpi2(c,str2search);
end
% disp(is);

% disp('---callback');
feval(uv.callback,is);


% lb1=findobj(uv.fig2,'tag','lb1');
% if isempty(is)==1
%     return; 
% end
% set(lb1,'value',is);
% if length(is)==1
%     set(lb1,'ListboxTop',is);
% end


function pbexitsearch(e,e2)
try
    try
        %last column
        hx= findobj(gcf,'tag','pdcolumnsearch');
        columnsearch=get(hx,'value');
        uv=get(findobj(gcf,'tag', 'edsearch'),'userdata');
        us=get(uv.fig2,'userdata');
        us.findercolumn=columnsearch;
        set(uv.fig2,'userdata',us);
    end
    
    hs=findobj(gcf,'tag', 'edsearch');
    for i=1:length(hs)
    uv=get(hs(i),'userdata');
    try; delete( uv.controls);end
    end
end


function pbclearsearch(e,e2)
hs=findobj(gcf,'tag', 'edsearch');
uv=get(hs,'userdata');

set(hs,'string','');
hl=findobj(gcf,'tag', 'lbsearch');
set(hl,'value',1,'string',uv.list);

function keyedit(e,e2)
hs=findobj(gcf,'tag', 'edsearch');
uv=get(hs,'userdata');

hj=uv.hj;
str=char(hj.getText);


he=findobj(gcf,'tag','toggleexactsearch');
em=get(he,'value'); %exact match

if em==0
    isel=find(cellfun(@(x) any(x),regexpi(uv.list,str)));
else
    isel=find(cellfun(@(x) any(x),regexpi(uv.list,[ '^' str  ])))
end


if isempty(str)
    isel=1:length(uv.list);
end

hl=findobj(gcf,'tag', 'lbsearch');
set(hl,'value',1,'string',uv.list(isel));
if isempty(isel)
    set(hl,'backgroundcolor',[1 1 .4]);
else
    set(hl,'backgroundcolor',[1 1 1]);
end
% 'keyedit'


return
% e2
% % let=e2.Key
%
% let=e2.Character
% if strcmp(e2.Key,'backspace')
%     if length(uv.str)>0
%     uv.str(end)=[];
%     end
% else
%     if ~isempty(regexpi(' ','[A-z0:9. ]'));
%     uv.str=[uv.str let];
%     end
% end
% disp('-----');
% disp(uv.str);
% set(hs,'userdata',uv);
% isel=find(cellfun(@(x) any(x),regexpi(uv.list,uv.str)));
% if isempty(isel)
%    isel=1:length(uv.list);
% end
% hl=findobj(gcf,'tag', 'lbsearch');
% set(hl,'value',1,'string',uv.list(isel));

function lbselectthis(e,e2)
li=get(e,'string');
va=get(e,'value');
hs=findobj(gcf,'tag', 'edsearch');
set(hs,'string',li{va});
uv=get(hs,'userdata');
uv.str=li{va};
set(hs,'userdata',uv);
pbsearch(e,e2);

function v=geticon(arg)
if strcmp(arg,'hand')
    v=[129	129	129	129	129	129	129	0	0	129	129	129	129	129	129	129
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
elseif strcmp(arg,'resize')
        v(:,:,1)=...
            [0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
            0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
            0	0	38	51	51	51	51	13	0	0	0	0	0	0	0	0
            0	0	48	153	111	153	67	12	0	0	0	0	0	0	0	0
            0	0	44	103	132	73	29	0	0	0	0	0	0	0	0	0
            0	0	40	149	72	123	56	22	0	0	0	0	0	0	0	0
            0	0	35	50	23	50	114	50	19	0	0	0	0	0	0	0
            0	0	8	8	0	17	44	109	45	16	0	0	0	0	0	0
            0	0	0	0	0	0	14	40	104	40	13	0	5	5	0	0
            0	0	0	0	0	0	0	11	33	93	32	12	32	19	0	0
            0	0	0	0	0	0	0	0	8	26	73	23	110	14	0	0
            0	0	0	0	0	0	0	0	0	6	16	49	27	10	0	0
            0	0	0	0	0	0	0	0	1	6	73	10	73	6	0	0
            0	0	0	0	0	0	0	0	0	2	2	2	2	1	0	0
            0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
            0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0];
        v(:,:,2)=...
            [0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
            0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
            0	0	95	126	126	126	126	31	0	0	0	0	0	0	0	0
            0	0	123	229	188	229	143	31	0	0	0	0	0	0	0	0
            0	0	118	179	208	141	76	0	0	0	0	0	0	0	0	0
            0	0	112	225	139	199	130	61	0	0	0	0	0	0	0	0
            0	0	106	123	69	123	190	123	58	0	0	0	0	0	0	0
            0	0	26	26	0	54	115	182	115	54	0	0	0	0	0	0
            0	0	0	0	0	0	51	108	175	108	50	0	22	22	0	0
            0	0	0	0	0	0	0	47	101	172	103	55	103	85	0	0
            0	0	0	0	0	0	0	0	43	96	174	98	199	78	0	0
            0	0	0	0	0	0	0	0	0	46	93	178	144	72	0	0
            0	0	0	0	0	0	0	0	8	91	198	146	198	66	0	0
            0	0	0	0	0	0	0	0	6	62	62	62	62	38	0	0
            0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
            0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0];
        v(:,:,3)=...
            [0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
            0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
            0	0	140	186	186	186	186	46	0	0	0	0	0	0	0	0
            0	0	183	255	236	255	200	46	0	0	0	0	0	0	0	0
            0	0	178	232	252	199	115	0	0	0	0	0	0	0	0	0
            0	0	172	254	198	247	190	94	0	0	0	0	0	0	0	0
            0	0	166	183	108	183	243	183	90	0	0	0	0	0	0	0
            0	0	41	41	0	87	176	236	175	87	0	0	0	0	0	0
            0	0	0	0	0	0	83	168	229	168	83	0	37	37	0	0
            0	0	0	0	0	0	0	80	162	228	163	94	163	145	0	0
            0	0	0	0	0	0	0	0	76	158	233	160	243	138	0	0
            0	0	0	0	0	0	0	0	0	86	156	243	213	132	0	0
            0	0	0	0	0	0	0	0	16	155	252	217	252	126	0	0
            0	0	0	0	0	0	0	0	12	122	122	122	122	74	0	0
            0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
            0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0];
        
         
end







