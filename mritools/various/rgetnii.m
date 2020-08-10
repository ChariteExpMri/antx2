

function [h d xyz xyzind]=rgetnii(file,imgnum )
%% get Nifti/analyzeFormat
% [h d xyz xyzind]=rgetnii(file )

%% in
% file: filename ; e.g.  'T2brain.nii';
%% out
%[h d xyz]: header,data,xyz
%% example
% [h d xyz]=rgetnii('T2brain.nii')

% [pa fi ext]=fileparts(file)
% if strcmp(ext,'.gz')
%     fname=gunzip(file) 
% end

if exist('imgnum')==0 % no explizit volume-Number as input
    h=spm_vol(file);
    if nargout<=2;
        [d  ]=(spm_read_vols(h));
    elseif nargout==3
        [d xyz]=(spm_read_vols(h));
    elseif nargout==4
        [d xyz]=(spm_read_vols(h));
        [x y z] = ind2sub(size(d),1:length(d(:)));
        xyzind=[x;y;z];
    end

else %explicit volnumber given...used for 4D-data if single VOLUME or VOL-range is used
    
    [h d xyz]=getvols(file,imgnum);
    
    if nargout==4
        [x y z] = ind2sub(size(d),1:length(d(:)));
        xyzind=[x;y;z];
    end
    
end
    
    
function [V2, Y,XYZmm]=getvols(file,imgnum);

V=spm_vol(file);
spm_check_orientations(V);


% imgnum=[2:3]  %2:3
if length(imgnum)==1
    if isnan(imgnum) || isinf(imgnum)  %nan/inf definition --> get all vols
        imgnum=1:numel(V);
    end
elseif length(imgnum)==2
    if isnan(imgnum(end)) || isinf(imgnum(end))
        imgnum(2)=numel(V);
    end
    
end

n=length(imgnum);

% n = numel(V);                                           %-#images
Y = zeros([V(1).dim(1:3),n]);                           %-image data matrix

no=1;
V2=V(1:n);
for i=imgnum
    for p=1:V(1).dim(3)
        Y(:,:,p,no) = spm_slice_vol(V(i),spm_matrix([0 0 p]),V(i).dim(1:2),0);
    end
    V2(no).n     =[no V2(1).n(2)];
    V2(no).n_orig=V(i).n;
    no=no+1;
end
%-Compute XYZmm co-ordinates (if required)
%--------------------------------------------------------------------------
[R,C,P] = ndgrid(1:V(1).dim(1),1:V(1).dim(2),1:V(1).dim(3));
RCP     = [R(:)';C(:)';P(:)';ones(1,numel(R))];
XYZmm   = V(1).mat(1:3,:)*RCP;

