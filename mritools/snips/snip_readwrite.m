
fi0=fullfile(pwd,'ms20150908_FK_C1M02_1_3_1.nii')
fi1=fullfile(pwd,'c1s20150908_FK_C1M02_1_3_1.nii')
fi2=fullfile(pwd,'c2s20150908_FK_C1M02_1_3_1.nii')

h0=spm_vol(fi0);
h1=spm_vol(fi1);
h2=spm_vol(fi2);
d0=single(spm_read_vols(h0));
d1=single(spm_read_vols(h1));
d2=single(spm_read_vols(h2));

d1(d1>0.2)=1;
d2(d2>0.2)=1;
d3=d1+d2;

h3=h1;
h3.fname='c12_sum2.nii'
  h3=spm_create_vol(h3);
h3=spm_write_vol(h3,  d3);

d4=d3;
d4(d4>0)=1;


%% mask out
d0(d4==0)=0;

h4=h0;
h4.fname='tpl_ms.nii'
  h4=spm_create_vol(h4);
h4=spm_write_vol(h4,  d0);


return
%% sliceView-1
ls={'NS_Wnn_mrmNeAtMouseBrain_Atlas_23_highRes.nii' 'c1s20150908_FK_C1M02_1_3_1.nii'}
[bb, vx]  = world_bb(ls{2})
dim=2
slices=linspace(bb(1,dim),bb(2,dim),10)
 slices=1:.3:6
add=[];
add.transparency=.5  %overlay transparency
add.anatomicalImg=ls{1}
file=ls{2} %functional data
red=repmat([1 0 0],[64 1])
pslices(file,[],slices,'red','coronal',add)  %Inputs: show file|intern dynamicRange|MNI-slices|colorbar|sliceDefinition|additionals


%% sliceview2
ls={'NS_Wnn_mrmNeAtMouseBrain_Atlas_23_highRes.nii' 'c1s20150908_FK_C1M02_1_3_1.nii'}
% simpleoverlay(ls', [1:2:30], .1,{'g','m' } );

h1=spm_vol(ls{1});
h2=spm_vol(ls{2});
% The mat file contents are loaded by:
	MF = spm_get_space(ls{1});
	MG = spm_get_space(ls{2});
	
	% A rigid body mapping is derived by:
	MR = MF/MG; % or MR = MG/MF;
	
	% From this, a set of rotations and translations
	% can be obtained via:
	params = spm_imatrix(MR)
    

    dim=h1.dim;
     v =single(spm_read_vols(h2));
    
    g=[];
    for i=1:size()
    img = spm_slice_vol(v,MR,dim(1:2),1);
%      img = spm_slice_vol(V,M,dim(1:2),1);
    
    end
    
    

VI          = spm_vol(ls{1});
VO          = VI;
VO.fname    = deblank(PO);
VO.mat      = mat;
VO.dim(1:3) = dim;

VO = spm_create_image(VO); end;
for x3 = 1:VO.dim(3),
        M  = inv(spm_matrix([0 0 -x3 0 0 0 1 1 1])*inv(VO.mat)*VI.mat);
        v  = spm_slice_vol(VI,M,VO.dim(1:2),hld);
        VO = spm_write_plane(VO,v,x3);
end;




% 
% fi1=fullfile(pwd,'pgreyr62.nii')
% fi2=fullfile(pwd,'pwhiter62.nii')
% 
% 
% h1=spm_vol(fi1);
% h2=spm_vol(fi2);
% d1=single(spm_read_vols(h1));
% d2=single(spm_read_vols(h2));
% 
% d1(d1>0)=1;
% d2(d2>0)=1;
% d3=d1+d2;
% 
% h3=h1;
% h3.fname='pgraywhite_sum2.nii'
%   h3=spm_create_vol(h3);
% h3=spm_write_vol(h3,  d3);