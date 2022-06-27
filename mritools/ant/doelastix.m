
%..
%% #yk doelastix
% #k calculate transformation, apply transformation to other images
% input image: calculation: 3d; transformation 3d or 4d
% doelastix( direction, path,images,interp,  localtransform ,params)
% params.resolution: if defined, this parameter specifies the image output resolution.
%                     - can be triple value of final volume dimension [200 200 50]
%                     - or tripple of voxel size [.06 .05 .1]
%                     -if omitted, default target resolution is used
%                     -nan's can be used...than the respective target resolution is used for that dimension
%                      example: [.1]  ...same as [.1 .1 .1] voxel-resolution
%                               [nan .01 nan] ... use orig. target vox.resolution from 1st and 3rd dim and .01 for 2nd dim
%                               [100] ...same as [100 100 100] image-dimension
%                               [nan nan 100] ... use orig. target image-dimension from 1st and 2nd dim and 100 for 3rd-dim
% params.source: either 'intern' or 'extern'
%                      'intern' or [1] {default}: the image is located in the dat-folder
%                      - if 'intern': the parameter can be omitted
%                      -'extern' or [2] : image is located somewhere else (for instance in the
%                        template folder). In this case the paramter must be specified
% _______________________________________________________________________________________________________________________________________________
% #yk ..WHEN CALLED FROM ANT-GUI
% this function aims to deform other images
%     -select the file(s) to transform   - use the same type of images (masks vs nonMasks .. because of interpolation!)
%     -than you have to set the parameters in a subsequent window:
%         direction           transformation direction: [1] to Allen Space, [-1] to native space
%         voxresolution       leave this field empty (use vox-resolution from the templates)
%         interpolation order [0,1,2,3] for NN, linear, 2nd order, 3rd order (spline)
%                              -use [0] for masks and atlases
%         source:    - either [1] image ('intern') is in the dat-folder or [2] image is somewhere else ('extern')
%                    - see above
% _______________________________________________________________________________________________________________________________________________
%   #wr [1] calculate transformation (xwarp-step)
%% [1] Calculation (forward and backward calculation is done in one process)-->run only once!!
% doelastix(task,     path, images ,parafiles )
% task : 'calculate'
% path:    local mousepath
% parafiles:  cell of elastix-parameterfiles (txt-files)
% images: cell with 2 inputs: fixed Image  & moving IMage, i.e.    { "fullpathOf AVGT.nii"   "fullpathOf t2.nii"}
% _______________________________________________________________________________________________________________________________________________
%   #wr [2]Apply transformation to other images:
%
%   doelastix(direction, [], files  ,interpx ,'local' );
%   arg1:  direction .. which direction to warp [1]to allen [-1] to native space
%   arg2:  voxresolution--> leave it empty
%   arg3: files --> cell with nifti files to warp
%   arg4: interpolation order [0,1,2,3] for NN, linear, 2nd order, 3rd order (spline)
%   arg5: apply additional rigid body transformation (calculated beforehand) ..use 'local' to use the local parameters
%   example:
%       files={'O:\harms1\harms3_lesionfill\dat\s20150505SM02_1_x_x\lesion_64.nii'
%       'O:\harms1\harms3_lesionfill\dat\s20150505SM03_1_x_x\lesion_64.nii'
%       'O:\harms1\harms3_lesionfill\dat\s20150505SM09_1_x_x\lesion_64.nii'}
%       doelastix(1   , [],      files                      ,3 ,'local' );
%% [2a] Transformation Forward (>>to ALLENspace)
% doelastix(task,       path  ,files, interp, M  )
% task:  'transform'   or  1  (just 1 !)
% path:    local mousepath          or   empty  []
% files:     cell of all files to be transformed (fullpathlist),  files can be from different directories, but then set M='local'
% interp: interpolationMethod:   -1  used for 0-1-range images such as TPMs (GM,WM,CSF)  , (due to elastix-bug ??)
%                                                      0 used for binary images or images not to interpolate such as anatom-label-volumes
%                                                      1,2,3 spline interpolation   (use 3 or 4) for "fullrange"
%                         -if there are more tranformation files, the same interpolation method is applied
%                           alternatively you could specifiy an interpolation vector of length of files (example: 2 files   --> interp=[3 -1] --> 1st. file spline interpolated, 2nd file int the 0-1range)
% M         : transformationMatrix        -[] do not use/apply transformation matrix (reorient.mat)
%                                                           -4x4 orientationMatrix, -->this will be used/applied for all inputfiles>>thus inputfiles should derive from the same directory
%                                                           -'local' (string)  : for each file use the locally stored reorientationMatrix (it is assumed that the "reorient.mat" file
%                                                              is located in the file(i)'s directory   )
%% [2b] Transformation Backward (>>to MOUSESspace)
% same as Forward transformation but the task is 'transforminv' instead 'transform'
% task:  'transforminv'   or  -1  (just -1 !)
%% EXAMPLES
%% EXAMPLE FILES;
%     f1=fullfile(pwd,'sAVGT.nii')
%     f2=fullfile(pwd,'_b1grey.nii')
%     f3=fullfile(pwd,'t2.nii')
%     f4=fullfile(pwd,'c1t2.nii')
%     f5=fullfile(pwd,'c1c2mask.nii')
%     path=pwd
%% CALCULATION
%     fixim=fullfile(pwd, 'templateGMWM.nii'); %FIEX IMAGE
%     movim=fullfile(pwd, 'mouseGMWM.nii'); %MOVINF IMAGE
%     parafiles={'V:\mritools\elastix\paramfiles\Par0025affine.txt'
%         'V:\mritools\elastix\paramfiles\Par0033bspline_EM2.txt'}  %ELASTIX PARAMETERFILES
%     doelastix('calculate'  ,path, {fixim movim} ,parafiles)   ;
%% BACKWARD TRAFO
%     doelastix('transforminv'  , path,    {f1 f2} ,[3 -1]  )   ;%TPM with interp=-1' !!! (elastix:0-1 range not defined)
%     doelastix('transforminv'  , path,    {f1 f2}   )    ;%if not specified interp=3
%     doelastix('transforminv'  , path,    {f1 f2} ,[3]  )
%% FORWARD TRAFO
%     doelastix('transform'  , path,    {f3 f4} ,[3 -1]  )   ;%TPM with interp=-1' !!! (elastix:0-1 range not defined)
%     doelastix('transform'  , path,    { f4} ,[ -1]  )   ;%TPM with interp=-1'
%     doelastix('transform'  , path,    { f5} ,[ 0]  )   ; %BINARYMASK with interp=0'
%% use TRANSFORMATION matrix(4x4) (Variable | stored as reorient.mat)
%     (1)  use reorient matrix M(4x4) from workspace
%     doelastix('transforminv'  , path,    {fullfile(path,'sAVGT.nii')} ,[] ,M )
%    (2)  forward, useLocalPath,  files2trafo from different Mousefolders , interp, use Locally stored ReorientMat
%      doelastix(1    , [],      files                          ,3 ,      'local' );
%
%% —————————————————————————————————————————————————————————————————————————————————————————————————
%% OTHER TRANSFORMATION EXAMPLES
%% —————————————————————————————————————————————————————————————————————————————————————————————————
%
%% =======[ INTERNAL SOURCE]=====================================================================================
%% internal source: fullpath images, change output resolution
%     fis=doelastix(1, 'O:\data4\recode2Rat_WHS2\dat\t_fastsegm','O:\data4\recode2Rat_WHS2\dat\t_fastsegm\c1t2.nii',4,'local');
%
%% internal source: fullpath images, change output resolution
%     files = {'O:\data4\recode2Rat_WHS2\dat\t_fastsegm\c1t2.nii'
%              'O:\data4\recode2Rat_WHS2\dat\test_uncut\c1t2.nii'};
%     pp.source =  'intern';
%     pp.resolution =  [0.1  0.1  0.1];
%     fis=doelastix(1, [],files,4,'local' ,pp);
%
%% internal source: short image names (no full path)
%     files={'c1t2.nii', 'c2t2.nii'};
%     mdirs = {'O:\data4\recode2Rat_WHS2\dat\t_fastsegm'
%              'O:\data4\recode2Rat_WHS2\dat\test_uncut'};
%     pp.source =  'intern';
%     fis=doelastix(1, mdirs,files,4,'local' ,pp);
%
%% internal source: apply for all pre-selected dirs
%     files={'c1t2.nii', 'c2t2.nii'};
%     pp.source =  'intern';
%     fis=doelastix(1, [],files,4,'local' ,pp);
%
%% internal source: the parameter 'source' can be omitted, for internal sources
%     files={'c1t2.nii', 'c2t2.nii'};
%     fis=doelastix(1, [],files,4,'local');
%
%% =======[ EXTERNAL SOURCE]=====================================================================================
%%  external source
%     files = {'O:\anttemplates\rat_Waxholm\ANO_VH.nii'
%              'O:\anttemplates\rat_Waxholm\#cut.nii' };
%     mdirs = {'O:\data4\recode2Rat_WHS2\dat\t_fastsegm'
%              'O:\data4\recode2Rat_WHS2\dat\test_uncut' };
%     pp.source =  'extern';
%     fis=doelastix(-1, mdirs,files,0,'local' ,pp);
%
%%  external source: change output resolution
%     files = {'O:\anttemplates\rat_Waxholm\#cut.nii'
%              'O:\anttemplates\rat_Waxholm\ANO_VH.nii' };
%     mdirs = {'O:\data4\recode2Rat_WHS2\dat\t_fastsegm'};
%     pp.resolution =  [0.1  0.1  0.1];
%     pp.source     =  'extern';
%     fis=doelastix(-1, mdirs,files,0,'local' ,pp);
%
%% external source: apply for all pre-selected dirs
%     files = {'O:\anttemplates\rat_Waxholm\#cut.nii'
%              'O:\anttemplates\rat_Waxholm\ANO_VH.nii' };
%     mdirs = [];
%     pp.source     =  'extern';
%     fis=doelastix(-1, mdirs,files,0,'local' ,pp);
%% —————————————————————————————————————————————————————————————————————————————————————————————————
% #bb calc forward only
% - use struct: with field: 'calcforwardonly' =1
% example:
% doelastix('calculate' ,s.pa, {fixim movim}  ,parafiles2,[],struct('calcforwardonly',1)  )


%  doelastix('calculate',     path, fixmovIMG,  )
%doelastix('transform'       path  ,files,interp  )
%doelastix('transforminv'  path,  files,interp   )
% doelastix('transforminv'  , pa,    {fullfile(pa,'_sample.nii')},3,M   ) %where M is the reorientMAT(4x4)
%% —————————————————————————————————————————————————————————————————————————————————————————————————

function out=doelastix( task, arg1,arg2,arg3,  arg4,params)
out='';

% %     if 0
% %        task
% %        arg1,
% %        arg2,
% %        arg3
% %        arg4
% %        params
% %     %% —————————————————————————————————————————————————————————————————————————————————————————————————
% %     %% EXTERN FILES
% %     %    task =
% %     %      1
% %     % arg1 =
% %     %      []
% %     % arg2 =
% %     %     'O:\anttemplates\rat_Waxholm\ANO_VH.nii'
% %     % arg3 =
% %     %      4
% %     % arg4 =
% %     % local
% %     % params =
% %     %      []
% %     %% —————————————————————————————————————————————————————————————————————————————————————————————————
% %     %% FILES IN DIRS
% %     % task =
% %     %      1
% %     % arg1 =
% %     %      []
% %     % arg2 =
% %     %     'O:\data4\recode2Rat_WHS2\dat\t_fastsegm\c1t2.nii'
% %     %     'O:\data4\recode2Rat_WHS2\dat\test_uncut\c1t2.nii'
% %     % arg3 =
% %     %      4
% %     % arg4 =
% %     % local
% %     % params =
% %     %      []
% %      %% —————————————————————————————————————————————————————————————————————————————————————————————————
% %
% %     end



warning off;

if exist('params')~=1 | isempty(params)
    params={};
end


%% direction also assigned using 1/-1
if   isnumeric(task);
    if      task==1     ;  task='transform';
    elseif  task==-1    ;  task='transforminv';
    end
end
%% —————————————————————————————————————————————————————————————————————————————————————————————————
% % % if 0
% % %     f1=fullfile(pwd,'sAVGT.nii')
% % %     f2=fullfile(pwd,'_b1grey.nii')
% % %     f3=fullfile(pwd,'t2.nii')
% % %     f4=fullfile(pwd,'c1t2.nii')
% % %     f5=fullfile(pwd,'c1c2mask.nii')
% % %     path=pwd
% % %
% % %     %calculate
% % %     fixim=fullfile(pwd, 'templateGMWM.nii')
% % %     movim=fullfile(pwd, 'mouseGMWM.nii')
% % %     parafiles={'V:\mritools\elastix\paramfiles\Par0025affine.txt'
% % %         'V:\mritools\elastix\paramfiles\Par0033bspline_EM2.txt'}
% % %     doelastix('calculate'  ,path, {fixim movim} ,parafiles)   ;
% % %
% % %
% % %     % BACKWARD
% % %     doelastix('transforminv'  , path,    {f1 f2} ,[3 -1]  )   ;%TPM with interp=-1' !!! (elastix:0-1 range not defined)
% % %     doelastix('transforminv'  , path,    {f1 f2}   )    ;%if not specified interp=3
% % %     doelastix('transforminv'  , path,    {f1 f2} ,[3]  )
% % %
% % %     %FORWARD
% % %     doelastix('transform'  , path,    {f3 f4} ,[3 -1]  )   ;%TPM with interp=-1' !!! (elastix:0-1 range not defined)
% % %     doelastix('transform'  , path,    { f4} ,[ -1]  )   ;%TPM with interp=-1'
% % %     doelastix('transform'  , path,    { f5} ,[ 0]  )   ; %BINARYMASK with interp=0'
% % %
% % %     doelastix('transforminv'  , path,    {fullfile(path,'sAVGT.nii')} ,[] ,M ) %use reorientMAT from workspace
% % %
% % %     %%  forward, useLocalPath,  files2trafo from different Mousefolders , interp, use Locally stored ReorientMat
% % %     doelastix(1    , [],      files                          ,3 ,      'local' );
% % % end
%% —————————————————————————————————————————————————————————————————————————————————————————————————

prefix={'x_' 'ix_'};
folder={'elastixForward' 'elastixBackward'};

switch task
    %% —————————————————————————————————— CALCULATION  ————————————————————————————————————————————————
    
    case 'calculate'
        z.prefix=prefix;
        z.folder=folder;
        z.path=arg1;
        z.fiximg=arg2{1};
        z.movimg=arg2{2};
        z.parafiles=arg3;
        
        if exist('arg4')
            if iscell(arg4)
                try;                z.fiximgMSK=arg4{1} ; catch; z.fiximgMSK=[]; end
                try;                z.movimgMSK=arg4{2} ; catch; z.movimgMSK=[]; end
            end
        end
        if exist('params'); %  ADDITIONAL PARAMETERSTRUCT
            if isstruct(params)
                z.pp=params;
            end
            
        end
        
        %         try;               timex('CALCULATE TRANSFORMATION: dt=');  end
        calculate(z);        %% now calculate
        %         try;              delete(timerfind('tag','timex99'));  statusbar(0)   ;end
    otherwise
        %% ———————————————        FORWARD/BACKWARD TRANSFORM FILE     ——————————————————————————————
        switch task
            case 'transform'
                z.direction= 1;             %warpdirection [1,-1].forward,backward
                z.prefix=prefix{1};       %file prefix used
                z.folder=folder{1};     %folder were transformParas.txt etc will be written
                if exist('arg4'); z.M=arg4; else; z.M=[]; end  %reorientMAT  applied if given
            case 'transforminv'
                z.direction=-1;
                z.prefix=prefix{2};
                z.folder=folder{2};
                if exist('arg4'); z.M=arg4; else; z.M=[]; end  %reorientMAT
        end
        z.path=arg1;
        z.files  =arg2;
        try ; z.interp=arg3  ; catch  ; z.interp=[];end  %% INTERPOLATION (default 3)
        
        z.params=params;
        
        %         try;               timex('TRANSFORM IMAGES: dt=');  end
        if isfield(z.params,'source')==0
            z.params.source='intern';
        end
        if isnumeric(z.params.source)
            if z.params.source==1;  z.params.source='intern';
            else                 ;  z.params.source='extern';
            end
        end
        
        if strcmp(z.params.source,'intern');    % ## USE FILENAMES FROM DAT-FOLDER
            z.files=cellstr(z.files);
            if  isempty(fileparts(z.files{1}))  %% ## USING FILENAMES WITHOUT FULLPATH
                mdirs={};
                if isempty(z.path)
                    mdirs=antcb('getsubjects') ; %get selected paths from GUI
                else
                    mdirs=cellstr(z.path) ;
                end
                files=cellstr(z.files);
                list={};                       %make FP-filename-list
                for ii=1:length(mdirs)
                    for jj=1:length(files)
                        list(end+1,1)={fullfile(mdirs{ii},files{jj})};
                    end
                end
                z2=z;
                z2.path=[];
                z2.files=list;
                out=trafo(z2);
            else               %% CONVENTIONAL FULLPATH-NAME IMAGES
                out=trafo(z) ;
            end
            
            
            
        elseif strcmp(z.params.source,'extern'); % ## use from outside dat-folder
            if isempty(z.path)
                z.path=antcb('getsubjects') ; %get selected paths from GUI
            end
            out={};
            zz=z;
            zz=rmfield(zz,'path');
            paths=cellstr(z.path);
            for j=1:length(paths)
                zz.path=paths{j};
                outj=trafo(zz);
                out=[out;outj];
            end
        else
            disp(['[source] must be "intern" or extern']);
        end
        
        % ==============================================
        %% BATCH
        % ===============================================
        makebatchTrafo(z);
        
        % ==============================================
        %% SHOWINFO
        % ===============================================
        if 0
            fis=out;
            for jj=1:length(fis)
                fpdir=fileparts(fis{jj});
                [~,ID,~ ]=fileparts(fpdir);
                showinfo2( ['[' ID '] new volume' ] ,fis{jj},z.direction) ; drawnow;
            end
        end
        
end
return


%% ################################################################################

%%  [2]    transform forward, backward

%% ################################################################################

function out=trafo(z)
%% check files (cell) and add interpolationMethod
if ischar(z.files);                            z.files  = cellstr(z.files)                         ;end                                             % cell only
if isempty(z.interp);                          z.interp = ones(1, length((z.files) ))*3            ; end                        % default interp if empty
if length(z.files)~=length(z.interp);          z.interp = repmat(z.interp(1),[1 length(z.files)  ]); end   %replicate interp, if one interpvalue given for all files


z.path=char(z.path);
%% get TRAFOFILE
if ~isempty(z.path)
    z.getPathInEachLoop=0;
    z.trafopath=   fullfile(z.path,z.folder) ;
    z.trafofile=   dir(fullfile(z.trafopath,'TransformParameters*.txt'));
    z.trafofile=   fullfile(z.trafopath,z.trafofile(end).name);                                          %the last TRAFOFILE contains all infos
else
    z.getPathInEachLoop=1;
end

%% check wether local REORIENT.MAT SHOULD BE JUSED (z.m='local')
%% use local Reorient.mat
if isstr(z.M) && ~isempty(z.M)
    if            strcmp(z.M,'local')
        z.getReorientmatInEachLoop=1; %load in each ImageLoop
    end
else
    z.getReorientmatInEachLoop=0;
end

% makebatchTrafo(z)

%% apply for each file
for i=1:length(z.files)
    filename=z.files{i};
    
    %% use local path
    if z.getPathInEachLoop==1;
        z.path   = fileparts(filename);
        z.trafopath= fullfile(z.path,z.folder) ;
        z.trafofile= dir(fullfile(z.trafopath,'TransformParameters*.txt'));
        z.trafofile= fullfile(z.trafopath,z.trafofile(end).name);                                          %the last TRAFOFILE contains all infos
    end
    
    %% load the local Reorient.mat
    if z.getReorientmatInEachLoop==1
        Mpath=fullfile(z.path,'reorient.mat');
        if exist(Mpath)==2
            load(Mpath);
            z.M=M;
        else
            keyboard
        end
    end
    
    %% set internal imagePRECISION
    %               // *********** used for all other images ***************
    %             (FixedInternalImagePixelType "float")
    %             (MovingInternalImagePixelType "float")
    %             (ResultImagePixelType "float")
    %
    %             // *********** used for 64bit images ***************
    %             //(FixedInternalImagePixelType "short")
    %             //(MovingInternalImagePixelType "short")
    %             //(ResultImagePixelType "float")
    %                 v=  spm_vol(filename);
    % rm_ix(trafofile,'FixedInternalImagePixelType');
    % rm_ix(trafofile,'MovingInternalImagePixelType');
    % rm_ix(trafofile,'ResultImagePixelType');
    
    %———————————————————————————————————————————————
    %%  run over 4d data
    %———————————————————————————————————————————————
    v0=  spm_vol(filename);
    
    
    v=v0(1);
    
    
    if v.dt(1)<=100%32
        if v.dt(1)==16
            set_ix(z.trafofile,'FixedInternalImagePixelType','short');
            set_ix(z.trafofile,'MovingInternalImagePixelType','short');
            set_ix(z.trafofile,'ResultImagePixelType','float');
        else
            set_ix(z.trafofile,'FixedInternalImagePixelType','float');
            set_ix(z.trafofile,'MovingInternalImagePixelType','float');
            set_ix(z.trafofile,'ResultImagePixelType','float');
        end
    else
        set_ix(z.trafofile,'FixedInternalImagePixelType','short');
        set_ix(z.trafofile,'MovingInternalImagePixelType','short');
        set_ix(z.trafofile,'ResultImagePixelType','float');
    end
    
    %===========================================================================================
    %% change resolution
%     if isfield(z.params,'resolution')
%         res={};
%         res.size  = get_ix(z.trafofile,'Size');
%         res.space = get_ix(z.trafofile,'Spacing');
%         res.input=z.params.resolution;
%         if sum(z.params.resolution>2)==3  % dims where given
%             res.spaceNew =(res.size./res.input).*res.space;
%             res.sizeNew =res.input;
%         else  %voxelsize
%             
%             res.sizeNew =round((res.space./res.input).*res.size);
%             res.spaceNew =res.input;
%         end
%         
%         set_ix(z.trafofile,'Size'   , res.sizeNew );
%         set_ix(z.trafofile,'Spacing', res.spaceNew );
%     end
    %===========================================================================================
    
    
    % ==============================================
    %%    %% TRANSFORM VOLUME INNER LOOP 3d/4d-DATA
    % ===============================================
    
    %% BUG: calculation and tranformation on DIFFERENT machines !!!!!!
    if 1
        initrafoParamFN=   get_ix(z.trafofile,'InitialTransformParametersFileName');
        [pas fis exs]=fileparts(initrafoParamFN);
        if strcmp(exs,'.txt')==1
            initrafoParamFN_neu=fullfile(z.trafopath, [fis exs]);
            set_ix(z.trafofile,'InitialTransformParametersFileName',initrafoParamFN_neu);
        end
    end
    
    
    
    if z.interp(i)==-1 %TPMs -->between 0 and 1   ...ALTERNATIVE FOR 0-1-RANGE-DATA
        set_ix(z.trafofile,'FinalBSplineInterpolationOrder',    3);
    else
        set_ix(z.trafofile,'FinalBSplineInterpolationOrder',    z.interp(i));        
    end
    
    
    if length(v0)==1
        for jvol=1:length(v0)
            transformVolume(  filename,i, jvol, v0, z);
        end %4d
    else
        parfor jvol=1:length(v0)
            transformVolume(  filename,i, jvol, v0, z);
        end %4d
    end
    
    
    
    
    %===========================================================================================
    
    [pas fis ext]=fileparts(filename); %RENAME FILE
    
    % add SUFFIX to FILENAME
    if isfield(z.params,'fileNameSuffix') && ~isempty(z.params.fileNameSuffix);
        uscore='_';
        if strcmp(z.params.fileNameSuffix(1),'_')==1
            uscore='';
        end
        fileout=fullfile(z.path, [z.prefix fis uscore z.params.fileNameSuffix ext]);
    else
        fileout=fullfile(z.path, [z.prefix fis ext]);
    end
    
    for jvol=1:length(v0) %4D-data
        warpedfile=fullfile(z.path,[z.folder],[ 'trans_' pnum(jvol,4)], 'elx___tobewarped.nii');
        [hd4 d4dum]=rgetnii(warpedfile);
        if jvol==1 %allocmem
            d4= zeros([size(d4dum) length(v0)]);
        end
        d4(:,:,:,jvol)=d4dum;
    end
    try; delete(fileout); end
    rsavenii(fileout,hd4,d4,v.dt);
    %clean-UP
    for jvol=1:length(v0) %4D-data
        warpfolder=fullfile(z.path,[z.folder],[ 'trans_' pnum(jvol,4)]);
        try;
            rmdir(warpfolder,'s');
        end
    end
    %     end
    %===========================================================================================
    %% change to original resolution
%     if isfield(z.params,'resolution')
%         set_ix(z.trafofile,'Size'   , res.size   );
%         set_ix(z.trafofile,'Spacing', res.space  );
%     end
    %===========================================================================================
    % ==============================================
    %%   MESSAGE
    % ===============================================
    if 1
        try
            % disp([pnum(i,4) '] transformed file <a href="matlab: explorerpreselect(''' fileout ''')">' fileout '</a>'  ]);
            fpdir=fileparts(fileout);
            [~,ID, ImgName ]=fileparts(fpdir);
            showinfo2( ['[' pnum(i,4) '][' ID ']--> new image' ] ,fileout ,z.direction) ; drawnow;
        end
    end
    out{i,1}=fileout;
end% files
%clean up
try; delete(tempfile0);end
try; delete(fullfile(z.path,'transformix.log'));end









%% ################################################################################
% transform volume, inner loop (3d/4d)--parfor
%% ################################################################################
function transformVolume(  filename,i, jvol, v0, z)




%———————————————————————————————————————————————
%%  run over 4d data
%———————————————————————————————————————————————

%% work on templatefile, which is renamed after trafo
% if length(v0)==1 %3D
%     tempfile0=fullfile(z.path, '__tobewarped.nii' );% WE WORK ON THIS
%     copyfile(filename,tempfile0,'f'); %
%     trafofile=z.trafofile;
%     tpath=z.path;
% else
try; rmdir(tpath,'s'); end
tpath=fullfile(z.path, z.folder, ['trans_' pnum(jvol,4)] );
mkdir(tpath);
tempfile0=fullfile(tpath, ['__tobewarped'  '.nii'] );% WE WORK ON THIS
delete(tempfile0);
%         if jvol==1 %load data once
%             [hx x]=rgetnii(filename,jvol);
%         end
%         rsavenii(tempfile0,hx(1),x(:,:,:,jvol));

[hx x]=rgetnii(filename,jvol);
% if hx.dt(1)==2
%     hx.dt(1)=64;
% end
rsavenii(tempfile0,hx(1),x);

% trafofile
[pa fis ext]=fileparts(z.trafofile);
trafofile=fullfile(tpath,[regexprep(fis,'TransformParameters',['temptrafo'  ])  '.txt']);
copyfile(z.trafofile, trafofile,'f');

z.afftrafo=strrep(z.trafofile,'.1.txt','.0.txt');
if exist(z.afftrafo)==2
    [pa fis ext]=fileparts(z.afftrafo) ;
    afftrafo=fullfile(tpath,[regexprep(fis,'TransformParameters',['temptrafo'  ])  '.txt']);
    copyfile(z.afftrafo, afftrafo,'f');
    set_ix(trafofile, 'InitialTransformParametersFileName',afftrafo)
end


if isfield(z.params,'resolution')
    res={};
    res.size  = get_ix(trafofile,'Size');
    res.space = get_ix(trafofile,'Spacing');
    res.input=z.params.resolution;
    
    changeResolution=0;
    if sum(isnan(z.params.resolution)==1)==3 % "triple-NANs" [nan nan nan]-value
        changeResolution=0;
    elseif sum(isnan(z.params.resolution)==1)>=0 && length(z.params.resolution)==3  % one or two nans
        changeResolution=1;  
    elseif sum(isnan(z.params.resolution)==1)==0 && length(z.params.resolution)==1 % single-no-NAN-value
        changeResolution=1;  
    end
    if  sum(isnan(z.params.resolution)==1)==1 && length(z.params.resolution)==1 ;% [nan]-value
        changeResolution=0;
    end
    
    if changeResolution==1
        res.input=z.params.resolution;
        if length(res.input)<3
            res.input=repmat(res.input(1),[1 3]);
        end
        nanIDX=(isnan(res.input));
        
        if max(z.params.resolution)>20 % sum(z.params.resolution>2)==3  % DIMS  given
            res.input(nanIDX)=res.size(nanIDX);
            res.spaceNew =(res.size./res.input).*res.space;
            res.sizeNew =res.input;
        else                                 %voxelsize
            res.input(nanIDX)=res.space(nanIDX);
            res.sizeNew =round((res.space./res.input).*res.size);
            res.spaceNew =res.input;
        end
        
        set_ix(trafofile,'Size'   , res.sizeNew );
        set_ix(trafofile,'Spacing', res.spaceNew );
    end
end

%% ====================[imgSize]===========================
if isfield(z.params,'imgSize') && length(z.params.imgSize)==3
    res.imgSize=get_ix(trafofile,'Size');
    val           =res.imgSize;
    ixreplace     =find(~isnan(z.params.imgSize));
    val(ixreplace)=z.params.imgSize(ixreplace);
    set_ix(trafofile,'Size'   , val );
    res.imgSizeNew=val;
end
%% ====================[imgOrigin]===========================
if isfield(z.params,'imgOrigin') && length(z.params.imgOrigin)==3
    res.imgOrigin =get_ix(trafofile,'Origin');
    val           =res.imgOrigin;
    ixreplace     =find(~isnan(z.params.imgOrigin));
    val(ixreplace)=z.params.imgOrigin(ixreplace);
    set_ix(trafofile,'Origin'   , val );
    res.imgOriginNew=val;
end

%% ===============================================

if z.direction==1 && ~isempty(z.M)  %apply TRAFO in FORWARD-DIR
    v=  spm_vol(tempfile0);
    spm_get_space(tempfile0,      inv(z.M) * v.mat);
end

%% —————————————————————————————————————————————————————————————————————————————————————————————————
%%    set size of IMAGE
%     if z.direction==   -1
% %         hh=spm_vol(fullfile(z.path,'t2.nii'));
% %         disp(['  check dim inverse: ' num2str(hh.dim)]);
% %         set_ix(trafofile,'Size',    hh.dim);
%     elseif z.direction==1
%         hh=spm_vol(fullfile(z.path,'_refIMG.nii')); %(Size 172 215 115)
%         disp(['  check dim forward: ' num2str(hh.dim)]);
%         set_ix(trafofile,'Size',    hh.dim);
%     end
%% —————————————————————————————————————————————————————————————————————————————————————————————————
%     edit(trafofile)


if z.interp(i)==-1 %TPMs -->between 0 and 1   ...ALTERNATIVE FOR 0-1-RANGE-DATA
    [ha  a]=rgetnii( tempfile0);
    range1=[min(a(:))  max(a(:))];
    dt=ha.dt;
    pinfo=ha.pinfo;
    ha.dt=[16 0];
    a=a.*10000;
    tempfile=fullfile( tpath,['_elxTemp.nii']);
    rsavenii(tempfile,  ha,a );
    
    
    % set_ix(z.trafofile,'FinalBSplineInterpolationOrder',    3);
    % [im4,tr4] =        run_transformix(  tempfile ,[],trafofile,   z.path ,'');
    [~,im4,tr4]=evalc('run_transformix(  tempfile ,[],trafofile,   tpath ,'''')');
    
    %% set original range
    [hb  b]=rgetnii( im4);
    b2=b./10000;
    %     [pas fis ext]=fileparts(tempfile);
    fileout=fullfile(tpath, [ 'elx___tobewarped.nii']);
    %newfile=stradd(z.files{i},  z.prefix ,1 );
    rsavenii(fileout,  hb,b2 );
    try; delete(tempfile);end
    try; delete(im4);       end
else  %% USE ELASTIX INTERPOLATION
    
    %% ANO-check inverse-->problem with precission, since values are to large
    [~, fi,ext]=fileparts(filename);
    if strcmp([fi ext],'ANO.nii') && z.interp(i)==0
        [dx dc]=rgetnii(tempfile0);
        uni=unique(dc);
        il=find(uni>1e6);
        maxval=uni(min(il)-1);
        valtrans=[uni(il)  [20000+[1:length(il)]]'   ];
        
        for j=1:size(valtrans,1)
            dc(dc==valtrans(j,1))=valtrans(j,2);
        end
        rsavenii(tempfile0,dx,dc);
    end
    
    % [im4,tr4] =       run_transformix(  tempfile0 ,[],trafofile, z.path ,'');
    [~,im4,tr4]=evalc('run_transformix(  tempfile0 ,[],trafofile, tpath ,'''')');  
    if strcmp([fi ext],'ANO.nii') && z.interp(i)==0
        [dx dc]=rgetnii(im4);
        for j=1:size(valtrans,1)
            dc(dc==valtrans(j,2))=valtrans(j,1);
        end
        rsavenii(im4,dx,dc,[64 0]);
    end
    fileout=im4;
end

if z.direction==-1 && ~isempty(z.M)  % TRAFO in BACKWARD-DIR
    v=  spm_vol(fileout);
    spm_get_space(fileout,      (z.M) * v.mat);
    doreslice=1;
    
    if isfield(z.params,'resolution'); % userdefined resolution (dim/voxsize) for output in native space
        doreslice=0;
        %disp('temp: no-reslicing');
    end
    
    if doreslice==1
        rreslice2target(fileout,fullfile(z.path,'t2.nii') , fileout  , 0);
        %disp('temp: reslicing');
    end
end








%% ################################################################################

%%  [1] calculate forward & backward

%% ################################################################################

function calculate(z)

%% —————————————————————————————————————————————————————————————————————————————————————————————————
%% 1st copy parameterFiles
%% —————————————————————————————————————————————————————————————————————————————————————————————————
parafiles2=replacefilepath(stradd(z.parafiles,'x',1),z.path);
for i=1:length(parafiles2)
    copyfile(z.parafiles{i},parafiles2{i},'f');
end
parafiles=parafiles2;


%% —————————————————————————————————————————————————————————————————————————————————————————————————
%% run Elastix : forwardDirection
%% —————————————————————————————————————————————————————————————————————————————————————————————————
z.outforw=fullfile(z.path,z.folder{1}); mkdir(z.outforw);


fprintf('..calc forward..','%s');

if isfield(z,'fiximgMSK')==0; z.fiximgMSK=[]; end
if isfield(z,'movimgMSK')==0; z.movimgMSK=[]; end
[~,im,trfile]=evalc('run_elastix(z.fiximg,z.movimg,    z.outforw  ,parafiles,   z.fiximgMSK,z.movimgMSK     ,[],[],[])');


if isfield(z,'pp')  %%CALC ONLY FORWARD
    if isfield(z.pp,'calcforwardonly') && z.pp.calcforwardonly==1
        cleanup(z);
        return
    end
end

%% —————————————————————————————————————————————————————————————————————————————————————————————————
%% run Elastix : backWardDirection
%% —————————————————————————————————————————————————————————————————————————————————————————————————
%% copy PARAMfiles

fprintf('calc backward..','%s');
parafilesinv=stradd(parafiles,'inv',1);
for i=1:length(parafilesinv)
    copyfile(parafiles{i},parafilesinv{i},'f');
    pause(.01)
    rm_ix(parafilesinv{i},'Metric'); pause(.1) ;
    set_ix3(parafilesinv{i},'Metric','DisplacementMagnitudePenalty'); %SET DisplacementMagnitudePenalty
end

trafofile=dir(fullfile(z.outforw,'TransformParameters*.txt')); %get Forward TRAFOfile
trafofile=fullfile(z.outforw,trafofile(end).name);

z.outbackw=fullfile(z.path, z.folder{2} ); mkdir(z.outbackw);
% [im3,trfile3] =      run_elastix(z.movimg,z.movimg,    z.outbackw  ,parafilesinv,[], []       ,   trafofile   ,[],[]);
[~,im3,trfile3]=evalc('run_elastix(z.movimg,z.movimg,    z.outbackw  ,parafilesinv,[], []       ,   trafofile   ,[],[])');


trfile3=cellstr(trfile3);
%set "NoInitialTransform" in TransformParameters.0.txt.
set_ix(trfile3{1},'InitialTransformParametersFileName','NoInitialTransform');%% orig

cleanup(z);
fprintf('done.\n','%s');



function cleanup(z);
%% —————————————————————————————————————————————————————————————————————————————————————————————————
%% clean up
%% —————————————————————————————————————————————————————————————————————————————————————————————————
try
    k=dir(fullfile(z.outforw,'*.nii'));
    for i=1:length(k)
        try; delete(           fullfile(z.outforw,k(i).name)              )  ;end
    end
end
try
    k=dir(fullfile(z.outbackw,'*.nii'));
    for i=1:length(k)
        try; delete(           fullfile(z.outbackw,k(i).name)              )  ;end
    end
end

return



function timex(task)
delete(timerfindall);
% task='calculate'
us.task=task;
us.t=tic;
t = timer('period',6.0,'userdata',us);
set(t,'ExecutionMode','fixedrate','StartDelay',0,'tag','timex99');
set(t,'timerfcn',['t=timerfind(''tag'',''timex99'')   ; us=get(t,''userdata'');' ...
    'dt=toc(us.t);'  ,  'statusbar(0, sprintf([ ''  '' us.task   ''%2.2fmin'' ],dt/60));'   ]);
%           'dt=toc(us.t);   statusbar(0,num2str(dt))  '      ]);
%       'dt=toc(us.t);'  ,  'statusbar(0, sprintf([''%2.2f min'' ],dt/60));'   ]);
start(t);
return

function makebatchTrafo(s)








% ==============================================
%%   makebatch
% ===============================================


s.files =cellstr(s.files);
if ~isempty(s.path)
    s.path  =cellstr(s.path);
end

lg={'%% DEFORM VIA ELASTIX '};

if length(s.files )==1
    lg{end+1,1} =[ 'files = ' '{' '''' s.files{1} '''' '};'  ];
else
    lg{end+1,1}=[ 'files = ' '{' '''' s.files{1} ''''   ];
    dum=cellfun(@(a){[ repmat(' ',1, length(['files = ' '{']) ) '''' a  ''' ' ]}, s.files(2:end));
    dum{end}=[dum{end} '};'];
    lg=[lg;dum];
end

if isempty(s.path)
    pathStr='[]';
else
    if length(s.path )==1
        lg{end+1,1} =[ 'mdirs = ' '{' '''' s.path{1} '''' '};'  ];
        pathStr='mdirs';
    else
        lg{end+1,1}=[ 'mdirs = ' '{' '''' s.path{1} ''''   ];
        dum=cellfun(@(a){[ repmat(' ',1, length(['mdirs = ' '{']) ) '''' a  ''' ' ]}, s.path(2:end));
        dum{end}=[dum{end} '};'];
        lg=[lg;dum];
        pathStr='mdirs';
    end
end

% params
if ~isempty(s.params)
    p=s.params;
    dum=(struct2list2(p,'pp'));
    lg=[lg;dum];
    paramsStr=',pp';
else
    paramsStr='';
end

% if ~isempty(s.params)
%     lg{end+1,1}= ['pp.resolution = [' regexprep(num2str(s.params.resolution),'\W+',' ') '];'];
%     paramsStr=',pp';
% else
%     paramsStr='';
% end


interp  =s.interp;
if length(unique(interp))==1  %same interp used for all files
    interpStr=num2str(unique(interp));
else
    lg{end+1,1}= [ 'interp = [' regexprep(num2str(interp),'\W+',' ') '];'];
    interpsStr='interp';
end


lg{end+1,1}= ['fis=doelastix(' num2str(s.direction) ', ' pathStr ',' 'files' ',' interpStr ',''local'' ', paramsStr ');'];

%
% ==============================================
%%
% ===============================================

% lg{end+1,1}= ['fis=doelastix(' num2str(s.direction) ', [],' 'files' ',' interpStr ',''local'' ', paramsStr ');'];



% if ~isempty(s.params)
%     lg{end+1,1}=...
%         ['fis=doelastix(' num2str(s.direction) ', [],' 'files' ',' num2str(s.interpx) ',''local'', pars );'];
% else
%     lg{end+1,1}=...
%         ['fis=doelastix(' num2str(s.direction) ', [],' 'files' ',' num2str(s.interpx) ',''local'');'];
%
% end

if 0 % TEST: run it
    lg
    rr=strjoin(lg,char(10))
    eval(rr)
end



try
    v = evalin('base', 'anth');
catch
    v={};
    assignin('base','anth',v);
    v = evalin('base', 'anth');
end
v=[v; lg; {'                '}];
assignin('base','anth',v);


%disp([' [f: doelastix.m]: <a href="matlab: uhelp(anth)">' 'batch' '</a>' ]);
isDesktop=usejava('desktop');
if isDesktop==1
    disp(sprintf(['[f: doelastix.m]: <a href="matlab: uhelp(anth)">' 'batch' '</a>' ]));
else
   disp('for batch see variable "anth"'); 
end









