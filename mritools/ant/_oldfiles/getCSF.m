

%% get CSF based on label8

[ha a xyz XYZ]=rgetnii('ANO.nii');
[hb b]=rgetnii('FIBT.nii');

si=size(a)
c=single(a==8 & b==0);
rsavenii('testCSF.nii',ha,c)

c2=single(c(:));
idx=find(c2==1);
s=spm_clusters3(XYZ(:,idx)  );

st=tabulate(s)
st=flipud(sortrows(st,2))

num2code=6
s2=single(zeros(length(s),1));
for i=1:num2code
    id=st(i,1);
    inum=find(s==id);
    s2(inum)=i;
end

c3=zeros(size(c2));
c3(idx)=s2;

c4=reshape(c3,si);

rsavenii('testCSFcluster.nii',ha,c4)


