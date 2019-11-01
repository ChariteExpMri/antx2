

 


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
    'dt',    {[16 spm_platform('bigend')]},...
    'pinfo', {[1 0 0]'},...
    'mat',   {strct.mat},...
    'descrip', {[description ' map']});


oim=spm_create_vol(oim);
oim=spm_write_vol(oim,double(dat3d));