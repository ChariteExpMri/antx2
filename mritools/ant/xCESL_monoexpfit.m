
% xCESL_monoexpfit: Estimate voxel-wise R1rho relaxation maps from CESL/T1rho MRI
% data acquired at multiple spin-lock times (TSL).
% BASIC PRINCIPLE
% --------------------------------------------------------------
% For each voxel, the CESL signal decay over spin-lock time
% is modeled using a mono-exponential function:
%       S(TSL) = S0 * exp( -R1rho * TSL )
% where:
%   S(TSL)   = measured CESL signal intensity
%   S0       = estimated signal at TSL = 0
%   R1rho    = relaxation rate in the rotating frame [1/s]
%   TSL      = spin-lock time
% The function estimates one R1rho value for every voxel.
% FITTING OPTIONS
% --------------------------------------------------------------
% Two fitting methods are supported:
%   'linear'
%       Linearized mono-exponential fit using:
%           ln(S) = ln(S0) - R1rho * TSL
%       Advantages:
%           - fast
%           - robust
%       Disadvantages:
%           - slightly biased at low SNR
%   'nonlinear'
%       Direct nonlinear mono-exponential fit:
%           S(TSL) = S0 * exp( -R1rho * TSL )
%       Advantages:
%           - more accurate
%           - statistically preferable
%       Disadvantages:
%           - slower
% INPUT DATA
% --------------------------------------------------------------
% Each CESL map must contain multiple spin-lock times in the
% 3rd dimension:
%       dim1 = x
%       dim2 = y
%       dim3 = TSL dimension
% Example:
%       [220 220 13]
% meaning:
%       220 x 220 image
%       13 spin-lock times
% ==============================================================
% USAGE
% ==============================================================
% xCESL_monoexpfit(showgui,x)
% xCESL_monoexpfit(showgui,x,pa)
% 
% ==============================================================
% INPUT
% ==============================================================
% [showgui]  Show graphical user interface.
%               [1] show GUI
%               [0] no GUI
% [x]       Structure containing processing parameters.
% [pa]      Optional cellstring containing animal paths outside ANTx project structure.
%           Default:  Uses currently selected animals from ANTx GUI.
% ==============================================================
% PARAMETERS (x)
% ==============================================================
% [file]   Input CESL map (3D NIfTI).
%         Example dimensions: [220 220 13]
%         where dim3 corresponds to the different spin-lock times.   
% --------------------------------------------------------------
% [fit_othermaps] Process additional CESL maps belonging to the same series.
%   [1] process all matching files
%   [0] process only selected file
%         Matching is based on:
%           - identical basename
%           - numeric suffixes (001,002,...)
%         Default: [1]
% --------------------------------------------------------------
% [mask] Optional binary brain mask (2D NIfTI slice).
%         Advantages:
%           - accelerates computation
%           - suppresses background fitting
%         Example:   ix_AVGTmask_slice.nii
%         Example dimensions:   [220 220 1]
% --------------------------------------------------------------
% [fitmethod] Mono-exponential fitting method.
%         Options:
%           'linear'
%           'nonlinear'
%         Default:
%           'nonlinear'
% --------------------------------------------------------------
% [TSL] Spin-lock times corresponding to dim3 of the CESL map.
%         Requirements:
%           - number of TSL values must match dim3
%           - order must match dim3 order exactly
%         Input format:
%           - numeric array
%           - string containing numeric values
%         The GUI provides a helper tool to extract TSL values directly
%         from Bruker raw-data parameter files.
% --------------------------------------------------------------
% [TSL_unit] Units of the supplied spin-lock times.
%         Options:
%           's'    seconds
%           'ms'   milliseconds
%           'us'   microseconds
%         Internally all TSL values are converted to seconds before fitting.
%         Notes:
%           - Bruker raw data commonly stores TSL values in 'us'
%           - incorrect units lead to incorrect R1rho values
%         Default: 'us'
% --------------------------------------------------------------
% [outPrefix] Prefix of output R1rho maps.
%         Numeric suffixes (001,002,...) from the input series are  preserved automatically.
%         Example: R1rho_001.nii
%         Default: 'R1rho_'
% --------------------------------------------------------------
% [isparallel] Parallel processing across multiple CESL maps within animal.
%         Options:
%           [1] enable parallel processing
%           [0] disable parallel processing
%         Default: [0]
% 
% ==============================================================
% OUTPUT
% ==============================================================
% Voxel-wise R1rho relaxation maps in units of: [1/s]
% Example typical brain values:  ~5 - 25 1/s
% ==============================================================
% NOTES
% ==============================================================
% - Nonlinear fitting is generally recommended.
% - Late TSL images may contain very low or slightly negative signal values due to MRI noise floor effects.
% - A brain mask is strongly recommended for faster and more stable processing.
% - Resulting maps can optionally be used for deltaR1rho(t) analysis across temporal repetitions.
% ==============================================================
% ANTx HISTORY
% ==============================================================
% Use:   anth
% or:    disp(char(anth))
% to display the last executed command.
% ==============================================================
% 
% ==============================================
%%   EXAMPLES
% ===============================================
%% CESL: nonlineary FIT all CESL-maps corresponding to 'c_c_T1rho_2DG__001.nii' (maps: ..001-035), use a brainmask
%% and parallel processing
% 
% z=[];                                                                                                                                                                                                                          
% z.file          = { 'c_c_T1rho_2DG__001.nii' };                                                          % % single CESL / diffusion map (NIfTI)                                                                               
% z.fit_othermaps = [1];                                                                                   % % fit also all other maps of this series (if available)                                                             
% z.mask          = { 'ix_AVGTmask_slice.nii' };                                                           % % (optional,but prefered):binary brainmask (2D-NIFTI): example "ix_AVGTmask_slice.nii"                              
% z.fitmethod     = 'nonlinear';                                                                           % % fitting method: {linear | nonlinear | nonlinear_constant}                                                         
% z.TSL           = '5000,10000,20000,30000,40000,50000,60000,70000,80000,90000,100000,150000,200000';     % % signal encoding values (TSL for CESL or b-values for diffusion). Must match 3rd dimension                         
% z.TSL_unit      = 'us';                                                                                  % % units of TSL or encoding values: [s] seconds; [ms] milliseconds; [us] microseconds; or none                       
% z.outPrefix     = 'R1rho_';                                                                              % % prefix of resulting file (a  numeric suffix (such as "001" ) is added if found)                                   
% z.isparallel    = [0];                                                                                   % % parallel processing over CESL-maps within animal {0,1}                                                            
% xCESL_monoexpfit(1,z);  
% 
%% CESL: nonlineary FIT WITH Constant, this only, save all paramters (decay,S0,C) in one NIFTI-file
% z=[];                                                                                                                                                                                                                                                          
% z.file          = { 'c_c_T1rho_2DG__001.nii' };                                                                      % % single CESL / diffusion map (NIfTI)                                                                                                   
% z.fit_othermaps = [0];                                                                                               % % fit also all other maps of this series (if available)                                                                                 
% z.mask          = { 'ix_AVGTmask_slice.nii' };                                                                       % % (optional,but prefered):binary brainmask (2D-NIFTI): example "ix_AVGTmask_slice.nii"                                                  
% z.fitmethod     = 'nonlinear_constant';                                                                              % % fitting method: {linear | nonlinear | nonlinear_constant}                                                                             
% z.TSL           = [5000  10000  20000  30000  40000  50000  60000  70000  80000  90000  100000  150000  200000];     % % signal encoding values (TSL for CESL or b-values for diffusion). Must match 3rd dimension                                             
% z.TSL_unit      = 'us';                                                                                              % % units of TSL or encoding values: [s] seconds; [ms] milliseconds; [us] microseconds; or none                                           
% z.outPrefix     = 'R1rho_';                                                                                          % % prefix of resulting file (a  numeric suffix (such as "001" ) is added if found)                                                       
% z.savetype      = [2];                                                                                               % % save: [1] decay parameter only, [2] decay,S0 and C (if available) in SINGLE NIFTI [3] decay,S0 and C (if available), SEPARATE NIFTIs  
% z.isparallel    = [0];                                                                                               % % parallel processing over CESL-maps within animal {0,1}                                                                                
% xCESL_monoexpfit(1,z);  
%% DIFFUSION: nonlineary FIT WITH Constant, save decay-rate,S0,C as separate NIFIs  
% z=[];                                                                                                                                                                                                                                                                     
% z.file          = '03_ADC_map_19F_22.nii';                                                                                      % % single CESL / diffusion map (NIfTI)                                                                                                   
% z.fit_othermaps = [0];                                                                                                          % % fit also all other maps of this series (if available)                                                                                 
% z.mask          = '';                                                                                                           % % (optional,but prefered):binary brainmask (2D-NIFTI): example "ix_AVGTmask_slice.nii"                                                  
% z.fitmethod     = 'nonlinear_constant';                                                                                         % % fitting method: {linear | nonlinear | nonlinear_constant}                                                                             
% z.TSL           = [13.18056512  1009.622548  3010.317768  6010.999112  10011.67604  20012.91999  50015.38817  100018.1697];     % % signal encoding values (TSL for CESL or b-values for diffusion). Must match 3rd dimension                                             
% z.TSL_unit      = 'none';                                                                                                       % % units of TSL or encoding values: [s] seconds; [ms] milliseconds; [us] microseconds; or none                                           
% z.outPrefix     = 'ADC_';                                                                                                       % % prefix of resulting file (a  numeric suffix (such as "001" ) is added if found)                                                       
% z.savetype      = [3];                                                                                                          % % save: [1] decay parameter only, [2] decay,S0 and C (if available) in SINGLE NIFTI [3] decay,S0 and C (if available), SEPARATE NIFTIs  
% z.isparallel    = [0];                                                                                                          % % parallel processing over CESL-maps within animal {0,1}                                                                                
% xCESL_monoexpfit(1,z); 



