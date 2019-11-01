
cf;clear

% t2=fullfile('V:\mritools\ant\test\s20150506SM13_1_x_x', 't2.nii')
% t2='V:\mritools\ant\test\s20150506SM14_1_x_x/t2.nii'
t2='O:\harms1\harmsStaircaseTrial\dat\s20150505SM01_1_x_x\t2.nii'
x.voxres=[.07 .07  .07 ]


%=========================================================
%% INIT 
[pant r]=antpath
pa=fileparts(t2);

%=========================================================
 
start=tic

%=========================================================
%% COPY TPMS
 [tpm newotherfiles ]=xcopytpm(t2,   r.refTPM, x.voxres,   r.refsample   );%% COPY FILES

 %reference image
  [BB, voxref]   = world_bb(r.refTPM{1});
 refIMG=fullfile(fileparts(tpm{1}),'_refIMG.nii');
outfile=resize_img5( r.refTPM{1},refIMG, abs(x.voxres), BB, [], 1,[]);%REF_IMAGE
 
%=========================================================
 %%  reorient image                       ( FBtool [-pi/2 pi 0]   |    BERLIN [ PI/2 PI PI])
%% 3 STEPS

%% STEP-1  : FIND ROTATION 
parafile=fullfile(pant,'paraaffine4rots.txt');
[rot id trafo]=findrotation(r.refsample ,t2 ,parafile, 1,1);
preorient=trafo;
% preorient=[0 0 0 -pi/2 pi 0];%Freiburg 
% preorient=[0 0 0 pi/2 pi pi];%BErlin to ALLEN
Bvec=[ [preorient]  1 1 1 0 0 0];  %wenig slices
fsetorigin(tpm, Bvec);  %ANA



%% STEP-2+3  :  autocoregister+COREG
predef=[ [[0 0 0   0 0 0 ]]  1 1 1 0 0 0];
reorient=autoregister(tpm{1} , t2 , predef);
%% reorient TPMS
for i=1:length(tpm)
    mfvol=spm_vol(tpm{i});
    spm_get_space(tpm{i}, reorient * mfvol.mat);
end

%% retrieve & save orient MAT
v1 =  spm_vol(refIMG);
% v2 =  spm_vol('_test333FIN.nii');;
v2=   spm_vol(tpm{1});%
M =  v2.mat/v1.mat;
% M=diag([1 1 1 1]);
save(fullfile(pa,'reorient.mat'),'M');
 
 
 %%=========================================
%% WARP+SEGMENT

template= [tpm; fullfile(pa, 'reorient.mat')]
mouse.outfolder=pa ;%'O:\harms1\harmsStaircaseTrial\pvraw\results\mouse057'
mouse.DTI= '';                      mouse.t2=t2;
mouse.FcFLASH= {''};           mouse.rsfMRI= {};


spm fmri;drawnow;
loadspmmouse;drawnow;
tic
% AMA_segmentation(mouse,template); %(t=300s f)
xsegment(t2,template); %(t=300s f)

toc

%% warp other images
xdeform(   {refIMG} , -1,  [.07 .07 .07], [])

 xdeform(   {t2}  ,1,  [.07 .07 .07], [])


 
 toc(start)














