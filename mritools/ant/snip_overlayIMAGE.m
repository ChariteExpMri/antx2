

pa=pwd


 add=[];
  add.transparency=.2  %overlay transparency
  add.anatomicalImg=fullfile(pa,'w_t2.nii') %structural data
  add.anatomicalImg=fullfile(pa,'x_t2.nii') %structural data

  file=fullfile(pa,'GWC.nii') %structural data
  pslices(file,[],[-3:.5:-2],'jet','axial',add)  %Inputs: show file|intern dynamicRange|MNI-slices|colorbar|sliceDefinition|additionals
  
  
g=[...
    repmat( [ .5 .5 .5  ],  [8 1 ]  )
    repmat( [ 1 1 0 ],  [8 1 ]  )
    repmat( [ 1 0  0 ],  [8 1 ]  )
    repmat( [0 1 0 ],  [8 1 ]  )
    ]
  
  add.transparency=.1, pslices(file,[],[-6:.5:2],'g','coronal',add)

  
  f1=fullfile(pa,'w_t2.nii')
  f2=fullfile(pa,'GWC.nii')
  
  
ovlcontour({f1;fullfile(pwd,'ANO.nii')},2,['5 50'],[.08 0 0.05 0.05],[1 1 0],{jet .05  [0 500]}, 'R');
ovlcontour({f1;fullfile(pwd,'AVGT.nii')},2,['5 50'],[.08 0 0.05 0.05],[1 1 0],{jet .05  [0 500]}, 'R');
ovlcontour({f1;fullfile(pwd,'AVGT.nii')},2,['5 50'],[.08 0 0.05 0.05],[1 1 0],{jet .05  }, 'R');
ovlcontour({f1;fullfile(pwd,'AVGT.nii')},2,['5 50'],[.08 0 0.05 0.05],[1 1 0],{jet 1  }, 'R');
ovlcontour({f1;fullfile(pwd,'AVGT.nii')},2,['5 50'],[.08 0 0.05 0.05],[1 1 0],{jet .05  }, 'R');
ovlcontour({f1;fullfile(pwd,'AVGT.nii')},2,['5 50'],[.08 0 0.05 0.05],[1 1 0],{jet .5  }, 'R');
ovlcontour({f1;fullfile(pwd,'AVGT.nii')},2,['5 50'],[.08 0 0.05 0.05],[1 1 0],{jet .1  }, 'R');
ovlcontour({f1;fullfile(pwd,'ANO.nii')},2,['5 50'],[.08 0 0.05 0.05],[1 1 0],{jet .1  }, 'R');
ovlcontour({f1;fullfile(pwd,'ANO.nii')},2,['5 50'],[.08 0 0.05 0.05],[1 1 0],{jet .5  }, 'R');

cf
ovlcontour({f1;fullfile(pwd,'ANO.nii')},2,['5 50'],[.08 0 0.05 0.05],[1 1 0],{jet .5  [0 1000]}, 'R');
cf
ovlcontour({f1;fullfile(pwd,'ANO.nii')},2,['5 50'],[.08 0 0.05 0.05],[1 1 0],{jet .2  [0 1000]}, 'R');
ovlcontour({f1;fullfile(pwd,'ANO.nii')},2,['5 50'],[.08 0 0.05 0.05],[1 1 0],{jet .1  [0 1000]}, 'R');
ovlcontour({f1;fullfile(pwd,'ANO.nii')},2,['5 50'],[.08 0 0.05 0.05],[1 1 0],{jet .15  [0 1000]}, 'R');
colorcube
ovlcontour({f1;fullfile(pwd,'ANO.nii')},2,['5 50'],[.08 0 0.05 0.05],[1 1 0],{jet .15  [0 1000]}, 'R');
ovlcontour({f1;fullfile(pwd,'_b1grey.nii')},2,['5 50'],[.08 0 0.05 0.05],[1 1 0],{jet .15  [0 1000]}, 'R');
ovlcontour({f1;fullfile(pwd,'_b1grey.nii')},2,['5 50'],[.08 0 0.05 0.05],[1 1 0],{jet .1  [0 1000]}, 'R');
ovlcontour({f1;fullfile(pwd,'_b1grey.nii')},2,['5 50'],[.08 0 0.05 0.05],[1 1 0],{jet .05  [0 1000]}, 'R');

ovlcontour({f1;fullfile(pwd,'GWC.nii')},2,['5 50'],[.08 0 0.05 0.05],[1 1 0],{jet .1  }, 'R');
ovlcontour({f1;fullfile(pwd,'GWC.nii')},2,['5 50'],[.08 0 0.05 0.05],[1 1 0],{[] .1  }, 'R');
ovlcontour({f1;fullfile(pwd,'GWC.nii')},2,['5 50'],[.08 0 0.05 0.05],[1 1 0],{[] .5  }, 'R');
ovlcontour({f1;fullfile(pwd,'GWC.nii')},2,['5 50'],[.08 0 0.05 0.05],[1 1 0],{[] .3  }, 'R');
ovlcontour({f1e;fullfile(pwd,'GWC.nii')},2,['5 50'],[.08 0 0.05 0.05],[1 1 0],{[] .3  }, 'R');
ovlcontour({f1e;fullfile(pwd,'GWC.nii')},2,['5 50'],[.08 0 0.05 0.05],[1 1 0],{[] .3 [0 2] }, 'R');
cf
ovlcontour({f1e;fullfile(pwd,'GWC.nii')},2,['5 50'],[.08 0 0.05 0.05],[1 1 0],{[] .3 [1 2] }, 'R');
ovlcontour({f1e;fullfile(pwd,'GWC.nii')},2,['5 50'],[.08 0 0.05 0.05],[1 1 0],{[] .3 [0 1 ] }, 'R');
ovlcontour({f1e;fullfile(pwd,'GWC.nii')},2,['5 50'],[.08 0 0.05 0.05],[1 1 0],{[] .3 [1 2 ] }, 'R');
ovlcontour({f1e;fullfile(pwd,'GWC.nii')},2,['5 50'],[.08 0 0.05 0.05],[1 1 0],{[] .3 [2 3 ] }, 'R');




