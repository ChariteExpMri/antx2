

% snip_get_slices: get slices in axial, coronal or sagittal orientation
% function [d s]=snip_get_slices(f,orient,slicesnum,slicesmm,show )
%% INPUT
% f  : image str or cell with 1 or images
% if f points to one image: all information and slices are obtained from this image
% if f points to two images: the information is obtained from the 1st image but the slices are extracted from the 2nd image
%    -used to obtain the overlay slices with same size,voxsize, and dims as the background-image
% orient, (number)[1,2 or 3] or (string): 'axial', 'coronal' or 'sagittal'
% slicesnum: either numeric or string  (slicesmm must be empty)
%            # number/vector to get the slice indices
%            # string to code stepsize ('stepwidth'), example: '3' to get each 3rd slice
%            or string with 2 or 3 string elements ('stepwidth startpos endpos'),
%            example: '2 20'    : each 3rd slice in the range 20th to end-20th slice
%            example: '3 10 10' : each 3rd slice in the range 10th to end-10th slice
%            use nan for startpos or endpos to reset to 1st or endth slice, respectively
%             example: '3 nan 20'  : each 3rd slice within slice range  1 to end-20
%                      '3 20 nan'  : each 3rd slice within slice range  20 to end
% slicesmm: slices in mm  (slicesnum must be empty) as number or vector
%           example:  [-2 0 1]  : obtain slices -2mm, 0mm and 1mm away from origin
% show    : [0,1] show slices
%% OUTPUT
% d: 3d-arry of slices
% s: struct containing information (image header, slicesnum and slicesmm )
%% example1
%     f1=fullfile(pwd,'AVGT.nii')
%     f2=fullfile(pwd,'x_t2.nii');
%     slic='2 10 10'  ; get each 2nd slice within slice range  10 to end-10
%     [d ds]=getslices(f1     ,2,slic ); %backgroundImage
%     [o do]=getslices({f1 f2},2,slic ); %overlayedImage in reference to bgImage
%% example2
%     f1=fullfile(pwd,'t22.nii')
%     f2=fullfile(pwd,'c1t22.nii');
%     [d ds]=getslices(f1,1,['2'],[],0 );
%     [o os]=getslices({f1 f2},1,['2'],[],0 );
%     flip=0

function [d s]=get_slices(f,orient,slicesnum,slicesmm,show,volnum )



f = cellstr(f);
V = spm_vol(f{1});

if exist('volnum')~=1;
    volnum1=1;    %1st image
    volnum2=1;    %2nd image
else
    if length(volnum)==1
        volnum1 =volnum;    %1st image
        volnum2 =1;    %2nd image
    elseif length(volnum)==2
        volnum1=volnum(1);    %1st image
        volnum2=volnum(2);    %2nd image
    end
end %4dvolume



V=V(volnum1);

orientlabel={'axial', 'coronal', 'sagittal'};
if isnumeric(orient);     orient=orientlabel{orient}; end

ixorient  = strcmpi(orient,orientlabel);

% Candidate transformations
ts              = [0 0 0 0 0 0 1 1 1;...
    0 0 0 pi/2 0 0 1 -1 1;...
    0 0 0 pi/2 0 -pi/2 -1 1 1];
transform       = spm_matrix(ts(ixorient,:));

% Image dimensions
D               = V.dim(1:3);
% Image transformation matrix
T               = transform * V.mat;
% Image corners
voxel_corners   = [1 1 1; ...
    D(1) 1 1; ...
    1 D(2) 1; ...
    D(1:2) 1; ...
    1 1 D(3); ...
    D(1) 1 D(3); ...
    1 D(2:3) ; ...
    D(1:3)]';
corners         = T * [voxel_corners; ones(1,8)];
sorted_corners  = sort(corners, 2);
% Voxel size
voxel_size      = sqrt(sum(T(1:3,1:3).^2));

% Slice dimensions
% - rows: x and y of slice image;
% - cols: negative maximum dimension, slice separation, positive maximum dimenions
slice_dims      = [sorted_corners(1,1) voxel_size(1) sorted_corners(1,8); ...
    sorted_corners(2,1) voxel_size(2) sorted_corners(2,8)];
% Slices (in mm, world space):
slices          = sorted_corners(3,1):voxel_size(3):sorted_corners(3,8);
slicesix        =1:length(slices);


