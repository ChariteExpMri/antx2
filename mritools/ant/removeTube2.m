 
 
% ==============================================
%%   tubesegment2
% ===============================================
% subfunction: Exvivo-data with high-contrast (PBS) solution --> remove exvivo-tube  use imcomplement+otsu
% q=removeTube2(fullfile(pa,'t2.nii'));
% 
% EXAMPLES:
% f1='F:\data10\issue_exvivoSkullstrip\dat\20250801PBS_NS247_T2_DTI_MPM\t2.nii'
% F1=removeTube2(f1);
%   showinfo2(['new file2:'],F1);   
% % ===============================================
%     pa='F:\data8\lina_exvivoTubesegmentation\dat\20240828LA_CupExvivo_F01_dMRI_MPM_MWF'
%     file=fullfile(pa,'t2.nii');
%     q=removeTube2(file)
%     showinfo2(['new file2:'],q);
% 
% 
 
    
    
%
function fileout=removeTube2(file)
 
 
%% ===============================================
% file =...
%     'H:\Daten-2\Imaging\AG_Boehm_Sturm\Ratbrains_Iowa_2025_ana2\mpm_ana\dat\20250731PBS_NS242_T2_DTI_MPM\t2.nii'
%  file='F:\data10\issue_exvivoSkullstrip\dat\20250801PBS_NS247_T2_DTI_MPM\t2.nii'
%% ===============================================
 
disp(['..tubesegFile: ' mfilename]);
fileout=[];
f1=file;
pa=fileparts(f1);
% f1=fullfile(pa,'t2.nii');
[ha a0]=rgetnii(f1);
% a=imgaussfilt(a0,2);
a=ordfilt3D(a0,14);
b=reshape(otsu(a(:),2),[ha.dim]);
 
edge1=b(:,[1 end],:);
edge2=b([1 end],:,:);
edgeval=mode([edge1(:) ; edge2(:)]) ;% b(1,1,1);
val=setdiff(unique(b(:)),edgeval);
b2=b==val;
d=reshape(otsu(a(:),3),[ha.dim]);
 
% ==============================================
%%   get direction of tube
% ===============================================
excen=[];
id=[];
for i=1:3
    c=squeeze(mean(b2,i))>0;
    c=imfill(c,'holes');
    c2=bwlabeln(c);
    uni=unique(c2); uni(uni==0)=[];
    t=zeros(length(uni), 2);
    for k=1:length(uni)
        t(k,:) = [ uni(k) length(find(c2==uni(k)))] ;
    end
    t=flipud(sortrows(t,2));
    c2=c2==t(1, 1);
    d2=squeeze(mode(d,i));
    c3=imerode(c2,ones(3));
    c4=imerode(c2,ones(5));
    ring=c3-c4;
    %tabulate(d2(ring==1));
    val2=mode(d2(ring==1));
    
%  fg,imagesc(c2); title([' dim-' num2str(i)]);
%     o= regionprops(c2,'eccentricity');
%     excen(1,i)=o.Eccentricity;   
    o=regionprops(c2,'Solidity');
    excen(1,i)=o.Solidity;
    id(1,i)=val2;
end
% disp([excen]);
 
udim=find(excen==min(excen));
disp([ 'circle-dim: ' num2str(udim) ]);
% udim=2;
% ==============================================
%%   
% ===============================================
nsl=ha.dim(udim);
sl_mid=round(nsl/2);
sl_order=[round(nsl/2):-1:1   sl_mid+1:1:nsl  ];
dims =1:ndims(a);
dims2=[setdiff(1:ndims(a),udim) udim ];
b    =permute(a, dims2 );
% bback=permute(b, dims2 );
 
%% ======[otsu classes]=========================================
d2=zeros(size(b));
d3=zeros(size(b));
vval=zeros([size(b,3) 1]);
for i=1:size(b,3)
    bm=otsu(b(:,:,i),2);
    if length(unique(bm))>1
       vval(i,1)=1; 
        
       %===============================================      
       am=b(:,:,i);
       cm=double(otsu(am,5)>1);
       cm=imfill(cm,'holes');
       re=imerode(cm,ones(11));
       ed=cm-re;
       
       %v=otsu(am,5);
       v=otsu(am,4);
       in=v.*ed;
       ma=in==max(in(:));
       [cm unis]=bwlabeln(ma);
       s=v>=min(in(ma));
       [cm2 ]=bwlabeln(s);
       
       x=zeros(size(ma));
       uni=unique(cm(:)); uni(uni==0)=[];
       for j=1:length(uni)
           cl=unique(cm2(cm==uni(j)));
           x=x+double(cm2==cl);
       end
       x=x>0;
       
       
       % ===============================================
      d2(:,:,i)=x;
      %d3(:,:,i)=otsu(b(:,:,i),4);
    end
