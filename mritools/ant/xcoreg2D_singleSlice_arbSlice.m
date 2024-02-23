
%% #b coregister 3D-images using 2D-registration of a single specified slice-slice assignment pair and
%% #b apply transformation parameters to all other slices and apply to other 3D-images.
%
%   #kl IMPORTANT DIFFERENCES
% xcoreg2D_singleSlice_arbSlice  [this function]:
%   -given two 3D-images, a assignment between a single slice of the targetVolume and a single slice
%   of the sourcevolume is made by the user. For example: slice-23 of the targetvolume matches with
%   slice-1 of the sourceVolume. These two slices are extracted and registered (source-slice to target-slice).
%   the 2D registration parameters are than applied to all other slices of the sourceVolume.
%   Optional: 'applyVolumes': if specified, the 2D registration parameters can be applied to additional
%       3D-volumes (must be in the same space as the sourveVolume).
%   -sourcevolume and targetVolume can have different resolutions
%   -sourcevolume and applyVolumes can have different resolutions must must be in the same space
%   -PURPOSE: can be used for different modalities such registration of a single-slice CBF-volume with 't2.nii' (turboRARE)
%
% xcoreg2D_singleSlice [not this function!!!]
% sourcevolume and targetVolume: identical image & HDR-parameters (same resolution)
%   -PURPOSE: can be used for registration of same modalitites such as a sequence of several T1rho-volumes
%
%
%
% TO 3D-3D OR 2D-2D REGISTRATION:
%   #bl    Here, a single (!) corresponding slice of two 3D volumes is used for 2D-registration.
%   #bl    The resulting 2D-registration parameters are than applied to all other slices of the source-volume.
%
%% #ok ___PARAMETER___
% 'targetFile'      -target image (single 3D-NIFTI-file)
% 'sourceFile'      -source image (single 3D-NIFTI-file) which should be registered to the targetFile
% 'applyFile'       -optional: if specified, the 2D registration parameters can be applied to additional
%                    3D-volumes (must be in the same space as the sourveVolume 'sourceFile').
%                    you can use file-filter here: 
%                       example:  '^c_T1rho_2DG' to select all NIFTIS starting with 'c_T1rho_2DG' 
%
%  'targetSlice'     slice of target-file  to register (3rd dimension); default: [1]
%  'sourceSlice'     slice of source-file  to register (3rd dimension); default: [1]
%
%
% 'parameterFiles'  -Elastix-2D-parameter-files
%                   -either rigid,affine or Bspline,
%                   -use a single parameterfile or a set of parmaeterfiles (order is important)
%
% 'interpOrder'     -used image interpolation/interpolation order
%                     [0] nearest neighbour,
%                     [1] bilinear interpolation
%                     [3] spline-interpolation, order 3
%                     'auto' to autodetect interpolation order
%                    -default: 'auto'
%
% 'prefix'          -file prefix of the output file (NIFTI) attached to the original filename
%                   -if empty, the filename-prefix 'c_' is used
%                   -default: 'c_'
%
% 'cleanup'         -do cleanup. Remove temporary processing folder
%                        [0]: no clean up
%                        [1]: clean up level-1: remove processing folder
%                        [2]: clean up level-2: keep processing folder, but delete interim NIFTIS in this folder(s)
%                   -default: [1]
%
% 'isParallel'      -parallel processing
%                     [0] no parallel processing,
%                     [1] parallel processing over animals
%                     [2] parallel processing over applyFiles
%                   -default: [0]
%
%
%% #b ____ADDITIONAL ELASTIX-SPECIFICATIONS____
% [MaximumNumberOfIterations]:  maximum number of iterations, (leave empty to use default iteration from parameter-file)
%     -depending on the number of parameterfiles you can specify the number of iterations for each parameterfile.
%     -These values will override the MaximumNumberOfIterations specified in the parameter-files
%     -examples:
%        [1500]   ...number of iteration for single parameterfile is set to 1500
%        [1000 2000]  ...number of iteration for 1st parameterfile is set to 1000 (example: rigid registration)
%                        whereas the number of iteration for the 2nd parameterfile is set to 2000 (example: affine registration)
%     -default: [], i.e. the default MaximumNumberOfIterations of the parameterfile(s) are used.
%
%
%
%% #ok ___GUI___
% xcoreg2D_singleSlice_arbSlice;       % ... open PARAMETER_GUI, same as xcoreg2D_singleSlice_arbSlice(1);
% xcoreg2D_singleSlice_arbSlice(0,z);  % ...without GUI,  z is the predefined struct
% xcoreg2D_singleSlice_arbSlice(1,z);  % ...wit GUI, z is the predefined struct
%
%
%% #ok ___EXAMPLES___
%% #ba [ EXAMPLE-1]
%% use slice-1 of the 3d-file 'c_T1rho_2DG__001.nii' and rigidly register with slice-23 of 3D-file 't2anat.nii'
%% also apply registration to 'c_T1rho_2DG__002.nii' & 'c_T1rho_2DG__003.nii'
% z=[];
% z.targetFile                = { 't2anat.nii' };                           % % target image  (single 3D-NIFTI-file)
% z.sourceFile                = { 'c_T1rho_2DG__001.nii' };                 % % source images (single 3D-NIFTI-file)
% z.applyFile                 = { 'c_T1rho_2DG__002.nii'                    % % apply images  (single/multiple 3D-NIFTI-files)
%                                 'c_T1rho_2DG__003.nii'   }
% z.targetSlice               = [23];                                       % % slice of target  to register (3rd dimension)
% z.sourceSlice               = [1];                                        % % slice of source  to register (3rd dimension)
% z.parameterFiles            = { which('parameters_Rigid2D.txt') };        % % Elastix-2D-paramer-files (rigid,affine), single or multiple files
% z.interpOrder               = 'auto';                                     % % interpolation: [0] nearest neighbour, [1] bilinear interpolation, [3] spline interpolation, order 3, ["auto"] to autodetect interpolation order
% z.prefix                    = 'c_';                                       % % file prefix of the output file (if empty, "c_" is used  )
% z.cleanup                   = [1];                                        % % do cleanup. Remove temporary processing folder, {0|1|2}; default: [1]
% z.delete_targetSlice        = [1];                                        % %
% z.delete_sourceSlice        = [1];                                        % %
% z.delete_registeredSlice    = [1];                                        % %
% z.isParallel                = [0];                                        % % parallel processing over sourceFile , {0|1|2}; default: [0]
% z.MaximumNumberOfIterations = [];                                         % % number of iterations (if empty use number of iterations as specified in parameter-file)
% xcoreg2D_singleSlice_arbSlice(0,z);



