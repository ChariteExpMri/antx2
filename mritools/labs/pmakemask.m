
function pmakemask(nameout,radius)

% pmakemask('__muell',10)
% make mask based on current position of SPM's coordinate
% nameout: outputfilename
% radius    : radius of VOI [mm]
% example: pmakemask('__muell',10) ;%current MIP-poistion with radius 10mm
% ===========================================================================
if 0
    pmakemask('__muell',10)
    
end
% ===========================================================================


c    =extractVolume(radius);
data3=makevol( ones(length(c.maskidx),1),  c.XYZ(:,c.maskidx),  c.hdr);
pwritevol2vol(nameout,(data3),c.hdr, ['nvox=' num2str(length(c.maskidx))]);
 


function c=extractVolume(radius)

% spm_vol('beta_0001.hdr')


file='beta_0001.hdr';
hdr=spm_vol(file);
[M XYZmm]=spm_read_vols(hdr);
[x y z] = ind2sub(size(M),1:length(M(:)));
XYZ=[x;y;z];

if exist('operation')
%     XYZ  =XYZ(:,M(:)>0);
%     XYZmm=XYZmm(:,M(:)>0);
    tg=['XYZ    =XYZ(:,M(:)'   operation ');' ];eval(tg);
    tg=['XYZmm  =XYZmm(:,M(:)' operation ');' ];eval(tg);
end

ts = spm_sample_vol(hdr,XYZ(1,:),XYZ(2,:),XYZ(3,:),0);

c.ts     =ts;
c.hdr  =hdr;
c.vol    =M;
c.XYZ    =XYZ;
c.XYZmm  =XYZmm;

%% get current coordinate
hReg=evalin('base','hReg');
u=get(hReg,'UserData');% , u.xyz
xyz=round(u.xyz);
if size(xyz,1)==1;      xyz=xyz';  end

% xyz=sv.XYZ
% tic
XYZ=XYZmm;
idx=nan(size(xyz,2),1);
XYZ=single(XYZ);
xyz=single(xyz);
for i=1:size(xyz,2)
    ab= repmat(xyz(:,i)',[ size(XYZ,2) 1]);
   sums=  sum(    (XYZ'-ab).^2  ,2);
   ix=min(find(sums==min(sums)));
%   [uxyz ix]=intersect(XYZ',xyz(:,i)','rows');
   %    [uxyz ix]=ismember(XYZ',xyz(:,i)','rows'); ix=find(ix==1);
    if ~isempty(ix)
        idx(i)=ix;
    end
end
idx=idx(1);



% radius=10
r = radius.^2;
O = ones(1,length(c.XYZ));% searchlite sphereSize
s = (sum((c.XYZmm-c.XYZmm(:,idx)*O).^2) < r);%SPHEREMASK    [1x NvoxSphere; bool]

% j      = find(sum((XYZmm - xY.xyz*Q).^2) <= xY.spec^2); %%see spm_regions & spm_ROI

disp(['MNI-coordinate: [ ' num2str( xyz(:)' ) ']']);
disp(['Nvoxel in mask: ' num2str(sum(s)) ]);

c.mask=single(s);
c.maskcenteridx=idx;
c.maskidx=find(c.mask==1);
% 'a'
% ===========================================================================

function data3=makevol( data,  XYZ,  strct,voltype)
% function data3=makevol( data,  XYZ,  strct)
% put data into 3d volume at coordinates XYZ
% voltype: type of volume [0 or NAN]
% example
% vol    =makevol( ACC.dat,  ACC.XYZ,  ACC.hdr);%-->put data into '0'-matrix
% vol    =makevol( ACC.dat,  ACC.XYZ,  ACC.hdr,0);%-->put data into '0'-matrix
% vol    =makevol( ACC.dat,  ACC.XYZ,  ACC.hdr,nan);%-->put data into 'nan'-matrix

if size(XYZ,1)~=3 ;     XYZ=XYZ'; end
if exist('voltype')==0
   voltype=0; 
end   
% XYZ =xw.XYZ
% dim =strct.dim
data3=zeros(strct.dim)*voltype;
for kv=1:length(data)
    data3(XYZ(1,kv),XYZ(2,kv),XYZ(3,kv))=data(kv);
end

% ===========================================================================

function pwritevol2vol(name,dat3d,strct, description)
% function pwritevol2vol(name,dat3d,strct, description)
% write 3d volume to majo-IMG/HDR

if exist('description')==0; description=''; end
    

name=regexprep(name,'.img$','');
[pathi nameshort aaa]=fileparts(name);
if isempty(pathi)
    pathi=pwd;
end
% fullname=fullfile(pathi,[nameshort '.img']);
fullname=fullfile(pathi,[nameshort '.nii']);

% strct=spm_vol(templatefile);
% im=zeros(strct.dim);
% for kv=1:length(data)
%     im(XYZ(1,kv),XYZ(2,kv),XYZ(3,kv))=data(kv);
% end
 
oim   = struct('fname',fullname ,...
    'dim',   {strct.dim},...
    'pinfo', {[1 0 0]'},...
    'mat',   {strct.mat},...
    'dt',[2 0],...%BINARY
    'descrip', {[description ' map']});

%  'dt',    {[4 spm_platform('bigend')]},...%     'dt',    {[16 spm_platform('bigend')]},...

% hdr.dt(1)=2;%save binary data as bytes: uint8=2; int16=4; int32=8; float32=16; float64=64
oim=spm_create_vol(oim);
oim=spm_write_vol(oim,double(dat3d));












