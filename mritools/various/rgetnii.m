

function [h d xyz xyzind]=rgetnii(file )
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
