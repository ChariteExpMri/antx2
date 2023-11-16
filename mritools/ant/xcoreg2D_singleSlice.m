
%% #b coregister 3D-images using 2D-registration of a specified slice and
%% #b apply transformation parameters to all other slices. 
% 
%   #kl IMPORTANT DIFFERENCES TO 3D-3D OR 2D-2D REGISTRATION:                                                
%   #bl    Here, a single (!) corresponding slice of two 3D volumes is used for 2D-registration.              
%   #bl    The resulting 2D-registration parameters are than applied to all other slices of the source-volume.
% 
%% #ok ___PARAMETER___
% 'targetFile'      -target image (single 3D-NIFTI-file)  
% 'sourceFiles'     -one or more source images (3D-NIFTI-files) which should be registered to the targetFile
%                   -target and source-images must have the same header-parameters and image parameters 
%                    i.e. similar header-matrix & same image-size
% 
%                   -ALTERNATIVE: use file-filter (regexp)
%                        examples: '^T1rho_2DG.*.nii'  --> all NIFTI-files starting with 'T1rho_2DG'
%                                  '.*_post.nii$'      --> all NIFTI-files ending with '_post.nii'
%                    
% 'slice'           -slice  which is used for registration
%                   -currently supports only a slice from the 3rd dimension
%                   -The estimated registration parameters will than be applied to the other slices
%                   -default slice: 1, i.e. the 1st slice
% 'sliceDimension'  -The slice for registration is taken from this dimension 
%                   -options: {1|2|3}; 
%                   -default: [3] , i.e. slice is taken from 3rd dimension 
%                    
% 'parameterFiles'  -Elastix-2D-parameter-files
%                   -either rigid,affine or Bspline,
%                   -use a single parameterfile or a set of parmaeterfiles (order is important)
%                    
% 'interpOrder'     -iused image nterpolation/interpolation order
%                     [0] nearest neighbour, 
%                     [1] bilinear interpolation
%                     [3] spline-interpolation, order 3 
%                     'auto' to autodetect interpolation order
%                   -default: 'auto'
%              
% 'prefix'          -file prefix of the output file (NIFTI) attached to the original filename 
%                   -if empty, the filename-prefix 'c_' is used
%                   -default: 'c_'    
%                     
% 'cleanup'         -do cleanup. Remove temporary processing folder 
%                        [0]: no clean up 
%                        [1]: clean up level-1: remove processing folder
%                        [2]: clean up level-2: keep processing folder, but delete "mhd"- & "raw"-files
%                   -default: [1]
%                   
% 'isParallel'      -parallel processing over sourceFiles
%                     [0] no parallel processing, 
%                     [1] parallel processing
%                   -default: [0]
% 
% 'simulate'        -simulate process: i.e. check existence of sourceFiles and targetFile &
%                    check whether header-mat and dimensions are similar
%                   -if [0]: simulate only; if [1]: rgister images 
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
% xcoreg2D_singleSlice;       % ... open PARAMETER_GUI, same as xcoreg2D_singleSlice(1);  
% xcoreg2D_singleSlice(0,z);  % ...without GUI,  z is the predefined struct 
% xcoreg2D_singleSlice(1,z);  % ...wit GUI, z is the predefined struct 
% 
% 
%% #ok ___EXAMPLES___
% % % #ba [ EXAMPLE-1]
% % % Two images ("..post2DG_39.." & "..post2DG_40..") are registered to the target-image ("..pre2DG_6..") 
% % % using the information from slice-1. For this, rigid registration is used with an interpolation
% % % that is automatically detected (here: Bspline-interpolation, order-3). The transformation parameters are than
% % % applied to all other slices of the 3rd dimension of the source-images. The output is written with file name
% % % prefix "c"; afterwards clean up is done. Processing over the multiple source-files is parallelized.  
% z=[];                                                                                                                                                                                                                                                     
% z.targetFile     = { '05_01_T1rho_pre2DG_6_1.nii' };                                                   % % target image (single 3D-NIFTI-file)                                                                                                            
% z.sourceFiles    = { '05_34_T1rho_post2DG_39_1.nii'                                                    % % source images (1/more 3D-NIFTI-files)                                                                                                          
%                      '05_35_T1rho_post2DG_40_1.nii' };                                                                                                                                                                                                    
% z.slice          = [1];                                                                                % % slice  to register (3rd dimension), registration parameter will be applied to the other slices                                                 
% z.parameterFiles = { 'f:\antx2\mritools\elastix\paramfiles\paramfiles2D\parameters_Rigid2D.txt' };     % % Elastix-2D-paramer-files (rigid,affine or Bspline), single or multiple files                                                                   
% z.interpOrder    = 'auto';                                                                             % % interpolation: [0] nearest neighbour, [1] bilinear interpolation, [3] spline interpolation, order 3, ["auto"] to autodetect interpolation order
% z.prefix         = 'c';                                                                                % % file prefix of the output file (if empty, "c" is used  )                                                                                       
% z.cleanup        = [1];                                                                                % % do cleanup. Remove temporary processing folder, {0|1}; default: [1]                                                                            
% z.isParallel     = [1];                                                                                % % parallel processing over sourceFiles , {0|1}; default: [0]                                                                                     
% xcoreg2D_singleSlice(1,z);                                                                            % % run function with GUI.
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
    'targetFile'       {''}      'target image (single 3D-NIFTI-file)'       {@selector2,li,{'TargetImage'},'out','list','selection','single','position','auto','info','select target-image'}
    'sourceFiles'      {''}      'source images (1/more 3D-NIFTI-files)'     {@selector2,li,{'SourceImage'},'out','list','selection','multi','position','auto','info','select one/more source-image(s)'}
    
    'slice'            1          'slice  to register (3rd dimension), registration parameter will be applied to the other slices'  {1 2 3 }
    'sliceDimension'   3          'slice is taken from this dimension {1|2|3}; default: [3]'  { 1 2 3} 
    %---------
    'parameterFiles'   parameterFiles 'Elastix-2D-paramer-files (rigid,affine or Bspline), single or multiple files'  {@getparmfiles }

    'interpOrder'  'auto'    'interpolation: [0] nearest neighbour, [1] bilinear interpolation, [3] spline interpolation, order 3, ["auto"] to autodetect interpolation order' {'auto',0,1,2,3,4,5}'
    'prefix'       'c_'       'file prefix of the output file (if empty, "c_" is used  )'   {'c' 'c_'} 
    'cleanup'      [1]       'do cleanup. Remove temporary processing folder, {0|1|2}; default: [1]'  {0 1 2}     
    'isParallel'   [0]       'parallel processing over sourceFiles , {0|1}; default: [0]'   'b'
    
    'inf2999'     '' '' ''
    'simulate'     [0]       'simulate only (check existence of files,similar header-mat and dimensions) , {0|1}; default: [0]'   'b'

    
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
        'title',['***REGISTER VOLUME via single specified slice***' '[' mfilename '.m]'],'info',{@uhelp, [mfilename '.m']});
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


