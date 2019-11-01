
function [s]=pclustermaxima(Z,xyz,hdr)
% Sizes, maxima and locations of clusters
% 
% function [s]=pclustermaxima(Z,xyz,hdr)
% 
% IN:
%    Z  : values (Accuracies,t,Z... but not p-values)
%    XYZ: locations [x y x]' {in voxels}  [3 x nvox]   
% 
% OUT:
%       hdr: [1x1 struct]   header
%     XYZmm: [3x254 double] locations [x y x]' {in mm}
%       XYZ: [3x254 double] locations [x y x]' {in voxels}
%      nvox: [254x1 double] size of region {in voxels)
%     regnr: [254x1 double] region number
%         Z: [1x254 double] values
% example:
%    [s]=pclustermaxima(st.Z,st.XYZ,st.hdr)
% 
% regnr(i) identifies the ith maximum with a region. Region regnr(i) contains nvox(i) voxels.
%    


 %from [spmlist.m -line 418]
  % Includes Darren Gitelman's code for working around
    % spm_max for conjunctions with negative thresholds
    %----------------------------------------------------------------------
    minz        = abs(min(min(Z)));
    zscores     = 1 + minz + Z;
    [N Z xyz2 A] = spm_max(zscores,xyz);
    Z           = Z - minz - 1;
 
%     %-Convert maxima locations from voxels to mm
%     %----------------------------------------------------------------------
M=hdr.mat;
xyzmm = M(1:3,:)*[xyz2; ones(1,size(xyz2,2))];


s.hdr  =hdr;
s.XYZmm=xyzmm;
s.XYZ  =xyz2;
s.nvox =N;
s.regnr=A;
s.Z    =Z;

% X     - values of 3-D field
% L     - locations [x y x]' {in voxels}
% N     - size of region {in voxels)
% Z     - Z values of maxima
% M     - location of maxima {in voxels}
% A     - region number