%
%
%% #m RE-USE BATCH: see 'anth' [..anthistory] -variable in workspace
%
%
%



function xcoreg2D_singleSlice(showgui,x,pa)
warning off;

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
% ==============================================
%%   parameter files
% ===============================================


pa_parameterfiles =(fullfile(fileparts(antpath),'elastix','paramfiles','paramfiles2D'));
parameterFiles  ={fullfile(pa_parameterfiles ,'parameters_Rigid2D.txt')} ;


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


param_iterations={...
    'ITERATIONS as specified in parameterfile(s)'                       []
    'SINGLE parameterfile: iteration [1000]'                            [1000]
    'TWO parameterfiles: each with 1000 iterations: [1000 1000]'        [1000 1000]
    'THREE parameterfiles: each with 1000 iterations: [1000 1000 1000]' [1000 1000 1000]
    };


%% ________________________________________________________________________________________________
%%  PARAMETER-gui
%% ________________________________________________________________________________________________
if exist('x')~=1;        x=[]; end

p={...
    'inf1'      '--- Single Slice 2D-COREGESTRATION  ---             '                         '' ''
    'inf100'      [repmat('=',[1,100])]                            '' ''
    %
    'targetFile'      {''}      'target image (single 3D-NIFTI-file)'       {@selector2,li,{'TargetImage'},'out','list','selection','single','position','auto','info','select target-image'}
    'sourceFile'      {''}      'source images (single 3D-NIFTI-file)'     {@selector2,li,{'SourceImage'},'out','list','selection','single','position','auto','info','select one source-image(s)'}
    'applyFile'       {''}      'apply images  (1/more 3D-NIFTI-files)'     {@selector2,li,{'ApplyImages'},'out','list','selection','multi', 'position','auto','info','select one/more apply-image(s)'}
    
    'targetSlice'      1          'slice of target  to register (3rd dimension)'  num2cell(1:30)
    'sourceSlice'      1          'slice of source  to register (3rd dimension)'  num2cell(1:30)
    
    % 'sliceDimension'   3          'slice is taken from this dimension {1|2|3}; default: [3]'  { 1 2 3}
    %---------
    'parameterFiles'   parameterFiles 'Elastix-2D-paramer-files (rigid,affine or Bspline), single or multiple files'  {@getparmfiles }
    
    'interpOrder'  'auto'    'interpolation: [0] nearest neighbour, [1] bilinear interpolation, [3] spline interpolation, order 3, ["auto"] to autodetect interpolation order' {'auto',0,1,2,3,4,5}'
    'prefix'       'c_'       'file prefix of the output file (if empty, "c_" is used  )'   {'c' 'c_'}
    
    'inf2997'     '' '' ''
    'cleanup'      [1]       'do cleanup. Remove temporary processing folder, {0|1|2}; default: [1]'  {0 1 2}
    
    'inf2998'     '' '' ''
    'delete_targetSlice'      [1]   'delete target slice,{0|1}. This interim file is used only for registration'  'b'
    'delete_sourceSlice'      [1]   'delete source slice,{0|1}. This interim file is used only for registration'  'b'
    'delete_registeredSlice'  [1]   'delete registered source slice,{0|1}. This is the interim output of the registration'  'b'
    
    'inf2999'     '' '' ''
    'isParallel'   [0]       'parallel processing: [0] no ; [1] over animals; [2] over applyfiles ; {0|1|2}; default: [0]'  {'no parallel-proc. [0]' [0]; 'parallel-proc. over animals [1]' [1]; 'parallel-proc. over applyfiles [2]' [2] }
    
    
    'inf3000'        ''                           '' ''
    'inf3'  '___ELASTIX_PARAMETER_SPECS___'  ' ' ' '
    'MaximumNumberOfIterations'   []    'number of iterations (if empty use number of iterations as specified in parameter-file)'   param_iterations
    };


