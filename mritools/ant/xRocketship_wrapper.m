% Estimate quantitative R1 (=1/T1) and T1 maps from Variable Flip Angle (VFA)
% MRI data using the ROCKETSHIP toolbox.
%
% This wrapper provides a fully automated interface to ROCKETSHIP and
% performs all preprocessing steps required for VFA fitting without user
% interaction or graphical dialogs.
%
% Compared with the original ROCKETSHIP workflow, this wrapper
%
%   • automatically combines individual VFA images into a 4D NIfTI volume
%   • optionally applies a brain mask prior to fitting
%   • optionally dilates the mask to increase tissue coverage
%   • automatically creates the required ROCKETSHIP job structure
%   • executes ROCKETSHIP completely without GUI interaction
%   • copies the resulting quantitative maps back to the animal directory
%   • optionally removes the temporary processing directory afterwards
%
% The wrapper supports all fitting models implemented by ROCKETSHIP, but is
% primarily intended for VFA-based T1/R1 mapping using linear or nonlinear
% fitting algorithms.
%% =====================================================
%% DESCRIPTION
%% =====================================================
% The function prepares all ROCKETSHIP input files, creates the required
% job structure, executes the selected ROCKETSHIP fitting routine and
% returns the resulting quantitative parameter maps.
%
% Processing is completely automatic and does not require any interaction
% with the original ROCKETSHIP GUI.
% 
%% =====================================================
%% USAGE
%% =====================================================
% xRocketship_wrapper(showgui,x)
% xRocketship_wrapper(showgui,x,pa)
% 
%% =====================================================
%% INPUT
%% =====================================================
% [showgui]  Show graphical user interface.
%               [1] show GUI
%               [0] no GUI
% [x]       Structure containing processing parameters.
% [pa]      Optional cellstring containing animal paths outside ANTx project structure.
%           Default:  Uses currently selected animals from ANTx GUI.
% ==============================================================
% PARAMETERS (x)
% ==============================================================
% [inputfiles]       Cell array containing the input NIfTI files.
%                    Typically a VFA image series acquired at different flip
%                    angles. File order must exactly match rs_parameters.
% 
% [Nifti4D_name]     Filename of the temporary 4D NIfTI volume generated
%                    from inputfiles. This filename also becomes part of the
%                    final ROCKETSHIP output filename.
%                    Example:
%                    'VFA_T1map.nii'
%                    'VFA_T1map_post.nii'
% 
% [subdirName]       Name of the temporary processing subdirectory created
%                    inside each animal directory.
%                    Default: 'sub_rs'
% 
% [mask]             Optional binary brain mask restricting voxel fitting to
%                    brain tissue only. Using a mask considerably reduces
%                    computation time and suppresses noisy background fits.
%
%                    For native-space input data the recommended mask is:
%                    'ix_AVGTmask.nii'
%
%                    Leave empty to disable masking.
% 
% [maskDilationSize] Number of voxels used to dilate the mask before fitting.
%                    0 disables dilation.
%                    Larger values increase tissue coverage but may include
%                    surrounding non-brain voxels.
%                    Default: [3]
% 
% [path_Rocketship]  Full path to the ROCKETSHIP installation directory.
%                    Required for locating all ROCKETSHIP functions.
%
%                    Default (Windows):
%                    'D:\MATLAB\ROCKETSHIP-master_2016\ROCKETSHIP-master'
% 
% [rs_output_basename]
%                    Base filename used for all ROCKETSHIP output maps,
%                    R² maps and log files.
%
%                    Default:   'T1_map'
% 
% [rs_fit_type]      ROCKETSHIP fitting model.
%                    For standard VFA T1 mapping use:
%
%                    't1_fa_linear_fit'
%
%                    Other supported ROCKETSHIP models: 't2_linear_simple','t2_linear_weighted','t2_exponential'
%                        ,'t2_linear_fast','t1_tr_fit','t1_fa_fit','t1_fa_linear_fit','t1_ti_exponential_fit'
% 
% [rs_parameters]    Model parameters supplied to ROCKETSHIP.
%                       exampe & default:  [5 10 20 35 50]
%
%                    For VFA fitting these correspond to the flip angles
%                    (degrees) and must exactly match the acquisition.
% 
% [rs_tr]            Repetition time (TR) in milliseconds.
%                    Required for all VFA T1 fitting methods.
%                       exampe & default: [15]
% 
% [rs_xy_smooth_size] Gaussian smoothing kernel size applied before fitting (in-plane only). 
%                     0 disables smoothing.
%                     Larger values improve SNR at the expense of spatial resolution.
% 
% [rs_rsquared]      Minimum accepted coefficient of determination (R²).
%
%                    -1 disables thresholding.
%                    Otherwise voxels with R² below the specified threshold
%                    are excluded from the output map.
% 
% [rs_odd_echoes]    Use only odd echoes.
%
%                    Mainly intended for multi-echo acquisitions.
%                    For standard VFA T1 mapping this should remain 0.
% 
% [rs_number_cpus]   Maximum number of CPU cores used during fitting.
%
%                    The wrapper automatically limits this value to the
%                    number of available logical processors.
% 
% [cleanup]          Delete the temporary processing directory after
%                    successful completion.
%
%                    If enabled, the resulting output-file are copied back to the animal
%                    directory before the processing directory is removed.
% 
%% =====================================================
%% OUTPUT
%% =====================================================
% Quantitative parameter maps generated by ROCKETSHIP.
%
% For linear VFA fitting the primary output is
%
%       T1_map_t1_fa_linear_fit_<Nifti4D_name>_real.nii
% 
% is defined by:  [rs_output_basename]_[rs_fit_type]_[Nifti4D_name]_"real.nii" 
%       example:  ['T1_map']_['t1_fa_linear_fit']_['VFA_T1map.nii']_"real.nii"
%
% where "_real" indicates that the real-valued component of the fitted map
% has been extracted from the complex ROCKETSHIP output.
%
%% =====================================================
%% UNDERLYING ROCKETSHIP FUNCTIONS
%% =====================================================
% The wrapper uses the original ROCKETSHIP implementation without modifying
% the underlying fitting algorithms.
%
% Main functions: 
%   calculateMap.m
%   parallelFit.m
%   fitParameter.m
%
% All quantitative maps are therefore numerically identical to those
% produced by the original ROCKETSHIP GUI when identical parameters are
% supplied.
% 
% 
%% =======================================================================
%% EXAMPLE-1: rocketship:  PRE-INJECTION
%% --> resulting file: T1_map_t1_fa_linear_fit_VFA_T1map_real.nii
%% =======================================================================
% z=[];
% z.inputfiles         = {...
%     'c_VFA_T1_map_5deg.nii'                                                  % % Input VFA NIfTI images. File order must exactly match rs_parameters (flip angles).
%     'c_VFA_T1_map_10deg.nii'
%     'c_VFA_T1_map_20deg.nii'
%     'c_VFA_T1_map_35deg.nii'
%     'c_VFA_T1_map_50deg.nii' };
% z.Nifti4D_name       = 'VFA_T1map.nii';                                      % % Name of the temporary 4D NIfTI file created for ROCKETSHIP from the individual VFA images.
% z.subdirName         = 'sub_rs';                                             % % Temporary processing subdirectory.
% z.mask               = 'ix_AVGTmask.nii';                                    % % Optional binary brain mask to restrict fitting to brain tissue. Improves speed and reduces noise-driven fitting errors.
% z.maskDilationSize   = [3];                                                  % % Number of voxels by which the brain mask is dilated before fitting. 0 disables dilation; higher values increase coverage but may include non-brain tissue.
% z.path_Rocketship    = 'F:\data10\rocketship_wrapper\ROCKETSHIP-master';     % % Full path to ROCKETSHIP installation folder. Required to locate core fitting functions and scripts.
% z.rs_output_basename = 'T1_map';                                             % % Base name for all output maps (e.g., T1_map.nii, T1_map_R2.nii). Defines naming convention for all results of this run.
% z.rs_fit_type        = 't1_fa_linear_fit';                                   % % Defines the fitting model used for T1 estimation. "t1_fa_linear_fit" performs linearized VFA T1 mapping using flip angle data.
% z.rs_parameters      = [5  10  20  35  50];                                  % % Flip angles (degrees) used for VFA T1 fitting. Must exactly match acquisition order and values for correct T1 estimation.
% z.rs_tr              = [15];                                                 % % Repetition time (TR) used in the acquisition (ms). Critical parameter for accurate T1 estimation in VFA models.
% z.rs_xy_smooth_size  = [0];                                                  % % Gaussian smoothing kernel size applied before fitting (in-plane only). 0 = no smoothing. Larger values improve SNR but reduce spatial resolution.
% z.rs_rsquared        = [-1];                                                 % % R² threshold for voxel inclusion. -1 disables thresholding; otherwise voxels with poor fit quality are excluded.
% z.rs_odd_echoes      = [0];                                                  % % If enabled (1), only odd echoes are used for fitting. For standard VFA T1 mapping this should remain 0.
% z.rs_number_cpus     = [5];                                                  % % Number of CPU cores used for parallel fitting. Higher values speed up computation but depend on system limits and MATLAB Parallel Toolbox.
% z.cleanup            = [1];                                                  % % Delete the temporary processing directory after completion.; default [1]
% xRocketship_wrapper(0,z);
%% =======================================================================
%% EXAMPLE-2: rocketship:  POST-INJECTION
%% --> resulting file: T1_map_t1_fa_linear_fit_VFA_T1map_post_real.nii 
%% =======================================================================
% z=[];                                                                                                                                                                                                                                          
% z.inputfiles         = { 'c_VFA_T1_map_postInj_5deg.nii'                     % % Input VFA NIfTI images. File order must exactly match rs_parameters (flip angles).
%                          'c_VFA_T1_map_postInj_10deg.nii'                                                                                                                                                                                      
%                          'c_VFA_T1_map_postInj_20deg.nii'                                                                                                                                                                                      
%                          'c_VFA_T1_map_postInj_35deg.nii'                                                                                                                                                                                      
%                          'c_VFA_T1_map_postInj_50deg.nii' };                                                                                                                                                                                   
% z.Nifti4D_name       = 'VFA_T1map_post.nii';                                 % % Name of the temporary 4D NIfTI file created for ROCKETSHIP from the individual VFA images.                                                  
% z.subdirName         = 'sub_rs';                                             % % Temporary processing subdirectory.     
% z.mask               = 'ix_AVGTmask.nii';                                    % % Optional binary brain mask to restrict fitting to brain tissue. Improves speed and reduces noise-driven fitting errors.
% z.maskDilationSize   = [3];                                                  % % Number of voxels by which the brain mask is dilated before fitting. 0 disables dilation; higher values increase coverage but may include non-brain tissue.    
% z.path_Rocketship    = 'F:\data10\rocketship_wrapper\ROCKETSHIP-master';     % % Full path to ROCKETSHIP installation folder. Required to locate core fitting functions and scripts.                                                           
% z.rs_output_basename = 'T1_map';                                             % % Base name for all output maps (e.g., T1_map.nii, T1_map_R2.nii). Defines naming convention for all results of this run.                                       
% z.rs_fit_type        = 't1_fa_linear_fit';                                   % % Defines the fitting model used for T1 estimation. "t1_fa_linear_fit" performs linearized VFA T1 mapping using flip angle data.                                
% z.rs_parameters      = [5  10  20  35  50];                                  % % Flip angles (degrees) used for VFA T1 fitting. Must exactly match acquisition order and values for correct T1 estimation.                                     
% z.rs_tr              = [15];                                                 % % Repetition time (TR) used in the acquisition (ms). Critical parameter for accurate T1 estimation in VFA models.                                               
% z.rs_xy_smooth_size  = [0];                                                  % % Gaussian smoothing kernel size applied before fitting (in-plane only). 0 = no smoothing. Larger values improve SNR but reduce spatial resolution.             
% z.rs_rsquared        = [-1];                                                 % % R² threshold for voxel inclusion. -1 disables thresholding; otherwise voxels with poor fit quality are excluded.                                              
% z.rs_odd_echoes      = [0];                                                  % % If enabled (1), only odd echoes are used for fitting. For standard VFA T1 mapping this should remain 0.                                                       
% z.rs_number_cpus     = [5];                                                  % % Number of CPU cores used for parallel fitting. Higher values speed up computation but depend on system limits and MATLAB Parallel Toolbox.                    
% z.cleanup            = [1];                                                  % % Delete the temporary processing directory after completion.; default [1]                                                                                                                          
% xRocketship_wrapper(0,z);
        



