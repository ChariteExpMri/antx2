


t1=fullfile(pa,'AVGT.nii');       [dum t1id]=fileparts(t1)
t2=fullfile(pa,'\vY1\x_t2.nii'); [dum t2id]=fileparts(fileparts(t2))
t3=fullfile(pa,'\wr1\x_t2.nii'); [dum t3id]=fileparts(fileparts(t3))

w1=t1
w2=t2
s1=t1id
s2=t2id
h1=ovlcontour({w1},2,['5 50'],[.08 0 0.05 0.05],[1 1 0],{jet .1  []}, s1);
h2=ovlcontour({w2},2,['5 50'],[.08 0 0.05 0.05],[1 1 0],{jet .1  []}, s2);
gifoverlay2([h1 h2],fullfile(pwd,[ s1 '___'  s2   ]) ,300 )

 w1=t1
w2=t3
s1=t1id
s2=t3id
h1=ovlcontour({w1},2,['5 50'],[.08 0 0.05 0.05],[1 1 0],{jet .1  []}, s1);
h2=ovlcontour({w2},2,['5 50'],[.08 0 0.05 0.05],[1 1 0],{jet .1  []}, s2);
gifoverlay2([h1 h2],fullfile(pwd,[ s1 '___'  s2   ]) ,300 )


 w1=t2
w2=t3
s1=t2id
s2=t3id
h1=ovlcontour({w1},2,['5 50'],[.08 0 0.05 0.05],[1 1 0],{jet .1  []}, s1);
h2=ovlcontour({w2},2,['5 50'],[.08 0 0.05 0.05],[1 1 0],{jet .1  []}, s2);
gifoverlay2([h1 h2],fullfile(pwd,[ s1 '___'  s2   ]) ,300 )