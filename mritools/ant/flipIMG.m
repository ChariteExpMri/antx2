

function flipIMG(f1,f2,mode,dim,doreslice,dt,interp)


if exist('mode')~=1            ;mode=1;       end
if exist('dim')~=1             ;dim=1;        end
if exist('doreslice')~=1       ;doreslice=1;  end
if exist('dt')~=1              ;dt=64;        end
if exist('interp')~=1          ;interp=1;     end


% f1 ='F:\data7\anastasia_maskcheck\dat\flip_mask1\x_t1_mask.nii'
% f2 ='F:\data7\anastasia_maskcheck\dat\flip_mask1\blob.nii'

if 0
    %% ________________________________________________________________________________________________
    f1 ='F:\data7\anastasia_maskcheck\dat\flip_mask1\x_t1_mask.nii'
%     f1 ='F:\data7\anastasia_maskcheck\dat\flip_mask1\AVGT.nii'
    f2 ='F:\data7\anastasia_maskcheck\dat\flip_mask1\blob.nii'
    mode=1
    dim=1
    interp=0
    doreslice=1
    dt=64;
    flipIMG(f1,f2,mode,dim,doreslice,dt,interp)
    %% ________________________________________________________________________________________________
    
end


if mode==1
    % copyfile(f1,f2,'f')
    [ha a]=rgetnii(f1);
    a     = flipdim(a,1);% flip image data
        
    hb=ha;
    % calculate adjusted mat-file data
    hb.mat(1:3,4) = hb.mat(1:3,4)+hb.mat(1:3,1)*hb.dim(1);
    hb.mat(2:3,1) = -hb.mat(2:3,1);
    hb.mat(1,2:4) = -hb.mat(1,2:4);

    try; delete(f2); end
    rsavenii(f2, hb, a,dt);
    
       
%     rmricron([],fullfile(pwd,'AVGT.nii'),f2,1);
%     rmricron([],fullfile(pwd,'AVGT.nii'),f1,1);
    
    
    ha=spm_vol(f1);
    hb=spm_vol(f2);
    %ha.mat-hb.mat
    if doreslice==1
        rreslice2target(f2, f1, f2, interp,dt);
    end
    
%     ha=spm_vol(f1);
%     hb=spm_vol(f2);
%     ha.mat-hb.mat;
   % rmricron([],f1,f2,0);
% %     rmricron([],fullfile(pwd,'AVGT.nii'),f2,0);
    
    
end

% ==============================================
%%
% ===============================================
if mode==2
    [ha a]=rgetnii(f1);
    a2=flipdim(a,dim);
    try; delete(f2); end
    rsavenii(f2, ha, a2,[dt]);
    %     rmricron([],f1,f2,0);
    %     rmricron([],fullfile(pwd,'AVGT.nii'),f3,0);
end