function xCESL_monoexpfit(showgui,x,pa)


if 0
    
    %% =======[test single CESL-map]======================================== 
    z=[];
    z.file          = { 'c_c_T1rho_2DG__006.nii' };                                                                      % % first CESL-map (NIFTI)
    z.fit_othermaps = [0];                                                                                               % % fit also all other maps of this series
    z.fitmethod     = 'nonlinear';                                                                                       % % fittinng option: {linear|nonlinear}
    z.mask          = { 'ix_AVGTmask_slice.nii' };     % % binary brainmask (2D-NIFTI): example "ix_AVGTmask_slice.nii"
    z.TSL           = [5000  10000  20000  30000  40000  50000  60000  70000  80000  90000  100000  150000  200000];     % % SPIN-LOCK TIMES (number must match 3rd dimensin of CESL-map)
    z.TSL_unit      = 'us';                                                                                              % % units of SPIN-LOCK TIMES: [s] seconds; [ms] milliseconds; [us] microseconds
    xCESL_monoexpfit(1,z);
    %% ==========[test externam path]=======================
    pam='F:\data10\t1roh_monexpfit\dat\2023117PM_hypothermia_2DG'
      z=[];
    z.file          = { 'c_c_T1rho_2DG__006.nii' };                                                                      % % first CESL-map (NIFTI)
    z.fit_othermaps = [0];                                                                                               % % fit also all other maps of this series
    z.fitmethod     = 'nonlinear';                                                                                       % % fittinng option: {linear|nonlinear}
    z.mask          = { 'ix_AVGTmask_slice.nii' };     % % binary brainmask (2D-NIFTI): example "ix_AVGTmask_slice.nii"
    z.TSL           = [5000  10000  20000  30000  40000  50000  60000  70000  80000  90000  100000  150000  200000];     % % SPIN-LOCK TIMES (number must match 3rd dimensin of CESL-map)
    z.TSL_unit      = 'us';                                                                                              % % units of SPIN-LOCK TIMES: [s] seconds; [ms] milliseconds; [us] microseconds
    xCESL_monoexpfit(1,z,pam);
    %% =========[test CESL-map-series]======================================
    z=[];
    z.file          = { 'c_c_T1rho_2DG__001.nii' };                                                                      % % first CESL-map (NIFTI)
    z.fit_othermaps = [1];                                                                                               % % fit also all other maps of this series
    z.fitmethod     = 'nonlinear';                                                                                       % % fittinng option: {linear|nonlinear}
    z.mask          = { 'ix_AVGTmask_slice.nii' };     % % binary brainmask (2D-NIFTI): example "ix_AVGTmask_slice.nii"
    z.TSL           = [5000  10000  20000  30000  40000  50000  60000  70000  80000  90000  100000  150000  200000];     % % SPIN-LOCK TIMES (number must match 3rd dimensin of CESL-map)
    z.TSL_unit      = 'us';                                                                                              % % units of SPIN-LOCK TIMES: [s] seconds; [ms] milliseconds; [us] microseconds
    xCESL_monoexpfit(1,z);
    %% ==========[test: parallel proc]=====================================
    z=[];
    z.file          = { 'c_c_T1rho_2DG__001.nii' };                                                                      % % first CESL-map (NIFTI)
    z.fit_othermaps = [1];                                                                                               % % fit also all other maps of this series
    z.fitmethod     = 'nonlinear';                                                                                       % % fittinng option: {linear|nonlinear}
    z.mask          = { 'ix_AVGTmask_slice.nii' };     % % binary brainmask (2D-NIFTI): example "ix_AVGTmask_slice.nii"
    z.TSL           = [5000  10000  20000  30000  40000  50000  60000  70000  80000  90000  100000  150000  200000];     % % SPIN-LOCK TIMES (number must match 3rd dimensin of CESL-map)
    z.TSL_unit      = 'us';                                                                                              % % units of SPIN-LOCK TIMES: [s] seconds; [ms] milliseconds; [us] microseconds
    z.isparallel    = [1];                                                                                               % % parallel processing over CESL-maps within animal {0,1}
    xCESL_monoexpfit(0,z);
    %% ==========[tets: cesl-file without numeric suffic]=====================================
    z=[];
    z.file          = { 'in.nii' };                                                                      % % first CESL-map (NIFTI)
    z.fit_othermaps = [0];                                                                                               % % fit also all other maps of this series
    z.mask          =[];                           % % (optional,but prefered):binary brainmask (2D-NIFTI): example "ix_AVGTmask_slice.nii"
    z.fitmethod     = 'nonlinear';                                                                                       % % fittinng option: {linear|nonlinear}
    z.TSL           = [5000  10000  20000  30000  40000  50000  60000  70000  80000  90000  100000  150000  200000];     % % SPIN-LOCK TIMES (number must match 3rd dimensin of CESL-map)
    z.TSL_unit      = 'us';                                                                                              % % units of SPIN-LOCK TIMES: [s] seconds; [ms] milliseconds; [us] microseconds
    z.outPrefix     = 'out';                                                                                          % % prefix of resulting file (if found numeric suffix such as "001" is added)
    z.isparallel    = [0];                                                                                               % % parallel processing over CESL-maps within animal {0,1}
    xCESL_monoexpfit(0,z);
    %% ===============================================
    
    
    
