 
function[hfig]=ovlcontour(fi,dim,slices,crop,tff,cont,namestr,params)

%%  overlay 2volumes: image and contour (1st IMG: image), 2nd IMG: contour
% fi:    cell with filenames
% dim: dim to slice (1,2,3)
% slices:   vector with slicenumbers, [10 20 30]
%              string with one number ( '5')   --> every Nth slice (every 5th slice) to plot
%               string with two numbers ( '5 10')   -->plot  every Nth slice (every 5th slice) starting with arg(2) slice and ending with Nslices-arg(2)   
%                      e.g.: ( '5 10')  plot every 5th slice starting with the 10th slice up to Nslices-10
% crop: crop image, 4 element vector [down up left right] from outer border in normalized units         
%                     e.g. [0 .2 0 .5] : crops 20% from upper image and 50%from right side
% tff: transpos, flildown,flipright:  3 element binary vector to define whether images should be transpodes, flipud and fliplr
%                       e.g. [1 1 0] ; transpose image, than flipupdown, do NOT flipLeftright
% cont:   2 element vector:  Number of contours & linewidth                 
%            3 element vector:  Number of contours & linewidth & linestyle 
%               -linestyle (3rd,optional,argument) is numeric and calls one of these styles: {'-'     ':'      '-.'    '--'};
%                -default linestyle is 2, (dottet ':' style)
% namestr: string to add in plot
% <optiona>
%   params  : struct with addit. pairwise inputs
%     ---currently : 'position'  , [x y w h]   --> to define window location on screen
%% EXAMPLES NEW
%   ovlcontour(fis,orient,['2'],[.08 0 0.05 0.05],[1 1 0],{[cmap] .3 [ ] }, strings,...
%         struct('position', [0.601    0.1783    0.3889    0.4667] ));
%     
%         ovlcontour(fis,orient,['2'],[.08 0 0.05 0.05],[1 1 0],{[cmap] .3 [ ] })        
%% EXAMPLES
% fi={'V:\projects\atlasRegEdemaCorr\nii32\s20150908_FK_C1M01_1_3_1_1\hx_T2.nii'; 'V:\projects\atlasRegEdemaCorr\nii32\s20150908_FK_C1M01_1_3_1_1\_Atpl_mouseatlasNew.nii';}
% ovlcontour(fi,2,'10 15',[],[1 1 0],[4 2],'FÜR MOUSETEMPLATE: every10thSlice,starting from 15th slice,transpose,flipdown, 4contours,lw=2 ')
% ovlcontour(fi,1,[20:40],[],[1 1 0],[5 1],'')
%  ovlcontour(fi,2,['10 15'],[],[1 1 0],[5 1 1.3],'');% USE THAT ####
% print(gcf,'-djpeg','-r300',fullfile(pwd,'test8.jpg'),'-zbuffer');
%%EXAMPLE: HEMISPHERE
% fi={'V:\projects\atlasRegEdemaCorr\nii32\s20150908_FK_C1M01_1_3_1_1\hx_T2.nii'; 'V:\projects\atlasRegEdemaCorr\nii32\s20150908_FK_C1M01_1_3_1_1\hx_hemi2.nii';}
%  ovlcontour(fi,2,['10 15'],[],[1 1 0],[5 2],'hemis')
% EXAMPLE:3
% ovlcontour(fi)  ; %use default settings 
%% EXP4
% ovlcontour({f1;f2},2,['8 25'],[.08 0 0.05 0.05],[1 1 0],[2 2 1], 'R');

if 0
    % aa='V:\projects\atlasRegEdemaCorr\nii32\s20150908_FK_C1M01_1_3_1_1\_Atpl_mouseatlasNew_left.nii'
    % bb='V:\projects\atlasRegEdemaCorr\nii32\s20150908_FK_C1M01_1_3_1_1\elx_T2_left-0.nii'
    bb='V:\projects\atlasRegEdemaCorr\nii32\s20150908_FK_C1M01_1_3_1_1\_Atpl_mouseatlasNew.nii'
    % bb='V:\projects\atlasRegEdemaCorr\nii32\s20150908_FK_C1M01_1_3_1_1\hx_T2.nii'
    %  aa='V:\projects\atlasRegEdemaCorr\nii32\s20150908_FK_C1M01_1_3_1_1\elx_T2-0.nii'
    aa='V:\projects\atlasRegEdemaCorr\nii32\s20150908_FK_C1M01_1_3_1_1\hx_T2.nii'
    dim=3
    slices=[ 60 100 120 150]
    slices=[50:5:200]
    slices=[ 40:5:80]
    slices=('20'); %stepsize, every 5th slice
    %slices=('4 10'); %first is stepsize ,2nd is start/stop relative to idx1/idxEnd
    crop=[0 0 0 0];
    crop=[0 .2 0 .5]
    tff=[1 1 0]  ;%tff: transpose-flipdown-flipright
    cont=[4 2 2 ];%[4 1.5]
    namestr='bla';
    ovlcontour({aa bb},dim,slices,crop,tff,cont,namestr)