function xRocketship_wrapper(showgui,x,pa)

isExtPath=0; % external path
if exist('pa')==1 && ~isempty(pa)
    isExtPath=1;
end
%===========================================
%%   PARAMS
%===========================================
if exist('showgui')==0 || isempty(showgui) ;    showgui=1                ;end
if exist('x')==0                          ;    x=[]                     ;end
if isExtPath==0      ;    pa=antcb('getsubjects')  ;end
if ischar(pa);                      pa=cellstr(pa);   end
if isempty(x) || ~isstruct(x)  ;  %if no params spezified open gui anyway
    showgui  =1   ;
    x=[]          ;
end
%________________________________________________
%%  generate list of nifit-files within pa-path
%________________________________________________
%% fileList
if 1
    fi2={};
    for i=1:length(pa)
        [files,~] = spm_select('FPList',pa{i},['.*.nii$']);
        if ischar(files); files=cellstr(files);   end
        fis=strrep(files,[pa{i} filesep],'');
        fi2=[fi2; fis];
    end
    li=natsort(unique(fi2));
end

%% ________________________________________________________________________________________________
%%  PARAMETER-gui
%% ________________________________________________________________________________________________
if exist('x')~=1;        x=[]; end
%example-pre
% Nifti4D_name ='VFA_T1map.nii';
% inputfiles = {...
%     'c_07_2_VFA_T1_map_5deg.nii'
%     'c_07_3_VFA_T1_map_10deg.nii'
%     'c_07_4_VFA_T1_map_20deg.nii'
%     'c_07_5_VFA_T1_map_35deg.nii'
%     'c_07_6_VFA_T1_map_50deg.nii'    };
Nifti4D_name ='VFA_T1map.nii';
inputfiles={''};

