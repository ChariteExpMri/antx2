


tpm=  {    'wc1T2.nii'    'wc2T2.nii'  }';
 tpm=fullpath(pwd,tpm);
 makebrainmask2(tpm, .2, 'mousemask.nii')
 
 
 tpm=  {    '_Atpl_greyr62.nii'    '_Atpl_whiter62.nii'  }';
 tpm=fullpath(pwd,tpm);
 makebrainmask2(tpm, .2, 'templatemask.nii')
 
 
  [fileout h x ]=rapplymask('wT2.nii ','mousemask.nii','>0',1,nan,'_masked');
 [fileout h x ]=rapplymask('_Atpl_mouseatlasNew.nii ','templatemask.nii','>0',1,nan,'_masked');
 
 
 %% normalize
 
%  1.02303491592024
% 1.03414423030123
% -0.01110931438099
 
matlabbatch=[]
matlabbatch{1}.spm.spatial.normalise.estwrite.subj.source = {'V:\projects\atlasRegEdemaCorr\optimiceWarp\s20150909_FK_C2M10_1_3_1_1\wT2_masked.nii'};
matlabbatch{1}.spm.spatial.normalise.estwrite.subj.wtsrc =''% {'V:\projects\atlasRegEdemaCorr\optimiceWarp\s20150909_FK_C2M10_1_3_1_1\wmask2.nii'};
matlabbatch{1}.spm.spatial.normalise.estwrite.subj.resample = {...
    'V:\projects\atlasRegEdemaCorr\optimiceWarp\s20150909_FK_C2M10_1_3_1_1\whemi2.nii'
    'V:\projects\atlasRegEdemaCorr\optimiceWarp\s20150909_FK_C2M10_1_3_1_1\wmask2.nii'
    };
matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.template = {'V:\projects\atlasRegEdemaCorr\optimiceWarp\s20150909_FK_C2M10_1_3_1_1\_Atpl_mouseatlasNew_masked.nii'};
matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.weight = '';
matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.smosrc =.7 ;0.3;
matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.smoref =.7; 0.2;
matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.regtype = 'subj';
matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.cutoff =1;
matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.nits = 16;
matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.reg = .1;
matlabbatch{1}.spm.spatial.normalise.estwrite.roptions.preserve = 0;
matlabbatch{1}.spm.spatial.normalise.estwrite.roptions.bb = [-5.9252 -9.4889 -8.671
                                                             5.5466 6.5385 0.7027];
matlabbatch{1}.spm.spatial.normalise.estwrite.roptions.vox = [0.07 0.07 0.07];
matlabbatch{1}.spm.spatial.normalise.estwrite.roptions.interp = 0;
matlabbatch{1}.spm.spatial.normalise.estwrite.roptions.wrap = [0 0 0];
matlabbatch{1}.spm.spatial.normalise.estwrite.roptions.prefix = 'O';
    
 spm_jobman('run',  matlabbatch);

%   %% getHEMI-normalized
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

% with maskbrain
%     1.00848430525099
% 1.03414423030123
% -0.02565992505024



%% normalized using trilinar interp


matlabbatch=[]
matlabbatch{1}.spm.spatial.normalise.estwrite.subj.source = {'V:\projects\atlasRegEdemaCorr\optimiceWarp\s20150909_FK_C2M10_1_3_1_1\wT2_masked.nii'};
matlabbatch{1}.spm.spatial.normalise.estwrite.subj.wtsrc = {''};
matlabbatch{1}.spm.spatial.normalise.estwrite.subj.resample = {...
        'V:\projects\atlasRegEdemaCorr\optimiceWarp\s20150909_FK_C2M10_1_3_1_1\wT2.nii'
        'V:\projects\atlasRegEdemaCorr\optimiceWarp\s20150909_FK_C2M10_1_3_1_1\wc1T2.nii'
        'V:\projects\atlasRegEdemaCorr\optimiceWarp\s20150909_FK_C2M10_1_3_1_1\wc2T2.nii'
        'V:\projects\atlasRegEdemaCorr\optimiceWarp\s20150909_FK_C2M10_1_3_1_1\wc3T2.nii'
        };

matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.template = {'V:\projects\atlasRegEdemaCorr\optimiceWarp\s20150909_FK_C2M10_1_3_1_1\_Atpl_mouseatlasNew_masked.nii'};
matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.weight = '';
matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.smosrc = 0.3;
matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.smoref = 0.2;
matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.regtype = 'subj';
matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.cutoff = 1;
matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.nits = 16;
matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.reg = 0.1;
matlabbatch{1}.spm.spatial.normalise.estwrite.roptions.preserve = 0;
matlabbatch{1}.spm.spatial.normalise.estwrite.roptions.bb = [-5.9252 -9.4889 -8.671
                                                             5.5466 6.5385 0.7027];
matlabbatch{1}.spm.spatial.normalise.estwrite.roptions.vox = [0.07 0.07 0.07];
matlabbatch{1}.spm.spatial.normalise.estwrite.roptions.interp = 1;
matlabbatch{1}.spm.spatial.normalise.estwrite.roptions.wrap = [0 0 0];
matlabbatch{1}.spm.spatial.normalise.estwrite.roptions.prefix = 'O';
    


 spm_jobman('run',  matlabbatch);




