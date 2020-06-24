

% #bo xdraw (xdraw.m)
% manually draw a (multi)-mask  onto a nifti-file as background image
% input: background file and optional a maskfile (for example an unfinished mask)
% for more information see coltrol's tooltips 
% 
% #ok CONTROL ROW-1 ==================
% #g [otsu]         #k: make otsu-clustered image (created in another figure), depends on number 
%                    of otsu-classes
% #g [otsu classes] #k: number of otsu-classes, {2...n}
% #g [3dotsu]       #k: if true,  otsu-clustering is done on the entire 3D-volume (otherwise, slice-wise)
% #g [link]         #k: update otsu-clustering when changing the slice/dimension-view
% 
% #b [unpaint] [u]     #k: remove drawed location, toggle between drawing and unpainting mode
% #b [undo][redo]      #k: undo/redo last steps...note that a change of slice-number/dimension will reset the undo/redo steps
% #b [show legend] [l] #k: show/hide id-legend (colorcode and id)
% 
% #ok CONTROL ROW-2 ==================
% #b [brush type] [t] #k: change brush type, {dot,square, vertical/horizontal line}
% #b [brush size] [up/down arrow ] #k: change brush size,  
% #b [dim] [d] #k: viewing dimension {1,2,3}  
% #b [left arrow] [left arrow] #k: show previous slice   
% #b [dim]      #k: edit a slice number 
% #b [right arrow][right arrow] #k: show next slice  
% 
% #b [transparency]  #k: set transparency  of the mask (2nd image)  range 0-1
% #b [hide mask] [h] #k: hide mask (2nd image) shortly
% #r [value]         #k: set value/ID here which should be entered into the mask
% 
% #b [save]  #k: save image ...saving mode depends on...
% #b [saving options] #k: select here, what should be saved (mask, masked image)
% 
% #b [clear]  #k: clear mask of current slice/clear entire 3d mask
% #b [fill]  #k: fill drawed aread (use mouse to specify the location)
% 

% ====================================================================================
% #b COMMANDLINE
% xdraw(fullfile(pwd,'AVGT.nii'),[]); %without mask
% xdraw(fullfile(pwd,'AVGT.nii'),fullfile(pwd,'AVGThemi.nii'));  %with mask
% xdraw(fullfile(pwd,'t2.nii'),fullfile(pwd,'masklesion.nii')); 
function  xdraw(file,maskfile)
try; delete(findobj(0,'tag','otsu'));end
% ==============================================
%%   file
% ===============================================
if exist('file')~=1
    [fi pa]=uigetfile(fullfile(pwd,'*.nii'),'select BACKGROUND-FILE');
    if isnumeric(fi);
        return;
    end
    file=fullfile(pa,fi);
end
% file=fullfile(pwd,'AVGT.nii')
u.f1=file;
[ha a]=rgetnii(u.f1);

% ==============================================
%%   maskfile
% ===============================================
if exist('maskfile')~=1
    [fi pa]=uigetfile(fullfile(pwd,'*.nii'),'optional, select a MASK-FILE, or hit "cancel"');
    if isnumeric(fi)
        maskfile=[];
    else
        maskfile=fullfile(pa,fi);
    end
end
if isempty(maskfile)
  u.f2=[];
  hb=ha;
  b=zeros(size(a));
else
    % maskfile=fullfile(pwd,'AVGThemi.nii')
    u.f2=maskfile;
    [hb b]=rgetnii(u.f2);
    [h,d ]=rreslice2target(u.f2, u.f1, [], 0);
    hb=h;
    b =d;
    
    uni=unique(b);
    if median(double(round(uni*10)/10==uni ))==0
        b=double(b>0);
    end
end

% ==============================================
%%   
% ===============================================


delete(findobj(0,'tag','xpainter'));
fg;
set(gcf,'units','norm','menubar','none','name','xdraw','NumberTitle','off','tag','xpainter');
makegui;
u.dummy=1;
set(gcf,'userdata',u);

% return
% return
u.him=[];
u.usedim =3;
% u.pensi  =10;
u.alpha  =.5;
u.dotsize=5;
u.dotsizes=([1:200]);





u.a=a; u.ha=ha;
u.b=b; u.hb=hb;

u.dim=u.ha.dim;
u.useslice=round(u.dim(u.usedim)/2);


%---------

colmat = distinguishable_colors(25,[1 1 1; 0 0 0]);
colmat=[colmat([2 1 13:end],:)];
% figure; image(reshape(c,[1 size(colmat)]));
u.colmat=colmat;
% -------------

set(gcf,'userdata',u);


set(findobj(gcf,'tag','dotsize'),'string',num2cell(u.dotsizes),'value',u.dotsize);

setslice();
set(gcf,'WindowButtonMotionFcn', {@motion,1})
set(gcf,'WindowButtonUpFcn'     ,@selstop);
set(gcf,'WindowKeyPressFcn',@keys);
% ==============================================
%%
% ===============================================
function keys(e,e2)

if strcmp(e2.Key,'leftarrow')
    cb_setslice([],[],'-1');
elseif strcmp(e2.Key,'rightarrow')
    cb_setslice([],[],'+1');
elseif strcmp(e2.Key,'uparrow') || strcmp(e2.Key,'downarrow')
    o=findobj(gcf,'tag','dotsize');
    li=get(o,'string'); 
    va=get(o,'value');
    %oldsize=str2num(li{va});
    if strcmp(e2.Key,'uparrow')
    va=va-1;
    elseif strcmp(e2.Key,'downarrow')
        va=va+1;
    end
    if     va>length(li);     va=length(li);
    elseif va<1;              va=1;
    end
    set(o,'value',va);
    definedot([],[]);
    