fit_options= {'none','t2_linear_simple','t2_linear_weighted','t2_exponential','t2_linear_fast',...
      		't1_tr_fit','t1_fa_fit','t1_fa_linear_fit','t1_ti_exponential_fit'};



p={...
    'inf1'      '--- Rocketship wrapper ---'  '' ''
    'inf2'      'Estimation of quantitative R1/T1 maps from variable flip angle (VFA) MRI data using linear or nonlinear fitting models.'     '' ''
    'inf3'      repmat('_',[1,100])  '' ''
    
    'inputfiles'        inputfiles    'Input VFA NIfTI images. File order must exactly match rs_parameters (flip angles)'          {@selector2,li,{'files'},'out','list','selection','multi','position','auto','info','select input-files'}
    'Nifti4D_name'      Nifti4D_name  'Name of the temporary 4D NIfTI file created for ROCKETSHIP from the individual VFA images.' {'VFA_T1map.nii' 'VFA_T1map_post.nii'}
    
    'subdirName'        'sub_rs'           'Temporary processing subdirectory, located within the animal-DIR.'  {'subdir1' 'rocketship_1' ''}
    'mask'              'ix_AVGTmask.nii'  'Optional binary brain mask to restrict fitting to brain tissue. Improves speed and reduces noise-driven fitting errors.' {@selector2,li,{'files'},'out','list','selection','single','position','auto','info','select (brain) mask'}
    'maskDilationSize'  [3]                'Number of voxels by which the brain mask is dilated before fitting. 0 disables dilation; higher values increase coverage but may include non-brain tissue.' {0,1,2,3,4,5}
    
    'inf4' '' '' ''
    'inf5' '___ ROCKETSHIP PARAMETER SETTINGS ___' '' ''
    'path_Rocketship'      'D:\MATLAB\ROCKETSHIP-master_2016\ROCKETSHIP-master' 'Full path to ROCKETSHIP installation folder. Required to locate core fitting functions and scripts.' {@rocketship_paths}
    'rs_output_basename'   'T1_map'             'Base name for all output maps (e.g., T1_map.nii, T1_map_R2.nii). Defines naming convention for all results of this run.' {'T1_map'}
    'rs_fit_type'          't1_fa_linear_fit'   'Defines the fitting model used for T1 estimation. "t1_fa_linear_fit" performs linearized VFA T1 mapping using flip angle data.'  fit_options
    'rs_parameters'        [5 10 20 35 50]      'Flip angles (degrees) used for VFA T1 fitting. Must exactly match acquisition order and values for correct T1 estimation.'     {[5 10 20 35 50]}
    'rs_tr'                [15]                 'Repetition time (TR in ms) used in the acquisition (ms). Critical parameter for accurate T1 estimation in VFA models.'     ''
    'rs_xy_smooth_size'    [0]                  'Gaussian smoothing kernel size applied before fitting (in-plane only). 0 = no smoothing. Larger values improve SNR but reduce spatial resolution.'  ''
    'rs_rsquared'          [-1]                 'R² threshold for voxel inclusion. -1 disables thresholding; otherwise voxels with poor fit quality are excluded.'  ''
    'rs_odd_echoes'        [0]                  'If enabled (1), only odd echoes are used for fitting. For standard VFA T1 mapping this should remain 0.'     ''
    'rs_number_cpus'       [5]                  'Number of CPU cores used for parallel fitting. Higher values speed up computation but depend on system limits and MATLAB Parallel Toolbox.' ''
    
    'inf6'      repmat('_',[1,100])  '' ''
    'cleanup'              [1]  'Delete the temporary processing directory after completion.; default [1]'   'b'
    };

