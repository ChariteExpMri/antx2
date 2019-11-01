


pa='O:\harms1\harmsStaircaseTrial\dat\s20150506SM11_1_x_x'
t2=fullfile(pa,'t2.nii')
ov=fullfile(pa,'c1t2.nii')


ovlcontour({t2 ov},3,['1'],[.2 .2 0.2 0.2],[1 1 0],[1 1 4],'');

id='sss'
ovlcontour({t2 ov},3,['1'],[.2 .2 0.2 0.2],[1 .5 1],[1 .5 1],'id');
print(gcf,'-djpeg','-r300',fullfile(pwd, ['test1'    '.jpg']));


   [pathx s]=antpath
pa='O:\harms1\harmsStaircaseTrial\dat\s20150506SM11_1_x_x'
t2=fullfile(pa,'t2.nii')
ov=fullfile(pa,'c1t2.nii')


ovlcontour({t2 ov},3,['1'],[.2 .2 0.2 0.2],[1 1 0],[1 1 4],'');

id='sss'
ovlcontour({t2 ov},3,['1'],[.2 .2 0.2 0.2],[1 .5 1],[1 .5 1],'id');
print(gcf,'-djpeg','-r300',fullfile(pwd, ['test1'    '.jpg']));
