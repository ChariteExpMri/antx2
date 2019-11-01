

function deform(   files  ,direction,  resolution, interpx)


if exist('direction')~=1; direction=[]; end;
if isempty(direction); direction =1; end

if exist('resolution')~=1; resolution=[]; end;
if isempty(resolution); resolution =[.025 .025 .025]; end



if exist('interpx')~=1; interpx=[]; end;
if isempty(interpx); interpx =4; end

pathx=fileparts(files{1});


% bbox =  [-6 -9.5 -7
%     6 5.5 1];
% bbox =  [nan nan nan;nan nan nan];
% bbox =  [nan(2,3)];
  bbox = world_bb(files{1});

cnt = 1;
nr = 1;
if direction==1
    matlabbatch{cnt}.spm.util.defs.comp{1}.def = {fullfile(pathx,'y_forward.nii')};
elseif direction==-1
    matlabbatch{cnt}.spm.util.defs.comp{1}.def = {fullfile(pathx,'y_inverse.nii')};
end
%matlabbatch{cnt}.spm.util.defs.comp{2}.id.space = '<UNDEFINED>'; % For fMRI Files use fMRI-Scan resolution.
matlabbatch{cnt}.spm.util.defs.comp{2}.idbbvox.vox = resolution;
matlabbatch{cnt}.spm.util.defs.comp{2}.idbbvox.bb = bbox;
matlabbatch{cnt}.spm.util.defs.ofname = '';
matlabbatch{cnt}.spm.util.defs.fnames = files(1:end);
matlabbatch{cnt}.spm.util.defs.savedir.savesrc = 1;
matlabbatch{cnt}.spm.util.defs.interp =interpx;% 4;  default is 4 (spline4)
spm_jobman('serial',  matlabbatch);






% resolution =[.025 .025 .025]
% bbox =  [-6 -9.5 -7
%     6 5.5 1];
% cnt = 1;
% nr = 1;
% AMAfiles =..
% %    'C:\Users\skoch\Desktop\SPMmouseBerlin\mouse001\t2_1.nii,1'
% %     'C:\Users\skoch\Desktop\SPMmouseBerlin\mouse001\c1t2_1.nii,1'
% %     'C:\Users\skoch\Desktop\SPMmouseBerlin\mouse001\c2t2_1.nii,1'
% %     'C:\Users\skoch\Desktop\SPMmouseBerlin\mouse001\c1c2mask.nii,1'
% %
% matlabbatch{cnt}.spm.util.defs.comp{1}.def = {fullfile(t2destpath,'y_forward.nii')};
% %matlabbatch{cnt}.spm.util.defs.comp{2}.id.space = '<UNDEFINED>'; % For fMRI Files use fMRI-Scan resolution.
% matlabbatch{cnt}.spm.util.defs.comp{2}.idbbvox.vox = resolution;
% matlabbatch{cnt}.spm.util.defs.comp{2}.idbbvox.bb = bbox;
% matlabbatch{cnt}.spm.util.defs.ofname = '';
% matlabbatch{cnt}.spm.util.defs.fnames = AMAfiles(1:end);
% matlabbatch{cnt}.spm.util.defs.savedir.savesrc = 1;
% matlabbatch{cnt}.spm.util.defs.interp = 4;
% spm_jobman('serial',  matlabbatch);
