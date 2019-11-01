

%% convert analyze(img/hdr)files to nifti
%% function nii=analyze2nii(img)
%% IN
% img     ; string of single OR cell of multiple analyzefiles
% if Fullpath not provided, analyze files are assumed to be located in PWD
% converted nifti-files will be saved in the same directory    
%% OUTS
% nii:        FPnames of resulting NII-files

function nii=analyze2nii(img)
if 0
    img={f1;f2};
    analyze2nii(img);
end
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
nii={};

%% OPEN GUI
if exist('img')==0
    [fi]=  cfg_getfile2(inf,'any',{'SELECT ANALYZE FILES';'the header ("*.hdr") files are selected here'},{},pwd,'.hdr' ,[]);
   if isempty(isempty(char(fi))); disp('no files selected'); return; end
   
   img=fi;
end
    

if ischar(img); img=cellstr(img); end %working on cell

for i=1:length(img)
    
    name=img{i};
    
    %% short name..suggested to be in pwd
    [pa fi ext]=fileparts(name);
    if isempty(pa); name=fullfile(pwd,[fi ext]);end
    
    %get file
    hr=spm_vol(name);
    [d  ]=(spm_read_vols(hr));
%     [hr d ]   =rgetnii(name);
    
    %% out
    [pa fi ext]=fileparts(name);
    nameout=fullfile(pwd,[fi '.nii']);
    nii{end+1,1}=nameout;
    h2=hr;
    h2.fname=nameout;
    %     h2.dt=[2 0];
    %     h2=rmfield(h2,'private');
    %  d2=flipdim(d,2);
    hh=spm_create_vol(h2);
    hh=spm_write_vol(hh,  (d));
    
end