function [img] = get_slice (Vname,p)

% function [img] = get_slice (Vname,p)
% 
% Get a transverse slice 
%
% Vname 		volume name eg. 'spmT_0004.img');
% p         slice number eg. 31
%
% img        unprocessed slice data 

V=spm_vol(Vname);

% To figure out the appropriate C matrix to use in spm_slice_vol
% use the fact that
%
% [x,y,z,1]' = C [x',y',0,1]
% 
% where [x',y'] define coordinates in your plane of interest.
% A voxel in the volume z=[x,y,z,1]' which corresponds to 
% a pixel in this slice is then 
% a linear combination of [x',y']. For example, to 
% get a transverse slice the z-value is always fixed at p.
% So the 3rd row of C is [0 0 1 p].

% Transverse slice
%==========================================================
C=[1 0 0 0;0 1 0 0;0 0 1 0;0 0 0 1];
DIM=V.dim(1:2);

C(3,4)=p;
%C(3,4)=-p;

img = spm_slice_vol(V,C,DIM,0);
%img = spm_slice_vol(V,inv(C),DIM,0);

%figure
%imagesc(img);

% Add zero matrix onto left edge of 
% rotated and scaled image, then plot
figure
img=rot90(img);
im=image(img);
axis image








%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

vHdr=ha

bb=world_bb(f1)
% bb = [-78 -112 -50; 78 76 85];
Dims = diff(bb)'+1;

TM0 = [ 1 0 0 -bb(1,1)+1;...
    0 1 0 -bb(1,2)+1;...
    0 0 1 0;...
    0 0 0 1]
CM0 = [ 1 0 0 -bb(1,1)+1;...
    0 0 1 -bb(1,3)+1;...
    0 1 1 0;...
    0 0 0 1]
SM0 = [ 0 -1 0 -bb(1,2)+1;...
    0 0 1 -bb(1,3)+1;...
    1 0 0 0;...
    0 0 0 1]

TD = [Dims(1) Dims(2)];
CD = [Dims(1) Dims(3)];
SD = [Dims(2) Dims(3)];

notSure = [1 0 0 0; 0 1 0 0 ; 0 0 1 0; 0 0 0 1];
notSure=vHdr.mat;notSure(:,end)=[0 0 0 1]

TM = inv(TM0*(notSure\vHdr.mat));
CM = inv(CM0*(notSure\vHdr.mat));
SM = inv(SM0*(notSure\vHdr.mat));


as = spm_slice_vol(vHdr,TM,TD,0);
cs = spm_slice_vol(vHdr,CM,CD,0);
ss = spm_slice_vol(vHdr,SM,SD,0);











