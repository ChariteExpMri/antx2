
function montage2(fname)

%     fname: 'O:\data\millward\raw\20160823qing1.Dd1\6\pdata\1\2dseq'
%       dim: [128 128 10 8]
%       mat: [4x4 double]
%        dt: [4 0]
%     Ndims: 4
%__________image______________________________________
%
% fname='O:\Processing_dti\20160624HP_M39\2\pdata\1\2dseq'

if isnumeric(fname) | islogical(fname)
    dat=double(fname);
    fname=['matlabvariable ' '[' inputname(1) ']' ];
    x.fname=fname;
    x.dim=size(dat);
    
    x.Ndims=length(x.dim);
    
    h(1).fname=x.fname;
    h(1).dim  =x.dim;
    h(1).mat  =nan(4);
    h(1).pinfo=[nan nan nan];
    h(1).dt   =[nan 0];
    h(1).n    =[1 1];
    h(1).descrip='loaded data from workspace, without header';
    h(1).Ndims=length(h.dim);
    hd=h;
    d =dat;
    
    isbruker=0;
elseif isstruct(fname)


    
    hd=fname.hd;
    d =fname.d;
    hd.fname=fname.hd(1).fname;
    fname=hd.fname;
    
    x=hd;
    x.fname=fname;
    x.dim=size(d);
    x.Ndims=length(x.dim);
    isbruker=0;
else
    
    try
        [ni bh  da]=getbruker(fname);
        hd=ni.hd;
        d =ni.d;
        hd.fname=fname;
        
        x=hd;
        x.fname=fname;
        x.dim=size(d);
        x.Ndims=length(x.dim);
        isbruker=1;
    catch
        [pax fix ex]=fileparts(fname);
        if strcmp(ex,'.nii')
            [hd d]=rgetnii(fname);
            
            x=hd(1);
            x.fname=fname;
            x.dim=size(d);
            x.Ndims=length(x.dim);
            isbruker=0;
        end
    end
    
end



 


info={[' #kr ' fname ]};
info=[info; struct2list(x);{' '}];

if isbruker==1
    try
        %     x=bh.v;      ;
        %     info=[info;  {' #yg VISU-PARS  ------------------------'};  struct2list(x) ;{' '}];     % {' #yg PARAMS  ------------------------'}; info(2:end)];
        
        x=preadfile(strrep(fname,'2dseq','visu_pars'));
        info=[info;  {' #yg VISU-PARS  ------------------------'}; x.all ;{' '}];     % {' #yg PARAMS  ------------------------'}; info(2:end)];
        
    end
    try
        %     x=bh.m;
        %     info=[info;  {' #yg METHOD  ------------------------'};  struct2list(x) ;{' '}];     % {' #yg PARAMS  ------------------------'}; info(2:end)];
        x=preadfile(fullfile(fileparts(fileparts(fileparts(fname))),'method'));
        info=[info;  {' #yg METHOD  ------------------------'}; x.all ;{' '}];     % {' #yg PARAMS  ------------------------'}; info(2:end)];
        
    end
    try
        %     x=bh.a;
        %     info=[info;  {' #yg ACQP  ------------------------'};  struct2list(x) ;{' '}];     % {' #yg PARAMS  ------------------------'}; info(2:end)];
        x=preadfile(fullfile(fileparts(fileparts(fileparts(fname))),'acqp'));
        info=[info;  {' #yg ACQP  ------------------------'}; x.all ;{' '}];
        
        
    end
else
    
end
%________________________________________________

us=[];
us.hd=hd;
us.d =d;
us.fname=fname;
us.num=1;
us.info=info;
%________________________________________________



fg;
set(gcf,'userdata',us);
set(gcf,'name',fname,'KeyPressFcn',@keypress);
set(gcf,'WindowButtonMotionFcn', @motion);
showimagenum;


