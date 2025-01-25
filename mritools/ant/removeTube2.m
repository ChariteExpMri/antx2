

% ==============================================
%%   tubesegment
% ===============================================
% subfunction: Exvivo-data with high-contrast (PBS) solution --> remove exvivo-tube  use imcomplement+otsu
% q=removeTube2(fullfile(pa,'t2.nii'));
%
function fileout=removeTube2(file)
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
    
    %     fg,imagesc(c2); title([' dim-' num2str(i)]);
    o= regionprops(c2,'eccentricity');
    excen(1,i)=o.Eccentricity;
    id(1,i)=val2;
end
% disp([excen]);
% ans =
%     Eccentricity: 0.1383

% ==============================================
%%   untube
% ===============================================


%% ===============================================
threshEcentr=0.3;
filename    ='_tmp_ExvivoTube.nii';
dim2use=min(find(excen==min(excen)));
if ~isempty(dim2use)
    
    %% ===============================================
    b=zeros(size(a0));
    memax=zeros(size(a,dim2use) ,1);
    ri=b;
    for i=1:size(a,dim2use)
        %disp(i);
        ao=squeeze(a0(:,i,:));
        as=squeeze(a(:,i,:));
        
        %         m=otsu(ao,nc);
        %         mx=(m==nc);
        %         val=mean(ao(m==(nc-1)));
        %
        %         d=ao;
        %         d(mx==1)=val;
        %         b(:,i,:)=d;
        v=otsu(as,3); %multimask
        m=v>1;
        m=imfill(m,'holes');
        in=imerode(m,ones(3));
        in2(:,i,:)=in;
        vals=sort(as(in),'descend');
        memax(i,1)=mean(vals(1:100));
        
        b(:,i,:)=as./memax(i,1);
        % b(:,i,:)=ao./memax(i,1);
        ri(:,i,:)=m-in;
    end
    %     fg,plot(memax)
    
    %% ===============================================
    if 0
        ox=reshape(otsu(b(:),4),[ha.dim]);
        ox2=permute(ox.*ri, [ (setdiff(1:3,dim2use))  dim2use])  ;
        ox2=reshape(ox2, [ size(ox2,1)*size(ox2,2) size(ox2,3)  ]);
        uni=unique(ox2); uni(uni==0)=[];
        ta=[];
        for i=1:length(uni)
            ta(i,:)=sum(ox2==uni(i),1);
        end
        
        idel=find(uni==4);
        if isempty(idel); idel=max(uni); end
        cl2del=uni(idel);
    end
    %% ===============================================
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
