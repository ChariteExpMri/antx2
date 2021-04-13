


%% #b coregister images using affine transformation, 
% optional:  coregistration with rough manual  pre-registration   or centering only (the latter 
% requested for elastix)
% dirs:  works on preselected dirs, i.e. mouse-folders in [ANT] have to be selected before
% works with 3d & 4 d-data
% new coregisterd images receive the prefix 'c_'
% NOTE: the target-image is allways copied, since the origin is always centered, and receives the 
% prefix 'c_'
% ===========================================================================
% 
%% #by HOW-TO: 
% select: SELECT ONE REFERENCE or TARGET IMAGE
% select: SELECT ONE SOURCE IMAGE 
% <optional> SELECT ONE or several other IMAGES to transform (here the calculated transformation 
% rule is applied)
%
%% #by PARAMETERS: 
% function xcoreg(showgui,x)
% showgui: (optional)  :  0/1   :no gui/open gui
% x      : (optional)  : struct with following parameters:
%  #b z.TASK      : task(s) to perform , visualization TASKS and ONE registration task can be combined !!  
%                #n [1]: visualize the overlay of images before ANY registration is performed
%                #n [3]: visualize the overlay of images after a registration is performed (this step
%                        can only run, if a registration is performed in advance)
%                #m [2]: SPM rigid-body coregistration
%               #m [20]: SPM rigid-body coregistration coregistration with previous manual registering (roughly shifted 
%                          manually via gui)
%               #n [10]: centering only   : only centering (set origin to midpoint of the Ref-image,
%                        this step is automatically done in [2]&[20])
%                                           -this is a necessary step for warping using elastix
%               #m [50]: reorient only   : only reorient image based on "x.preRotate"-angles
%                        For this, "x.preRotate" has to be defined (3 rotation angles in radians)    
%               #m [100]: Elastix registration (without SPM coregistration), with single/multiple parameter
%                        files (regid&|affine&|bspline) 
% 
%                  example combinations: [=combinations of one registration task AND visualization task]
%                   [1 2 3]  : affine registration, but show registration befor AND afterwards
%                     [2 3]  : affine registration, but show registration only      afterwards
%                  [1 10 3]  : centering only, but show registration befor AND afterwards 
%                  [1 20 3]  : affine registration with previous manual pre-registration, but show
%                              registration befor AND afterwards 
%                  not valid combinations: [=combinations of multiple registration-task ARE NOT ALLOWED]
%                  [10 20] or [2 20] ...     
%  #b IMAGES             
%     z.targetImg1:    THE ONE TARGET-IMAGE , example: { 'c_2_T2_ax_mousebrain_1.nii' };                                                                 
%     z.sourceImg1:    THE ONE SOURCE-IMAGE , (this image should be "transformed" to the target-image )
%                        example: { 'c_nan2neu_2.nii' };                                                                            
%     z.sourceImgNum1: WHICH volume to use if source image is a 4dim volume    , default: 1                                                                                           
%     z.applyImg1:     <OPTIONAL> OTHER (ONE/MULTIPLE; 3D OR 4D) IMAGES TO REGISTER USING THE 
%                      ABOVE ESTIMATED TRANSFORMATION RULE  
% ------------------------------------------
% #b SPM-Coregistration PARAMETER        	 
% x.cost_fun      :  objective function: [nmi] norm. mutual Info, [mi] mutual Info, 
%                    [ecc] entropy corrcoef,[ncc] norm. crosscorr
%                    Default:  nmi
% x.sep           : optimisation sampling steps (mm)  [4  2  1  0.5  0.1  0.05];	
%                   Increase the first value(s) to increase the 'search-field' (larger displacement)
% x.tol           : tolerences for accuracy of each param:  [0.01  0.01  0.01  0.001  0.001  0.001];	
% x.fwhm          : smoothing to apply to 256x256 joint histogram:  [7  7]; 
% -----------------
% x.centerering   : make copy of targetIMG & set origin to "center" ,than apply centeringTRafo
%                   to all coregistered images. Default: [0]	
% -----------------
% #b RESLICING VOLUME  PARAMETER (OPTIONAL)
% x.reslicing     : reslice images,  [0] no, do not reslice, [1] reslice to target Image (targetImg1) 
%                  Default: [0]		
% x.interpOrder   : interpolation order for reslicing: 
%                         [0]nearest neighbour, [1] trilinear interpolation, 
%                         ["auto"] to autodetect interpolation order; Default: 'auto';
% x.prefix        : file prefix for the new resliced volume (if empty, overwrite the soureIMG  )
%                   Default: 'r'
% -----------------
% #b ELASTIX  PARAMETER (OPTIONAL)
% use Elastix (rigide,affine, bsline) instead of SPM-coregistration or after SPM coregistration 
% x.warping       :   USE ELASTIX-registration  {0|1: no|yes}
%                     #r This Paramter has to bet set to [1]! when using Elastix-registration here.
%                     #r So even when using rigid-body coregistration via Elastix
%                     #r Sorry for misusing the variable-name here! 
%                      Default: [0]		
% x.warpParamfile :  the Elastixs parameterfile(s) to apply. Several parameter files (rigid, affine, bspline)
%                    can be combined in the correct order
%                   Example-1: use rigid-body coregistration
%                   x.warpParamfile={'f:\antx2\mritools\elastix\paramfiles\trafoeuler5_MutualInfo.txt' };
%                   Example-2: use rigid-body coregistration, followed by affine regisitration
%                   x.warpParamfile={'f:\antx2\mritools\elastix\paramfiles\trafoeuler5_MutualInfo.txt' ...
%                                    'f:\antx2\mritools\elastix\paramfiles\Par0025affine.txt'}; 
% x.warpPrefix    : prefix out the output file  (if empty, it will overwrite the output of the previously affine registered file)
%                   Default: 'c_';	
% -----------------
% #b PRE-ROTATE IMAGES (Reorient images) (OPTIONAL)
% Use this option to reorient  images based on 3 rotation angles (radians)
%    AIM: 
%    a) as only action: for this define "x.preRotate" and set "z.TASK" to [50]!
%    b) reorient image prior to registration: for this define "x.preRotate" and set "z.TASK" 
%      to [100] (for using Elastix) or [2] (using SPM-coregistration) !
% x.preRotate    : the 3 rotation angles (in radians)
% % ------------------------------------------
% #b  x.cleanup       : remove interim steps {0|1: no|yes}; Default: [1]
% 
% #g ==============================================================================
% #g BLOCK-2, BLOCK-3... etc .. other coregistrations in the same pipeline
% #g ==============================================================================
%   one can use up to 5 independent other coregistrations in the same pipeline:
%   example scenario: - image [A] should be registered to image [B], and transformation rule 'x'
%                       is applied to images [E,F]
%                     - additionally and independently ...
%                       image [G] should be reguistered to image [H], and transformation rule 'y'
%                       is applied to images [I,J]
%                   --> this case is usefull, if transform [A] to [B] and [G] to [H] have different
%                       transformation rules
%   thus, if other independent coregistrations needed, use z.targetImg2/z.sourceImg2/applyImg3 .
%   ..to.. z.targetImg5/z.sourceImg5/applyImg5
% 
% 
%% #by RUN: 
% xcoreg(1) or  xcoreg    ... open PARAMETER_GUI 
% xcoreg(0,z)             ...NO-GUI,  z is the predefined struct 
% xcoreg(1,z)             ...WITH-GUI z is the predefined struct 
% 
%% #by BATCH EXAMPLE
% ======================================================                                                       
% BATCH:        [xcoreg.m]                                                                                     
% #b descr:  #b coregister images                                                                              
% ======================================================                                                       
% z=[];                                                                                                          
% z.TASK=[1  10  3];                                % show before, do centering only, than show results                                                                                  
% z.targetImg1={ 'c_2_T2_ax_mousebrain_1.nii' };    % SELECT ONE REFERENCE or TARGET IMAGE                                                              
% z.sourceImg1={ 'c_nan2neu_2.nii' };               % SELECT ONE SOURCE IMAGE                                                                  
% z.sourceImgNum1=[1];                              % WHICH volume to use if source image is 4dim volume                                                                                
% z.applyImg1={ '' };                               % <optional>: other images (can be multiple) to 
%                                                   % coregister using previously calculated affine 
%                                                   % transformation rule                                                                                                                                                                              
% xcoreg(1,z);                                      % run function, but open also gui 
% 
% % ======================================================                                                   
% % #b EXAMPLE: REGISTER IMAGES & reslice      [xcoreg.m]     
% % ======================================================              
% z=[];                                                                 
% z.TASK         = '[2] coregister';                
% z.targetImg1   = { 'DTI_shrew_1.nii' };                                   
% z.sourceImg1   = { 't2.nii' };                                            
% z.sourceImgNum1= [1];                                                  
% z.applyImg1    = { 'atlasmask.nii'                                         
%                    'brainmask.nii' };                                      
% z.cost_fun     = 'nmi';                                                     
% z.sep          = [4  2  1  0.5  0.1  0.05];                                      
% z.tol          = [0.01  0.01  0.01  0.001  0.001  0.001];                        
% z.fwhm         = [7 7];                                                        
% z.centerering  = [0];                                                                                                 
% z.reslicing    = [1];            %% RESLICE IMAGES                                        
% z.interpOrder  = 'auto';         %% determine Interpolation order                                            
% z.prefix       = '';             %% no prefix-->overwrite registered image  
% z.warping      = [0];                                                        
% z.warpParamfile= 'o:\antx\mritools\elastix\paramfiles\p33_bspline.txt';
% z.warpPrefix   = 'warped';  
% xcoreg(1,z);         %% NO GUI                                                   
%   
% % ======================================================                                                    
% % #b EXAMPLE: REGISTER IMAGES & reslice & warp   [xcoreg.m]     
% % ======================================================  
% z=[];                                                                 
% z.TASK         = '[2] coregister';                
% z.targetImg1   = { 'DTI_shrew_1.nii' };                                   
% z.sourceImg1   = { 't2.nii' };                                            
% z.sourceImgNum1= [1];                                                  
% z.applyImg1    = { 'atlasmask.nii'                                         
%                    'brainmask.nii' };                                      
% z.cost_fun     = 'nmi';                                                     
% z.sep          = [4  2  1  0.5  0.1  0.05];                                      
% z.tol          = [0.01  0.01  0.01  0.001  0.001  0.001];                        
% z.fwhm         = [7 7];                                                        
% z.centerering  = [0];                                                                                                
% z.reslicing    = [1];             %% RESLICE IMAGES                                        
% z.interpOrder  = 'auto';          %% determine Interpolation order                                            
% z.prefix       = '';              %% no prefix--> overwrite registered image 
% z.warping      = [1];             %% nonlinear warp                                                  
% z.warpParamfile= 'o:\antx\mritools\elastix\paramfiles\p33_bspline.txt';
% z.warpPrefix   = 'warped';  
% xcoreg(0,z);             %% NO-GUI  
% 
% ==============================================
%%  #b EXAMPLE: ROTATE/REORIENT IMAGE ONLY
%  rotate image 'source.nii' by "z.preRotate"-angles
%  the output 'c_source.nii' is rotated by "z.preRotate"-angles
% ===============================================
% z=[];                                                                                 
% z.TASK='50';                         % % reorient image(s) only                                                   
% z.targetImg1='';                                                          
% z.sourceImg1={ 'source.nii' };                                                            
% z.sourceImgNum1=[1];       
% z.applyImg1    = {};
% z.preRotate=[pi/2 pi/2 pi/2];                                                                                                                     
% xcoreg(1,z); %OPEN GUI
% ==============================================
%%  #b EXAMPLE: REORIENT IMAGE followed by Elastix rigid-body registration
%  (1) Rotate image 'm1.nii' to obtain the same orientation as 'AVGT.nii' via "z.preRotate"-angles.
%  (2) Than, use Elastix rigid-body registration
% ===============================================
% z=[];                                                                                 
% z.TASK         ='100';            % % use ELASTIX registration
% z.targetImg1   ={ 'AVGT.nii' };                                                          
% z.sourceImg1   ={ 'm1.nii' };                                                            
% z.warpParamfile={ 'f:\antx2\mritools\elastix\paramfiles\trafoeuler5_MutualInfo.txt' };
% z.cleanup      =[1];    
% z.preRotate    =[1.5708    3.1416         0]
% xcoreg(0,z);    %No- GUI
% 
%
%% #by RE-USE BATCH: see 'anth' [..anthistory] -variable in workspace
% 
% update 01.04.21: 
% preRotate & pre-elastix-registration work with 4D-data
% if sourceImgage is 4D, it uses the 1st volume




