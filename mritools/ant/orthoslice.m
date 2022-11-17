
% #yk orthogonal slice-view
% [varargout]=orthoslice(f, varargin )
% ===============================================
%% optional pairwise parameter
% ===============================================
% p.ce         =[0 0 0];      % coordinate to plot; default: [0 0 0]
% p.alpha      =0.5;          % transparency [0-1]; default: 0.5
% p.mode       ='ovl';        % mode to plot {'def','mask','ovl'}; default: 'ovl'
% p.cmap       ='spmhot';     % colormap (string, 'spmhot' is spms-colormap); default: 'spmhot' 
% p.clim       =[];           % color limit [min max]; default: [] (i.e. use map's min max)
% p.blobthresh =[];           % lower image threshold -->produces blobs; default: [] (so no blobs)
% p.axcol      =[0 0 0];      % axes color; default: [0 0 1]
% p.maskcol    =[.7 .7 .7]    % color of the brainMaks (usefull when "blobthresh" is set)
% p.fs         =9;            % colorbar fontsize; default: 9
% p.cursorcol  =[0 0 1];      % cursorcolor; default: [0 0 1] (i.e spm cursor color)
% p.cursorwidth=0.5;          % cursor width; default: 0.5 
% p.showparams =0;            % display parameter; {0,1}; default: 0
% ===============================================
%% examples
% ===============================================
% orthoslice({'AVGTmask.nii','s.nii'});
% orthoslice({'AVGT.nii','s.nii'});
% orthoslice('s.nii','fs',20,'cmap','parula');
% orthoslice({'AVGTmask.nii','s.nii'},'ce',[0.271 0.026 -3.567],'clim',[-14 18]);
% orthoslice({'AVGT.nii','s.nii'},'mode','ovl')
% orthoslice({'AVGTmask.nii','s.nii'},'mode','mask')
% orthoslice({'AVGTmask.nii','s.nii'},'mode','mask','axcol',[0 0 0],'blobthresh',5);
% orthoslice('s.nii','mode','def','axcol',[1 1 1]);
% orthoslice({'AVGT.nii','s.nii'},'mode','ovl','axcol',[0 0 0],'blobthresh',5,'alpha',1);
% ... spm-like
% orthoslice({'AVGTmask.nii','s.nii'},'mode','ovl','alpha',1);
% orthoslice({'AVGT.nii','s.nii'},'mode','mask');
% orthoslice({'AVGT.nii','s.nii'},'mode','ovl','alpha',.5);
% orthoslice({lab.template,'thresh_svimg__control_LT_mani__FWE0.05k1.nii'},'mode','ovl','alpha',.5,'blobthresh',0);


function [varargout]=orthoslice(f, varargin )
if nargin==0
   orthoslice('s.nii');
   % orthoslice({'AVGTmask.nii','s.nii'});
   % orthoslice({'AVGT.nii','s.nii'});
   % orthoslice('s.nii','fs',20,'cmap','parula');
   %orthoslice({'AVGTmask.nii','s.nii'},'ce',[0.271 0.026 -3.567],'clim',[-14 18]);
   %    orthoslice({'AVGT.nii','s.nii'},'mode','ovl')
   %    orthoslice({'AVGTmask.nii','s.nii'},'mode','mask')
   %  orthoslice({'AVGTmask.nii','s.nii'},'mode','mask','axcol',[0 0 0],'blobthresh',5);
   %orthoslice('s.nii','mode','def','axcol',[1 1 1]);
   %     orthoslice({'AVGT.nii','s.nii'},'mode','ovl','axcol',[0 0 0],'blobthresh',5,'alpha',1);
   %spm-like
   %
   % orthoslice({'AVGTmask.nii','s.nii'},'mode','ovl','alpha',1);
   % orthoslice({'AVGT.nii','s.nii'},'mode','mask');
   % orthoslice({'AVGT.nii','s.nii'},'mode','ovl','alpha',.5);
   %orthoslice({lab.template,'thresh_svimg__control_LT_mani__FWE0.05k1.nii'},'mode','ovl','alpha',.5,'blobthresh',0);

    return
end

% ==============================================
%% pairwise parameter
% ===============================================
p.ce         =[0 0 0];      % coordinate to plot; default: [0 0 0]
p.alpha      =0.5;          % transparency [0-1]; default: 0.5
p.mode       ='ovl';        % mode to plot {'def','mask','ovl'}; default: 'ovl'
p.cmap       ='spmhot';     % colormap (string, 'spmhot' is spms-colormap); default: 'spmhot' 
p.clim       =[];           % color limit [min max]; default: [] (i.e. use map's min max)
p.blobthresh =[];           % lower image threshold -->produces blobs; default: [] (so no blobs)
p.axcol      =[0 0 0];      % axes color; default: [0 0 1]
p.maskcol    =[.7 .7 .7];    % color of the brainMaks (usefull when "blobthresh" is set)
p.fs         =9;            % colorbar fontsize; default: 9
p.cursorcol=[0 0 1];      % cursorcol; default: [0 0 1] (i.e spm cursor color)
p.cursorwidth=0.5;          % cursor width; default: 0.5 
p.showparams =0;            % display parameter; {0,1}; default: 0
%% ========[varinpit]=======================================
if nargin>1
   pin=cell2struct(varargin(2:2:end),varargin(1:2:end),2);
   p=catstruct2(p,pin);
end
if p.showparams==1
    cprintf([0 .5 .8],[ '...PARAMETER'   '"\n']);
    disp(p);
end

% ==============================================
%% 
% ===============================================
delete(findobj(0,'tag','orthoview'));
f=cellstr(f);
p.f=f;
%% ===============================================

update(p)
varargout{1}=gcf;

return

% gx={};
% p.f=f;
% ce=p.ce;
% for i=1:length(f)
%     [gt p]=obtaintslices(f{i},p);
%     gx{1,i}=gt;
% end
% makeimage(gx,p);
% % u.p=p;
% % u.gx=gx;
% % set(gcf,'userdata',u);


function update(p)
gx={};
for i=1:length(p.f)
    [gt p]=obtaintslices(p.f{i},p);
    gx{1,i}=gt;
end
makeimage(gx,p)


%% ===============[button down]================================
function btndown(e,e2)
u=get(gcf,'userdata');
co=get(gca,'CurrentPoint');
co=round(co(1,[1 2]));
% get(gca,'tag')
val=[0];
if strcmp(get(gca,'tag'),'ax1')
    w=u.gx{1}(3);
    lx=linspace(w.x(1),w.x(2),size(w.a,2));
    ly=linspace(w.y(1),w.y(2),size(w.a,1));
    ce=[    u.p.ce(1)     lx(co(1))   ly(co(2))  ];
    
    val(1)=w.a(co(2),co(1));
    if size(u.gx,2)>1
      w2=u.gx{2}(3); 
      val(2)=w2.a(co(2),co(1));
    end
    
    
elseif strcmp(get(gca,'tag'),'ax2')
    w=u.gx{1}(1);
    lx=linspace(w.x(1),w.x(2),size(w.a,2));
    ly=linspace(w.y(1),w.y(2),size(w.a,1));
    ce=[lx(co(1)) u.p.ce(2)  ly(co(2))  ];
    
    val(1)=w.a(co(2),co(1));
    if size(u.gx,2)>1
      w2=u.gx{2}(1); 
      val(2)=w2.a(co(2),co(1));
    end
elseif strcmp(get(gca,'tag'),'ax3')
    w=u.gx{1}(2);
    lx=fliplr(linspace(w.x(1),w.x(2),size(w.a,2)));
    ly=linspace(w.y(1),w.y(2),size(w.a,1));
    ce=[lx(co(2))   ly(co(1)) u.p.ce(3) ];
    
    val(1)=w.a(co(1),size(w.a,2)-co(2)+1);
    if size(u.gx,2)>1
      w2=u.gx{2}(2); 
      val(2)=w2.a(co(1),size(w2.a,2)-co(2)+1);
    end
end

% max(w2.a(:))

p=u.p;
p.ce=ce;
p.val=val;
update(p);
% val
return
%% ===============================================
% % cf
% % 1 coronal
% % 2 axional
% gx={};
% p=u.p;
% p.ce=ce;
% f=p.f;
% for i=1:length(f)
%     [gt p]=obtaintslices(f{i},p);
%     gx{1,i}=gt;
% end
% 
% 
% makeimage(gx,p);
% u.p=p;
% u.gx=gx;
% set(gcf,'userdata',u);
% ==============================================



function makeimage(gx,p)
ce=p.ce;
g=gx{1};
if size(gx,2)==1
    p.mode='def';
end

% p.masktreshold=0.5
if strcmp(p.mode,'mask') && size(gx,2)>1 || strcmp(p.mode,'ovl') && size(gx,2)>1 ...
    || strcmp(p.mode,'blob') && size(gx,2)>1
   g=gx{2};
   ref=gx{1};

  
end
if isempty(p.clim)
    val=[g(1).a(:);g(2).a(:); g(3).a(:)];
    p.clim= [min(val) max(val)];
end
   
 %% ===============================================
lx=linspace(g(1).x(1),g(1).x(2),size(g(1).a,2));
cx=vecnearest2(lx,ce(1));

lz=linspace(g(1).y(1),g(1).y(2),size(g(1).a,1));
cz=vecnearest2(lz,ce(3));

ly=linspace(g(3).x(1),g(3).x(2),size(g(3).a,2));
cy=vecnearest2(ly,ce(2));

idx=[cx cy cz];
idx=idx-1;
%% ===============================================
hf=findobj(0,'tag','orthoview');
if isempty(hf)
    fg;  set(gcf,'units','normalized','tag','orthoview','numbertitle','off');
    hf=gcf;
end
if sum(round(ce==round(ce)))==3; 
    mmstr=sprintf('%d,%d,%d ',ce);
else; 
    mmstr=sprintf('%2.3f,%2.3f,%2.3f ',ce);
end
if isfield(p,'val')
    valstr=num2str(p.val);
else
    valstr='';
end
set(hf,'name',[mmstr sprintf('[%d,%d,%d]',idx) '  ' valstr ]);


ordspm=1;
if    ordspm==1;   ord=[ 3 1 2]; %ord spm
else;              ord=[1 3 2];
end
%         axposspm=[ % original SPM-ortho-position
%             [ 0.1378    0.2684    0.3984    0.2059]
%             [ 0.5504    0.2684    0.3082    0.2059]
%             [ 0.1378    0.0463    0.3984    0.2137]
%             ]
fc=1.8;
gap=0.01;

axposspm=[
    [ 0.12        0.2137*fc+0.12+gap     0.3984    0.2059*fc]
    [ 0.12+0.377    0.2137*fc+0.12+gap     0.3082    0.2059*fc]
    [ 0.12    0.12    0.3984    0.2137*fc]
    ];

axexist=0;

for i=1:3
    w=g(ord(i));
    ha=findobj(gcf,'type','axes','tag',['ax' num2str(i)]);
    if isempty(ha)
        ha=axes('position',axposspm(i,:));
        set(ha,'tag',['ax' num2str(i)])
    else
        axes(ha);
        axexist=1;
    end
    delete(findobj(gca,'type','line'));
    
   
    if ord(i)==2
        dx=flipud(w.a');
    else
        dx=w.a;
    end
    
    
    if strcmp(p.mode,'mask')
        %him=imagesc(dx);
        if ord(i)==2
            ad=ref(ord(i)).a';
        else
            ad=ref(ord(i)).a;
        end
        
        ad2=ad(:);
        bw(1,1,1:3)=p.axcol;
        bv=repmat( bw ,[prod(size(ad)) 1 ] );
        ima=find(ad2==1);
        bv(ima,1,:)=repmat(p.maskcol,[size(ima,1)  1]);
        B=reshape(bv,[ size(ad) 3 ]);
        him1=findobj(ha,'type','image','tag','im1');
        if isempty(him1)
            him1 = imagesc(B);
        else
            him1.CData=B;
        end
        hold on;
        set(him1,'tag','im1');
        % --------------       
        climF=p.clim;
        F=dx;        
        him2=findobj(ha,'type','image','tag','im2');
        if isempty(him2)
            him2 = imagesc(F,climF);
        else
            him2.CData=F;
        end
        set(him2,'tag','im2');
         if ~isempty(p.blobthresh)
            ad=ad.*(dx>p.blobthresh);
         end
        set(him2,'AlphaData',ad);

        set(him1,'ButtonDownFcn',@btndown);
        set(him2,'ButtonDownFcn',@btndown);
        
    elseif strcmp(p.mode,'ovl')
        if ord(i)==2
          B=ref(ord(i)).a';
        else
           B=ref(ord(i)).a; 
        end
       
          Bv=[ref(1).a(:);ref(2).a(:);ref(3).a(:)];
          climB = [min(Bv(:)), max(Bv(:))];
          
          Badj=mat2gray(double(B),double(climB));
          if length(unique(B(:)))==2
             Bm=B; 
          else
              Bm=imfill(otsu(B,50)>1,'holes');
          end
          B = repmat(Badj,[1,1,3]);
          %% ===============================================
          him1=findobj(ha,'type','image','tag','im1');
          if isempty(him1)
              him1 = imagesc(B);
          else
              him1.CData=B;
          end
          hold on;
          set(him1,'tag','im1');
          %% ===============================================
          climF=p.clim;
          F=dx;
          %p.alpha=.5;
          
          him2=findobj(ha,'type','image','tag','im2');
          if isempty(him2)
              him2 = imagesc(F,climF);
          else
              him2.CData=F;
          end
          set(him2,'tag','im2');
          
        
          alphadata = p.alpha.*(F >= climF(1));
          if length(unique(Bm(:)))>1 %outer mask
              alphadata=alphadata.*Bm;
          end
          if ~isempty(p.blobthresh)
              alphadata=alphadata.*(F>p.blobthresh);
          end
          
          set(him2,'AlphaData',alphadata);
         
          
          set(him1,'ButtonDownFcn',@btndown);
          set(him2,'ButtonDownFcn',@btndown);
    else
       him=imagesc(dx); 
    
       
        if ~isempty(p.blobthresh)
            ad=(dx>p.blobthresh);
            set(him,'AlphaData',ad);
        end
      
        
        
        set(him,'ButtonDownFcn',@btndown);
       
    end

    
    
    
    caxis(p.clim);
    xl=xlim;yl=ylim;
    set(gca,'tag',['ax' num2str(i)]);
    
    if ord(i)==1
        hline(cz,'color',p.cursorcol,'linewidth',p.cursorwidth);
        vline(cx,'color',p.cursorcol,'linewidth',p.cursorwidth);
        
    elseif ord(i)==3
        hline(cz,'color',p.cursorcol,'linewidth',p.cursorwidth);
        vline(cy,'color',p.cursorcol,'linewidth',p.cursorwidth);
    elseif ord(i)==2
        if ordspm==0
            hline(cy,'color',p.cursorcol,'linewidth',p.cursorwidth);
            vline(cx,'color',p.cursorcol,'linewidth',p.cursorwidth);
        elseif ordspm==1
            if ord(i)==2
                hline(size(w.a,2)-cx,'color',p.cursorcol,'linewidth',p.cursorwidth);
                vline(cy,'color',p.cursorcol,'linewidth',p.cursorwidth);
            else
                hline(cy,'color',p.cursorcol,'linewidth',p.cursorwidth);
                vline(cx,'color',p.cursorcol,'linewidth',p.cursorwidth);
            end
        end
    end
    set(findobj(gcf,'type','line'),'ButtonDownFcn',@btndown);

    %  axis normal
    set(gca,'YDir','normal');
     axis tight;     axis image;
    set(gca,'xticklabels',[],'yticklabels',[]);
    caxis(p.clim);
%     set(gca,'xtick',xl, 'xticklabels',lx);
%     set(gca,'ytick',yl, 'yticklabels',fliplr(w.y));
    
    axis on
    set(gca,'color',p.axcol);
   

end
% colormap(actc);

%% ===========[ tune subplot-gaps]====================================
if axexist==0
    hax=[ findobj(gcf,'tag','ax1');
        findobj(gcf,'tag','ax2');
        findobj(gcf,'tag','ax3')];
    set(hax,'units','pixels');
    pos=cell2mat(get(hax,'position'));
    
    sbgap=7;
    pos(3,2)=pos(1,2)-pos(3,4)-sbgap+1;
    set(hax(3),'position',[pos(3,:) ]);
    
    pos(2,1)=pos(2,1)+sbgap;
    set(hax(2),'position',[pos(2,:) ]);
end

% ===========[colorbar]====================================
cb=findobj(gcf,'tag','cbar');
if isempty(cb)
    set(hax,'units','normalized');
    % set(gcf,'units','units')
    ax3=findobj(gcf,'tag','ax3');
    pos=get(ax3,'position');
    axpos=[pos(1)+pos(3)  pos(2)  pos(3:4) ];
    ha=axes('position',axpos);
    % imagesc(w.a)
    set(ha,'tag',['axcb' ]);
    cb=colorbar;
    set(ha,'visible','off');
    cbpos=get(cb,'position');
    set(cb,'position',[ pos(1)+pos(3)+.034 pos(2)+0.008 cbpos(3)+0.0085 cbpos(4)-+0.017]);
    caxis(p.clim);
    
    set(cb,'FontName','Arial Narrow', 'fontsize',p.fs,'tag','cbar');
end   
 
if ~isnumeric(p.cmap) && strcmp(p.cmap,'spmhot');
    cmap=getmap('hot');
else
    cmap=p.cmap;
end

colormap(cmap);


% ==============================================
%%
% ===============================================

% u.p=p;
% % u.gx=gx;
% set(gcf,'userdata',u);

u.p=p;
u.gx=gx;
set(gcf,'userdata',u);


function [ g p]=obtaintslices(f,p);

ce=p.ce;

f = cellstr(f);
V = spm_vol(f{1});
BB=world_bb(V);

% V=V(volnum1);
% [~,~,qmm ]=rgetnii(f{1});
% qmm=qmm';



if isfield(p,'qmm')==0
    [R,C,P] = ndgrid(1:V(1).dim(1),1:V(1).dim(2),1:V(1).dim(3));
    RCP     = [R(:)';C(:)';P(:)';ones(1,numel(R))];
    p.qmm   = [V(1).mat(1:3,:)*RCP]';
% else
%     qmm
end

df=sum((p.qmm-repmat(ce(:)',[size(p.qmm,1) 1])).^2,2);
imin=find(df==min(df));


orientlabel={'coronal'  'axial'  'sagittal'};

ts  = [...
    0 0 0 pi/2 0 0 1 -1 1;...
    0 0 0 0 0 0 1 1 1;...
    0 0 0 pi/2 0 -pi/2 -1 1 1];
for kk=1:3
    orient=kk;
    if kk==1  ;   slicesmm=ce(2); end
    if kk==2  ;   slicesmm=ce(3); end
    if kk==3  ;   slicesmm=ce(1); end
    
    slicesnum=[];
    if isnumeric(orient);     orient=orientlabel{orient}; end
    ixorient  = strcmpi(orient,orientlabel);
    
    % Candidate transformations
    %     ts              = [0 0 0 0 0 0 1 1 1;...
    %         0 0 0 pi/2 0 0 1 -1 1;...
    %         0 0 0 pi/2 0 -pi/2 -1 1 1];
 
    
    transform       = spm_matrix(ts(ixorient,:));
    
    % Image dimensions
    D               = V.dim(1:3);
    % Image transformation matrix
    T               = transform * V.mat;
    % Image corners
    voxel_corners   = [1 1 1; ...
        D(1) 1 1; ...
        1 D(2) 1; ...
        D(1:2) 1; ...
        1 1 D(3); ...
        D(1) 1 D(3); ...
        1 D(2:3) ; ...
        D(1:3)]';
    corners         = T * [voxel_corners; ones(1,8)];
    sorted_corners  = sort(corners, 2);
    % Voxel size
    voxel_size      = sqrt(sum(T(1:3,1:3).^2));
    
    % Slice dimensions
    % - rows: x and y of slice image;
    % - cols: negative maximum dimension, slice separation, positive maximum dimenions
    slice_dims      = [sorted_corners(1,1) voxel_size(1) sorted_corners(1,8); ...
        sorted_corners(2,1) voxel_size(2) sorted_corners(2,8)];
    % Slices (in mm, world space):
    slices          = sorted_corners(3,1):voxel_size(3):sorted_corners(3,8);
    slicesix        =1:length(slices);
    
    
    
    
    
    % ===============================================
    
    
    if exist('slicesnum') && ~isempty(slicesnum)
        if isnumeric(slicesnum)
            slicesmm=slices(vecnearest2(slicesix,slicesnum)');
            nslices=length(slicesmm);
        else
            if ~isempty(strfind(slicesnum,'n'))
                nimg=str2num(strrep(slicesnum,'n',''));
                slicenum=round(linspace(slicesix(1),slicesix(end),nimg+2));
                slicenum=slicenum(2:end-1); %don't use 1 and last slice
                slicesmm=slices(slicenum);
                nslices=length(slicesmm);
            else
                str1=str2num(slicesnum); % stepwise
                if length(str1)==1
                    slicesnum=slicesix(1):str1:slicesix(end);
                    slicesmm=slices(vecnearest2(slicesix,slicesnum)');
                    nslices=length(slicesmm);
                elseif length(str1)>1
                    if isnan(str1(2))==1;
                        s1=1;
                    else
                        s1=str1(2);
                    end
                    
                    if length(str1)>2
                        if isnan(str1(3))==1;
                            s2=length(slicesix);
                        else
                            s2=length(slicesix)-str1(3)+1;
                        end
                    else
                        s2=length(slicesix);
                    end
                    slicesnum=s1:str1(1):s2;
                    slicesmm=slices(vecnearest2(slicesix,slicesnum)');
                    nslices=length(slicesmm);
                end
            end
        end
    else
        slicesnum=slicesix;
        nslices=size(slicesmm,1);
    end
    
    % Plane coordinates
    X               = 1;
    Y               = 2;
    Z               = 3;
    dims            = slice_dims;
    xmm             = dims(X,1):dims(X,2):dims(X,3);
    ymm             = dims(Y,1):dims(Y,2):dims(Y,3);
    
    
    % zmm             = slices(ismember(slices,slicesmm));
    zmm             = slices(vecnearest2(slices,slicesmm));
    
    
    [y, x]          = meshgrid(ymm,xmm');
    
    % Voxel and panel dimensions
    vdims           = [length(xmm),length(ymm),length(zmm)];
    pandims         = [vdims([2 1]) 3];
    
    
    
    nvox        = prod(vdims(1:2));
    
    hold=0;
    
    % disp('nslices');
    % disp(nslices);
    
    
    
    d=zeros([fliplr(vdims(1:2)) nslices ]);
    
    
    if length(f)==2
        V=spm_vol(f{2});
        V=V(volnum2);
        %     if length(V)>1
        %     V=V(1);
        %     end
    end
    %  V=spm_vol(fullfile(pwd,'Rct.nii'));
    for is=1:nslices
        
        xyzmm = [x(:)';y(:)';ones(1,nvox)*zmm(is);ones(1,nvox)];
        
        vixyz = (transform*V.mat) \ xyzmm;
        % return voxel values from image volume
        
        slice             = spm_sample_vol(V,vixyz(1,:),vixyz(2,:),vixyz(3,:), hold);
        % transpose to reverse X and Y for figure
        slice = reshape(slice, vdims(1:2))';
        
        xs=xyzmm(1:3,:)';
        mima=[min(xs(:,1:3))
            max(xs(:,1:3))];
        xs=vixyz(1:3,:)';
        idxmima=[min(xs(:,1:3))
            max(xs(:,1:3))]  ;
        
        if strcmp(orient,'sagittal');
            %slice=flipud(fliplr(slice));
            slice=fliplr(slice);
            %             q.y=[mima(1,2) mima(2,2)]
            %             q.x=[mima(1,1) mima(2,1)]
            
            q.x=BB(:,2)';
            q.y=sort(BB(:,3)');
        elseif strcmp(orient,'coronal');
            % slice=flipud(slice);
            %             q.y=[mima(1,2) mima(2,2)]
            %             q.x=[mima(1,1) mima(2,1)]
            q.x=BB(:,1)';
            q.y=sort(BB(:,3)');
            
        elseif strcmp(orient,'axial');
            % slice=flipud(slice);
            %             q.y=[mima(1,2) mima(2,2)]
            %             q.x=[mima(1,1) mima(2,1)]
            
            q.x=BB(:,1)';
            q.y=BB(:,2)';
            
        end
        
        %      if is==1
        % %         d=zeros([size(slice) length(slicesmm) ]);
        %         d=zeros([fliplr(vdims(1:2)) length(slicesmm) ]);
        %     end
        slice(isnan(slice))=0;
        d(:,:,is) = slice;
        
        
    end
    

    
    q.a=d;
    g(kk)=q;
    %fg,imagesc(d);
end %



function map=getmap(cm)
if strcmp(cm,'hot')
  map=[  0.0417         0         0
    0.0833         0         0
    0.1250         0         0
    0.1667         0         0
    0.2083         0         0
    0.2500         0         0
    0.2917         0         0
    0.3333         0         0
    0.3750         0         0
    0.4167         0         0
    0.4583         0         0
    0.5000         0         0
    0.5417         0         0
    0.5833         0         0
    0.6250         0         0
    0.6667         0         0
    0.7083         0         0
    0.7500         0         0
    0.7917         0         0
    0.8333         0         0
    0.8750         0         0
    0.9167         0         0
    0.9583         0         0
    1.0000         0         0
    1.0000    0.0417         0
    1.0000    0.0833         0
    1.0000    0.1250         0
    1.0000    0.1667         0
    1.0000    0.2083         0
    1.0000    0.2500         0
    1.0000    0.2917         0
    1.0000    0.3333         0
    1.0000    0.3750         0
    1.0000    0.4167         0
    1.0000    0.4583         0
    1.0000    0.5000         0
    1.0000    0.5417         0
    1.0000    0.5833         0
    1.0000    0.6250         0
    1.0000    0.6667         0
    1.0000    0.7083         0
    1.0000    0.7500         0
    1.0000    0.7917         0
    1.0000    0.8333         0
    1.0000    0.8750         0
    1.0000    0.9167         0
    1.0000    0.9583         0
    1.0000    1.0000         0
    1.0000    1.0000    0.0625
    1.0000    1.0000    0.1250
    1.0000    1.0000    0.1875
    1.0000    1.0000    0.2500
    1.0000    1.0000    0.3125
    1.0000    1.0000    0.3750
    1.0000    1.0000    0.4375
    1.0000    1.0000    0.5000
    1.0000    1.0000    0.5625
    1.0000    1.0000    0.6250
    1.0000    1.0000    0.6875
    1.0000    1.0000    0.7500
    1.0000    1.0000    0.8125
    1.0000    1.0000    0.8750
    1.0000    1.0000    0.9375
    1.0000    1.0000    1.0000];

    map(1:12,:)=[];
end

