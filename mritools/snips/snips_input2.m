function snips_input2

snips
return


%% #################################################
% VOXELWISE-STATISTIC
% PART-1: transform images to standard-space-->THOSE IMAGES WILL BE COMPARED

%% ==============================================
%%   prep voxstat
%% ===============================================
cf;clear
 
antcb('selectdirs','all'); %seleact all animals
%% ==============================================
%%  [1] trafo images to standard space
%% ==============================================
fi2trafo={...
    'c1t2.nii'
    'c2t2.nii'
    'fa.nii'
    'rd.nii'
    'ad.nii'
    'adc.nii'};
 
fis=doelastix(1, [],fi2trafo,1,'local');
img_ss=stradd(fi2trafo,['x_'],1); %images in standardSpace
 
%% ==============================================
%%   multiplay/divide JD with GM
%% ===============================================
z.files={ ...
    'JD.nii'    'JD_gmMult.nii'  'mo: o=i1.*i;'
    'x_c1t2.nii'    ''           'i1' };
xrename(0,z.files(:,1),z.files(:,2),z.files(:,3) );
 
z.files={ ...
    'JD.nii'    'JD_gmDiv.nii'  'mo: o=i1./i;'
    'x_c1t2.nii'    ''           'i1' };
xrename(0,z.files(:,1),z.files(:,2),z.files(:,3) );



