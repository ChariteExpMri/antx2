

%% ===============================================

function sub_mosaic(p);

%% ===============================================

% p.msliceidx  = 'n10'         ;%mosaic: sliceindices to plot: example  'n20', '5' ,[10:20] or '3 10 10
% p.mslicemm   =[]             ;%mosaic: alternative: vec with mm-values  -->this slices will be plotted
% p.mdim       =2              ;%mosaic: dimension to plot [1,2 or 3]
% p.mroco      =[nan nan]      ;%mosaic: number of rows and columns (default: [nan nan]); example: [2 nan] or [nan 5]
% p.mlabelfs   =8              ;%mosaic: mm-labels fontsize
% p.mlabelfmt  ='%2.2f'        ;%mosaic: mm-labels format
% p.mlabelcol  ='r';           ;%mosaic: color of mm-labels
% p.mcbarpos   =[5   20 10 100];%mosaic: cbar-positon (pixels), 1st value is a x-offset relative to plot
% p.mplotwidth =0.89           ;%mosaic: width of plot to allow space for colorbar; default: 0.9 (normalized units)

if 0
    nslice='n20'
    % nslice=20
    % nslice='10 0 20'
    slicemm=[];
    % nslice=[ 5:200]
    % nslice=[ 123:130]
    dim=1;
    % nslic=5
    roco=[nan nan];
    
    if 0
        nslice=[]
        slicemm=[-2:1:2]
    end
end


nslice  = p.msliceidx;
slicemm = p.mslicemm;
if isempty(nslice)==0 && isempty(slicemm)==0
    slicemm=[];
end
roco   = p.mroco ;
dim    = p.mdim ;

%% ===============================================
g={};
for i=1:length(p.f)
    [d ds]=getslices(p.f{1},dim,nslice,slicemm,0 );
    g(i).d=d;
    g(i).ds=ds;
    if i>1% length(p.f)==2
        [o os]=getslices(p.f([1 i])   ,dim,nslice,slicemm,0 );
        g(i).d=o;
        g(i).ds=os;
    end
end
% ===============================================
z=zeros(size(g(1).d)); % label-location
zslice=size(z,3);
z(1,1,:)=[1:zslice];
z=montageout(permute(z,[1 2 4 3 ]),'size',roco);

% mm=1:zslice;
mm=g(1).ds.smm;

for i=1:length(g)
    g(i).d=flipdim(g(i).d,1);
    g(i).d=montageout(permute(g(i).d,[1 2 4 3 ]),'size',roco);
    
%     if size(g(i).d,2)/size(g(i).d,1)>5
%         g(i).d=[g(i).d; zeros(200, size(g(i).d,2))    ]
%     end
    
    if i==1
        if p.bgadjust==1
          %  g(i).d= imadjust(mat2gray(g(i).d));
        end
        
    end
end

% ===============================================
% if 0
%     fg,imagesc(g(1).d)
%     fg,imagesc(g(2).d)
% end
% ===============================================


% ==============================================
%%
% ===============================================


% dx=w.d;

B=g(1).d;
Bv=B(:);
climB = [min(Bv(:)), max(Bv(:))];
Badj=mat2gray(double(B),double(climB));
if length(unique(B(:)))==2
    Bm=B;
else
    Bm=imfill(otsu(B,50)>1,'holes');
end
B = repmat(Badj,[1,1,3]);
%B=Badj;
% ===============================================
if 0
    him1=findobj(ha,'type','image','tag','im1');
    if isempty(him1)
        him1 = imagesc(B);
    else
        him1.CData=B;
    end
    hold on;
    set(him1,'tag','im1');
end
%% ===============================================
% ==============================================
%%   image and axes
% ===============================================

hf=findobj(0,'tag','orthoview');
if isempty(hf)
    figvisible='on';
    if p.hide~=0 ; figvisible='off';     end
    figure('visible',figvisible,'units','normalized','tag','orthoview','numbertitle','off','color','w')
    set(gcf,'menubar','none','toolbar','none')
    %     fg;  set(gcf,'units','normalized','tag','orthoview','numbertitle','off');
    fpos=get(gcf,'position');
    set(gcf,'position', [0.4  fpos(2:end)  ]);
    hf=gcf;
