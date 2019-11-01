

%  [bb vox]=world_bb(fullfile(pwd,'_AwAVGT.nii'));
%  bb =
% 
%    -5.9252   -9.4889   -8.6710
%     5.5466    6.5385    0.7027
%     
% vox =
% 
%     0.0699    0.0700    0.0700
    
    
   %% MASK
    tic
    matlabbatch=[];
%     matlabbatch{1}.spm.spatial.normalise.estwrite.subj.source ={fullfile(pa, ['c1' fi ext] ) }; %{'V:\dtiatlas2spmmouse\data32new\c1T3.nii,1'};

    matlabbatch{1}.spm.spatial.normalise.estwrite.subj.source =...%{fullfile(pa, ['c1' fi ext] ) }; %{'V:\dtiatlas2spmmouse\data32new\c1T3.nii,1'};
     { fullfile(pwd,'wc1T2.nii')}

matlabbatch{1}.spm.spatial.normalise.estwrite.subj.wtsrc = '';
    matlabbatch{1}.spm.spatial.normalise.estwrite.subj.resample = {
%         maskfile
         fullfile(pwd,'whemi2.nii')
        %     'V:\dtiatlas2spmmouse\data32new\T3.nii,1'
        %     'V:\dtiatlas2spmmouse\data32new\c1T3.nii,1'
        %     'V:\dtiatlas2spmmouse\data32new\c2T3.nii,1'
        }  ;
%     matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.template =TPMpathnew(2);% {'V:\dtiatlas2spmmouse\data32new\Atpl_greyr62.nii,1'};
    
    matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.template =...   %TPMpathnew(2);% {'V:\dtiatlas2spmmouse\data32new\Atpl_greyr62.nii,1'};
 { fullfile(pwd,'_Atpl_greyr62.nii')};

    matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.weight = '';
    matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.smosrc = 0.3;
    matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.smoref = 0.2;
    matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.regtype = 'subj';
    matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.cutoff = 1;
    matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.nits = 16;
    matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.reg = 1;
    matlabbatch{1}.spm.spatial.normalise.estwrite.roptions.preserve = 0;
    
    % matlabbatch{1}.spm.spatial.normalise.estwrite.roptions.bb = [-Inf -Inf -Inf;     Inf Inf Inf];
%     matlabbatch{1}.spm.spatial.normalise.estwrite.roptions.bb = [bb];
    
  matlabbatch{1}.spm.spatial.normalise.estwrite.roptions.bb =[...
       -5.9252   -9.4889   -8.6710
    5.5466    6.5385    0.7027
    ]
    % matlabbatch{1}.spm.spatial.normalise.estwrite.roptions.vox = [0.1 0.1 0.1];
     matlabbatch{1}.spm.spatial.normalise.estwrite.roptions.vox = [0.07 0.07 0.07];
    %matlabbatch{1}.spm.spatial.normalise.estwrite.roptions.vox = [vox];
    
    matlabbatch{1}.spm.spatial.normalise.estwrite.roptions.interp = 0;
    matlabbatch{1}.spm.spatial.normalise.estwrite.roptions.wrap = [0 0 0];
    matlabbatch{1}.spm.spatial.normalise.estwrite.roptions.prefix = 'O';
    spm_jobman('run',  matlabbatch);
    toc
    
    %===================
  %% getHEMI-normalized
    [h3 d3 ]=rgetnii(fullfile(pwd,[  'Owhemi2.nii ']) );
    d3=d3(:);
    voxvol2=abs(prod(diag(h3.mat(1:3,1:3))));
    vol2=[sum((d3==1)) sum((d3==2))].*voxvol2;
    post=  ((vol2./sum(vol2))*100)  ;
    
%     ratio= vol2(1)./vol2(2)
ratio= vol2(1)./((vol2(1)+vol2(2))/2)
refratio=1.03414423030123
    disp( sprintf('%1.14f',ratio))
   disp(    sprintf('%1.14f',refratio))
    disp(   sprintf('%1.14f',ratio-refratio))
    
    
    
    
    