if exist('slicesnum') && ~isempty(slicesnum)
    if isnumeric(slicesnum)
        slicesmm=slices(vecnearest2(slicesix,slicesnum)');
        nslices=length(slicesmm);
    else
        if ~isempty(strfind(slicesnum,'n'))
            nimg=str2num(strrep(slicesnum,'n',''));
            slicenum=round(linspace(slicesix(1),slicesix(end),nimg+2));
            slicenum=slicenum(2:end-1); %don't use 1 and last slice
            slicesmm=slices(slicenum);
            nslices=length(slicesmm);
        elseif strcmp(slicesnum,'all') || strcmp(slicesnum,':')%all slices
            slicenum=1:length(slices);
            slicesmm=slices;
            nslices=length(slicesmm);
        else
            str1=str2num(slicesnum); % stepwise
            if length(str1)==1
                slicesnum=slicesix(1):str1:slicesix(end);
                slicesmm=slices(vecnearest2(slicesix,slicesnum)');
                nslices=length(slicesmm);
            elseif length(str1)>1
                if isnan(str1(2))==1;
                    s1=1;
                else
                    s1=str1(2);
                end
                
                if length(str1)>2
                    if isnan(str1(3))==1;
                        s2=length(slicesix);
                    else
                        s2=length(slicesix)-str1(3)+1;
                    end
                else
                    s2=length(slicesix);
                end
                slicesnum=s1:str1(1):s2;
                slicesmm=slices(vecnearest2(slicesix,slicesnum)');
                nslices=length(slicesmm);
            end
        end
    end
else
    slicesnum=slicesix;
    nslices=size(slicesmm,1);
end

% Plane coordinates
X               = 1;
Y               = 2;
Z               = 3;
dims            = slice_dims;
xmm             = dims(X,1):dims(X,2):dims(X,3);
ymm             = dims(Y,1):dims(Y,2):dims(Y,3);


% zmm             = slices(ismember(slices,slicesmm));
zmm             = slices(vecnearest2(slices,slicesmm));


[y, x]          = meshgrid(ymm,xmm');

% Voxel and panel dimensions
vdims           = [length(xmm),length(ymm),length(zmm)];
pandims         = [vdims([2 1]) 3];



nvox        = prod(vdims(1:2));

hold=0;

% disp('nslices');
% disp(nslices);



d=zeros([fliplr(vdims(1:2)) nslices ]);


if length(f)==2
    V=spm_vol(f{2});
    V=V(volnum2);
%     if length(V)>1
%     V=V(1);
%     end
end
%  V=spm_vol(fullfile(pwd,'Rct.nii'));
for is=1:nslices
    
    xyzmm = [x(:)';y(:)';ones(1,nvox)*zmm(is);ones(1,nvox)];
    
    vixyz = (transform*V.mat) \ xyzmm;
    % return voxel values from image volume
    
    slice = spm_sample_vol(V,vixyz(1,:),vixyz(2,:),vixyz(3,:), hold);
    % transpose to reverse X and Y for figure
    slice = reshape(slice, vdims(1:2))';
    
    if strcmp(orient,'sagittal');
        slice=fliplr(slice);
    end
    
    %      if is==1
    % %         d=zeros([size(slice) length(slicesmm) ]);
    %         d=zeros([fliplr(vdims(1:2)) length(slicesmm) ]);
    %     end
    d(:,:,is) = slice;
    
    
end

% fg,imagesc(slice);
% axis image;
% axis xy;





s.V=V;
s.smm      =slicesmm ;
s.slicesnum=slicesnum;
s.transform=transform;

if 0
    
    'a'
    % ==============================================
    %%
    % ===============================================
    
    vm=inv(V(1).mat);
    orig=round([0 0 0 ]*vm(1:3,1:3)+vm(1:3,4)')
    orig=abs((diag(V.mat(1:3,1:3))<0)'.*V.dim+[diag(V.mat(1:3,1:3))<0']'-round([0 0 0 ]*vm(1:3,1:3)+vm(1:3,4)'))
    sl=orig(find(ixorient) )
    co=orig(find(~ixorient) )
    
    disp(orig)
    
    orientnum=find(ixorient)
    if orientnum==1
        co2= orig(1:2)
        
        %        co2(1)=V.dim(orientnum)-co2(1)
    elseif orientnum==2
        co2= orig([1 3])
    elseif orientnum==3
        co2=([orig([2 3])])
    end
    
    d2=montageout(permute(d,[1 2 4 3]),[2 nan]);
    fg;imagesc(d2);axis xy; colormap gray
    axis image
    
    vline(co2(1),'color','w');
    hline(co2(2),'color','w');
    
    'a'
    %% end
end


ps.show=0;
if exist('show')
    if ~isempty(show)
        ps.show=show;
    end
end
if ps.show
    d2=montageout(permute(d,[1 2 4 3]),[2 nan]);
    fg;imagesc(d2);axis xy;
end



