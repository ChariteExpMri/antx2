


function removePBStube2(F1,species)

% removePBStube2
% Creates a skullstripped brain and removes surrounding PBS tube/background
% from a T2 MRI volume.
% Main steps:
%   1. Copies the input image and performs skull stripping using
%      skullstrip_pcnn3d.
%   2. If skull stripping fails, applies intensity normalization and
%      bias-field correction before retrying.
%   3. Runs a second skull stripping pass on the residual image to
%      detect remaining non-brain structures.
%   4. Compares candidate masks using compactness/shape measures and
%      selects the most plausible brain mask.
%   5. Saves the final mask as:
%         _msk.nii
%   6. Removes temporary files.
%
% Input:
%   F1  - fullpath filename of T2w-NIfTI image
%   species -species 'rat','mouse',etc
% Output:
%   _msk.nii  - final skullstripped brain
%
% Purpose:
%   Intended for automated removal of PBS tube signal and extraction
%   of the brain region from rodent MRI data.


if 0
    %% ===============================================
    clc
    mdirs=antcb('getallsubjects');
    for i=1:2%length(mdirs)
        f2=fullfile(mdirs{i},'t2.nii');
        temp_tube(f2);
    end
    
    %% ===============================================
    
end

p.show=1;
p.cleanup=1;

skparam.species = species;


%
%% ==============================================
%%  part-1: skullstripp
%% ===============================================
pa=fileparts(F1);
% F1=fullfile(pa,'t2.nii')
Fs=fullfile(pa,'_noPBStemp.nii');
Fm1=fullfile(pa, '_msk1.nii' );
Fm2=fullfile(pa, '_msk2.nii' );

%% ===============================================

try; delete(Fs); end

try; delete(Fm1); end
try; delete(Fm2); end

try
    copyfile(F1,Fs,'f') ;
    evalc('skullstrip_pcnn3d(Fs, Fm1,  ''skullstrip'',skparam   )');
    %evalc(['skullstrip_pcnn3d(F1, fullfile(s.pa, ''_msk.nii'' ),  ''skullstrip'' ,skparam  )']); ;

catch
    [ha a]=rgetnii(F1);
    vec=spm_imatrix(ha.mat);
    voxelsize=vec(7:9);
    V=a;
    V = double(V);
    V = V - min(V(:));
    V = V ./ max(V(:));
    
    bias = imgaussfilt3(V, 15);%— bias-field correction (low-frequency shading removal)
    Vcorr = V ./ (bias + eps);
    rsavenii(Fs,ha,Vcorr);
    % ===============================================
    
    evalc('skullstrip_pcnn3d(Fs, Fm1,  ''skullstrip'',skparam   )');
    % rmricron([],Fm1)
end

try
    [ha a]=rgetnii(Fs);
    [hb b]=rgetnii(Fm1);
    c=a-b;
    rsavenii(Fs,hb,c);
    
    
    evalc('skullstrip_pcnn3d(Fs, Fm2,  ''skullstrip'',skparam   )');
catch
%     disp('--failed') ;
end

% [hd d]=rgetnii(Fm2);
% rmricron([],Fm2)
%
%% ==============================================
%%  part-1: skullstripp
%% ===============================================

if exist(Fm2)==2
    % ===============================================
    [ha a]=rgetnii(Fm1);
    [hb b]=rgetnii(Fm2);
    am=a>0;
    bm=b>0;
    % ===============================================
    sv=[];
    ce=[];
    cv2=[];
    cf
    for j=1:2
        if j==1; dx=am;  dv=a;
        else;    dx=bm;  dv=b;
        end
        dims=ha.dim;
        vs1=squeeze(sum(sum(dx,2),3));
        vs2=squeeze(sum(sum(dx,1),3));
        vs3=squeeze(sum(sum(dx,1),2));
        
        %             fg;plot(vs1); title([j]);
        %             fg;plot(vs2); title([j]);
        %             fg;plot(vs3); title([j]);
        
        sv(1,j)=sum(vs1>0)./dims(1).*100;
        sv(2,j)=sum(vs2>0)./dims(2).*100;
        sv(3,j)=sum(vs3>0)./dims(3).*100;
        
        stats = regionprops3(dx,'Volume','SurfaceArea');
        compactness = (stats.Volume.^(2/3)) ./ stats.SurfaceArea;
        ce(1,j)=compactness;
        
        %             stats = regionprops3(dx,'Centroid');
        %             sz = size(dx);
        %             imgCenter = sz/2;
        %             d = vecnorm(stats.Centroid - imgCenter,2,2);
        %             d=min(d);
        %             ce(j)=d;
        %             disp(stats);
        %             disp(d);
        
        %             vals = dv(dx==1);
        %             me = mean(vals);
        %             se = std(vals);
        %             cv = se/me;
        %             stats = regionprops3(dx,'BoundingBox');
        %             cv=stats.BoundingBox;
        %             %cx=[ .5 .5 .5 dims]
        %             cv=[cv(4)-cv(1) cv(5)-cv(2) cv(6)-cv(3)]
        %             cv2(:,j)=cv;
        
    end
    %         disp('prod');
    %         disp([   prod(s(:,1)) prod(s(:,2))]);
    %         disp('ce');
    
    
    ix=find(ce==max(ce));
    if ix==1; mask=Fm1;
    else mask=Fm2;
    end
    
%     disp([ ' ..'  num2str(ix) ]);
    %         disp(ce);
    %         disp(cv2);
    
    
    %% ===============================================
    
else
    mask=Fm1;
end

% ==============================================
%%   write maskfile and cleanup
% ===============================================
mask2=fullfile(pa,'_msk.nii');
copyfile(mask,mask2,'f');


% ==============================================
%%   cleanup
% ===============================================
if p.cleanup==1
    try; delete(Fm1); end
    try; delete(Fm2); end
    try; delete(fullfile(pa,'_noPBStemp.nii')); end
end

if p.show==1;
    showinfo2('mask: ' ,mask2);
elseif  p.show==2;
    rmricron([],mask2);
end