p=paramadd(p,x);%add/replace parameter
%     [m z]=paramgui(p,'uiwait',0,'close',0,'editorpos',[.03 0 1 1],'figpos',[.2 .3 .7 .5 ],'title','PARAMETERS: LABELING');

% %% show GUI
if showgui==1
    %hlp=help(mfilename); hlp=strsplit2(hlp,char(10))';
    [m z ]=paramgui(p,'uiwait',1,'close',1,'editorpos',[.03 0 1 1],'figpos',[.15 .3 .7 .4 ],...
        'title',['***REGISTER VOLUME via single specified slice-pair***' '[' mfilename '.m]'],'info',{@uhelp, [mfilename '.m']});
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
    % xmakebatch(z,p, mfilename,isDesktop)
    if isExtPath==0
        xmakebatch(z,p, mfilename,[mfilename '(' num2str(isDesktop) ',z);' ]);
    else
        xmakebatch(z,p, mfilename,[mfilename '(' num2str(isDesktop) ',z,mdirs);' ],pa);
    end
end
% ==============================================
%%   currently fixed parameters
% ===============================================
z.sliceDimension=3;
z.simulate      =0;

%===========================================
%%  sanity checks
%===========================================
z.targetFile  =cellstr(z.targetFile);
z.sourceFile =cellstr(z.sourceFile);
z.applyFile =cellstr(z.applyFile);
parameterFiles=cellstr(parameterFiles);


if isempty(pa)
    error('!NO ANIMAL-DIRS SELECTED....CANCELLED!') ;
end
%===========================================
%%   process: [1] loop over m-dirs
%===========================================
if z.simulate==1
    cprintf('*[0.9294    0.6941    0.1255]',[ 'SIMULATION ONLY: *** 2D-REGISTRATION via REFERENCE-SLICE *** ' '\n'] );
else
    cprintf('*[ 0.3020    0.7451    0.9333]',[ '*** 2D-REGISTRATION via REFERENCE-SLICE ***' '\n'] );
end
timex0=tic;
%% ===============================================
%% parallel over mdirs
%% ===============================================
if z.isParallel==1
    msg2={};
    parfor i=1:length(pa)
        z2     =z;
        z2.mdir=pa{i};
        [~,animal]=fileparts(z2.mdir);
        msg2{i,1}=proc_mdir(z2);
    end
    
    
    
    %% ===============================================
    %% sequential over mdirs
    %% ===============================================
else
    msg2={};
    for i=1:length(pa)
        z2     =z;
        z2.mdir=pa{i};
        
        z2.tempfileParfor=fullfile(z2.mdir,'_tempXcoreg2SParfor.txt');
        try; delete(z2.tempfileParfor) ;end
        if exist(z2.tempfileParfor)==2;
            fclose('all');
            try; delete(z2.tempfileParfor) ;end
        end
        f = fopen(z2.tempfileParfor, 'w');
        fprintf(f, '%d\n', 0); % Save N at the top of progress.txt
        fclose(f);
        
        
        [~,animal]=fileparts(z2.mdir);
        cprintf('*[ 0.3020    0.7451    0.9333]',[ '[' num2str(i) '/' num2str(length(pa)) '] animal: "' animal '"' '\n'] );
        msg2{i,1}=proc_mdir(z2);
        
        try; delete(z2.tempfileParfor) ;end
        if exist(z2.tempfileParfor)==2;
            fclose('all');
            try; delete(z2.tempfileParfor) ;end
        end
    end
