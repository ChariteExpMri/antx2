% BIASFIELDCOR Simple slice-wise bias-field correction of a 3D NIfTI image
% [ha,ac,a] = biasfieldcor(file)
% biasfieldcor(file,fileout)
% Performs a simple bias-field correction on a 3D NIfTI volume. The correction is performed independently 
% for each axial slice using a local intensity-based bias-field estimation. After correction, the intensity 
% distributions of neighbouring slices are matched to reduce slice-to-slice intensity differences.
% 
% _INPUT_
% file: FULLPATH-FILENAME of the input 3D NIfTI image.
%       Alternatively, FILE can be a cell array containing an already loaded NIfTI header and image:
%        file = {ha,a};
% fileout - OPTIONAL 
%         FULLPATH-FILENAME of the output 3D NIfTI image.   
%         If omitted or empty, no output file is written.
% 
% _OUTPUT_
% ha : NIfTI header of the input image.
% ac : Bias-field-corrected 3D image. The corrected image retains the original image geometry and is returned 
%      in the intensity scale of the input image.
% a  : Original 3D image loaded from FILE.
% 
% METHOD
% 1. Each axial slice is normalized to a fixed intensity range.
% 2. A 2D bias field is estimated for each slice using the local region-based level-set method implemented in LSE_BFE.
% 3. The estimated bias field is removed from the slice.
% 4. After processing all slices, slice intensities are adjusted using histogram matching (IMHISTMATCH) to reduce intensity
%    differences between neighbouring slices.
% 5. NaN voxels resulting from the correction are replaced by the median intensity of the corrected volume.
% NOTE: 
% The correction is slice-wise. It therefore corrects intensity inhomogeneity within individual slices, but does not estimate
% one smooth 3D bias field across the entire volume.
% 
% _EXAMPLES_
% % Correct a 3D NIfTI image and save the result:
% f1 = fullfile(pwd,'t2_orig.nii');
% f2 = fullfile(pwd,'t2_UNBIASED.nii');
% biasfieldcor(f1,f2);
% 
% % Correct an image and keep the result in MATLAB:
% [ha,ac,a] = biasfieldcor(f1);
% 
% % Use an already loaded NIfTI header and image:
% [ha,ac,a] = biasfieldcor({ha,a});



function [ha,ac,a]=biasfieldcor(file,fileout)
% v2.0


if exist('fileout')~=1 || ~ischar(fileout)
    fileout=[];
end

if iscell(file)
    ha=file{1};
    a =file{2};
else
    
    [ha,a] = rgetnii(file);
end

c = zeros(size(a),'like',a);

% -------------------------------------------------------
% constants (compute once)
% -------------------------------------------------------

A          = 255;
sigma      = 4;
nu         = 0.001*A^2;

iter_outer = 10;%20;   % was 50
iter_inner = 3;%5;    % was 10

timestep   = .1;
mu         = 1;
c0         = 1;
epsilon    = 1;

% -------------------------------------------------------
% geometry (compute once)
% -------------------------------------------------------

imsz = size(a(:,:,1));

K = fspecial('gaussian',round(2*sigma)*2+1,sigma);

KONE = conv2(ones(imsz),K,'same');

initialLSF = c0*ones(imsz);

box = round(imsz/4);

ctr = round(imsz/2);

r1 = max(1,ctr(1)-box(1));
r2 = min(imsz(1),ctr(1)+box(1));

c1 = max(1,ctr(2)-box(2));
c2 = min(imsz(2),ctr(2)+box(2));

initialLSF(r1:r2,c1:c2) = -c0;

% -------------------------------------------------------
% slice loop
% -------------------------------------------------------

for i=1:size(a,3)

%     S = sprintf('BiasFieldCorrection slice-%d\n',i);
%     fprintf(S);

    bb = double(a(:,:,i));

    Img = A*normalize01(bb);

    u = initialLSF;

    b = ones(imsz);

    for n=1:iter_outer
        [u,b] = lse_bfe( ...
            u,...
            Img,...
            b,...
            K,...
            KONE,...
            nu,...
            timestep,...
            mu,...
            epsilon,...
            iter_inner);
    end

    bci = denormalize01( ...
        (Img./(b+(b==0)))./255 , ...
        bb);

    c(:,:,i) = bci;

%     fprintf(repmat('\b',1,numel(S)));

end

% ==============================================
%%   nans
% ===============================================

 cnan=c;
% c(isnan(c))=nanmedian(c(:));

%% ===============================================

% -------------------------------------------------------
% slice-wise adjustment
% -------------------------------------------------------

mid = round(size(c,3)/2);

li = [ ...
    flipud([[2:mid]' [1:mid-1]']); ...
    [[mid:size(c,3)-1]' [mid+1:size(c,3)]'] ...
    ];

e = c;

e(:,:,mid) = mat2gray(e(:,:,mid));

for i=1:size(li,1)

    a1 = mat2gray(e(:,:,li(i,2)));
    a2 = mat2gray(e(:,:,li(i,1)));

    e(:,:,li(i,2)) = imhistmatch(a1,a2);

end

ac = denormalize01(e,a);

% ac_bk=ac;
ac(isnan(cnan))=nanmedian(ac(:)); %replace nan's


%% =====[save file]==========================================
if ~isempty(fileout)
   %try; delete(fileout); end 
   rsavenii(fileout, ha, ac);
end


