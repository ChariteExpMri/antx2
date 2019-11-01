%% SEGMENT MOUSE
% function xsegment(t2,template)
% function xsegment(t2,template,job)...see below
% function xsegment(t2,template,'segment') %% SEGMENT ONLY without using Freiburg-normalization 
%% INPUT: 
% t2 :          FPfile of t2.nii
% template: {cell} with ordered TPMs(GM,WM,CSF)+FPfile of reorient.mat
%% EXAMPLE
% t2='O:\harms1\koeln\dat\s20150701_BB1\t2.nii';
% template={         'O:\harms1\koeln\dat\s20150701_BB1\_b1grey.nii'
%                             'O:\harms1\koeln\dat\s20150701_BB1\_b2white.nii'
%                             'O:\harms1\koeln\dat\s20150701_BB1\_b3csf.nii'
%                             'O:\harms1\koeln\dat\s20150701_BB1\reorient.mat'}
% xsegment(t2,template)

function xsegment(t2,template,job)

t2destpath=fileparts(t2);


% b0only = 0;
% if exist(fullfile(mouse.outfolder, 't2_1.nii'),'file')
%     options(4) = 4;
% else
%     options = 0;
% end



% Preparing path names
% t2path = mouse.t2;
% t2destpath = mouse.outfolder;
% t2nii = cell(length(t2path));
% for k = 1:length(t2path),
%     t2fullname = fullfile(t2destpath,['t2_' num2str(k)]);
%     t2nii{k} = [t2fullname '.nii,1'];
% end

% Start of segmentation with t2.nii
% If t2.nii does not exist use b0.nii
cnt = 1;

%     if exist(fullfile(mouse.outfolder, 't2_1.nii'),'file') == 2 && b0only == 0
        matlabbatch{cnt}.spm.spatial.preproc.data = {t2}  ;%{t2nii{1}}; %% T2file
        matlabbatch{cnt}.spm.spatial.preproc.opts.warpreg = 1; % Original 1 (funzt okay: 50)
        matlabbatch{cnt}.spm.spatial.preproc.opts.warpco = 1.75; % Original 1.75 (funzt okay: 2.5)
%     else
% %         matlabbatch{cnt}.spm.spatial.preproc.data = {fullfile(t2destpath,'b0.nii')};
% %         matlabbatch{cnt}.spm.spatial.preproc.opts.warpreg = 1; % Original 1 (funzt okay: 50)
% %         matlabbatch{cnt}.spm.spatial.preproc.opts.warpco = 1.75; % Original 1.75 (funzt okay: 2.5)
%     end;
    matlabbatch{cnt}.spm.spatial.preproc.output.GM = [0 0 0 1];
    matlabbatch{cnt}.spm.spatial.preproc.output.WM = [0 0  0 1];
    matlabbatch{cnt}.spm.spatial.preproc.output.CSF = [0 0 0 1];
  matlabbatch{cnt}.spm.spatial.preproc.output.SK = [0 0 0 1];
    matlabbatch{cnt}.spm.spatial.preproc.output.biascor = 1;
    matlabbatch{cnt}.spm.spatial.preproc.output.cleanup = 0;
    matlabbatch{cnt}.spm.spatial.preproc.opts.tpm = template; % Define Templates here
    matlabbatch{cnt}.spm.spatial.preproc.opts.ngaus = [3
        2
        2
        4];
    matlabbatch{cnt}.spm.spatial.preproc.opts.regtype = 'animal'; % 'animal' / '';
    matlabbatch{cnt}.spm.spatial.preproc.opts.biasreg = 0.0001;
    matlabbatch{cnt}.spm.spatial.preproc.opts.biasfwhm = 5;
    matlabbatch{cnt}.spm.spatial.preproc.opts.samp = 0.1;
    matlabbatch{cnt}.spm.spatial.preproc.opts.msk = {''};

    
cnt = cnt + 1;

%     if exist(fullfile(mouse.outfolder, 't2_1.nii'),'file') && b0only == 0
 matlabbatch{cnt}.spm.util.imcalc.input =  {
                                            fullfile(t2destpath,'c1t2.nii')
                                            fullfile(t2destpath,'c2t2.nii')
                                            };

