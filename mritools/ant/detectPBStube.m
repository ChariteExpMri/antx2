function [PBS_present,score,info] = detectPBStube(f1, varargin)

% detection of PBS tube in ex-vivo mouse MRI
% Handles anisotropic voxels + arbitrary orientation
% Uses SPM NIfTI loader
% 
% EXAMPLE
% pa='F:\data10\oxford_exvivo\dat\20260327_jh_DTH_exvivo_LA13_MPM_DTI_exvivo';
% f1=fullfile(pa,'t2.nii');
% 
% [PBS_present,score,info] = detectPBStube(f1);
% detectPBStube(f1,'show',0);
% 
% 


if 0
    %% ===============================================
    pa='F:\data10\oxford_exvivo\dat\20260327_jh_DTH_exvivo_LA13_MPM_DTI_exvivo';
    f1=fullfile(pa,'t2.nii');
    %    [ha a]=rgetnii(f1);
    [PBS_present,score,info] = detectPBStube(f1)
    %% ===============================================
end


p.dum =1;
p.show=0;
if nargin>1%pairwise inputs
    pin=cell2struct(varargin(2:2:end),varargin(1:2:end),2);
    p=catstruct(p,pin);
end

%% -------------------------------------------------
% Load volume using SPM
%% -------------------------------------------------
V = spm_vol(f1);
Y = spm_read_vols(V);
vox = sqrt(sum(V.mat(1:3,1:3).^2));
%% -------------------------------------------------
% Normalize intensity
%% -------------------------------------------------
Y = double(Y);
Y = Y - min(Y(:));
Y = Y ./ (max(Y(:)) + eps);
%% -------------------------------------------------
% Detect boundary-connected bright region
%% -------------------------------------------------
no=2;
o=reshape(otsu(Y(:),no),size(Y));
thr=min(Y(o>=2));
PBSmask= Y > thr;
% no=3;
% o=reshape(otsu(Y(:),no),size(Y));
% thr=min(Y(o==3));
% bright = Y > thr;
% PBSmask = imclearborder(bright,26);
% PBSmask=bright;
% thr = graythresh(Y);
% bright = Y > thr;
% PBSmask = imclearborder(bright,26);
volumeFraction = sum(PBSmask(:))/numel(PBSmask);
if volumeFraction < 0.01
    PBS_present = false;
    score = 0;
    info.reason = 'no boundary shell detected';
    return
end


%% -------------------------------------------------
% Evaluate all slice orientations
%% -------------------------------------------------
dims = size(Y);
bestCircularity = 0;
bestResidual = inf;
bestAxis = 0;
t=[];
sliceAreas2={};
for axis = 1:3
    switch axis
        case 1
            nSlices = dims(1);
        case 2
            nSlices = dims(2); 
        case 3        
            nSlices = dims(3);        
    end
    sliceAreas = zeros(nSlices,1);
    for s = 1:nSlices
        sliceMask = getSlice(PBSmask,axis,s);
        sliceAreas(s) = sum(sliceMask(:));
    end
    [~,bestSlice] = max(sliceAreas); 
    sliceMask = getSlice(PBSmask,axis,bestSlice);
%     
%     w = getSlice(Y,axis,round(nSlices/2));
%     sliceMask=otsu(w,3)>1;
%     fg,imagesc(sliceMask); 
%    sliceMask =squeeze(mean(PBSmask,axis))>0;
    sliceMask=imfill(sliceMask,'holes');
    sliceMask = imclose(sliceMask,strel('disk',3));
    sliceMask = imopen(sliceMask,strel('disk',2));

CC = bwconncomp(sliceMask);
numPixels = cellfun(@numel,CC.PixelIdxList);
[~,idx] = max(numPixels);
cleanMask = false(size(sliceMask));
cleanMask(CC.PixelIdxList{idx}) = true;
sliceMask = cleanMask;
% fg,imagesc(sliceMask);
    B = bwperim(sliceMask);
    [y,x] = find(B);
    if numel(x) < 40
        continue
    end  
    switch axis % correct anisotropic voxel scaling
        case 1  
            x = x * vox(2);
            y = y * vox(3);      
        case 2 
            x = x * vox(1);
            y = y * vox(3);   
        case 3
            x = x * vox(1);
            y = y * vox(2);     
    end  