elseif strcmp(e2.Key,'l');
    o=findobj(gcf,'tag','pb_legend');
    set(o,'value',~get(o,'value'));
    pb_legend([],[]);
elseif strcmp(e2.Key,'d') ;%strcmp(e2.Key,'uparrow') || strcmp(e2.Key,'downarrow')
    e=findobj(gcf,'tag','rd_changedim');
    li=get(e,'string'); va=get(e,'value');
    olddim=str2num(li{va});
%     if strcmp(e2.Key,'uparrow')
        newdim=olddim+1;
%     else
%         newdim=olddim-1;
%     end
    if newdim>3;     newdim=1; 
    elseif newdim<1; newdim=3;end
    set(e,'value',newdim);
    pop_changedim();
% elseif regexpi(e2.Key,['^\d$'])
%    o=findobj(gcf,'tag','edvalue');
%    set(o,'string',e2.Key);
elseif strcmp(e2.Key,'u')
    o=findobj(gcf,'tag','undo');
    if get(o,'value')==0; set(o,'value',1); else; set(o,'value',0); end
    undo();
 elseif strcmp(e2.Key,'h')
     cb_preview();
     
elseif strcmp(e2.Key,'t')
    e=findobj(gcf,'tag','rd_dottype');
    li=get(e,'string'); va=get(e,'value');
    va=va+1; 
    if va>4; va=1; end
    set(e,'value',va);
    definedot([],[]);
elseif strcmp(e2.Key,'c')
    hf1=findobj(0,'tag','xpainter');
    hf2=findobj(0,'tag','otsu');
    if isempty(hf2); return; end
    figure(hf2);
    pb_otsouse(e,e2)
    figure(hf1);
elseif strcmp(e2.Key,'o')    
    pb_otsu([],[],1);
elseif strcmp(e2.Character,'+') 
    hf1=findobj(0,'tag','xpainter');
    he=findobj(hf1,'tag','ed_otsu');
    str=num2str(str2num((get(he,'string')))+1);
    set(he,'string',str);
    hgfeval(get(he,'callback'),he);
    figure(hf1);
elseif strcmp(e2.Character,'-') 
    hf1=findobj(0,'tag','xpainter');
    he=findobj(hf1,'tag','ed_otsu');
    str=str2num((get(he,'string')))-1;
    if str<2; return; end
    
    set(he,'string',num2str(str));
    hgfeval(get(he,'callback'),he);
    figure(hf1);
end

%  e2
% ''

function v2=getslice2d(v3)
hf1=findobj(0,'tag','xpainter');
u=get(hf1,'userdata');
if u.usedim==1
    v2=squeeze(v3(u.useslice,:,:));
elseif u.usedim==2
    v2=squeeze(v3(:,u.useslice,:));
elseif u.usedim==3
    v2=squeeze(v3(:,:,u.useslice));
end


function cb_preview(e,e2)

setslice(1);
drawnow;
pause(.2);
setslice();

function pb_otsu(e,e2,par)
hf1=findobj(0,'tag','xpainter');
figure(hf1);
u=get(hf1,'userdata');

r1=getslice2d(u.a);
r2=getslice2d(u.b);

numcluster=str2num(get(findobj(hf1,'tag','ed_otsu'),'string'));
do3d=get(findobj(hf1,'tag','rd_otsu3d'),'value');
if do3d==1                                         %3d
    if isfield(u,'otsu')==0 || numcluster~= u.otsuclasses
        v=reshape(  otsu(u.a(:),numcluster),[ size(u.a) ]);
        u.otsu=v;
        u.otsuclasses=numcluster;
        set(hf1,'userdata',u);
    end
    ot=getslice2d(u.otsu);
else                                            %2d
    ot=otsu(r1,numcluster);
end

hf2=findobj(0,'tag','otsu');
if isempty(hf2)
    fg;
    set(gcf,'units','norm','menubar','none','name','otsu','NumberTitle','off','tag','otsu');
    pos1=get(hf1,'position');
    pos2=pos1; 
    pos2(1)=(pos2(1)-pos2(3)/2)-.016; pos2(3)=pos2(2)/2;
    set(gcf,'position',pos2);
    hf2=gcf;
%     pointer=nan(16,16); pointer(:,8)=1; pointer(8,:)=1;
%     drawnow
%     set(gcf,'Pointer','custom');drawnow
%     pointer=ones(16,16)*2; pointer(:,8)=1; pointer(8,:)=1;drawnow
%     set(gcf,'PointerShapeCData',pointer);drawnow
%     pointer=nan(16,16)*2; pointer(:,8)=1; pointer(8,:)=1;drawnow
%     set(gcf,'PointerShapeCData',pointer);drawnow

    hb=uicontrol('style','pushbutton','units','norm', 'tag'  ,'pb_otsouse');
    set(hb,'position',[ .1 .9 .5 .05],'string','select class for all slices', 'callback',{@pb_otsouse,3});
    set(hb,'fontsize',7,'backgroundcolor','w');
    set(hb,'tooltipstring',['select class for all slices' char(10) ' ']);
    
    hb=uicontrol('style','radio','units','norm', 'tag'  ,'pb_otsucut');
    set(hb,'position',[ .7 .9 .2 .05],'string','cut cluster', 'callback',{@pb_otsucut,1});
    set(hb,'fontsize',7,'backgroundcolor','w','value',1);
    set(hb,'tooltipstring',['cut cluster' char(10) ' ']);
    
else
    figure(hf2);
end





hp=findobj(hf2,'tag','pb_otsouse');
if do3d==1
    set(hp,'enable','on');
