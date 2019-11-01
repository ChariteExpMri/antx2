
%% reslice 3d/4d volume based on reference (=target) image or just reslicing with preservation of voxelsize
% function rreslice4d(s,r, prefix, interpx  )
% s: (char) FPname of sourceImage to reslice
% r: (char) FPname of referenceImage  or empty to just reslice without using the reference image
% prefix: -prefix for the output name:   <prefix string>,<empty><filename with format .nii>   
%           -if prefix is a string: filename is stored with this prefix
%           -if prefix is a filename with ending format '.nii' such as 'test.nii' the file is stored under this name
%           -if empty, the input sourceImage is overwritten with the resliced Image
% interpx: interpolationOrder [0] NN, [1]bilinear,.. [3]spline  or 'auto'
%   -if interpx is set to 'auto' the function tries to detect whether the volume contains only integers
%    and applies a NN-interpolation, otherwise a 3rd order interpolation is used
%     [0] nearest neighbor interpolation [1]trilinear interpolation
%   -'auto'  autodetect whether image is binary or multinary (contains only integers) such as in masks or atlases
%           in this case NN is applied, otherwise (image contain fraction numbers) apply trilinear interpolation
%   -'auto2' or 'auto3' : autodetect whether image is binary or multinary and apply NN-interpolation, otherwise
%      (image contain fraction numbers) apply 2nd/3rd .. order interpolation
% optonal pairwise inputs:
% 'verbose','on' : shows resulting header and hdr.mat
% OUTPUT: <optional> filename of the resulting volume
% 
%% EXAMPLES
%  % reslice  'c_DTI_shrew_1.nii' to targetImage ('DTI_shrew_1.nii'), using prefix 'aa', trilinear interpolation
%    rreslice4d('c_DTI_shrew_1.nii' ,'DTI_shrew_1.nii', 'aa',1  )
% ----------------------------------------------------------------------- 
%  %% just reslice  'c_DTI_shrew_1.nii', prefix 'aa',trilinear interpolation
%    rreslice4d('c_DTI_shrew_1.nii' ,[], 'aa', 1  )
% ----------------------------------------------------------------------- 
%  %% reslice  atlas  ('c_atlasmask.nii', multi-integer image) to targetImage ('c_DTI_shrew_1.nii'), using prefix 'aa', autodetect interpolation order
%    rreslice4d('c_atlasmask.nii','c_DTI_shrew_1.nii', 'aa' ,'auto');
% ----------------------------------------------------------------------- 
%  %% same as above with explicit interporder 0 (Next neighbour)
%    rreslice4d('c_atlasmask.nii','c_DTI_shrew_1.nii', 'aa' ,1);
% ----------------------------------------------------------------------- 
% same as above, bit save volume as 'test.nii', output is the resulting filename
%    filenameout=rreslice4d('c_atlasmask.nii','c_DTI_shrew_1.nii', 'test.nii',1);
% ----------------------------------------------------------------------- 
% same as above but show information
%  rreslice4d('c_atlasmask.nii','c_DTI_shrew_1.nii', 'aa',0 ,'verbose','on');
% ----------------------------------------------------------------------- 
% overwrite 'test2.nii' with the resliced image
% rreslice4d('test2.nii' ,'c_DTI_shrew_1.nii', '',1,'verbose','on'  );


%  rreslice4d('c_t2.nii','c_DTI_shrew_1.nii' , 'aa', 3 )
%  rreslice4d('c_t2.nii',[] , 'aa', 3  )
%  
%  rreslice4d('c_t2.nii',[] , 'aa', 3  )
 

 
 
    

function varargout=rreslice4d(s,r, prefix, interpx, varargin  )



%———————————————————————————————————————————————
%%   examples ..
%———————————————————————————————————————————————

% if 0
%     r=fullfile(pwd,'DTI_shrew_1.nii');
%     s=fullfile(pwd,'c_DTI_shrew_1.nii');
%     method =2  ; %[1]reslice to reference , [2] reslice preserve voxelsize
%     prefix='b' ; % prefix for outputfile: '' (empty) to overwrite coregistered image , or string ('r')
%     interpx=2  ; % interpolationorder: a number or 'auto' to determnine interpolationOrder (wither 0 or 3);
% end
% 
% if 0
%   % rreslice4d(s,r, prefix, method,interpx  ) 
%    rreslice4d('c_DTI_shrew_1.nii' ,'DTI_shrew_1.nii', 'aa',3  )  
%    rreslice4d('c_DTI_shrew_1.nii' ,[], 'aa', 3  ) 
%    
%    
%     rreslice4d('c_t2.nii','c_DTI_shrew_1.nii' , 'aa', 3 ) 
%     rreslice4d('c_t2.nii',[] , 'aa', 3  )
%     
%     rreslice4d('c_t2.nii',[] , 'aa', 3  )
%     
%     rreslice4d('c_atlasmask.nii','c_DTI_shrew_1.nii', 'aa' ,'auto');
% end