%===========================================
%%  sanity checks
%===========================================
z.targetFile  =cellstr(z.targetFile);
z.sourceFiles =cellstr(z.sourceFiles);
parameterFiles=cellstr(parameterFiles);

%===========================================
%%   process: [1] loop over m-dirs
%===========================================
if z.simulate==1
    cprintf('*[0.9294    0.6941    0.1255]',[ 'SIMULATION ONLY: *** 2D-REGISTRATION via REFERENCE-SLICE *** ' '\n'] );
else
    cprintf('*[ 0.3020    0.7451    0.9333]',[ '*** 2D-REGISTRATION via REFERENCE-SLICE ***' '\n'] );
end
timex0=tic;

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
sourcefile=p0.sourceFiles;
if length(sourcefile)==1
    sourcefile=char(sourcefile);
    if ~isempty(regexpi(sourcefile,'\^|\$|*'))
        mdir=char(p0.mdir);
        [files] = spm_select('List',mdir,sourcefile);
        p0.sourceFiles=cellstr(files);
        p0.sourceFiles(find(strcmp(p0.sourceFiles,p0.targetFile)))=[];%remove targetFile from list
        p0.sourceFiles=natsort(p0.sourceFiles); %sort numeric
        disp([ '..using fileFilter: "' sourcefile '"'  ', ' num2str(length(p0.sourceFiles))  ' sourcefiles were found: ' strjoin(p0.sourceFiles,'|') ]);
    end
end