else
    set(hp,'enable','off');
end


him2=imagesc(ot);
caxis([0 max(ot(:))]);
set(him2,'ButtonDownFcn',{@pb_otsouse,1})
set(gca,'units','norm','position',[0 0 .9 .9]);
axis off
set(gcf,'Pointer','arrow');

pb_otsucut([],[],[])

% drawnow
% set(gcf,'Pointer','custom');drawnow
% % pointer=ones(16,16)*2; pointer(:,8)=1; pointer(8,:)=1;drawnow
% % set(gcf,'PointerShapeCData',pointer);drawnow
% % pointer=nan(16,16)*2; pointer(:,8)=1; pointer(8,:)=1;drawnow
% set(gcf,'PointerShapeCData',pointer);drawnow
% set(gcf,'PointerShapeCData',pointer);drawnow
% set(gcf,'pointer','cross');

function pb_otsucut(e,e2,par)
hf=findobj(0,'tag','otsu');
him2=findobj(hf,'Type','image');
if get(findobj(hf,'tag','pb_otsucut'),'value')==1  % CUT-OTSU
    
    set(him2,'ButtonDownFcn',[]);
    set(hf,'WindowButtonDownFcn',{@selcut,1});
    set(hf,'WindowButtonUpFcn' ,{@selcut,0});
    set(hf,'WindowButtonMotionFcn',@otsumotion);
    
    o=get(hf,'userdata');
    o.docut=0;
    set(hf,'userdata',o);
    xl=xlim; yl=ylim; xlim(xl);ylim(yl);
    
% disp(get(gcf,'selectiontype'))

else % transfer cluser
    set(him2,'ButtonDownFcn',{@pb_otsouse,1});
    set(hf,'WindowButtonDownFcn',[]);
    set(hf,'WindowButtonUpFcn' ,[]);
    set(hf,'WindowButtonMotionFcn',[]);
end



function selcut(e,e2,arg)
hf=findobj(0,'tag','otsu');
o=get(hf,'userdata');
o.docut=arg;
if o.docut==1
%     disp(get(gcf,'selectiontype'));
    selectionType=get(gcf,'selectiontype');
    if strcmp(selectionType,'alt')
        pb_otsouse([],[],1)
    end
end
set(hf,'userdata',o);
% disp(o);


function otsumotion(e,e2)
hf=findobj(0,'tag','otsu');
o=get(hf,'userdata');
try
    if o.docut==1
        co=get(gca,'CurrentPoint');
        co=round(co);
        hf=findobj(0,'tag','otsu');
        him2=findobj(hf,'Type','image');
        dx=get(him2,'cdata');
        
        if co(1,2)<=size(dx,1) && co(1,1)<=size(dx,2) && co(1,2)>0 && co(1,1)>0
            dx(co(1,2),co(1,1))=0;
            set(him2,'cdata',dx);
        end
    end
end



function pb_otsouse(e,e2,par)
if exist('par')==0; par=2; end

hf1=findobj(0,'tag','xpainter');
hf2=findobj(0,'tag','otsu');
u=get(hf1,'userdata');

figure(hf2);
if par==2 || par==3
    [x y]=ginput(1);
    set(gcf,'Pointer','arrow');
%     disp('x-y');
%     [x y]
%     disp('cp');
     cor=get(gca,'CurrentPoint');
else
    set(gcf,'Pointer','arrow');
    cor=get(gca,'CurrentPoint');
    x=cor(1,1);  y=cor(1,2);
end
% return
xb=x;
yb=y;

figure(hf1);
dx=get(findobj(hf2,'type','image'),'cdata');
val=dx(round(y),round(x));
valotsu=val;
dx2=bwlabel(dx==val);
m=double(dx2==dx2(round(y),round(x)));


dims=u.dim(setdiff(1:3,u.usedim));
bw = m;
%         if u.usedim==3
r1=getslice2d(u.a);
r2=getslice2d(u.b);
%             r1=u.a(:,:,u.useslice);
%             r2=u.b(:,:,u.useslice);
si=size(r2);
r2=r2(:);
% if type==1
    r2(bw==1)  =  str2num(get(findobj(hf1,'tag','edvalue'),'string'))  ;
% elseif type==2
%     r2(bw==1)  =  0;
% end

r2=reshape(r2,si);

%===== update history
% r2=getslice2d(u.b);
u.histpointer=u.histpointer+1;
u.hist(:,:,u.histpointer)=r2;

% disp(u);
% set(gcf,'userdata',u);




alp=u.alpha;% .8
% val=unique(u.b); val(val==0)=[];
r2v=r2(:);
r1=mat2gray(r1);
ra=repmat(r1,[1 1 3]);

rb=reshape(zeros(size(ra)), [ size(ra,1)*size(ra,2) 3 ]);
val=unique(r2); val(val==0)=[];
for i=1:length(val)
    ix=find(r2v==val(i));
    rb( ix ,:)  = repmat(u.colmat(i,:), [length(ix) 1] );
end
% rb=reshape(rb,size(ra));
s1=reshape(ra,[ size(ra,1)*size(ra,2) 3 ]);
rm=sum(rb,2);
im=find(rm~=0);
s1(im,:)= (s1(im,:)*alp)+(rb(im,:)*(1-alp)) ;
x=reshape(s1,size(ra));


set(u.him,'cdata',   x  );
u=putsliceinto3d(u,r2,'b');
set(gcf,'userdata',u);
him=findobj(gcf,'tag','image');


if par==3 %replace
%%     f = msgbox('this will overwrite the entire mask')
answer = questdlg('this will replace the entire mask over all slices..proceed?', ...
	'', 	'yes','no','dd');
