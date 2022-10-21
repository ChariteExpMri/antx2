
% save RGB-NIFTI image
% f3=fullfile(pwd,'RGB.nii')
% rsaveniiRGB(f3, hz, z);
% hz: handle from standard atlas
% z: data:  4-dim:  x,y,z,RGB  (example: 164 x  212  x 158  x   3)

function rsaveniiRGB(filename, hz, z)


% ==============================================
%%  make  struct
% ===============================================
si=hz.dim;
s2=[];
for i=1:3
    s.fname='ee';
    s.dim=[si ];
    s.dt=[16 0];
    s.mat=hz.mat;
    s.n=[i  1];
    if 0
        s.private.dat.fname='ee';
        s.private.dat.dim= [si 3];
        s.private.dat.dtype='FLOAT32-LE';
        s.private.dat.offset=352;
        s.private.dat.scl_slope= 1;
        s.private.dat.scl_inter= 0;
        
        s.private.mat =s.mat
        s.private.mat_intent= 'Scanner';
        s.private.mat0 =s.mat
        s.private.mat0_intent= 'Scanner';
        
        s.private.intent.code='RGB_VECTOR';
        s.private.intent.param=[];
        s.private.intent.name='';
        
        s.private.timing.toffset= 0;
        s.private.timing.tspace=  1;
        s.private.descrip= '5.0.10';
        s.private.cal= [-1 1];
    end
    if i==1
        s2=s;
    else
        s2(i)=s;
        
    end
end
rsavenii(filename,  s2,  z );
% ==============================================
%%   reload and change intent_code
% ===============================================
%% ----
% addpath('F:\data3\felix_180cases\plots_afterRandForest\NIIrgb')
% v=load_nii('_test4.nii')
% v=rmfield(v,'original')
[v, imgRGB] = nii_loadhdrimg(filename);
v.private.dime.intent_code=2003;
nii_savehdrimg(filename, v, imgRGB);
%% ----