s1 = uicontrol('Style', 'slider','units','norm',...
    'Position', [.3 .97 .25 .02],'tag','slidlowvalue','tooltipstring','intensity: low-threshold',...
    'Min',1,'Max',50,'Value',41,'callback',{@sliderIntensityThresh,1});
s2 = uicontrol('Style', 'slider','units','norm',...
    'Position', [.3 .95 .25 .02],'tag','slidhighvalue','tooltipstring','intensity: high-threshold',...
    'Min',1,'Max',50,'Value',41,'callback',{@sliderIntensityThresh,2});

%   us=get(gcf,'userdata')
%   mima=[min(us.d(:)) max(us.d(:)) ]
mima=[0 1];
set(s1,'value',mima(1));
set(s1,'min',mima(1));
set(s1,'max',mima(2));

set(s2,'value',mima(2));
set(s2,'min',mima(1));
set(s2,'max',mima(2));




s1 = uicontrol('Style', 'togglebutton','units','norm',...
    'Position', [.55 .95 .04 .04],'string','<HTML>I<sub>data','tooltipstring','intensity: DATA (min - max)',...
    'callback',{@sliderIntensityThresh,3},'fontsize',6,'tag','buttintens1');
s2 = uicontrol('Style', 'togglebutton','units','norm',...
    'Position', [.59 .95 .04 .04],'string','<HTML>I<sub>image','tooltipstring','intensity: IMAGE (min - max)',...
    'callback',{@sliderIntensityThresh,4},'fontsize',6,'tag','buttintens2');

s3 = uicontrol('Style', 'togglebutton','units','norm',...
    'Position', [.63 .95 .04 .04],'string','<HTML>I<sub>auto','tooltipstring','intensity: IMAGE autoscale (median+/-2*SD)',...
    'callback',{@sliderIntensityThresh,5},'fontsize',6,'tag','buttintens3');

set(s2,'value',1); % default 

% return

showimage([],[],1);

%% courcour
%% courcour
cr=[...


  NaN    1       1   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   
   1     2       2     1   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   
   1     2       2     1   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   
   NaN   1       1   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   
   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN
   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN
   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN
   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN
   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN
   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN
   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN
   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN
   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN
   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN
   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN
   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN];

set(gcf,'Pointer','custom');
set(gcf,'PointerShapeCData',cr);




  

%     ,...
%         'Callback', @surfzlim); 


%———————————————————————————————————————————————
%%   subs
%———————————————————————————————————————————————

function sliderIntensityThresh(h,e,slidnum)
hs1=findobj(gcf,'tag','slidlowvalue');
hs2=findobj(gcf,'tag','slidhighvalue');

hb1=findobj(gcf,'tag','buttintens1');
hb2=findobj(gcf,'tag','buttintens2');
hb3=findobj(gcf,'tag','buttintens3');

if slidnum<3
    if get(hs1,'value')< get(hs2,'value')
        caxis([get(hs1,'value')  get(hs2,'value') ]);
    end
end
if slidnum==3
    set(hb1,'value',1); set(hb2,'value',0); set(hb3,'value',0);
    
    us=get(gcf,'userdata');
    mima=[min(us.d(:)) max(us.d(:)) ];
    if get(hs1,'min')>mima(1);
        %mima(1)=get(hs1,'min');
        set(hs1,'min',mima(1));
    end
    if get(hs2,'max')<mima(2);
       % mima(2)=get(hs2,'max');
       set(hs2,'max',mima(2));
    end
    
    set(hs1,'value',mima(1));
    set(hs2,'value',mima(2));
     caxis([mima(1) mima(2) ]);
