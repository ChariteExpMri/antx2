function filename=rchangeDatatype(file,dt,prefix)

% change datatype
% function filename=rchangeDatatype(file,dt,prefix)
%% example
% file  : file ,eg, 's20150908_FK_C1M01_1_3_1.nii'  
% dt    : dataType, e.g. =[16 0]
% prefix: prefix,eg. ='sd'
% filename=rchangeDatatype('s20150908_FK_C1M01_1_3_1.nii',[16 0],'sd')

[ha a]=rgetnii(file);

[pa fi ext]=fileparts(file);
filename=fullfile(pa ,[[prefix fi  ext]]);
ha.dt=dt;


rsavenii(filename,ha,a )