end
%% ===============================================
 
 
% fg,imagesc(mode(d3,3))
% fg,imagesc(mode(d3(:,:,vval==1),3))
 
d3=permute(d2, dims2 );
val=min(a0(:));
w=a0;
w(d3==1)=val;
% montage2(w)
% montage2(imadjust(mat2gray(w)))
 
 
% m3=mode(d3(:,:,vval==1),3);
% m4=m3==max(m3(:));
% m5=repmat(m4,[1 1 size(b,3)]);
% c=b;
% c(m5==1)=0;
% w=permute(c, dims2 );
 
% [~,animal]=fileparts(pa);
% montage2(permute(w,[1 3 2]));
% title(animal)
% return
 
 
filename    ='_tmp_ExvivoTube.nii';
f2=fullfile(pa,filename);
rsavenii(f2,ha,w,64);
fileout=f2;
disp('done_v4');
    
 
    
 
 
 
 
 
 
 
 
 
 
return
 
 
 
%% ===============================================
 
%% ===============================================
% if 0
%
%     pa='F:\data8\lina_exvivoTubesegmentation\dat\20240828LA_CupExvivo_F01_dMRI_MPM_MWF'
%     file=fullfile(pa,'t2.nii');
%     q=removeTube2(file)
%     showinfo2(['new file2:'],q);
%
% end
%% ===============================================
disp(['..tubesegFile: ' mfilename]);
fileout=[];
f1=file;
pa=fileparts(f1);
% f1=fullfile(pa,'t2.nii');
[ha a0]=rgetnii(f1);
% a=imgaussfilt(a0,2);
a=ordfilt3D(a0,14);
b=reshape(otsu(a(:),2),[ha.dim]);
 
edge1=b(:,[1 end],:);
edge2=b([1 end],:,:);
edgeval=mode([edge1(:) ; edge2(:)]) ;% b(1,1,1);
val=setdiff(unique(b(:)),edgeval);
b2=b==val;
 
d=reshape(otsu(a(:),3),[ha.dim]);
 
% ==============================================
%%   get direction of tube
% ===============================================
 
excen=[];
id=[];
for i=1:3
    c=squeeze(mean(b2,i))>0;
    c=imfill(c,'holes');
    c2=bwlabeln(c);
    uni=unique(c2); uni(uni==0)=[];
    t=zeros(length(uni), 2);
    for k=1:length(uni)
        t(k,:) = [ uni(k) length(find(c2==uni(k)))] ;
    end
    t=flipud(sortrows(t,2));
    c2=c2==t(1, 1);
    
    d2=squeeze(mode(d,i));
   
    
    c3=imerode(c2,ones(3));
    c4=imerode(c2,ones(5));
    ring=c3-c4;
    %tabulate(d2(ring==1));
    val2=mode(d2(ring==1));
    
%    fg,imagesc(c2); title([' dim-' num2str(i)]);
%     o= regionprops(c2,'eccentricity');
%     excen(1,i)=o.Eccentricity;
%     
    o=regionprops(c2,'Solidity');
    excen(1,i)=o.Solidity;
 
    
    id(1,i)=val2;
end
disp([excen]);
% ans =
%     Eccentricity: 0.1383
 
% ==============================================
%%   untube
% ===============================================
 
 
 
 
 
 
 
 
%% ===============================================
threshEcentr=0.3;
filename    ='_tmp_ExvivoTube.nii';
dim2use=min(find(excen==min(excen)));
 
 
%% ===============================================
 
s=montageout(permute(a,[1 2 4 3]));
s2=otsu(s,3);
% um=otsu(s,7)<=4;
% um=otsu(s,4)<=4;
um=otsu(s,4)==2;
 
x=zeros(size(a));
for i=1:size(x,3)
   x(:,:,i)=i; 
end
x2=montageout(permute(x,[1 2 4 3]));
 
um2=zeros(size(a));
for i=1:size(x,3)
  ix=find(x2==i); 
  dx=um(ix);
 um2(:,:,i)= reshape(dx,[size(a,1), size(a,2)]);
end
w=um2.*a;
% 
% 
% w=imcomplement(a0);
% w=w-min(w(:))+1;
% x=reshape(otsu(a(:),2),[ha.dim]);
% w(x==1)=0;
 
f2=fullfile(pa,filename);
rsavenii(f2,ha,w,64);
fileout=f2;
disp('donexx')
    
