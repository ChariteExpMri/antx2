
function bla


% aa='V:\projects\atlasRegEdemaCorr\nii32\s20150908_FK_C1M01_1_3_1_1\_Atpl_mouseatlasNew_left.nii'
% bb='V:\projects\atlasRegEdemaCorr\nii32\s20150908_FK_C1M01_1_3_1_1\elx_T2_left-0.nii'

aa='V:\projects\atlasRegEdemaCorr\nii32\s20150908_FK_C1M01_1_3_1_1\_Atpl_mouseatlasNew.nii'
% bb='V:\projects\atlasRegEdemaCorr\nii32\s20150908_FK_C1M01_1_3_1_1\hx_T2.nii'
 bb='V:\projects\atlasRegEdemaCorr\nii32\s20150908_FK_C1M01_1_3_1_1\elx_T2-0.nii'
 
%  
%  aa='C:\Users\skoch\Desktop\overlay\hx_c2T2.nii'
%  bb='C:\Users\skoch\Desktop\overlay\hx_c1T2.nii'

 aa='C:\Users\skoch\Desktop\overlay\_Atpl_mouseatlasNew.nii'
 bb='C:\Users\skoch\Desktop\overlay\T2.nii' 
 
 
  aa='O:\harms1\koeln\dat\s20150701_AA1\sAVGT.nii'
  bb='O:\harms1\koeln\dat\s20150701_AA1\x_t2.nii'
 

[ha a]=rgetnii(aa);
[hb b]=rgetnii(bb);

% [hb b]=rreslice2target(hb,b,ha);
[hb b]=rreslice2target(hb,ha);
a=a-min(a(:));   a=a./max(a(:));
b=b-min(b(:));   b=b./max(b(:));

nn=12
a1=(squeeze(a(:,nn,:)));
b1=(squeeze(b(:,nn,:)));

npix=50; %number of voxels within puzzle
nrep=ceil(size(a1)./(2*npix))
cb=checkerboard(npix,nrep( 1 ),nrep(2));
cb=cb(1:size(a1,1),1:size(a1,2));
cb(cb<.5)=0;cb(cb>=.5)=1;

c1=cb; c1(c1==0)=nan;
c2=cb; c2(c2==1)=nan;c2(c2==0)=1;

% fg,imagesc(nanmean(cat(3,a1.*c1,b1.*c2),3))
% fg,imagesc(nanmean(cat(3,imadjust(a1).*c1,imadjust(b1).*c2),3))

% c1
% fg,imagesc(c1)
% return
% slic=[30 60 100 120 150]

ns=30  %nslices
bord=15; %start top from border
slic=round(linspace(bord,size(a,2)-bord,ns));
dum2=[];
for i=1:length(slic)
    
    
    
    nn=slic(i);
    a1=(squeeze(a(:,nn,:)));
    b1=(squeeze(b(:,nn,:)));
%     a1=a1-min(a1(:));   a1=a1./max(a1(:));
%     b1=b1-min(b1(:));   b1=b1./max(b1(:));
    
    a1=imadjust(a1);
    b1=imadjust(b1);
%     as=cat(3,a1,a1,a1);bs=cat(3,b1,b1,b1);
%     fg,image(bs); hold on;c=contour(a1,3,'linewidth',2,'linestyle','--')
%     
%     v=contourc(a1,3)'
%     
%     continue
    
    npix=5;
    nrep=ceil(size(a1)./(2*npix));
    cb=checkerboard(npix,nrep( 1 ),nrep(2));
    cb=cb(1:size(a1,1),1:size(a1,2));
    cb(cb<.5)=0;cb(cb>=.5)=1;
    
    c1=cb; c1(c1==0)=nan;
    c2=cb; c2(c2==1)=nan;c2(c2==0)=1;
    
    % fg,imagesc(nanmean(cat(3,a1.*c1,b1.*c2),3))
%     fg,imagesc(nanmean(cat(3,imadjust(a1).*c1,imadjust(b1).*c2),3))
    
    dum=nanmean(cat(3,imadjust(a1).*c1,imadjust(b1).*c2),3);
    dum2(:,:,i)=dum;
end
% fg,imagesc(reshape(dum2,[ 165 135*size(dum2,3)  ]))

% r=reshape(dum2,[ 165 135*4  ])
% vb=[2 4]
[vb ,n]=numSubplots(ns);

si=size(dum2)
e=[];n=1
for i=1:vb(1)
    for j=1:vb(2)
        if n<=size(dum2,3) 
            e(si(1)*i-si(1)+1:si(1)*i-si(1)+si(1),  si(2)*j-si(2)+1:si(2)*j-si(2)+si(2)   )=dum2(:,:,n);
       
        n=n+1;
         end
    end
end

e=flipud(e');
fg,imagesc(e)

function [p,n]=numSubplots(n)
% function [p,n]=numSubplots(n)
%
% Purpose
% Calculate how many rows and columns of sub-plots are needed to
% neatly display n subplots. 
%
% Inputs
% n - the desired number of subplots.     
%  
% Outputs
% p - a vector length 2 defining the number of rows and number of
%     columns required to show n plots.     
% [ n - the current number of subplots. This output is used only by
%       this function for a recursive call.]
%
%
%
% Example: neatly lay out 13 sub-plots
% >> p=numSubplots(13)
% p = 
%     3   5
% for i=1:13; subplot(p(1),p(2),i), pcolor(rand(10)), end 
%
%
% Rob Campbell - January 2010
   
    
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


%Reformat if the column/row ratio is too large: we want a roughly
%square design 
while p(2)/p(1)>2.5
    N=n+1;
    [p,n]=numSubplots(N); %Recursive!
end