end

sizim=size(g(1).d);
axposspm=[0 0 1 1];
set(0,'CurrentFigure',hf);
axexist=0;
delete(findobj(hf,'type','axes'))

w=g(1);%(ord(i));
ha=findobj(hf,'type','axes','tag',['ax1']);
if isempty(ha)
    ha=axes('units','normalized','position',axposspm(1,:));
    set(ha,'tag',['ax1' ]);
else
    set(ha,'CurrentAxes',ha);
    axexist=1;
end
set(ha,'YDir','reverse');
% ==============================================
%   image props
% ===============================================
% if isnumeric(p.cmap)
%     if length(g)>length((p.cmap))
%         p.cmap=[1 2 3 4 5] ;
%     end
% elseif iscell(p.cmap)
%     if length(g)>length(cellstr(p.cmap))
%         p.cmap={  'gray' 'jet' 'copper'  'hot' 'summer'};
%         p.cmap=[1 2 3 4 5];
%     end
% elseif ischar(p.cmap)
%     if length(g)>length(cellstr(p.cmap))
%         
%     end
% end
% 
% if isempty(p.clim) || size(p.clim,1)~=length(g) || size(p.clim,2)~=2
%     p.clim=nan(length(g), 2);
% end
% 
% alpha=p.alpha;
% if length(alpha)<length(g)
%    alpha=[  1   repmat(alpha,[ 1 length(g)-1 ] )  ] ;
%    p.alpha=alpha;
% end
% 
% thresh=p.thresh;
% if isempty(thresh)
%     p.thresh=nan(length(g), 2);
% end
% 
% if isempty(p.visible) || length(p.visible)~=length(p.f)
%     p.visible=repmat(1,  [1  length(p.f) ]  );
% end
% 
% if ischar(p.mbarlabel)
%     p.mbarlabel=cellstr(p.mbarlabel)
% end
% if length(p.mbarlabel)<length(p.f)
%     p.mbarlabel=repmat(p.mbarlabel, [1 length(p.f)]);
% end

% ==============================================
%%   plot
% ===============================================
%  maps={'gray' 'jet' 'copper'}
%   maps={'copper' 'jet'}
% delete(findobj(hf,'type','axes'))
hold on
for i=1:length(g)
    F=g(i).d;
    if p.value0transp==1
        F(F==0)=nan;
    end
    
    climF=p.clim(i,:);
    Fvec=F(:);
    if isnan(climF(1))==1; climF(1)=min(Fvec)  ;end
    if isnan(climF(2))==1; climF(2)=max(Fvec)  ;end
    if climF(1)==climF(2);    climF(2)=climF(2)+eps; end
    if isnan(climF(1))==1; climF(1)=0      ;end
    if isnan(climF(2))==1; climF(2)=0+eps  ;end
    p.clim(i,:)=climF;
    

    him2=findobj(ha,'type','image','tag',['im' num2str(i)]);
    %hims=findobj(ha,'type','image');
%     try
%         him2del=hims(setdiff(1:length(hims),regexpi2(get(hims,'tag'),'im1|im2')));
%         delete(him2del)
%     end
    %delete(hims)
    if isempty(him2)
        him2 = imagesc(F,climF);
    else
        unfreezeColors(him2)
        him2.CData=F;
    end
    set(him2,'tag',['im' num2str(i)]);
    caxis(climF);
%     if i>1

% # ALPHA #############
        alphadata = p.alpha(i).*(F >= climF(1));
        if length(unique(Bm(:)))>1 %outer mask
            alphadata=alphadata.*Bm;
        end
% # THRESHOLD ############
   athresh=(p.thresh(i,:));
   
   if any(athresh)==1
       if isnan(athresh(1))==0
          % alphadata=alphadata.*(F>athresh(1));
           alphadata(find(F<athresh(1)))=0;
       end
       if isnan(athresh(2))==0
           %alphadata=alphadata.*(F<athresh(2));
            alphadata(find(F>athresh(2)))=0;
           
       end
   end
  set(him2,'AlphaData',alphadata);
  
