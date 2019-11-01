

function out=CTgetbrain_approach1(z, pa)




% ############################# START APPROACH HERE #######################################################


%============================================================================================================================================
%% getting CT image
%============================================================================================================================================


cprintf([.87 .490 0], [ 'using METHOD-1' ]);

try
    cprintf([.87 .490 0], [ '.. reading image [' z.CTimg ']'  ]);
catch
    fprintf(['.. reading image [' z.CTimg ']']);
end

[ha a]=rgetnii(fullfile(pa, z.CTimg ));
si=size(a);
a2=a(:);
a3=reshape((otsu(a2,3)),si);
a4=a3==3;

% a3=reshape((otsu(a2,4)),si);
% a4=a3>3;
%============================================================================================================================================
%%   S1: extracting brain: axial
%============================================================================================================================================

fprintf(['.. get brain from skull: steps 1']);
do=1;
jj=0;
while do==1
    no=6+jj;
    jj=jj+1;
    nv=-no:no;
    x=zeros(size(a4));
    for i=1:size(a4,3)
        vc=nv+i;
        vc(vc<1)=[];
        vc(vc>size(a4,3))=[];
        
        r=mean(a4(:,:,vc),3);
        r=r>0;
        r1=imdilate(r,ones(4));
        r2=imfill(r1,'holes');
        r3=imerode(r,ones(4));
        r4=imdilate(r2-r1,ones(5));
        
        x(:,:,i)=r4>0;
        
        if 0
            figure(10)
            subplot(2,2,1);imagesc(r)
            subplot(2,2,2);imagesc(a4(:,:,i))
            subplot(2,2,3);imagesc(r4*3+r); title(i);
            subplot(2,2,4);imagesc(r4*3+a4(:,:,i)); title(i);
            pause; drawnow
        end
    end
    
    
    % missing slice
    
    %     fg,imagesc(squeeze(mean(x,2)))
    wm=squeeze(mean(mean(x,2),1));
    ix=find(wm==0);
    ix(  find(ix<  round(size(x,3)*.2)  )   )=[];
    ix(  find(ix>  size(x,3)-round(size(x,3)*.2)  )   )=[];
    if isempty(ix)
        do=0;
    end
    
end


%============================================================================================================================================
%%   S2: extracting brain: topdown
%============================================================================================================================================

fprintf(['.2']);
lim=4;
vc=[-lim:lim];
xv=zeros(size(x));
for i=1:size(x,2)
    ix=vc+i;
    ix(ix<1)=[];
    ix(ix>size(x,2))=[];
    
    ar  =squeeze(a4(:,i,:));
    ar2 =squeeze(a4(:,ix,:));
    ar2 =squeeze(mean(a4(:,ix,:),2))>0;
    
    br=squeeze( x(:,i,:));
    rd  =imfill(ar+br,'holes')-ar;
    rd2 =imfill(ar2+br,'holes')-ar2;
    rd3=(rd2+rd)>0;
    xv(:,i,:)=rd3;
    
    if 0
        figure(10)
        subplot(2,2,1); imagesc(ar); title(i);
        subplot(2,2,2); imagesc(br);
        subplot(2,2,3); imagesc(ar+2*rd);
        subplot(2,2,4); imagesc(ar+2*rd3);
        drawnow; pause
    end
end

%============================================================================================================================================
%%   S3: extracting brain: sagittal
%============================================================================================================================================

fprintf(['.3']);
lim=8;
vc=[-lim:lim];
xh=zeros(size(x));
for i=1:size(x,1)
    ix=vc+i;
    ix(ix<1)=[];
    ix(ix>size(x,1))=[];
    
    ar  =squeeze(a4(i,:,:));
    ar2 =squeeze(a4(ix,:,:));
    ar2 =squeeze(mean(a4(ix,:,:),1))>0;
    
    br=squeeze( x(i,:,:));
    rd  =imfill(ar+br,'holes')-ar;
    rd2 =imfill(ar2+br,'holes')-ar2;
    rd3=(rd2+rd)>0;
    xh(i,:,:)=rd3;
    
    if 0
        figure(10)
        subplot(2,2,1); imagesc(ar); title(i);
        subplot(2,2,2); imagesc(br);
        subplot(2,2,3); imagesc(ar+2*rd);
        subplot(2,2,4); imagesc(ar+2*rd3);
        drawnow; pause
    end
end



%============================================================================================================================================
%%  updating skull
%============================================================================================================================================

x=xh;