%———————————————————————————————————————————————
%%   aux parameters
%———————————————————————————————————————————————

p=struct('verbose','off');

if ~isempty(varargin)
    pn=struct(varargin{:});
    fn=fieldnames(pn);
    for i=1:length(fn);
       p=setfield(p,fn{i},getfield(pn,fn{i})) ;
    end
end

%———————————————————————————————————————————————
%%   
%———————————————————————————————————————————————

if isempty(r); % no referenceIMG is given
        method=2; % than reslice slice only
else
    [hr]=spm_vol(r );%REFIMAGE
    if size(hr,1)~=1; hr=hr(1); end %  REF is 4d take HDR of 1st vol
    method=1;
end

%r=s.ac{j}

[hs]=spm_vol(s );%SOURCE
[sdat]=spm_read_vols(hs);








 
%===================================================================================
if isempty(prefix);   fname =  hs(1).fname;                       %FILENAME - prefix
else;  
    if ~isempty(regexpi(prefix,'.nii$'))  %write to this name
        fname=prefix;
    else
        fname =  stradd(hs(1).fname,prefix,1) ;
    end
    
end

if  ischar(interpx) 
    if strcmp(interpx,'auto');   
        determineInterp = 1; % determine INTERPOLATION
        interpHighorder=  1;
    elseif strfind(interpx,'auto')
        determineInterp = 1; 
        interpHighorder=  str2num(strrep(interpx,'auto',''));
    else
        return
    end
else;                                            determineInterp = 0; interpp=interpx; 
end

%===================================================================================



for k=1:size(hs,1), % for each vol of 4d
    
    %% AUTODETDECT INTERPOLATION
    if determineInterp==1
        sint=sdat(:,:,:,k);sint=sint(:);
        if all(round(sint)==sint)==0; 
            interpp=interpHighorder;  %NON-integer
        else;                       ; 
            interpp=0;                %INTEGER
        end
    end
  
    %[ho, o] = nii_reslice_target(inhdr, inimg, tarhdr, interpx);
    if method==1
        [ho, o] = nii_reslice_target(hs(1), sdat(:,:,:,k), hr, interpp) ;
        
    elseif method==2
        if k==1
            hx=hs(1);
            hv=spm_imatrix(hx.mat);
            hv2=[hv(1:3) zeros(1,3) hv(7:9) zeros(1,3)];
            mat2=spm_matrix(hv2)  ;
            hx.mat = mat2;
            
        end
        [ho, o] = nii_reslice_target(hs(1), sdat(:,:,:,k), hx, interpp) ;
    end
    
    dum=ho;
    dum.fname=fname;
    dum.n=[k 1];
    hh2(k,1)=dum;
    if k==1;            spm_create_vol(hh2); end
    spm_write_vol(hh2(k),o);
end

try; delete( strrep(fname,'.nii','.mat')   ); end  %% REMOVE MATFILE

varargout{1}=fname;

%===================================================================================
%% VERBOSE ON
warning off;
if strcmp(p.verbose,'off'); return; end

clc
disp('===========** REPORT **===========');
try
    disp('---reference ');
    ht=spm_vol(r); ht=ht(1);
    disp(['NAME: ' ht.fname]);
    disp(ht);
    disp(ht.mat);
end
try
    disp('---source  (applied image)');
    hs=hs(1);
    disp(['NAME: ' hs.fname]);
    disp(hs);
    disp(hs.mat);
end

disp('---test RESLICED(OUT)');
ht=spm_vol(hh2); ht=ht(1);
disp(['NAME: ' ht.fname]);
disp(ht);
disp(ht.mat);

disp('==================================');
if method==1;
disp(['method            : '  '..reslice to reference']);
else
disp(['method            : '  ' ..reslice only,  preserve voxelsize']);
end
disp(['interpolationorder: ' num2str(interpp)]);




