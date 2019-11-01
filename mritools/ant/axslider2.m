

% PANEL IMAGES WITH SELECTION-OPTION
%     [ax rb]=axslider2(nb,varargin)
%    [hs rb] =axslider2([5 4],  'checkbox',0 ); %[5x4 pannel] no checkbox
%    [hs rb] =axslider2([5 4],  'checkbox',4,'selection','single' );%  %[5x4 pannel], each 4th image gets a checkbox, singleSelection 
%    [hs rb] =axslider2([5 4],  'checkbox',2,'selection','multi' );%  %[5x4 pannel], each 2nd image gets a checkbox, numtiSelection 
%     
%   %% so something with axes  
%    for i=1:length(hs)
%         axes(hs(i))
%         imagesc(rand(4));
% %        text(.5,.5,num2str(i))
%        axis off
%    end
%    
%    % posthoc: get selected radiobutton and more important the rb-'string'
%    rbsel    =rb(find(cell2mat(get(rb,'value'))));        % id of radiobutton(s) selected
%    rbstring = str2num(char(get(rbsel,'string')))'        ;%get string of selected radiobutton
%    disp(rbstring);

function [ax rb]=axslider2(nb,varargin)


if 0
    
    [hs rb] =axslider2([5 4],  'checkbox',0 ); %[5x4 pannel] no checkbox
    [hs rb] =axslider2([5 4],  'checkbox',4,'selection','single' );%  %[5x4 pannel], each 4th image gets a checkbox, singleSelection
    [hs rb] =axslider2([5 4],  'checkbox',2,'selection','multi' );%  %[5x4 pannel], each 2nd image gets a checkbox, numtiSelection
    
    %% so something with axes
    for i=1:length(hs)
        axes(hs(i))
        imagesc(rand(4));
        %        text(.5,.5,num2str(i))
        axis off
    end
    
    % posthoc: get selected radiobutton and more important the rb-'string'
    rbsel    =rb(find(cell2mat(get(rb,'value'))));        % id of radiobutton(s) selected
    rbstring = str2num(char(get(rbsel,'string')))'        ;%get string of selected radiobutton
    disp(rbstring);
    
end







warning off;
[ax rb]=deal([]);

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

us=[];

%% num
if isfield(v,'num')==0
    stepimg=nb(2);
    v.num=stepimg;
else
     stepimg=v.num;
%      v.num=1;
end

if isfield(v,'selection')==0
   v.selection='single' ;
end
  
if 0
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
    % set(b,'visible','off');
    % set(b,'visible','on');
    % steptxt=1:v.num:prod(nb);
    % bc=b(1:v.num:end);
    % for i=1:length(bc)
    %     set(bc(i),'string',num2str(i));
    % end
end

%% checkbox
if isfield(v,'checkbox')
    chk.ichk=1:1:prod(nb);
    si=0.04;
    for i=1:length(chk.ichk)
        ref=p(chk.ichk(i),:);
        chk.pos(i,:)=[ref(1)+0.*si ref(2)+ref(4)-si si+.065 si];
        chk.hchk(i)=uicontrol('style','radio','units','norm','position',chk.pos(i,:),'string',num2str(i),...
            'backgroundcolor','k','foregroundcolor','w','value',0,'userdata', (i),'tag','chk1',...
            'fontsize',6,'callback',{@radioselection,v.selection});
    end
    us.rbpos=chk.pos;
    
    set(chk.hchk,'visible','off');
    set(chk.hchk(1:v.checkbox:end),'visible','on');
    inum=1:length(1:v.checkbox:length(chk.ichk));
    huse=chk.hchk(1:v.checkbox:end);
    for i=1:length(huse)
        set(huse(i) ,'string', num2str(inum(i)));
    end
    
    rb=chk.hchk;
end
%  return



us.nb=nb;
us.v=v;
us.ax=ax;
us.stp=stp;
us.p=p;
us.up=up;
us.lasttimeSliderCalled=tic;
us.slidvalue=1;
us.topcurrentrow=1;
us.scrollrows=[1 3 5];
% us.slidstep=1;

us.slidstep =nb(1);%p(1,3);

set(findobj(gcf,'tag','slid'),'SliderStep',[1/us.slidstep 1/us.slidstep]);

if isfield(v,'checkbox')
    us.rb=rb;
end

% if 0
%   re=mod(nb(1),3);
%     k2=(nb(1)-re)/3+1 ;
%    % disp([nb k2  ]);
%     if k2==0;
%         k2=1;
%         set(findobj(gcf,'tag','slid'),'visible','off');
%     end 
% us.slidstep=k2;
% 
% 
% set(findobj(gcf,'tag','slid'),'SliderStep',[1/us.slidstep 1/us.slidstep]);
% end

