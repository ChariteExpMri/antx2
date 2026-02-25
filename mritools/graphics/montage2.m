
% display 2-4d volume
% montage2(IMG) ;%show image
%     -IMG can be NIFTI-file or 2-4d array
%% ADDITONAL PAIRWSE PARAMETER:
% cmap : COLORMAP for cmaps see: help of getCMAP, use o=getCMAP   or   getCMAP('showmaps');
% dim  : -dimension to slice, default: [3]
%        -dim can be used to permute the ND-array, if dim is of size as ndims
%         ecample: [2 3 1 4]  -->permute dimensions of 4D array --> 1st dim is than used to get slices
% makeanimatedgif: create animated gif over volumes: [0,1]; default: [0]
% dt:  delaytime between images for animated gifs
% 
% ===============================================
%% examples
% montage2(fname) ;%show image
% montage2(fullfile(pwd,'img2_Elastix1_rrt2_t1_T1_map_RARE_pfi.nii'))
% show image and make animated gif
% montage2(fullfile(pwd,'img2_Elastix1_rrt2_t1_T1_map_RARE_pfi.nii'),'makeanimatedgif',1);
% show image and make animated gif, saved with specific name 
% montage2(fullfile(pwd,'img2_Elastix1_rrt2_t1_T1_map_RARE_pfi.nii'),'makeanimatedgif',1,'fileout',fullfile(pwd,'test2.gif'));
% smae as above, but change dalytime of animated gif
% montage2('rt2_t1_T1map_RARE_rat220705avg2_7.nii','makeanimatedgif',1,'fileout',fullfile(pwd,'test2.gif'),'dt',0.5);
% 
% change dimension
% montage2(a,'dim',[2]);          %slice alling 2nd dimension
% montage2(a,'dim',[3 2 1 4]);    % permute 4D-volune
% 
%--colormaps--- 
% :for cmaps see: help of getCMAP, use o=getCMAP   or   getCMAP('showmaps');
% montage2(rand(30,30),1);
% montage2(rand(30,30),'cmap',1 );
% montage2(rand(30,30),'cmap','NIH_fire.lut' );



function montage2(fname, varargin)

%     fname: 'O:\data\millward\raw\20160823qing1.Dd1\6\pdata\1\2dseq'
%       dim: [128 128 10 8]
%       mat: [4x4 double]
%        dt: [4 0]
%     Ndims: 4
%__________image______________________________________
%
% fname='O:\Processing_dti\20160624HP_M39\2\pdata\1\2dseq'
p.dummy=0;
p.dim  =3;   %dimension to slice
p.dt   =0.1; %animated gif delaytime 
p.cmap='gray';

if nargin>1
    pin=cell2struct(varargin(2:2:end),varargin(1:2:end),2);
    p=catstruct(p,pin);
end


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
            x.mat=hd(1).mat;
            %plog([],hd(1).mat,0,'','plotlines=0;')
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
%% change dim
if length(p.dim)==1
    if ndims(d)>2
    dimvec=1:ndims(d);
    isdim=find(dimvec==p.dim);
    dimvec2=dimvec;
    dimvec2(3)=isdim;
    dimvec2(isdim)=3;
    d=permute(d, dimvec2);
    end
elseif length(p.dim)==ndims(d)
     d=permute(d, p.dim);
end
%% ===============================================

us=[];
us.figtag='montage2.m';
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

if isfield(p,'cmap')
    if isnumeric(p.cmap) && length(p.cmap)==1
        o=getCMAP(p.cmap);colormap(o);
    else
        try;
            colormap(p.cmap);
        catch
            try
                o=getCMAP(p.cmap); colormap(o);
                '3'
                
            end
            
        end
    end
    
    
end


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



% cm = uicontextmenu(gcf);
% m1 = uimenu(cm,'Text','Menu1');
% m2 = uimenu(cm,'Text','Menu2');

% cm = uicontextmenu(gcf);
% m = uimenu(cm,'Text','Menu1');
% cm.ContextMenuOpeningFcn = @(src,event)disp('Context menu opened');

c = uicontextmenu;
m= uimenu(c,'Label','change colormap','Callback',{@context,'chnagemap'},'separator','on');
set(gcf     ,'UIContextMenu',c);

%% ===============================================
if isfield(p,'makeanimatedgif' ) && p.makeanimatedgif==1
    makeanimatedgif(p);
end
  

%———————————————————————————————————————————————
%%   subs
%———————————————————————————————————————————————
function context(e,e2,arg)
if strcmp(arg,'chnagemap');
    
    fig = ancestor(e,'figure');
    
    % get mouse position in figure coordinates
    oldUnits = fig.Units;
    fig.Units = 'pixels';
    pt = fig.CurrentPoint;   % [x y]
    fig.Units = oldUnits;
    
    % optional: adjust y (popup grows downward)
    popupWidth  = 150;
    popupHeight = 25;
    
     hb= findobj(gcf,'tag','popcmapm');
     if isempty(hb)
         % create popup
         o=getCMAP('html');
         hb=uicontrol('Parent',fig, ...
             'Style','popupmenu', ...
             'String',{'Option 1','Option 2','Option 3'}, ...
             'Units','pixels', 'tag','popcmapm',...
             'Position',[pt(1) pt(2)-popupHeight popupWidth popupHeight],...;
             'callback'  ,{@context,'setCmap'});
         set(hb,'string',o)
     else
        set(hb,'visible','on');
        set(hb, 'Position',[pt(1) pt(2)-popupHeight popupWidth popupHeight] );
     end
    
