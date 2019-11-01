% cf;
clear

ls={
    's20150908_FK_C1M04_1_3_1.nii'
    'c1s20150908_FK_C1M04_1_3_1.nii' 
    'c2s20150908_FK_C1M04_1_3_1.nii' 
    'c3s20150908_FK_C1M04_1_3_1.nii'
    }
ls={
    's20150908_FK_C1M04_1_3_1.nii'
    'c1s20150908_FK_C1M04_1_3_1.nii' 
    'c2s20150908_FK_C1M04_1_3_1.nii' 
    }
ls={
    's20150908_FK_C1M04_1_3_1.nii'
    'c1s20150908_FK_C1M04_1_3_1.nii' 
    }
    
slices=1:32
for i=1:size(ls,1)    
    h1=spm_vol(ls{i})
    dum=single(spm_read_vols(h1));
    dum=dum(:,:,slices);
    dum=flipdim(permute(dum,[2 1 3]),1);
    if i==1
       x=single(zeros([size(dum) size(ls,1)    ])) ;
    end
    x(:,:,:,i)=dum;
end

for i=1:size(x,3)
   dum= mat2gray(x(:,:,i,1));
   dum=brighten( imadjust(dum),.7);
   x(:,:,i,1)=medfilt2(dum);
%    cc2(:,:,i)= mat2gray(c2(:,:,i));
%    cc3(:,:,i)= mat2gray(c3(:,:,i));
end

for i=1:size(x,4)
    xm(:,:,i)=createMontageImage(permute(x(:,:,:,i),[1 2 4 3]));
end



ana=xm(:,:,1);
xm=xm(:,:,2:end) ;

fg
imagesc( ana(:,:,[1 1 1]) );
% imagesc( xm(:,:,[1 1 1]) );
hold on;

tresh=.01
xv=xm.*nan;
for i=1:size(xm,3)
   b2=xm(:,:,i);
   t1 = b2 .* ( b2 >= tresh & b2 <= 1.0 ); % threshold second image
   t1(t1>0)=i;
   xv(:,:,i)=t1;
end
ts   =sum(xv,3);
talph=ts>0;
talph=talph/2;
ih = imagesc( ts);colorbar;
talph(talph==0)=nan;
set( ih, 'AlphaData', talph );


