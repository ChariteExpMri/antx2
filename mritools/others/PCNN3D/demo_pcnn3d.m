
% C:\Users\skoch\Downloads\PCNN3D matlab\PCNN3D

clear
[ha a]=rgetnii('T2.nii');

% a=a./max(a(:));


brainSize=[100 550]
tic
vdim=abs(diag(ha.mat(1:3,1:3))')
[I_border, gi] = PCNN3D(  a , 4  , vdim, brainSize,50 )
toc

 gi(find(gi<brainSize(1) | gi>brainSize(2)))=nan  ;%set nan outside brainsize
id=  find(diff(gi)==nanmin(diff(gi))); %find plateau
id=min(id)

r=I_border{id}
% r=I_border{35}
for i=1:length(r)
    b=full(r{i});
    if i==1; x=zeros(size(a));end
    x(:,:,i)=b;
end


rsavenii('___test.nii',ha,x);

m=x.*a;
rsavenii('_msk',ha,m);