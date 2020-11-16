function montage_slices(us,callbackfun)
%     us.ha    header not needed
%     us.hb    header not needed
%     us.a       %  BG-volume
%     us.b       % ATLAS volume
%     us.c       % EXCELTABLE (col-1: label, col-4:ID, COL-5:children)
%     
%     us.dim          % dimension {1,2,3}        get(findobj(hf1,'tag','dim'),'value');
%     us.do_transp    % transpose image {0,1}    get(findobj(hf1,'tag','transpose'),'value');
%     us.do_flipud    % flipud image {0,1}       get(findobj(hf1,'tag','flipud'),'value');
%     ht=findobj(hf1,'tag','table');
%     us.iuse         %indices to display find(cell2mat(ht.Data(:,1)))+1;
%     
%     
% callbackfun : callback function 
% ==============================================
%%   
% ===============================================

if 0
    
    %% ===============================================================
    hf1=findobj(0,'tag','atlasviewer');
    u=get(hf1,'userdata');
    % us.ha   =u.ha;
    % us.hb   =u.hb;
    us.a    =u.a;
    us.b    =u.b;
    us.c    =u.c;
    
    us.dim       = get(findobj(hf1,'tag','dim'),'value');
    us.do_transp = get(findobj(hf1,'tag','transpose'),'value');
    us.do_flipud = get(findobj(hf1,'tag','flipud'),'value');
    ht=findobj(hf1,'tag','table');
    us.iuse      = find(cell2mat(ht.Data(:,1)))+1;
   
    
    montage_slices(us);
    
    %% ===============================================================
    
end

% ==============================================
%%   
% ===============================================


hf4=findobj(0,'tag','montage');
if isempty(hf4);
    makenewFig=1;
    fg;
    set(gcf,'tag','montage');
else
    makenewFig=0;
    figure(hf4);
end
hf4=findobj(0,'tag','montage');
% ==============================================
%%   
% ===============================================



% %% ===============================================================
% 
% % us.ha   =u.ha;
% % us.hb   =u.hb;
% us.a    =u.a;
% us.b    =u.b;
% us.c    =u.c;
% 
% us.dim       = get(findobj(hf1,'tag','dim'),'value');
% us.do_transp = get(findobj(hf1,'tag','transpose'),'value');
% us.do_flipud = get(findobj(hf1,'tag','flipud'),'value');
% ht=findobj(hf1,'tag','table');
% us.iuse      = find(cell2mat(ht.Data(:,1)))+1;
% 
% %% ===============================================================

id=cell2mat(us.c(:,4));
% col=str2num(char(us.c(:,3)))/255;
us.id   =id(us.iuse);

try
    us.callbackfun= callbackfun;
end
set(hf4,'userdata',us);
drawnow



% ==============================================
%%   
% ===============================================


show_allslices()




function montage_reload(e,e2)
show_allslices();

% ==============================================
%%   
% ===============================================


function show_allslices(e,e2,px)
atim=tic;

% ==============================================
%%   make/get figure
% ===============================================

hf4=findobj(0,'tag','montage');
us=get(hf4,'userdata');


% ==============================================
%%
% ===============================================
waitspin(1,'get data...');
% fprintf('..wait...');
% hf1=findobj(0,'tag','atlasviewer');
% hw=findobj(hf1,'tag','waitnow');
% set(hw,'visible','on','string','..wait..'); drawnow;
% u=get(hf1,'userdata');
% hb=findobj(hf1,'tag','dim');
% dimval=us.dimval; %get(hb,'value');
% dimlist=get(hb,'string');
% dim=str2num(dimlist{dimval});
% dim=
% do_transp=get(findobj(hf1,'tag','transpose'),'value');
% do_flipud=get(findobj(hf1,'tag','flipud'),'value');

dim      =us.dim;
do_transp=us.do_transp;
do_flipud=us.do_flipud;

% ==============================================
%%   
% ===============================================
waitspin(2,'colorize regions...');
% disp(['time1:' num2str(toc(atim))]);
id=cell2mat(us.c(:,4));
col=str2num(char(us.c(:,3)))/255;

% ht=findobj(hf1,'tag','table');
% iuse=find(cell2mat(ht.Data(:,1)))+1;
% id=id(iuse);
iuse =us.iuse;
id   =us.id;
dimother=setdiff(1:3,dim);

