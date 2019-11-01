

m=load('reorient.mat')

 %••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
% using GM+WM
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

 %% make mousemask
 [ha  a]=rgetnii(fullfile(pwd, 'c1t2.nii'));
  [hb b]=rgetnii(fullfile(pwd, 'c2t2.nii'));
 [hd d]=rgetnii(fullfile(pwd, 'c3t2.nii')); 
 c=a.*10000+b*20000+d*40000;
% c=a.*10000+b*20000;
mausGMWM=fullfile(pwd,'mouseGMWM.nii')
rsavenii(mausGMWM,ha,c,[16 0]); 

%   mausmask=fullfile(pwd,'mouseC2.nii')
%   copyfile(fullfile(pwd,'c2t2.nii'),mausmask,'f'  )
 %% reorient mousmask
%  vol = spm_vol(mausGMWM);
% spm_get_space(mausGMWM, inv(m.M) * vol.mat);
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
%%make template
 [ha  a]=rgetnii(fullfile(pwd, '_b1grey.nii'));
  [hb b]=rgetnii(fullfile(pwd, '_b2white.nii'));
    [hd d]=rgetnii(fullfile(pwd, '_b3csf.nii'));
% c=a.*10000+b*20000;
 c=a.*10000+b*20000+d*40000;
templateGMWM=fullfile(pwd,'templateGMWM.nii')
rsavenii(templateGMWM,ha,c,[16 0]); 

p1='V:\mritools\elastix\paramfiles\Par0025affine.txt'
p2='V:\mritools\elastix\paramfiles\Par0033bspline_EM2.txt'
pfiles={p1; p2}
fixIM    =templateGMWM   ;%fullfile(pwd, '_templatec1.nii')
movIM =mausGMWM

% fixIM    =fullfile(pwd,'sAVGT.nii')   ;%fullfile(pwd, '_templatec1.nii')
% movIM =fullfile(pwd,'t2.nii')  

outfold=fullfile(pwd,'out9'); mkdir(outfold)
% [im,trfile] = run_elastix(fixIM,movIM,outfold,pfiles,  [] ,[],[],[],[]);
 fun0=['!' which('elastix.exe')]
 out=[' -out '   outfold]
 ff      = [' -f '  fixIM ]
 mm   =[' -m '  movIM ]
pp      =[' -p '  p1  ' -p '  p2]
 do=[fun0 ff mm out pp ]
 eval(do)
 
 normIM=fullfile(pwd,'t2.nii')
 tp=[' -tp '  fullfile(outfold,'TransformParameters.1.txt') ]
 in=[' -in '   normIM ]
 fun=['!' which('transformix.exe')]
 do=[fun out  tp in ]
 eval(do)
 
%   normIM=fullfile(pwd,'c1t2.nii')
%  tp=[' -tp '  fullfile(outfold,'TransformParameters.1.txt') ]
%  in=[' -in '   normIM ]
%  fun=['!' which('transformix.exe')]
%  do=[fun out  tp in ]
%  eval(do)
 

%% inverse
% elastix -to outputdir/TransformParameters.1.txt -f fixedimage -m fixedimage -p inversionparameterfile.txt -out inversionoutdir

outfoldinv=fullfile(pwd,'outinv'); mkdir(outfoldinv)
 to=[' -to '  fullfile(outfold,'TransformParameters.1.txt') ]
 po=[' -p '  fullfile(outfold,'inversion.txt') ]
 do=[fun0  to [' -f '  fixIM ] [' -m '  fixIM ]  po  [' -out ' outfoldinv ] ]
 eval(do)



 
 
 