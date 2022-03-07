




% add resize buttons to listbox or other uicontrols
% image axes partly supported
% resize buttons can be assigne to multiple uicontrols in the same figure
% addResizebutton(figh,hres ,varargin)
% ===============================================
%  figh: figure handle
% hres : handle of control to resize
%
% ----otional PARAMETER (pairwise input)
% mode  ='R';                        ;%resize button: see 'mode'
% listboxResize =1                   ;%[1]resize other listbox or [0] shift listbox
% moo           =1                   ;%move other objects in neighbourhood: [1]yes, [0]no
%
% mode ='L' ...sesize button left
% mode ='R' ...sesize button right
% mode ='U' ...sesize button up
% mode ='D' ...sesize button down
% or any combination such as : mode ='LUDR'
% 
% -------optional-------
% 'restore' :      -   [0/1]; restore previous position via contextmenu
% 
%% examples-1
% fg; imagesc;hf=gcf; hres=gca,addResizebutton(hf,hres,'mode','UDLR','moo',0);
%% example-2
% fg; imagesc;
% hf=gcf; 
% set(gca,'units','norm','position',[.3 .3 .3 .3]) ;
% hb=uicontrol('style','listbox','units','norm','position',[.5 .5 .3 .3],'string',{'aa','bb'}) ;
% addResizebutton(hf,hb,'mode','UDLR','moo',1);
%% remove resizeButtons from current figure
% addResizebutton('remove')
% ===============================================



function addResizebutton(figh,hres ,varargin)
warning off;
% ==============================================
%%
% ===============================================

if 0
    %% ===============================================
    
    fg; imagesc;hf=gcf; set(gca,'units','norm','position',[.3 .3 .3 .3]) ;
    hb=uicontrol('style','listbox','units','norm','position',[.5 .5 .3 .3],'string',{'aa','bb'}) ;
    addResizebutton(hf,hb,'mode','UDLR','moo',1);
    %% ===============================================
    
end


if 0
    %% ===============================================
    
    ant
    hf=findobj(0,'tag','ant');
    hres=findobj(hf,'tag','lb3');
    addResizebutton(hf,hres,'mode','UR')
    
    
    return
    ant; hf=findobj(0,'tag','ant'); hres=findobj(hf,'tag','lb3');  addResizebutton(hf,hres,'mode','LUDR');addResizebutton(hf,findobj(hf,'tag','lb1'),'mode','LUDR')
    return
    
    
    ant; hf=findobj(0,'tag','ant'); hres=findobj(hf,'tag','lb1');  addResizebutton(hf,hres,'mode','UDLR')
    return
    
    %% ===============================================
    
    cf;fg;
    imagesc
    hf=gcf; hres=gca
    %      test_resize(hf,hres,'mode','L')
    %      test_resize(hf,hres,'mode','R')
    %      test_resize(hf,hres,'mode','U')
    %      test_resize(hf,hres,'mode','D')
    addResizebutton(hf,hres,'mode','UDLR')
    %% ===============================================
    return
    %% ===============================================
    
    cf;fg; imagesc;hf=gcf; hres=gca,addResizebutton(hf,hres,'mode','UDLR');
    addNote(gcf,'text','This is <b>Note-1</b><br>123','pos',[0.02 .5  .3 .3],'mode','multi');
    
    %% ===============================================
    cf;fg; imagesc;hf=gcf; hres=gca,addResizebutton(hf,hres,'mode','UDLR');     addNote(gcf,'text','This is <b>Note-1</b><br>123','pos',[0.02 .5  .3 .3],'mode','multi');
    
    %% ===============================================
    
end

% ==============================================
%%   close option
% ===============================================
if ischar(figh) && strcmp(figh,'remove')
    delete(findobj(gcf,'tag','BUT_resizeControl'));
    return
end

% ==============================================
%%   inputs
% ===============================================
if exist('figh')==1 ;     hf=figh; else;     hf=gcf; end
if exist('hres')==1 ;            ; else;     return; end
figure(hf);



% ===============================================
% ----INPUT PARAMETER
p0.mode  ='R';                        ;%resize button: see 'mode'
p0.listboxResize =1                   ;%[1]resize other listbox or [0] shift listbox
p0.moo           =1                   ;%move other objects: [1]yes, [0]no
p0.restore       =1                   ;%restore previous position via contextmenu
% ===============================================


% p0.head=['<b><div style="font-family:impact;color:green">' 'Matlab</div></b>']


if nargin>1
    v=varargin;
    p=cell2struct(v(2:2:end),v(1:2:end),2);
    p=catstruct(p0,p);
else
    p=p0;