if strcmp(answer,'no'),'return'; end
    
    ot3=u.otsu;
    ot3=double(ot3==valotsu);
    sm=strel('disk',2);
    ot3=imdilate( imerode( ot3  ,sm)  ,sm);
    ot4=bwlabeln(ot3,6);
    
    u.ot4=ot4;
    bv=getslice2d(u.ot4);
    clustnum=bv(round(yb),round(xb));
    ot5=zeros(size(ot4));
    ot5(ot4==clustnum)=str2num(get(findobj(hf1,'tag','edvalue'),'string'));
%     ot3(ot3==1)=str2num(get(findobj(hf1,'tag','edvalue'),'string'));

% montage2(ot5)

    u.b=ot5;
    set(hf1,'userdata',u);
end

drawnow;
figure(hf1);
%----------------
     hf1=findobj(0,'tag','xpainter');       
figure(hf1);




function pb_undoredo(e,e2,direction)
hf1=findobj(0,'tag','xpainter');
u=get(hf1,'userdata');

% if ~histpointer
if direction==-1
    if u.histpointer>1
        u.histpointer=u.histpointer+direction;
    else
        return;
    end
elseif direction==+1
    if u.histpointer<size(u.hist,3)
        u.histpointer=u.histpointer+direction;
    else
        return;
    end
end

r2=u.hist(:,:,u.histpointer);
u=putsliceinto3d(u,r2,'b');
set(gcf,'userdata',u);


setslice([],'noupdate');





function setslice(par,histupdate)
hf1=findobj(0,'tag','xpainter');
u=get(hf1,'userdata');
alp=u.alpha;% .8
if exist('par')==1
    if par==1
        alp=1;
    end
    
end

r1=getslice2d(u.a);
r2=getslice2d(u.b);


if 0
    i=mat2gray(r1);
    i1=imadd(i,100);
    i2=imsubtract(i,50);
    i3=immultiply(i,0.5);
    i4=imdivide(i,0.5);
    i5=imcomplement(i);
%     fg;imagesc(i5); colormap gray
   r1=i5;
end


if exist('histupdate')~=1
    u.hist       =r2;
    u.histpointer=size(u.hist,3);
    set(hf1,'userdata',u);
%     disp(u);
end

% if u.usedim==3
%     r1=u.a(:,:,u.useslice);
%     r2=u.b(:,:,u.useslice);
% end

r1=mat2gray(r1);
ra=repmat(r1,[1 1 3]);

% if 0
%     rx=r2./max(r2(:));
%     rb=cat(3,rx,rx.*0,rx.*0);
% end

val=unique(u.b); val(val==0)=[];
if length(val)>size(u.colmat,1)
    u.colmat=distinguishable_colors(length(val),[1 1 1; 0 0 0]);
    set(hf1,'userdata',u);
end

r2v=r2(:);
rb=reshape(zeros(size(ra)), [ size(ra,1)*size(ra,2) 3 ]);
for i=1:length(val)
    ix=find(r2v==val(i));
  rb( ix ,:)  = repmat(u.colmat(i,:), [length(ix) 1] );
end
% rb=reshape(rb,size(ra));
s1=reshape(ra,[ size(ra,1)*size(ra,2) 3 ]);
rm=sum(rb,2);
im=find(rm~=0);
s1(im,:)= (s1(im,:)*alp)+(rb(im,:)*(1-alp)) ;
x=reshape(s1,size(ra));




if isempty(u.him)
    u.him=image(  x );
    %u.him=image(  (ra*alp)+(rb*(1-alp))   );
else
    set(u.him,'cdata',  x );
    %set(u.him,'cdata',   (ra*alp)+(rb*(1-alp))    );
end
set(findobj(gcf,'tag'  ,'edslice'),'string',u.useslice);
set(findobj(gcf,'tag'  ,'edalpha'),'string',u.alpha);

definedot();
set(u.him,'ButtonDownFcn', @sel);
% set(h  ,'ButtonDownFcn', @sel)
set(gca  ,'ButtonDownFcn', @sel);
set(gcf,'userdata',u);

xlim([0.5 size(ra,2)+.5]);
ylim([0.5 size(ra,1)+.5]);

%otsu updat
hf1=findobj(0,'tag','xpainter');

if get(findobj(hf1,'tag','rd_otsu'),'value')==1
    if exist('histupdate')~=1
        pb_otsu([],[]);
    end
    
    figure(hf1);
end
% ==============================================
%%
% ===============================================

function makegui
u=get(gcf,'userdata');
u.ax=axes('units','norm','position',[0 0 .9 .9]);


%==========================================================================================
%-----CHANGE DIM
str={'1' ,'2' '3'};
hb=uicontrol('style','popupmenu','units','norm', 'tag'  ,'rd_changedim');             %CHANGE-DIM
set(hb,'position',[ .25  .9 .05 .041],'string',str,'value',3,'backgroundcolor','w');
set(hb,'callback',{@pop_changedim});
set(hb,'fontsize',8);
set(hb,'tooltipstring',['change viewing dimension' char(10) '[d] shortcut']);

%=============WHICH SLICE=============================================================================
hb=uicontrol('style','pushbutton','units','norm', 'tag'  ,'prev');           %SETL-prev-SLICE
set(hb,'position',[ .35 .9 .05 .04],'string',char(8592), 'callback',{@cb_setslice,'-1'});
set(hb,'fontsize',8);
set(hb,'tooltipstring',['view previous slice' char(10) '[left-arrow] shortcut' ]);

