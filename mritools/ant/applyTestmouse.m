
clear; close all
x=[]
% x.t2path       ='C:\Users\skoch\Desktop\SPMmouseBerlin3\testmice\mouse001'
% x.t2path       ='C:\Users\skoch\Desktop\SPMmouseBerlin3\testmice\mouse007'
x.t2path='C:\Users\skoch\Desktop\SPMmouseBerlin3\testmice\paulimport'
x.tpmpath   ='C:\Users\skoch\Desktop\SPMmouseBerlin3\templateBerlin_hres'
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
tpmorig=cfg_getfile('FPList',x.tpmpath,'^_b');
t2           =fullfile(x.t2path, 't2_1.nii');
pa           =x.t2path 
tpm= strrep(tpmorig ,fileparts(tpmorig{1}),x.t2path)  ;
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
%% copy templates
% for i=1:length(tpm)
%     copyfile(tpmorig{i},tpm{i},'f');
% end
%% RESLICE other resolution
x.vox=[.07 .07 .07];
for i=1:length(tpm)
   [BB, vx]   = world_bb(tpmorig{i});
outfile=resize_img5(tpmorig{i},tpm{i}, abs(x.vox), BB, [], 1,[]);
end
x.reference=fullfile(fileparts(tpm{1}),'reference.nii');
outfile=resize_img5(tpmorig{1},x.reference, abs(x.vox), BB, [], 1,[]);%REF_IMAGE


%% reorient image
%% FBtool [-pi/2 pi 0]
%% BERLIN [ PI/2 PI PI]

% preorient=[0 0 0 -pi/2 pi 0];%FB
preorient=[0 0 0 pi/2 pi pi];%BE
Bvec=[ [preorient]  1 1 1 0 0 0];  %wenig slices
fsetorigin(tpm, Bvec);  %ANA

%% autoNcoregister
predef=[ [[0 0 0   0 0 0 ]]  1 1 1 0 0 0];
reorient=autoregister(tpm{1} , t2 , predef);
%% reorient TPMS
for i=1:length(tpm)
    mfvol=spm_vol(tpm{i});
    spm_get_space(tpm{i}, reorient * mfvol.mat);
end
%% retrieve & save orient MAT
v1 =  spm_vol(x.reference);
% v2 =  spm_vol('_test333FIN.nii');;
v2=   spm_vol(tpm{1});%
M =  v2.mat/v1.mat;
% M=diag([1 1 1 1]);
save(fullfile(pa,'reorient.mat'),'M')

 

%% SEGMENT
% t2=ref; %ORIGH AVGT (517s to segment)
%      t2=refsmall;
% t2file=fullfile(pwd,  't2_1.nii');
% copyfile(t2,t2file,'f');

template= [tpm; fullfile(pa, 'reorient.mat')]

mouse.outfolder=pa ;%'O:\harms1\harmsStaircaseTrial\pvraw\results\mouse057'
mouse.DTI= '';
mouse.t2=t2;
mouse.FcFLASH= {''};
mouse.rsfMRI= {};

loadspmmouse
tic
AMA_segmentation(mouse,template); %(t=300s f)
toc

%% warp images


testdeform(   {x.reference} , -1,  [.07 .07 .07], [])

 testdeform(   {t2}  ,1,  [.07 .07 .07], [])

return
 
 
testdeform(   {x.reference} , 1,  [.07 .07 .07], [])

 testdeform(   {t2}  ,-1,  [.07 .07 .07], [])
% 
%  return
 
 
 