end





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
        if ischar(files); files=cellstr(files);   end;
        fis=strrep(files,[pa{i} filesep],'');
        fi2=[fi2; fis];
    end
    li=unique(fi2);
end


% get bruker-reader-function from 'xCESL_monoexpfit_showfit'
fromBrukerrawfile2=xCESL_monoexpfit_showfit('getfun_fromBrukerrawfile') ;
%% ________________________________________________________________________________________________
%%  PARAMETER-gui
%% ________________________________________________________________________________________________
if exist('x')~=1;        x=[]; end

p={...
    'inf1'      '--- CESL monoexponential fit   ---             '                         '' ''
    'inf2'      'estimating an R1ρ relaxation map from series of CESL images acquired at different spin-lock times(TSL)', '' ''
    'inf3'      [repmat('_',[1,100])]                            '' ''
    
    'file'              ''           'single CESL / diffusion map (NIfTI)'     {@selector2,li,{'CESL-map'},'out','list','selection','single','position','auto','info','select first CESL-image'}
    'fit_othermaps'     1            'fit also all other maps of this series (if available)'  'b'
    'mask'              ''           '(optional,but prefered):binary brainmask (2D-NIFTI): example "ix_AVGTmask_slice.nii" '   {@selector2,li,{'brain-mask'},'out','list','selection','single','position','auto','info','selectbrain-mask (slice)'}
    'fitmethod'         'nonlinear'  'fitting method: {linear | nonlinear | nonlinear_constant}'   {'linear' 'nonlinear' 'nonlinear_constant'}
    'TSL'               []           'signal encoding values (TSL for CESL or b-values for diffusion). Must match 3rd dimension'   {fromBrukerrawfile2}
    'TSL_unit'         'us'          'units of TSL or encoding values: [s] seconds; [ms] milliseconds; [us] microseconds; or none'  {'s' 'ms' 'us' 'none'}
    
    'inf4'      [repmat(' ',[1,100])]                            '' ''
    
    'outPrefix'    'R1rho_'         'prefix of resulting file (a  numeric suffix (such as "001" ) is added if found)' {'R1rho_' 'ADC_' 'decayrate_' 'RR_'}
    'savetype'      [1]             'save: [1] decay parameter only, [2] decay,S0 and C (if available) in SINGLE NIFTI [3] decay,S0 and C (if available), SEPARATE NIFTIs  '  {1, 2, 3}
    'isparallel'    [0]             'parallel processing over CESL-maps within animal {0,1}' 'b'
    

    
    };


