function  [h,d ]=rreslice2target(fi2merge, firef, fi2save, interpx,dt)
% reslice image to target
% [h,d ]=rreslice2target(fi2merge, firef, fi2save, interpx,dt)
% [h,d ]=rreslice2target(fi2merge, firef, fi2save)
% if [fi2save] is empty/not existing..parse to workspace
% 
%% INPUT
% fi2merge: orignal image
%                 'string': fullpath-NIFTI name
%                 'cell'  : containing the header and the image-array, order in cell doesn't matter
% firef   : reference image, either as
%                 'string': fullpath-NIFTI name
%                 'cell'  : containing the header
%                 'struct': the header
% fi2save : optional, fullpath name to save the new file, otherwise empty([])
%              -if fi2save is empty ([]); mew NIFTI is not stored ...instead use function's output (hd,d)
% interpx : optional, interpolation: [0] NN, [1] lninear interpolation, default: [1] if empty ([])
% dt      : optional; dataType to save the file 
% 
%% OUTPUT (optional)
% h: new header
% d: new image-array 
% 
%% EXAMPLES
%% save to disk, NN-intepr, 16 bit
% rreslice2target({hb b},{ha a}, fullfile(pwd,'test.nii'), 0, 16);
%% pass outputs only, NN-interpolation
% [h,d ]=rreslice2target({hb b},{ha},[],0);
%% via filenames
% fsmall=fullfile('F:\data5_histo\markus_Coregistrierung_2025_05_02\dat\Tet2_m006_B_3_1_DAPI\AVGT4plotting.nii')
% fbig=fullfile(ak.template,'AVGT.nii')
% [h,d ]=rreslice2target(fbig,fsmall,[],0);
%% via hdr and array
% fsmall=fullfile('F:\data5_histo\markus_Coregistrierung_2025_05_02\dat\Tet2_m006_B_3_1_DAPI\AVGT4plotting.nii')
% fbig=fullfile(ak.template,'AVGT.nii')
% [ha a ]=rgetnii(fsmall);
% [hb b ]=rgetnii(fbig);
% rreslice2target({hb b},{ha a}, fullfile(pwd,'test.nii'), 0, 16);
% or
% [h,d ]=rreslice2target({hb b},fsmall, [], 0, 16);
% [h,d ]=rreslice2target({b hb},fsmall, [], 0, 16);
% [h,d ]=rreslice2target(fbig,ha, [], 0, 16);
% [h,d ]=rreslice2target(fbig,{ha a}, [], 0, 16);
% [h,d ]=rreslice2target(fbig,{a ha}, [], 0, 16);

if ~exist('interpx')
    interpx=1;
end

if iscell(fi2merge)
    ihdr   =find(cellfun(@(a)[isstruct(a)  ], fi2merge));
    inhdr =fi2merge{ihdr };
    inimg =fi2merge{min(setdiff(1:length(fi2merge),ihdr))};
else
    [inhdr, inimg]=rgetnii(fi2merge);
end

if iscell(firef)
    ihdr   =find(cellfun(@(a)[isstruct(a)  ], firef));
    tarhdr =firef{ihdr};
elseif isstruct(firef) 
     tarhdr =firef;
else
    [tarhdr]=rgetnii(firef);
end
[h, d] = nii_reslice_target(inhdr, inimg, tarhdr, interpx) ;


if exist('fi2save')
    if ~isempty(fi2save)
        if exist('dt')~=1
            try; delete(fi2save); end
            rsavenii(fi2save,h,d);
        else
             %h=rmfield(h,'pinfo'); %remove pinfo-field to change dt (works also  for 4d)
             %h=rmfield(h,'private'); %remove pinfo-field to change dt (works also  for 4d)
             try; delete(fi2save); end
            rsavenii(fi2save,h,d,dt);
        end
    end
    
end