p=paramadd(p,x);%add/replace parameter
if showgui==1
    [m z ]=paramgui(p,'uiwait',1,'close',1,'editorpos',[.03 0 1 1],'figpos',[0.16 0.19 0.74  0.46],...
        'title',['***Rocketship_wrapper***' '[' mfilename '.m]'],'info',{@uhelp, [mfilename '.m']});
    if isempty(m); return; end
    fn=fieldnames(z);
    z=rmfield(z,fn(regexpi2(fn,'^inf\d')));
else
    z=param2struct(p);
end

% ==============================================
%%   BATCH
% ===============================================
try
    isDesktop=usejava('desktop');
    if isExtPath==0
        xmakebatch(z,p, mfilename,[mfilename '(' num2str(isDesktop) ',z);' ]);
    else
        xmakebatch(z,p, mfilename,[mfilename '(' num2str(isDesktop) ',z,mdirs);' ],pa);
    end
end


% ==============================================
%%   checks and mods
% ===============================================
x=z;
x.inputfiles        =cellstr(x.inputfiles);
x.path_Rocketship   =x.path_Rocketship;

fn=fieldnames(x);
fnrs=fn(regexpi2(fn,'rs_'));

for i=1:length(fnrs)
    val=getfield(x,fnrs{i});
    if strcmp(fnrs{i},'rs_number_cpus')
        newname=regexprep(fnrs{i}, {'rs_'},{ 'ba.'  } )   ;
    else
        newname=regexprep(fnrs{i}, {'rs_'},{ 'ba.batch_data.'  } );
    end
    eval(['x.' newname ' = val;']);
    try;
        x=rmfield(x,fnrs{i});
    end