p=paramadd(p,x);%add/replace parameter
if showgui==1
    [m z ]=paramgui(p,'uiwait',1,'close',1,'editorpos',[.03 0 1 1],'figpos',[ 0.2542    0.3200    0.5389    0.3367 ],...
        'title',['***CESL monoexponential fit***' '[' mfilename '.m]'],'info',{@uhelp, [mfilename '.m']});
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
% return
% ==============================================
%%

z.file=cellstr(z.file);
z.mask=cellstr(z.mask);


%% ======[proc]=========================================
% ==============================================
%% loop OVER animals:
% ===============================================
tic1=tic;
for i=1:length(pa)
    [~,animal]=fileparts(pa{i});
    tic2=tic;
    cprintf('[0 0 1]',['[' num2str(i) '/' num2str(length(pa)) '] ' animal '\n']);
    proc_anmal(z,pa{i},i)
    cprintf('[0 0 1]',['..DONE (' animal '). ET:' sprintf('%2.1fmin',toc(tic2)/60)  '\n']);
end
cprintf('*[0 .5 0]',['DONE. ET:' sprintf('%2.1fmin',toc(tic1)/60)  '\n']);



function  proc_anmal(z,pam,iter)
% get otherCESL-maps if requested
[~,z.rooutname]=fileparts(z.file{1});
fi=char(z.file);
[numstr isep] = regexp(fi,'\d+(?=\.[^.]+$)','match','once');
if ~isempty(isep)
    nametag=['^' fi(1:isep-1)  '.*.nii'];
    z.rooutname=fi(1:isep-1);
