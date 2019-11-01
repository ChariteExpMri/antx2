
ls={'NS3_Wnn2_mrmNeAtMouseBrain_Atlas_23_highRes.nii' 'ms20150908_FK_C1M02_1_3_1.nii'}'
ls={'ms20150908_FK_C1M02_1_3_1.nii' 'A2N_Wnn2_mrmNeAtMouseBrain_Atlas_23_highRes.nii'}'
f1=ls{1}
f2=ls{2}

% f1=fullfile(pwd,'con_0010.hdr')
% f2=fullfile(pwd,'avg152T1.img')

ct=cbrewer('qual', 'Paired', 32)
ct(1,:)=[0 0 0]

   add=[];
   add.transparency=.3  %overlay transparency
 add.anatomicalImg=f1
  pslices(f2,[],[-2:.3:6],'ct','coronal',add) ; %Inputs: show file|intern dynamicRange|MNI-slices|colorbar|sliceDefinition|additionals
  global SO
  SO.labels.format='%+3.1f'
  SO.labels.size=.2
 slice_overlay2('display')
 
  
  pslices(f1,[],[],'actc','coronal',add) ; %Inputs: show file|intern dynamicRange|MNI-slices|colorbar|sliceDefinition|additionals

  
  
  f1=f1
  f2=f2
     add=[];
    add.transparency=.5  %overlay transparency
    file='C:\Dokumente und Einstellungen\skoch\Desktop\test\swua_1.nii' %functional data
    pslices(f1,[],[-20:5:20],'actc','sagittal',add) ; %Inputs: show file|intern dynamicRange|MNI-slices|colorbar|sliceDefinition|additionals
    
    

  
  
% f1=fullfile(pwd,'con_0010.hdr')
% f2=fullfile(pwd,'avg152T1.img')

 
f0=fullfile(pwd,'c1s20150910_FK_C8M28_1_3_1.nii')
f1=fullfile(pwd,'c2s20150910_FK_C8M28_1_3_1.nii')
f2=fullfile(pwd,'s20150910_FK_C8M28_1_3_1.nii')


h1=spm_vol(f0);
d1=spm_read_vols(h1);

h2=spm_vol(f1);
d2=spm_read_vols(h2);

d1=d1/max(d1(:));
d2=d2/max(d2(:));

dx=(d1+d1)+d2;
%  dx=d1;
lim=0.1
d1(d1<lim)=0;
d2(d2<lim)=0;
% d1(d1>=lim)=1;
% d2(d2>=lim)=1;
dx=(d1+d1)+d2;

img.mat    =h1.mat;   %SPM-file:  hdr.mat    [53 63 46]
img.dim    =h1.dim;   %SPM-file:  hdr.dim    [4x4 double]
img.imgdata=dx;


c1=gray
c2=autumn
% cmap=[c1(33:end,:); c2(1:32,:)  ]
% cmap=[c1(33:end,:); flipud(c2(1:2:end,:))  ]
cmap=[c1(33:end,:); repmat([1 0 0],32,1)  ]


add=[];
add.transparency=.4 %overlay transparency
add.anatomicalImg=f2
pslices(img,[0 2],[-8:1:8],'cmap','axial',add) ; 
  
  
%   pslices(f1,[],[],'actc','sagittal',add) ; %Inputs: show file|intern dynamicRange|MNI-slices|colorbar|sliceDefinition|additionals

  
 