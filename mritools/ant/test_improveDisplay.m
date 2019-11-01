

voxres=[0.0700    0.0700    0.0700 ]
pa='O:\harms1\harmsStaircaseTrial\dat\s20150506SM11_1_x_x\'
cd(pa)

t2=fullfile(pa,'t2.nii')
g=fullfile(pa,'_refIMG.nii')


xnormalize(t2, voxres ,1);

% displaykey2(g,t2,0); %orig
displaykey2(t2,g,0); %shoenso


displaykey3inv(g,t2,0); %shoenso