%     matlabbatch{cnt}.spm.util.imcalc.input =  {
%                                             fullfile(t2destpath,'c1t2_1.nii,1')
%                                             fullfile(t2destpath,'c2t2_1.nii,1')
%                                             };
%     else
%     matlabbatch{cnt}.spm.util.imcalc.input =  {
%                                             fullfile(t2destpath,'c1b0.nii,1')
%                                             fullfile(t2destpath,'c2b0.nii,1')
%                                             };
%     end
    matlabbatch{cnt}.spm.util.imcalc.output = 'c1c2mask.nii';
    matlabbatch{cnt}.spm.util.imcalc.outdir = { t2destpath };
    matlabbatch{cnt}.spm.util.imcalc.expression = '((i1 + i2)/2)>0.3';
    matlabbatch{cnt}.spm.util.imcalc.options.dmtx = 0;
    matlabbatch{cnt}.spm.util.imcalc.options.mask = 0;
    matlabbatch{cnt}.spm.util.imcalc.options.interp = 1;
    matlabbatch{cnt}.spm.util.imcalc.options.dtype = 4;
cnt = cnt + 1;


%% SEGMENT ONLY
if exist('job') && strcmp(job,'segment')
    spm_jobman('serial',  matlabbatch);
   return
end
    
 

% Convert Deformation Parameters
% Convert deformation parameters to iy/y format (forward)

% if any(options == 4)
    matlabbatch{cnt}.spm.util.defs.comp{1}.sn2def.matname = {fullfile(t2destpath,'t2_seg_sn.mat')};

%     matlabbatch{cnt}.spm.util.defs.comp{1}.sn2def.matname = {fullfile(t2destpath,'t2_1_seg_sn.mat')};
% else
%     matlabbatch{cnt}.spm.util.defs.comp{1}.sn2def.matname = {fullfile(t2destpath,'b0_seg_sn.mat')};
% end
    matlabbatch{cnt}.spm.util.defs.comp{1}.sn2def.vox = [NaN NaN NaN];
    matlabbatch{cnt}.spm.util.defs.comp{1}.sn2def.bb = [NaN NaN NaN
                                                        NaN NaN NaN];
    matlabbatch{cnt}.spm.util.defs.ofname = 'forward';
    matlabbatch{cnt}.spm.util.defs.fnames = '';
    matlabbatch{cnt}.spm.util.defs.savedir.savedef = 1;
    matlabbatch{cnt}.spm.util.defs.interp = 4;
    cnt = cnt + 1;

% Convert deformation parameters to iy/y format (inverse)
% if any(options == 4)
    matlabbatch{cnt}.spm.util.defs.comp{1}.sn2def.matname = {fullfile(t2destpath,'t2_seg_inv_sn.mat')};
%     matlabbatch{cnt}.spm.util.defs.comp{1}.sn2def.matname = {fullfile(t2destpath,'t2_1_seg_inv_sn.mat')};
% else
%     matlabbatch{cnt}.spm.util.defs.comp{1}.sn2def.matname = {fullfile(t2destpath,'b0_seg_inv_sn.mat')};
% end
    matlabbatch{cnt}.spm.util.defs.comp{1}.sn2def.vox = [NaN NaN NaN];
    matlabbatch{cnt}.spm.util.defs.comp{1}.sn2def.bb = [NaN NaN NaN
                                                      NaN NaN NaN];
    matlabbatch{cnt}.spm.util.defs.ofname = 'inverse';
    matlabbatch{cnt}.spm.util.defs.fnames = {''};
    matlabbatch{cnt}.spm.util.defs.savedir.savedef = 1;
    matlabbatch{cnt}.spm.util.defs.interp = 4;
    
% Realign deformations to original template space
cnt = cnt + 1;
    matlabbatch{cnt}.dtijobs.realigndef.yname = {fullfile(t2destpath,'y_forward.nii')};
    matlabbatch{cnt}.dtijobs.realigndef.iyname = {fullfile(t2destpath,'y_inverse.nii')};
    matlabbatch{cnt}.dtijobs.realigndef.matname =  template(end);%template(4);
    
%     return
    spm_jobman('serial',  matlabbatch);
    
    
    
    
    
    
    
    