end

% ==============================================
%%
% ===============================================

% delete(findobj(gcf,'tag','but_resize'))

modes=p.mode;
% p

% IS=15;

% return
% ==============================================
%%
% ===============================================
posR=get(hres,'position');
hh=[];
orient={};
hhunit={};
hhpos=[];
this='';
for i=1:length(modes)
    mode=p.mode(i);
    if strcmp(mode,'R')
        si=[.01 posR(4)/3 ];
        posB=[posR(1)+posR(3)-si(1) posR(2)+si(2)   si  ];
        orient(end+1,1)={'R'};
        %this='R';
    elseif strcmp(mode,'L')
        si=[.01 posR(4)/3 ];
        posB=[posR(1)-si(1)        posR(2)+si(2)   si  ];
        orient(end+1,1)={'L'};
        %this='L';
    elseif strcmp(mode,'U')
        si=[posR(3)/3 .01  ];
        posB=[(posR(1)+(si(1)))    posR(2)+posR(4)   si  ];
        orient(end+1,1)={'U'};
        %this='U';
    elseif strcmp(mode,'D')
        si=[posR(3)/3 .01  ];
        posB=[(posR(1)+(si(1)))    posR(2)  si  ];
        orient(end+1,1)={'D'};
        %this='D';
    end
    
    
    %% ___________________[resize]_____________________________________________________________________________
    if strcmp(get(get(hres,'parent'),'type'),'figure')
        hpar=hf;
    else % panel or else
       hpar=get(hres,'parent'); 
    end
    hb=uicontrol('parent',hpar, 'style','push','units','norm','string','<');
    set(hb,'position',posB,'fontsize',5,'tag','BUT_resizeControl',...
        'TooltipString','resize panel','tooltipstring','resize control');
    set(hb,'units','pixels');
    posN=get(hb,'position');
    % set(hb,'position',[posN(1:2) IS IS]);
    set(hb,'units','norm');
    hmove = findjobj(hb);
    
    set(hmove,'MouseDraggedCallback',{@fnote_resize,mode,hb,{hres},{},{},{} } );
    
    hh(i)=hb;
    hhunit{i}=get(hb,'units');
    hhpos{i}=posB;
    
    
    c = uicontextmenu;
    hb.UIContextMenu = c;
    if p.restore==1
        m1 = uimenu(c,'Label','restore default control position','Callback',@restoredefault);
    end
    
end
u.hh    =hh;
u.orient=orient;
u.hhunit=hhunit;
u.hhpos =hhpos;

set(hh,'userdata',u);

%% ============ other controls ===================================

h=findobj(gcf,'type','uicontrol'); %controls
b=h(regexpi2(get(h,'tag'),'BUT_resizeControl')); %resize button
h(regexpi2(get(h,'tag'),'BUT_resizeControl'))=[];

oc.h=h;
oc.units=get(h,'units');
oc.pos=get(h,'position');
%% ===============================================


for i=1:length(hh)
    u2=get(hh(i),'userdata');
    u2.this=p.mode(i);
    u2.oc=oc;
    
    u2.butunit=get(hh(i),'units');
    u2.butpos =get(hh(i),'position');
    
    u2.figunit=get(gcf,'units');
    u2.figpos =get(gcf,'position');
    u2.p=p;
    set(hh(i),'userdata',u2);
end

function restoredefault(e,e2)
%% ________________________________________________________________________________________________
try
    h=findobj(gcf,'type','uicontrol'); %controls
    b=h(regexpi2(get(h,'tag'),'BUT_resizeControl')); %resize button
    h(regexpi2(get(h,'tag'),'BUT_resizeControl'))=[];
    % units=get(h,'units');
    % get(h,'position');
    u=get(b(1),'userdata');
    
    %---figure-position/size
    units=get(gcf,'units');
    posf =get(gcf,'position');
    set(gcf,'units'      ,u.figunit);
    posn=[posf(1:2) u.figpos(3:4) ];
    set(gcf,'position'   ,posn);
    % set(gcf,'position'   ,u.figpos);
    set(gcf,'units'      ,units);
    
    
    
    %__reset all other controls
    for i=1:length(u.oc.h)
        units=get(u.oc.h(i),'units');
        set(u.oc.h(i),'units',u.oc.units{i});
        set(u.oc.h(i),'position',u.oc.pos{i});
        set(u.oc.h(i),'units',units);
    end
    % %__reset resize-buttons
    for i=1:length(b)
        us=get(b(i),'userdata');
        units=get(b(i),'units');
        set(b(i),'units',us.butunit);
        set(b(i),'position',us.butpos);
        set(b(i),'units',units);
        
    end
