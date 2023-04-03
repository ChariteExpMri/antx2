
%% skullstrip2(t2file,ford,ocr,bordTR,objTR,doplot,dosave)
% t2file='D:\Paul\data1\Leduc_adc_regist\dat\L13_post\t2.nii'
% ford=5;   %3d-median filter order
% ocr=[3:10]; %ocr. otsu-class-range classes to separate example; [3]..3 classes; [3:10]..iteratively 3,4,..10 classes
% cclust    : keep connected cluster; [0] take all objects, [1] use only connected centered cluster
% bordTR=20; %if object has more than x-percent of bordervoxels (xy-double-frame) --<remove this object
% objTR=1; %remove small object with object-size < value-percent of slice size; (default: 1% of sliceSize)
% doplot=0; %[0]silent [1]plots [2]show final plot in mricron
% dosave=1  ; %save image
% skullstrip2(t2file,ford,ocr,bordTR,objTR,doplot,dosave)



function skullstrip2(t2file,ford,ocr,cclust,bordTR,objTR,doplot,dosave)

%% ============data ===============================================
if 0
    cf
    t2file='D:\Paul\data1\Leduc_adc_regist\dat\L13_post\t2.nii'
    ford=5;   %3d-median filter order
    ocr=[3:10]; %ocr. otsuclassrange classes to separate example [3:10]
    cclust=1; %use only connected centered cluster 
    bordTR=20; %if object has more than x-percent of bordervoxels (xy-double-frame) --<remove this object
    objTR=1; %remove small object with object-size < value-percent of slice size; (default: 1% of sliceSize)
    doplot=0; %[0]silent [1]plots [2]show final plot in mricron
    dosave=1  ; %save image
    skullstrip2(t2file,ford,ocr,cclust,bordTR,objTR,doplot,dosave)
    
    skullstrip2(t2file,5,[3:10],1,20,1,0,1);
end







%% ============data ===============================================
% addpath('C:\Users\SVC-AG-TierMRT\Downloads\ordfilt3')
% 
% dum='D:\Paul\data1\Leduc_adc_regist\dat\L13_post\adc.nii'
% [ha a]=rgetnii(dum);
[ha a]=rgetnii(t2file);

%% ============median filter ===============================================

% medfltord=4
f=a;
% f2=medfilt2(f,[11 11]);
if ford==0
    f2=f;
else
    [f2] = ordfilt3D(f,ford);
end

% if doplot
% montage2(f2)
% end
%% ===========================================================
%% OTSU
%% ===========================================================

