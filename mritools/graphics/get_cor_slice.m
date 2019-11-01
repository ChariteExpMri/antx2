function [img] = get_cor_slice (Vname,p,interp)

% function [img] = get_cor_slice (Vname,p,interp)
% 
% Get a coronal slice (ie. fixed y)
%
% Vname 		volume name eg. 'spmT_0004.img');
% p         slice number eg. 31
% interp		'trilinear','sinc' or 'none' (the default)
%				Note: for the first two options we return
%				an oversample image - with twice as many
%				voxels in each dimension
%
% img        unprocessed slice data 

if nargin < 3 | isempty(interp)
   interp='none';
end


V=spm_vol(Vname);

% Get raw number of pixels
DIM=V.dim([1 3]);

disp('Warning: get_cor_slice is untested');

%interp='trilinear';
%interp='sinc';
%interp='none';

switch interp
case 'sinc',
   C=[0.5 0 0 0;0 0 1 p;0 0 0.5 0;0 0 0 1];
   img = spm_slice_vol(V,C,DIM*2,-5);
   msk=img<0;
   img(msk)=0;
case 'trilinear',
   C=[0.5 0 0 0;0 0 1 p;0 0 0.5 0;0 0 0 1];
   img = spm_slice_vol(V,C,DIM*2,1);
otherwise,
   C=[1 0 0 0;0 0 1 p;0 0 1 0;0 0 0 1];
   img = spm_slice_vol(V,C,DIM,0);
   
end

img=rot90(img);

%figure
%imagesc(img);


% Add zero matrix onto left edge of 
% rotated and scaled image, then plot