%------------------------------
timex2=tic;
msg={};
if p0.isParallel==1 && length(p0.sourceFiles)>1
    parfor i=1:length(p0.sourceFiles)
        p            =p0;
        p.iter       =i;
        p.niter      =length(p0.sourceFiles);
        p.sourceFiles=p0.sourceFiles(i);
        msg{i,1}=proc_register(p);
    end
else
    for i=1:length(p0.sourceFiles)
        p            =p0;
        p.iter       =i;
        p.niter      =length(p0.sourceFiles);
        p.sourceFiles=p0.sourceFiles(i);
        msg{i,1}=proc_register(p);
    end 
end

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


% ==============================================
%%
% ===============================================
% disp(char(p.sourceFiles));
% 
% return
% cd('F:\data7\ag_mergenthaler_singleSlice\dat\m1');
% px='F:\data7\ag_mergenthaler_singleSlice\dat\m1';
% 
% [files] = spm_select('List',px,'^0.*2DG.*.nii');
% files=cellstr(files);

% f1=fullfile(px,files{1} )  ;%target
% f2=fullfile(px,files{end}) ; %source


% ==============================================
%%   
% ===============================================



% pa_parameterfiles =(fullfile(fileparts(antpath),'elastix','paramfiles','paramfiles2D'));
% p.parameterFiles  ={fullfile(pa_parameterfiles ,'parameters_Rigid2D.txt')} ;
%% ===============================================
px             =char(p.mdir); %mdir
p.target       =fullfile(char(p.mdir),char(p.targetFile));
p.source       =fullfile(char(p.mdir),char(p.sourceFiles));

if ischar(p.sliceDimension) || isempty(p.sliceDimension) || ismember(p.sliceDimension,[1:3])==0
    p.sliceDimension=3;
end

% ==============================================
%%   
% ===============================================
[paS filenameS extS]=fileparts(p.source );
[paT filenameT extT]=fileparts(p.target );
[~,animal]=fileparts(paS );
cprintf('*[0 0 1]',[ 'ANIMAL' '"' animal ':'  '" [' num2str(p.iter) '/'  num2str(p.niter) ']'  '\n'] );
cprintf('[0 0 1]' ,[ '  [SOURCE]: ' '"' [ filenameS extS] '"; [TARGET]: ' '"' [ filenameT extT] ...
    '"; [SLICE]:' num2str(p.slice) '; [SLICE-DIM]:' num2str(p.sliceDimension) '\n'] );

%% =================[progress for parallelport]==============================
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

if ck.sameDim~=1
    msg{end+1,1}=['ERROR: dim-mismatch targetFile/sourceFile: ' ['DIM [' regexprep(num2str(ha(1).dim(1:3)),'\s+', ' ') ']' ' vs ' '[' regexprep(num2str(hb(1).dim(1:3)),'\s+', ' ') ']'] ] ;
    msg{end+1,1}=['    animal: "' animal '"'] ;
    msg{end+1,1}=showinfo2(['    targetFile:'],p.target);
    msg{end+1,1}=showinfo2(['    sourceFile:'],p.source);
end
if ck.sameMat~=1
    msg{end+1,1}=['ERROR: header-matrix-mismatch targetFile/sourceFile: '] ;
    msg{end+1,1}=['    animal: "' animal '"'] ;
    msg{end+1,1}=showinfo2(['    targetFile:'],p.target);
    msg=[msg; plog([],[ ha(1).mat ],0,'','al=2;plotlines=0;ind=10;' )];
    msg{end+1,1}=showinfo2(['    sourceFile:'],p.source);
    msg=[msg; plog([],[ hb(1).mat ],0,'','al=2;plotlines=0;ind=10;' )];
end

% char(msg)

if ~isempty(msg);  msg=char(msg);     return;   end


if p.simulate==1
   return 
end

%% ===============[get data]================================


timex1=tic;
[ha a0]=rgetnii(p.target);  % TARGET
[hb b0]=rgetnii(p.source);  % SOURCE




% if sum([ha(1).dim(1:3)  == hb(1).dim(1:3) ])
    
    
    



%% ============[permute DIMs, such that slice is internally taken from last dim]===================================
% p.sliceDimension=p.sliceDimension;
dimPerm    =[setdiff([1:3],p.sliceDimension) p.sliceDimension];
a=permute(a0,dimPerm);
b=permute(b0,dimPerm);

