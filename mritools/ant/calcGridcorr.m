



function param=calcGridcorr(fi1,fi2)

%input: filepath or 3d volume

if ischar(fi1)
[ha a]=rgetnii(fi1);
else
    a=fi1;
end

if ischar(fi2)
[hb b]=rreslice2target(fi2, fi1, [], 1);%rgetnii(fi2);rgetnii(fi2);
else
    b=fi2;
end

%% no nan
a(isnan(a))=0;
b(isnan(b))=0;

aa=permute(a,[1 3 2]);
bb=permute(b,[1 3 2]);


aa(aa<.01)=0;

% aa=aa-min(aa(:)); aa=255*(aa./max(aa(:)));
% bb=bb-min(bb(:)); bb=255*(bb./max(bb(:)));

nele=zeros(size(aa,3),2);
for i=1:size(aa,3)
    nele(i,:)=[ length(unique(aa(:,:,i)))     length(unique(bb(:,:,i)))   ];
end
nslice=find(nele(:,1)>5 & nele(:,2)>5);

nslice=120:150;%# predefined

% zz=zeros(size(aa,3),3);
zz=zeros(length(nslice),3);
n=1;
for i=1:length(nslice)
    [xmed xsum xme]=corrgrid(aa(:,:,nslice(i)),bb(:,:,nslice(i)), 5:20,0);
    zz(n,:)=[xmed xsum xme];
    n=n+1;
end
param=nanmean(zz);