end

if z.fit_othermaps==1
    fi=char(z.file);
    %tok = regexp(fi,'(\d+)(?=\.[^.]+$)','tokens')
    %[numstr isep] = regexp(fi,'\d+(?=\.[^.]+$)','match','once');
    if ~isempty(isep)
        %nametag=['^' fi(1:isep-1)  '.*.nii'];
        %z.rooutname=fi(1:isep-1);
        [fis] = spm_select('List',pam,nametag);
        fis=cellstr(fis);
    else
        fis=cellstr(z.file);
    end
else
    fis=cellstr(z.file);
end



% ==============================================
%% loop OVER maps:   parfor here
% ===============================================
if z.isparallel==1
    parfor i = 1:length(fis)
        file = fis{i};
        procmap_wrapper(file,pam,z)
    end
else
    for i=1:length(fis)
        file=fis{i};
        procmap_wrapper(file,pam,z)
    end
end



function procmap_wrapper(file,pam,z)
%% ======[get data]=========================================
f1=fullfile(pam, file);
[ha a]=rgetnii(f1);  % [220 220 13]

ismask_ok=0;
if ~isempty(regexpi2({char(z.mask)},'=|<|>')) % using threshold
    try
    eval([  'm=a(:,:,1)' char(z.mask) ';'])
     a=a.*double(repmat(m,[1 1 size(a,3)]));
     ismask_ok=1;
    end 