return
 
%% ===============================================
 
 
 
if ~isempty(dim2use)
    
    %% =====[depending on dimension]========================
    dim_excen=find(excen==min(excen));
    dims =1:ndims(a);
    dims2=[setdiff(1:ndims(a),dim_excen) dim_excen ];
    
    a0p= permute(a0,dims2);
    ap = permute(a ,dims2);
    
    [in2 bp rip]=deal(zeros(size(a0p)));
    for i=1:size(a0p,3)
        %disp(i);
        ao=squeeze(a0p(:,:,i));
        as=squeeze( ap(:,:,i));
        v=otsu(as,3); %multimask
        m=v>1;
        m=imfill(m,'holes');
        in=imerode(m,ones(3));
        if length(unique(m(:)))~=1
            vals=sort(as(in),'descend');
            memax(i,1)=mean(vals(1:100));
            bp(:,:,i)=as./memax(i,1);
            rip(:,:,i)=m-in;
        end
    end
    b  =permute(bp ,dims2);
    ri =permute(rip,dims2);
    
    
  
      %% ===============================================
      if 1
          cl2del=[];
          nclvec=[4 5 6];
          for j=1:length(nclvec)
              if isempty(cl2del)
                  ox=reshape(otsu(b(:),nclvec(j)),[ha.dim]);
                  ox2=permute(ox.*ri, [ (setdiff(1:3,dim2use))  dim2use])  ;
                  ox2=reshape(ox2, [ size(ox2,1)*size(ox2,2) size(ox2,3)  ]);
                  uni=unique(ox2); uni(uni==0)=[];
%                   ta=[];
%                   for i=1:length(uni)
%                       ta(i,:)=sum(ox2==uni(i),1);
%                   end
                  
                  idel=find(uni==max(uni));
                  cl2del=uni(idel);
              end
          end
      end
    %% ===============================================
    
    
 
    
    w=b;
    w(ox>=cl2del)=0;
    
    f2=fullfile(pa,filename);
    rsavenii(f2,ha,w,64);
    
    '..done'
%     showinfo2(['img'],f2);
    
    %% ===============================================
    
    
    
    %     ta=tabulate(ox(ri==1));
    %     disp(ta)
    %     cl=ta(find(ta(:,2)==max(ta(:,2)),1)); %cluster to remove
    %
    %
    %     w=b;
    %     w(ox==cl)=0;
    
    %% ===============================================
    
    
    
    %     f2=fullfile(pa,filename);
    %     rsavenii(f2,ha,w,64);
    %     showinfo2(['img'],f2);
    %% ===============================================
    %     ix=find(in2(:)==1);
    %    av=a0(:);
    %    %   av=a(:);
    %     av(ix)=imcomplement(av(ix));
    %     av(ix)=av(ix)-min(av(ix))+1;
    %     ixo=find(in2(:)==0);
    %     av(ixo)=0+1;
    %   av=reshape(av,[ha.dim]);
    %     montage2(permute(av,[1 3 2]))
    %
    %     patest='F:\data8\lina_exvivoTubesegmentation\dat\1stTest'
    %     f2=fullfile(patest,'t2.nii');
    %     rsavenii(f2,ha,av,64);
    %     showinfo2(['img'],f2);
    %
    %      %% ===============================================
    %     b=imcomplement(a0);
    %     b=b-min(b(:))+1;
    %     b=b.*in2;
    % %     ms=reshape(otsu(a(:),2),[ha.dim]);
    % %     b(ms==1)=0;
    %     patest='F:\data8\lina_exvivoTubesegmentation\dat\1stTest'
    %     f2=fullfile(patest,'t2.nii');
    %     rsavenii(f2,ha,b,64);
    %     showinfo2(['img'],f2);
    %
    
    %% ===============================================
    %     b=imcomplement(a0);
    %     b=b-min(b(:))+1;
    %     ms=reshape(otsu(a(:),2),[ha.dim]);
    %     b(ms==1)=0;
    %
    % %         patest='F:\data8\lina_exvivoTubesegmentation\dat\1stTest'
    % %         f2=fullfile(patest,'t2.nii');
    % %         rsavenii(f2,ha,b,64);
    % %         showinfo2(['img'],f2);
    %   w=b*100;
    %
    %     f2=fullfile(pa,filename);
    %     rsavenii(f2,ha,w,64);
    %     showinfo2(['img'],f2);
    %% ===============================================
    
    
else;
    f2=fullfile(pa,filename);
    copyfile(f1,f2,'f');
end
 
% showinfo2(['new file:'],f2);
 
fileout=f2;

