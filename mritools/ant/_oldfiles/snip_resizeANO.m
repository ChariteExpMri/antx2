


[pathx s]=antpath
voxres=[.07 .07 .07]

%% AVGT
fin=s.avg
[pa fi ext]=fileparts(fin)
fout=fullfile(pa, [ 's' fi  ext])
% --------
[bb vox]=world_bb(fin)
resize_img5(fin,fout, voxres, bb, [], 1,[]);   

%% ANO
fin=s.ano
[pa fi ext]=fileparts(fin)
fout=fullfile(pa, [ 's' fi  ext])
% --------
[bb vox]=world_bb(fin)
resize_img5(fin,fout, voxres, bb, [], 0,[]);   


%% FIBT
fin=s.fib
[pa fi ext]=fileparts(fin)
fout=fullfile(pa, [ 's' fi  ext])
% --------
[bb vox]=world_bb(fin)
resize_img5(fin,fout, voxres, bb, [], 0,[]);   