%   
%   dc=alphadata;
%   dc(find(F>athresh(2)))=0;
%    set(him2,'AlphaData',dc);
   
%         if ~isempty(p.blobthresh)
%             alphadata=alphadata.*(F>p.blobthresh);
%         end
%         set(him2,'AlphaData',alphadata);
% %     end
    
    %unfreezeColors(him2); %drawnow
    if isnumeric(p.cmap)
        cmap=getCMAP(p.cmap(i));
    else
        p.cmap{i};
        cmap=getCMAP(p.cmap{i});
    end
    
    colormap(cmap); drawnow;
    freezeColors;%(him2);
    delete(findobj(hf,'tag',['cbar' num2str(i)]));
    hc=jicolorbar('freeze');
    
   
        %                hc= freezeColors(maps{j-1})
        %                freezeColors(colorbar)
        set(hc,'tag',['cbar' num2str(i)],'userdata','cbar');
     if 0    
        
        set(hc,'position',[.5+i*(0.1) 0.1 .02 .3]);
        
        
        set(hc,'units','pixels');
        bargap=50;
        set(hc,'position',[ 350+(bargap*i)-bargap     p.mcbarpos(2:end)] );
        set(hc,'YColor',p.labelcol,'XColor',p.labelcol);
     end
     %set(hc.YLabel,'string','ww')
     %     posb=p.mcbarpos;
     
     %     uistack(hc,'top');
     
     % visible/invisible
     if  p.visible(i)==1
         set(him2,'visible','on');
     else
         set(him2,'visible','off');
     end
     
     tx={0  'off'
         1  'on'};
     hba=findobj(hc,'type','image');
     set(hc ,'visible',tx{p.cbarvisible(i)+1,2});
     set(hba,'visible',tx{p.cbarvisible(i)+1,2});
     
     
end
uistack(findobj(hf,'userdata','cbar'),'top');






% ==============================================
%%   tests
% ===============================================
if 0
    no=3
    him2=findobj(hf,'tag',['im' num2str(no)])
    unfreezeColors(him2); %drawnow
    colormap(hot); drawnow
    lims=[  -2.5510    4.3414]
    lims=[  -1 1]
    caxis(lims)
    freezeColors
    
    
    hc=findobj(hf,'tag',['cbar' num2str(no)]);
    pos=get(hc,'position');
    delete(hc);
    
    hc=jicolorbar('freeze');
    set(hc,'tag',['cbar' num2str(no)],'userdata','cbar');
    set(hc,'position',pos)
    uistack(findobj(hf,'userdata','cbar'),'top');
end

%% ===============================================



% if isempty(p.clim);        p.clim= climF;     end
% if isempty(p.clim);        p.clim= climB;     end
%
% caxis(p.clim);
% xl=xlim;yl=ylim;
% set(ha,'tag',['ax' num2str(i)]);


% axis normal
set(ha,'YDir','reverse');
axis tight;     axis image;
set(ha,'xticklabels',[],'yticklabels',[]);
axis off
set(ha,'color',p.axcol);




aspect = get(ha,'PlotBoxAspectRatio');
set(ha,'Units','pixels');
pos = get(ha,'Position');
pos(3) = aspect(1)/aspect(2)*pos(4);
set(ha,'Position',pos);
set(ha,'Units','pixels');

pos=get(ha,'position');
set(ha,'units','normalized');
pos2=get(ha,'position');

bh=pos2(3:4);
% ===============================================
% more=.11;
more=1-p.mplotwidth;
newsiz=bh/max(max(bh));
rat=newsiz(1)/newsiz(2);
if newsiz(1)==1
    newsiz= [1-more  (1-more)/rat ];
elseif  newsiz(2)==1
    
    stp=more:.001:.5;
    cs=1-stp;
    rat=newsiz(2)/newsiz(1);
    
    iu=min(find(cs*rat<=1));
    newsiz=  [ cs(iu)  cs(iu)*rat];
end
if ~isempty(newsiz)
    set(ha,'position',[0 0 newsiz ]);
end