% us.num  =[]b;%number + ip
% us.numip=ip;
% us.numpos=bpos;

if isfield(v,'checkbox')
   us.chk=chk;
end

set(u,'userdata',us);
set(u,'callback',{@slidupdate});

set(findobj(gcf,'type','axes'),'XTickLabel','','YTickLabel','');


set(gcf,'WindowScrollWheelFcn',@sliderupdate)

% ns=3
% set(u,'SliderStep',[1/ns 1/ns]);


ht=uicontrol('style','text','units','norm');
set(ht,'position',[.85 0 .1 .025],'string',['Pan ' num2str(nb(1)) 'x' num2str(nb(2))],'backgroundcolor','w','foregroundcolor',[1 0 1]);
set(ht,'tag','msg');

function radioselection(e,e2,selection)
if strcmp(selection,'single')
%     disp('single');
    
    cb=findobj(gcf,'tag','chk1');
    set(cb,'value',0);
    set(e,'value',1);
    
    
    
else
%      disp('multi');
end

function key(h,e)
u=findobj(gcf,'tag','slid');
us=get(u,'userdata');


stp=1/us.slidstep ;%.05;
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
if strcmp(e.Key,'rightarrow')
    u=findobj(gcf,'tag','slid');
    stepvec=fliplr(linspace(0,1,us.nb(1)));
    v=get(u,'value');
    ic=vecnearest2(stepvec,v);
    try
       v= stepvec(ic+us.nb(2));
    catch
        if us.nb(2)+ic<us.nb(1)
            v= stepvec(ic+us.nb(1)-(us.nb(2)+ic));
        else
            return
        end
    end
    if v<0; v=0; end
    set(u,'value',v);
    slidupdate([],[]);
elseif strcmp(e.Key,'leftarrow')
     u=findobj(gcf,'tag','slid');
    stepvec=fliplr(linspace(0,1,us.nb(1)));
    v=get(u,'value');
    ic=vecnearest2(stepvec,v);
    try
       v= stepvec(ic-us.nb(2));
    catch
      if ic==1;         return; end
         v= stepvec(ic-1);
    end
    if v<0; v=0; end
    set(u,'value',v);
    slidupdate([],[]);
   
   
   
elseif strcmp(e.Key,'c') 
    try
        contours=findobj(gcf,'Type','contour');
        if strcmp(get(contours(1),'visible'),'off')
            set(contours,'visible','on');
        else
            set(contours,'visible','off');
        end
    end
    
end
   



%% callback scrollwhell
function sliderupdate(hf,e)
sc=sign(e.VerticalScrollCount);
% u=findobj(gcf,'tag','slid');
% stp=get(u,'SliderStep');
% % stp=[.1 .2];
% nval=get(u,'value')+stp(2).*-sign(e.VerticalScrollCount);
% if nval>1; nval=1; end
% if nval<0; nval=0; end
% set(u,'value',nval);
% slidupdate([],[]);

if sc==0; return; end


u=findobj(gcf,'tag','slid');
us=get(u,'userdata');


stp=1/us.slidstep ;%.05;
if sc==1; %strcmp(e.Key,'downarrow')
    u=findobj(gcf,'tag','slid');
    v=get(u,'value');
    v=v-stp;
    if v<0; v=0; end
    set(u,'value',v);
    slidupdate;
else%strcmp(e.Key,'uparrow')
    u=findobj(gcf,'tag','slid');
    v=get(u,'value');
    v=v+stp;
    if v>1; v=1; end
    set(u,'value',v);
    slidupdate;
end


  
function slidupdate(u,e,arg)

if exist('arg')==1

else
    
end

u=findobj(gcf,'tag','slid');
us=get(u,'userdata');


% us.topcurrentrow
val=get(u,'value');
steps=us.slidstep;

stepvec=fliplr(linspace(0,1,us.nb(1)));
p=us.p;
hig=[p(:,2); p(:,2)+p(:,4)];
step2=[max(hig)-min(hig)]/length(stepvec);
% movvec=[1:length(stepvec)]*us.p(1,3)-us.p(1,3);
movvec=[1:length(stepvec)]*step2-step2;

im=vecnearest2(stepvec,val);
ic=movvec(im);
% disp('---');
% disp([im ic]);


% return
% shift=1-get(u,'value');
shift=ic;
ax=us.ax;

p(:,2)=p(:,2)+shift;
for i=1:length(ax)
    set(ax(i),'position',p(i,:));
end

%% checkbox
if isfield(us,'rb')
    hh=us.rb;
    p3=us.rbpos;
    p3(:,2)=p3(:,2)+shift;
    for i=1:length(hh)
        %cpos=get(hh(i),'position');
        set(hh(i),'position',p3(i,:));
        %set(hh(i),'position',p3(i,:));
    end
end
drawnow;