end
%% ===============================================

evalin('base', ['clear ' ['log_' mfilename]]); %CLEAR LOG-VARIABLE
if z.simulate==1
    cprintf('*[0.9294    0.6941    0.1255]',[ 'SIMULATION ONLY: 2D-REGISTRATION finished! ' sprintf('(%ct=%0.2fmin)', 916,toc(timex0)/60)  '\n'] );
else
    cprintf('*[0 .5 0]',[ '2D-REGISTRATION finished! ' sprintf('(%ct=%0.2fmin)', 916,toc(timex0)/60)  '\n'] );
    
end
% length(msg2)==1 && isempty(char(msg2)) ||
if  sum(cellfun(@isempty,msg2 ))==length(msg2) %ERRORS OCCURED
    if z.simulate==1
        cprintf('*[0.9294    0.6941    0.1255]',[ 'STATUS: all files seems to be OK.' '\n'] );
    else
        cprintf('*[0 .5 0]',[ 'STATUS: all files processed' '\n'] );
    end
else
    cprintf('*[1 0 1]',[ 'STATUS: some files were not processed--> see variable "' ['log_' mfilename] '" in workspace' '\n'] );
    assignin('base',['log_' mfilename],msg2);
    mg=[' see VARIABLE <a href="matlab: disp(char(' ['log_' mfilename] '));">' [ ['log_' mfilename] ] '</a> to inspect errors.'];
    disp(mg);
end




% ==============================================
%%           [2] loop over source-files
% ===============================================
function msg2=proc_mdir(p0);

%% ----IF regexp-FILTER IS USED
sourcefile=p0.sourceFile;
if length(sourcefile)==1
    sourcefile=char(sourcefile);
    if ~isempty(regexpi(sourcefile,'\^|\$|*'))
        mdir=char(p0.mdir);
        [files] = spm_select('List',mdir,sourcefile);
        p0.sourceFile=cellstr(files);
        p0.sourceFile(find(strcmp(p0.sourceFile,p0.targetFile)))=[];%remove targetFile from list
        p0.sourceFile=natsort(p0.sourceFile); %sort numeric
        disp([ '..using fileFilter: "' sourcefile '"'  ', ' num2str(length(p0.sourceFile))  ' sourceFile were found: ' strjoin(p0.sourceFile,'|') ]);
    end
end

%------------------------------
timex2=tic;
msg={};
% if p0.isParallel==1 && length(p0.sourceFile)>1
%     parfor i=1:length(p0.sourceFile)
%         p            =p0;
%         p.iter       =i;
%         p.niter      =length(p0.sourceFile);
%         p.sourceFile=p0.sourceFile(i);
%         msg{i,1}=proc_register(p);
%     end
% else
for i=1:length(p0.sourceFile)
    p            =p0;
    p.iter       =i;
    p.niter      =length(p0.sourceFile);
    p.sourceFile=p0.sourceFile(i);
    msg{i,1}=proc_register(p);
end
% end

[~, animal]=fileparts(char(p0.mdir));

% if p0.simulate==1
%     cprintf('*[0.9294    0.6941    0.1255]',[ 'SIMULATION: 2D-REGISTRATION finished! ' sprintf('(%ct=%0.2fmin)', 916,toc(timex0)/60)  '\n'] );
% end

if sum(cellfun(@isempty,msg )) ==length(msg)  %everything is OK!!
    showinfo2(['   processed:'],char(p0.mdir));
    cprintf('*[0 .5 0]',[ 'Done animal "' animal '"! ' sprintf('(%ct=%2.2fmin)', 916,toc(timex2)/60)  '\n'] );
    msg2='';
else
    showinfo2(['   could not process!:'],char(p0.mdir));
    cprintf('*[1 0 1]',[ 'ERROR unprocessed animal "' animal '"! ' sprintf('(%ct=%2.2fmin)', 916,toc(timex2)/60)  '\n'] );
    msg(cellfun(@isempty,msg ))=[] ; %remove empty-cells (okish-cells)
    msg2=char(msg);
end

% ==============================================
%%  loop over source-files
% ===============================================
function msg=proc_register(p)

%% ===============================================
px             =char(p.mdir); %mdir
p.target       =fullfile(char(p.mdir),char(p.targetFile));
p.source       =fullfile(char(p.mdir),char(p.sourceFile));

if ischar(p.sliceDimension) || isempty(p.sliceDimension) || ismember(p.sliceDimension,[1:3])==0
    p.sliceDimension=3;
end