%     sliceperc=bestSlice./nSlices;
%     sliceperc=bestSlice;
   slicefrac= sum(sliceMask(:))./numel(sliceMask);
    points = [x y];
    % circle fit
    [~,~,~,residual] = fitCircleLeastSquares(points);
    stats = regionprops(sliceMask,'Area','Perimeter','Eccentricity','Extent','Solidity');
    A = stats.Area;
    P = stats.Perimeter;
    E = stats.Eccentricity;
    S= stats.Solidity;  
    circularity = 4*pi*A/(P^2);
    if 0
        if axis == 1
            disp({'residual' 'circularity' 'Eccentricity' 'slicefrac'});
        end
        disp({ residual circularity E S });
    end
    t(axis,:)=[ residual circularity E S slicefrac ];
    if circularity > bestCircularity
        bestCircularity = circularity;
        bestResidual = residual;
        bestAxis = axis; 
    end
    sliceAreas2{axis}=sliceAreas; 
end
%% -------------------------------------------------
% scoring
%% -------------------------------------------------
% % [t]: axis x [ 'residual' 'circularity' 'Eccentricity' 'Solidity']
% t(:,1)=t(:,1)./max(t(:,1)); %normalize residuals
% scores=0.3*exp(-t(:,1) / median(t(:,1))) +0.7.*(1-t(:,3));
% [score,bestAxis] = max(scores);
% PBS_present= score > 0.6;

% scoring
%% -------------------------------------------------
residual = t(:,1);
ecc      = t(:,3);
% ---------- absolute axis quality score ----------
resScore = exp(-residual / median(residual));
eccScore = 1 - ecc;
axisScore = 0.3*resScore + 0.7*eccScore;
[bestAxisScore,bestAxis] = max(axisScore);

% ---------- axis separation score ----------
eccSep = (median(ecc) - min(ecc)) / median(ecc);
resSep = (median(residual) - min(residual)) / median(residual);
separationScore = 0.6*eccSep + 0.4*resSep;
% ---------- final PBS confidence ----------
% PBSconfidence = 0.5*bestAxisScore + 0.5*separationScore;
PBSconfidence = 0.4*bestAxisScore + 0.4*separationScore + 0.2*(volumeFraction*2);
PBS_present = PBSconfidence > 0.7;
score=PBSconfidence;

%% diagnostics
% {'residual' 'circularity' 'Eccentricity' 'Solidity'}
s=t(bestAxis,:);
info.residual        = s(1);
info.circularity     = s(2);
info.Eccentricity    = s(3);
info.Solidity        = s(4);
% info.circularity = bestCircularity;
info.volumeFraction = volumeFraction;
info.axis = bestAxis;
info.ht={'residual' 'circularity' 'Eccentricity' 'Solidity' 'sliceprc'};
info.t =t;

%% ===============================================
if p.show==1
    file=strrep(f1,filesep,[filesep filesep]);
    cprintf('*[0 .5 0]',[file '\n']);
    
    disp(['   PBS_present:'  num2str(PBS_present) ]);
    disp(['          axis:'  num2str(info.axis) ]);
    disp(['         score:'  num2str(score) ]);
    disp(['volumeFraction:'  num2str(info.volumeFraction) ]);
    disp(char(plog([],[info.ht; num2cell(info.t)])));
    if PBS_present==1
        cprintf('*[0 0 1]',[ '  ...  PBS-tube ' '\n']);
    else
        cprintf('*[1 0 0]',[ '  ... no PBS-tube ' '\n']);
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% helper slice extractor
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function slice = getSlice(vol,axis,index)
switch axis
    case 1
        slice = squeeze(vol(index,:,:));
    case 2
        slice = squeeze(vol(:,index,:));
    case 3
        slice = squeeze(vol(:,:,index));
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% helper circle fit
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [xc,yc,R,residual] = fitCircleLeastSquares(points)
x = points(:,1);
y = points(:,2);
A = [2*x 2*y ones(size(x))];
b = x.^2 + y.^2;
params = A\b;
xc = params(1);
yc = params(2);
R = sqrt(params(3) + xc^2 + yc^2);
distances = sqrt((x-xc).^2 + (y-yc).^2);
residual = std(distances - R);







