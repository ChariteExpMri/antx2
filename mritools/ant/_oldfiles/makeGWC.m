


clear

pas=pwd
anofile=fullfile(pas,'ANO.nii')
fibfile=fullfile(pas,'FIBT.nii')

[ha a xyz XYZ]=         rgetnii(anofile);
[hb b]             =         rgetnii(fibfile);

a2=a;
a2(a2~=8 & a2~=0)=1;
a2(a2==8)=0;
b(b~=0)=1;
c=a2+b;

% rsavenii('test.nii',ha,c);

%----------------------
si=size(a)
c=single(a==8 & b==0);
% rsavenii('testCSF.nii',ha,c)

c2=single(c(:));
idx=find(c2==1);
s=spm_clusters3(XYZ(:,idx)  );

st=tabulate(s);
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
c4(c4>0)=1;

d=a2+b+c4;
% rsavenii('test_1.nii',ha,a2)
% rsavenii('test_2.nii',ha,b)
% rsavenii('test_3.nii',ha,c4)

dum=a2+(b*2);  
dum(dum==3)=2;%replace 3...
dum=dum+(c4*3);
rsavenii(fullfile(pas, 'GWC.nii' ),ha,   dum ,[2 0])
