elseif slidnum==4     
    set(hb1,'value',0); set(hb2,'value',1); set(hb3,'value',0);
    us=get(gcf,'userdata');
    %dx=us.d(:,:,us.num);
    caxis auto
    mima=[caxis];
    %     if get(hs1,'min')>mima(1);
    %         %mima(1)=get(hs1,'min');
    %         set(hs1,'min',mima(1));
    %     end
    %     if get(hs2,'max')<mima(2);
    %        % mima(2)=get(hs2,'max');
    %        set(hs2,'max',mima(2));
    %     end
    if get(hs1,'min')>mima(1);
        %mima(1)=get(hs1,'min');
        set(hs1,'min',mima(1));
    end
    if get(hs2,'max')<mima(2);
        % mima(2)=get(hs2,'max');
        set(hs2,'max',mima(2));
    end
    
    set(hs1,'value',mima(1));
    set(hs2,'value',mima(2));
    caxis([mima(1) mima(2) ]);
    
    
    
elseif slidnum==5
    set(hb1,'value',0); set(hb2,'value',0); set(hb3,'value',1);
    us=get(gcf,'userdata');
    me=median(us.d(:));
    sd=2*std(us.d(:));
    mima=[me-sd me+sd];
    if get(hs1,'min')>mima(1);
        mima(1)=get(hs1,'min');
    end
    if get(hs2,'max')<mima(2);
        mima(2)=get(hs2,'max');
    end
    
    set(hs1,'value',mima(1));
    set(hs2,'value',mima(2));
     caxis([mima(1) mima(2) ]);
end



function motion(h,e)


try
    pos=get(gca,'CurrentPoint');
    pos=round(pos(1,1:2));
    pos=fliplr(pos);
    
    d= (get(findobj(gcf, 'type','image'),'cdata'));;
    % disp(pos);
    % disp(size(d));
    if (pos(1)>0 && pos(1)<=size(d,1)) &&  (pos(2)>0 && pos(2)<=size(d,2))
        v=d(pos(1),pos(2)) ;
        magn=sprintf('  %10.5f',v);
        %     disp(sprintf('  %10.5f',v));
        
        mn=[pos(2) pos(1)];
        %     disp(mn)
        te=findobj(gcf,'tag','posmagn');
        if isempty(te)
            te=text(mn(1), mn(2),magn ,'tag','posmagn' ,'color','w');
            set(te,'horizontalalignment','left','fontsize',8,'foregroundcolor','w''fontname',...
                'courier','verticalalignment','center');
        else
            set(te,'position',[mn(1), mn(2) .1 ]);
        end
        set(te,'string',magn);
    end
end

function showimage(h,e,imnum)
us=get(gcf,'userdata');
d =us.d;
hd=us.hd;

if imnum>size(d,4)
   showinfo(imnum);
   return;   
end




ax2=findobj(gcf,'tag','ax2');
if isempty(ax2)
    
    ax2=axes('position',[.3 0.01 .698 .94],'tag','ax2');
    set(ax2,'units','normalized');
end
set(gcf,'currentaxes',ax2);

montage_p(squeeze(fliplr(rot90(d(:,:,:,imnum)))));
set(gca,'tag','ax2');
axis off;
title([  '                              IMG-no. - \color[rgb]{1,0,0}'  num2str(imnum) ],'fontsize',8,'fontweight','bold');

us.num=imnum;
set(gcf,'userdata',us);

%colorize
set( findobj(gcf,'userdata','txtid'),'color',[.7 .7 .7] );
this=findobj(gcf,'type','text' ,'-and','string', [' ' num2str(imnum) ' ']);
set(this,'color','b');
%% colorbar

cb=findobj(gcf,'type','colorbar');
if isempty(cb)
 cb=colorbar;   
end
set(cb,'position',[.25 .03 .02 .3],'fontsize',8,'fontweight','normal','color','k')

%% set MINMAXINFO
dat=d(:,:,:,imnum); dat=dat(:);

hm={};
hm{end+1,1}=[sprintf('min: %4.4g'    ,min(dat))];
hm{end+1,1}=[sprintf('max: %4.4g'    ,max(dat))];
hm{end+1,1}=[sprintf('ME : %4.4g'   ,mean(dat))];
hm{end+1,1}=[sprintf('SD : %4.4g'     ,std(dat))];
hm{end+1,1}=[sprintf('med: %4.4g' ,median(dat))];