% ==============================================
%%
% ===============================================
[paS filenameS extS]=fileparts(p.source );
[paT filenameT extT]=fileparts(p.target );
[~,animal]=fileparts(paS );
cprintf('*[0 0 1]',[ 'ANIMAL' '"' animal ':'  '"'   '\n'] ); %[' num2str(p.iter) '/'  num2str(p.niter) ']'
cprintf('[0 0 1]' ,[ '  [SOURCE]: ' '"' [ filenameS extS] '"; [TARGET]: ' '"' [ filenameT extT] ...
    '"; [TargetSLICE]:' num2str(p.targetSlice) '"; [SourceSLICE]:' num2str(p.sourceSlice) ,...
    '; [SLICE-DIM]:' num2str(p.sliceDimension) '\n'] );

%% =================[progress for parallelport]==============================
try
    f = fopen(p.tempfileParfor, 'a');
    fprintf(f, '1\n');
    fclose(f);
    
    f = fopen(p.tempfileParfor, 'r');
    progress = fscanf(f, '%d');
    fclose(f);
    percent = (length(progress)-1)/p.niter*100;
    % disp(percent);
    disp([ '   progress: '  num2str(length(progress)-1) '/'  num2str(p.niter) ' ' sprintf('(%1.0f%%)', 100*(length(progress)-1)/p.niter) ...
        ' ' [repmat('x',[1 length(progress)-1]) repmat('.',[1 p.niter-[length(progress)-1]]) ] ]);
    
end
%% ===============[check consistency of data]================================
msg={};
% return
if exist(      p.target)==2;
    ha=spm_vol(p.target);
else
    msg{end+1,1}=[ 'ERROR: targetFile missing: "' p.target '"'] ;
    msg{end+1,1}=showinfo2(['    animal:'],paT);
    if ~isempty(msg);  msg=char(msg);     return;   end
end
if exist(      p.source)==2;
    hb=spm_vol(p.source);
else
    msg{end+1,1}=[ 'ERROR: sourceFile missing: "' p.source '"'] ;
    msg{end+1,1}=showinfo2(['    animal:'],paS);
    if ~isempty(msg);  msg=char(msg);     return;   end
end

ck.sameDim=sum([ha(1).dim(1:3)  == hb(1).dim(1:3) ]) ==3;
ck.sameMat=sum(ha(1).mat(:)==hb(1).mat(:))           ==16;




if p.simulate==1
    return
end

%% ===============[get data]================================


timex1=tic;



%% ===========[outputfolders]====================================
% paout=fullfile(px,'temp_reg2D_special');
paout=fullfile(px,['temp_reg2D__' filenameS]);
try; rmdir(paout,'s'); end
if exist(paout)~=7
    mkdir(paout);
end
paoutParamfiles=fullfile(paout,'paramfiles');
if exist(paoutParamfiles)~=7
    mkdir(paoutParamfiles);
end
p.paout=paout;
p.paoutParamfiles=paoutParamfiles;

%% ===============[extract slice]================================

p=getslice(p); %extract slice




%% ===========[parameterfile]====================================
% pa_parameterfiles =(fullfile(fileparts(antpath),'elastix','paramfiles','paramfiles2D'));
% paramFile0        ={fullfile(pa_parameterfiles,'parameters_Rigid2D.txt')};

% paramFile0        ={...
%     fullfile(pa_parameterfiles,'parameters_Rigid2D.txt')
%     fullfile(pa_parameterfiles,'parameters_BSpline2D.txt')
%     };

paramFile0 =p.parameterFiles;
paramFile0 =cellstr(paramFile0);


if ~isempty(p.MaximumNumberOfIterations)
    numberOfIterations=p.MaximumNumberOfIterations;
    if length(paramFile0)>length(numberOfIterations)
        numberOfIterations=repmat(numberOfIterations, [1 length(paramFile0)]);
        disp([' Number of paramerfiles is ' num2str(length(paramFile0)) '. It is expected that also '  ...
            num2str(length(paramFile0)) ' values for the "numberOfIterations" is given!']);
        disp(['--> SOLUTION: numberOfIterations is replicated to match the number of paramerfiles: [' num2str(numberOfIterations) ']'   ]);
    end
end

% set copy paramfiles and set parameter
chk__NO_iterations=[];
for i=1:length(paramFile0)
    [papar parname parext] =fileparts(paramFile0{i});
    paramFile{i,1}=fullfile(paoutParamfiles,[ parname parext] );
    copyfile(paramFile0{i},paramFile{i}, 'f');
    
    set_ix(paramFile{i}, 'ResultImagePixelType' ,'float');
    
    if ~isempty(p.MaximumNumberOfIterations)
        set_ix(paramFile{i}, 'MaximumNumberOfIterations' ,numberOfIterations(i));
    end
    chk__NO_iterations(1,i)=  get_ix(paramFile{i}, 'MaximumNumberOfIterations');