end


%% ============== [not modifiable but required] =================================
x.ba.neuroecon                  = [0];%Switch for Neuroecon / external pipeline mode (rarely used in standard MRI fitting).Keep 0 unless running specialized Neuroeconomics pipeline integration.
x.ba.batch_data.to_do           = [0]; %Internal flag controlling execution state. Must be 0 for normal execution (GUI state variable).
x.ba.batch_data.curslice        = [1];% Initial slice index used for preview/GUI navigation.Only relevant for interactive visualization, ignored in batch mode.
x.ba.batch_data.data_order      = 'xyzn'; %data_order = 'xyzn' Defines dimension ordering of input data (x, y, z, n-volumes).Must match how 4D NIfTI is interpreted; wrong order leads to incorrect fits.
x.ba.batch_data.preview_image   = []; %Optional image used for GUI preview.Empty means no preview is shown (batch mode).
x.ba.save_log                   = [1]; %Saves full processing log file (.txt / .mat).Useful for reproducibility and debugging pipelines.
x.ba.batch_log                  = [0];
% x.ba.current_dir                =  x.pa_out ;%'H:\Daten-2\Imaging\AG_Penack_ICANS\rocketship_simulate_paul\sub1';%'D:\';
x.ba.save_txt                   = [0];
x.ba.submit                     = [1];

