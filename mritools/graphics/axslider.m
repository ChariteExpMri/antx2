

function ax=axslider(nb,varargin)

warning off;
if nargin>1
    %vnew=varargin{1};
    
    vara=reshape(varargin,[2 length(varargin)/2])';
    vnew=cell2struct(vara(:,2)',vara(:,1)',2);
    
else
    vnew=struct();
end

v=vnew;
 

% n=20;
% nr=3;

n=nb(1);
nr=nb(2);

if n<nr
   norig=n; 
   n=nr; 
   removeimg=1;
else
    removeimg=0;
end


% ax=[];
% for i=1:n*nr
%     ax(i,1)=subplot(20,3,i); plot(1:10);title(i);
% end
%
% p=cell2mat(get(ax,'position'))


nps=nr;

slidwid=.02;
lewid  =.01;

% sub=(1/nps)*.8;
up=0:1/nps:1-1/nps;
wid=(1-(slidwid+lewid))/nr;
re=[0:wid:wid*(nr-1)] ;
si=1/nps;
hi=si;

hit=cumsum(repmat(hi,[n 1]));
hit=flipud(hit-hit(end-(nps-1)));


si2=wid;
% si2=si*1.00
shift2right=(si-si2);

p=[];
for i=1:length(re)
    p0=[repmat(re(i),[size(hit,1) 1])  hit  repmat(si2,[size(hit,1) 2])];
    p=[p;p0];
end
p=sortrows(p,[ -2  1]);
p(:,1)=p(:,1)+shift2right*.75;

if removeimg==1;
    nkeep=norig.*nr;
    p=p(1:nkeep,:);
end


figure('color','w','units','norm');
u=uicontrol('style','slider','units','normalized');
set(u,'position',[1-slidwid 0 slidwid 1]);
set(u,'value',get(u,'max'),'tag','slid');
set(gcf,'WindowKeyPressFcn',@key);


for i=1:size(p,1)
    ax(i,1)= axes('Position',p(i,:),'tag','ax');
%     text(.5,.5,num2str(i));
end

% ax=findobj(gcf,'tag','ax');
% p2=cell2mat(get(ax,'position'));
stp=-.1;
% p2(:,2)=p2(:,2)+stp;
% for i=1:length(ax)
% set(ax(i),'position',p2(i,:));
% end


%% num
if isfield(v,'num')==0
    stepimg=nb(2);
else
     stepimg=1;
end
    
ip=1:stepimg:prod(nb);
si=0.03;
for i=1:length(ip)
    ref=p(ip(i),:);
    if stepimg==1
        bpos(i,:)=[ref(1) ref(2)+ref(4)-si si si];
    else
        bpos(i,:)=[0 ref(2)+ref(4)-si si si];
    end
    b(i)=uicontrol('style','text','units','norm','position',bpos(i,:),'string',num2str(i),...
    'backgroundcolor','k','foregroundcolor','w');
end


%% checkbox
if isfield(v,'checkbox')
    chk.ichk=1:1:prod(nb);
    si=0.03;
    for i=1:length(chk.ichk)
        ref=p(chk.ichk(i),:);
        chk.pos(i,:)=[ref(1)+si ref(2)+ref(4)-si si si];
        chk.hchk(i)=uicontrol('style','checkbox','units','norm','position',chk.pos(i,:),'string',num2str(i),...
            'backgroundcolor','k','foregroundcolor','w','value',0,'userdata', (i),'tag','chk1');
    end
end


us=[];
us.v=v;
us.ax=ax;
us.stp=stp;
us.p=p;
us.up=up;

us.num  =b;%number + ip
us.numip=ip;
us.numpos=bpos;

if isfield(v,'checkbox')
   us.chk=chk;
end

set(u,'userdata',us);
set(u,'callback',{@slidupdate});

set(findobj(gcf,'type','axes'),'XTickLabel','','YTickLabel','');


set(gcf,'WindowScrollWheelFcn',@sliderupdate)


function key(h,e)

stp=.05;
if strcmp(e.Key,'downarrow')
    u=findobj(gcf,'tag','slid');
    v=get(u,'value');
    v=v-stp;
    if v<0; v=0; end
    set(u,'value',v);
    slidupdate;
elseif strcmp(e.Key,'uparrow')
    u=findobj(gcf,'tag','slid');
    v=get(u,'value');
    v=v+stp;
    if v>1; v=1; end
    set(u,'value',v);
    slidupdate;
end
stp=.2;
if strcmp(e.Key,'rightarrow')
    u=findobj(gcf,'tag','slid');
    v=get(u,'value');
    v=v-stp;
    if v<0; v=0; end
    set(u,'value',v);
    slidupdate;
elseif strcmp(e.Key,'leftarrow')
    u=findobj(gcf,'tag','slid');
    v=get(u,'value');
    v=v+stp;
    if v>1; v=1; end
    set(u,'value',v);
    slidupdate;
end
   



%% callback
function sliderupdate(hf,e)


sign(e.VerticalScrollCount);
u=findobj(gcf,'tag','slid');
% stp=get(u,'SliderStep');
stp=[.1 .2];
nval=get(u,'value')+stp(2).*-sign(e.VerticalScrollCount);
if nval>1; nval=1; end
if nval<0; nval=0; end
set(u,'value',nval);
slidupdate([],[])

function slidupdate(u,e)

u=findobj(gcf,'tag','slid');
us=get(u,'userdata');
ax=us.ax;
p=us.p;

axvis=ax;
for i=1:length(axvis)
    set(get(axvis(i),'children'),'visible','off');
end


val=1-get(u,'value');
yr=[min(p(:,2)) max(p(:,2))];

stp=abs(min(yr)*val);

if val==0
    stp=stp-.05;
elseif val==1
    stp=stp+.05;
end

p2=p;
p2(:,2)=p2(:,2)+stp;

for i=1:length(ax)
    set(ax(i),'position',p2(i,:));
end

%% number
nu=us.num;
p3=us.numpos;
p3(:,2)=p3(:,2)+stp;
for i=1:length(nu)
    set(nu(i),'position',p3(i,:));
end

%% checkbox
if isfield(us,'chk')
    hh=us.chk.hchk;
    p3=us.chk.pos;
    p3(:,2)=p3(:,2)+stp;
    for i=1:length(hh)
        set(hh(i),'position',p3(i,:));
    end
end


axvis=ax(find(p2(:,2)>-1 & p2(:,2)<1));
for i=1:length(axvis)
    set(get(axvis(i),'children'),'visible','on');
end



% p=us.p
% ax=us.ax
% p2=cell2mat(get(ax,'position'));
% stp=-.1;
% p2(:,2)=p2(:,2)+stp;
%  for i=1:length(ax)
% set(ax(i),'position',p2(i,:));
%  end