%============================================================================================================================================
%%   cluster image
%============================================================================================================================================
fprintf(['..clustering']);
%% remove other cluster
[b2 n]=bwlabeln(double(x),6);
uni=[1:(n)]';
nx=histc(b2(:),uni);
tb=sortrows([nx uni],1);
x2=(b2==tb(end,2));

%============================================================================================================================================
%%   find connected clusters
%============================================================================================================================================
fprintf(['..connectedness']);
x3=x2;
mid=round(size(x3,3)/2);
mx=x3(:,:,mid );
[b2 n2]=bwlabeln(mx);
uni=[1:n2]';
if n2>1
    nr=histc(b2(:),uni);
    nuni=sortrows([nr uni],1);
    b2lab=nuni(end,2);
else
    b2lab=1;
end
x3(:,:,mid) = b2==b2lab;


i1=[round(size(x3,3)/2)-1:-1:1 round(size(x3,3)/2)+1: size(x3,3) ];
i2=[[[round(size(x3,3)/2)-1:-1:1]+1] [[round(size(x3,3)/2)+1: size(x3,3)]-1] ];
for i=1:length(i1)
    r1=x3(:,:,i2(i));
    e1=x3(:,:,i1(i));
    
    [b1 n1]=bwlabeln(e1);
    [b2 n2]=bwlabeln(r1);
    
    uni=[1:n2]';
    if n2>1
        nr=histc(b2(:),uni);
        nuni=sortrows([nr uni],1);
        b2lab=nuni(end,2)
    else
        b2lab=1;
    end
    
    
    uni=unique(b1(b2==b2lab));
    uni(uni==0)=[];
    
    if 0
        figure(11);
        imagesc([e1 r1]), title(i1(i));
    end
    
    
    if length(uni)==1
        x3(:,:,i1(i))=(b1==uni);
    elseif length(uni)>1
        
        
        me=b1(b2==1);
        nr=histc(me,uni);
        nuni=sortrows([nr uni],1);
        uni=nuni(end,2);
        x3(:,:,i1(i))=(b1==uni);
    else
        %          keyboard
        x3(:,:,i1(i))=0;
    end
    
    
    
    
    
    if 0
        %     figure(11);
        %    imagesc([e1 r1]), title(i1(i));
        drawnow;pause
    end
end

%============================================================================================================================================
%%   remove tail
%============================================================================================================================================
fprintf(['..remove tail']);

df=abs(diff(squeeze(sum(sum(x3,1),2))));
dr=df<median(df);
t1=min(find(dr~=1));
t2=max(find(dr~=1));
if t1~=1; t1=t1-1; end
if t2~=size(x3,3); t2=t2+1; end

x4=x3;
x4(:,:,1:t1)  =0;
x4(:,:,t2:end)=0;


if 0
    fg,imagesc(squeeze(mean(x4,1)))
    %%
end

%———————————————————————————————————————————————
%% dilate/erode brain
%———————————————————————————————————————————————

% dilation of 2 seems to be good
if z.dilate~=0
    if z.dilate>0
        fprintf(['..dilate brain (nvx: ' num2str(z.dilate) ')']);
        x5=imdilate(x4,strel('disk',  z.dilate  ));
    elseif z.dilate<0
        fprintf(['..erode brain (nvx: ' num2str(z.dilate) ')']);
        x5=imerode(x4,strel('disk',   abs(z.dilate) ));   
    end
else
    x5=x4;
end

% ERODE--> increases brain in ALLENSPACE
% v10=imerode(v9,strel('disk',4));


%============================================================================================================================================
%%   write CTbrain image
%============================================================================================================================================
% keyboard
fprintf(['..write vol']);

hv  =ha;
hv  =rmfield(hv,'private');
hv  =rmfield(hv,'pinfo');
hv.descrip =['source: ' z.CTimg];
mov =fullfile(pa,'_brainCT.nii');
rsavenii(mov,[hv],uint8(x5),[2 0]);

fprintf(['.[done]\n']);

%============================================================================================================================================
%%   write ref image (ix_AVGT)
%============================================================================================================================================
fprintf(['.. write REFvol']);
[hb b]=rgetnii(fullfile(pa,z.fix)); % fix: 'ix_AVGT.nii'
fix=fullfile(pa,'_brainAllen.nii');
rsavenii(fix,[hb],uint8(b>50),[2 0]);
%rmricron([],mov,fix, 2,[20 -1])


out.fix=fix;
out.mov=mov;

% ############################# END APPROACH HERE #######################################################