
% ==============================================
%%  searchfun 
% ===============================================

function searchfun

pbexitsearch;
hfig2=findobj(0,'tag','selector');
us=get(hfig2,'userdata');

uv.header      =us.header(2:end);
if isfield(us,'findercolumn')==0
    if length(uv.header)>1
        us.findercolumn=2;
    else
        us.findercolumn=1;
    end
    set(hfig2,'userdata',us);
end

uv.searchcolumn=us.findercolumn;




% list = regexprep( us.raw(:,uv.searchcolumn), {'<.*?>','&nbsp;'}, '' );
list={''};


figure(hfig2);
hig=.03;
pos=[0.25 .8 .7 hig];


% ==============================================
%%   
% ===============================================

%% column-selection
hpd=uicontrol('style','popupmenu','units','norm','position',   pos,'tag', 'pdcolumnsearch');
set(hpd,'position',[pos(1) pos(2)+hig-0.01 .2 pos(4)  ],'string',uv.header,'value',uv.searchcolumn);
set(hpd,'tooltipstr','column to search','callback', {@changecolumnpulldown} );
%% prev
hpb=uicontrol('style','pushbutton','units','norm','position',   pos,'tag', 'pbcolumnprevsearch');
set(hpb,'position',[pos(1)+.2 pos(2)+hig .02 .02  ],'string','<', 'callback', {@changecolumn,-1} );
set(hpb,'tooltipstr','prev. column');
%%next
hpb=uicontrol('style','pushbutton','units','norm','position',   pos,'tag', 'pbcolumnnextsearch');
set(hpb,'position',[pos(1)+.2+.02 pos(2)+hig .02 .02  ],'string','>', 'callback', {@changecolumn,-1} );
set(hpb,'tooltipstr','next. column');

%% EDIT
hs=uicontrol('style','edit','units','norm','position',   pos,'tag', 'edsearch');
%% LISTBOX
hl=uicontrol('style','listbox','units','norm','position',[pos(1) pos(2)-.15 pos(3) .15],'tag', 'lbsearch');
set(hl,'string',list)
set(hl,'callback',@lbselectthis);


%pb search
he=uicontrol('style','togglebutton','units','norm',...
    'position',[pos(1)  pos(2) .04 hig],'string','EM','fontsize',6,...
    'tag', 'toggleexactsearch','tooltipstr','[0] find str [1] exact match','value',1);
% ida=fullfile(matlabroot, 'toolbox\matlab\icons\zoom.mat');  ida=load(ida);
% set(he, 'CData',ida.zoomCData);

% zoom.mat       zoomplus.mat   zoomy.mat      
% zoomminus.mat  zoomx.mat      

%pb search
he=uicontrol('style','pushbutton','units','norm',...
    'position',[pos(1)+.038  pos(2) .04 hig],...
    'tag', 'pbsearch','tooltipstr','search','callback',@pbsearch);
ida=fullfile(matlabroot, 'toolbox','matlab','icons','zoom.mat');  ida=load(ida);
set(he, 'CData',ida.zoomCData);

%exit finder
he=uicontrol('style','pushbutton','units','norm',...
    'position',[pos(1)+pos(3)-.03  pos(2)+.03 .03 hig-.005],...
    'tag', 'pbexitsearch','tooltipstr','exit find window','string','x','fontsize',7);
set(he,'fontsize',10,'fontweight','bold','callback', @pbexitsearch);


%pb clear
he=uicontrol('style','pushbutton','units','norm',...
    'position',[pos(1)+pos(3)-2*.03  pos(2) .03*2 hig-.0005],...
    'tag', 'pbclearsearch','tooltipstr','clear field','string','clr');
set(he,'fontsize',8,'fontweight','bold','callback', @pbclearsearch);

% ==============================================
%%   
% ===============================================
%% movepanel

v=uint8(geticon('hand'));
v(v==v(1,1))=255;
if size(v,3)==1; v=repmat(v,[1 1 3]); end
v=double(v)/255;
%% ______________

hp=uicontrol('style','pushbutton','units','norm','position',   pos,'tag', 'pbmovepan');
set(hp,'position',[pos(1)+pos(3)-.03*2  pos(2)+.03 .03 hig-.005],'string','',...
    'CData',v,'tooltipstr',['shift panel position' char(10) 'left mouseclick+move mouse/trackpad pointer position' ]);%, 'callback', {@changecolumn,-1} );
je = findjobj(hp); % hTable is the handle to the uitable object
set(je,'MouseDraggedCallback',{@motio,1}  );


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
    ];

% 'pbmovepan'


hj=findjobj(hs);
uv.hj=hj;
set(hs,'KeyPressFcn',@keyedit);
uv.str=[];
uv.list=list;
uv.fig2=hfig2;
set(hs,'userdata',uv);
updatecolumnlist;
uicontrol(findobj(gcf,'tag','edsearch'));

function motio(e,e2,id)
try
    uv=get(findobj(gcf,'tag', 'edsearch'),'userdata');
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
    
end



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
list = regexprep( us.raw(:,icol+1), {'<.*?>','&nbsp;'}, '' );

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
c = regexprep( us.raw(:,icol+1), {'<.*?>','&nbsp;'}, '' );

hexact= findobj(gcf,'tag','toggleexactsearch');
if get(hexact,'value')==1
    is=regexpi2(c,['^' str2search '$']);
else
    is=regexpi2(c,str2search);
end


lb1=findobj(uv.fig2,'tag','lb1');
if isempty(is)==1
    return; 
end
set(lb1,'value',is);
if length(is)==1
    set(lb1,'ListboxTop',is);
end


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
isel=find(cellfun(@(x) any(x),regexpi(uv.list,str)));

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
    
end







