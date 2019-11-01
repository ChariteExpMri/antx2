
% px: mousepath path
% status: pre or post
function varargout=fastsegment(px, status,varargin)




if 0
    px='O:\data4\phagozytose\dat\200_Exp1';
   [t2 template] =fastsegment(px, 'pre','subdir','segm')
   
    px='O:\data4\phagozytose\dat\200_Exp1';
   fastsegment(s.pa, 'post','subdir','segm');
end


pp=cell2struct(varargin(2:2:end),varargin(1:2:end),2);
pp.px=px;
pp.status=status;
if isfield(pp,'subdir')==0
    pp.subdir='';
    replaceT2(pp);
else
    [varo]=useSubdir(pp);
    if strcmp(pp.status,'pre')
    varargout{1} =varo{1};
    varargout{2} =varo{2};
    elseif strcmp(pp.status,'post')
        [varo]=useSubdir(pp);
        
    end
end

% ================================================================================================
function [out]=useSubdir(pp);
out={};
px=pp.px;
if strcmp(pp.status,'pre')

    %copy stuff
    p1=px;
    p2=fullfile(px,pp.subdir);

    warning off;
    try; rmdir(p2, 's'); end
    try; mkdir(p2); end
    
    f1=fullfile(p1,'t2cut@.nii');     f2=fullfile(p2,'t2.nii');          copyfile(f1,f2,'f');
    f1=fullfile(p1,'reorient.mat');   f2=fullfile(p2,'reorient.mat');    copyfile(f1,f2,'f');
    f1=fullfile(p1,'defs.mat');       f2=fullfile(p2,'defs.mat');        copyfile(f1,f2,'f');
    
    load(f2);
    fis=defs.tpms(:,1);
    fis2=replacefilepath(fis,p2);
    copyfilem(fis,fis2);
    defs.tpms(:,1)=fis2;
    save(f2,'defs');
    
    t2        = fullfile(p2,'t2.nii');
    template  = [fis2; fullfile(p2, 'reorient.mat')];
    
    out{1}=t2;
    out{2} =template;
    
elseif strcmp(pp.status,'post')  
   
    p1=fullfile(px,pp.subdir);
    p2=px;
    ref=fullfile(p2,'t2.nii');
    
    %% reslice images
    img={...img        interp
        'c1t2.nii'     1
        'c2t2.nii'     1
        'c3t2.nii'     1
        'mt2.nii'      1
        'c1c2mask.nii' 1 };
    for i=1:size(img,1)
        w1=fullfile(p1,img{i,1});
        w2=fullfile(p2,img{i,1});
        rreslice2target(w1, ref, w2, img{i,2});
    end
    
    %% move files
    fis={... files
        't2_seg_sn.mat'
        't2_seg_inv_sn.mat'
        'y_forward.nii'
        'y_inverse.nii'
        };
    for i=1:size(fis,1)
        w1=fullfile(p1,fis{i,1});
        w2=fullfile(p2,fis{i,1});
        try; movefile(w1, w2, 'f');end
    end
    
    
  
    
    
end













% ================================================================================================
function replaceT2(pp);
px=pp.px;
if strcmp(pp.status,'pre')
    %———————————————————————————————————————————————
    %%   copy replace t2 by t2cut@
    %———————————————————————————————————————————————
    
    
    %save backup copy of origT2
    f1=fullfile(px,'t2.nii');
    f2=fullfile(px,'t2orig@.nii');
    copyfile(f1,f2,'f');
    
    % replace by cutted version
    f1=fullfile(px,'t2cut@.nii');
    f2=fullfile(px,'t2.nii');
    copyfile(f1,f2,'f');
    
    return
end

if strcmp(pp.status,'post')
    %———————————————————————————————————————————————
    %%   copy replace t2cut@ by t2 and change imageDIMS
    %———————————————————————————————————————————————
    
    % back to orig
    f1=fullfile(px,'t2orig@.nii');
    f2=fullfile(px,'t2.nii');
    copyfile(f1,f2,'f');
    
    
    % reslice files
    w1=fullfile(px,'c1t2.nii');
    rreslice2target(w1, f2, w1, 1);
    
    w1=fullfile(px,'c2t2.nii');
    rreslice2target(w1, f2, w1, 1);
    
    w1=fullfile(px,'c3t2.nii');
    rreslice2target(w1, f2, w1, 1);
    
    w1=fullfile(px,'mt2.nii');
    rreslice2target(w1, f2, w1, 1);
    
    
    w1=fullfile(px,'c1c2mask.nii');
    % w2=fullfile(px,'c1c2mask2.nii');
    rreslice2target(w1, f2, w1, 1);
    return
end

