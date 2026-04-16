function [brainmask,Vclean] = removePBS(f1)

% INPUT
% V           = 3D MRI volume (double/single/int)
% voxelsize   = [vx vy vz] in mm  (example: [0.1 0.1 0.5])

% OUTPUT
% brainmask   = binary brain mask
% Vclean      = PBS-removed volume

%% ===============================================

if 0

    %% ===============================================
    
    pa='F:\data10\oxford_exvivo\dat\20260327_jh_DTH_exvivo_LA13_MPM_DTI_exvivo';
    f1=fullfile(pa,'t2.nii');
    [ha a]=rgetnii(f1);
    vec=spm_imatrix(ha.mat);
    voxelsize=vec(7:9)
    [bm,vm] = removePBS(f1); montage2(vm);
    
    
    %% ===============================================
end


[ha a]=rgetnii(f1);
vec=spm_imatrix(ha.mat);
voxelsize=vec(7:9);

%% -------------------------------------------------
% Step 0 — normalize
%% -------------------------------------------------
V=a;
V = double(V);
V = V - min(V(:));
V = V ./ max(V(:));


%% -------------------------------------------------
% Step 1 — bias-field correction (low-frequency shading removal)
%% -------------------------------------------------

% fprintf('Bias correction...\n')

bias = imgaussfilt3(V, 40);
Vcorr = V ./ (bias + eps);
%% ===============================================
% 
% % sm = imgaussfilt3(V, 5);
% b=zeros(size(Vcorr));
% for i=1:size(Vcorr,3)
%   b(:,:,i)=  medfilt2(Vcorr(:,:,i), [ 3 3  ]);
%     
% end
% Vcorr=b;

%% ===============================================

% -------------------------------------------------
% Step 2 — detect bright boundary-connected PBS
% -------------------------------------------------
% montage2(reshape(otsu(Vcorr(:),3),size(Vcorr)));
no=3;
o=reshape(otsu(Vcorr(:),no),size(Vcorr));
thr=min(Vcorr(o>=3));

% thr = graythresh(Vcorr(:));

bright = Vcorr > thr;

 PBSmask =bright;% imclearborder(bright,26);
% PBSmask =imclearborder(bright,18);



% -------------------------------------------------
% Step 3 — remove PBS
% -------------------------------------------------

% fprintf('Removing PBS...\n')

Vclean = Vcorr;
Vclean(PBSmask) = 0;

%  montage2(PBSmask);
% -------------------------------------------------
% Step 4 — initial brain segmentation
% -------------------------------------------------

% fprintf('Segmenting brain...\n')

thr2 = graythresh(Vclean(Vclean>0));
brainmask = Vclean > thr2;

 
%  montage2(brainmask);
 %% ===============================================
 

%% -------------------------------------------------
% Step 5 — keep largest connected component
%% -------------------------------------------------

% fprintf('Selecting largest component...\n')

CC = bwconncomp(brainmask,26);

numPixels = cellfun(@numel,CC.PixelIdxList);
[~,idx] = max(numPixels);

brainmask_clean = false(size(brainmask));
brainmask_clean(CC.PixelIdxList{idx}) = true;


%% -------------------------------------------------
% Step 6 — anisotropic morphology cleanup
%% -------------------------------------------------

% fprintf('Morphological cleanup...\n')

radius_mm = 0.25;

rx = round(radius_mm / voxelsize(1));
ry = round(radius_mm / voxelsize(2));
rz = round(radius_mm / voxelsize(3));

se = anisotropicSE(rx,ry,rz);

brainmask_clean = imclose(brainmask_clean,se);
brainmask_clean = imfill(brainmask_clean,'holes');


%% -------------------------------------------------
% Step 7 — cortex edge recovery
%% -------------------------------------------------
% 
% fprintf('Recovering cortex boundary...\n')
% 
% dist = bwdist(~brainmask_clean);
% 
% expand_voxels =0.00001;% round(0.2 / mean(voxelsize));
% brainmask_clean2=brainmask_clean;
% brainmask_clean2(dist < expand_voxels) = 1;
% 
% montage2(brainmask_clean2);
%% -------------------------------------------------
% OUTPUT
%% -------------------------------------------------

brainmask = brainmask_clean;

% fprintf('Done.\n')

end


%% -------------------------------------------------
% helper: anisotropic structuring element
%% -------------------------------------------------

function se = anisotropicSE(rx,ry,rz)

[x,y,z] = ndgrid(-rx:rx,-ry:ry,-rz:rz);

se = (x.^2/rx^2 + y.^2/ry^2 + z.^2/rz^2) <= 1;

end