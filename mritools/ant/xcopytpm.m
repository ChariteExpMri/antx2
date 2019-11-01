
function [newtpm neof ]=xcopytpm(destpath, reftpm,vx, otherfiles2copy)
%% copy TPMs at a given vox-size resolution &  copy other files to destination path
%% IN
% destpath :        path of the destination, can be also the FullPathame of a file in the destination folder
% reftpm:           cell with FPnames of template TPMS
% vx:                   voxel size to resample [1x3] array;   e.g.[.07 .07 .07]
%                         if vx=[nan nan nan] than TPMs are just copied (orig resol.), no resizing necessary
%otherfiles2copy; additional single (string/cell) or multiple (cell) files to copy
%% OUT
% newtpm   : new FPname of copied tpms
% newof2c  : new FPname(s) of files bundled in 'otherfiles2copy'
%% EXAMPLES
% xcopytpm('V:\mritools\ant\test\s20150506SM13_1_x_x\t2.nii', r.refTPM,[.7 .7 .7])
% xcopytpm('V:\mritools\ant\test\s20150506SM13_1_x_x',           r.refTPM,[.07 .07 .07])
% xcopytpm('V:\mritools\ant\test\s20150506SM13_1_x_x',           r.refTPM,[nan nan nan])
%  [newtpm neof ]=xcopytpm(f1,   r.refTPM,[.1 .1 .1],r.refsample)
% [newtpm neof ]=xcopytpm(f1,   r.refTPM,[.1 .1 .1],r.refsample)

%% outputs
[newtpm neof ]=deal({});


%% get path
[pa fi ext]=fileparts(destpath);
if ~isempty(ext); destpath=pa; end


%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••


%% RESLICE TPM other resolution
if exist('reftpm','var')
    if ~isempty(reftpm) && ~isnumeric(reftpm)
        tpm= strrep(reftpm ,fileparts(reftpm{1}),destpath)  ;
        newtpm=tpm;
        for i=1:length(tpm)
            if any(isnan(vx)) %% if vx=[nan nan nan]-->just copy TPM
                copyfile(reftpm{i},tpm{i},'f');
            else
                [BB, vox]   = world_bb(reftpm{i});
                outfile=resize_img5(reftpm{i},tpm{i}, abs(vx), BB, [], 1,[]);
                
                rreslice2target(reftpm{i}, firef, tpm{i})
                
            end
        end
    end
end

%% copy other images
if exist('otherfiles2copy','var')
    if ~isempty(otherfiles2copy) && ~isnumeric(otherfiles2copy);
        if ischar(otherfiles2copy)
            otherfiles2copy={otherfiles2copy};
        end
        for i=1:length(otherfiles2copy)
            dum= strrep(otherfiles2copy{i} ,fileparts(otherfiles2copy{i}),destpath);
            copyfile(otherfiles2copy{i},dum,'f');
            neof{i}=dum;
        end
    end
end




%
% x=[]
% % x.t2path       ='C:\Users\skoch\Desktop\SPMmouseBerlin3\testmice\mouse001'
% % x.t2path       ='C:\Users\skoch\Desktop\SPMmouseBerlin3\testmice\mouse007'
% % x.t2path='C:\Users\skoch\Desktop\SPMmouseBerlin3\testmice\paulimport'
% % x.tpmpath   ='C:\Users\skoch\Desktop\SPMmouseBerlin3\templateBerlin_hres'
% %••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
% tpmorig=cfg_getfile('FPList',x.tpmpath,'^_b');
% t2           =fullfile(x.t2path, 't2_1.nii');
% pa           =x.t2path
% tpm= strrep(tpmorig ,fileparts(tpmorig{1}),x.t2path)  ;
% %••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
% %% copy templates
% % for i=1:length(tpm)
% %     copyfile(tpmorig{i},tpm{i},'f');
% % end
% %% RESLICE other resolution
% x.vox=[.07 .07 .07];
% for i=1:length(tpm)
%    [BB, vx]   = world_bb(tpmorig{i});
% outfile=resize_img5(tpmorig{i},tpm{i}, abs(x.vox), BB, [], 1,[]);
% end
% x.reference=fullfile(fileparts(tpm{1}),'reference.nii');
% outfile=resize_img5(tpmorig{1},x.reference, abs(x.vox), BB, [], 1,[]);%REF_IMAGE




