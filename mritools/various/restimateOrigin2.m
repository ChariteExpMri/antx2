





function pos2shiftMM = restimateOrigin2(source, ref,rangeMM, resolMM)
%% estimate origin in refImage
%% inp:
% source :sourceIMage                           ;e.g  'xx_s20150505SM02_1_x_x_1.nii'
% ref    :refImage (tested for grayMatter-image)  ; 'greyr62.nii'
% rangeMM: starting range, [min max] in mm         ; e.g [-7 7];
% resolMM: mm-resolution steps used for iteration  ; e.g [2 .5 .1];
% note: ref&source needn't to have same dims&voxSizes
%% out
% pos2shiftMM: xyz-MM vector to shift --> use [fsetorigin] to apply this on image
%% example
% pos2shiftMM = restimateOrigin('xx_s20150505SM02_1_x_x_1.nii', 'greyr62.nii',[-7 7], [2 .5 .1])
%==================================
% spkoch
%==================================







% source='xx_s20150505SM02_1_x_x_1.nii'
% ref='greyr62.nii'
% rangeMM=[-7 7]
% resolMM=[2 .5 .1]


[hr r] = rgetnii(ref); %load header
[ha a]=rgetnii(source);%ha,ha.mat
 
[ho,o] = nii_reslice_target(hr,r, ha); %resize in memory

hox=ho;%%backup
ox=o;

o=single(o);
a=single(a);

% o(o==0)=nan;
% a(a==0)=nan;


vox=diag(ho.mat(1:3,1:3));

bestposMM=[0 0 0];

xrangeMM=rangeMM(1):resolMM(1):rangeMM(2);