if ~isempty(id)
    col=col(iuse,:);
    b=us.b(:);
    bsparse=sparse(b);
    uni=unique(b); uni(uni==0)=[];
    c=single(zeros(size(b,1),3));
    for i=1:length(id)
        %pdisp(i,20);
        ix=find(bsparse==id(i));
        c(ix,:)=repmat( col(  i  ,:) ,[ length(ix) 1]);
    end
    cx=reshape(c,[[size(us.b)] 3]);
    cx=permute(cx, [dimother dim 4]); 
end
bg  =single(permute(us.a, [dimother dim]));
at  =single(permute(us.b, [dimother dim]));


if  isempty(id)
    cx=zeros([size(bg) 3]);
end
% disp(['time2:' num2str(toc(atim))]);


% ==============================================
%%   use only slices with regions
% ===============================================
waitspin(2,'prune slices...');

IDX=[1:size(bg,3)]';


at_slice=us.b(:); 
at_slice=reshape(ismember(at_slice,id), [size(us.b)]);
at_slice=squeeze(sum(sum(permute(at_slice, [dimother dim]),1),2));
IDX=find(at_slice);

isregion=1;
if isempty(IDX)
   IDX=[1:size(bg,3)]';
   isregion=0; 
end

bg=bg(:,:,IDX);
at=at(:,:,IDX);
cx=cx(:,:,IDX,:);


% ==============================================
%%   transpose+flipud
% ===============================================
if do_transp==1
    cx=permute(cx,[2 1 3 4]);
    at=permute(at,[2 1 3 4]);
    bg=permute(bg,[2 1 3 4]);
end
if do_flipud==1
    cx=flipud(cx);
    at=flipud(at);
    bg=flipud(bg);
end
% disp(['time3:' num2str(toc(atim))]);

% ==============================================
%%   crop
% ===============================================
hf4=findobj(0,'tag','montage');
hc=findobj(hf4,'tag','montage_crop');
if isempty(hc)
    docrop=1;
else
    docrop=get(hc,'value');
end



if docrop==1        %------------------------- CROP
    waitspin(2,'crop slices...');

    o=reshape(   otsu(bg(:),3)  ,[size(bg,1) size(bg,2) size(bg,3)])  ;
    cm=mean(o,3)==1 ;%crop
    cm=imerode(cm,strel('square',[2]));
    v.ins_lr=find(mean(cm,1)~=1);
    v.ins_ud=find(mean(cm,2)~=1);
    
    bg     =bg(   v.ins_ud, v.ins_lr,:);  
    at     =at(   v.ins_ud, v.ins_lr,:);  
    cx     =cx(   v.ins_ud, v.ins_lr,:,:);

    if  isempty(id)%    
             o(o==1)=0;
            IDX=find(squeeze(sum(sum(o,1),2))~=0);
            bg  =bg(:,:,IDX);
            at  =at(:,:,IDX);
            cx  =squeeze(cx(:,:,IDX,:));
    end
end
% disp(['time4:' num2str(toc(atim))]);

d=single([]);
d(:,:,1)=montageout(permute(cx(:,:,:,1),[1 2 4 3]));
d(:,:,2)=montageout(permute(cx(:,:,:,2),[1 2 4 3]));
d(:,:,3)=montageout(permute(cx(:,:,:,3),[1 2 4 3]));
% disp(['time5:' num2str(toc(atim))]);

% ==============================================
%%   
% ===============================================
siz3d=size(bg);
bg  =montageout(permute(bg,[1 2 4 3]));
bg=imadjust(bg);
bg=repmat(bg,[1 1 3]); %make 3d


at  =montageout(permute(at,[1 2 4 3]));

slic=repmat(reshape([single(IDX)],     [1 1 length(IDX)]), [siz3d(1) siz3d(2) 1]   ); %sliceCode
slic  =montageout(permute(slic,[1 2 4 3]));

% ==============================================
%%   %%label-cords
% ===============================================
waitspin(2,'prep labels...');