hb=uicontrol('style','edit','units','norm', 'tag'  ,'edslice');           %EDIT-SLICE
set(hb,'position',[ .4 .9 .05 .04],'string','##','callback',{@cb_setslice,'ed'});
set(hb,'fontsize',8);
set(hb,'tooltipstring','select slice number to view');

hb=uicontrol('style','pushbutton','units','norm', 'tag'  ,'next');           %SET-next-SLICE
set(hb,'position',[ .45 .9 .05 .04],'string',char(8594),'callback',{@cb_setslice,'+1'});
set(hb,'fontsize',8);
set(hb,'tooltipstring',['view next slice' char(10) '[right-arrow] shortcut' ]);



%==========================================================================================
%-----dotType
str={'dot' ,'square' 'hline' 'vline'};
hb=uicontrol('style','popupmenu','units','norm', 'tag'  ,'rd_dottype');
set(hb,'position',[ .001  .9 .1 .04],'string',str,'value',1,'backgroundcolor','w');
set(hb,'callback',{@rd_dottype});
set(hb,'fontsize',8);
set(hb,'tooltipstring',['brush type' char(10) '[t] shortcut to alternate between brush types']);

% DOT-SIZE
hb=uicontrol('style','popupmenu','string',{'dotsize'},'value',1,'units','norm','tag','dotsize');
set(hb,'position',[.1  .9 .075 .04],'backgroundcolor','w','tooltipstring','disksize (diameter)');
set(hb,'callback',@definedot);
set(hb,'fontsize',8);
set(hb,'tooltipstring',['brush size']);
%==========================================================================================


% deselect
hb=uicontrol('style','togglebutton','string','unpaint','units','norm','value',0);
set(hb,'position',[.30  .95 .15 .04],'backgroundcolor','w');
set(hb,'callback',@undo,'tag','undo');
set(hb,'fontsize',8);
set(hb,'tooltipstring',['un-paint location' char(10) '[up/down arrow] to change brush size' ]);


%==========================================================================================
    %TRANSPARENCY
hb=uicontrol('style','edit','units','norm', 'tag'  ,'edalpha');        
set(hb,'position',[ .65 .9 .05 .04],'string','##','callback',{@edalpha});
set(hb,'fontsize',8);
set(hb,'tooltipstring',['set transparency {value between 0 and 1}' ]);
%==========================================================================================
%HIDE
hb=uicontrol('style','pushbutton','units','norm', 'tag'  ,'preview');
set(hb,'position',[ .7 .9 .1 .04],'string','hide mask', 'callback',{@cb_preview});
set(hb,'fontsize',8);
set(hb,'tooltipstring',['shortly hide mask' char(10) '[h] shortcut']);
%==========================================================================================
% EDIT-VALUE (value to be set)
hb=uicontrol('style','edit','units','norm', 'tag'  ,'edvalue');
set(hb,'position',[ .85 .9 .05 .04],'string','1');
set(hb,'fontsize',8);
set(hb,'tooltipstring',['value to be set']);

%==========================================================================================
% LAST-STEP
hb=uicontrol('style','pushbutton','units','norm', 'tag'  ,'pb_prevstep');
set(hb,'position',[ .5 .95 .05 .04],'string',' ', 'callback',{@pb_undoredo,-1});

set(hb,'fontsize',7,'backgroundcolor','w');
set(hb,'tooltipstring',['UNDO last step' char(10) '..for this slice only']);
e = which('undo.gif');
%    if ~isempty(regexpi(e,'.gif$'))
[e map]=imread(e);e=ind2rgb(e,map); 
set(hb,'cdata', e);


% NEXT-STEP
hb=uicontrol('style','pushbutton','units','norm', 'tag'  ,'pb_prevstep');
set(hb,'position',[ .54 .95 .05 .04],'string',' ', 'callback',{@pb_undoredo,+1});
set(hb,'fontsize',7,'backgroundcolor','w');
set(hb,'tooltipstring',['REDO last step' char(10) '..for this slice only']);
set(hb,'cdata', flipdim(e,2));



%==========================================================================================
%legend
hb=uicontrol('style','togglebutton','units','norm', 'tag'  ,'pb_legend','value',0);
set(hb,'position',[ .7 .95 .1 .04],'string','show legend', 'callback',{@pb_legend});
set(hb,'fontsize',7,'backgroundcolor','w');
set(hb,'tooltipstring',['show legend' char(10) '[l] shortcut']);


%==========================================================================================
% %load file
% hb=uicontrol('style','pushbutton','units','norm', 'tag'  ,'pb_load','value',0);
% set(hb,'position',[ .0 .95 .1 .04],'string','load file', 'callback',{@pb_load,1});
% set(hb,'fontsize',7,'backgroundcolor','w','fontweight','bold');
% set(hb,'tooltipstring',['load file' char(10) '']);
% %load mask
% hb=uicontrol('style','pushbutton','units','norm', 'tag'  ,'pb_loadmask','value',0);
% set(hb,'position',[ .1 .95 .1 .04],'string','load mask', 'callback',{@pb_load,2});
% set(hb,'fontsize',7,'backgroundcolor','w','fontweight','bold');
% set(hb,'tooltipstring',['(optional) load additional maskfile' char(10) 'mask file will be overlayed']);
%==========================================================================================
%save file
hb=uicontrol('style','pushbutton','units','norm', 'tag'  ,'pb_save');
set(hb,'position',[ .9 .95 .1 .04],'string','save file', 'callback',{@pb_save});
set(hb,'fontsize',7,'backgroundcolor','w','fontweight','bold');
set(hb,'tooltipstring',['save new mask as niftifile' char(10) '']);

%save file-2

