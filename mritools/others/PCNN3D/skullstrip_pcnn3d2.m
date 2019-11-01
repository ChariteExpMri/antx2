
function skullstrip_pcnn3d2(t2file, fileout,  mode   )


if 0
    skullstrip_pcnn3d2(fullfile(pa,'t2.nii'), fullfile(pa, '_test1.nii' ),  'skullstrip'   )
%      skullstrip_pcnn3d(fullfile(pwd,'t2_aa.nii'), fullfile(pwd, '_test1.nii' ),  'mask'   )
%     skullstrip_pcnn3d(fullfile(pwd,'t2_aa.nii'), fullfile(pwd, '_test2.nii' ),  'skullstrip'   )
end

warning off;

% tmpfile=fullfile(fileparts(t2file),'__temp4skullstrip.nii')
% copyfile(t2file,tmpfile,'f')
% spm_reslice(tmpfile)
 [bb vox]=world_bb(t2file);
% outfile=resize_img5(imname,outname, Voxdim, BB, ismask, interpmethod, dt)

% [ha a]=rgetnii('T2.nii');
[ha a]=         rgetnii(t2file);
brainSize=  [100 550];
niter        = 100;
radelem =4;

vdim=abs(vox);%abs(diag(ha.mat(1:3,1:3))');
 %[I_border, gi] = PCNN3D(  a , 4  , vdim, brainSize );
[args ,I_border, gi] =  evalc('PCNN3D(  a , radelem  , vdim, brainSize );');

disp(args);

%get Guess for best iteration.  
ix=strfind(args,'Guess for best iteration is ');
ix2=strfind(args,'.');
ank=ix2(min(find(ix2>ix)));
id=str2num(regexprep(args(ix:ank-1),'\D',''));
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

ss=[];
sv=[];
ad=[];
% for j=1:length(I_border)
for j=20:length(I_border)
    r=I_border{j};
    % r=I_border{35}
    for i=1:length(r)
        b=full(r{i});
        if i==1; x=zeros(size(a));end
        x(:,:,i)=b;
        ss(j,1)=sum(x(:));
        sv(j,i)=sum(b(:));
        ad(j,i)= (([sv(j,i)./sv(j-1,i)])-1)*100  ;%sv(j,i)-sv(j-1,i);
    end
%    fg,montage_p( x)
end

ss(:,2)=[0;diff(ss(:,1))]
ss(ss==0)=nan
best=find(ss(:,2)==min(ss(:,2)))

best=29
r=I_border{best};
% r=I_border{35}
for i=1:length(r)
    b=full(r{i});
    if i==1; x=zeros(size(a));end
    x(:,:,i)=b;
end
%  fg,montage_p( x)



[hc a]=rgetnii(t2file);

%  imoverlay2(a,x,[],[],hot,[.5],'',[]);;


 
%  return
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

if strcmp(mode, 'mask')
    m=x;
elseif strcmp(mode, 'skullstrip')
    m=x.*a;
end


% rsavenii('_msk',ha,m);
rsavenii(fileout,ha,m);

% close(gcf);


