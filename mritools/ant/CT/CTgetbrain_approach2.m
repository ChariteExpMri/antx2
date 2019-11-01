

function out=CTgetbrain_approach2(z, pa)




% ############################# START APPROACH HERE #######################################################


%============================================================================================================================================
%% getting CT image
%============================================================================================================================================

cprintf([.87 .490 0], [ 'using METHOD-2' ]);

try
    cprintf([.87 .490 0], [ '.. reading image [' z.CTimg ']'  ]);
catch
    fprintf(['.. reading image [' z.CTimg ']']);
end

[ha a]=rgetnii(fullfile(pa, z.CTimg ));
si=size(a);

%
% fprintf(['.. get brain from skull: steps 1']);
% fprintf(['.2']);
% fprintf(['..connectedness']);


%�����������������������������������������������
%%   [1] otsu and take largest usefull cluster
%�����������������������������������������������
fprintf(['..otsu-ct (get proper cluster)']);

v=otsu(a(:),5);
v=reshape(v,size(a));
v(v==1)=0;
v(v==2)=0;
v(v==3)=0;


[bx n]=bwlabeln(v>0);
uni=unique(bx); uni(uni==0)=[];
[c ]=histc(bx(:),uni);
tb=sortrows([uni(:) c],2);

% v2=bx==tb(end,1); %take largest cluster



%% --which cluster--------------
voxsi=abs(det(ha.mat(1:3,1:3)));

% BBboxwithin=.5;
% sid=size(a);
% bboxin=zeros(sid);
% fillind=round((sid-(sid*BBboxwithin))/2);
% bboxin(...
%     fillind(1):end-fillind(1)+1,...
%     fillind(2):end-fillind(2)+1,...
%     fillind(3):end-fillind(3)+1)=1;
% montage2(bboxin+double(bx==tb(end-1,1)));
% montage2(bboxin+double(bx==tb(end,1)));

% tc=bx==tb(end-2,1); disp(round([sum(bboxin(tc)) sum(tc(:)==1)  sum(bboxin(tc))/sum(tc(:)==1)*100  ]))
% tc=bx==tb(end-1,1); disp(round([sum(bboxin(tc)) sum(tc(:)==1)  sum(bboxin(tc))/sum(tc(:)==1)*100  ]))
% tc=bx==tb(end  ,1); disp(round([sum(bboxin(tc)) sum(tc(:)==1)  sum(bboxin(tc))/sum(tc(:)==1)*100  ]))

% 
% tc=bx==tb(end  ,1);
% rv=squeeze(sum(tc,1)>0); fg;imagesc(rv); sum(rv(:)==1)/numel(rv)*100
% rv=squeeze(sum(tc,2)>0); fg;imagesc(rv); sum(rv(:)==1)/numel(rv)*100
% rv=squeeze(sum(tc,3)>0); fg;imagesc(rv); sum(rv(:)==1)/numel(rv)*100
% 
% tc=bx==tb(end-1  ,1);
% rv=squeeze(sum(tc,1)>0); fg;imagesc(rv); sum(rv(:)==1)/numel(rv)*100
% rv=squeeze(sum(tc,2)>0); fg;imagesc(rv); sum(rv(:)==1)/numel(rv)*100
% rv=squeeze(sum(tc,3)>0); fg;imagesc(rv); sum(rv(:)==1)/numel(rv)*100

% rv=squeeze(sum(tc,1)>0);

tb3=[];
for j=0:3
    tc=bx==tb(end-j   ,1);
    rv1=squeeze(sum(tc,1)>0); %fg;imagesc(rv1);
    rv2=squeeze(sum(tc,2)>0); %fg;imagesc(rv2);
    rv3=squeeze(sum(tc,3)>0); %fg;imagesc(rv3);
    vol=round(sum(sum(rv1,1).*sum(rv2,1))*voxsi);
    perc=(sum(rv1(:)==1)+sum(rv2(:)==1))/(numel(rv1)+numel(rv2))*100;
    
    vol3=[round(round(sum(pi*((sum(rv1,1)/2).^2)))*voxsi)
          round(round(sum(pi*((sum(rv2,1)/2).^2)))*voxsi)
          round(round(sum(pi*((sum(rv3,1)/2).^2)))*voxsi)];
    
    tb3(j+1,:)=round([ size(tb,1)-j vol perc median(vol3) ] );
end
%tb3:header: clusterNUM bonebrainvolRectangle percVolInImage bonebrainvolElipsoidal
% here we use bonebrainvolElipsoidal
% iclust=tb3(vecnearest2(tb3(:,4),1500),1);
iclust=tb3(vecnearest2(tb3(:,4),z.bonebrainvolume),1);
v2=bx==tb(iclust,1); %take largest cluster

