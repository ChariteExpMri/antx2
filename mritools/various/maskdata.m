

function [fileout h x ]=maskdata(file,cords,dimens,operation,assign, suffix )
%% mask data in file based given 3cooredinates, the dimension to mask, the operation and assignment
% file         = filename
% cords      =standard space coordinates, 3 values ,e.g [ 0 0  0]
% dimens   =dimension where operation and assignment is directed
% operation=(string) mathematical relation <,>,=>...~=,  
% assign      =value to be assigned , e.g 0
% suffix  = suffic to be assigned
% example: 
% maskData('_Atpl_mouseatlasNew_masked.nii',[0 0 0],1,'<',0, '_leftTest' ); 
%%explanation: %set mask on left hemisphere, 1..refers to first dimension,
%%values below 0 (first enty in cords) becomes zero





if 0
    cords=[0 0 0 ]
    operation='>'
    assign     =0;
    dimens   =1;
    suffix='_test'
end

% ha=spm_vol(file);
% a=(spm_read_vols(ha));
 [ha a xyz]=rgetnii(file );
xyz=xyz';
idx=round(mni2idx(cords, ha,'mni2idx'));

a2=a(:);

idx=[];
% idx2=find(xyz(:,dimens)>cords(dimens));
eval(['idx2=find(xyz(:,dimens)'  operation 'cords(dimens));' ]);
eval('a2(idx2)=assign;' );


ha3=ha;
a3=reshape(a2,  ha.dim);

fileout=strrep(file,'.nii',[suffix '.nii']);
rsavenii(fileout,ha3,a3 );