% FORCE NON-GUI FLAGS
x.ba.options.gui = 0;
x.ba.handles.submit = 1;
x.ba.log_name                   =  'bla.log';%'ROCKETSHIP_MAPPING_26-May-2026_16-33-49.log';
x.ba.email                      =  '';
x.ba.email_log                  =  [0];

x.ba.batch_data.roi_list        = {}; %List of ROI masks to restrict fitting to specific regions. Empty {} means full-volume voxel-wise fitting.
x.ba.batch_data.fit_voxels      = [1]; %If 1: performs voxel-wise fitting over entire volume. If 0: may restrict fitting or run test/ROI-only mode.

% ==============================================
%%   check number of cpus
% ===============================================
nCPU=parcluster('local').NumWorkers;
if x.ba.number_cpus>nCPU
    x.ba.number_cpus=nCPU;
end
% ==============================================
%%   add rocketship-path
% ===============================================
if isempty(which('calculateMap.m'))
    addpath(genpath(x.path_Rocketship))
end
chk_pa=which('calculateMap.m');
if isempty(chk_pa)
    msg='ROCKETSHIP installation path not specified. Please set ''path_Rocketship''. Aborting.';
     try
         msgbox(msg,'ERROR');
     catch
         disp(msg);
     end
     return
end


% ==============================================
%%   process
% ===============================================
cprintf('*[0 0 1]',['ROCkETSHIP_WRAPPER'  '\n']);
mdirs=cellstr(pa);
timex1=tic;
for i=1:length(mdirs)
    timex2=tic;
    [~,animal]=fileparts(mdirs{i});
    cprintf('[0 0 1]',['..processing: ' pnum(i,3) '/' pnum(length(mdirs),3) '[' animal ']'  '\n']);
    proc(mdirs{i}, x);
    cprintf('[0 0 1]',['..DONE: ' pnum(i,3) '/' pnum(length(mdirs),3)  ', ET:' sprintf('%2.1fmin',toc(timex2)/60)  '\n']);
end
cprintf('*[0 0 1]',['..DONE: ' 'ET:' sprintf('%2.1fmin',toc(timex1)/60)  '\n']);


function proc(mdir, x)

% ==============================================
%%
% ===============================================
tempdir=mdir;
if isempty(x.subdirName)
    copyfiles=0;
else
    tempdir= fullfile(mdir,x.subdirName );
    if exist(tempdir)~=7
        mkdir(tempdir);
    end
end

% ==============================================
%% using mask and  make 4D
% ===============================================
% mask ( maskDilationSize,mask)
usemask=0;
m=[];
maskfile=fullfile(mdir,char(x.mask));
if exist(maskfile)==2
    img1=fullfile(mdir,x.inputfiles{1});
    [hm,m ]= rreslice2target(maskfile,img1, [], 0, 2);
    
    dilateMask_value=x.maskDilationSize ; %%mask delaton value: default 3
    if ~isempty(dilateMask_value) && dilateMask_value>1
        m= imdilate(m,ones(dilateMask_value,dilateMask_value));
    end
    usemask=1;
end