end
disp([ '  ..MaximumNumberOfIterations: ['  num2str(chk__NO_iterations) ']' ]);


% ==============================================
%%   run elastix
% ===============================================
% if 0
%     %% ============Version-1===================================
%     % addpath(genpath('D:\MATLAB\bart\elastix2\matlab_elastix\code'))
%     % cd(fileparts(which('elastix.exe')))
%     % varargout=elastix(movingImage,fixedImage,outputDir,paramFile,varargin)
%     % [v v2]=elastix(bb,aa,paout,paramFile);
%     fprintf('  ..running Elastix..');
%     [logela v v2]=evalc('elastix(bb,aa,paout,paramFile)');
%     %[v v2]=elastix(bb,aa,paout,paramFile);
% end
%% ===============================================
fprintf('  ..running Elastix..');

%  f1=p.target;
%  f2=p.source;
%  [logela v v2]=evalc('elastix(f2,f1,paout,paramFile)');
% (ResultImageFormat "mhd")
% addpath(fileparts(which('run_elastix.m')));
for i=1:length(paramFile)
    set_ix(paramFile{i},'ResultImageFormat','nii');
end

f1=p.targetslice;
f2=p.sourceslice;
[~,imfile,trfile]=evalc('run_elastix(f1,f2,    paout  ,paramFile,   [],[]     ,[],[],[])');
imfile=cellstr(imfile);
p.sourcesliceRegisterd=imfile{end};
trfile=cellstr(trfile);
%% ===============================================
% fisout=cellstr(im)
%  ifile=regexpi2(fisout,'.mhd$')
%  mhdfile=fisout{ifile}
%  v=mhd_read_header(mhdfile)

%% ===============================================

% ==============================================
%%
% ===============================================


h1=spm_vol(f1);
% h2=spm_vol(im)
% h2=spm_vol(f2)
% vh2=spm_imatrix(h2.mat)

f3=p.sourcesliceRegisterd;
[h3 d3]=rgetnii(f3);
f4=stradd(f3,'_modHDR',2);

h4=h1;
% hd2.mat(3,4)=h1.mat(3,4);
% hd2.mat(3,3)=h1.mat(3,3) ;%vh2(9)
% h4.mat=h1.mat;
rsavenii(f4, h4, d3, 64);
showinfo2('saved: ',f1,f4,0);

%% ===============================================




% ==============================================
%%   set transform-parameters
% ===============================================
trafofile=cellstr(trfile);

if ischar(p.interpOrder) && strcmp(p.interpOrder,'auto')
    [hb b]=rgetnii(p.source);
    unib=unique(b(:));
    if sum(unib==round(unib))==length(unib)  ;% integers --> NN-interp
        interpOrder=0;
    else
        interpOrder=1;
    end
else
    interpOrder=p.interpOrder;
end
for i=1:length(trafofile)
    set_ix(trafofile{i}, 'ResultImagePixelType' ,'float');
    set_ix(trafofile{i}, 'FinalBSplineInterpolationOrder' ,interpOrder);
end

% ==============================================
%%  [1] prepare: apply images
% ===============================================
tmpfiles=[];
if ~isempty(char(p.applyFile))
    %% ----IF regexp-FILTER IS USED
    applyFile=cellstr(p.applyFile);
    if length(applyFile)==1 && ~isempty(regexpi(applyFile,'\^|\$|*'))
        applyFile=char(applyFile);
        
        [flt_files] = spm_select('List',px,applyFile);
        flt_files=cellstr(flt_files);
        disp([ '..using fileFilter: "' applyFile '"'  ', ' num2str(length(flt_files))  ...
            ' applyfiles were found: ' strjoin(flt_files,'|') ]);
      tmpfiles=stradd(flt_files,[px filesep]);   
    else
       tmpfiles=stradd(p.applyFile,[px filesep]); 
    end
    
    tmpfiles=tmpfiles(find(existn(tmpfiles)==2)); %check existence of files
end
p.apply=unique(cellstr([p.source; tmpfiles]));
p.trafofile=trafofile;
p.thisAnimalDir=px;
% ==============================================
%%  [2] transform: apply images
% ===============================================
if p.isParallel==2
    parfor ii=1:length(p.apply)
        jj=ii;
        trafo_applyImages(p,jj);
    end
else
    for ii=1:length(p.apply)
        trafo_applyImages(p,ii);
    end
end