if 0
    % ===========[colorbar]====================================
    delete(findobj(hf,'tag','cbar'));
    delete(findobj(hf,'tag','axcb'));
    
    cb=findobj(gcf,'tag','cbar');
    if isempty(cb)
        ax3=findobj(gcf,'tag','ax1');
        pos=get(ax3,'position');
        axpos=[pos(1)+pos(3)  pos(2)  pos(3:4) ];
        has=axes('position',axpos);
        set(has,'tag',['axcb' ]);
        set(has,'visible','off');
        
        cb=colorbar;
        cbpos=get(cb,'position');
        set(ha,'units','pixels');
        pos=get(ax3,'position');
        
        set(cb,'units','pixels')
        aspect = get(ha,'PlotBoxAspectRatio');
        ratio=aspect(1)/aspect(2);
        ratio=pos(4)/pos(3);
        %posax=[ pos(3)+5   20 10 100 ];
        posax=[ pos(3)+p.mcbarpos(1)  p.mcbarpos(2:end)  ];
        set(cb,'position',posax);
        
        caxis(p.clim);
        
        set(cb,'FontName','Arial Narrow', 'fontsize',p.fs,'tag','cbar');
        set(cb,'color',p.labelcol,'fontweight','bold');
        set(cb, 'YAxisLocation','right');
    end
    
    % if ~isnumeric(p.cmap) && strcmp(p.cmap,'spmhot');
    %     cmap=getmap('hot');
    if isnumeric(p.cmap)
        maps=getCMAP('names');
        cmap=getCMAP(maps{p.cmap});
    else
        try
            cmap=getCMAP(p.cmap);
        catch
            cmap=p.cmap;
        end
    end
    colormap(cmap);
    haxcb=findobj(hf,'tag','axcb' );
    set(hf,'CurrentAxes',haxcb);
    set(ha,'units','normalized');
    set(cb,'units','normalized');
    set(cb.Label,'string', p.cblabel);
    
    set(ha,'color','none');
    set(gcf,'color',p.bgcol);
end

set(ha,'color','none');
set(gcf,'color',p.bgcol);

% ==============================================
%  mm-label
% ===============================================
ht=[];
hold on
set(gcf,'CurrentAxes',ha);
delete(findobj(ha,'tag','mm'));
for i=1:length(mm)
    [co(1,2) co(1,1)]=find(z==i);
    ht(i,1)=text(co(1,1),co(1,2), sprintf([' ' p.mlabelfmt],mm(i) ));
end
set(ht,'color',p.mlabelcol,'fontsize',p.mlabelfs,'fontweight','bold');
set(ht,'VerticalAlignment','cap');
set(ht,'tag','mm');
if p.mlabelshow ==1
   set(ht,'visible','on') ;
else
   set(ht,'visible','off') ; 
end



% ==============================================
%%   cbar-location
% ===============================================
fg_unit=get(hf,'units');
set(hf,'units','pixels');
figpos=get(hf,'position');
set(hf,'units',fg_unit);

%% ===============================================



xshift=p.mcbarpos(1);
hcs=findobj(hf,'userdata','cbar');
n=1;
for i=length(hcs):-1:1
   hc= findobj(hf,'tag',['cbar' num2str(i)]);
   set(hc,'units','pixels');
   posb=[ figpos(3)+xshift-(p.mcbargap.*n)+p.mcbargap p.mcbarpos(2:end) ];
   set(hc,'position',posb);
   n=n+1;
   set(hc,'units','normalized');
   set(hc,'YColor',p.labelcol,'XColor',p.labelcol,'fontsize' , p.mcbarfs);
   %set([hc; get(hc,'children')],'visible','on')
   if ~isempty(p.mbarlabel{i})
       set(hc.YLabel,'string',p.mbarlabel{i});
   end
end
hc= findobj(hf,'tag',['cbar1' ]);
posb1=get(hc,'position');
posf=get(ha,'position');

if p.mcbaralign==1
    set(ha,'position',[posf(1:2)  posb1(1)  posf(4) ]);
else
    set(ha,'position',[posf(1:2)  p.mplotwidth 1 ]);
end
%% ===============================================

% ==============================================
%%
% ===============================================

u.p=p;
% u.gx=gx;
set(gcf,'userdata',u);