end

%% ________________________________________________________________________________________________


function fnote_resize(e,e2,mode,btag,rtag,movetags, downTags,upTags)
% rtag=cellstr(rtag);


% hv=findobj(gcf,'tag',rtag{1});
hv=btag(1);
% hv=rtag{1};
% get(hv,'tag')
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

%  [xx yy]

add=pos(2)-yy;

% if xx<0; xx=0; end
% if xx>(posF(3)-pos(3)); xx=posF(3)-pos(3); end
% yy=mp(2)-posF(2);
% if yy<0; yy=0; end
% if yy>(posF(4)-pos(4)); yy=(posF(4)-pos(4)); end
% disp('-....');

xs=pos(1)-xx;
ys=pos(2)-yy;
posn=[ xx yy pos(3)+xs pos(4)+ys]; % resize -down-left
% posn=[ pos(1:2) pos(3)+xs pos(4)+ys]
if posn(3)<0; posn(3)=3; end
if posn(4)<0; posn(4)=3; end
%
% set(hv,'position',posn);
set(hv ,'units'  ,units_hv);
set(gcf,'units'  ,units_fig);
set(0  ,'units'  ,units_0);
% df=[pos(1)-xx pos(2)-yy];
% ----------------------------
% ==============================================
%%   BUTTON
% ===============================================
% move moving-icon
% [xs xs]
% hv=findobj(gcf,'tag',tag);
% hv=tag{1};
hv=btag(1); %button
units_hv =get(hv ,'units');
set(hv  ,'units','pixels');
pos2=get(hv,'position');
% ___________
hr=rtag{1}; %resize object
units_hr =get(hr ,'units');
set(hr  ,'units','pixels');
posr=get(hr,'position');
set(hr  ,'units',units_hr);
% ___________
hf=gcf; %figure
units_hf =get(hf ,'units');

set(hf  ,'units','pixels');
posf=get(hf,'position');
set(hf  ,'units',units_hf);


if strcmp(mode,'L')
    pp= [  pos2(1)-xs  pos2(2)-(pos2(4)/2)-ys   pos2(3:4)];
    if pp(1)<0 ||  (pp(1)+pp(3)+6)>(posr(1)+posr(3))
        return
    end
    set(hv,'position',pp);% resize -down-left
elseif strcmp(mode,'R')
    pp=[  pos2(1)-xs  pos2(2)-ys+add   pos2(3:4)];
    %     L=(pp(1)+pp(3))  ;%,posf(3);
    %     posr
    %     xs
    % posr
    if (posr(3)<18 && xs>0 ) || (pp(1)+pp(3))>posf(3)
        return
    end
    set(hv,'position',pp);% resize -down-left
elseif strcmp(mode,'U')
    add2=pos(1)-xx;
    pp=[  pos2(1) pos2(2)-ys   pos2(3:4)];
    if (posr(4)<12 && ys>0) || (pp(2)+pp(4))>posf(4)
        return
    end
    set(hv,'position',pp);% resize -down-left
elseif strcmp(mode,'D')
    add2=pos(1)-xx;
    pp=[  pos2(1) pos2(2)-ys   pos2(3:4)];
    % pp
    % (pp(2)+pp(4))
    % ((posr(2)+posr(4)))
    if pp(2)<0 || (pp(2)+pp(4))>((posr(2)+posr(4)))
        return
    end
    set(hv,'position',pp);% resize -down-left
end


set(hv  ,'units',units_hv);

% return

% ==============================================
%%   resize object
% ===============================================
% get(findobj(gcf,'tag','note_drag'),'units'),1
% hv=tag(1);
hv=rtag{1};
pos2=get(hv,'position');
% return
units_hv =get(hv ,'units');      set(hv  ,'units','pixels');
pos2=get(hv,'position');
% get(hv,'tag')
if strcmp(mode,'L')
    pt=[  pos2(1)-xs  pos2(2)   pos2(3)+xs  pos2(4)-ys+add];
    set(hv,'position',pt);% resize -down-left
elseif strcmp(mode,'R')
    pt=[  pos2(1)  pos2(2)   pos2(3)-xs  pos2(4)-ys+add  ];
    set(hv,'position',pt);% resize -down-right
elseif strcmp(mode,'U')
    pt=[  pos2(1)  pos2(2)   pos2(3)  pos2(4)-ys  ];
    set(hv,'position',pt);% resize -down-right
elseif strcmp(mode,'D')
    pt=[  pos2(1)  pos2(2)-ys   pos2(3)  pos2(4)+ys  ];
    set(hv,'position',pt);% resize -down-right
