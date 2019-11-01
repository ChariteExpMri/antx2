
function fileout=rflipdim(filename, dimorder, prefix )
%%  flip dimensions/orientation and handendness/reflextion
%  rflipdim(filename, dimorder, prefix )
% fileout=rflipdim(filename, dimorder, prefix )
%% IN
% filename    : <str> filename 
% dimorder    : <3 val vector>  [x y z] tp permute dims , use sign to flip handendness
%             eg. [1 -3 2]  x..x, y->z with fliped orientation, z->y
% prefix      : <str> filename prefix  , eg. 'p'
%% OUT
% fileout : name of file to write
%% example
% rflipdim('RwhsLabel_msk.nii', [1 3 -2], 'q' );
% rflipdim('RT2W.nii', [1 3 -2], 'q' );


% filename='T2brain_msk.nii' 

if ~exist('prefix','var'); prefix='p'; end

if ~exist('dimorder','var')
    prompt = {'order of dims,use[-] to flip dir of this dim, e.g. [1 3 -2], [] for orig. settup '};
    dlg_title = 'Input for peaks function';
    num_lines = 1;
    def = {num2str([1 2 3])};
    answer = inputdlg(prompt,dlg_title,num_lines,def);
    dimorder=[str2num(char(answer)) ];
end

if length(dimorder)~=3; return; end
%===============================

flips=sign(dimorder);
perms=abs(dimorder);

[v d]=rgetnii(filename);

% v=spm_vol(st.overlay.fname)
% d=spm_read_vols(v); % r

isflip=find(flips==-1);
dia=diag(v.mat(1:3,1:3));
dc=zeros(3,1);
for i=1:length(isflip)
    vsiz=dia(isflip(i));
    a=[vsiz:vsiz:vsiz*(size(d,isflip(i))+1)]+v.mat(isflip(i),4);
    %a=[0:vsiz:vsiz*(size(d,isflip)-1)]+v.mat(isflip(i),4);
    dc(isflip(i))=-[a([ end]) ] ;
    d=flipdim(d,isflip(i));
end
%permute
d=permute(d,[perms]);

%         dsh=round(size(d)/2)  ;
%         subplot(3,3,7); imagesc( squeeze(d(dsh(1),:     ,:) )   )     ;title(['2 3']);
%         subplot(3,3,8); imagesc( squeeze(d(:     ,dsh(2),:) )   )     ; title(['1 3']);
%         subplot(3,3,9); imagesc( squeeze(d(:     ,:     ,dsh(3)) )   );  title(['1 2']);
%
%
v2=v;
[pa filename fmt]=fileparts(v2.fname);
v2.fname=fullfile(pa ,[prefix filename  fmt]);
v2.dim=size(d);
mat=v2.mat;
dia=diag(mat);
mat(1:4+1:end)=dia([perms 4]);

orig=mat(1:3,4);
orig(find(dc~=0) )=dc(find(dc~=0));
%         orig=orig.*flips'
%         orig(2)=orig(2)+3
orig=orig(perms);

mat(:,4)=[orig; 1];
%         mat(3,4)=mat(3,4)+2
v2.mat=mat;
spm_write_vol(v2, d); % write data to an image file.

fileout=v2.fname;