a2=ipermute(a,dimPerm);
b2=ipermute(b,dimPerm);
% montage2(b2)
%% ===============================================

aa=a(:,:,p.slice) ;    
bb=b(:,:,p.slice) ;
%% ==========[add path]=====================================
% pa_melastixcode='F:\data7\ag_mergenthaler_singleSlice\matlab_elastix\code'
pa_melastixcode=(fullfile(fileparts(antpath),'elastix','melastix','code'));
if isempty(which('elastix.m'))
    addpath(genpath(pa_melastixcode));
end

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

%% ============Version-1===================================
% addpath(genpath('D:\MATLAB\bart\elastix2\matlab_elastix\code'))
% cd(fileparts(which('elastix.exe')))
% varargout=elastix(movingImage,fixedImage,outputDir,paramFile,varargin)
% [v v2]=elastix(bb,aa,paout,paramFile);
fprintf('  ..running Elastix..');
 [logela v v2]=evalc('elastix(bb,aa,paout,paramFile)');
%[v v2]=elastix(bb,aa,paout,paramFile);

if 0
    %% ===============Version-2=================================
    %addpath(genpath('D:\Paul\data3\matlab_elastix\code2'));
    %cd(fileparts(which('elastix.exe')))
    
    clear q
    q.Transform='EulerTransform';%'AffineTransform';
    q.MaximumNumberOfIterations=1%1.5E3;
    % q.SP_alpha=0.6; %The recomended value
    paout=fullfile(px,'temp124');
    mkdir(paout)
    % ymlfile='D:\MATLAB\bart\elastix2\matlab_elastix\code2\elastix_default.yml'
    ymlfile='elastix_default.yml'
    tic;[w w2]=elastix(bb,aa,paout,ymlfile,'paramstruct',q);toc;
    %% ===============================================
    
end

% return

% ==============================================
%%   apply transform
% ===============================================
if ischar(p.interpOrder) && strcmp(p.interpOrder,'auto')
    unib=unique(b(:));
    if sum(unib==round(unib))==length(unib)  ;% integers --> NN-interp
        interpOrder=0;
    else
        interpOrder=3;
    end
else
    interpOrder=p.interpOrder;
end
for i=1:length(v2)
    set_ix(v2.TransformParametersFname{i}, 'ResultImagePixelType' ,'float');
    set_ix(v2.TransformParametersFname{i}, 'FinalBSplineInterpolationOrder' ,interpOrder);
end
% [cc,slog] = transformix(bb,v2.TransformParametersFname);

% [loga ,cc,slog] = evalc('transformix(bb,v2.TransformParametersFname)');



% ==============================================
%%   transform other slices
% ===============================================
fprintf(' running Transformix..');
b2=zeros(size(b));
for i=1 :size(b,3)
    [loga ,cc,slog] = evalc('transformix(b(:,:,i),v2);');
    b2(:,:,i)   =cc;
    % [cc,slog] = transformix(b(:,:,i),v2);
   
end
fprintf('\n');

% ==============================================
%%   permute DIMS back
% ===============================================

% a2=ipermute(a,dimPerm); %don't need, because a2 is just copied
b3=ipermute(b2,dimPerm);
% ==============================================
%%   save file
% ===============================================
if isempty(p.prefix)
    p.prefix='c';
end

[pam finame ext]=fileparts(p.source) ;
file2save=fullfile(pam,[ p.prefix  finame ext]);
hb3=hb;

rsavenii(file2save, hb3, b3,64);
% showinfo2(['registerd file:' ],file2save);
showinfo2(['  ..regist img:' ],p.target ,file2save);

% ==============================================
%%   copy orig-targetfile and add prefix
% ===============================================

copyfile(p.target, stradd(p.target,p.prefix,1), 'f');

% ==============================================
%%   clearn up
% ===============================================
if p.cleanup==1
    try; rmdir(paout,'s'); end
elseif p.cleanup==2
    try; delete(fullfile(paout,'*.mhd')); end
    try; delete(fullfile(paout,'*.raw')); end
end
%% ===============================================

cprintf('[0 .5 0]',[ 'Done! ' sprintf('(%ct=%0.0fs)', 916,toc(timex1))  '\n'] );







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