end

set(hv  ,'units',units_hv);

% ==============================================
%%   other buttons
% ===============================================
% get(findobj(gcf,'tag','note_drag'),'units'),2


hv=btag(1);
u=get(hv,'userdata');

if strcmp(u.this,'D') || strcmp(u.this,'U')
    ih=find(ismember(u.orient,{'L','R'}));
    for i=1:length(ih)
        ho=u.hh(ih(i));
        % ___________
        units_ho =get(ho ,'units');
        set(ho  ,'units','pixels');
        posh=get(ho,'position');
        %         if strcmp(u.this,'D')
        %             px=[  posh(1)  pt(2)+(pt(4)-posh(4)+ys)/2    posh(3)  posh(4)+ys  ];
        %         else
        %             px=[  posh(1)  pt(2)+(pt(4)-posh(4)+ys)/2    posh(3)  posh(4)-ys  ];
        %         end
        px=[  posh(1)  pt(2)+pt(4)/3    posh(3)  pt(4)/3   ];
        if 1%px(4)>5
            set(ho,'position',px);% resize -down-right
            set(ho  ,'units',units_ho);
        end
    end
    
elseif strcmp(u.this,'L') || strcmp(u.this,'R')
    %u.this
    ih=find(ismember(u.orient,{'U','D'}));
    %return
    for i=1:length(ih)
        ho=u.hh(ih(i));
        %get(ho,'userdata')
        % ___________
        units_ho =get(ho ,'units');
        set(ho  ,'units','pixels');
        posh=get(ho,'position');
        if strcmp(u.this,'R')
            px=[   pt(1)+pt(3)/3  posh(2)    pt(3)/3  posh(4)  ];
        else
            px=[   pt(1)+pt(3)/3  posh(2)    pt(3)/3  posh(4)  ];
        end
        %         pt(3)
        %         px(3)
        if 1%pt(3)>12
            set(ho,'position',px);% resize -down-right
            set(ho  ,'units',units_ho);
        end
    end
    
end

% get(findobj(gcf,'tag','note_drag'),'units'),3

% ==============================================
%%  outside controls
% ===============================================
if u.p.moo==0 ; return; end
h1=findobj(gcf,'type','uicontrol');
h2=findobj(gcf,'type','axes');
h=[h1(:);h2(:) ];
%     h(regexpi2(get(h,'tag'),'BUT_resizeControl'))=[];
h(find(ismember(h,u.hh)))=[]; %remove this resizeButton
h(find(ismember(h,btag)))=[]; % remove this button
if isempty(h); return; end
% h(regexpi2(get(h,'tag'),get(hr,'tag')))=[];
h(find(h==hr))=[];
if isempty(h); return; end

if strcmp(u.this,'R')
    %     h=findobj(gcf,'type','uicontrol');
    %     h(regexpi2(get(h,'tag'),'BUT_resizeControl'))=[];
    try
        units=cell2mat(get(h,'units'));
    catch
        units=(get(h,'units'));
    end
    set(h,'units','pixels');
    if length(h)==1
        posw=(get(h,'position'));
    else
        posw=cell2mat(get(h,'position'));
    end
    wi=pt(1)+pt(3); %wid
    hi=pt(2)+pt(4);%high
    ix=find(...
        (posw(:,1)>=(wi-50) & ((posw(:,2)+posw(:,4))<=hi)) | ...
        (posw(:,1)>=(wi-50)) & (hi-20>(posw(:,2)))  ...
        );
    
    %     h((posw(:,1)>=(wi-50)) & (hi-20>(posw(:,2))))
    hall=h;
    h=h(ix);
    
    %     return
    %% ===============================================
    if 1
        %--------------get buttons
        B=findobj(h,'tag','BUT_resizeControl');
        hh=[];
        for i=1:length(B);
            ub=get(B(i),'userdata');
            hh=[hh ub.hh];
        end
        hh=unique(hh);
        hh(find(hh==btag))=[]; %remove active button
        h(ismember(h,hh))=[]; %remove resBUt
        h=[h(:) ;hh(:)];
        ix=1:length(h);
    end
    
    %% ===============================================
    for i=1:length(ix)
        ho=h(ix(i));
        %if strcmpho,'')
        pw=get(ho,'position');
        if strcmp(get(ho,'style'),'listbox')
            %
            if u.p.listboxResize==1
                p1=[pw(1)-xs pw(2) pw(3)+xs pw(4)];
            else
                p1=[pw(1)-xs pw(2) pw(3) pw(4)];
            end
            if p1(3)<20; p1(3)=20; end
        else
            p1=[pw(1)-xs pw(2:end)];
        end
        set(ho,'position',p1);
    end
    
    units=cellstr(units);
    for i=1:length(u)
        set(hall,'units',units{i});
    end