end

%% missingINPUT
% ovlcontour(fi,dim,slices,crop,tff,cont,namestr)
if ischar(fi) ;                        fi={fi;fi};         end
if exist('dim')==0;             dim=[];          end;     if isempty(dim); dim=2                     ;end
if exist('slices')==0;          slices=[];          end;   if isempty(slices); slices='10 20'        ;end
if exist('crop')==0;             crop=[];          end;   if isempty(crop); crop=[0 0 0 0]        ;end
if exist('tff')==0;                 tff=[];             end;    if isempty(tff); tff=[1 1 0]                     ;end
if exist('cont')==0;            cont=[];          end;    if isempty(cont); cont=[2 1]                     ;end
if exist('namestr')==0;     namestr=[];    end;    if isempty(namestr); namestr=''                     ;end

if exist('params')~=1  %placeholder if params not exists
    params.dummy='dummy';
end

% if isempty(crop); crop=[0 0 0 0]; end
if length(fi)==1
    fi{2}=fi{1}
end

%% get files
aa=fi{1};
bb=fi{2};
if 1
    [hbb, b ]=rreslice2target([bb,',1'], [aa ',1'], [], 0);
    
%     [hbb, b ]=rreslice2target(bb, aa, [], 0);
end
[haa a]=rgetnii([aa ',1']);
% [hbb b]=rgetnii(bb);
[pas f1 ext]=fileparts(aa);
[pas f2 ext]=fileparts(bb);



%%remove NAN
a(isnan(a))=0;
b(isnan(b))=0;



siz=size(a);

%% define tff: tranpose fliddown flipright
transp=tff(1);
flipd=tff(2);
flipr=tff(3);

%% get Number of contours and linewitdh, linestyle
if ~iscell(cont) % CONTOUR
    ncontours=cont(1);
    lw=cont(2);
    linestyle={'-'     ':'      '-.'    '--'};
    ls=linestyle{2};
    if length(cont)>2
        ls=linestyle{ cont(3)};
    end
    task='contour';
else %IMAGEOVERLAY
    cmap=cont{1};
    if numel(cmap)<10
        cmap=[...
        repmat( [ .5 .5 .5  ],  [16 1 ]  )
        repmat( [ 0 1 0 ],  [16 1 ]  )
        repmat( [ 1 1  0 ],  [16 1 ]  )
        repmat( [1 0 0 ],  [16 1 ]  )
        ];
    end
    try; clim2=cont{3}; catch; clim2=[];end
    alphalevel=cont{2};
    task='fusion';
end

if ~iscell(cont) % CONTOUR
    a=a-min(a(:));   a=a./max(a(:));%normalize
    b=b-min(b(:));   b=b./max(b(:));
end

%% which dim, which slices
if dim==1
    a=permute(a,[2 3 1]);
    b=permute(b,[2 3 1]);
elseif dim==2
    a=permute(a,[1 3 2]);
    b=permute(b,[1 3 2]);
end
if ischar(slices) %special sliceRequest
    if length(str2num(slices))==1
        slices=1:str2num(slices):size(a,3);
        slices(find(slices==1))=[];
    else
        dum=str2num(slices);
        slices=dum(2):dum(1):size(a,3)-dum(2);
    end
end