elseif strcmp(arg,'setCmap')
   hb= findobj(gcf,'tag','popcmapm');
   val=hb.Value;
   o=getCMAP(val);
   colormap(o);
   set(hb,'visible','off');
    
end
 
 


return
    %% ===============================================
    
    o=getCMAP('html');
%     o2=regexprep(o,{'<html>' ,'</html>'},'')
    
    hb=uicontrol('style','popupmenu')
    
    set(hb,'string',o)
    
    
    return
    
    
    s
% str_out : cleaned cell array
str_in=o2
str_out = cell(size(str_in));

for i = 1:numel(str_in)

    s = strtrim(str_in{i});

    % 1) lowercase FONT
    s = regexprep(s,'<\s*FONT','<font');
    s = regexprep(s,'</\s*FONT','</font');

    % 2) quote hex colors
    s = regexprep(s,'color=#([0-9A-Fa-f]{6})','color="#$1"');

    % 3) ensure black is quoted
    s = regexprep(s,'color=black','color="black"');

    % 4) insert closing </font> BEFORE each new <font>
    s = regexprep(s,'(<font[^>]*>)','</font>$1');

    % remove first unnecessary closing
    s = regexprep(s,'^</font>','');

    % 5) add html wrapper
    s = ['<html>' s '</html>'];

    str_out{i} = s;

end

o2=regexprep(str_out,{'<html>' ,'</html>'},'')
     id=selector2(o2,{'colormap'},'iswait',1,'position',[0.0778  0.0772  0.3510  0.8644],'selection','single')
    

    %% ===============================================
    
    
  
    
    
    
    
    
    
    
    
    
    
%     
%      id=selector2(o2,{'colormap'},'iswait',1,'position',[0.0778  0.0772  0.3510  0.8644],'selection','single')
% 
%     %% ===============================================
%     
%       tb={  'cx'     ' 6'    'g33'
%       'b1'     '10'    'g3'
%       'c1'     ' 9'    'f3'
%       'd1'     ' 8'    'd3'
%       'f1'     ' 5'    'c3'
%       'g1'     ' 0'    'b3'
%       'g11'    ' 7'    'a3' }
%   
%   colhtml=getCMAP('html') 
%   
%   id=selector2(tb,{'Nvox' 'Color'  'Label'},'iswait',1,'position',[0.0778  0.0772  0.3510  0.8644]);
%  id=selector2(tb,{'Nvox' 'Color'  'Label'},'iswait',1,'position',[0.0778  0.0772  0.3510  0.8644],'selection','single')
%     
%     
%     %% ===============================================
%     
%     
% end


function makeanimatedgif(p)

%% ===============================================

us=get(gcf,'userdata');
[pa fi]=deal('');
if isfield(us,'fname')
    [pa fi]=fileparts(us.fname);
end
if isfield(p,'fileout')
    [pa fi]=fileparts(p.fileout);
end
if isempty(pa);  pa=pwd; end
if isempty(fi);  fi='test'; end

filename=fullfile(pa,[fi '.gif']);

for i=1:size(us.d,4)
    num=i;
    showimage([],[],num);
    drawnow
    
    
    % --- Capture frame ---
    frame = getframe(gcf);
    im = frame2im(frame);
    [A,map] = rgb2ind(im,256);
    % --- Write to GIF ---
    if i == 1
        imwrite(A,map,filename,'gif','LoopCount',Inf,'DelayTime',p.dt); % 
    else
        imwrite(A,map,filename,'gif','WriteMode','append','DelayTime',p.dt);
    end
    
    
end
showinfo2(['..animated gif'],filename);


%% ===============================================



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
    me=nanmedian(us.d(:));
    sd=2*nanstd(us.d(:));
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
    u=get(gcf,'userdata');
    if strcmp(u.figtag,'montage2.m')~=1; %prevent op on other fig
        return
    end
    

    
    
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
hm{end+1,1}=[sprintf('min: %4.4g'    ,nanmin(dat))];
hm{end+1,1}=[sprintf('max: %4.4g'    ,nanmax(dat))];
hm{end+1,1}=[sprintf('ME : %4.4g'   ,nanmean(dat))];
hm{end+1,1}=[sprintf('SD : %4.4g'     ,nanstd(dat))];
hm{end+1,1}=[sprintf('med: %4.4g' ,nanmedian(dat))];

is_nan=~isempty(find(isnan(dat)));
if is_nan==1; nanstr='yes'; else; nanstr='no'; end
hm{end+1,1}=[sprintf('contains NaN: %s' ,nanstr)  ];

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
px=[.1 .85];
pp=px;
stp_right=0.08;
nplotperrow=5;
for i=1:no
    if i==no-1
       num='info'; col='r';  txtid='info'; stp_right=0.1;  pp(1)=stp_right; pp(2)=pp(2)-.18;
    elseif i==no
       num='[help]'; col='m';  txtid='keys';stp_right=0.1; 
    else
      num=  num2str(i);col=[.7 .7 .7];txtid='txtid';
    end
    ht=text(pp(1),pp(2) ,[' ' num ' '],'fontsize',10,'fontweight','bold','ButtonDownFcn' ,{@showimage,i},'userdata',txtid,...
    'color',col);
    %set(ht,'backgroundcolor',[0.9412    0.9412    0.9412]);
    if mod(i,nplotperrow)==0  
        pp(2)=pp(2)-.12; 
        pp(1)=px(1)-stp_right;  
    end
    pp(1)=pp(1)+stp_right;
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
    
    
    
    
    
    
    
    
    
    