col={[0 0 1] [1 0 0] [0 1 0] [ 1     1     0]  [0     1     1] [1     0     1]}
n=size(xv,3)
% cmap=[ repmat(col{1},[32 1]);  repmat(col{2},[32 1])]
cmap=cell2mat(col(1:n)');
try; cmap(end+1,:)=sum(cmap(1:2,:));end
try; cmap(end+1,:)=[0.7490         0    0.7490];end

if n==1; n2=1;end
if n==2; n2=3;end
if n==3; n2=6;end
cmap=cmap(1:n2,:);
if n==1; cmap=[cmap;cmap]; n2=2; end
colormap(cmap)
hb=colorbar
caxis([1 n2])
set(gca,'position',[0 0 1 1])
set(hb,'position',[0.015 0.1 .01 .2],'xcolor','w','ycolor','w')


return
   
 t1 = b2 .* ( b2 >= .01 & b2 <= 1.0 ); % threshold second image
t2 = b3 .* ( b3 >= .01 & b3 <= 1.0 ); % threshold second image
t1(t1>0)=1;
t2(t2>0)=2;
ts   =(t1+t2);
talph=ts>0;
talph=talph/2;
ih = imagesc( ts);colorbar;
talph(talph==0)=nan;
set( ih, 'AlphaData', talph );
 
col={[0 0 1] [1 0 0] };
n=2
cmap=[ repmat(col{1},[32 1]);  repmat(col{2},[32 1])]
colormap(cmap)
hb=colorbar
caxis([1 2])

set(gca,'position',[0 0 1 1])
set(hb,'position',[0.015 0.1 .01 .2],'xcolor','w','ycolor','w')

% print('-djpeg','-r200','muell.jpg')

if 0
print('-djpeg','-r300','v2.jpg')
set( ih, 'AlphaData', talph/100 );
print('-djpeg','-r300','v1.jpg')
end
%%*****************************************

if 0
   ls={
    fullfile(pwd,  'v1.jpg')
    fullfile(pwd,  'v2.jpg')
    }
    makegif('test3.gif',ls,.3);
end





% 00000000000000000000000000000000000000000000000000000000000
return
clear

h1=spm_vol('s.nii')
h2=spm_vol('c1.nii')
h3=spm_vol('c2.nii')

cc1=spm_read_vols(h1);
cc2=spm_read_vols(h2);
cc3=spm_read_vols(h3);
cc1=single(cc1);
cc2=single(cc2);
cc3=single(cc3);
 
slices=1:2:size(cc1,3)

cc1=cc1(:,:,slices);
cc2=cc2(:,:,slices);
cc3=cc3(:,:,slices);

%shiftDIM
cc1=flipdim(permute(cc1,[2 1 3]),1);
cc2=flipdim(permute(cc2,[2 1 3]),1);
cc3=flipdim(permute(cc3,[2 1 3]),1);

%% run2

for i=1:size(cc1,3)
   dum= mat2gray(cc1(:,:,i));
   dum=brighten( imadjust(dum),.7);
   cc1(:,:,i)=medfilt2(dum);
%    cc2(:,:,i)= mat2gray(c2(:,:,i));
%    cc3(:,:,i)= mat2gray(c3(:,:,i));
end
% montage(permute(cc1,[1 2 4 3]))

a1=createMontageImage(permute(cc1,[1 2 4 3]));
b2=createMontageImage(permute(cc2,[1 2 4 3]));
b3=createMontageImage(permute(cc3,[1 2 4 3]));

 
fg
imagesc( a1(:,:,[1 1 1]) );
hold on;
% freezeColors
t1 = b2 .* ( b2 >= .01 & b2 <= 1.0 ); % threshold second image
t2 = b3 .* ( b3 >= .01 & b3 <= 1.0 ); % threshold second image
t1(t1>0)=1;
t2(t2>0)=2;
ts   =(t1+t2);
talph=ts>0;
talph=talph/2;
ih = imagesc( ts);colorbar;
talph(talph==0)=nan;
set( ih, 'AlphaData', talph );
 
col={[0 0 1] [1 0 0] }
n=2
cmap=[ repmat(col{1},[32 1]);  repmat(col{2},[32 1])]
colormap(cmap)
hb=colorbar
caxis([1 2])

set(gca,'position',[0 0 1 1])
set(hb,'position',[0.015 0.1 .01 .2],'xcolor','w','ycolor','w')

% print('-djpeg','-r200','muell.jpg')
% print('-djpeg','-r200','v2.jpg')

%%*****************************************
return



h1=spm_vol('s.nii')
h2=spm_vol('c1.nii')
h3=spm_vol('c2.nii')

c1=spm_read_vols(h1);
c2=spm_read_vols(h2);
c3=spm_read_vols(h3);

alpha=.2
out2=nan.*c1;;
fg
for i=8%:size(c1,3)

    b1=c1(:,:,10+i);
    b2=c2(:,:,10+i);
    b3=c3(:,:,10+i);
%     out =dum(b1,b2,b2,.5, alpha);
%     %         subplot(4,3,i);
%     image(out);
%     axis('image');
    %     out2(:,:,i)=out;
end

% 
% figure;
% imshow( first(:,:,[1 1 1]) ); % make the first a grey-scale image with three channels so it will not be affected by the colormap later on
% hold on;
% t_second = second .* ( second >= .6 & second <= 1.0 ); % threshold second image
% ih = imshow( t_second );
% set( ih, 'AlphaData', t_second );
% colormap jet

%% run
% b1=flipud(b1);

figure;
% b11=mat2gray(b1);
b11=brighten( imadjust(mat2gray(b1)),.7);
b11 = medfilt2(b11);
imagesc( b11(:,:,[1 1 1]) );
% imagesc( b1(:,:,[1 1 1]) ); % make the first a grey-scale image with three channels so it will not be affected by the colormap later on
% imagesc(b1);colormap gray
hold on;
% freezeColors
t1 = b2 .* ( b2 >= .01 & b2 <= 1.0 ); % threshold second image
t2 = b3 .* ( b3 >= .01 & b3 <= 1.0 ); % threshold second image
t1(t1>0)=1;
t2(t2>0)=2;
ts   =(t1+t2);
talph=ts>0;
talph=talph/2;
ih = imagesc( ts);colorbar;






% talph(:,1:2:end)=0;

set( ih, 'AlphaData', talph );
colormap jet
'a'






















