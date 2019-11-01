

function  [h,d ]=rreslice2target(fi2merge, firef, fi2save, interpx,dt)
%  [h,d ]=rreslice2target(fi2merge, firef, fi2save, interpx,dt)
% [h,d ]=rreslice2target(fi2merge, firef, fi2save)
% if [fi2save] is empty/not existing..parse to workspace

if ~exist('interpx')
    interpx=1;
end

[inhdr, inimg]=rgetnii(fi2merge);
[tarhdr      ]=rgetnii(firef);


%  inhdr=spm_vol(fi2merge);
% inimg=spm_read_vols(inhdr);

% [h, d] = nii_reslice_target(inhdr, inimg, tarhdr, 'false') ;
% if interpx==1
%     [h, d] = nii_reslice_target(inhdr, inimg, tarhdr, 'true') ;
% else
%     [h, d] = nii_reslice_target(inhdr, inimg, tarhdr, 'false') ;
% end
[h, d] = nii_reslice_target(inhdr, inimg, tarhdr, interpx) ;



if exist('fi2save')
    if ~isempty(fi2save)
        if exist('dt')~=1
            rsavenii(fi2save,h,d );
        else
            rsavenii(fi2save,h,d,dt );
        end
    end
    
end