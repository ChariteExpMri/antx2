
%% change header information of 3d/4d nifti files (multifile-based)
% o=rchangehdr(task,varargin)
% currently only task-1 provided...but will be extended
%% TASK-1
% change voxel-resolution
% reason: erornous voxelsize defined by other programs, for example voxelsize is set to 1 (mm)
% o=rchanrgehdr(1,pairwise arguments)
% .. pairwise arguments
% [1] 'devres': devision factor for voxelresolution (for example, if devres is 10, voxelsize and origin is devided by 10)
%    devres:  can be a scalar (example [10]) or a triple-vector (example [10 10 1]) correponding to x,y,z-dimension
% [2] 'owrite' (optional)  option to overwrite the data, with following value and scenario
%     -1  [orig. file name]: origname maintained         [new file name]: origname+suffix '_new.nii'
%      0  [orig. file name]: origname+suffix '_orig.nii' [new file name]: origname
%      1  [orig. file name]: -will be deleted-           [new file name]: origname
% [3] 'files' (optional) : the inputfile/s  as fullpath cell-array otherwise file selection is done via gui
%% OUTPUT
% [o]struct with input/output-files (o.fnew/o.fold) 
%% EXAMPLE
% rchangehdr(1,'devres',10,'owrite',0); 
% rchangehdr(1,'devres',[2 3 4],'owrite',0); 
% o=rchangehdr(1,'devres',[10 12 1],'owrite',-1,'files',r);

function o=rchangehdr(task,varargin)





% =====TESTS=====================================

if 0
    r={ 'O:\data\aswendt\dat\test\masklesion.nii'
        'O:\data\aswendt\dat\test\nan_2.nii'
        'O:\data\aswendt\dat\test\t2.nii'};
end

% ==========================================
if nargin<=1; return; end

c =varargin(2:2:end);
f = varargin(1:2:end);
ar = cell2struct(c,f,2);
% ==========================================



    
if isfield(ar,'files')==0 ||  isempty(ar.files)==1
    [t,sts] = cfg_getfile2(inf,'image','select volume to change header resolution','',pwd,'.nii');
    if isempty(t); return; end
    t=regexprep(t,',.*','');% delete frameInfo
    ar.files=t;
end



if task==1
    o=changeresolution(ar);
end




%———————————————————————————————————————————————
%%   SUBS
%———————————————————————————————————————————————

%———————————————————————————————————————————————
%%   1  changeresolution
%———————————————————————————————————————————————
function o=changeresolution(ar)


type=0; %TYPES OF RESOLUTION SET
if isfield(ar,'devres')  && (length(ar.devres)==1 || length(ar.devres)==3) ; type=1; end
if type==0; return; end

% copy files
t0=ar.files;
if isfield(ar,'owrite')==0;   ar.owrite=0; end
t1=stradd(t0,'_orig',2);
t2=stradd(t0,'_new',2);
copyfilem(t0,t2);


for i=1:length(t2)    
    [ha a]=rgetnii(t2{i});
    
    for ii=1:length(ha)
        %%hc(ii).fname=['filename.nii'];
        hc=ha(ii);
        if type==1
            mat=hc.mat;
            im=spm_imatrix(mat);
            im([1:3  ]) =im([1:3 ])./ar.devres;
            im([7:9  ]) =im([7:9])./ar.devres;
            mat2=spm_matrix(im);
            hc.mat=mat2;
        end
        spm_write_vol(hc,a(:,:,:,ii));
    end
    
    %delete matfile
    matfile=regexprep(t2{i},'.nii','.mat');
    if exist(matfile)==2
        delete(matfile);
    end
end

if ar.owrite==-1   %%: [orig file]: origname             [new file]: origname*_new.nii
    o.fnew=t2;
    o.fold=t0;
elseif ar.owrite==0    %%: [orig file]: origname_orig    [new file]: origname.nii
    movefilem(t0,t1);
    movefilem(t2,t0);
    o.fnew=t0;
    o.fold=t1;
elseif  ar.owrite ==1  %%: [orig file]: --               [new file]: origname.nii
    movefilem(t0,t1);
    movefilem(t2,t0);
    deletem(t1);
    o.fnew=t0;
    o.fold=t0;
end





% 
% al=fullfile('O:\data\aswendt\dat\JANG_28913_2doi141','masklesion - Kopie.nii')
% h=spm_vol(al)



% tic
% for ii=1:length(h)
%     hx=h(ii);
%     hx.mat(1:3,1:4)=hx.mat(1:3,1:4)/fc
%     spm_get_space(al,      hx.mat);
%     
% end
% toc