
% [  m ]=fsegbrain(f1);
% [  m mv ]=fsegbrain({hh a0});
% m..mask (binary)
% mv..mask with orig values
% EXAMPLES:
%  m=fsegbrain('F:\data5\nogui\dat\1001_copy\t2.nii','volnum',1);
% [m mf]=fsegbrain('F:\data5\nogui\dat\1001_copy\t2.nii','volnum',1,'show',0);


 function [  m mv ]=fsegbrain(f1,varargin)
 
 p.volnum    =1;  %1
 p.show      =1;
 if nargin>1
    pin=cell2struct(varargin(2:2:end),varargin(1:2:end),2);
    p=catstruct(p,pin);
 end
 
 

% ==============================================
%%   
% ===============================================
% cf;clear;clc

volnum      =1;  %1
% imextmin     =1      ;%def:4
% expectclass ='auto'; %'auto'
% sortmode    =1; 
% showit      =1;

% volnum, imextmin,expectclass,sortmode, showit

% f1='F:\data5\nogui\dat\MPM_Pilot_test_retest_c9038_SID_27183_1tailmark_retest\t2.nii'

if ischar(f1)
    hp=spm_vol(f1);
    if length(hp)==1
        [hh a0]=rgetnii(f1);
    else
        [hh a0]=rgetnii(f1,p.volnum);
    end 
else
    hh=f1{1};
    a0=f1{2};
end
abk=a0;
% a=imgaussfilt3(a,0.5);

% montage2(reshape(otsu(a0(:),4),hh.dim)>1 )
a2=a0.*(reshape(otsu(a0(:),4),hh.dim)>1);

%% ====[PBS]===========================================
ec=[];
va=[];
mes=[];
for i=1:3
    m2=squeeze(mean(a2,i));
    %m2=squeeze(max(a2,[],i));
    % m2=squeeze(mean(a2,2));
    % m3=squeeze(mean(a2,3));
    
    q1=imfill(otsu(m2,2),'holes');
    bc=imfill(otsu(m2,2),'holes')==2;
    [bw no]=bwlabel(bc);
    uni=1:no;
    l=[];
    for j=1:length(uni)
        l(j,:)=[ uni(j)   sum(bw(:)==   uni(j)) ];
    end
    l=flipud(sortrows(l,2));
    bw=bw==l(1,1);
    re=regionprops(bw,'Eccentricity');
    ec(1,i)=re.Eccentricity;
    va(1,i)=mean(m2(bw==1));
    
    bm=bw.*squeeze(median(a2,i));
    cir=(   imerode(bw,ones(3))-imerode(bw,ones(4)));
    ot=otsu(bm,3);
    no=mode(ot(cir==1));
    vl=bm(ot==mode(ot(cir==1)));
    mes(i,:)=[mean(vl) std(vl)];
    
end
% ec
% mes
%% ===============================================

minec=min(ec);
mev=[];
if minec<0.2 %circle
%     cprintf('*[0 .5 0]',['TUBE'  '\n'] );
    disp(['...segmenting tube..']);
    aa=abk;
    q=(reshape(otsu(aa(:),3),hh.dim));
    mesd=mes(find(ec==minec),:);
    uni=unique(q(:));
    for i=1:length(uni)
       mev(i,:) =mean(aa(q==uni(i)));
    end
    lev=vecnearest2(mev,mesd(1));
    qm=q==lev;
   qm=(imdilate(qm,ones(5)));
%     q(q==lev)=1;
    aa=aa.*(qm==0);
    aa(qm==1)=mesd(1);
    %aa(q==0)=mesd(1);
    
    i_inbrain=setdiff([1:3],[ 1 lev ]);
    brainval=mev(3);
    tubval=mev(lev);
    
    aa(q~=i_inbrain)=0;
    q2=reshape(otsu(aa(:),3),hh.dim);
    aa(q2==3)=aa(q2==3)./2;
%     aa=aa+100;
    
    if 0
        %     brainval>=tubval
        %     mev
        %     '---'
        %     lev
        if brainval>=tubval
            aa(q==1)=mev(lev,1);
            %         aa=imcomplement(aa);
            %         aa(q==1)=
            %         aa=aa+100;
            %     elseif brainval==tubval
            %         'a'
            
        else
            aa=imcomplement(aa);
            aa=aa+100;
        end
    end
    
    
    a0=aa;
    a2=a0.*(reshape(otsu(a0(:),20),hh.dim)>1);
end

% montage2(aa);
% return

% ==============================================
%%   
% ===============================================

%% ===============================================
si=hh.dim;

o=reshape(otsu(a2(:),20),[si]);
% o=reshape(otsu(a2(:),5),[si]);

bw=double(squeeze(o(:,:,:))>1);
% montage2(bw);
% bw2 = ~bwareaopen(~bw, 10);
% ;montage2(bw2)
D = -bwdist(~bw);
% montage2(D)
% w=imextendedmin(  imcomplement( a2(:,:,40) ) ,1)
w=imextendedmin(  imcomplement( D) ,1);
w2=imcomplement(w);
%% ===============================================

w3=w2;
for i=1:size(w3,3)
    w3(:,:,i)=bwareaopen(w3(:,:,i),100);
    w3(:,:,i)=imerode(w3(:,:,i),ones(3));
    w3(:,:,i)=imfill(w3(:,:,i),'holes');
    
   
    
