function fsetorigin(files, Bvec)

%% set fsetorigin/[0,0,0]-punct
% function fsetorigin(files, Bvec)
% files: cell with files or string for single file
% Bvec: vec with trans,rot,voxsize,...
%% example
% filesx = {
%     'V:\harmsSC\nii\s20150908_FK_C1M01_1_3_1\pmouseatlas.nii'
%     'V:\harmsSC\nii\s20150908_FK_C1M01_1_3_1\pgreyr62.nii'
%     'V:\harmsSC\nii\s20150908_FK_C1M01_1_3_1\pwhiter62.nii'
%     'V:\harmsSC\nii\s20150908_FK_C1M01_1_3_1\pcsfr62.nii'};
% Bvec=[0.2 -4.1 2 0 0 0 1 1 1 0 0 0];
% fsetorigin(filesx, Bvec);


%% single file
if ischar(files)
    files=cellstr(files);
end

P=files ;%
B=Bvec  ;%[0.2 -4.1 2 0 0 0 1 1 1 0 0 0]
%% copied from  spm_image('reorient')
% st.B  % aus der gui-->now "B"
% [0.2 -4.1 2 0 0 0 1 1 1 0 0 0]
% 
% mat = spm_matrix(st.B)
% 
% 
%     1.0000         0         0    0.2000
%          0    1.0000         0   -4.1000
%          0         0    1.0000    2.0000
%          0         0         0    1.0000


%   mat = spm_matrix(st.B);
  mat = spm_matrix(B);

%     if det(mat)<=0
%         spm('alert!','This will flip the images',mfilename,0,1);
%     end
%     [P, sts] = spm_select([1 Inf], 'image','Images to reorient');
%     if ~sts, return; else P = cellstr(P); end
    
    
    
    
    Mats = zeros(4,4,numel(P));
%     spm_progress_bar('Init',numel(P),'Reading current orientations',...
%         'Images Complete');
    for i=1:numel(P)
        Mats(:,:,i) = spm_get_space(P{i});
        spm_progress_bar('Set',i);
    end
%     spm_progress_bar('Init',numel(P),'Reorienting images',...
%         'Images Complete');
    for i=1:numel(P)
        spm_get_space(P{i},mat*Mats(:,:,i));
        spm_progress_bar('Set',i);
    end
%     spm_progress_bar('Clear');