it=1;
% cf
for j=ocr
    nclass=j;
    k=reshape(otsu(f2(:),nclass),[ha.dim]);
    % montage2(k)
    
    
    si=size(a);
    bord=repmat(padarray(zeros(si(1)-4,si(2)-4),[2 2],1),[1 1 si(3)]);
    
    un=unique(k(:));
    ac=zeros([size(a) length(un)]);
    pbord=[];
    for i=1:length(un)
        ac(:,:,:,i)=double(k==un(i));
        ac(:,:,:,i)=imerode(ac(:,:,:,i),strel('disk',3));
        ac(:,:,:,i)=imdilate(ac(:,:,:,i),strel('disk',3));
        ac(:,:,:,i)=imfill(ac(:,:,:,i),'holes');
        r=bwlabeln(ac(:,:,:,i));
        %     montage2(r)
        unir=unique(r(:));
        unir(unir==0)=[];
        if ~isempty(unir)
            tb=flipud(sortrows([unir histc(r(:),unir)],2));
            maxclustID=tb(1,1);
            ac(:,:,:,i)=double( r==maxclustID);
        else
            ac(:,:,:,i)=double( r.*0);
        end
        
        % numVox in border
        nb=(bord.*r)>0;
        pbord(i,1)=sum(nb(:))./sum(bord(:));
        
    end
    % montage2(ac)
    
    
    % h = fspecial('gaussian',[size(a,1) size(a,2)], mean([size(a,1) size(a,2)]) );
    % fg,plot(h)
    si=size(a);
    % si=[20 30]
    ra=repmat(hanning(si(1)), [1 si(2)]);
    rb=repmat(hanning(si(2))', [si(1) 1]);
    ke=(ra.*rb);
    ke3=repmat(ke,[1 1 si(3)]);
    ke4=repmat(ke3,[1 1 1 length(un)]);
    
    
    % montage2(ke4.*ac)
    
    rp=ke4.*ac;
    rp(rp==0)=nan;
    % p3=[];
    % for i=1:size(rp,4)
    %     ds=rp(:,:,:,i);
    %     ds=ds(:);
    %     p3(i,1)=prod(ds(~isnan(ds(:))));
    % end
    %
%     j
%     if j==10
%         'a'
%     end

    pp=squeeze(nanmedian(nanmean(nanmean(rp,1),2),3));
    nv=round(squeeze(nansum(nansum(nansum(~isnan(rp),1),2),3)));
%     disp(['nclass:' num2str(nclass)]);
%     disp(pp)
    
    maxpn=pp.*nv;
    %bordTR=.20; %20 percent threshold
    nonbordclust=pbord<(bordTR/100);
    krit=pp.*nv.*nonbordclust;
    sel=krit==max(krit);
    imax=find(sel);
    % uhelp(plog([],[[pp nv maxpn pbord nonbordclust krit sel]],0,'..','s=2'),1);
    
    
    
    
    % it=1
    ma1(:,:,:,it)=ac(:,:,:,imax);
    pm1(:,:,:,it)=ac(:,:,:,imax).*ke3;
    dx=ac(:,:,:,imax);
    dp=pm1(:,:,:,it); dp(dp==0)=nan;
    
    nvox=sum(dx(:)>0);
    vol(it,1)=abs(det(ha.mat(1:3,1:3)))*nvox;
    prop(it,1)=nanmean(dp(:));
    
    
    % montage2(ac(:,:,:,imax))
    
    it=it+1;
end

%% ===========================================================
%%  morph OPS
%% ===========================================================

r=nansum(ma1,4);
r2=reshape(otsu(r(:),2),[ha.dim]);
r2=r2==max(r2(:));
if doplot==1; montage2(r2); title([repmat(' ',[1 50]) ' after otsu']); end


r3=imclose(r2, strel('disk',4));
if doplot==1; montage2(r3); title([repmat(' ',[1 50]) ' closing image']); end

r4=r3;
for i=1:size(r4,3)
    r4(:,:,i)=imfill(r3(:,:,i),'holes');
end
if doplot==1; montage2(r4); title([repmat(' ',[1 50]) ' fill holes']); end


r5=imerode(r4,strel('disk',1));

% ------------------- remove small stuff -------------------
% objTR=1; %percent

ms=zeros(size(r5));
for i=1:size(ms,3)
%     ms(:,:,i)=...
%         imcomplement(bwareafilt(r5(:,:,i)==1,[0 si(1).*dimsizeTR.*si(2).*dimsizeTR]));
   ms(:,:,i)=...
         imcomplement(bwareafilt(r5(:,:,i)==1,[0   si(1)*si(2)*objTR/100 ]));
end
r6=r5.*ms;
if doplot==1; montage2(r6); title([repmat(' ',[1 50]) ' remove smaller objects']); end



if doplot==1;
    imoverlay(double(montageout(montageout(permute(a,[1 2 4 3])))),double(montageout(permute(r6,[1 2 4 3]))));
    title([repmat(' ',[1 50]) ' final mask']);
end

%% ===========================================================
%%  keep center cluster
%% ===========================================================
if cclust==1
    [dx num]=bwlabeln(r6);
    tp=[];
    num=unique(dx(:));num(num==0)=[];
    for i=1:length(num)
        dy=double(dx==num(i));
        dp=ke3.*dy;
        dp(dp==0)=nan;
        tp(i,:)=[num(i) nansum(dp(:))];
    end
    
    imax=find(tp(:,2)==max(tp(:,2)));
    r6=double(dx==tp(imax,1));
end

%% ===========================================================
%%  save imgae
%% ===========================================================
if dosave==1
    fileout=fullfile(fileparts(t2file),'_msk.nii');
    rsavenii(fileout,ha,r6.*a);
    if doplot==1 || doplot==2;
        drawnow;
        rmricron([],t2file,fileout,1);
    end
end



