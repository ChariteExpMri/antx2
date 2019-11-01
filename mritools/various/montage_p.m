
function montage_p(u,lis,xopengl,grids,varargin)
% montage_p(u,lis,xopengl,grids)
% example: montage_p(dat,[],1,1)
% u=3dmatrix   :sliced allong 3rd. dim
% lis=[2val]    :c-limits
% xopengl=[0,1] :normal/opengl
% grid [0/1]; grid off/on
cla;

u=single(u);

if ~exist('lis');lis=[];end
if ~exist('xopengl');xopengl=[1];end
if ~exist('grids');grids=[1];end

if isempty(lis)
    lis=[min(u(:)) max(u(:))];
end

if isempty(xopengl)
    xopengl=0;
end


    

si=size(u);
if length(si)>2 
    n=ceil(sqrt(si(3)));
else
    n=1;
end
r=zeros(n*si(1),n*si(2) );
p=1;

sp=[];col=[];
for i=1:n %zeileblock
    for j=1:n %spaltenblock
        try
       dx= u(:,:,p);
        catch
           dx=zeros(size(  u(:,:,1) ))+  mean(u(:)); 
        end
             tx=i*si(1)-si(1)+1;
             ty=j*si(2)-si(2)+1;
              
              sp(end+1,1)=ty(1);
              col(end+1,1)=tx(1);
 
         r(tx:tx+si(1)-1   , ty:ty+si(2)-1  ) = dx ;
        p=p+1;
    end
     
end

% r=imadjust(uint8(r));

if nargin==5
% %     sizf=varargin{1}
% %     H = fspecial('average',sizf);
% %     r2 = imfilter(r,H,'replicate');
% %      fg,imagesc(r2)
else
    imagesc(r) ;
%     imagescnan(r) ;
end
% imagescnan(r) ;hold on;

 %contourf(r,30);hold on

% [f1 f2]=gradient(r,.1);quiver(f1,f2,'color','k','linewidth',2);
% set(gca,'ydir','reverse')

% grid on;
if grids==1
    col=unique(col);
    sp=unique(sp);
    hold on;
    try
    for i=1:length(sp)
        vline(sp(i),'color',[1 1 1]);
    end
    for i=1:length(col)
        hline(col(i),'color',[1 1 1]);
    end
    end
end
if lis(1)~=lis(2) %if not the same limits 
    caxis(lis);
end






% if xopengl==1
%     set(gcf,'Renderer','opengl');
% end