%% get MNI
co=zeros(length(slices),3); co(:,dim)=slices;
mm=mni2idx( co' , haa, 'idx2mni' );
mm=mm(:,dim);

%% get layout
nb=length(slices);
[p,n]=numSubplots(nb);

%% imadjust
if strcmp( task, 'contour')
    a3=a(:,:,slices); six=size(a3);  a3=reshape(imadjust(a3(:)),six);
    b3=b(:,:,slices);                       b3=reshape(imadjust(b3(:)),six);

a(:,:,slices)=a3;
b(:,:,slices)=b3;
end


%% make figure
hfig=figure;
if isfield(params,'position')
   set(hfig,'units','normalized','position',params.position) ;
end

set(hfig,'KeyPressFcn',@keys)
set(gcf,'color','k','units','normalized','name','hit [h] for help');
ha = tight_subplot(p(1),p(2),[0 0],[0 .025],[.01 .01]);
set(ha,'color','k');
% clims=[];

if strcmp( task, 'fusion')
   
    G=b;
    if ~isempty(clim2);
      G(G<clim2(1))=0;
      G(G>clim2(2))=0;
    end
    Gs=G-min(G(:)); Gs=round(((Gs./max(Gs(:))).*(size(cmap,1)-1))+1);
    b=Gs;
end


for i=1:length(slices)
    axes(ha(i));
    
    nn=slices(i);
    a1=(squeeze(a(:,:,nn)));
    b1=(squeeze(b(:,:,nn)));
    
    if strcmp( task, 'contour')
        a1=a1-min(a1(:));   a1=a1./max(a1(:));
        b1=b1-min(b1(:));   b1=b1./max(b1(:));
    end
    
    if transp==1;          a1=a1';               b1=b1';     end
    if flipd==1;             a1=flipud(a1);    b1=flipud(b1);end
    if flipr==1;              a1=fliplr(a1);      b1=fliplr(b1);end

    si=size(a1);
    bord1=[ round(si(1)*crop(2))+1    si(1)-round(si(1)*crop(1)) ];
    bord2=[           round(si(2)*crop(3))+1   si(2)-round(si(2)*crop(4))         ];
    bord=[bord1;bord2];
    a1=a1(bord(1,1):bord(1,2),bord(2,1):bord(2,2));
    b1=b1(bord(1,1):bord(1,2),bord(2,1):bord(2,2));
    %      dd=   a1(bord(1,1):bord(1,2),bord(2,1):bord(2,2))
    %      fg,subplot(2,2,1);imagesc(a1);subplot(2,2,2);imagesc(dd)
    
    %     end
%     a1=imadjust(a1);
%     b1=imadjust(b1);
if strcmp( task, 'contour')  %% CONTOUR
    image(cat(3,a1,a1,a1)); hold on;
    [c he]=contour(b1,ncontours,'linewidth',lw,'linestyle',ls,'tag','contour');
    if ncontours==1
        set(he,'color','r')
    end
else  %IMAGEFUSION
    
    a3=repmat(mat2gray(a1),[1 1 3]);
    G=b1;
    %    cmap = copper;  % Get the figure's colormap.
%     cmap=[...
%         repmat( [ .5 .5 .5  ],  [16 1 ]  )
%         repmat( [ 0 1 0 ],  [16 1 ]  )
%         repmat( [ 1 1  0 ],  [16 1 ]  )
%         repmat( [1 0 0 ],  [16 1 ]  )
%         ];
%     L = size(cmap,1);
    % Scale the matrix to the range of the map.
    % Gs = round(interp1(linspace(min(G(:)),max(G(:)),L),1:L,G,'nearest'));
%     Gs=G-min(G(:)); Gs=round(((Gs./max(Gs(:))).*(size(cmap,1)-1))+1);
    Gs=G;
    try
    H = reshape(cmap(Gs,:),[size(Gs) 3]); % Make RGB image from scaled.
    c=fuseimage(a3, H,  alphalevel   );
    image(c);

    us.fus(:,:,:,i)=single(c);
    us.a3(:,:,:,i)=single(a3);
    us.Gs(:,:,:,i)=single(Gs);
    us.ha(i)=ha(i);
    us.slice=slices(i);
    us.alphalevel=alphalevel;
    us.mm=mm(i);
    set(gca,'ButtonDownFcn',@keys)
     end
end
   
   
   
    
    te=text(0,1,['' num2str(slices(i))  '\color[rgb]{0.7569    0.8667    0.7765}'   sprintf(' [%2.2f]',mm(i))],...
        'tag','txt','color','r','units','normalized',...
        'fontunits','normalized','fontsize',.05,'fontweight','bold','verticalalignment','top');
    
    
    
    axis off;
%     clims(i,:)=caxis;
end

try; us.cmap=cmap; end
set(gcf,'userdata',us);


%% common clim
% climall=[min(clims(:)) max(clims(:))]
% for i=1:length(ha)
%     caxis(ha(i),climall);
% end

drawnow;
%% title
ptitle([ namestr ' (' f1 ' - ' f2 ')']);

set(gcf,'color','k','InvertHardcopy','off');
drawnow;

if 0
    print(gcf,'-djpeg','-r300',fullfile(pwd,'test3.jpg'));
end

%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
%% addon functions
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
function keys(he,e)



us=get(gcf,'userdata');

if strcmp(e.Character,'h')
    h={};
    h{end+1,1}=[' #by  SHORTCUTS  '      ];
    h{end+1,1}=[' #b [left arrow]     #k  toggle to show background & foreground image only'      ];
    h{end+1,1}=[' #b [right arrow]    #k  show fusion of background & foreground image'      ];
    h{end+1,1}=[' #b [up/down arrow]  #k decrease/increase fusion transparency'      ];
    h{end+1,1}=[' #b [c]              #k change  between multiple colormaps'      ];
    uhelp(h,0,'position',[ 0.6330    0.5178    0.3535    0.40]);
    
end

if strcmp(e.Character,'c')
    if isfield(us,'cmapall')==0; 
        maps={'jet','hot','summer','parula','hsv','winter'};
      for i=1:length(maps);
        cm{i}=colormap(maps{i});
      end
      us.cmapall=[{us.cmap} cm ];
      us.cmapval=1;
      set(gcf,'userdata',us);
    end
    
    us.cmapval  =mod(us.cmapval, length(us.cmapall) )+1;
    us.cmap=us.cmapall{us.cmapval};
    set(gcf,'userdata',us);
    replot(3);
end





if strcmp(e.Key,'leftarrow')
  replot(1);
elseif strcmp(e.Key,'rightarrow')
   replot(3);
end

if strcmp(e.Key,'uparrow')
  replot(3,1);
elseif strcmp(e.Key,'downarrow')
   replot(3,-1);
end
    

function replot(do,alpha)
us=get(gcf,'userdata');
if isfield(us,'mode')==0
   us.mode=3;
   set(gcf,'userdata',us);
   us=get(gcf,'userdata');
end

if do==1
    if us.mode==3 | us.mode==2
        us.mode=1;
    else
        us.mode=2;
    end
elseif do==3
    us.mode=3;
end
set(gcf,'userdata',us);

 

for i=1:length(us.ha)
   set(gcf,'currentaxes',us.ha(i));
   him=findobj(gca,'type','image');
   if  us.mode==1
   set(him,'cdata',us.a3(:,:,:,i));
   elseif  us.mode==2
   set(him,'cdata',us.Gs(:,:,:,i));
    elseif  us.mode==3
        
       if exist('alpha') ==1 
           us.alphalevel=us.alphalevel+(sign(alpha)*.02);
           if us.alphalevel>1; us.alphalevel=1; end
           if us.alphalevel<0; us.alphalevel=0; end
            set(gcf,'userdata',us);
%             us.alphalevel
       end
            H = reshape(us.cmap(us.Gs(:,:,i),:),[size(us.Gs,1) size(us.Gs,2) 3]); % Make RGB image from scaled.
            us.fus(:,:,:,i)=fuseimage(us.a3(:,:,:,i), H,  us.alphalevel   );
           
      
   set(him,'cdata',us.fus(:,:,:,i));
   end
%    image(us.a3(:,:,:,i))
    
end

function [p,n]=numSubplots(n)
while isprime(n) & n>4,
    n=n+1;
end

p=factor(n);

if length(p)==1
    p=[1,p];
    return
end


while length(p)>2
    if length(p)>=4
        p(1)=p(1)*p(end-1);
        p(2)=p(2)*p(end);
        p(end-1:end)=[];
    else
        p(1)=p(1)*p(2);
        p(2)=[];
    end
    p=sort(p);
end
while p(2)/p(1)>2.5
    N=n+1;
    [p,n]=numSubplots(N); %Recursive!
end


function ptitle(tex,varargin)

ha=axes('position',[0 0 1 1],'color','none',...
    'visible','off','HitTest','off','tag','subtitle');
te=text(0,1,tex,...
    'tag','txt2','color','w','units','normalized',...
    'fontunits','normalized','fontsize',.02,'fontweight','bold','verticalalignment','top',...
    'horizontalalignment','left');
set(te,'interpreter','none');


% h=text(.5,.97,tex,'horizontalalignment','center','fontsize',20,'tag','txt2');
% uistack(ha,'bottom');
%  set(ha,'visible','off','HitTest','off','tag','subtitle')
if ~isempty(varargin)
    set(h,varargin{:})  ;
end


%Program Description
%This program is the main entry of the application.
%This program fuses/combines 2 images
%It supports both Gray & Color Images
%Alpha Factor can be varied to vary the proportion of mixing of each image.
%With Alpha Factor = 0.5, the two images mixed equally.
%With Alpha Facotr < 0.5, the contribution of background image will be more.
%With Alpha Facotr > 0.5, the contribution of foreground image will be more.

function fusedImg = fuseimage(bgImg, fgImg, alphaFactor)

bgImg = double(bgImg);
fgImg = double(fgImg);

fgImgAlpha = alphaFactor .* fgImg;
bgImgAlpha = (1 - alphaFactor) .* bgImg;

fusedImg = fgImgAlpha + bgImgAlpha;



