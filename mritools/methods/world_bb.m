function [bb, vx]  = world_bb(img)
%  world-bb -- get bounding box in world (mm) coordinates
% bb = world_bb(img)
% [bb vx] = world_bb(img); % get voxel sizes too
%
% Based on John Ashburner's reorient.m
% http://www.sph.umich.edu/~nichols/JohnsGems.html#Gem7
% http://www.sph.umich.edu/~nichols/JohnsGems5.html#Gem2
% Adapted by Ged Ridgway -- email bugs to drc.spm@gmail.com

% Check spm version:
if exist('spm_select','file') % should be true for spm5
    spm5 = 1;
elseif exist('spm_get','file') % should be true for spm2
    spm5 = 0;
else
    error('Can''t find spm_get or spm_select; please add SPM to path')
end

% set up defaults (including analyze.flip)
spm_defaults;

% prompt for missing arguments
if ( ~exist('img','var') || isempty(img) )
    if spm5
        img = spm_select(1, 'image', 'Choose image');
    else
        img = spm_get(1, 'img', 'Choose image');
    end
end

V = spm_vol(img); % (okay if img is already an SPM vol)

V=V(1);

d = V.dim(1:3);
% corners in voxel-space
c = [ 1    1    1    1
    1    1    d(3) 1
    1    d(2) 1    1
    1    d(2) d(3) 1
    d(1) 1    1    1
    d(1) 1    d(3) 1
    d(1) d(2) 1    1
    d(1) d(2) d(3) 1 ]';
% corners in world-space
tc = V.mat(1:3,1:4)*c;
% reflect in x if required (I don't think this was correct...)
% if spm_flip_analyze_images; tc(1,:) = -tc(1,:); end;

% bounding box (world) min and max
mn = min(tc,[],2)';
mx = max(tc,[],2)';
bb = [mn; mx];

if nargout > 1
    prm = spm_imatrix(V.mat);
    vx = prm(7:9);
end