hb=uicontrol('style','popupmenu','units','norm', 'tag'  ,'pb_saveoptions');
set(hb,'position',[ .9 .91 .1 .04],'string','r');%, 'callback',{@pb_save2});
set(hb,'fontsize',6,'backgroundcolor','w','fontweight','bold');
set(hb,'tooltipstring',['saving options' char(10) '']);
list={'save: mask [sm]' %'save: masked image [smi]'
    'save: mask-value of 0 is removed from image (filled with 0-values)    [smi00]'
    'save: mask-value of 0 is removed from image (filled with mean-values) [smi0m] ' 
    'save: mask-value of 1 is removed from image (filled with 0-values)    [smi10]' 
    'save: mask-value of 1 is removed from image (filled with mean-values) [smi1m]' 
    };
set(hb,'string',list);

%=========OTSU=================================================================================

%otsu -button
hb=uicontrol('style','pushbutton','units','norm', 'tag'  ,'pb_otsu','value',0);
set(hb,'position',[ .0 .95 .08 .04],'string','otsu', 'callback',{@pb_otsu,1});
set(hb,'fontsize',7,'backgroundcolor','w','fontweight','bold');
set(hb,'tooltipstring',['otsu' char(10) '']);
%otsu -number of classes
hb=uicontrol('style','edit','units','norm', 'tag'  ,'ed_otsu','value',0);
set(hb,'position',[ .08 .95 .04 .04],'string','3', 'callback',{@pb_otsu,1});
set(hb,'fontsize',7,'backgroundcolor','w','fontweight','bold');
set(hb,'tooltipstring',['otsu define number of classes/clusters' char(10) 'xx']);

%3d-otsu
hb=uicontrol('style','radio','units','norm', 'tag'  ,'rd_otsu3d','value',0);
set(hb,'position',[ .12 .95 .08 .04],'string','3dotsu','callback',{@pb_otsu,1});
set(hb,'fontsize',6,'backgroundcolor','w','fontweight','bold');
set(hb,'tooltipstring',['[]2d vs [x]3d otsu' char(10) '']);

%link otsu
hb=uicontrol('style','radio','units','norm', 'tag'  ,'rd_otsu','value',1);
set(hb,'position',[ .2 .95 .08 .04],'string','link');
set(hb,'fontsize',6,'backgroundcolor','w','fontweight','bold');
set(hb,'tooltipstring',['link otsu : always perform otsu when changing the slice number' char(10) '']);

%=========HELP=================================================================================
hb=uicontrol('style','pushbutton','units','norm', 'tag'  ,'pb_help');
set(hb,'position',[ .9 .75 .1 .04],'string','help', 'callback',{@pb_help});
set(hb,'fontsize',7,'backgroundcolor','w','fontweight','bold');
set(hb,'tooltipstring',['more help' char(10) '']);

%=========clear mask=================================================================================
hb=uicontrol('style','popupmenu','units','norm', 'tag'  ,'clear mask');           %SET-next-SLICE
set(hb,'position',[ .9 .7 .1 .04],'string',{'clear slice'; 'clear all slices'},'callback',{@cb_clear});
set(hb,'fontsize',8);
set(hb,'tooltipstring',['clear current slice/clear all slices' char(10) '' ]);


%=========fill something=================================================================================
hb=uicontrol('style','pushbutton','units','norm', 'tag'  ,'fill');           %SET-next-SLICE
set(hb,'position',[ .9 .2 .05 .04],'string','fill','callback',{@cb_fill});
set(hb,'fontsize',8);
set(hb,'tooltipstring',['fill something' char(10) '' ]);



function cb_fill(e,e2)
set(gcf,'WindowButtonMotionFcn', []);
hl=findobj(gcf,'tag','undo'); %set togglebut to painting
if get(hl,'value')==1; set(hl,'value',0); end

va=get(e,'value');
hf1=findobj(0,'tag','xpainter');
u=get(hf1,'userdata');
r1=getslice2d(u.b);
bk=r1;

[x y]=ginput(1);

selstop([],[]);
selstop([],[]);
selstop([],[]);

 sm=strel('disk',1);
 %  r2=imerode( imdilate( r1  ,sm)  ,sm);
r2=imclose( r1  ,sm) ;

r3=imfill(im2bw(r2),[round(y) round(x) ],8);
r4=bwlabel(r3);
clustnum=r4(round(y), round(x));
val=str2num(get(findobj(hf1,'tag','edvalue'),'string'));
r5=bk;
r5(r4==clustnum)=val;

u=putsliceinto3d(u,r5,'b');
set(gcf,'userdata',u);
set(gcf,'WindowButtonMotionFcn', {@motion,1});
setslice([],'moox');



function cb_clear(e,e2)
va=get(e,'value');
hf1=findobj(0,'tag','xpainter');
u=get(hf1,'userdata');
% him=findobj(hf1,'type','image');
r2=getslice2d(u.b)*0;
% set(him,'cdata',   r2  );
u=putsliceinto3d(u,r2,'b');
set(gcf,'userdata',u);
  
    
if va==2
    u.b=u.b.*0;
    set(gcf,'userdata',u);
end

setslice();

function pb_help(e,e2)
uhelp(mfilename);


function pb_save(e,e2)
hf=findobj(0,'tag','xpainter');

u=get(hf,'userdata');
[fi pa]=uiputfile(fullfile(fileparts(u.f1),'*.nii'),'save new mask as..');
if isnumeric(fi); 
    return; 
end

if max(unique(u.b))<=255
    dt=[2 0];
else
    dt=[16 0];
end
so=findobj(hf,'tag','pb_saveoptions');
li=get(so,'string'); va=get(so,'value');
% ==============================================
%%   saveoption
% ===============================================