%�����������������������������������������������
%%   old
%�����������������������������������������������

% if 0
%
%     v3=v2;
%     v4=v3;
%     ns=3;
%     t=[[1:size(v3,3)]'];
%     t(:,2:3)=[t-ns t+ns]
%     for i=1:size(v3,3)
%         ix=t(i,2):t(i,3);
%         ix=ix(ix>0 & ix<=size(v3,3));
%
%         r=max(v2(:,:,ix),[],3);
%         rt=v2(:,:,i);
%         rr=double((r+rt)>0);
%         v3(:,:,i)=rr;
%         rx=imcomplement(rr+bwmorph(rr,'remove'));
%         v4(:,:,i)=rx;
%     end
%
% end

%�����������������������������������������������
%%   find bone-boundy using MIP of neighbouring slices
%�����������������������������������������������

fprintf(['..find SKULL (neighb. MIP approach)']);


v3=v2;
ns=2; %number of slices for MIP
for j=1:3
    if j==1
        vv= permute(v3,[3 2 1]);  vz= permute(v2,[3 2 1]);
    elseif j==2
        vv= permute(v3,[1 3 2]);  vz= permute(v2,[1 3 2]);
    elseif j==3
        vv= permute(v3,[1 2 3]);   vz= permute(v2,[1 2 3]);
    end
    
    %     disp(j);
    
    t=[[1:size(vv,3)]'];
    t(:,2:3)=[t-ns t+ns];
    for i=1:size(vv,3)
        ix=t(i,2):t(i,3);
        ix=ix(ix>0 & ix<=size(vv,3));
        
        
        r=max(vz(:,:,ix),[],3);
        rt=vz(:,:,i);
        rr=double((r+rt)>0);
        vv(:,:,i)= vv(:,:,i)+rr;
    end
    
    if j==1
        v3= permute(vv,[3 2 1]);
    elseif j==2
        v3= permute(vv,[1 3 2]);
    elseif j==3
        v3= permute(vv,[1 2 3]);
    end
    
end


v4=v3;
for i=1:size(v4,3)
    rr=v3(:,:,i);
    rx=imcomplement(rr+bwmorph(rr,'remove'));
    v4(:,:,i)=rx;
end

%�����������������������������������������������
%%   watershed
%�����������������������������������������������
fprintf(['..cluster(watershed)']);



%%  rr
v5=v4;
for i=1:size(v4,3)
    %disp(i);
    %disp('watershed');
    
    bw=v4(:,:,i);
    D = -bwdist(~bw);
    Ld = watershed(D);
    
    bw2 = bw;
    bw2(Ld == 0) = 0;
    mask = imextendedmin(D,1);
    
    D2 = imimposemin(D,mask);
    Ld2 = watershed(D2);
    bw3 = bw;
    bw3(Ld2 == 0) = 0;
    
    u4=bw3;
    v5(:,:,i)=u4;
end

%% remove image edge cluster
fprintf(['..remove edge cluster']);
v6=v5;
for i=1:size(v5,3)
    %disp(i);
    
    bw    =v5(:,:,i);
    [bx n]=bwlabeln(bw);
    del =[unique(bx(:,1:2)); unique(bx(:,end-1:end)) ; % remove outer cluster
        unique(bx(1:2,:)); unique(bx(end-1:end,:)) ];
    ikeep=setdiff([1:n], del);
    bs=bw.*0;
    for j=1:length(ikeep)
        bs=bs+double(bx==ikeep(j));
    end
    v6(:,:,i)=bs;
end

%%  get cluster sizes
fprintf(['..get cluster sizes']);
v7=double(v6);
cl=[];
for i=1:size(v6,3)
    %disp(i);
    
    bw=v6(:,:,i);
    [bx n]=bwlabeln(bw);
    v7(:,:,i)=bx;
    
    uni=unique(bx); uni(uni==0)=[];
    [c ]=histc(bx(:),uni);
    rp=repmat([i n],[n 1]);
    tb=[ rp uni(:) c  ];
    
    cl=[cl;tb];
end

%�����������������������������������������������
%%  find connected clusters
%�����������������������������������������������
fprintf(['..find brain clusters']);

mit=round(size(v7,3)/2);  % middle slice

t=...
    [[[mit:size(v7,3)-1]' [mit+1:size(v7,3)]'];
    [[mit:-1:2]' [mit-1:-1:1]']];

v8  =v7.*0;
f   =cl(find(cl(:,1)==mit),:);
mx  =f(max(find(f(:,4)==max(f(:,4)))),4);
mn  =round(mx.*.5);
icl =f(find(f(:,4)>mn),3);
b   =v7(:,:,mit);
b2  =b.*0;

for j=1:length(icl)
    b2=b2+double(b==icl(j));
end
v8(:,:,mit)=b2;


for i=1:size(t,1)
    i1=t(i,1);
    i2=t(i,2);
    
    b1=v8(:,:,i1);
    b2=v7(:,:,i2);
    
    f=cl(find(cl(:,1)==i2),:);
    
    %     exb=(imdilate(b1,strel('disk',0)));%extendend brain
    exb=(imerode(b1,strel('disk',1)));%extendend brain
    krit=unique(b2(exb==1)); krit(krit==0)=[];  % cluster inside extended brain
    if ~isempty(krit)
        % check mass of krit. cluster inside/outside extended brain
        tg=[];
        for j=1:length(krit)
            k1=b2(:)==krit(j);
            tg(j,:)=[ krit(j)  sum(k1.*exb(:)) sum(k1) ];
        end
        tg(:,4)=100.*(tg(:,2)./tg(:,3)); % percent inside extendend brain
        
        percInside=51;
        iclkeep=tg(find(tg(:,4)>percInside),1);
        icl=iclkeep;
        %icl=setdiff(f(:,3),noticl);
        
        % %     if 0
        % %         icl=unique(b2(b1==1));
        % %         icl(icl==0)=[];
        % %
        % %         f=cl(find(cl(:,1)==i2),:);
        % %         mx=[];
        % %         for j=1:length(icl)
        % %             mx=[mx f(find(f(:,3)==icl(j)),4)];
        % %         end
        % %
        % %         mn=round(max(mx).*.50); %prev 75
        % %         iuse=find(mx>mn);
        % %         icl=icl(iuse);
        % %     end
        
        
        b3=b2.*0;
        for j=1:length(icl)
            b3=b3+double(b2==icl(j));
        end
        
        if sum(b3(:))<20
            b3=b3.*0;
        end
        
        if 0
            if i>1%i>=200
                figure(10); imagesc([[b1 b2; b3 b3.*0] ]); title(i); pause
            end
        end
        
        v8(:,:,i2)=b3;
    end% krit
end


%�����������������������������������������������
%% clean brain boundaries
%�����������������������������������������������
fprintf(['..clean boundaries']);
v9=v8;
for i=1:size(v8,3)
    rr=v8(:,:,i);
    %     r2=imopen(imclose(rr,strel('disk',5)),strel('disk',5));
    r2=imopen(imclose(rr,strel('disk',5)),strel('disk',2));
    %     figure(11), imagesc([rr r2]); title(i); drawnow; pause
    
    v9(:,:,i)=r2;
    
end

 

%�����������������������������������������������
%% dilate/erode brain
%�����������������������������������������������

% dilation of 2 seems to be good
if z.dilate~=0
    if z.dilate>0
        fprintf(['..dilate brain (nvx: ' num2str(z.dilate) ')']);
        v10=imdilate(v9,strel('disk',  z.dilate  ));
    elseif z.dilate<0
        fprintf(['..erode brain (nvx: ' num2str(z.dilate) ')']);
        v10=imerode(v9,strel('disk',  abs( z.dilate) ));   
    end
else
    v10=v9;
end

% ERODE--> increases brain in ALLENSPACE
% v10=imerode(v9,strel('disk',4));

%�����������������������������������������������
%%  save file
%�����������������������������������������������
% % % rx=v9;
% % % hx=ha;
% % % hx.dt=[2 0];
% % % 
% % % hx=rmfield(hx,'private')
% % % hx=rmfield(hx,'pinfo')
% % % rsavenii('test2.nii',hx, double(rx));
% % % 





%============================================================================================================================================
%%   write CTbrain image
%============================================================================================================================================

xx = v10; 


fprintf(['..write vol']);
hv  =ha;
hv  =rmfield(hv,'private');
hv  =rmfield(hv,'pinfo');
hv.descrip =['source: ' z.CTimg];
mov =fullfile(pa,'_brainCT.nii');
rsavenii(mov,[hv],uint8(xx),[2 0]);

fprintf(['.[done]\n']);

%============================================================================================================================================
%%   write ref image (ix_AVGT)
%============================================================================================================================================
fprintf(['.. write REFvol']);
[hb b]=rgetnii(fullfile(pa,z.fix)); % fix: 'ix_AVGT.nii'
fix  =fullfile(pa,'_brainAllen.nii');
rsavenii(fix,[hb],uint8(b>50),[2 0]);
%rmricron([],mov,fix, 2,[20 -1])


out.fix=fix;
out.mov=mov;

% ############################# END APPROACH HERE #######################################################