tix=tic;
for i=1:length(resolMM)
    disp(['RUN:' num2str(i)] );
    resMM=xrangeMM;
    grid=allcomb(resMM,resMM,resMM);
    grid=grid+repmat(bestposMM,[size(grid,1) 1]);%add best location so far
    
    gridIX=round(grid./repmat(vox(:)',[size(grid,1) 1]));
    gridIX=unique(gridIX,'rows');
%     size(gridIX)
    g=single(zeros(size(gridIX,1),1));
   
    
    for j=1:size(gridIX,1)
        pdisp(j,50);
        o2=circshift(o,gridIX(j,:) );
        %%calc para
%         r2=single(o2>.2);
%         r3=a.*r2; 
%         g(j)= nanmean(r3(:));
    
g(j)=nansum((o2(:)-a(:)).^2);
    
        
    end
%     ix=min(find(g==max(g)));
ix=min(find(g==min(g)));
    
    %prepar for next loop
    bestposMM=gridIX(ix,:).*vox';
    if i~=length(resolMM);
    xrangeMM=-resolMM(i):resolMM(i+1):resolMM(i);
    end

end
disp(['Elapsed time(s): ' num2str(toc(tix))]);

pos2shiftMM=-bestposMM;


if 0
    file2test='dumdum.nii'
    copyfile(source,file2test)
    fsetorigin({file2test}, [ [pos2shiftMM]  0 0 0 1 1 1 0 0 0] );
end


function pdisp(i,varargin)
if nargin==2
  if mod(i,varargin{1})==0
    fprintf(1,'%d ',i);   
  end
    
else
   fprintf(1,'%d ',i); 
    
end










% 
% return
% 
% %••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
% %ansatz 2
% %••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
% 
% source='xx_s20150505SM02_1_x_x_1.nii'
% ref='greyr62.nii'
% [hr r] = rgetnii(ref); %load header
% [ha a]=rgetnii(source);ha,ha.mat
% tic
% [ho,o] = nii_reslice_target(hr,r, ha); %resize in memory
% toc
% 
% hox=ho;
% ox=o;
% 
% Bvec0=[ [0 0 0] 0 0 0 1 1 1 0 0 0];  %wenig slices
% bx=-10:2:10
% tic
% g=[];
% 
% tic
% resMM=[-7:2:7]
% grid=allcomb(resMM,resMM,resMM);
% vox=diag(ho.mat(1:3,1:3))
% gridMM=round(grid./repmat(vox(:)',[size(grid,1) 1]))
% 
% o=single(o);
% a=single(a);
% gridMM=unique(gridMM,'rows');
% size(gridMM)
% g=single(zeros(size(gridMM,1),1));
% 
% for j=1:size(gridMM,1)
%     %set default
%     %     Bvec=Bvec0;
%     %     Bvec(3)=bx(j);
% 
%     o2=circshift(o,gridMM(j,:) );
% 
%     %     mat = spm_matrix(Bvec);
%     %     Mats = zeros(4,4);
%     %     Mats = hox.mat ;%spm_get_space(P{i});
%     %     mat2=mat*Mats
%     %     %   spm_get_space(P{i},mat*Mats(:,:,i));
%     %     ho.mat=mat2;
%     %     [ho2,o2] = nii_reslice_target(ho,o, ha); %resize in memory
% 
%     %%calc para
%     r2=single(o2>.2);
%     r3=a.*r2; r4=r3(:);
%     g(j)= mean(r4);
% end
% fg,plot(g);
% ix=(find(g==max(g)))
% toc
% 
% %%step2
% ori=gridMM(ix,:).*vox'
% 
% tic
% resMM=[-2:.5:2]
% grid=allcomb(resMM,resMM,resMM);
% grid=grid+repmat(ori,[size(grid,1) 1])
% 
% vox=diag(ho.mat(1:3,1:3))
% gridMM=round(grid./repmat(vox(:)',[size(grid,1) 1]))
% 
% o=single(o);
% a=single(a);
% gridMM=unique(gridMM,'rows');
% size(gridMM)
% g=single(zeros(size(gridMM,1),1));
% 
% for j=1:size(gridMM,1)
%     pdisp(j,50);
%     %set default
%     %     Bvec=Bvec0;
%     %     Bvec(3)=bx(j);
% 
%     o2=circshift(o,gridMM(j,:) );
% 
%     %     mat = spm_matrix(Bvec);
%     %     Mats = zeros(4,4);
%     %     Mats = hox.mat ;%spm_get_space(P{i});
%     %     mat2=mat*Mats
%     %     %   spm_get_space(P{i},mat*Mats(:,:,i));
%     %     ho.mat=mat2;
%     %     [ho2,o2] = nii_reslice_target(ho,o, ha); %resize in memory
% 
%     %%calc para
%     r2=single(o2>.2);
%     r3=a.*r2; r4=r3(:);
%     g(j)= mean(r4);
% end
% fg,plot(g);
% ix=(find(g==max(g)))
% toc
% 
% ori2=gridMM(ix,:).*vox'
% 
% %% step3
% ori2=gridMM(ix,:).*vox'
% 
% 
% resMM=[-.5:.1:.5]
% grid=allcomb(resMM,resMM,resMM);
% grid=grid+repmat(ori2,[size(grid,1) 1])
% 
% vox=diag(ho.mat(1:3,1:3))
% gridMM=round(grid./repmat(vox(:)',[size(grid,1) 1]))
% 
% 
% o=single(o);
% a=single(a);
% gridMM=unique(gridMM,'rows');
% size(gridMM)
% g=single(zeros(size(gridMM,1),1));
% 
% tic
% for j=1:size(gridMM,1)
%     pdisp(j,50);
%     %set default
%     %     Bvec=Bvec0;
%     %     Bvec(3)=bx(j);
% 
%     o2=circshift(o,gridMM(j,:) );
% 
%     %     mat = spm_matrix(Bvec);
%     %     Mats = zeros(4,4);
%     %     Mats = hox.mat ;%spm_get_space(P{i});
%     %     mat2=mat*Mats
%     %     %   spm_get_space(P{i},mat*Mats(:,:,i));
%     %     ho.mat=mat2;
%     %     [ho2,o2] = nii_reslice_target(ho,o, ha); %resize in memory
% 
%     %%calc para
%     r2=single(o2>.2);
%     r3=a.*r2; r4=r3(:);
%     g(j)= mean(r4);
% end
% fg,plot(g);
% ix=(find(g==max(g)))
% toc
% 
% ori3=gridMM(ix,:).*vox'
% 
% repos=-[ori3]
% 
% 