saveop=li{va};
if ~isempty(regexpi(saveop,'\[sm\]'))
%     11
    c=u.b;
elseif ~isempty(regexpi(saveop,'\[smi00\]'))
%     22
    m=u.b>0;
    c=u.a.*m;
    dt=u.ha.dt;
elseif ~isempty(regexpi(saveop,'\[smi0m\]'))
%     33
     m=u.b>0;
    c=u.a.*m+(m==0).*mean(u.a(:));
    dt=u.ha.dt;
elseif ~isempty(regexpi(saveop,'\[smi10\]'))
%     44
     m=~(u.b>0);
    c=u.a.*m;
    dt=u.ha.dt;
elseif ~isempty(regexpi(saveop,'\[smi1m\]'))
    % 55
    m=~(u.b>0);
    c=u.a.*m+(m==0).*mean(u.a(:));
    dt=u.ha.dt;
end

% montage2(c);

% [smi00] 
% [smi0m] 
%  [smi10] 
% [smi1m] 

% ==============================================
% save
% ===============================================
newmask=fullfile(pa,fi);
rsavenii(newmask,u.hb,c,dt);
try
showinfo2('new mask',u.f1,newmask,13);
end





function pb_legend(e,e2)
u=get(gcf,'userdata');
uni=unique(u.b(:)); uni(uni==0)=[];

hold on;
if isempty(uni)
    pl(1) = plot(nan,nan,'ko','markerfacecolor',[1 0 1]);
    lgstr={'there is nothing in mask'};
else
    for i=1:length(uni)
        pl(i) = plot(nan,nan,'ko','markerfacecolor',u.colmat(i,:));
    end
    lgstr=cellstr(num2str(uni));
end

le=legend(pl,lgstr,'fontsize',5);
set(le,'Location','northeast','tag','xlegend');
% pos=get(le,'position'); 
% pos(3)=pos(3)/5;
% set(le,'position',pos);
% set(le,'Color','none','TextColor',[ 0.9294    0.6941    0.1255],'fontweight','bold');
set(le,'Color','k','TextColor',[ 0.9294    0.6941    0.1255],'fontweight','bold');
if get(findobj(gcf,'tag','pb_legend'),'value')==0
   try; delete(findobj(gcf,'tag','xlegend')); end
end



function pop_changedim(e,e2)
e=findobj(gcf,'tag','rd_changedim');
li=get(e,'string');
va=get(e,'value');
newdim=str2num(li{va});
u=get(gcf,'userdata');
u.usedim=newdim;
u.useslice=round(u.dim(u.usedim)/2);
set(gcf,'userdata',u);
set(findobj(gcf,'tag','edslice'),'string',num2str(u.useslice));
setslice();

function rd_dottype(e,e2)
definedot([],[]);

function edalpha(e,e2,par)
u=get(gcf,'userdata');
u.alpha=str2num(get(e,'string'));
set(gcf,'userdata',u);
set(e,'string',num2str(u.alpha));
setslice();


function cb_setslice(e,e2,par)
u=get(gcf,'userdata');
if strcmp(par,'-1')
    
    if u.useslice>1
        u.useslice=u.useslice-1;
    end
elseif strcmp(par,'+1')
    if u.useslice<u.dim(u.usedim)
        u.useslice=u.useslice+1;
    end
elseif strcmp(par,'ed')
    sl=str2num(get(findobj(gcf,'tag'  ,'edslice'),'string'));
    if sl>0 && sl<=u.dim(u.usedim)
        u.useslice=sl;
    end
end
set(gcf,'userdata',u);
setslice();





% ==============================================
%%
% ===============================================
function selstop(e,e2)
hd=findobj(gcf,'tag','dot');
set(hd,'FaceColor',[0 1 0]);
set(hd,'userdata',0);

u=get(gcf,'userdata');
xylim=[xlim ylim];
co=get(gca,'currentpoint');
% disp('-------------')
% disp(xylim);
% disp(co);
% disp([co(1,1)<xylim(2)   ]); %right
% disp([co(1,2)>0          ]); %UP
if co(1,1)<xylim(2) && co(1,2)>0
    %disp('inIMAGE')
    %---make history
    r2=getslice2d(u.b);
    u.histpointer=u.histpointer+1;
    u.hist(:,:,u.histpointer)=r2;
    
%     disp(u);
    set(gcf,'userdata',u);
end

function sel(e,e2)
hd=findobj(gcf,'tag','dot');
set(hd,'FaceColor',[1 0 0]);
set(hd,'userdata',1);
if get(findobj(gcf,'tag','undo'),'value')==0
    motion([],[], 1);
end



function selectarea(e,e2)
set(gcf,'WindowButtonMotionFcn', {@motion,1})
% set( findobj(gcf,'tag','selectarea') ,'backgroundcolor',[ 1.0000    0.8431         0]);
% set( findobj(gcf,'tag','undo') ,'backgroundcolor',[ 1 1 1]);

function undo(e,e2)
e=findobj(gcf,'tag','undo');
if get(e,'value')==1
set(gcf,'WindowButtonMotionFcn', {@motion,2})
% set( findobj(gcf,'tag','undo') ,'backgroundcolor',[ 1.0000    0.8431         0]);
% set( findobj(gcf,'tag','selectarea') ,'backgroundcolor',[ 1 1 1]);
else
 set(gcf,'WindowButtonMotionFcn', {@motion,1})   
end
% ==============================================
%%
% ===============================================

function definedot(e,e2)

hc=findobj(gcf,'tag','dotsize');
va=get(hc,'value');
li=get(hc,'string');
dia=str2num(li{va});