% disp(['time6:' num2str(toc(atim))]);
TX=single(zeros(siz3d));
TX(1,1,:)=IDX;
TX=montageout(permute(TX,[1 2 4 3]));
TXsparse=sparse(double(TX));      %faster
[laco(:,1) laco(:,2)]=find(TXsparse);
laco=sortrows(laco,1);
% disp(['time7:' num2str(toc(atim))]);
% ==============================================
%%   fuse image
% ===============================================
alpha=.5;
if sum(d(:))==0
    fus=bg;
else
    fus=(bg.*(1-alpha))+d.*(alpha);
end

% us.c  =u.c; %table
us.fus=fus;
us.bg =bg;
us.ma =d;
us.at =at;
us.slic=slic;
us.docrop=docrop;

 us.pointer=[...
1	2	1	0	0	0	0	0	0	0	0	0	0	0	0	0
2	2	2	0	0	0	0	0	0	0	0	0	0	0	0	0
1	2	1	0	0	0	0	0	0	0	0	0	0	0	0	0
0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
];
 us.pointer(us.pointer==0)=nan;
 
% disp(['time8:' num2str(toc(atim))]);

% ==============================================
%%
% ===============================================



hf4=findobj(0,'tag','montage');
him=findobj(hf4,'type','image');
if isempty(him);
    makenewFig=1;
else
    makenewFig=0;
end

if makenewFig==1
    %fg;
    hf4=gcf;
    set(hf4,'NumberTitle','off','name', 'montage');
    image(fus);
    axis image; axis off;
    title('bg-image & mask');
    
    
    set(gca,'position',[0.05 0 1 1]); %axis normal;
%     hb=uicontrol('style','text','units','norm','string','bg-image & mask');
%     set(hb,'position',[0 0 1 .04],'foregroundcolor','b');
else
    figure(hf4);
    him=findobj(hf4,'type','image');
    set(him,'cdata',us.fus);
end
him=findobj(hf4,'type','image');
set(him,'ButtonDownFcn',@montage_btndown);

set(hf4,'userdata',us,'tag','montage');
delete(findobj(hf4,'tag','slicenum'));

set(gcf,'WindowButtonMotionFcn',@win_motion);



% ==============================================
%%   label slice
% ===============================================
xx=laco(:,2);
yy=laco(:,1);
ll=cellstr(num2str([IDX(:)]));
ll=regexprep(ll,'\s+','');

try; delete(te); end
try; delete(findobj(gcf,'tag','slicenum')); end
% fg;
hold on;
te=text(xx,yy,ll,'color','r');
set(te,'color',[1.0000    0.8431         0],'tag','slicenum');
set(te,'VerticalAlignment','top','fontsize',6,'fontweight','bold');
set(te,'ButtonDownFcn', @showclises_gotoThisSlice);

xlim([.5 size(us.fus,2)]);
ylim([.5 size(us.fus,1)]);

%% ==============================================
%%   
% ===============================================

% ==============================================
%%
% ===============================================
if makenewFig==1;
    
    zoom on;
    % fprintf('done\n');
    
    
    hb=uicontrol('style','text','units','norm','string','Show');
    set(hb,'position',[0 .9+1*.03 .1 .03],'fontsize',7,'backgroundcolor','w','HorizontalAlignment','left','fontweight','bold');
    
    hb=uicontrol('style','radio','units','norm','string','both','value',1,'callback',@montage_post);
    set(hb,'position',[0 .9 .15 .03],'fontsize',7,'backgroundcolor','w','userdata',1,'tag','rd_montage_ovl');
    set(hb,'tooltipstring','show background image [BG] and mask');
    
    hb=uicontrol('style','radio','units','norm','string','[0]BG,[1]Mask','value',0,'callback',@montage_post);
    set(hb,'position',[0 .9-1*.03  .15 .03],'fontsize',7,'backgroundcolor','w','userdata',2,'tag','rd_montage_ovl');
    set(hb,'tooltipstring','show background image [BG] or mask');
    
    
    %slider-TXT
    hb=uicontrol('style','text','units','norm','string','contrast');
    set(hb,'position',[0 .8-0*.03  .15 .03],'fontsize',7,'backgroundcolor','w');
    %slider-ui
    hb=uicontrol('style','slider','units','norm','string','rb','value',0.5,'callback',@montage_slid_contrast);
    set(hb,'position',[0 .8-1*.03  .15 .03],'fontsize',7,'backgroundcolor','w','userdata',[],'tag','montage_slid_contrast');
    set(hb,'tooltipstring','change contrast');
    