function xcoreg(showgui,x,pa)


%===========================================
%%   PARAMS
%===========================================
if exist('showgui')==0 || isempty(showgui) ;    showgui=1                ;end
if exist('x')==0                          ;    x=[]                     ;end
if exist('pa')==0      || isempty(pa)      ;    pa=antcb('getsubjects')  ;end

if ischar(pa);                      pa=cellstr(pa);   end
if isempty(x) || ~isstruct(x)  ;  %if no params spezified open gui anyway
    showgui  =1   ;
    x=[]          ;
end



%===========================================
%%   %% test SOME INPUT
%===========================================


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


%% ________________________________________________________________________________________________
%%  PARAMETER-gui
%% ________________________________________________________________________________________________
if exist('x')~=1;        x=[]; end

p={...
    'inf1'      '--- COREGESTRATION   ---             '                         '' ''
    'inf2'      'Block-1,Block-2...Block-3..: are independent coregistrations with independent targetImage/sourceImgae and applyIMages, respectively' ,'' ''
    'inf99'      'coregister sourceImage[t1] onto targetImage[t1] and apply transformation to other images [applyImages]', '' ''
    'inf100'      [repmat('_',[1,100])]                            '' ''
    %
    'TASK'            {'[2]'}                'Task to perform (display before/after and or register)' ...
    {' [1] display' '[2] coregister' '[3] displayResult' ...
    '[1+2+3] display & coregister & displayResult'  '[1+2] display & coregister' ...
    '[1+3] display & displayResult' '[1+3] coregister & displayResult' ...
    '[20] coregister with previous manual registering byHand' ...
    '[10] centering only'...
    '[50] reorient image only, x.preRotate must be defined'...
    '[100] noSPMregistration, only elastix'};
    %
    'targetImg1'      {''}                'target image [t1], (static/reference image)'  {@selector2,li,{'TargetImage'},'out','list','selection','single'}
    'sourceImg1'      {''}                'source image [t2], (moved image)'             {@selector2,li,{'SourceImage'},'out','list','selection','single'}
    'sourceImgNum1'   1                   'if sourceImg has 4 dims use this imageNumber  --> sourceImg(:,:,:,sourceImgNum) '  ''
    'applyImg1'       {''}                'images on which the transformation is applied (do not select the sourceIMG again!)'  {@selector2,li,{'Images to Apply Trafo'},'out','list','selection','multi'}
    %
    'inf103'      '% PARAMETERS       '  '' ''
    'cost_fun'      'nmi'                                 'objective function: [nmi] norm. mutual Info, [mi] mutual Info, [ecc] entropy corrcoef,[ncc] norm. crosscorr' ,{'nmi' 'mi' 'ecc' 'ncc'}
    'sep'           [4 2 1 0.5 0.1 .05]                   'optimisation sampling steps (mm)' ,{'4 2 1 0.5 0.1 .05' ;'2 1 0.36 0.18 '}
    'tol'           [0.01 0.01 0.01   0.001 0.001 0.001]  'tolerences for accuracy of each param' ,{'0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001' ;' 0.02 0.02 0.02 0.001 0.001 0.001'}
    'fwhm'          [7 7]                                 'smoothing to apply to 256x256 joint histogram' ,''
    'centerering'   [0]                                   'make copy of targetIMG & set origin to "center" ,than apply centeringTRafo to all coregistered images,  ' ,'b'
    
     'inf2002'      [ '% RESLICE VOLUME (OPTIONAL) '    repmat('_',[1,90])]   '' ''
    'reslicing'    [0]      'reslice images,  [0] no, do not reslice, [1] reslice to target Image (targetImg1) ' ,{0 1 2}'
    'interpOrder'  'auto'   'interpolation order [0]nearest neighbour, [1] trilinear interpolation, ["auto"] to autodetect interpolation order' {'auto',0,1}'
    'prefix'       'r'      'file prefix for the new resliced volume (if empty, overwrite the soureIMG  )'   '' 
    
    
    'inf2001'       [ '% ELASTIX: rigid,affine, bspline  (OPTIONAL) '    repmat('_',[1,90])]   '' ''
    'warping'       [0]        'USE ELASTIX, example..do subsequent nonlinear warping [0|1],  ' ,'b'
    'warpParamfile'  fullfile(fileparts(fileparts(which('ant.m'))),'elastix','paramfiles' ,'p33_bspline.txt')      'parameterfile used for warping'  {@getparmfiles }
    'warpPrefix'   'c_'                            'prefix out the output file after warping (if empty, it will overwrite the output of the previously affine registered file)'  ''
    'cleanup'      [1]  'remove interim steps'  'b'      

    'inf2011'       [ '% pre-rotate image '    repmat('_',[1,90])]   '' ''
    'preRotate'     []  'pre-rotate image prior to any task [3 values;  string or numerical],   ' ,{ '1.5708 3.1416 0'}
    

    
    
    %
    'inf200'        ''                           '' ''
    'inf201'      [ '%___  BLOCK-2 (optional)  '    repmat('_',[1,90])]   '' ''
    'targetImg2'      {''}                'target image [t1], (static/reference image)'  {@selector2,li,{'TargetImage'},'out','list','selection','single'}
    'sourceImg2'      {''}                'source image [t2], (moved image)'             {@selector2,li,{'SourceImage'},'out','list','selection','single'}
    'sourceImgNum2'   1                  'if sourceImg has 4 dims use this imageNumber  --> sourceImg(:,:,:,sourceImgNum) '  ''
    'applyImg2'       {''}               'images on which the transformation is applied (do not select the sourceIMG again!)'  {@selector2,li,{'Images to Apply Trafo'},'out','list','selection','multi'}
    %
    %     'inf300'      [repmat('�',[1,100])]                            '' ''
    'inf301'     [ '%___  BLOCK-3 (optional)  '    repmat('_',[1,90])]   '' ''
    'targetImg3'      {''}                'target image [t1], (static/reference image)'  {@selector2,li,{'TargetImage'},'out','list','selection','single'}
    'sourceImg3'      {''}                'source image [t2], (moved image)'             {@selector2,li,{'SourceImage'},'out','list','selection','single'}
    'sourceImgNum3'   1                  'if sourceImg has 4 dims use this imageNumber  --> sourceImg(:,:,:,sourceImgNum) '  ''
    'applyImg3'       {''}               'images on which the transformation is applied (do not select the sourceIMG again!)'  {@selector2,li,{'Images to Apply Trafo'},'out','list','selection','multi'}
    
    'inf401'      [ '%___  BLOCK-4 (optional)  '    repmat('_',[1,90])]   '' ''
    'targetImg4'      {''}                'target image [t1], (static/reference image)'  {@selector2,li,{'TargetImage'},'out','list','selection','single'}
    'sourceImg4'      {''}                'source image [t2], (moved image)'             {@selector2,li,{'SourceImage'},'out','list','selection','single'}
    'sourceImgNum4'   1                  'if sourceImg has 4 dims use this imageNumber  --> sourceImg(:,:,:,sourceImgNum) '  ''
    'applyImg4'       {''}               'images on which the transformation is applied (do not select the sourceIMG again!)'  {@selector2,li,{'Images to Apply Trafo'},'out','list','selection','multi'}
    
    'inf501'      [ '%___ BLOCK-5 (optional)  '    repmat('_',[1,90])]   '' ''
    'targetImg5'      {''}                'target image [t1], (static/reference image)'  {@selector2,li,{'TargetImage'},'out','list','selection','single'}
    'sourceImg5'      {''}                'source image [t2], (moved image)'             {@selector2,li,{'SourceImage'},'out','list','selection','single'}
    'sourceImgNum5'   1                  'if sourceImg has 4 dims use this imageNumber  --> sourceImg(:,:,:,sourceImgNum) '  ''
    'applyImg5'       {''}               'images on which the transformation is applied (do not select the sourceIMG again!)'  {@selector2,li,{'Images to Apply Trafo'},'out','list','selection','multi'}

    };