% make 4D-data
f2  =cellfun(@(a){[mdir     filesep a ]},x.inputfiles );
for i=1:length(f2)
    [ha a]=rgetnii(f2{i});
    if i==1
        a2=zeros([size(a)  length(f2) ]);
    end
    a2(:,:,:,i)=a;
end

if usemask==1 && ~isempty(m) && any(size(a)==size(m))
    a2=a2.*repmat(m,[ 1 1 1 size(a2,4) ]);
    original_size=size(m);
    %crop IMage
    M  = m > 0;
    [idx_x, idx_y, idx_z] = ind2sub(size(M), find(M));
    xmin = min(idx_x); xmax = max(idx_x);
    ymin = min(idx_y); ymax = max(idx_y);
    zmin = min(idx_z); zmax = max(idx_z);
    Ycrop = a2(xmin:xmax, ymin:ymax, zmin:zmax, :);
    
    V0 = ha;
    M  = V0.mat;
    % voxel offset in homogeneous coordinates
    offset = [xmin-1; ymin-1; zmin-1; 0];
    M(1:3,4) = M(1:3,4) + M(1:3,1:3)*offset(1:3);
    Vout = V0;
    Vout.mat = M;
    Vout.dim=[size(Ycrop(:,:,:,1)) ];
    
    try; delete(file4d); end
    file4d=fullfile(tempdir, x.Nifti4D_name);
    rsavenii(file4d,Vout,Ycrop,16);
%     showinfo2(['NIFTI'],file4d);
else
    file4d=fullfile(tempdir, x.Nifti4D_name);
    rsavenii(file4d,ha,a2,16);
%     showinfo2(['NIFTI'],file4d);
end

% ==============================================
%%   copy files
% ===============================================
x.copyfiles=0;
if ~isempty(x.subdirName)
    x.copyfiles=1;
end


clear s0
s=x.ba;
s.batch_data.file_list ={file4d} ;  %; {fullfile(mdir, x.file ) };
% s.input.files          = x.inputfiles ;
% s=rmfield(s,'input');
s.current_dir=tempdir;
if x.copyfiles==1 &&  strcmp(mdir,tempdir)==0
    %     f1 =fullfile(mdir    ,'dum.nii');
    %     fo1=fullfile(tempdir ,'dum.nii');
    %     copyfile(f1,fo1,'f');
    %     showinfo2([' copied'],fo1);
    if 0
        f2  =cellfun(@(a){[mdir     filesep a ]},x.inputfiles );
        fo2 =cellfun(@(a){[tempdir  filesep a ]},x.inputfiles );
        copyfilem(f2,fo2);
    end
    s.current_dir          =tempdir;
end
s.batch_data.file_list ={file4d};%fo2;%x.inputfiles;%{};% {fullfile(tempdir, x.file ) };


% %% ROI
% if 1
%     mask=fullfile(tempdir,'brainmask.nii');
%     rreslice2target(fullfile(mdir,'ix_AVGTmask.nii' ),fo2{1}, mask, 0, 2);
%     s.batch_data.roi_list={mask};%{'brainmask.nii'};
% end
% ==============================================
%%   calc
% ===============================================
%DELETE OLD LOG-FILE
% T1_map_t1_fa_linear_fit_VFA_T1map_post.txt
[~,fnameShort ]=fileparts(s.batch_data.file_list{1});
basename=[s.batch_data.output_basename '_' s.batch_data.fit_type  '_' fnameShort];
oldlog=fullfile(tempdir,[ basename '.txt'  ]);
if exist(oldlog)==2
    try; delete(oldlog); end
end
%% ===============================================

disp('Running PRE fit...');
% [single_IMG, errormsg, JOB_struct, txtlog_output_path] = calculateMap(s);
% [single_IMG, errormsg, JOB_struct] = calculateMap(s);
try
    %[outStr, result] = evalc('[single_IMG, errormsg, JOB_struct] = calculateMap(s);');
    outStr = evalc('[single_IMG, errormsg, JOB_struct] = calculateMap(s);');
