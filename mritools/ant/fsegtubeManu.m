%% #lk *** MANUAL tube segmentation *** 
% v=fsegtubeManu(f1,volnum)
% ------------------------------------------------------------------------
% Use this function if you have several animal in one Nifti-image.
% Max-projection over the selected dimension is used. So mask must be drawn only once for each animal.
% Here we generate simple masks, one for each animal. Mask can drawn via free-hand or rectangle option.
% The masks wil be than "extended" over the collapsed (hidden) dimension. 
% Beware to select the optimal dimension first.
% 
% #lk *** Procedure to segment animals amnually ***
% #b DIMENSION #n Select the optimal dimension for Maxprojection (pulldown: dim1,dim2 or 
%      dim3).  #r This paramter can't be changed afterwards.
% #b COLORMAP #n Select optimal colormap. default #g "gray"
% #b Number of masks #n Select the number of mask/animals. If there are three animals im the
%      image select "3". #r This paramter can't be changed afterwards.
% #b listbox #n The listbox dipicts drawn masks and unpainted masks 
% #g "msk-1" internally refers to mask-number 1; "msk-2" refers to mask-number 2 etc.
% [1] Select a mask from the listbox: Example: Select "msk-1 ...unpainted". 
% [2] from #k pulldown menu #n select #g freehand #n or #g rectange #n drawing type. Rectangle is faster.
% [3] Click #b [draw] #n button #n to draw. Now draw the mask. 
%     Note, an [accept]-button appears when clicking the [draw] button. 
% [4] Click #b [accept] #n button #n to accept this mask.
% -------------------------------------------------------------------------------------------
%  * The painted mask will appear semitransparent onto the image. To know which mask belongs 
%    to which mask-number (msk-1..1; msk-2...2; etc.) you can click on the items in the listbox.
%    The respective mask will shortly disappear.
%  * use Contextmenu of the Listbox to show all masks in a separate window.
%  #r * use keyboard shortcuts #n to select a mask, draw mask and accept mask.
% -------------------------------------------------------------------------------------------
% [5] When finished click #b [OK].
% #r * IF masks overlap, the overlapping parts will be removed in the resulting output image. 
% 
% #lk *** SHORTCUTS ***
% [up/down] keys : to go up/down in the listbox, i.e. select previous/subsequent mask
% [d]            : draw mask
% [a] or [space] : accept mask
%
% #lk *** Comandline ***
% v=fsegtubeManu(f1,volnum)
% f1:     fullpath filename of  of the nifti-file
% volnum: idx of the volume (for 4D data, default is 1)
% #b --> see xsegmenttubeManu;

function v=fsegtubeManu(f1,volnum)
% clc; 
warning off;


if exist('volnum')~=1; volnum=1; end
[ha a]=rgetnii(f1,volnum);

u.isOK=0;
u.ha=ha;
u.a =a;
u.f1=f1;


% ==============================================
%%   make figure
% ===============================================

delete(findobj(gcf,'tag','segmanu'));
fg;
u.him=imagesc(squeeze(max(a,[],3)));
set(gcf,'units','norm','tag','segmanu','NumberTitle','off',...
    'name',['munual segmentation' '[' mfilename '.m]' ]);
axis off
set(gcf,'userdata',u);
axis image;axis normal;
pos=get(gca,'position');
set(gca,'position',[.001 pos(2:end)  ]);
set(gcf,'WindowKeyPressFcn',@keyx);
[pa fi ext]=fileparts(f1);
ti=title({['file: ' fi ext];['path: ' pa]},'fontsize',8,'interpreter','none',...
    'backgroundcolor',repmat(.9,[1 3]));
set(ti,'units','norm')
tpos=get(ti,'position');
set(ti,'position',[0  tpos(2)+.01 tpos(3) ],'HorizontalAlignment','left');
% ==============================================
%%   controls
% ===============================================

