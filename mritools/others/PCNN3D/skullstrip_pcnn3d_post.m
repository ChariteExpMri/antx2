
% skullstrip t2w-image, volume-estimation from c1+c2-compartments-mask is used to improve skullstripping.
%
% function skullstrip_pcnn3d_post(t2file, fileout,  mode , thresh,tolperc)
% SEGMENTATION AS TO BE DONE BEFORE
% INPUT:
% t2file : t2w.nii or segmented mt.nii volume
% fileout: name of the output volume
% mode   : output modus: 'mask' or 'skullstrip' to generate mask or skulstripped volume
% thresh : threshold of tissue compartments: (e.g. 0.1)
% tolperc: percent tolerance added to the compartment-volumes  
% 
% EXAMPLE:
% t2file  =fullfile('O:\data2\minoryx\dat\M3c','mt2.nii')
% fileout =fullfile('O:\data2\minoryx\dat\M3c','_mask.nii')
% mode    = 'mask';%'skullstrip'
% thresh =0.1; %compartment threshold
% tolperc =5 ;%5percent
% skullstrip_pcnn3d_post(t2file, fileout,  mode , thresh,tolperc);

function skullstrip_pcnn3d_post(t2file, fileout,  mode , thresh,tolperc)


% if 0
%     t2file  =fullfile('O:\data2\minoryx\dat\M3c','mt2.nii')
%     fileout =fullfile('O:\data2\minoryx\dat\M3c','_mask.nii')
%     mode    = 'mask';%'skullstrip'
%     thresh =0.1; %compartment threshold
%     tolperc =5 ;%5percent
%     skullstrip_pcnn3d_post(t2file, fileout,  mode , thresh,tolperc);
% end

%———————————————————————————————————————————————
%%   get volume from compartments
%———————————————————————————————————————————————
pa=fileparts(t2file);
c1=fullfile(pa,'c1t2.nii');
c2=fullfile(pa,'c2t2.nii');

[hc c]=         rgetnii(c1);
[hd d]=         rgetnii(c2);

dd=( ((c>thresh)+(d>thresh) )>0 );

de=dd;
for i=1:size(de,3)
  de(:,:,i)= imfill(de(:,:,i),'holes') ;
end
vol=abs(det(hc.mat(1:3,1:3)) *(sum(de(:))));

volmax=round(  vol+(vol*tolperc/100)  );





%———————————————————————————————————————————————
%%  use skullstripping algorithm
%———————————————————————————————————————————————



warning off;
[bb vox]  = world_bb(t2file);
[ha a]    = rgetnii(t2file);
brainSize = [100 550]; %B6-

niter   = 200;
radelem = 4;
vdim    = abs(vox);%abs(diag(ha.mat(1:3,1:3))');
 %[I_border, gi] = PCNN3D(  a , 4  , vdim, brainSize );
[args ,I_border, gi] =  evalc('PCNN3D(  a , radelem  , vdim, brainSize,niter );');
close(gcf);
% disp(args);
%get Guess for best iteration.  
% ix=strfind(args,'Guess for best iteration is ');
% ix2=strfind(args,'.');
% ank=ix2(min(find(ix2>ix)));
% id=str2num(regexprep(args(ix:ank-1),'\D',''));


%———————————————————————————————————————————————
%%   get matching volume (compared to compartment-mask)
%———————————————————————————————————————————————

id=max(find(gi<volmax & gi>0));
if length(I_border)<id
    %get Guess for best iteration.
    ix=strfind(args,'Guess for best iteration is ');
    ix2=strfind(args,'.');
    ank=ix2(min(find(ix2>ix)));
    id=str2num(regexprep(args(ix:ank-1),'\D',''));
end
r=I_border{id};


% r=I_border{35}
for i=1:length(r)
    b=full(r{i});
    if i==1; x=zeros(size(a));end
    x(:,:,i)=b;
end

if strcmp(mode, 'mask')
    m=x;
elseif strcmp(mode, 'skullstrip')
    m=x.*a;
end

%———————————————————————————————————————————————
%%   save mask
%———————————————————————————————————————————————
rsavenii(fileout,ha,m);

% fileout2=fullfile('O:\data2\minoryx\dat\M3c','_mask3.nii')
% rsavenii(fileout2,ha,de);



