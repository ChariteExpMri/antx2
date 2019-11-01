%% set volume to centerIMAGE
% function mnew=ftrafo_center(f1,f2)
% f1: vol to valculate the centerPosition: [f1]=filename or nifti-HDR
% f2: (optional): vol to apply centerposMAT   ...if empty.. centerpos-MAT is send to output
%% EXAMPLE
%     do= 1
%     if do==1
%         %% use filenames
%         pa=pwd;
%         f1=fullfile(pa,'2_T2_ax_mousebrain_1.nii');
%         f2=fullfile(pa,'t3.nii');
%         copyfile(f1,f2,'f');
%         f3=fullfile(pa,'t4.nii');
%         copyfile(f1,f3,'f');
%         ftrafo_center(f2,f3)
%         %
%     elseif do==2
%         %% use Header
%         pa=pwd;
%         f1=fullfile(pa,'2_T2_ax_mousebrain_1.nii');
%         f2=fullfile(pa,'t3.nii');
%         copyfile(f1,f2,'f');
%         f3=fullfile(pa,'t4.nii');
%         copyfile(f1,f3,'f');
%         hd=spm_vol(f2)
%         ftrafo_center(hd,f3)
%     end
    
function mnew=ftrafo_center(f1,f2)


warning off;


% clear
if 0
    
    do= 1
    if do==1
        %% use filenames
        pa=pwd;
        f1=fullfile(pa,'2_T2_ax_mousebrain_1.nii');
        f2=fullfile(pa,'t3.nii');
        copyfile(f1,f2,'f');
        f3=fullfile(pa,'t4.nii');
        copyfile(f1,f3,'f');
        ftrafo_center(f2,f3)
        %
    elseif do==2
        
        pa=pwd
        f1=fullfile(pa,'cMSME-T2-map_20slices_1.nii');
        f2=fullfile(pa,'t3.nii');
        copyfile(f1,f2,'f');
        f3=fullfile(pa,'t4.nii');
        copyfile(f1,f3,'f');
        ftrafo_center(f2,f3);
        
    elseif do==3
         %% use Header
        pa=pwd;
        f1=fullfile(pa,'2_T2_ax_mousebrain_1.nii');
        f2=fullfile(pa,'t3.nii');
        copyfile(f1,f2,'f');
        f3=fullfile(pa,'t4.nii');
        copyfile(f1,f3,'f');
        hd=spm_vol(f2)
        ftrafo_center(hd,f3)
    end
end


if isstruct(f1)%use header
    ha  =f1;   
else %use file
%     m=spm_get_space(f1);
    %  [bb vx] = world_bb(f1)
    [ha  ]=spm_vol(f1);
end

mvol=ha;
if size(ha,1)>1 %% 4d
    ha=ha(1);
end

m=ha.mat;
v=(spm_imatrix(m));


res=v(7:9);
m=[[diag(res); 0 0 0] [[-v(7:9)]'.*round(ha.dim(1:3)/2)' ;1]];


mg=m       ;%  [m]=   VG=refIMG %reference image
mf=ha.mat  ;%   VF=movIMG %source (moved) image


% MR = MG/MF
MR=mg/mf;

% mfvol=spm_vol(f1);
% 
% %% 4d
% if size(mfvol,1)>1 
%     mfvol=mfvol(1);
% end
mfvol = ha;
mnew  = MR * mfvol.mat;

if exist('f2')==1
    
    try;
        [pa fi ext]=fileparts(f2);
        delete(fullfile(pa,[fi '.mat']));
    end

    ha=spm_vol(f2);
    
    if size(ha,1)>1 %struct
        inum =1;
        hr       = ha(inum); %get 3d-HDR of transformed data with this vol-Number
        hr.mat   =mnew;  %NEW-MAT
        %hr.fname = s.ac{j} ;%fullfile(fileparts(s.ac{j}), '_o.nii')  ;%
        
        clear hh2
        for k=1:size(ha,1)
            dum=hr;
            dum.n=[k 1];
            
            hh2(k,1)=dum;
            if k==1
                %mkdir(fileparts(hh2.fname));
                spm_create_vol(hh2);
            end