end
[w4 no]=bwlabeln(w3);
 w5=w4(:);
 uni=1:no;
 l=[];
for i=1:length(uni)
    l(i,:)=[ uni(i)   sum(w5==   uni(i)) ];
end
l=flipud(sortrows(l,2));
percbraininvol=1;
nvox2keep=round(numel(w4)*percbraininvol/100);

ikeep=find(l(:,2)>nvox2keep);
if isempty(ikeep)
    %     try
    %        ikeep= find(l(:,2)>1000);
    %     catch
    %          ikeep=1:4;
    %     end
    %     if isempty(ikeep)
    %         ikeep=1;
    %     end
    % %     w4=w2;
    % %     w5=w4(:);
    % %     l=[];
    % %     ikeep=1;
    % %     l(ikeep,:)=[1   sum(w5) ];
    %% ===============================================
    srun=1;
    for i=1:30
        if srun==1
            w3=imerode(reshape(otsu(abk(:),2),hh.dim)==2, ones(5+i) );
            [w4 no]=bwlabeln(w3);
            w5=w4(:);
            uni=1:no;
            l=[];
            for i=1:length(uni)
                l(i,:)=[ uni(i)   sum(w5==   uni(i)) ];
            end
            l=flipud(sortrows(l,2));
            percbraininvol=0.5;
            nvox2keep=round(numel(w4)*percbraininvol/100);
            
            ikeep=find(l(:,2)>nvox2keep);
            if length(ikeep)>1
                %break
                srun=0;
            end
        end
    end
    %% ===============================================
    

    
end


l=l(ikeep,:);
w6=w5.*0;
for i=1:size(l,1)
    w6(find(w5==l(i,1)))=l(i,1);
end
w6=reshape(w6,size(w4));
 %% ===============================================
 ws=[];
 we=[];
 wk=[];
 wp=[]; %bordering pixe\
 for i=1:size(l,1)
     w7=w6==l(i,1);
     
     %% ===============================================
     di=[1 2; 1 3; 2 3  ];
     wp0=[];
     for j=1:size(di,1)
         le=squeeze(sum(sum(w7,di(j,1)), di(j,2) ));
         percfill=sum(le~=0)./length(le)*100;
         %disp(percfill);
         %wp(i,j)=percfill;
         le2=le([1 end]);
         %disp(le2(:)');
         wp0=[wp0 le2(:)'];
     end
     wp(i,:)=wp0;
     %% ===============================================
     
     
     %sum(w7(:)>0)
     wt=0;
     for j=1:size(w7,3)
         %regionprops(w7(:,:,j),'EulerNumber','solidity')
         r=regionprops(w7(:,:,j),'Solidity');
         if ~isempty(r)
             wt=wt+r(1).Solidity;
         end
     end
     ws(i,1)=wt;
     
     %d=double(w7).*a2;
     wt2=[];
     for j=1:3
         d=squeeze(max(w7,[],j));
         %          fg,imagesc(d.*squeeze(max(o,[],j)))
         r=regionprops(d, 'Orientation');
         try
             wt2(1,j)=r(1).Orientation;
         end
     end
     we(i,:)=wt2;
     
     %      c=w7.*a0;
     
     
     
     % ===============================================
     
     ss=[];
     for j=1:3
         c=w7.*a0;
         %  c2=imgradient(squeeze(max(c,[],1)),'sobel') ;
         cm=squeeze(max(c,[],j));
         ma=cm>0;
         %      cb=squeeze(max(c,[],1));
         %      cm=c2>0;
         props = regionprops(ma,'BoundingBox');
         bb = round(props(1).BoundingBox);
         
         
         om = imcrop(cm, bb) ;
         om=imgaussfilt(om,1);
         
         of = fliplr(om);
         mv1 = sum(sum(om & of)) / sum(sum(om | of));% Overlap metric: Jaccard index (IoU)
         of = flipud(om);
         mv2 = sum(sum(om & of)) / sum(sum(om | of));% Overlap metric: Jaccard index (IoU)
         %disp([mv1 mv2 ]);
         ss=[ss mv1 mv2];
         
         %      fg,imagesc(om)
         %      fg,imagesc(of)
         
     end
     wk(i,:)=ss;
 end
 wk=max(wk,[],2);
 we=180-mean(abs(we),2);
%% ===============================================
l2=l;
t1=[l2(:,2) ws we wk ];
% remove large bordering cluster
idel=find( sum(wp,2)>100);
if ~isempty(idel) && size(t1,1)>1
    t1(idel,:)=[];
    l2(idel,:)=[];
end



if size(t1,1)==1
    t2=t1;
    ix=1;
    score=t2;
else
    colMin = min(t1,[],1);
    colMax = max(t1,[],1);
    % normalize each column
    t2 = bsxfun(@rdivide, bsxfun(@minus, t1, colMin), (colMax - colMin));
    score=mean(t2,2);
    ix=find(score==max(score));
end
if length(ix)>1
    ix=ix(1);
end


m=w6==l2(ix,1);
m=imdilate(m,ones(3));
mv=abk.*m;
% disp(score);
if  p.show ==1
    montage2(m);
end