else
    fm=fullfile(pam, char(z.mask));
    if ~isempty(char(z.mask)) && exist(fm)==2
        [hm m]=rgetnii(fm);  % [220 220 1]
        a=a.*repmat(m,[1 1 size(a,3)]);
        ismask_ok=1;
    end
end




% % using mask
% fm=fullfile(pam, char(z.mask));
% if ~isempty(char(z.mask)) && exist(fm)==2
%     [hm m]=rgetnii(fm);  % [220 220 1]
%     a=a.*repmat(m,[1 1 size(a,3)]);
% end
%% =========[fit ]======================================
procmap=xCESL_monoexpfit_showfit('getfun_procmap');
[w]=procmap(a,z);

%% ===========[save NIFTI]====================================
suffix=strrep(file, z.rooutname,''); %pure numeric

fo3=fullfile(pam, [ z.outPrefix  suffix ]);
if exist(fo3)==2
    try; delete(fo3); end
end

if z.savetype==1
    % ==== only decay-parameter( R1rho) ===========================================
    hc=ha;
    hc.dim=[ha.dim(1:2) 1];
    rsavenii(fo3, hc,  w.R1rho);
    showinfo2(' ..new file',fo3);
elseif z.savetype==2
    % ======[ as 3D with all parameters  ]=========================================
    r=cat(3, w.R1rho, w.S0map);
    ht='R1rho,S0';
    if isfield(w,'Cmap')==1
        r=cat(3, r, w.Cmap);
        ht=[ht ',C'];
    end
    ht=[ht ,[',[TSL]' regexprep(num2str(w.TSL),'\s+',',') ]];
    hc=ha;
    hc.dim=[ha.dim(1:2) size(r,3)];
    hc.descrip=ht;
    rsavenii(fo3, hc,  r);
    showinfo2(' ..new file',fo3);
elseif z.savetype==3 %all parameters, separate files
    r=cat(3, w.R1rho, w.S0map);
    ht={'R1rho' 'S0'};
    if isfield(w,'Cmap')==1
        r=cat(3, r, w.Cmap);
        ht=[ht 'C'];
    end 
    [~, suffix2 , ext]=fileparts(suffix);
    for i=1:size(r,3)       
        hc=ha;
        hc.dim=[ha.dim(1:2) 1];
        hc.descrip=['[TSL]' regexprep(num2str(w.TSL),'\s+',',') ];
        fo3=fullfile(pam, [ z.outPrefix  suffix2  '_' ht{i}  ext ]);
        try; delete(fo3); end
        rsavenii(fo3, hc,  r(:,:,i));
        showinfo2(' ..new file',fo3);
        
    end   
end






