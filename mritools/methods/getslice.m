

%% ALLEN
% p='O:\data\karina\templates\AVGT.nii'
% img=getslice(p,100, 2, 1);
% %NATIVE
% p2='O:\data\karina\dat\s20160613_RosaHDNestin_eml_08_1_x_x\t2.nii'
% img=getslice(p2,10,1 , 1);


function img=getslice(Vname,p, dirs, show)

interp=0;
if dirs==1
    [img] = get_slice (Vname,p);
elseif dirs==2
    [img] = get_cor_slice (Vname,p,interp);
elseif dirs==3
    [img] = get_sag_slice (Vname,p,interp);
end

if exist('show')~=1; show=0;end
if show==1
   lab={'axial' 'coronar' 'saggital'} ;
   fg,imagesc(img);colormap(gray); 
   title(lab{dirs});
end


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
% figure
img=rot90(img);
% im=image(img);
% axis image




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

% disp('Warning: get_cor_slice is untested');
%interp='trilinear';
%interp='sinc';
%interp='none';

% switch interp
% case 'sinc',
%    C=[0.5 0 0 0;0 0 1 p;0 0 0.5 0;0 0 0 1];
%    img = spm_slice_vol(V,C,DIM*2,-5);
%    msk=img<0;
%    img(msk)=0;
% case 'trilinear',
%    C=[0.5 0 0 0;0 0 1 p;0 0 0.5 0;0 0 0 1];
%    img = spm_slice_vol(V,C,DIM*2,1);
% otherwise,
%    C=[1 0 0 0;0 0 1 p;0 0 1 0;0 0 0 1];
%    img = spm_slice_vol(V,C,DIM,0);
%    
% end

% img=rot90(img);

% if 0
%     ts = [0 0 0 0 0 0 1 1 1;...
%       0 0 0 pi/2 0 0 1 -1 1;...
%       0 0 0 pi/2 0 -pi/2 -1 1 1];
%   n=3
%  c= spm_matrix(ts(3,:));
%  c(n,4)=p;
%  img = spm_slice_vol(V,c,DIM,0);
% %  img=rot90(img);
%  fg,imagesc(img)
% end

%  ts = [0 0 0 0 0 0 1 1 1;...
%       0 0 0 pi/2 0 0 1 -1 1;...
%       0 0 0 pi/2 0 -pi/2 -1 1 1];
%   
%  c= spm_matrix(ts(2,:));
 
 c=[1 0 0 0
    0 0 1 0
    0 1 0 0
    0 0 0 1];
 
 c(2,4)=p;
 img = spm_slice_vol(V,c,DIM,0);
 img=rot90(img);
%  fg,imagesc(img)
% 
%  
%  %••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
%  N=1
%    dim=V.dim( sort( setdiff([1:3],N))     )
%  
%  ts = [
%      0 0 0 pi/2 0 -pi/2 -1 1 1
%      0 0 0 pi/2 0 0 1 -1 1
%      0 0 0 0 0 0 1 1 1];
%  
%   ts = [
%      0 0 0 pi/2 0 -pi/2 -1 1 1
%      0 0 0 pi/2 0 0 1 -1 1
%      0 0 0 0 0 0 1 1 1];
%  
%  c= (ts(N,:))
%  c(N,4)=p
%  img = spm_slice_vol(V,c,dim,0);
%  img=rot90(img);
%  fg,image(img)
% 
%  
%  %•••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••• 
% DIM=V.dim([2 3]);
% 
% 
% %interp='trilinear';
% %interp='sinc';
% %interp='none';
% 
% switch interp
% case 'sinc',
%    C=[0 0 1 p;0.5 0 0 0;0 0.5 0 0;0 0 0 1];
%    img = spm_slice_vol(V,C,DIM*2,-5);
%    msk=img<0;
%    img(msk)=0;
% case 'trilinear',
%    C=[0 0 1 p;0.5 0 0 0;0 0.5 0 0;0 0 0 1];
%    img = spm_slice_vol(V,C,DIM*2,1);
% otherwise,
%    C=[0 0 1 p;1 0 0 0;0 1 0 0;0 0 0 1];
%    img = spm_slice_vol(V,C,DIM,0);
% end
%  img=rot90(img);
% 
% fg,image(img)
%    
%    %••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
%  
%  
%  
%  C=[1 0 0 0;0 1 0 0;0 0 1 0;0 0 0 1];
% DIM=V.dim(1:2);
% 
% C(3,4)=p;
% %C(3,4)=-p;
% 
% img = spm_slice_vol(V,C,DIM,0);
% %img = spm_slice_vol(V,inv(C),DIM,0);
% 
% %figure
% %imagesc(img);
% 
% % Add zero matrix onto left edge of 
% % rotated and scaled image, then plot
% figure
% img=rot90(img);
% im=image(img);
% axis image
%•••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••• 
%figure
%imagesc(img);


% Add zero matrix onto left edge of 
% rotated and scaled image, then plot



function [img] = get_sag_slice (Vname,p,interp)

% function [img] = get_sag_slice (Vname,p,interp)
% 
% Get a sagittal slice  (ie. fixed x)
%
% Vname 		volume name eg. 'spmT_0004.img');
% p         slice number eg. 31
% interp		'trilinear','sinc' or 'none' (the default)
%				Note: for the first two options we return
%				an oversample image - with twice as many
%				voxels in each dimension
%
%
% img        unprocessed slice data 

if nargin < 3 | isempty(interp)
   interp='none';
end

V=spm_vol(Vname);



% Get raw number of pixels
DIM=V.dim([2 3]);


%interp='trilinear';
%interp='sinc';
%interp='none';

switch interp
case 'sinc',
   C=[0 0 1 p;0.5 0 0 0;0 0.5 0 0;0 0 0 1];
   img = spm_slice_vol(V,C,DIM*2,-5);
   msk=img<0;
   img(msk)=0;
case 'trilinear',
   C=[0 0 1 p;0.5 0 0 0;0 0.5 0 0;0 0 0 1];
   img = spm_slice_vol(V,C,DIM*2,1);
otherwise,
   C=[0 0 1 p;1 0 0 0;0 1 0 0;0 0 0 1];
   img = spm_slice_vol(V,C,DIM,0);
   
end

img=rot90(img);

% figure;image(img);


% Add zero matrix onto left edge of 
% rotated and scaled image, then plot