% function trafo_applyImages(p)
% % ==============================================
% %%   get applyImages
% % ===============================================
% % [cc,slog] = transformix(bb,v2.TransformParametersFname);
% % [loga ,cc,slog] = evalc('transformix(bb,v2.TransformParametersFname)');
% %applyfile='F:\data8\schönke_2dregistration\dat\20231117PM_hypothermia_2DG_PME000651_2DG\t2anat_slice.nii'
% % applyfile='F:\data8\schönke_2dregistration\dat\20231117PM_hypothermia_2DG_PME000651_2DG\t2anat.nii'
%
% applyfile=p.source;
% hx=spm_vol(applyfile);
%
% fis_a=extract_slice(applyfile,p.paout,'all');  % [1]: extract slice
%
% fis_aT={};
% for i=1:length(fis_a)  % [2]: trasnform slice
%     [~,im4,tr4]=evalc('run_transformix(  fis_a{i} ,[],trafofile{end},   paout ,'''')');
%     fis_aT{i,1}=char(im4);
% end
%
% %% ========[3] recontruct =======================================
% for i=1:length(fis_aT)
%     [hx x]=rgetnii(fis_aT{i});
%     if i==1
%        x2=zeros([size(x) length(fis_aT)]) ;
%     end
%     x2(:,:,i)=x;
% end
% %% ===============================================
% h1=spm_vol(p.target);
%
% [ha a mm ]=rgetnii(p.target);
% ha=ha(1);
% % ix=find(squeeze(sum(sum(a,1),2))~=0)
% aq=repmat(permute(1:size(a,3),[1 3 2]), [size(a,1) size(a,2)  1]);
% aq=aq(:);
% mx=[median(squeeze(mm(3,find(aq==1))))
%     median(squeeze(mm(3,find(aq==max(aq)))))];
% ifin=median(squeeze(mm(3,find(aq==p.targetSlice))));
%
% v1=spm_imatrix(h1.mat);
%
% spacemm=linspace(mx(1),mx(2),h1.dim(3));
% slicenr_zero =vecnearest2(spacemm,0);
% slicenr_target=p.targetSlice;
% % ==============================================
% %%   write nifti
% % ===============================================
% % p.sourceSlice=2
% spacemm_target=spacemm(slicenr_target-p.sourceSlice+1);
%
% % umgekehrt: das 10.slice soll 0 sein --> origin??? % -10*0.75  % 10.slice*voxsize
% coxmm=v1(9);
%
% h2=h1(1);
% h2.mat(3,4)=spacemm_target-coxmm;
% h2.dim(3)=size(x2,3);
%
% % f3=fullfile(px,'test.nii')
% f3=stradd(p.source,p.prefix,1 );
% rsavenii(f3, h2, x2, 64);
%
% f5=p.target;
% showinfo2('saved: ',f5,f3,0);


% ==============================================
%%   keep files
% ===============================================

if p.delete_targetSlice==0
    [~,namex, extx]=fileparts(p.targetslice);
    try; movefile(p.targetslice, fullfile(px, [namex extx  ]),'f'); end
end
if p.delete_sourceSlice==0
    [~,namex, extx]=fileparts(p.sourceslice);
    try; movefile(p.sourceslice, fullfile(px, [namex extx  ]),'f'); end
end
if p.delete_registeredSlice==0
    [~,namex, extx]=fileparts(p.sourceslice);
    try; movefile(p.sourcesliceRegisterd, fullfile(px, [p.prefix namex extx  ]),'f'); end
end


% ==============================================
%%   clearn up
% ===============================================
if p.cleanup==1
    try; rmdir(paout,'s'); end
elseif p.cleanup==2
    try; delete(fullfile(paout,'*.nii')); end
end
%% ===============================================

cprintf('[0 .5 0]',[ 'Done! ' sprintf('(%ct=%0.0fs)', 916,toc(timex1))  '\n'] );





return

function he=getparmfiles(li,lih)

[r x]=paramgui('getdata','x.parameterFiles');

he=x.parameterFiles;
pap=fullfile(fileparts(antpath),'elastix','paramfiles','paramfiles2D');
msg='select 1/more parameter file (order is important)';
[t,sts] = spm_select(inf,'any',msg,'',pap,'.*.txt');
if isempty(t); return; end
t=cellstr(t);
he=t;
% paramgui('setdata','x.wa.elxParamfile',t)
return


function p=getslice(p)

%target
f1=p.target;
[~,name ext]=fileparts(f1);
% f2=stradd(f1 ,'_sliceTarget',2  );
f2=fullfile(p.paout);
slice=p.targetSlice;
p.targetslice=char(extract_slice(f1,f2,slice));

%source
f1=p.source;
% f2=stradd(f1 ,'_sliceSource',2  );
f2=fullfile(p.paout);
slice=p.sourceSlice;
p.sourceslice=char(extract_slice(f1,f2,slice));




function trafo_applyImages(p,ii)
% ==============================================
%%   get applyImages
% ===============================================
% [cc,slog] = transformix(bb,v2.TransformParametersFname);
% [loga ,cc,slog] = evalc('transformix(bb,v2.TransformParametersFname)');
%applyfile='F:\data8\schönke_2dregistration\dat\20231117PM_hypothermia_2DG_PME000651_2DG\t2anat_slice.nii'
% applyfile='F:\data8\schönke_2dregistration\dat\20231117PM_hypothermia_2DG_PME000651_2DG\t2anat.nii'


% make temp_dir and copy trafoFile to this folder
applyfile=p.apply{ii};
[~, fname]=fileparts(applyfile);
tempdir=fullfile(p.thisAnimalDir, ['temp_apply_' fname ]);
if exist(tempdir)~=7; mkdir(tempdir); end
%% ===============================================
%copy trafofile
trafofile=strrep(p.trafofile, p.paout,tempdir);
copyfilem(p.trafofile,trafofile);
%-----if more than one trafofile: change "InitialTransformParametersFileName"
[tpath tname text]=fileparts2(trafofile);
for i=2:length(trafofile)
    prevtrafofile=fullfile(tempdir,[tname{i-1} text{i-1}] );
    %get_ix(trafofile{i}, 'InitialTransformParametersFileName')
    set_ix(trafofile{i}, 'InitialTransformParametersFileName',prevtrafofile) ;
end

%prevous: (InitialTransformParametersFileName "F:\data8\schoenke_2dregistration\dat\20231117PM_hypothermia_2DG_PME000651_2DG\temp_reg2D__c_T1rho_2DG__001\TransformParameters.0.txt")
%now:  (InitialTransformParametersFileName "F:\data8\schoenke_2dregistration\dat\20231117PM_hypothermia_2DG_PME000651_2DG\temp_apply_c_T1rho_2DG__001\TransformParameters.0.txt")

%% ===============================================




fis_a=extract_slice(applyfile,tempdir,'all');  % [1]: extract slice

fis_aT={};
for i=1:length(fis_a)  % [2]: trasnform slice
    %[~,im4,tr4]=evalc('run_transformix(  fis_a{i} ,[],p.trafofile{end},   p.paout ,'''')');
    [~,im4,tr4]=evalc('run_transformix(  fis_a{i} ,[],trafofile{end},   tempdir ,'''')');
    fis_aT{i,1}=char(im4);
end

%% ========[3] recontruct =======================================
hx=spm_vol(applyfile);
for i=1:length(fis_aT)
    [hx x]=rgetnii(fis_aT{i});
    if i==1
        x2=zeros([size(x) length(fis_aT)]) ;
    end
    x2(:,:,i)=x;
end
% ==============================================
%%
% ===============================================
h1=spm_vol(p.target);

[ha a mm ]=rgetnii(p.target);
ha=ha(1);
% ix=find(squeeze(sum(sum(a,1),2))~=0)
aq=repmat(permute(1:size(a,3),[1 3 2]), [size(a,1) size(a,2)  1]);
aq=aq(:);
mx=[median(squeeze(mm(3,find(aq==1))))
    median(squeeze(mm(3,find(aq==max(aq)))))];
ifin=median(squeeze(mm(3,find(aq==p.targetSlice))));

v1=spm_imatrix(h1.mat);

spacemm=linspace(mx(1),mx(2),h1.dim(3));
slicenr_zero =vecnearest2(spacemm,0);
slicenr_target=p.targetSlice;
% ==============================================
%%   write nifti
% ===============================================
% p.sourceSlice=2
spacemm_target=spacemm(slicenr_target-p.sourceSlice+1);

% umgekehrt: das 10.slice soll 0 sein --> origin??? % -10*0.75  % 10.slice*voxsize
coxmm=v1(9);

h2=h1(1);
h2.mat(3,4)=spacemm_target-coxmm;
h2.dim(3)=size(x2,3);

% f3=fullfile(px,'test.nii')
f3=stradd(applyfile,p.prefix,1 );
rsavenii(f3, h2, x2, 64);

%---display overlay
f5=p.target;
showinfo2('saved: ',f5,f3,0);


% ==============================================
%%   clearn up
% ===============================================
if p.cleanup==1
    try; rmdir(tempdir,'s'); end
elseif p.cleanup==2
    try; delete(fullfile(tempdir,'*.nii')); end
end

