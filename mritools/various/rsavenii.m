

function  filenameout=rsavenii(filename,h,d, dt)
%% save Nifti
%  filenameout=rsavenii(filename,h,d, dt)
%             rsavenii(filename,h,d)
% filenameout=rsavenii(filename,h,d) 
%% in
% filename: filename to save (.nii not needed)
% h       : header -->fname is replaced by new filename
% d       : data
%% out
% filenameout : written filename
%% example
% rsavenii('test',h,d )
% rsavenii('test2.nii',h,d )



[pa fi ext]= fileparts(filename);
% if isempty(pa);     pa=''; end
if isempty(ext);    ext='.nii'; end

if ndims(d)==3
    h(1).fname=fullfile(pa,[ fi  ext]);
    if exist('dt')==1 && length(dt)==2
        h.dt=dt;
    end
    h=spm_create_vol(h);
    h=spm_write_vol(h,  d);
    filenameout=h.fname;
    
else
    
    for k=1:size(h,1)
        dum       = h(1);
        dum.n     = [k 1];
        dum.fname =fullfile(pa,[ fi  ext]);
        
        hh2(k,1)=dum;
        if k==1
            %mkdir(fileparts(hh2.fname));
            spm_create_vol(hh2);
        end
        spm_write_vol(hh2(k),d(:,:,:,k));
    end
    try; delete(regexprep(dum.fname,'.nii','.mat')); end
end
     