%             spm_write_vol(hh2(k),a(:,:,:,k));
        end
    else
        %% 3D
        spm_get_space(f2, mnew );
        
        
    end
    
    try; 
        [pa fi ext]=fileparts(f2);
        delete(fullfile(pa,[fi '.mat']));
    end
    
    
    
    %     %———————————————————————————————————————————————
    %     %%  SAVE NIFTI (3d/4d)
    %     %———————————————————————————————————————————————
    %     fclose('all');
    %     [ha a]=rgetnii
    %     if ndims(ni.d)==3
    %         hh=spm_create_vol(hh);
    %         hh=spm_write_vol(hh,  ni.d);
    %     elseif ndims(ni.d)==4
    %         clear hh2
    %         for j=1:size(ni.d,4)
    %             dum=hh;
    %             dum.n=[j 1];
    %             hh2(j,1)=dum;
    %             if j==1
    %                 %mkdir(fileparts(hh2.fname));
    %                 spm_create_vol(hh2);
    %             end
    %             spm_write_vol(hh2(j),ni.d(:,:,:,j));
    %         end
    %     end
    %
    %     try
    %         delete(strrep(fpname,'.nii','.mat')) ; %% delete helper.mat
    %     end
    %      fclose('all');
    
    
end

return

%
% MR=
% mg/mf*mfvol.mat  =ref
%
% MR * mfvol.mat
% mf/mg
%
% mov = mf
% ref = mg
% % ---------------------
% mr =mg/mf   %ref/mov
% new=mr*mf
%
% new=mg/mf*mf
% new=ref/mov*mov
%% cdcd

% try; delete('t5.nii'); end
% try; delete('t5.mat'); end
% copyfile(f22,f2,'f')
% r0=spm_vol(f1)
% m0=spm_vol(f2)
% r=r0(1).mat
% m=m0.mat
%
% % new=r/m
% % new =  m\(r\m)*r
%
% % spm_get_space(f2, new);
% %
% e=[4 -8 4 [0 0 .209] 1 1 1 0 0 0]
% new=spm_matrix(e)*m
% fsetorigin(f2, (new))
%
% m2=spm_imatrix(m)
% r2=spm_imatrix(r)

%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
%%   test-2  get mat from Image A to A' and apply to Image B to yield B'
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
% VF.mat\spm_matrix(x(:)')*VG.mat

if 0 %only 3d
    fa=fullfile(pa,'cnan_2.nii')
    [ha a]=rgetnii(fa);
    rsavenii('cnan_2_img1.nii',ha(1),a(:,:,:,1))
    
    fa=fullfile(pa,'cMSME-T2-map_20slices_1.nii')
    [ha a]=rgetnii(fa);
    rsavenii('MSME_img1.nii',ha(1),a(:,:,:,1))
end


try; delete('t5.nii'); end
try; delete('t5.mat'); end

f1=fullfile(pa,'2_T2_ax_mousebrain_1.nii')
f2=fullfile(pa,'t3.nii')

% f3=fullfile(pa,'MSME_img1.nii')
f3=fullfile(pa,'cnan_2_img1.nii')

f4=fullfile(pa,'t5.nii')
copyfile(f3,f4,'f')

s1=spm_vol(f1);
s2=spm_vol(f2);
s3=spm_vol(f3);
s4=spm_vol(f4);

m1=s1.mat
m2=s2.mat
m3=s3.mat
m4=s4.mat


% new=(m1/m2)*m3
% new=inv(m1\m2)*m3
new=inv(m1/m2)*m3   %best ####
% new=m3*(m1\m2)


hb=spm_vol(f4);
hb=ha(1);
hb.mat=new
rsavenii(f4,hb,a(:,:,:,1))
%  fsetorigin(f4, (new))