catch ME
    fprintf(2, ' MATLAB error in calculateMap:\n%s\n', ME.message);
    rethrow(ME);
end

% only show Rocketship-specific error message if it exists
if exist('errormsg','var') && ~isempty(errormsg)
    fprintf(2, ' calculateMap returned error message:\n%s\n', errormsg);
end

% ==============================================
%%
% ===============================================
% \T1_map_t1_fa_linear_fit_VFA_T1map_post.txt'

% ==============================================
%%   from cmplexData use  real-part only
% ===============================================
% resfile=txtlog_output_path;
% [~, name  ]=fileparts(resfile);
% resfile=fullfile(tempdir, [ name '.nii']);

name=[s.batch_data.output_basename '_' s.batch_data.fit_type  '_' fnameShort '.nii'];
resfile=fullfile(tempdir,name);

nii=load_nii(resfile);
nii.img(imag(nii.img)~=0)=-1;
nii.img=real(nii.img);

hd  =spm_vol(resfile);
hd.dt=[64 0];

if usemask==1
    Yfull = zeros(original_size);
    Yfull(xmin:xmax, ymin:ymax, zmin:zmax, :) = nii.img;
    hd  =spm_vol(resfile);
    hd.dt=[64 0];
    himg1=spm_vol(f2{i});
    hd.mat=himg1.mat;
    hd.dim=size(Yfull);
    d=Yfull;
else
    d=nii.img;
end
% hd.mat=diag(ones(1,4));%TEMPORARE--MIMICHE ERROR IN AFFINE


[~, name, ext]=fileparts(resfile);
newname=[name '_real'  ext ];
fo1=fullfile(tempdir,newname);
rsavenii(fo1,hd,d);
% showinfo2(['NIFTI'],fo1);

% ==============================================
%%   copy file from tempdir to mdir
% ===============================================
if x.copyfiles==1
    fo2=fullfile(mdir,newname);
    copyfile(fo1,fo2,'f');
    showinfo2(['NIFTI'],fo2);
end



% ==============================================
%%   sub--test output
% ===============================================
if 0
    [~,animal]=fileparts(mdir);
    paref=fullfile('H:\Daten-2\Imaging\AG_Penack_ICANS\rocketship',animal)
    
    if isempty(strfind(newname,'post'))
        fi1=fullfile(paref        ,'T1_map_t1_fa_linear_fit_VFA_T1map_real.nii' );
    else
        fi1=fullfile(paref        ,'T1_map_t1_fa_linear_fit_VFA_T1map_post_real.nii' );
    end
    
    fi2=fullfile(tempdir      ,newname);
    
    disp(fi1);
    disp(fi2);
    rmricron([],fi1,fi2,0);
    
    % [ha a]=rgetnii(fi1);
    % [hb b]=rgetnii(fi2);
end
% ==============================================
%%   clean up
% ===============================================
fclose('all');
if x.cleanup==1 %remove temprary folder
    if strcmp(mdir,tempdir)==0
        if exist(tempdir)==7
          rmdir(tempdir,'s')  
        end
    end
end



function rocketship_paths(e,e2)
%% ===============================================
cmd4ui_path='<Select other/own Rocketship-path>';

rs_path={...
    '[win-server] D:\MATLAB\ROCKETSHIP-master_2016\ROCKETSHIP-master' 
    '[win-server] D:\MATLAB\ROCKETSHIP'
    '[paul] F:\data10\rocketship_wrapper\ROCKETSHIP-master'
    cmd4ui_path
    };

[idx,tf] = listdlg('PromptString',{ 'Select Rocketship-path',''},...
    'SelectionMode','single','ListString',rs_path,'ListSize',[450,100]);
if isempty(idx); return; end
tpath=rs_path{idx};
tpath=regexprep(tpath,{'[.*\]\s+','^\s+'},{''});


if strcmp(tpath,cmd4ui_path)
       dn = uigetdir(pwd, 'Select other/own Rocketship-path');
       if isnumeric(dn); return; end
       tpath=dn;
end
paramgui('setdata','x.path_Rocketship',tpath);
return