%     % =========contour======================================================
%     hb=uicontrol('style','radio','units','norm', 'tag'  ,'montage_contour','value',0);
%     set(hb,'position',[0 .7 .12 .04],'string','contour', 'callback',@montage_post);
%     set(hb,'fontsize',7,'backgroundcolor',[1 1 1],'fontweight','normal');
%     set(hb,'tooltipstring',['show contour' char(10) '-']);
  
    % =========slicenumber======================================================
    hb=uicontrol('style','radio','units','norm', 'tag'  ,'montage_slicenumber','value',1);
    set(hb,'position',[0 .7 .15 .04],'string','show sliceNo', 'callback',@montage_slicenumber);
    set(hb,'fontsize',7,'backgroundcolor',[1 1 1],'fontweight','normal');
    set(hb,'tooltipstring',['show slice number' char(10) '-']);
   % =========crop======================================================
    hb=uicontrol('style','radio','units','norm', 'tag'  ,'montage_crop','value',1);
    set(hb,'position',[0.0017857 0.61786 0.12 0.04],'string','crop slices', 'callback',@montage_reload);
    set(hb,'fontsize',7,'backgroundcolor',[1 1 1],'fontweight','normal');
    set(hb,'tooltipstring',['crop slices for better montage' char(10) '-']);
   % =========axis normal/image======================================================
    hb=uicontrol('style','radio','units','norm', 'tag'  ,'montage_axisnormal','value',1);
    set(hb,'position',[0.0017857 0.57976 0.12 0.04],'string','axis normal', 'callback',@montage_axisnormal);
    set(hb,'fontsize',7,'backgroundcolor',[1 1 1],'fontweight','normal');
    set(hb,'tooltipstring',['axis normal/image' char(10) '-']);
    
    
     % =========dimension======================================================
    hb=uicontrol('style','popupmenu','units','norm', 'tag'  ,'change_dim','value',2);
    set(hb,'position',[0.0017857 0.50 0.07 0.04],'string',{'1' '2' '3'}, 'callback',@change_dim);
    set(hb,'fontsize',7,'backgroundcolor',[1 1 1],'fontweight','normal');
    set(hb,'tooltipstring',['change dimension/orientation' char(10) '-']);

    % =========reload======================================================
    hb=uicontrol('style','pushbutton','units','norm', 'tag'  ,'montage_reload');
    set(hb,'position',[0.0017857 0.96071 0.12 0.04] ,'string','reload', 'callback',@montage_reload);
    set(hb,'fontsize',7,'backgroundcolor',[0.8392    0.9098    0.8510],'fontweight','normal');
    set(hb,'tooltipstring',['reload data']);
    
    
%     set(findobj(hf4,'type','uicontrol'),'units',  'pixels');
 
else
    set(findobj(gcf,'tag','rd_montage_ovl','-and','userdata',1),'value',1);
    set(findobj(gcf,'tag','rd_montage_ovl','-and','userdata',2),'value',0);
end


montage_axisnormal();

%  montage_slid_contrast();
% set(hw,'visible','off');
disp(['timeF:' num2str(toc(atim))]);
waitspin(0,'Done!');
















% ==============================================
%%   
% ===============================================

function change_dim(e,e2)
hd=findobj(gcf,'tag','change_dim');
hf4=findobj(0,'tag','montage');
us=get(hf4,'userdata');
us.dim=get(hd,'value');
set(hf4,'userdata',us);

show_allslices();