te=findobj(gcf,'tag','infomagn');
if isempty(te)
    te=uicontrol('style','edit','units','normalized','position',[0 0 .2 .2],'tag','infomagn' );
    set(te,'horizontalalignment','left','fontsize',8,'backgroundcolor','w','max',100,'fontname','arial');
end
set(te,'string',hm);

s1=findobj(gcf,'tag','slidlowvalue');
s2=findobj(gcf,'tag','slidhighvalue');

mima=caxis;
set(s1,'min', mima(1));
set(s1,'max', mima(2));
set(s1,'value',mima(1));
set(s2,'min', mima(1));
set(s2,'max', mima(2));
set(s2,'value',mima(2));

hb1=findobj(gcf,'tag','buttintens1');
hb2=findobj(gcf,'tag','buttintens2');
hb3=findobj(gcf,'tag','buttintens3');
bvec=[get(hb1,'value') get(hb2,'value') get(hb3,'value')];

sliderIntensityThresh([],[],find(bvec==1)+2);

function showimagenum
us=get(gcf,'userdata');
d =us.d;
hd=us.hd;

hb=axes('position',[0 0.01 .28 .95],'tag','ax1');
set(gcf,'currentaxes',hb);


ns=size(d,4);
no=ns+2;
pp=[.1 1];
for i=1:no
    
    
    
    if i==no-1
       num='info'; col='r';  txtid='info';
    elseif i==no
       num='[help]'; col='m';  txtid='keys';
    else
      num=  num2str(i);col=[.7 .7 .7];txtid='txtid';
    end
    text(pp(1),pp(2) ,[' ' num ' '],'fontsize',8,'fontweight','bold','ButtonDownFcn' ,{@showimage,i},'userdata',txtid,...
    'color',col);
    if mod(i,5)==0; 
        pp(2)=pp(2)-.1; 
        pp(1)=0;  
    end
    pp(1)=pp(1)+.1;
end
ylim([pp(2)-.1 1]);
xlim([.05 .65]);
axis off;
title('4d-Vol-indices','color','k','ButtonDownFcn',{@showinfo})
if no<200;
    ylim([-3.1 1]);
end



 


function showinfo(imnum)

us=get(gcf,'userdata');
extnum=imnum-size(us.d,4);
if extnum==1
   uhelp([us.info],1);
else
   is={};
   is{end+1,1}=[' ##c SHORTCUTS & BUTTONS'];
   is{end+1,1}=[' [click number ] to view the slices of this index in 4th dim           '];
   is{end+1,1}=[' use [leftarrow]&[rightarrow] to do the same         '];
   is{end+1,1}=[' [+/-]  in/decrease fontsize         '];
   is{end+1,1}=[' [info]: shows available infos (header, ...for bruker-2dseq also: visu_pars/method/ACVQ)         '];
   uhelp(is);
end


function keypress(h,ev)
    % Callback to parse keypress event data to print a figure
    if ev.Character == '+'
        lb=findobj(gcf,'type','text');
        fs= get(lb(1),'fontsize')+1;
        if fs>1; 
            set(lb,'fontsize',fs); 
        end
    elseif ev.Character == '-'
        lb=findobj(gcf,'type','text');
         fs= get(lb(1),'fontsize')-1;
        if fs>1; 
            set(lb,'fontsize',fs); 
        end
    end

    
    if strcmp(ev.Key,'rightarrow')
        us=get(gcf,'userdata');
        num=us.num+1;
        if num<=size(us.d,4);
            showimage([],[],num);
            us.num=num;
            set(gcf,'userdata',us);
        end

        
     elseif strcmp(ev.Key,'leftarrow')
         us=get(gcf,'userdata');
        num=us.num-1;
        if num>=1;
            showimage([],[],num);
            us.num=num;
            set(gcf,'userdata',us);
        end   
    end
    
    
    
    
    
    
    
    
    
    