elseif strcmp(u.this,'U')
    %     's'
    %     return
    %     h=findobj(gcf,'type','uicontrol');
    %     h(regexpi2(get(h,'tag'),'BUT_resizeControl'))=[];
    %     h(regexpi2(get(h,'tag'),get(hr,'tag')))=[];
    
    try
        units=cell2mat(get(h,'units'));
    catch
        units=(get(h,'units'));
    end
    set(h,'units','pixels');
    if length(h)==1
        posw=(get(h,'position'));
    else
        posw=cell2mat(get(h,'position'));
    end
    x=pt(1)+pt(3); %wid
    hi=pt(2)+pt(4);%high
    ix=find(posw(:,1)<=(x) & ((posw(:,2)+posw(:,4)+100)>=hi) );
    hall=h;
    h=h(ix);
    %h(ix)
    %% ===============================================
    if 1
        %--------------get buttons
        B=findobj(h,'tag','BUT_resizeControl');
        hh=[];
        for i=1:length(B);
            ub=get(B(i),'userdata');
            hh=[hh ub.hh];
        end
        hh=unique(hh);
        hh(find(hh==btag))=[]; %remove active button
        h(ismember(h,hh))=[]; %remove resBUt
        h=[h(:) ;hh(:)];
        ix=1:length(h);
    end
    
    %% ===============================================
    
    
    
    
    for i=1:length(ix)
        ho=h(ix(i));
        %if strcmpho,'')
        pw=get(ho,'position');
        try
        if strcmp(get(ho,'style'),'listbox')
            %p1=[pw(1)-xs pw(2) pw(3)+xs pw(4)];
            p1=[pw(1) pw(2)-ys pw(3)  pw(4)];
            if p1(4)<20; p1(4)=20; end
        else
            p1=[pw(1) pw(2)-ys pw(3:end)];
        end
        set(ho,'position',p1);
        catch
          p1=[pw(1) pw(2)-ys pw(3:end)];  
        end
    end
    
    units=cellstr(units);
    for i=1:length(u)
        set(hall,'units',units{i});
    end
    
elseif strcmp(u.this,'L')
    
    %     h=findobj(gcf,'type','uicontrol');
    %     h(regexpi2(get(h,'tag'),'BUT_resizeControl'))=[];
    %     h(regexpi2(get(h,'tag'),get(hr,'tag')))=[];
    try
        units=cell2mat(get(h,'units'));
    catch
        units=(get(h,'units'));
    end
    set(h,'units','pixels');
    if length(h)==1
       posw= get(h,'position');
    else
        posw=cell2mat(get(h,'position'));
    end
    x=pt(1) ;%xstart
    hi=pt(2)+pt(4);%high
    y=pt(2)      ;%ystart
    %     ix=find(posw(:,1)<=(bo1-50) & ((posw(:,2)+posw(:,4))<=bo2) );
    ix=find(...
        (posw(:,1)<=(x+50) & ((posw(:,2)+posw(:,4))<=hi) & ((posw(:,2))>=y) ) | ...
        ((posw(:,1)<(x+50) & ((posw(:,2)<hi)) )) ...
        ); %...
    %     h(ix)
    hall=h;
    h=h(ix);
    %h(ix)
    %% ===============================================
    if 1
        %--------------get buttons
        B=findobj(h,'tag','BUT_resizeControl');
        hh=[];
        for i=1:length(B);
            ub=get(B(i),'userdata');
            hh=[hh ub.hh];
        end
        hh=unique(hh);
        hh(find(hh==btag))=[]; %remove active button
        h(ismember(h,hh))=[]; %remove resBUt
        h=[h(:) ;hh(:)];
        ix=1:length(h);
    end
    
    %% ===============================================
    
    
    
    for i=1:length(ix)
        ho=h(ix(i));
        %if strcmpho,'')
        pw=get(ho,'position');
        try
        if strcmp(get(ho,'style'),'listbox')
            p1=[pw(1)-xs pw(2) pw(3) pw(4)];
            if p1(3)<20; p1(3)=20; end
        else
            p1=[pw(1)-xs pw(2:end)];
        end
        catch
            p1=[pw(1)-xs pw(2:end)];
        end
        set(ho,'position',p1);
    end
    
    units=cellstr(units);
    for i=1:length(u)
        set(hall,'units',units{i});
    end
    
end

% get(findobj(gcf,'tag','note_drag'),'units'),4
