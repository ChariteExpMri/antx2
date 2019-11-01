
%% make AVGThemi-volume from AVGTmask
% function fout=makeAVGThemi(avgtmaskfile)
% avgtmaskfile: FP-filename of AVGTmask.nii (voxdim dependent)
% fout        :  FP-filename of AVGThemi.nii  
%EXAMPLE
%     f1=fullfile(pwd,'AVGTmask.nii');
%     fout=makeAVGThemi(f1);

function fout=makeAVGThemi(avgtmaskfile)

if 0
    f1=fullfile(pwd,'AVGTmask.nii');
    fout=makeAVGThemi(f1);
    
end

f1=avgtmaskfile;
if exist(f1)~=2; error('no AVGTmask.nii found'); end

[bb vox]=world_bb(f1);

df=bb(1,:)+bb(2,:);
dimlr=vecnearest2(df,0);   ;%left-right dim

[ha a x xi]=rgetnii(f1);

ilr=x(dimlr,:);
il=find(ilr<0);
ir=find(ilr>=0);

a2=a(:);
m=zeros(size(a2));
m(il)=1;
m(ir)=2;
m2=reshape(m,size(a));

m3=m2.*a;


% [px]=fileparts(f1)
fout=fullfile(fileparts(f1),'AVGThemi.nii' );
rsavenii(fout,ha,m3,[2 0]);