try; delete(findobj(gcf,'tag','dot')); end
r=dia/2;
th = 0:pi/50:2*pi;
x = r * cos(th) ;
y = r * sin(th) ;
z = x*0;





if get(findobj(gcf,'tag','rd_dottype'),'value')==2;
    x=[-r r r -r];     y=[-r -r r r];
    z=x*0;
elseif get(findobj(gcf,'tag','rd_dottype'),'value')==3;
    x=[-r r r -r];    y=[1 1 2 2];
    z=x*0;
elseif get(findobj(gcf,'tag','rd_dottype'),'value')==4;
    x=[1 2 2 1];  y=[ -r -r r r];
    z=x*0;
end

% % x=r
% % y=r
% z=r*0
co=get(gca,'CurrentPoint');
co=co(1,[1 2]);
x=x+co(1);
y=y+co(2);

hd = patch(x,y,z,'g','tag','dot');
set(hd  ,'ButtonDownFcn', @sel);
set(hd,'userdata',0);

u=get(gcf,'userdata');
u.dotsize=dia;
set(gcf,'userdata',u);


% function undo(e,e2)
% set(gcf,'WindowButtonMotionFcn', {@motion,2})
% set( findobj(gcf,'tag','undo') ,'backgroundcolor',[ 1.0000    0.8431         0]);
% set( findobj(gcf,'tag','selectarea') ,'backgroundcolor',[ 1 1 1]);

% ==============================================
%%
% ===============================================
function motion(e,e2, type)
u=get(gcf,'userdata');
co=get(gca,'CurrentPoint');
co=co(1,[1 2]);

% 'now'
    axlim=[get(gca,'xlim') get(gca,'ylim')];
    set(gcf,'pointer','topl');
    if co(2)<1 || co(1)>axlim(2)  %1 | co(2)<1
        set(gcf,'Pointer','arrow');
        %'u'
    else
        vp=nan(16,16);
%         vp(8,8)=2;
%         set(gcf,'pointer','custom','PointerShapeCData',vp);
        set(gcf, 'Pointer', 'custom', 'PointerShapeCData', NaN(16,16));
        %'a'
        
    end



hd=findobj(gcf,'tag','dot');
xx=get(hd,'XData');
yy=get(hd,'yData');
% x=(x-mean(x))+co(1);
% y=(y-mean(y))+co(2);

xs=(xx-mean(xx))+2;
ys=(yy-mean(yy))+2;

x=xs+co(1);
y=ys+co(2);
set(hd,'xdata',x,'ydata',y);

if get(hd,'userdata')==1  %PAINT NOW
    u=get(gcf,'userdata');
    x2=get(hd,'XData');
    y2=get(hd,'yData');
    
   
    
    dims = u.dim(setdiff(1:3,u.usedim));
    bw   = double(poly2mask(x2,y2,dims(1),dims(2)));
    if type~=0
%         if u.usedim==3
          r1=getslice2d(u.a);
          r2=getslice2d(u.b);
%             r1=u.a(:,:,u.useslice);
%             r2=u.b(:,:,u.useslice);
            si=size(r2);
            r2=r2(:);
            if type==1
                r2(bw==1)  =  str2num(get(findobj(gcf,'tag','edvalue'),'string'))  ;
            elseif type==2
                r2(bw==1)  =  0;
            end
            
            if 0
                r2=reshape(r2,si);
                
                r1=mat2gray(r1);
                ra=repmat(r1,[1 1 3]);
                
                rx=r2./max(r2(:));
                rx(isnan(rx))=0;
                rb=cat(3,rx,rx.*0,rx.*0);
                alp=u.alpha;% .8
                
                set(u.him,'cdata',   (ra*alp)+(rb*(1-alp))    );
                % u.b(:,:,u.useslice)=r2;
                u=putsliceinto3d(u,r2,'b');
                set(gcf,'userdata',u);
                him=findobj(gcf,'tag','image');
            end
            
            %---------------
            r2=reshape(r2,si);
            
%             %---make history
%             
%             u.histpointer=u.histpointer+1;
%             u.hist(:,:,u.histpointer)=r2;
%             
%             disp(u);
%             
%             %------
            
            
            alp=u.alpha;% .8
            val=unique(u.b); val(val==0)=[];
            r2v=r2(:);
            r1=mat2gray(r1);
            ra=repmat(r1,[1 1 3]);
                
            rb=reshape(zeros(size(ra)), [ size(ra,1)*size(ra,2) 3 ]);
            for i=1:length(val)
                ix=find(r2v==val(i));
                rb( ix ,:)  = repmat(u.colmat(i,:), [length(ix) 1] );
            end
            % rb=reshape(rb,size(ra));
            s1=reshape(ra,[ size(ra,1)*size(ra,2) 3 ]);
            rm=sum(rb,2);
            im=find(rm~=0);
            s1(im,:)= (s1(im,:)*alp)+(rb(im,:)*(1-alp)) ;
            x=reshape(s1,size(ra));
            
            
            set(u.him,'cdata',   x  );
            u=putsliceinto3d(u,r2,'b');
            set(gcf,'userdata',u);
            %him=findobj(gcf,'tag','image');
            %----------------
            
    end  %type  
end

% if 0
% 
% le=legend()
% 
% end


function u=putsliceinto3d(u,d2,varnarname)
% u=putsliceinto3d(u,r2,'b');
dum=getfield(u,varnarname);
if u.usedim==1
    dum(u.useslice,:,:)=d2;
elseif u.usedim==2
    dum(:,u.useslice,:)=d2;
elseif u.usedim==3
    dum(:,:,u.useslice)=d2;
end
 u=setfield(u,varnarname,dum);