p=paramadd(p,x);%add/replace parameter
%     [m z]=paramgui(p,'uiwait',0,'close',0,'editorpos',[.03 0 1 1],'figpos',[.2 .3 .7 .5 ],'title','PARAMETERS: LABELING');

% %% show GUI
if showgui==1
    hlp=help(mfilename); hlp=strsplit2(hlp,char(10))';
    [m z ]=paramgui(p,'uiwait',1,'close',1,'editorpos',[.03 0 1 1],'figpos',[.15 .3 .8 .6 ],...
        'title','***COREGISTRATION***','info',hlp);
    if isempty(m); return; end
    fn=fieldnames(z);
    z=rmfield(z,fn(regexpi2(fn,'^inf\d')));
else
    z=param2struct(p);
end


%% TASK
if iscell(z.TASK)
    %task=str2num(cell2mat(regexpi(char(z.TASK),'\d','match')'))';
%     task=str2num(char(regexprep(z.TASK,'\D',' ')));
    [st, en, match] = regexp(z.TASK, '\[.*?\]', 'start', 'end', 'match');
    task=str2num(char(match{1}));
elseif isnumeric(z.TASK)
    task=z.TASK;
else
    %task=str2num(cell2mat(regexpi(z.TASK,'\d','match')'))';
    task= str2num(cell2mat(regexpi(z.TASK,'\d+','match')'))';
    
end

%===========================================
%%   process
%===========================================
makebatch(z);


%% SHOW
if find(task==1)
    do_show(z,pa,1);
    %     '1'
end

%% COREG
if find(task==2)
    [t t2]=initialize(z,pa);
    do_coregister(t2,z,'');
end
%% COREG
if find(task==20)
    [t t2]=initialize(z,pa);
    do_coregister(t2,z,'preregister');
elseif find(task==10)
    [t t2]=initialize(z,pa);
    do_coregister(t2,z,'centering_only');
elseif find(task==100)
     if z.warping==0 % makes only sense if this is true
        z.warping=1;
     end
    [t t2]=initialize(z,pa);
    do_coregister(t2,z,'noSPMregistration');
    
elseif find(task==50)         %                  REOIRENT only
    z.warping=0;
    
    % empty target--> replace with source (which is never used/manipulated)
    fnames=fieldnames(z);
    ztarget=fnames(regexpi2(fnames,'targetImg.*'));
    zsource=regexprep(ztarget,'targetImg','sourceImg');
    for j=1:length(ztarget)
        if isfield(z,zsource{j}) && isfield(z,ztarget{j})
            source=getfield(z,zsource{j});
            if isempty(char(getfield(z,ztarget{j}))) % if target is empty--> set target as source
                z=setfield(z,ztarget{j},source);
            end
        end
    end
    
    
    [t t2]=initialize(z,pa);
    do_coregister(t2,z,'reorient_only');
end

%% SHOW AFTERWARDS
if find(task==3)
    do_show(z,pa,2);
    %     '3'
end

% % %% DISPLAY COMMANDLINE
% % for j=1:5
% %    char(getfield(z,['targetImg' num2str(j)]) 
% %     
% % end



% makebatch(z);
%===================================================================================================
%===================================================================================================
% 	subs      
%===================================================================================================

function makebatch(z)


try
    hlp=help(mfilename);
    hlp=hlp(1:min(strfind(hlp,char(10)))-1);
catch
    hlp='';
end

hh={};
hh{end+1,1}=( '% ======================================================');
hh{end+1,1}=[ '% BATCH:        [' [mfilename '.m' ] ']' ];
hh{end+1,1}=[ '% #b descr:' hlp];
hh{end+1,1}=( '% ======================================================');
hh=[hh; 'z=[];' ];
hh=[hh; struct2list(z)];
hh(end+1,1)={[mfilename '(' '1',  ',z' ');' ]};
% uhelp(hh,1);
try
    v = evalin('base', 'anth');
catch
    v={};
    assignin('base','anth',v);
    v = evalin('base', 'anth');
end
v=[v; hh; {'                '}];
assignin('base','anth',v);


%===========================================
%% COREG
%===========================================


function do_coregister(t2,z,modus)

atic=tic;

% fprintf('.. register images..');
% pause(1);
% fprintf(['\b\b, reslicing..'  ]);
% pause(1);
% 
% fprintf(['\b\b, warping..'  ]);
% pause(1);
% fprintf(['\b\b [done] ELA ' sprintf('%2.2fmin',toc(atic)/60) '\n']);

proc=cell2mat(t2(:,1));
nprocs=unique(proc);


for i=1:length(nprocs)
    g=t2(proc==i,:);
    displog={};
    
    s=[];
    s.t     =  g(regexpi2(g(:,4),'t'),6);
    s.s     =  g(regexpi2(g(:,4),'s'),6);
    s.snum  =  g{regexpi2(g(:,4),'s'),7};
    s.a     =  g(regexpi2(g(:,4),'a'),6);
    
    try
        %%TARGET-IMGAGES
        s.tc=stradd(s.t,  'c_');
        deletem(s.tc);
        copyfilem(  s.t,  s.tc);
        %%SOURCE-IMGAGES
        s.sc=stradd(s.s,  'c_');
        deletem(s.sc);
        deletem(regexprep(s.sc,'.nii$','.mat'));
        copyfilem(  s.s,  s.sc);
        
        
        
        %%APPLY-IMGAGES
        s.ac=stradd(s.a,  'c_');
        deletem(s.ac);
        deletem(regexprep(s.ac,'.nii$','.mat'));
        copyfilem(  s.a,  s.ac);
        
        %% images
        otherImg=regexprep(s.ac(2:end),'.nii','.nii,1');
        if isempty(otherImg)
            otherImg={''} ;
        end
        %% dd
        
        %% ----------PREROTATE (3d or 4d)-----------------------------------------
        if isfield(z,'preRotate') && ~isempty(z.preRotate)
            warning off;
            rotangle=z.preRotate;
          if ~isnumeric(rotangle);  rotangle=str2num(rotangle); end
          if length(rotangle)==3
              for jj=1:length(s.ac)
                  Bvec      =[ [0 0 0] [rotangle]  1 1 1 0 0 0];
                  hh=spm_vol(s.ac{jj});
                  if length(hh)==1   % 3D
                      fsetorigin(s.ac{jj},   spm_imatrix(inv(spm_matrix(Bvec)))    );
                  else                %4D
                      hh2=hh;
                      M=inv(spm_matrix(Bvec));
                      for ivol=1:length(hh2)
                         hh2(ivol).mat = M*hh(ivol).mat;
                      end
                      spm_create_vol(hh2);        
                  end
                  fprintf(['pre-rotate..'  ]);
              end
          end
          if strcmp(modus,'reorient_only')
              try; displog={s.ac{1} }'; end
              fprintf(['\b\b [done] ELA ' sprintf('%2.2fmin',toc(atic)/60) '\n']);
              try; showinfo2([ 'reorient: ' fileparts(displog{1}) ], displog{1}); end
              
              continue
          end
            
        end
        
        %% ---------------------------------------------------
        %% PRERGISTER MANUALLY
        if strcmp(modus,'preregister')
            s=preregister(s,z);
        end
        
        
        
        if strcmp(modus,'centering_only')==0 &&  strcmp(modus,'noSPMregistration')~=1
            matlabbatch=[];
            matlabbatch{1}.spm.util.exp_frames.files = {[char(s.sc) ,',' num2str(s.snum) ]}  ;%{'O:\data\karina_v2\dat\2014_test\nan_2.nii,1'};
            matlabbatch{1}.spm.util.exp_frames.frames = Inf;
            matlabbatch{2}.spm.spatial.coreg.estimate.ref = {[char(s.tc) ,',1' ]}  ;%{'O:\data\karina_v2\dat\2014_test\t2_1.nii,1'};
            matlabbatch{2}.spm.spatial.coreg.estimate.source(1) = cfg_dep;
            matlabbatch{2}.spm.spatial.coreg.estimate.source(1).tname = 'Source Image';
            matlabbatch{2}.spm.spatial.coreg.estimate.source(1).tgt_spec{1}(1).name = 'filter';
            matlabbatch{2}.spm.spatial.coreg.estimate.source(1).tgt_spec{1}(1).value = 'image';
            matlabbatch{2}.spm.spatial.coreg.estimate.source(1).tgt_spec{1}(2).name = 'strtype';
            matlabbatch{2}.spm.spatial.coreg.estimate.source(1).tgt_spec{1}(2).value = 'e';
            matlabbatch{2}.spm.spatial.coreg.estimate.source(1).sname = 'Expand image frames: Expanded filename list.';
            matlabbatch{2}.spm.spatial.coreg.estimate.source(1).src_exbranch = substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1});
            matlabbatch{2}.spm.spatial.coreg.estimate.source(1).src_output = substruct('.','files');
            matlabbatch{2}.spm.spatial.coreg.estimate.other = otherImg ;%{''};
            matlabbatch{2}.spm.spatial.coreg.estimate.eoptions.cost_fun = z.cost_fun   ;%'nmi';
            matlabbatch{2}.spm.spatial.coreg.estimate.eoptions.sep =      z.sep        ;%[4 2];
            matlabbatch{2}.spm.spatial.coreg.estimate.eoptions.tol =      z.tol        ;% [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
            matlabbatch{2}.spm.spatial.coreg.estimate.eoptions.fwhm =     z.fwhm       ;%[7 7];
            %     spm_jobman('run',matlabbatch)
            %disp(['coregistration:  refIMG:' s.sc{1}]);
            cprintf([0 .5 0] ,['targetIMG: '    ]);
            cprintf([0 0 1] ,[ strrep(s.tc{1},filesep,['/' filesep])  '\n']);
            fprintf('.. register images..');
            evalc('spm_jobman(''run'',matlabbatch)');
            % spm_jobman('run',matlabbatch);
            
            
           
            
            
            %% apply to 4d-data
            for j=1:size(s.ac,1)
                %r=s.ac{j}
                [ha]=spm_vol(s.ac{j} );%transformed header
                [ho]=spm_vol(s.a{j}  );%orig header & data
                [b]=spm_read_vols(ho);
                %v=load_untouch_nii(ha);
                if size(ha,1)>1 %struct
                    if j==1  %sourceIMG
                        inum = 1 ;%s.snum;
                    else     % all other IMAGES get header from 1st HDR
                        inum = 1;
                    end
                    hr       = ha(inum); %get 3d-HDR of transformed data with this vol-Number
                    hr.fname = s.ac{j} ;%fullfile(fileparts(s.ac{j}), '_o.nii')  ;%
                    
                    clear hh2
                    for k=1:size(ha,1)
                        dum=hr;
                        dum.n=[k 1];
                        
                        hh2(k,1)=dum;
                        if k==1
                            %mkdir(fileparts(hh2.fname));
                            spm_create_vol(hh2);
                        end
                        spm_write_vol(hh2(k),b(:,:,:,k));
                    end
                end
            end
           try; displog={s.tc{1},s.ac{1}}'; end
        end
        
        %===========================================
        %%   centering
        %===========================================
        if z.centerering ==  1
            
            s.tc=stradd(s.t,'c_');
            copyfile(s.t{1},s.tc{1},'f');
            ftrafo_center(s.t{1},s.tc{1}); %center TargetIMAGE
            
            %apply trafo to all applyIMG
            for j=1:size(s.ac,1)
                
                %% targtImge,targtImge, applyIMG, targtImge2write
                ftrafo_img2img(s.t{1},s.tc{1}  ,     s.ac{j},s.ac{j}  );
                
                %% BACKTRAFO: were [ s.ac{j},toback] is a copy of s.ac{j}
                % ftrafo_img2img(s.tc{1},s.t{1}  ,     s.ac{j},toback)
            end
            try; displog={s.tc{1},s.ac{1}}'; end
        end
        
                
        %===========================================
        %%  reslicing
        %===========================================
        if z.reslicing ==  1
            fprintf(['\b\b, reslicing..'  ]);
            for j=1: size(s.ac,1) %for each volume
                targ=s.tc{1};
                sour=s.ac{j};
                prefix=z.prefix;
                interpOrder=z.interpOrder;
                
                %rreslice4d('test2.nii' ,'c_DTI_shrew_1.nii', '',1,'verbose','on'  );
                rreslice4d(sour ,targ, prefix, interpOrder  );
            end%for each volume
            if ~isempty(prefix)
                copyfile(s.tc{1} ,stradd(s.tc{1},prefix,1),'f');
            end
            
            
            %% ALTERNATIVE: .coreg.write
            % matlabbatch{1}.spm.spatial.coreg.write.ref = {'O:\data2\susanne_shrew\dat\DTI_coreg\DTI_shrew_1.nii,1'};
            % matlabbatch{1}.spm.spatial.coreg.write.source = {'O:\data2\susanne_shrew\dat\DTI_coreg\c_t2.nii,1'};
            % matlabbatch{1}.spm.spatial.coreg.write.roptions.interp = 7;
            % matlabbatch{1}.spm.spatial.coreg.write.roptions.wrap = [0 0 0];
            % matlabbatch{1}.spm.spatial.coreg.write.roptions.mask = 0;
            % matlabbatch{1}.spm.spatial.coreg.write.roptions.prefix = 'Q';
            
             try; displog={s.tc{1}, stradd(s.ac{1},prefix,1) }'; end
        end
        
%         if z.warping==0
%            try; showinfo2('aaa',s.t{1},s.ac{1}); end 
%         end
        
        %===========================================
        %%   warp bsline transformation
        %===========================================
        %
        if z.warping ==  1
            fprintf(['\b\b, Elastix..'  ]);
%             z.warpParamfile=fullfile(fileparts(fileparts(which('ant.m'))),'elastix','paramfiles' ,'p33_bspline.txt')
%             z.warpPrefix='bspline';
%             keyboard
            
            pfile=z.warpParamfile ;%{fullfile(pwd,'p33_bspline.txt')}
            if ischar(pfile); pfile={pfile};end
%             pfile={fullfile(pwd,'Par0038affine.txt')}
%             pfile={fullfile(pwd,'xPar0033bspline_EM2.txt')}
            %pfile={fullfile(pwd,'p33_bspline.txt')}
            
            href=spm_vol(s.tc{1});
            if size(href,1)==1;
                fximg=s.tc{1};
            else
                imgnumref=1;
                [hv v]=rgetnii(s.tc{1}); 
                hv=href(imgnumref);  hv.n=[1 1];
                v=v(:,:,:,imgnumref);
                refvol3d=fullfile(fileparts(s.tc{1}),'_coregref3d.nii');
                rsavenii( refvol3d, hv,v);
                fximg=refvol3d;
            end
            
            moimg=s.sc{1};
            pout  =fullfile(fileparts(moimg),'regwarp'); mkdir(pout);
            
            % check if movingIMG is 4D-volume
            hmov=spm_vol(moimg);
            is4D=length(hmov)>1;
            if is4D %4D
                w =spm_read_vols(hmov(1));
                hw=hmov(1);
                moimg=fullfile(pout, 'movimg3D.nii');
                rsavenii(  moimg,   hw,w   );  % write 1st 3D volume as movIMG to "paout"
            end
            
            
            [infox rimg, trafofile]=evalc('run_elastix( fximg, moimg,    pout  ,pfile,  [],[]    ,[],[],[])');
            trafofile  =cellstr(trafofile);
            trafofile2 =trafofile{end};
            
            for jj=1:size(s.ac,1);  % TRANSFORM
                timg=s.ac{jj};
                [hu u]=rgetnii(timg);
                %% fraction number--> interp order 3, otherwise 0
                if length(find(round(unique(u))==unique(u)==0))>0  %fractional number -->intp3
                    interporder=3;
                else
                    interporder=0;
                end
                set_ix(trafofile2,'FinalBSplineInterpolationOrder',interporder);
                
                if length(hu)==1       % 3D ###############
                [infox im2,tr2]= evalc( 'run_transformix(timg,[],trafofile2,pout,'''')'     );
                [pa2 fis ext]=fileparts(timg);
                newfile=fullfile( pa2,[ z.warpPrefix  regexprep(fis,'^c_','') ext  ] );
                movefile(im2,newfile ,'f');
                else                   % 4D ###############
                    for kk=1:length(hu)
                        tempfi=fullfile(pout,'temp4d.nii');
                        hut=hu(kk);
                        hut.n(1)=1;
                        rsavenii(tempfi, hut, u(:,:,:,kk) );
                        [infox im2,tr2]= evalc( 'run_transformix(tempfi,[],trafofile2,pout,'''')'     );
                        [hat0 at0]=rgetnii(im2);
                        if kk==1
                           at  = zeros([size(at0) length(hu)]);
                           hat =hat0;
                        else
                          hat(kk)     =hat0;
                          hat(kk).n(1)=kk;
                        end
                        at(:,:,:,kk)=at0;
                    end%kk (3dvol in 4d)
                    newfile=timg;
                    rsavenii(  newfile     , hat,at);  
                end %3D/4D
                
                if jj==1
                     try; displog={s.tc{1}, newfile }'; end
                end
%                 try; showinfo2(' warped images',s.t{1},newfile); end
                %fprintf(['.. \b\b\b [done] ..ELA ' sprintf('%2.2fmin',toc(atic)/60) '\n']);
            end %  EACH-VOLUME TO REGISTER
            
           % try; displog={s.tc{1}, s.ac{1} }'; end
           % ---------------------------------------------------------------------------- 
            %% clean up warping
            if z.cleanup~=1
                try; delete(fullfile(pout,'*.nii')); end
                try; rmdir(pout, 's'); end
            end
            try; delete(refvol3d); end  % delete 3d refVOL
        end%DO ELASTIX (warping)
 % ---------------------------------------------------------------------------- 
       

        
% % % %       %% bla  
% % % %         if 0
% % % %             matlabbatch=[];
% % % %             matlabbatch{1}.spm.spatial.coreg.estimate.ref    = {[char(s.tc) ,',1' ]}      ;%{'O:\data\karina_v2\dat\2014_test\t2_1.nii,1'};
% % % %             matlabbatch{1}.spm.spatial.coreg.estimate.source = {[char(s.sc) ,',1' ]}       ;%{'O:\data\karina_v2\dat\2014_test\nan_2.nii,1'};
% % % %             matlabbatch{1}.spm.spatial.coreg.estimate.other = regexprep(s.ac(2:end),'.nii','.nii,1')     ;%apply;%{''};
% % % %             matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.cost_fun = z.cost_fun    ;%'nmi';
% % % %             matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.sep =      z.sep        ;%[4 2];
% % % %             matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.tol =      z.tol        ;% [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
% % % %             matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.fwhm =     z.fwhm       ;%[7 7];
% % % %             spm_jobman('run',matlabbatch);
% % % %         end
        


        fprintf(['\b\b [done] ELA ' sprintf('%2.2fmin',toc(atic)/60) '\n']);
        try; showinfo2([ 'coreg: ' fileparts(displog{1}) ], displog{1},displog{2}); end

    catch
        %%PROBLEM
        
        disp([pnum(i,4) '] coreg failed <a href="matlab: explorer('' ' fileparts(char(s.t)) '  '')">' char(s.t) '</a>']);% show h<perlink
        
        
    end
    
    
end%procs



%===========================================
%%   preregister by HAND
%===========================================
function s=preregister(s,z)




f1=s.tc{1}; % fullfile(pwd,'2_T2_ax_mousebrain_1.nii')
f2=s.ac{1};%fullfile(pwd,'MSME-T2-map_20slices_1.nii')

f1a=stradd(f1,'tpm_',1);
f2a=stradd(f2,'tpm_',1);

[ha a]=rgetnii(f1);
[hb b]=rgetnii(f2);

rsavenii(f1a,ha(1),a(:,:,:,1)  );
rsavenii(f2a,hb(1),b(:,:,:,s.snum)  );



o.getbvec=1 ;% but parse bvec
o.addautoregister=0;o.addpreviousorients=0; o.addsetzero=0;o.addreorientTPM=0; %show not these buttons(autoreg,prevorients,setsero,reorientTPM)
bv=displaykey3inv( f1a,f2a ,1,o);
mat=spm_matrix([bv ;[0 0 0]']);

% v=spm_vol(f2a)
%  spm_get_space(f2a,mat*v.mat);
for i=1:size(s.ac,1)
    v=spm_vol(s.ac{i});
    mat2=mat*v(1).mat;
    for j=1:size(v,1);
        v(j).mat=mat2;
    end
     spm_create_vol(v);
end

try; delete(f1a); end
try; delete(f2a); end



%===========================================
%% PLOT&chck overlay -all
%===========================================

function do_show(z,pa,modus);


if modus==1
    [t t2]=initialize(z,pa);
else
    
    for i=1:5
       
        if ~exist('var','var')
            var = '';
        end
        
        eval(['var=z.targetImg' num2str(i) ';']);
        if 1%~isempty(var{1})
            
            if  z.centerering ==  1
                eval(['z.targetImg' num2str(i) '=stradd(z.targetImg' num2str(i) ',''c_'');' ]);
            end
            eval(['z.sourceImg' num2str(i) '=stradd(z.sourceImg' num2str(i) ',''c_'');' ]);
            eval(['z.applyImg'  num2str(i) '=stradd(z.applyImg'  num2str(i) ',''c_'');' ]);
        end
    end
    
    [t t2]=initialize(z,pa);
end




proc=1;
ij=[0 0];
grid=[];
for i=1:size(t2,1)
    if strcmp(t2{i,4},'a')
        if t2{i,1}==proc
            ij=[proc ij(2)+1];
            grid(ij(1),ij(2))=i;
        else
            proc=proc+1;
            ij=[proc 1];
            grid(ij(1),ij(2))=i;
        end
    end
end

% grid-if only 1 column --->display 2
if size(grid,2)==1
    if mod(size(grid,1),2)==1
        grid=[grid;0];
    end
    grid=reshape(grid,length(grid)/2,2);
    iseachpannelacase=1;
else
    iseachpannelacase=0;
end

nrc=[size(grid)];
N=   prod(nrc);
vec=grid';
vec=vec(:);
% fg;
% hs = tight_subplot(nrc(1),nrc(2),[.0 .0],[0 0],[.0 .0]);
if iseachpannelacase==0
    hs =axslider([nrc]);
else
    hs =axslider([nrc],'num',1);
end
% delpanel=hs(find(vec==0));
% delete(delpanel);
% hs(hs==delpanel)=[];


for i=1:N
    if vec(i)==0;           continue  ;   end
    %________________________________________________
    % i=2
    prz=find(cell2mat(t2(:,1))==cell2mat(t2(vec(i),1)));
    mb=t2(prz,:);
    
    i1=find(strcmp(mb(:,4),'t'));
    i2=find(strcmp(mb(:,4),'s'));
    % i3=find(strcmp(mb(:,4),'t'))
    
    s=[];
    s.t=char(mb(i1,6));
    s.s=char(mb(i2,6));
    s.a=char(t2(vec(i),6));
    s.sImgno=cell2mat(mb(i2,7));
    
    %     disp([s.t  ' - '  s.a ]);
    % [o u]=voxcalc([0 0 0],s.t,'mm2idx')
    % slice=round(o(3))
    % fg;img=getslice(s.t,slice,1,1);
    
    % [h,d ]=rreslice2target(fi2merge, firef, fi2save, interpx,dt)
    
    %## 4d vol
    [inhdr, inimg]=rgetnii(s.a);
    [tarhdr      ]=rgetnii(s.t);
    [hb b] = nii_reslice_target(inhdr(1), inimg(:,:,:,1), tarhdr(1), 1) ;
    %##
    %[hb b ]=rreslice2target(s.a, s.t, [], 1);
    
    [ha a]=rgetnii(s.t);
    ha=ha(1); 
    a=a(:,:,:,1);
    
    [o u]=voxcalc([0 0 0],s.t,'mm2idx');
    slice=round(o(3));
    if slice>size(a,3)
        slice=size(a,3);
    end
    
    ca=single(rot90(a(:,:,slice)));
    cb=single(rot90(b(:,:,slice)));
    %
    %     ca=(imresize(ca,[75 75]));
    %     cb=(imresize(cb,[75 75]));
    
    %     resize_si=[50 50];
    %     ca=(imresize(ca,[resize_si]));
    %     cb=(imresize(cb,[resize_si]));
    %
    %%
    axes(hs(i));
    imagesc(ca); % colormap gray
    hold on;
    % contour(ca,'color','w')
    contour(cb,'color','r');
    axis off;
    
    [pat fit ]=fileparts(s.t); [~,pat]=fileparts(pat);
    [paa fia ]=fileparts(s.a); [~,paa]=fileparts(paa);
    
    % bla
    ns=(2*9*1.0);
    re=20;
    [qd qr]=find(grid== vec(i));
    %disp(['qd-qp' num2str([qd qr])]);
    %% ddew
    
    %   delete(findobj(gcf,'tag','tx'));
    yl=ylim;
    yl=round(yl(2));
    sp=yl-yl*.85;
    xs=linspace(1,sp,3)+sp/5;
    cshift=sp/50;
    
    
    %     if 1
    %         [o0 u0]=voxcalc([0 0 0],s.a,'mm2idx');
    %        v(1)=vline(o0(1),'color','c');v(2)=hline(yl-o0(2),'color','c')
    v(1)=vline(o(1),'color','c');v(2)=hline(yl-o(2),'color','c') ;
    %     end
    
    if iseachpannelacase==0
        if qr==1
            t1=text(sp/5, xs(1),  ['...\' pat '\'],'color','w','fontsize',6,'tag','tx','interpreter','none','fontweight','bold');
             set(t1,'ButtonDownFcn', {@openfolder,pat});
        end
    else
        t1=text(sp/5, xs(1),  ['...\' pat '\'],'color','w','fontsize',6,'tag','tx','interpreter','none','fontweight','bold');
         set(t1,'ButtonDownFcn', {@openfolder,pat});
        
    end
    hline((xs(1)+xs(2))/2,'color','w');
    t1=text(sp*.75,        xs(2),       [ fit '.nii'],'color',[0.3020    0.7451    0.9333],'fontsize',9,'tag','tx','interpreter','none');
    %      t1=text(sp*.75+cshift, xs(2), [ fit '.nii'],'color','w','fontsize',9,'tag','tx','interpreter','none');
    %      t1=text(sp*.75,        xs(3),       [ fia '.nii'],'color','r','fontsize',9,'tag','tx','interpreter','none');
    set(t1,'ButtonDownFcn', {@openfolder,pat});
    
    t1=text(sp*.75+cshift ,xs(3), [ fia '.nii'],'color','w','fontsize',9,'tag','tx','interpreter','none');
    set(t1,'ButtonDownFcn', {@openfolder,pat});
    
    t1=text(sp*.75-sp/2, xs(2), ['\otimes' ],'color',[0.3020    0.7451    0.9333],'fontsize',11,'tag','tx','fontweight','bold');
    set(t1,'ButtonDownFcn', {@openfolder,pat});
    
    t1=text(sp*.75-sp/2, xs(3),[ '\leftrightarrow'],'color','r','fontsize',11,'tag','tx','fontweight','bold');
   set(t1,'ButtonDownFcn', {@openfolder,pat});
    
    
    %% cdcd
    yl=ylim;
    hline(min(yl(2)),'color','w','linewidth',5);
    
    
end

set(hs,'XTickLabel','','YTickLabel','');
set(gcf,'name' ,'type [h] for help');


iptaddcallback(gcf, 'WindowKeyPressFcn', @keyx);


%===========================================
function keyx(h,e)

if strcmp(e.Character,'h')
    disp('*** SHORTCUTS ***');
    disp('left click  on "labels" (path or filenames) of images shows the mouse-folder-name in workspace (for longer names) ');
    disp('right click on "labels" (filenames) open the mousefolder in explorer and preselect the clicked file ');
end


function openfolder(h,e,pat)


if e.Button==3
    global an
    im=fullfile(an.datpath,pat,get(e.Source,'string'));
    explorerpreselect(im);
elseif e.Button==1
    disp(pat);
end

function [t t2]=initialize(z,pa)

%===========================================
%%   build blocktable-1 metaData
%===========================================


% F1=@(a)   cellstr(char(a));
% F2=@(a,b)  regexprep(a,b,'');
% F3=@(a)  a(~cellfun('isempty',a));
% F4=@(a,b) [F1(a); F3(F2(F1(b),F1(a)))]; %merge & soucre in on top % remove douplets

 
F4=@(a,b) unique([cellstr(char(a)) ; cellstr(char(b))],'stable'); % CELL with z.sourceImg and z.applyImg(s) in that order, i.e. sourceIMG always on top of list



t=[ %each row is a BLOCK
    {char(z.targetImg1) char(z.sourceImg1)     z.sourceImgNum1  F4(z.sourceImg1,z.applyImg1) }
    {char(z.targetImg2) char(z.sourceImg2)     z.sourceImgNum2  F4(z.sourceImg2,z.applyImg2) }
    {char(z.targetImg3) char(z.sourceImg3)     z.sourceImgNum3  F4(z.sourceImg3,z.applyImg3) }
    {char(z.targetImg4) char(z.sourceImg4)     z.sourceImgNum4  F4(z.sourceImg4,z.applyImg4) }
    {char(z.targetImg5) char(z.sourceImg5)     z.sourceImgNum5  F4(z.sourceImg5,z.applyImg5) }
    ] ;
t(cellfun('isempty',(t(:,1))),:)=[]  ; %remove useless Blocks

%===========================================
%%   build blocktable-2 subjectDATA 3rd dim
%===========================================
t2={};
col=[1 2 4];%col idx of names
procID=1;
for i=1:size(pa,1) %PATH
    %      disp(['SUBJECT:' num2str(i) '______________________' ]);
    for blk=1:size(t,1)  %BLOCK
        %         disp(['BLOCK:' num2str(blk) '______________________' ]);
        for j=1:length(col)  %column of t
            ss=t{blk,col(j)};
            if ischar(ss)  ; ss={ss};  end   %make cell
            for fi=1:size(ss,1)
                s2=ss{fi};
                
                pbnum  =  i;
                fname  =  fullfile(pa{i},s2) ;
                isexist=  exist(fname)==2    ;
                
                if isexist==0
                    if ~isempty(s2)
                    disp(['file not found: : <a href="matlab: explorer(''' fileparts(fname) ''')">' fname '</a>']);
                    end
                end
                
                shortIMGname=s2;
                if j==1      ; aim='t'  ; imgno=1;
                elseif j==2  ; aim='s'  ; imgno=t{blk,col(j)+1};
                elseif j==3  ; aim='a'  ; imgno=1;
                end
                t2(end+1,:)=            {procID  blk pbnum aim isexist fname imgno shortIMGname};
                %                 disp(s2);
            end %files per coreg
            
            
        end
        procID=procID+1;
    end
end





%===========================================
%%  check nonexisting FILES
%% check triplet s-t-a
%===========================================

% del=find(cell2mat(t2(:,4))==0)
% t2(del,:)=[];

proc=unique(cell2mat(t2(:,1)));
% pb =unique(cell2mat(t2(:,2)));
% blk=unique(cell2mat(t2(:,1)));
istriplet=zeros(size(t2,1),1);
for i=1:length(proc)
    icrit= find(cell2mat(t2(:,1))==i) ; %must be this block & thisSubject
    chk=cell2line(sort(unique(t2(icrit,4 ))),1,'');
    if strcmp(chk,'ast')==1 %is defined
        mblk=t2(icrit,:);
        chk2=[ %CHECK TRIPLET T-S-A  (=ast), source-target-applyIMAGES must exist
            sum(cell2mat(mblk(regexpi2(mblk(:,4),'t'),5)))>0
            sum(cell2mat(mblk(regexpi2(mblk(:,4),'s'),5)))>0
            sum(cell2mat(mblk(regexpi2(mblk(:,4),'s'),5)))>0
            ];
        icrit2=icrit(cell2mat(t2(icrit,5))==1);
        if all(chk2)==1
            istriplet(icrit2)=1;
        end
    end
end

t2h={'proc' 'blk' 'id' 'ast' 'isexist'   'FPname' 'imageNum' 'name' 'isTriplet'};
t2=[t2 num2cell(istriplet)];


% id=selector2(cellfun(@(x) num2str(x,3),t2,'UniformOutput',false),t2h,'iswait',1)


%===========================================
%%  remove files /keep valid AST-files
%% give new proc-Number
%===========================================
t2orig=t2;
t2(find(cell2mat(t2(:,end))==0),:)=[];

[u,~ ,in]=unique(cell2mat(t2(:,1)));%renumber ProcID
t2(:,1)=num2cell(in);


% mass-copy files  ;
% input:
% f1: cell of files =sources (this are copied)
% f2: cell of filenames to create
% f1 and f2 match in size

function copyfilem(f1,f2)

% f1=s.a
% f2=stradd(s.a,'c_')

if ischar(f1)
    f1=cellstr(f1);
end
if ischar(f2)
    f2=cellstr(f2);
end

for i=1:length(f1)
    copyfile(f1{i}, f2{i} ,'f');
end


function he=getparmfiles(li,lih)
%     'warpParamfile'  fullfile(fileparts(fileparts(which('ant.m'))),'elastix','paramfiles' ,'p33_bspline.txt')      'parameterfile used for warping'  @getparmfiles

he=[];
pap=fileparts(which('trafoeuler2.txt'));
msg='select one/more Parameter file for rigid/affine/bspline transformation (in that order)"';
[t,sts] = spm_select(inf,'any',msg,'',pap,'.*.txt','');
t=cellstr(t);
if isempty(t); return; end
% t=cellstr(t);
% [s ss]=paramgui('getdata')
% paramgui('setdata','x.wa.orientelxParamfile',[t ' % rem'])
he=t;
return