function win_motion(e,e2)
try
    hf1=findobj(0,'tag','montage');
    figure(hf1);
    us=get(hf1,'userdata');
    hunderpointer=hittest(hf1);
    % get(hunderpointer,'tag')
    % strcmp(get(hunderpointer,'tag'),'slicenum')
    % % if strcmp(get(hunderpointer,'type'),'figure')
    % %     set(gcf,'Pointer','arrow','PointerShapeHotSpot',[1 1])
    if strcmp(get(hunderpointer,'type'),'image') || strcmp(get(hunderpointer,'tag'),'slicenum');
        set(gcf,'Pointer','custom','PointerShapeCData',us.pointer,...
            'PointerShapeHotSpot',[2 2]);
    else
        set(gcf,'Pointer','arrow','PointerShapeHotSpot',[1 1])
    end
    % return
    
    try
        co=get (gca, 'CurrentPoint');  co=round(co(1,1:2));
        ID=squeeze(us.at(co(2),co(1)));
        label=us.c{cell2mat(us.c(:,4))==ID,1};
        % disp([label ' ID-' num2str(ID)]);
        set(gcf,'name', [label ' [ID-' num2str(ID) ']'] );
    catch
        
        set(gcf,'name', '' );
        
    end
end



function montage_btndown(e,e2)
co=get (gca, 'CurrentPoint');  co=round(co(1,1:2));
us=get(gcf,'userdata');

ht=findobj(gcf,'string',num2str(us.slic(co(2),co(1))),'-and','tag','slicenum');
showclises_gotoThisSlice(ht,e2);



% ==============================================
%%   
% ===============================================

function montage_slicenumber(e,e2)
hb=findobj(gcf,'tag','montage_slicenumber');
if hb.Value==1
    set(findobj(gcf,'tag','slicenum'),'visible','on');
else
   set(findobj(gcf,'tag','slicenum'),'visible','off'); 
end


function showclises_gotoThisSlice(e,e2)
 
try
drawnow
str=str2num(get(e,'string'));

us=get(gcf,'userdata');
hgfeval(us.callbackfun,str);
end
return

% hf1=findobj(0,'tag','atlasviewer');
% str=get(e,'string');
% figure(hf1);
% 
% hb=findobj(hf1,'tag','ed_slice');
% set(hb,'string',str);
% hgfeval(get(hb,'callback'),[],[]);

% cb_setslice([],[],'ed');
% 
% hd=findobj(hf1,'tag','dot');
% set(hd,'userdata',0);


% hb=uicontrol('style','radio','units','norm','string','Mask','value',0,'callback',@montage_post);
% set(hb,'position',[0 .9-2*.03  .12 .03],'fontsize',7,'backgroundcolor','w','userdata',3,'tag','rd_montage_ovl');
function montage_slid_contrast(e,e2)
% uv=get(gcf,'userdata')
% hb=findobj(gcf,'tag','montage_slid_contrast');
% val=get(hb,'value');
% him=findobj(gca,'type','image');
% d=get(him,'cdata');
% set(him,'cdata',d.*(val*3));
hf4=findobj(0,'tag','montage');
hd=findobj(hf4,'tag','rd_montage_ovl');
hf=hd(find(cell2mat(get(hd,'value'))));
montage_post(hf,[]);

function montage_axisnormal(e,e2,px)
montage_post();

function montage_post(e,e2)
hf4=findobj(0,'tag','montage');
hd=findobj(hf4,'tag','rd_montage_ovl');
us=get(gcf,'userdata');
% get(e,'userdata')

hs=[findobj(hd,'userdata',1) findobj(hd,'userdata',2)];
rd=cell2mat(get(hs,'value'));
if  rd(1)==1 && rd(2)==0
    im=us.fus;%
elseif rd(1)==0 && rd(2)==1
    im=us.ma;
elseif rd(1)==0 && rd(2)==0
    im=us.bg;
elseif rd(1)==1 && rd(2)==1
    
    im=us.ma;
end

him=findobj(gca,'type','image');
hb=findobj(gcf,'tag','montage_slid_contrast');
val=get(hb,'value');
% if get(e,'userdata')==1
%     im2=im*val*2;
% else
%     im2=im*val*2;
% end
im2=im*val*2;
set(him,'cdata',im2);

% ----contour
if 0% docontour==1
    
hold on;
hf1=findobj(0,'tag','xpainter');
u=get(hf1,'userdata');
uni=unique(us.mask); uni(uni==0)=[];



