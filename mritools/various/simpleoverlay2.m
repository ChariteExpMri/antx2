
function simpleoverlay(ls, slices, tresh, col,dirs, olap )

% simpleoverlay(ls2, [4 8 9], tresh,{'g','m' } );
% simpleoverlay2(ls, [], .002,{'r','m' },0 );
% simpleoverlay2(ls, [], .002,{'r','g' },0 );
% simpleoverlay2({t2file;  TPMpathnew{2}},'5',.01,{'r'},4.9);
%  simpleoverlay2({t2file;  TPMpathnew{2}},[],.01,{'r'},4.9);
% cf;
% clear
if 0
    ls3={
        's20150908_FK_C1M04_1_3_1.nii'
        'c1s20150908_FK_C1M04_1_3_1.nii'
        'c2s20150908_FK_C1M04_1_3_1.nii'
        'c3s20150908_FK_C1M04_1_3_1.nii'
        }
    ls2={
        's20150908_FK_C1M04_1_3_1.nii'
        'c1s20150908_FK_C1M04_1_3_1.nii'
        'c2s20150908_FK_C1M04_1_3_1.nii'
        }
    ls1={
        's20150908_FK_C1M04_1_3_1.nii'
        'c1s20150908_FK_C1M04_1_3_1.nii'
        }

    slices=1:32
    tresh=.01
end

if exist('col')
    col=colorcheck(col)
end
%% ==============================


if isempty(slices)
    h1=spm_vol(ls{1});
    slices=1:h1.dim(3);
end

for i=1:size(ls,1)   
    
    h1=spm_vol(ls{i});
   
    if i==1
        href=h1; 
        dum=single(spm_read_vols(h1));
    else
%        'a' 
       inhdr = spm_vol(ls{i}); %load header
       inimg = spm_read_vols(inhdr); %load volume
       tarhdr = href;%spm_vol(ls{2}); %load header
       [outhdr,outimg] = nii_reslice_target(inhdr,inimg, tarhdr); %resize in memory
       
       dum=outimg;
  
        
    end
    
    if ischar(slices)  %'2' or '5'-->use every 2nd,5th slice
        slicespace=str2num(slices)
        slices=1:slicespace:size(dum,1);
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
   dum= mat2gray(x(:,:,i,1));
   dum=brighten( imadjust(dum),.7);
   x(:,:,i,1)=medfilt2(dum);
%    cc2(:,:,i)= mat2gray(c2(:,:,i));
%    cc3(:,:,i)= mat2gray(c3(:,:,i));
end


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



for i=1:size(x,4)
  xm(:,:,i)=createMontageImage(permute(x(:,:,:,i),[1 2 4 3]));
  %     xm(:,:,i)=createMontageImage(permute(x(:,:,:,i),[ 3 2 4 1]));
end





ana=xm(:,:,1);
xm=xm(:,:,2:end) ;

h=figure('color','w');
imagesc( ana(:,:,[1 1 1]) );
% imagesc( xm(:,:,[1 1 1]) );
hold on;


% usespecificcolor
usemap=1


% tresh=.01
xv=xm.*nan;
for i=1:size(xm,3)
   b2=xm(:,:,i);
   t1 = b2 .* ( b2 >= tresh & b2 <= 1.0 ); % threshold second image
   if usemap==0
   t1(t1>0)=i;
   end
   xv(:,:,i)=t1;
end
ts   =sum(xv,3);
talph=ts;
talph=ts>0;
talph=talph/2;
ih = imagesc( ts, 'tag','myIMAGE');colorbar;
colormap(actc)
talph(talph==0)=nan;
set( ih, 'AlphaData', talph );

try;    
    if isempty(col); 
        col=jet; 
        colmode=2;
    end ;
end
if exist('col')==0

    col={[0 0 1] [1 0 0] [0 1 0] [ 1     1     0]  [0     1     1] [1     0     1]};
colmode=1;
end
if iscell(col)
   eval(['col=[' num2str(col{1}) ']']);
   colmode=2;
end

if colmode==1
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
    colormap(cmap);
    hb=colorbar;
    caxis([1 n2]);
else
    if size(col,1)~=1
        colormap(col);
    else
        colormap(repmat(col,[32 1]));
    end
    hb=colorbar;
end

set(gca,'position',[0 0 1 1]);
set(hb,'position',[0.015 0.1 .01 .2],'xcolor','w','ycolor','w');




function col=colorcheck(col)
cr={   'b' [1 0 0] 
    'g' [0 .5 0] 
    'r' [1 0 0] 
    'c' [0 1 1] 
    'm' [1 0 1] 
    'y' [1 1 0] 
    'k' [0 0 0] 
    'w' [1 1 1] }

for i=1:size(cr,1)
    ix= find(strcmp(col,cr{i,1}) );
    if ~isempty(ix)
        col{  ix} =cr{i,2}
    end
end

%          b     blue          .     point              -     solid
%          g     green         o     circle             :     dotted
%          r     red           x     x-mark             -.    dashdot 
%          c     cyan          +     plus               --    dashed   
%          m     magenta       *     star             (none)  no line
%          y     yellow        s     square
%          k     black         d     diamond
%          w     white         v     triangle (down)
%                              ^     triangle (up)
%                              <     triangle (left)
%                              >     triangle (right)
%                              p     pentagram
%                              h     hexagram
%                         










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






















