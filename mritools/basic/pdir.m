
%% get files/dirs/all from path 
% [files FPfiles]=pdir(pathx, modex, flt )
%% IN
% pathx   :path to search (optional), default pwd
% modex   :type to search (optional), default 'file' use['file' |'dir' |'all']
% flt     :window filter (optional),default '*.*'
% %% OUT
% files     elements (files and or folders)
% FPfiles]  fullpath elements
%% EXAMPLES
% [files FPfiles]=pdir(pwd,'dir')
% [files FPfiles]=pdir(pwd,'file')
% [files FPfiles]=pdir(pwd,'all')
% [files FPfiles]=pdir('c:\','all')
% [files FPfiles]=pdir('c:\','file','*.sys')
%     
 
function [files FPfiles]=pdir(pathx, modex,flt  )



% pathx=pa
% flt='*.*'
% modex='file'

if exist('pathx')==0; pathx=[]; end
if exist('flt')==0;    flt  =[]; end
if exist('modex')==0; modex=[]; end


if isempty(pathx); pathx=pwd; end
if isempty(flt); flt='*.*'; end
if isempty(modex); modex=2; end

% pathx
% flt
% modex


k=dir(fullfile(pathx,flt));
if isempty(k)
   [ files FPfiles]=deal([]);
    return
end
d=[{k(:).isdir}'];
n={k(:).name}';
n(:,2)=[{k(:).isdir}'];
%delete ./..
try; n(strcmp(n(:,1),'.'),:)=[]; end
try; n(strcmp(n(:,1),'..'),:)=[]; end


if strcmp(modex,'file')
    n(cell2mat(n(:,2))==1,:)=[];
elseif strcmp(modex,'dir')
    n(cell2mat(n(:,2))==0,:)=[];
end

files  =n(:,1);
FPfiles=cellfun(@(files)[fullfile(pathx, files )],files,'UniformOutput',0);