%% ===============================================
% 
% function  procmap_old(file,pam,z)
% 
% fitmethod = z.fitmethod;% 'nonlinear';% OPTIONS: 'linear'  'nonlinear'
% %
% % pam='H:\Daten-2\Imaging\AG_Mergenthaler\2DG_CEST_Manuskript\dat\2023117PM_hypothermia_2DG_PME000652_2DG'
% % f1=fullfile(pam,'c_c_T1rho_2DG__002.nii');%input
% % fm=fullfile(pam,'ix_AVGTmask_slice.nii');%mask
% %% ===============================================
% f1=fullfile(pam, file);
% [ha a]=rgetnii(f1);  % [220 220 13]
% 
% %% using mask
% fm=fullfile(pam, char(z.mask));
% if ~isempty(char(z.mask)) && exist(fm)==2
%     [hm m]=rgetnii(fm);  % [220 220 1]
%     a=a.*repmat(m,[1 1 size(a,3)]);
% end
% %% ===============================================
% % ============================================================
% % CESL / T1rho mono-exponential fitting
% % MATLAB 2016 + SPM version
% % ------------------------------------------------------------
% % DATA ASSUMPTION
% % ------------------------------------------------------------
% % One NIfTI file contains:
% %   dim1 = x direction
% %   dim2 = y direction
% %   dim3 = different spin-lock times (TSL)
% % Example:
% %   size(a) = [128 128 13]
% % meaning:
% %   128 x 128 image
% %   13 spin-lock times
% % ------------------------------------------------------------
% % BASIC CESL / T1rho SIGNAL EQUATION
% % ------------------------------------------------------------
% % The MRI signal decreases exponentially with increasing
% % spin-lock time:
% %   S(TSL) = S0 * exp( -R1rho * TSL )
% % where:
% %   S(TSL)   = measured MRI signal
% %   S0       = estimated signal at TSL = 0
% %   R1rho    = relaxation rate
% %   TSL      = spin-lock time
% % ------------------------------------------------------------
% % WHY WE USE THE LOGARITHM
% % ------------------------------------------------------------
% % Exponential fitting is harder than linear fitting.
% % Therefore we transform the equation:
% %   ln(S) = ln(S0) - R1rho * TSL
% % This is now:
% %   y = b + m*x
% % where:
% %   y = ln(S)
% %   b = ln(S0)
% %   m = -R1rho
% % Therefore:
% %   slope = -R1rho
% % ------------------------------------------------------------
% % IMPORTANT UNIT NOTE
% % ------------------------------------------------------------
% % TSL values MUST be in SECONDS.
% % Example:
% %   5 ms  = 0.005 sec
% % Otherwise R1rho values become wrong by factor 1000.
% % ============================================================
% 
% % ============================================================
% % DEFINE SPIN-LOCK TIMES
% % ============================================================
% % IMPORTANT:
% % These must correspond EXACTLY to the order of the
% % 13 volumes in dim3.
% % Example only:
% % Replace with your real TSL values.
% % Units = seconds
% % ============================================================
% % TSL_microseconds = [ ...
% %      5000 ...
% %     10000 ...
% %     20000 ...
% %     30000 ...
% %     40000 ...
% %     50000 ...
% %     60000 ...
% %     70000 ...
% %     80000 ...
% %     90000 ...
% %    100000 ...
% %    150000 ...
% %    200000 ];
% % % convert µs -> seconds
% % TSL = TSL_microseconds / 1e6;
% 
% %% ===============================================
% 
% TSL_au=z.TSL;
% if ~isnumeric(TSL_au)
%     TSL_au=str2num(TSL_au);
% end
% TSL_au=TSL_au(:)';
% switch z.TSL_unit
%     case {'seconds' 's'}
%         factor = 1;
%     case {'milliseconds' 'ms'}
%         factor = 1e3;
%     case {'microseconds' 'us'}
%         factor = 1e6;
% end
% TSL = TSL_au / factor;  % this is TSL in seonds
% 
% 
% 
% 
% 
% 
% %% ===============================================
% 
% % ============================================================
% R1rho = zeros(size(a,1), size(a,2));%This map will contain one fitted R1rho value
% S0map = zeros(size(a,1), size(a,2)); % OPTIONAL: STORE S0 MAP,S0 is the fitted signal intensity at TSL = 0.,Usually not used further, but helpful for debugging.
% % ============================================================
% % LOOP OVER ALL VOXELS
% % ============================================================
% for x = 1:size(a,1)
%     for y = 1:size(a,2)
%         s = squeeze(a(x,y,:));% EXTRACT SIGNAL DECAY CURVE
%         %s = s(:);
%         
%         if all(s == 0)  % SKIP INVALID VOXELS (outside mask)
%             continue
%         end
%         % ====================================================
%         % LINEARIZED FIT: ln(S) = ln(S0) - R1rho * TSL
%         % ====================================================
%         if strcmp(fitmethod,'linear')
%             if any(s <= 0)  % SKIP INVALID VOXELS -->due to log
%                 continue
%             end
%             
%             logS = log(s);   % log transform
%             p = polyfit(TSL, logS', 1);  % linear regression
%             R1rho(x,y) = -p(1); % slope = -R1rho
%             S0map(x,y) = exp(p(2));  % intercept = ln(S0)
%         end
%         % ====================================================
%         % NONLINEAR MONOEXPONENTIAL FIT
%         % ====================================================
%         % fits: S = S0 * exp( -R1rho * TSL ) using least squares optimization.
%         if strcmp(fitmethod,'nonlinear')
%             % INITIAL START VALUES;Optimization needs initial guesses.
%             % parameter vector: p(1) = S0; p(2) = R1rho
%             % p0 = [ max(s) 15 ];
%             p0 = [ max(s) 1/mean(TSL) ];
%             
%             % ERROR FUNCTION:
%             % Computes: sum of squared residuals
%             % residual = measured signal - predicted signal
%             errfun = @(p) sum(( s' - p(1) * exp( -p(2) * TSL )).^2);
%             %   errfun = @(p) sum(( s - p(1) * exp( -p(2) * TSL )).^2);
%             
%             % RUN OPTIMIZATION: fminsearch searches parameter values to minimize error function
%             pfit = fminsearch(errfun, p0);
%             S0map(x,y) = pfit(1);
%             R1rho(x,y) = pfit(2);
%         end
%     end
% end
% %% ===========[save NIFTI]====================================
% % isep=max(strfind(file,'_'));
% % suffix=file(isep:end);
% % outnameprefix='R1rho';
% suffix=strrep(file, z.rooutname,''); %pure numeric
% 
% 
% fo3=fullfile(pam, [ z.outPrefix  suffix ]);
% if exist(fo3)==2
%     try; delete(fo3); end
% end
% hc=ha;
% hc.dim=[ha.dim(1:2) 1];
% rsavenii(fo3, hc,  R1rho);
% showinfo2('R1rho-map',fo3);
% 




%% ===============================================

% function o=old____fromBrukerrawfile(e,e2)
% o=[];
% %% ===============================================
% sel='';
% wd=pwd;
% mesg='select TSL-file (BrukerData)';
% [t,sts] = spm_select(1,'any',mesg,sel,wd);
% if isempty(t); return; end
% 
% try;
%     a=preadfile(t); a=a.all;
%     a(cellfun(@isempty,a))=[];
%     a=(strjoin((a),','));
%     %     a=str2num(a);
%     o=a;
% end
% %% ===============================================



% function confirm_patrick
% % just a snip to copy/modify
% %% ===============================================
% 
% cf
% pam='F:\data10\t1roh_monexpfit\dat\2023117PM_hypothermia_2DG'
% 
% numstr=pnum(1,3)
% 
% [ha a]=rgetnii(fullfile(pam,['R1rho_' numstr '.nii']));
% [hb b]=rgetnii(fullfile(pam,['checkR1rho_' numstr '.nii']));
% [hm m]=rgetnii(fullfile(pam,'ix_AVGTmask_slice.nii'));
% 
% fg,imagesc(a); colorbar
% fg,imagesc(b); colorbar
% 
% av=a(m==1);
% rv=b(m==1);
% dv=av-rv;
% 
% 
% disp('values of inbrain-only R1rho map');
% disp('min,max,mean,median, std');
% disp([min(av(:)) max(av(:)) mean(av(:)) median(av(:))  std(av(:))]);
% 
% disp('values of inbrain-only R1rho-map from colleague');
% disp('min,max,mean,median, std');
% disp([min(rv(:)) max(rv(:)) mean(rv(:)) median(rv(:))  std(rv(:))]);
% 
% disp('difference of inbrain-only R1rho-map with colleague''s ');
% disp('min,max,mean,median, std');
% disp([min(dv(:)) max(dv(:)) mean(dv(:)) median(dv(:))  std(dv(:))]);
% 




%% ===============================================