%% DIMENSION
 hb=uicontrol('style','popupmenu','units','norm','string',{'dim1' ,'dim2' ,'dim3'});
 set(hb,'position',[ 0.01 0.01 .1 .05])
 set(hb,'tooltipstring','dimension to show');
 set(hb,'callback',@xdim,'value',3,'tag','xdim');

 %% CMAP
 cmap={'gray','jet' 'parula'};
 try
     CurrFolder=pwd;
     cd(strcat(matlabroot,'\help\matlab\ref'))
     Colormaps=dir('*colormap_*.png');
     TmpColormapsList={Colormaps.name};
     TmpColormapsList=cellfun(@(S)strrep(S,'colormap_',''),TmpColormapsList,'UniformOutput',false);
     ColormapsList=cellfun(@(S)strrep(S,'.png',''),TmpColormapsList,'UniformOutput',false);
     cd(CurrFolder)
     cmap=[cmap setdiff(ColormapsList,cmap)];
 end
 hb=uicontrol('style','popupmenu','units','norm','string',cmap);
 set(hb,'position',[ 0.11 0.01 .1 .05])
 set(hb,'tooltipstring','colormap');
 set(hb,'callback',@usecmap,'value',1,'tag','xcmap');
 
 
  %% Number of masks-label
  hb=uicontrol('style','text','units','norm','string','number of masks');
 set(hb,'position',[ 0.785 0.95 .2 .03],'backgroundcolor','w','HorizontalAlignment','left');
 set(hb,'tooltipstring','number of masks to draw');
 %% Number of masks
 li=cellstr(num2str([1:20]'));
 hb=uicontrol('style','popupmenu','units','norm','string',li);
 set(hb,'position',[ 0.785 0.9 .1 .05])
 set(hb,'tooltipstring','number of masks to draw');
 set(hb,'callback',@xnummask,'value',2,'tag','xnummask');
 

%% listbox
  hb=uicontrol('style','listbox','units','norm','string','<>');
 set(hb,'position',[ 0.785 0.5 .215 .4]);
 set(hb,'tooltipstring','segments');
 set(hb,'value',1,'tag','xlist');
 
  cmenu=uicontextmenu;
          uimenu(cmenu,'label','show this mask','callback',{@listcontext,'showmask'});
          uimenu(cmenu,'label','show all masks','callback',{@listcontext,'showallmasks'});
          uimenu(cmenu,'label','delete all masks','callback',{@listcontext,'deletemask'});
%           uimenu(cmenu,'Label','Context Menu #2');
%           uimenu(cmenu,'Label','Context Menu #3');
 set(hb,'UIContextMenu',cmenu);
 set(hb,'callback',@xlistCB);

          
  %% radio freehand vs imrect
 hb=uicontrol('style','popupmenu','units','norm','string',{'rectangle' 'freehand'});
 set(hb,'position',[ 0.785 0.4 .12 .05])
 set(hb,'tooltipstring','form of drawing');
 set(hb,'tag','xdrawingtype');
 
 
 %% pb Draw
 hb=uicontrol('style','pushbutton','units','norm','string','draw');
 set(hb,'position',[ 0.785 0.45 .1 .05])
 set(hb,'tooltipstring','draw mask');
 set(hb,'callback',@xdrawmask,'tag','xdrawmask');
 
  %% pb accept
 hb=uicontrol('style','pushbutton','units','norm','string','accept');
 set(hb,'position',[ 0.885 0.45 .1 .05])
 set(hb,'tooltipstring','accept mask');
 set(hb,'callback',@xacceptmask,'tag','xacceptmask');
 set(hb,'visible','off');
  set(hb,'backgroundcolor',[1 1 0]);
 
  
  %% pb ok
 hb=uicontrol('style','pushbutton','units','norm','string','ok');
 set(hb,'position',[ 0.785 0.01 .1 .05]);
 set(hb,'tooltipstring','ok,mask drawn..proceed');
 set(hb,'callback',@xok,'tag','xok');
 
 
   %% pb cancel
 hb=uicontrol('style','pushbutton','units','norm','string','cancel');
 set(hb,'position',[ 0.885 0.01 .1 .05]);
 set(hb,'tooltipstring','cancel this');
 set(hb,'callback',@xcancel,'tag','xcancel');
  
 
  
   %% pb help
 hb=uicontrol('style','pushbutton','units','norm','string','help');
 set(hb,'position',[ 0.885 0.12 .1 .05]);
 set(hb,'tooltipstring','some help');
 set(hb,'callback',@xhelp,'tag','xhelp');
  
  
 xnummask([],[]);
 usecmap([],[]);
 
 
 uiwait(gcf);


 
 %% out========================================================
 
u=get(gcf,'userdata');



hf=findobj(0,'tag','segmanu');
hdim=findobj(hf,'tag','xdim');
dim=get(hdim,'value');

if isfield(u,'m')==1 && u.isOK==1
    classes=[1:size(u.m,dim)];
    v.classes  =classes(:)';
    v.nclasses =length(classes);
    v.file     =u.f1;
    
    v.dat      =u.a;
    v.dat2d   = montageout(permute(v.dat ,[1 2 4 3]))  ;
    
    
    mbin=u.m>0;
    ms=squeeze(sum(mbin,dim));
    mnan=ms; mnan(mnan>1)=nan;
    ma =squeeze(sum(u.m,dim)).*mnan;
    ma(isnan(ma))=0;
    
    if     dim==1
        v.mask=permute( repmat(ma,[1 1 size(v.dat,dim)]),[3 1 2 ]);
    elseif dim==2
        v.mask=permute( repmat(ma,[1 1 size(v.dat,dim)]),[1 3 2 ]);
    elseif dim==3
        v.mask=repmat(ma,[1 1 size(v.dat,dim)]);
    end
    
    % v.mask     =Ld2;
    v.mask2d  = montageout(permute(v.mask,[1 2 4 3])) ;
else
    v=[];
end
close(hf);

 
% ==============================================
%%   
% ===============================================
function xnummask(e,e2)
hf=findobj(0,'tag','segmanu');
hb=findobj(hf,'tag','xnummask');
hl=findobj(hf,'tag','xlist');

va=get(hb,'value');
li=get(hb,'string');
nmask=str2num(li{va});
list={};
for i=1:nmask
    list(i,1)={['msk-'  num2str(i)  ' ..unpainted '] };
end
set(hl,'string',list,'value',1);




function xdrawmask(e,e2)
hf=findobj(0,'tag','segmanu');
hb=findobj(hf,'tag','xacceptmask');
set(hb,'visible','on');

hd=findobj(hf,'tag','xdrawingtype'); 
val=get(hd,'value');
global hfmask
if val==1
    hfmask=imrect();
elseif val==2
hfmask = imfreehand();
end
try
uiwait(hf);
% wait(hfmask);
end




function xacceptmask(e,e2)
global hfmask
% Create a binary image ("mask") from the ROI object.
binaryImage = hfmask.createMask();

% fg,imagesc(binaryImage);

hf=findobj(0,'tag','segmanu');
hb=findobj(hf,'tag','xlist');
u=get(gcf,'userdata');
hl=findobj(hf,'tag','xlist');
maskidx=get(hl,'value');
hdim=findobj(hf,'tag','xdim');
dim=get(hdim,'value');
img=double(binaryImage)*maskidx;
if dim==1
    u.m(maskidx,:,:)=img;
elseif dim==2
    u.m(:,maskidx,:)=img;
elseif dim==3
    u.m(:,:,maskidx)=img;
end
set(hf,'userdata',u);

va=get(hl,'value');
list=get(hl,'string');
list{va}=strrep(list{va}, 'unpainted' ,'painted***');
set(hl,'string',list);

hb=findobj(hf,'tag','xacceptmask');
set(hb,'visible','off');

% pos=getPosition(hfmask);
hold on;
% hp=patch([  ],[],'r')

% colorize ------------------------------------------
map=jet;
hlist=findobj(hf,'tag','xlist');
nmask=size(get(hlist,'string'),1);
idx=([1:nmask]-1); 
idx=round(idx./max(idx)*(size(map,1)-1)+1);
col=map(idx,:);

delete(findobj(gcf,'tag','mask'));
for i=1:size(u.m,dim)
    if dim==1
        im= squeeze(u.m(i,:,:));
    elseif dim==2
        im= squeeze(u.m(:,i,:));
    elseif dim==3
        im=squeeze(u.m(:,:,i));
    end
    
    
    % fg,imagesc(im);
    hold on;
    if sum(im(:))>0
        xy=bwboundaries(im);
        xy=xy{1};
        r=fill(xy(:,2),xy(:,1),'r');
        set(r,'FaceAlpha',[ .3],'tag','mask','facecolor',col(i,:));
        set(r,'userdata',['mask' num2str(i)]);
    end
    % r=rectangle('Position',pos);
    % set(r,'facecolor',[1 0 0, .1]);
end


delete(hfmask);
uiwait(gcf);


function xlistCB(e,e2)

hf=findobj(0,'tag','segmanu');
u=get(gcf,'userdata');
hlist=findobj(hf,'tag','xlist');
val=get(hlist,'value');

ob=findobj(hf,'userdata',['mask' num2str(val)]);
if ~isempty(ob)
    for i=1:2
        set(ob,'visible','off');drawnow;
        set(ob,'visible','on');drawnow;
    end
end


function xdim(e,e2)
hf=findobj(0,'tag','segmanu');
u=get(gcf,'userdata');

hb=findobj(hf,'tag','xdim');
dim=get(hb,'value');

a2=squeeze(max(u.a,[],dim));
set(u.him,'cdata',a2);
axis image;axis normal;


function usecmap(e,e2)
hf=findobj(0,'tag','segmanu');
hb=findobj(hf,'tag','xcmap');
va=get(hb,'value');
li=get(hb,'string');
map=li{va};
colormap(map);


function listcontext(e,e2,par)
if strcmp(par,'showmask')
    hf=findobj(0,'tag','segmanu');
    u=get(gcf,'userdata');
    hlist=findobj(hf,'tag','xlist');
    mskidx=get(hlist,'value');
    list=get(hlist,'string');
    hdim=findobj(hf,'tag','xdim');
    dim=get(hdim,'value');
    
    if     dim==1;         ma=squeeze(u.m(mskidx,:,:));
    elseif dim==2;         ma=squeeze(u.m(:,mskidx,:));
    elseif dim==3;         ma=squeeze(u.m(:,:,mskidx));
    end
        
        if sum(ma(:))==0
            msgbox(['no mask found for: "'  list{mskidx} '"']);
            return
        end
    
    
    mbin=u.m>0;
    ms=squeeze(sum(mbin,dim));
    mnan=ms; 
    mnan(mnan>1)=nan;
    
    ma2 =ma.*mnan;
    im =(squeeze(max(u.a,[],dim)));
    nmasks=size(get(hlist,'string'),1);
    ma2(1:nmasks,1)=1:nmasks;

    imoverlay2(im,ma2,[],[],'jet' ); colorbar
    title([list{mskidx}]);
    caxis([0 nmasks])
    
elseif strcmp(par,'showallmasks')
    hf=findobj(0,'tag','segmanu');
    u=get(gcf,'userdata');
    if ~isfield(u, 'm')
        msgbox(['can''t show masks, no masks were created']);
        return
    end
    
    hdim=findobj(hf,'tag','xdim');
    dim=get(hdim,'value');
    mbin=u.m>0;
    
        
    ms=squeeze(sum(mbin,dim));
    mnan=ms; mnan(mnan>1)=nan;
    
    ma =squeeze(sum(u.m,dim)).*mnan;
    im =(squeeze(max(u.a,[],dim)));

    imoverlay2(im,ma,[],[],'jet' );
    title('all masks');
    colorbar;
 elseif strcmp(par,'deletemask')   
    hf=findobj(0,'tag','segmanu');
    u=get(gcf,'userdata');
   try; u=rmfield(u,'m'); end
    set(gcf,'userdata',u);
    xnummask([],[]);
    delete(findobj(hf,'tag','mask'));
end

% function ma=getmask()



function xhelp(e,e2)
uhelp([mfilename '.m']);

function xok(e,e2)
hf=findobj(0,'tag','segmanu');;
u=get(gcf,'userdata');
u.isOK=1;
set(hf,'userdata',u);
 uiresume(gcf);
 
 function xcancel(e,e2)
hf=findobj(0,'tag','segmanu');;
u=get(gcf,'userdata');
u.isOK=0;
set(hf,'userdata',u);
 uiresume(gcf);

function keyx(e,e2)
% e
% e2

hf=findobj(0,'tag','segmanu');
if strcmp(e2.Key,'d')
    xdrawmask([],[]);
elseif strcmp(e2.Key,'a') || strcmp(e2.Key,'space')
    if strcmp(get(findobj(hf,'tag','xacceptmask'),'visible'), 'on')
        xacceptmask([],[]);
    end
elseif strcmp(e2.Key,'uparrow') 
    hlist=findobj(hf,'tag','xlist');
    val=get(hlist,'value')-1;
    if val>0; set(hlist,'value',val); end
elseif strcmp(e2.Key,'downarrow')
    hlist=findobj(hf,'tag','xlist');
    val=get(hlist,'value')+1;
    if val<=size(get(hlist,'string'),1); set(hlist,'value',val); end
    
end
 

% end