docontour=get(findobj(gcf,'tag','montage_contour'),'value');
delete(findobj(gca,'type','contour'));
delete(findobj(gca,'tag','mycontour'));

    %———————————————————————————————————————————————
    %%
    %———————————————————————————————————————————————
    delete(findobj(gca,'type','contour'));
    delete(findobj(gca,'tag','mycontour'));
    hold on;
    %     delete(findobj(gca,'type','contour'));
    %     contour(us.mask,length(uni),'linewidth',1);
    %     colormap(u.colmat(uni,:));
    %     %colorbar
    %     %caxis([0 size(u.colmat,1)]);
    %     try; caxis([1 max(uni)]); end
    %
    
    c=contourc(us.mask,length(uni));
    if isempty(c); return; end
    
    c2=contourdata(c);
    msk2=us.mask(:);
    uni=[unique(msk2)]; uni(uni==0)=[];
    %uni=[1 4 5]
    for i=1:length(c2)
        cx=[c2(i).xdata, c2(i).ydata];
        ind = sub2ind(size(us.mask), round(cx(:,2)),  round(cx(:,1)));
        tb=flipud(sortrows([uni histc(msk2(ind),uni) ],2))  ;
        val=tb(1,1);
        if tb(1,2)/length(ind)>30
            val=0;
        end
        %disp([(val)]);
        if val~=0
            hp=plot(c2(i).xdata, c2(i).ydata, 'color',u.colmat(val,:),'tag','mycontour','linewidth',1);
        end
        % disp(i) ;drawnow; pause
    end
    %
    
    
    % ==============================================
    %%
    % ===============================================
end


hd=findobj(hf4,'tag','montage_axisnormal');
figure(hf4);
if get(hd,'value')==1
    axis normal;
    set(gca,'position',[ 0.151         0  .848    1.0000]);
else
    axis image;
    set(gca,'position',[ 0.0500         0    1.0000    1.0000]);
end




function waitspin(status,msg)
if status==1
     hv=findobj(gcf,'tag','waitspin');
     try; delete(hv); end
    try
        % R2010a and newer
        iconsClassName = 'com.mathworks.widgets.BusyAffordance$AffordanceSize';
        iconsSizeEnums = javaMethod('values',iconsClassName);
        SIZE_32x32 = iconsSizeEnums(2);  % (1) = 16x16,  (2) = 32x32
        jObj = com.mathworks.widgets.BusyAffordance(SIZE_32x32, msg);  % icon, label
    catch
        % R2009b and earlier
        redColor   = java.awt.Color(1,0,0);
        blackColor = java.awt.Color(0,0,0);
        jObj = com.mathworks.widgets.BusyAffordance(redColor, blackColor);
    end
    % jObj.getComponent.setFont(java.awt.Font('Monospaced',java.awt.Font.PLAIN,1))
    jObj.setPaintsWhenStopped(true);  % default = false
    jObj.useWhiteDots(false);         % default = false (true is good for dark backgrounds)
    [hj hv]=javacomponent(jObj.getComponent, [10,10,80,80], gcf);
    set(hv,'units','norm');
    set(hv,'position',[.6 .2 .20 .20]);
    set(hv,'tag','waitspin')
    jObj.getComponent.setBackground(java.awt.Color(1.0, 0.78, 0.0));  % orange
    jObj.start;
    
    
    hv=findobj(gcf,'tag','waitspin');
%     us=get(gcf,'userdata');
%     us.hwaitspin =hv;
%     us.jwaitspin =jObj;
%     set(gcf,'userdata',us);
    setappdata(hv,'userdata',jObj);
    
elseif status==2
    hv=findobj(gcf,'tag','waitspin');
    jObj=getappdata(hv,'userdata');
%     us=get(gcf,'userdata');
%     jObj=us.jwaitspin;
    jObj.setBusyText(msg); %'All done!');
    jObj.getComponent.setBackground(java.awt.Color(1.0, 0.78, 0.0));  % orange
    set(hv,'visible','on');
    drawnow;
elseif status==0
     hv=findobj(gcf,'tag','waitspin');
    jObj=getappdata(hv,'userdata');
    %us=get(gcf,'userdata');
    %jObj=us.jwaitspin;
    jObj.stop;
    jObj.setBusyText(msg); %'All done!');
    jObj.getComponent.setBackground(java.awt.Color(.4667,    0.6745,    0.1882));  % green
%     pause(.2);
    %jObj.getComponent.setVisible(false);
    %set(us.hwaitspin,'visible','off');
    set(hv,'visible','off');
end


