
function [h ad]=ovlAtlas(ls,interpx,strtag)


% ls={'ms20150908_FK_C1M02_1_3_1.nii' 'A2N_Wnn2_mrmNeAtMouseBrain_Atlas_23_highRes.nii'}'
% ls={'s20150908_FK_C1M02_1_3_1.nii' 'A2N_Wnn2_mrmNeAtMouseBrain_Atlas_23_highRes.nii'}'

if exist('col')
    col=colorcheck(col)
end
%% ==============================


% if isempty(slices)
    h1=spm_vol(ls{1});
    slices=1:h1.dim(3);
% end

if ~exist('interpx')
    interpx=1;
end
 
for i=1:size(ls,1)   
    h1=spm_vol(ls{i});  
    if i==1
        href=h1; 
        dum=single(spm_read_vols(h1));
    else
       inhdr = spm_vol(ls{i}); %load header
       inimg = spm_read_vols(inhdr); %load volume
       tarhdr = href;%spm_vol(ls{2}); %load header
       [outhdr,outimg] = nii_reslice_target(inhdr,inimg, tarhdr, interpx); %resize in memory
       dum=outimg;
       dum(isnan(dum))=0;
    end
    dum=dum(:,:,slices);
    dum=dum./max(dum(:));
%     dum=flipdim(permute(dum,[2 1 3]),1);
  
    
%     if dirs==1
%         dum=permute(dum,[1 3 2 ]);
%     elseif dirs==2
%         dum=permute(dum,[2 1 3  ]);
%     elseif dirs==3
%         dum=permute(dum,[3 2 1 ]);
%     end
    
  if i==1
       x=single(zeros([size(dum) size(ls,1)    ])) ;
    end
    
    x(:,:,:,i)=dum;
end

for i=1:size(x,3)
    dum=x(:,:,i,1);
    dum(isnan(dum))=0;
   dum= mat2gray(dum);
   dum=brighten( imadjust(dum),.7);
   x(:,:,i,1)=medfilt2(dum);
%    cc2(:,:,i)= mat2gray(c2(:,:,i));
%    cc3(:,:,i)= mat2gray(c3(:,:,i));
end

crop=.45;
si=size(x);
icrop=round(si(1:2).*crop/2);

x=x(icrop(1):end-icrop(1)+1,icrop(2):end-icrop(2)+1,:,:);
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
olap=[];
if exist('olap')
    if ~isempty(olap)
        if olap==0
            tg=sum(sum(x,3),4);
            i1=find(sum(tg,1)~=0);
            i2=find(sum(tg,2)~=0);
            
            lm2=[i1(1) i1(end)];
            lm1=[i2(1) i2(end)]  ;
%             fg,imagesc(tg(lm1(1):lm1(2),lm2(1):lm2(2)))
           x=x(lm1(1):lm1(2),lm2(1):lm2(2),:,:);
            
        else
%             round( size(x,2).*olap)
        end
    end
end

%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
% rgb = imread('peppers.png');
for i=1:size(x,4)
  xm(:,:,i)=createMontageImage(permute(x(:,:,:,i),[1 2 4 3]));
  %     xm(:,:,i)=createMontageImage(permute(x(:,:,:,i),[ 3 2 4 1]));
end

a=xm(:,:,1)';
b=xm(:,:,2)';

% a=x(:,:,15,1);
% b=x(:,:,15,2);
 ct=cbrewer('qual', 'Paired', 32);
%ct=cbrewer('qual', 'Paired', 50);
ct(1,:)=[0 0 0];

G=b;
G(isnan(G))=1;
C = colormap(ct);  % Get the figure's colormap.
L = size(C,1);
% Scale the matrix to the range of the map.
Gs = round(interp1(linspace(min(G(:)),max(G(:)),L),1:L,G));
rgb = reshape(C(Gs,:),[size(Gs) 3]); % Make RGB image from scaled.

G=a;
C = colormap(jet);  % Get the figure's colormap.
L = size(C,1);
% Scale the matrix to the range of the map.
Gs = round(interp1(linspace(min(G(:)),max(G(:)),L),1:L,G));
rgb2 = reshape(C(Gs,:),[size(Gs) 3]); % Make RGB image from scaled.


if 0
    fg
    % rgb = imread('peppers.png');
    imshow(rgb);
    I = rgb2gray(rgb2);
    hold on
    h = imshow(I); % Save the handle; we'll need it later
    hold off

    % [M,N] = size(I);
    % block_size = 50;
    % P = ceil(M / block_size);
    % Q = ceil(N / block_size);
    % alpha_data = checkerboard(block_size, P, Q) > 0;
    % alpha_data = single(alpha_data(1:M, 1:N));
    %  alpha_data(alpha_data==0)=.5;

    %  ad=rgb2(:,:,1).*0+.5;
    % set(h, 'AlphaData', ad);
    ad=single(rgb(:,:,1)~=0);
    ad(ad~=0)=.1;
    ad(ad==0)=1;
    set(h, 'AlphaData', ad);

    % ################################
end

try
fg
catch
    figure('color','w')
end
% rgb = imread('peppers.png');
gr=rgb2gray(rgb2);

gr2=abs(gr-max(gr(:)));

imshow(gr2)
hold on
h = imshow(rgb); % Save the handle; we'll need it later
hold off

%  ad=rgb2(:,:,1).*0+.5;
% set(h, 'AlphaData', ad);
ad=single(rgb(:,:,1)~=0);
 ad(ad~=0)=.8;
  ad(ad==0)=0;
set(h, 'AlphaData', ad);


%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
set(gca,'units','normalized','position',[0 0 1 1])
ht=title(strtag);set(ht,'interpreter','none','fontsize',14,'fontweight','bold');

% paout=pwd
%    if 1
%       
%        print('-djpeg','-r300',fullfile(paout, 'vv1.jpg'));
%        ad(ad~=0)=0;
%        ad(ad==0)=0;
%        set(h, 'AlphaData', ad);
%        
%        print('-djpeg','-r300',fullfile(paout, 'vv2.jpg'));
%    end
%    %%*****************************************
% 
%    if 1
% %       [pa fi]= fileparts(t1);
%        ls={
%            fullfile(paout,  'vv1.jpg');
%            fullfile(paout,  'vv2.jpg');
%            }
%        makegif(fullfile(paout, ['agif2_'  '.gif'])  ,ls,.3);
%    end










%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••


% 
% rgb = imread('peppers.png');
% imshow(rgb);
% I = rgb2gray(rgb);
% hold on
% h = imshow(I); % Save the handle; we'll need it later
% hold off
% 
% [M,N] = size(I);
% block_size = 50;
% P = ceil(M / block_size);
% Q = ceil(N / block_size);
% alpha_data = checkerboard(block_size, P, Q) > 0;
% alpha_data = alpha_data(1:M, 1:N);
% set(h, 'AlphaData', alpha_data);