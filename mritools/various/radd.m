

function filename2=radd(filename, str2add, tail)
%  filename2=radd(filename, str2add, tail)
%  add string (prefix/suffix) to filename
 %% IN
%  filename   ... filename
%  str2add    ... str to add
%  tail       ...[1/2]...prefix/suffix
%% OUT
% filename2
%% example
% filename2=radd('V:\mrm\msk_fNat.nii', 'W', 1)
% filename2=radd('V:\mrm\msk_fNat.nii', 'W', 2)



[pa2 fi2 ext2]=fileparts(filename);
if tail==1
    filename2=fullfile(pa2, [str2add fi2 ext2]);
else
    filename2=fullfile(pa2, [ fi2 str2add ext2]) ;
end