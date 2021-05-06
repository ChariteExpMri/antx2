

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
% works with 4d

% remove both pinfo and private ( removing of pinfo  allows to store TPMs with dataType: 2

warning off;

[pa fi ext]= fileparts(filename);
% if isempty(pa);     pa=''; end
if isempty(ext);    ext='.nii'; end

if ndims(d)==3
    h(1).fname=fullfile(pa,[ fi  ext]);
    if exist('dt')==1
        if length(dt)==2
            h.dt=dt;
        else
            h.dt=[dt 0];
        end
    end
    
    if sum((round(d(:))-d(:)).^2)~=0
        try; h=rmfield(h,'pinfo'); end
        try; h=rmfield(h,'private');end
    end
    
    h=spm_create_vol(h);
    h=spm_write_vol(h,  d);
    filenameout=h.fname;
    
else % 4d-data
    % ==============================================
    %% 4D
    % ===============================================
    removefields=0;
    if sum((round(d(:))-d(:)).^2)~=0
        removefields=1;
    end
    
    
    clear hh2
    for k=1:size(d,4) ; %size(h,1)
        dum       = h(1);
        dum.n     = [k 1];
        dum.fname =fullfile(pa,[ fi  ext]);
        
        if exist('dt')==1
            if length(dt)==2
                dum.dt=dt;
            else
                dum.dt=[dt 0];
            end
        end
        %         try; dum=rmfield(dum,'pinfo'); end
        %         try; dum=rmfield(dum,'private');end
        if removefields==1 ;%sum((round(d(:))-d(:)).^2)~=0
            try; dum=rmfield(dum,'pinfo'); end
            try; dum=rmfield(dum,'private');end
        end
        hh2(k,1)=dum;
    end
    
    
    spm_create_vol(hh2);
    
    for k=1:size(d,4)
        spm_write_vol(hh2(k),d(:,:,:,k));
    end
    
    
    try; 
        [ps name ext]=fileparts(dum.fname);
        delete(fullfile(ps,[name '.mat']));
    end
    % ==============================================
    %%
    % ===============================================
end
